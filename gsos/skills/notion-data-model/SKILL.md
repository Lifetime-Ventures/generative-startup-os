---
name: notion-data-model
description: Notion workspace schema (6 DBs + Mission page) that GSOS reads from and writes to. Includes schema_version, idempotency lock, and DB validator rules.
---

The full Notion data model (databases, columns, schema_version conventions, idempotency lock, DB validator) is defined in [notion-templates/README.md](../../../notion-templates/README.md) and the "Architecture you operate against" section of [prompts/system-prompt.md](../../../prompts/system-prompt.md).

When a /gsos command needs to read or write Notion:

- Validate column names against the documented schema before any write.
- Include `schema_version: 1`, `created_by_skill: <skill-name>` on every row created.
- Respect the `lock_token` idempotency contract on the Mission page metadata.
- User-added columns prefixed `_user_*` are read-only — never write to them.

If the founder's DB diverges from the documented schema, abort with: "Notion DB `[name]` is missing column `[X]`. Either re-duplicate the template, or rename your column back to `[X]`. (Custom columns must be prefixed `_user_*`.)"
