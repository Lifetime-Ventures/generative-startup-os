# Prompts

This directory holds the system prompts that power Generative Startup OS.

## Files

- **`system-prompt.md`** — the master Custom Instructions for the founder's Claude.ai Project. Single self-contained file: paste into your Claude.ai Project's Custom Instructions field during onboarding. Contains the 5 skill definitions, pre-flight checks, schema validator, idempotency lock, and prompt injection defense.

## How to use

During onboarding (see repo root `README.md` Quickstart Path 1):

1. Open Claude.ai → New Project → name it "Generative Startup OS"
2. Open `system-prompt.md` in this directory
3. Copy everything **between the horizontal rule (line 5) and the `End of Custom Instructions content` marker** — do not include the YAML preamble or this README's pointer
4. Paste into the Project's Custom Instructions field
5. Save the Project

After install, the founder types `/okr-set` etc. in the Project's chat to invoke skills.

## Versioning

The system prompt evolves with the framework. Each ship is tagged via the repo's `CHANGELOG.md` (when re-introduced). Existing founders should:

- **Minor updates** (bug fixes, wording tweaks): re-paste the new content into their Project's Custom Instructions
- **Schema-breaking updates** (rare): wait for the corresponding `/migrate` skill (Phase 2) to migrate their Notion DB

## Contributing

Before opening a PR that modifies `system-prompt.md`:

1. Test the new prompt in your own Claude.ai Project for at least 1 cycle (`/okr-set` → `/sync-all` → `/today` → `/weekly-roast`)
2. Document the change in your PR description
3. The OSS export screening CI gate must pass (see `AGENTS.md`)

PRs that change skill behavior should include a brief description of how to verify the change works.
