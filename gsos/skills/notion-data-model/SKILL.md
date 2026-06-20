---
name: notion-data-model
description: Notion workspace schema (6 DBs + Mission page) that GSOS reads from and writes to. Includes schema_version, idempotency lock, and DB validator rules.
---

The full Notion data model (databases, columns, schema_version conventions, idempotency lock, DB validator) is defined in [notion-templates/README.md](../../../notion-templates/README.md) and the "Architecture you operate against" section of [prompts/system-prompt.md](../../../prompts/system-prompt.md).

When a /gsos command needs to read or write Notion:

- Prefer `query_database_view` for reads. SQL (`query_data_sources`) requires an Enterprise plan with Notion AI; use it only as an optional optimization and fall back to the view query on a 400 / permission error.
- Validate column names against the documented schema before any write.
- Validate `status` **value vocabulary** against [schema-vocab](../../../docs/schema-vocab.md). Reason over the normalized tokens defined there — never compare a status field to a single literal such as `open`. "Incomplete" = not in the Done-family and not in the Dropped-family.
- Include `schema_version: 1`, `created_by_skill: <skill-name>` on every row created.
- Respect the `lock_token` idempotency contract on the Mission page metadata.
- User-added columns prefixed `_user_*` are read-only — never write to them.
- When writing a `status`, use a value that already exists in the founder's option set (do not silently add or rewrite options).

If the founder's DB diverges from the documented schema, abort with: "Notion DB `[name]` is missing column `[X]`. Either re-duplicate the template, or rename your column back to `[X]`. (Custom columns must be prefixed `_user_*`.)" If a `status` value maps to no token in [schema-vocab](../../../docs/schema-vocab.md), abort with the value-vocab mismatch message instead; if all values map (e.g. `Not Started` / `In Progress` / `Done`), normalize and proceed.
