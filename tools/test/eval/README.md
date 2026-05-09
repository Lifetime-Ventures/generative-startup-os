# tools/test/eval/

Evaluation artifacts for GSOS. Currently scoped to **prompt regression** between v0 paste-flow and v1.x plugin marketplace.

## Files

- **`regression-diff-2026-05-09.md`** — static text diff between `prompts/system-prompt.md` (v0) and the `gsos/`-tree (v1.0.x). Catches dropped or paraphrased rescue logic. See the file for the full mapping table and the 4 HIGH-priority drops surfaced.

## Future contents (planned, not yet present)

- `fixtures/` — anonymized founder transcripts (Tier 3 only, AGENTS.md compliant) for behavioral regression tests
- `baselines/<date>-paste-flow/` — captured v0 paste-flow outputs against fixtures, for comparison after the v1.2 paste-flow deletion
- `baselines/<date>-plugin/` — captured v1.x plugin outputs against the same fixtures

## Why this directory exists

`/plan-eng-review` flagged a "silent prompt regression" Iron Rule at the v1.0 ship: skill split could drop hidden rescue logic without surfacing any test failure. The full LLM-driven baseline (run paste-flow on a fixture, capture output, run plugin on same fixture, compare) requires a real Claude.ai Project + Notion test workspace + Connector OAuth, which can only be done by the maintainer. The static diff in this directory is the autonomous-completable subset and was produced first.

The behavioral baseline is still recommended before v1.2 deletes `prompts/system-prompt.md` (only window for paste-flow capture). See `regression-diff-2026-05-09.md` § "Methodology caveats" for what static diff misses.
