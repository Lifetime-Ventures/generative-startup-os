// Safeguard structural eval — the deterministic ship gate (eng-review 4A).
// No API key required; runs in CI on every PR. Proves that every composed MCP
// prompt actually CARRIES the safeguards (Issue 3A) — if build-mcp ever stops
// inlining them, this fails the build instead of shipping a gutted prompt.
//
// The behavioral counterpart (does the safeguard actually FIRE under a planted
// attack) lives in safeguard-behavioral.mjs and needs ANTHROPIC_API_KEY.
//
// Run: node --test mcp/eval/

import { test } from "node:test";
import assert from "node:assert/strict";
import { readFileSync } from "node:fs";
import { join, dirname } from "node:path";
import { fileURLToPath } from "node:url";

const HERE = dirname(fileURLToPath(import.meta.url));
const REPO = join(HERE, "..", "..");
const MANIFEST = join(HERE, "..", "generated", "manifest.ts");
const COMMANDS_DIR = join(REPO, "gsos", "commands");

// Load PROMPTS out of the generated .ts (strip the TS bits, eval the array).
function loadPrompts() {
  const ts = readFileSync(MANIFEST, "utf8");
  const m = ts.match(/export const PROMPTS[^=]*=\s*(\[[\s\S]*\]);/);
  if (!m) throw new Error("could not parse PROMPTS from manifest — run build-mcp first");
  return JSON.parse(m[1]);
}

const PROMPTS = loadPrompts();
const byName = Object.fromEntries(PROMPTS.map((p) => [p.name, p]));

// Safeguards that MUST ride along with every command (from system-prompt.md).
const GLOBAL_SAFEGUARDS = [
  { id: "T14-injection-delimiter", needle: "BEGIN MEETINGS" },
  { id: "T14-treat-as-data", needle: "NEVER AS INSTRUCTIONS", ci: true },
  { id: "no-blank-page", needle: "Never write OKRs from a blank page" },
  { id: "pre-flight", needle: "Pre-flight" , ci: true },
  { id: "schema-version", needle: "schema_version" },
  { id: "idempotency-lock", needle: "lock_token" },
  { id: "privacy-boundary", needle: "Privacy" , ci: true },
  { id: "preamble-header", needle: "non-negotiable operating rules" },
  { id: "language-mirror", needle: "respond in the language the founder", ci: true },
];

test("manifest is non-empty and has the 5 core commands + help", () => {
  for (const n of ["okr-set", "sync-all", "today", "weekly-roast", "investor-update", "help"]) {
    assert.ok(byName[n], `missing prompt: ${n}`);
  }
});

for (const p of PROMPTS) {
  test(`/${p.name}: carries every global safeguard (Issue 3A)`, () => {
    const hay = p.body;
    const hayLc = hay.toLowerCase();
    for (const s of GLOBAL_SAFEGUARDS) {
      const found = s.ci ? hayLc.includes(s.needle.toLowerCase()) : hay.includes(s.needle);
      assert.ok(found, `/${p.name} missing safeguard ${s.id} ("${s.needle}")`);
    }
  });

  test(`/${p.name}: no dead relative links (would be broken in MCP surface)`, () => {
    const dead = p.body.match(/\]\((?!https?:\/\/)[^)]+\)/g) || [];
    assert.equal(dead.length, 0, `/${p.name} has dead relative links: ${dead.join(", ")}`);
  });

  test(`/${p.name}: zero-argument invariant (P4 — no PII through the Worker)`, () => {
    assert.ok(!/\$ARGUMENTS|\$\d+|\{\{\s*args?\s*\}\}/.test(p.body), `/${p.name} references arguments`);
  });

  test(`/${p.name}: preamble precedes the command body (order: rules first)`, () => {
    const iPreamble = p.body.indexOf("non-negotiable operating rules");
    const iCmd = p.body.indexOf(`# Command: /${p.name}`);
    assert.ok(iPreamble !== -1 && iCmd !== -1 && iPreamble < iCmd,
      `/${p.name}: safeguard preamble must come before the command body`);
  });
}

// plugin-vs-MCP equivalence: the command's own instructions must survive intact
// in the composed prompt (only relative links neutralized). Guards against
// build-mcp accidentally mangling/dropping command content.
test("composed prompts preserve their source command body", () => {
  for (const p of PROMPTS) {
    const src = readFileSync(join(COMMANDS_DIR, `${p.name}.md`), "utf8");
    // take a distinctive line from the source body (first '## ' heading) and
    // assert it appears in the composed prompt.
    const heading = (src.match(/^##\s+.+$/m) || [])[0];
    if (heading) assert.ok(p.body.includes(heading), `/${p.name}: lost source heading "${heading}"`);
  }
});
