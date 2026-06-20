# Schema Vocabulary — canonical status values + normalization

Single source of truth for the **values** (not just the column names) that GSOS
`status` select fields may legitimately contain, and how skills normalize them
when reading and writing.

Both the system prompt's DB schema validator (T3) at
[`prompts/system-prompt.md`](../prompts/system-prompt.md) and every `/gsos`
command reference this file. The column-level schema (which columns exist, of
what type) stays in [`notion-templates/README.md`](../notion-templates/README.md);
this file owns the **value vocabulary** layer that sits on top of it.

## Why this exists

GSOS ships a Notion template whose `status` selects use canonical lowercase
values. But founders frequently build the workspace by hand, or start from
Notion's built-in task templates, which seed **different, capitalized** option
sets. A real field session surfaced these live divergences:

- `Weekly Commitment.status` had `Not Started` / `In Progress` / `Done` — the
  template-canonical `open` did not exist, so a skill filtering on `status=open`
  matched zero rows and silently improvised a reading.
- `OKR Quarter.status` had `Not Started` / `On Track` / `At Risk` / `Done`,
  while the scoring spec referenced `behind` / `at risk` / `on track`.

The fix is one normalization layer, defined here, that both vocabularies map
into. Skills reason over the normalized **tokens** below, never over a single
hard-coded literal.

## Completion-status fields

Applies to: `Weekly Commitment.status`, `Today's Focus.status`.

| Raw value (any casing) | Normalized token | Counts as |
|---|---|---|
| `open` | `open` | incomplete |
| `Not Started` / `Not started` / `To Do` / `Todo` | `not_started` | incomplete |
| `In Progress` / `In progress` / `Doing` / `WIP` | `in_progress` | incomplete |
| `Blocked` / `On Hold` | `blocked` | incomplete |
| `Done` / `done` / `Complete` / `Completed` | `done` | **complete** |
| `Dropped` / `dropped` / `Cancelled` / `Canceled` / `Won't Do` | `dropped` | **excluded** |

**The canonical rule: 未完了 (incomplete) = any value that is NOT in the
"complete" set and NOT in the "excluded" set.** Equivalently: *incomplete =
everything except `Done`-family and `Dropped`-family.* A skill that wants
"the founder's still-open commitments" must use this rule, not a literal
`status == "open"` test.

- Template-canonical set: `open` / `done` / `dropped`
- Recognized Notion-default set: `Not Started` / `In Progress` / `Done`

## KR-status field

Applies to: `OKR Quarter.status`.

| Raw value (any casing) | Normalized token | Scoring weight |
|---|---|---|
| `behind` / `Behind` / `Off Track` | `behind` | 3 (highest urgency) |
| `at risk` / `At Risk` | `at_risk` | 2 |
| `on track` / `On Track` | `on_track` | 1 |
| `Not Started` / `not started` | `not_started` | 0 |
| `done` / `Done` / `Complete` | `done` | excluded from urgency boost |

`/today` scores Weekly Commitments partly by their related KR's normalized
token: `behind` > `at_risk` > `on_track` > `not_started`. A `done` KR contributes
no urgency. Skills MUST resolve the raw value to a token via this table before
applying weights — never compare against a single literal.

- Template-canonical set: `on track` / `at risk` / `behind` / `done`
- Recognized Notion-default set: `Not Started` / `On Track` / `At Risk` / `Done`

## Validation contract (used by the T3 DB validator)

When a skill reads a `status` field, classify every option value the field
actually carries:

1. **All observed values map to a token** in the relevant table above (whether
   from the canonical set or a recognized default set) → **proceed**, reasoning
   over normalized tokens. This is the common case and needs no founder action.
2. **At least one observed value maps to NO token** → the field has been
   customized in a way the skills cannot interpret. **Abort** with the explicit
   message in [`docs/error-rescue-map.md`](./error-rescue-map.md) (value-vocab
   mismatch row): name the DB, the field, the unrecognized value, and both
   accepted sets. Do not silently improvise a reading.

## Normalization is read-side; writes preserve the founder's vocabulary

Normalization happens **on read**, for filtering and scoring. When a skill
**writes** a `status` value (e.g. `/today` setting a Today's Focus row, or
`/sync-all` creating a Weekly Commitment), it must write a value that already
exists in the founder's select options:

- Detect the founder's existing option set for that field.
- If the founder uses the Notion-default set, write `Not Started` (or the
  appropriate default-set member), not the canonical `open`.
- For a fresh template-canonical DB, write the canonical value.

Never silently rewrite or add select options on the founder's DB — that is a
schema change the founder did not request. The single exception is the explicit
`/migrate` skill (Phase 2), which changes schema only with founder confirmation.

## Confidence fields

Applies to: `OKR Quarter.confidence`, `Decisions Log.confidence` /
`classification_confidence`. Skill prose says things like "decisions with
`confidence >= 7`", which assumes a 1–10 numeric scale — but real workspaces
carry **three different confidence encodings**. Resolve to the boolean
`high_confidence` token below; never compare the raw value to `7` directly.

| DB / field | Encoding | `high_confidence` (the "≥7 equivalent") |
|---|---|---|
| `OKR Quarter.confidence` (template-canonical) | select `1-3` / `4-6` / `7-10` | `7-10` |
| `OKR Quarter.confidence` (recognized variant) | select `High` / `Medium` / `Low` | `High` |
| `Decisions Log.confidence` (template-canonical) | select `1-3` / `4-6` / `7-10` | `7-10` |
| `Decisions Log.classification_confidence` (variant, `/sync-all`-derived) | float `0–1` (Layer-1 hit = `1.0`) | `>= 0.9` |

So "high-confidence decisions" = `confidence` in `7-10` **OR** select `High`
**OR** `classification_confidence >= 0.9`. A skill's confidence threshold MUST
branch on the field's encoding (detect select vs. float vs. canonical) and apply
the matching rule from this table. Mapping `Medium`/`Low` or `4-6`/`1-3` or
floats `< 0.9` → not high-confidence.

## Decisions Log field mapping

Applies to: `Decisions Log`. The template-canonical schema and a recognized
variant schema (created by a different decisions-extraction path, observed as
`/sync-all`-derived) carry the same information under different column names.
Map the variant to canonical on read:

| Variant column | Canonical column | Meaning |
|---|---|---|
| `D-ID` | `D_ID` | decision identifier |
| `The Trade-off` | `alternatives_considered` | alternatives / trade-off |
| `Assumption` | `rationale` | rationale / underlying assumption |
| `classification_confidence` (0–1) | `confidence` | confidence (via the table above) |
| `Decision Type` | — (no canonical equivalent) | variant-only metadata; read-only, ignore for the draft |
| `Status` | — (no canonical equivalent) | variant-only metadata; read-only, ignore for the draft |

**Validation contract (T3, Decisions Log).** When the canonical columns are
absent but a recognized variant is detected, **apply this mapping automatically**
and proceed — do not ask the founder per row. Only **unmapped / unrecognized**
required information (e.g. neither `rationale` nor `Assumption` present) raises a
single founder confirmation. Variant-only columns with no canonical equivalent
are read-only and excluded from the investor draft.

---

*Generative Startup OS — Schema Vocabulary v0.1, 2026-06-20*
