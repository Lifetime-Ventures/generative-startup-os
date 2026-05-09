# gsos-power

> **⚠️ Claude Code only** — hooks and local MCP servers do not activate in Cowork. If you install this in Cowork, components will be silently inactive (or rejected at install time, depending on Cowork's behavior — verified during the v1.0 Step 0 implementation gate).

Power-user extras for [`gsos`](../gsos). Adds local MCP server setup automation for Notion, plus a SessionStart hook that caches connector health.

## What this plugin adds

| Component | Type | Purpose |
|---|---|---|
| `/gsos-power:setup-mcp` | Slash command | Installs the Notion local MCP server binary into `${CLAUDE_PLUGIN_DATA}` and configures Claude Code to use it. Aborts if invoked from Cowork. |
| `hooks/scripts/pre-skill-connector-check.sh` | SessionStart hook | Lightweight session marker; result cached 24h in `${CLAUDE_PLUGIN_DATA}/connector-health.json` so /gsos:* skills do not re-check connectors per invocation. |
| `.mcp.json` | MCP server config | Notion local MCP server (binary installed by `/gsos-power:setup-mcp`). |

## Why "Code only"

This plugin's `hooks` and `mcpServers` declarations target Claude Code's runtime. Cowork's plugin sandbox does not currently support local MCP server execution outside the Anthropic Connector framework. If you install this in Cowork:

- The hook will not fire (Cowork does not execute SessionStart hooks for plugins).
- The MCP server will not start (Cowork's MCP integration is mediated by Anthropic Connectors, not user-bundled MCPs).
- The `/gsos-power:setup-mcp` command will print an abort message and exit.

If you want the Notion experience in Cowork, just install `gsos` — the Anthropic Notion **Connector** covers the same workflows over the cloud-mediated path.

## Install (Claude Code only)

```bash
claude plugin marketplace add Lifetime-Ventures/generative-startup-os
claude plugin install gsos-power@generative-startup-os
# /gsos-power:setup-mcp
```

The plugin declares `dependencies: [{name: "gsos", version: "~1.0.0"}]` in `.claude-plugin/plugin.json`. If you have not installed `gsos` first, the marketplace should resolve it automatically; if not, `claude plugin install gsos@generative-startup-os` first.

## Roadmap

- v1.1: `/gsos-power:peer-audit`, `/gsos-power:board-prep` (deferred from v0 reset, see `TODOS.md`)
- v1.1: Sub-agent extraction (action-extractor, drift-detector) for `gsos` workflows
- v1.x: Windows / Linux platform verification for `/setup-mcp`

## License

Apache License 2.0 — see [../LICENSE](../LICENSE) and [../NOTICE](../NOTICE).
