# GSOS MCP server

A no-auth, remote MCP server that lets a non-engineer founder use Generative
Startup OS from **Claude Desktop / Claude.ai** by adding **one custom-connector
URL** — instead of installing the plugin from GitHub.

It serves the GSOS commands as MCP **prompts** plus an onboarding-conductor
**tool**. It is a stateless **prompt-CDN**: it returns only public methodology
text. No founder data or credentials pass through it — those flow through the
founder's own Anthropic Notion / Google / Circleback connectors. Every prompt and
tool is **zero-argument**, so no PII can transit the Worker.

## How it works

```
gsos/commands/*.md   (canonical command bodies, pure-prompt)
prompts/system-prompt.md  (canonical safeguards: injection T14, idempotency T4,
        │                  schema-validate T3, pre-flight, tone, privacy)
        │  node scripts/build-mcp.mjs
        ▼
mcp/generated/manifest.ts  (each command = safeguard preamble + command body,
        │                   dead relative links neutralized, zero-arg enforced)
        │  bundled into the Worker (NO runtime fetch)
        ▼
Cloudflare Worker (McpAgent, Streamable HTTP, no-auth)  ──connector URL──▶  Claude
   prompts: okr-set / sync-all / today / weekly-roast / investor-update / help
   tools:   start_onboarding (conductor) / ping (health)
```

**Why compose the safeguard preamble (build-mcp):** in the plugin runtime the
commands reference shared safeguards by relative link and Claude Code loads
`CLAUDE.md`. As a bare MCP prompt those links are dead and there is no `CLAUDE.md`
in context — so build-mcp inlines the safeguards from `prompts/system-prompt.md`
in front of every command. Without this the MCP path would be silently less safe
than the plugin (transcript injection, fabricated OKRs, silent failures).

## Develop

```bash
cd mcp
npm install
npm run build      # regenerate generated/manifest.ts
npm test           # build + structural safeguard gate (+ behavioral if key set)
npm run check      # dry-run compile the Worker
```

## Deploy

```bash
npx wrangler login           # one-time, browser
npm run deploy               # build + wrangler deploy
# optional: publish the Notion template URL surfaced by start_onboarding
#   set NOTION_TEMPLATE_URL in wrangler.toml [vars] or via dashboard
```
Endpoint after deploy: `https://<worker>.workers.dev/mcp`. Add that URL in Claude
Settings → Connectors → Add custom connector (OAuth fields left empty = no-auth).

> **Commands live in the `+` menu**, not by typing their name in chat. This is
> easy to miss — `start_onboarding` tells founders where to find them.

## Safeguard eval (ship gate)

- `eval/safeguard-structural.test.mjs` — deterministic, no key, runs in CI.
  Proves every composed prompt carries every safeguard (Issue 3A), has no dead
  links, is zero-arg, and preserves its source command body.
- `eval/safeguard-behavioral.mjs` — needs `ANTHROPIC_API_KEY`. Drives each
  command with planted adversarial / blank-page / outbound input and checks the
  safeguard fires. Skips cleanly without a key.

## Status & staging

- **Stage 0 (spike)** — DONE / GREEN (2026-06-20). No-auth native connector add
  works on Claude.ai; prompts surface in the `+` menu; tools surface directly.
- **Stage 1 (this dir)** — real commands + safeguard composition + conductor.
  Validated end-to-end on real content (okr-set ran with pre-flight). Ship gate
  to a real founder = behavioral eval green + a solo-Pro founder confirms native
  connector add on their own account.
- **Stage 2 (later)** — CI auto-deploy, stable/latest prompt versioning,
  WAF/rate-limit, health/fallback UX. The plugin path stays for power/Code users;
  this MCP is the non-engineer front door (added channel, not a replacement).

## Architecture notes

- McpAgent (Durable Objects) was kept after the spike proved it renders prompts +
  tools in Claude.ai. Stateless `createMcpHandler` is a later optimization, not
  load-bearing at low founder volume.
- Deploy only from screened `main`: the OSS export screening CI gates merge, so
  served content is always Tier-3 public.
