# Contributing to Generative Startup OS

Thank you for your interest in contributing. GSOS is an open-source project and welcomes contributions from the community.

---

## Ways to Contribute

- **Bug reports**: Found something that doesn't work as described? [Open an issue](../../issues/new?template=bug_report.md)
- **Feature requests**: Have an idea for a new command or improvement? [Open a discussion](../../discussions/new)
- **Documentation**: Improve README, setup guides, or command documentation
- **New commands**: Propose or implement new `.claude/commands/` files
- **Translations**: Help translate the setup guide to other languages

---

## Getting Started

1. Fork this repository and clone your fork
2. Create a branch: `git checkout -b feat/your-feature-name`
3. Make your changes
4. Test your changes against a real Claude Code session if possible
5. Commit with a clear message: `git commit -m "feat: add /your-command command"`
6. Push and open a Pull Request

---

## Contribution Guidelines

### For new commands (`.claude/commands/`)

- Follow the existing file structure: Purpose → When to Use → Input → Process → Output Format → Limitations
- Commands should work for **any** deep tech startup, not a specific organization
- Do not include hardcoded Notion page IDs, organization names, or API keys
- Phase labels (`Phase: 1以降`, `Phase: 2以降`) are required
- Japanese is the primary language for command files (English comments welcome)

### For documentation changes

- Keep setup instructions accurate for the current version of Claude Code
- Verify any npm package names before adding them
- Flag anything that might be platform-specific (Mac/Windows/Linux)

### For PRR / DB schema changes

- Changes to the PRR formula or Notion DB schema affect all users — please open a discussion first
- Include a migration path for existing users if schemas change

---

## What We Won't Accept

- Hardcoded credentials, API keys, or organization-specific configurations
- VC-specific workflows (LP management, IC rules, fund accounting) — these belong in private forks
- Changes that break backward compatibility without a documented migration path

---

## Reporting Security Issues

**Do not open a public issue for security vulnerabilities.**
Please email the maintainers directly or use [GitHub's private vulnerability reporting](../../security/advisories/new).

---

## Code of Conduct

This project follows the [Contributor Covenant Code of Conduct](CODE_OF_CONDUCT.md).
By participating, you agree to uphold this standard.

---

## Questions?

Open a [GitHub Discussion](../../discussions) — we're happy to help.
