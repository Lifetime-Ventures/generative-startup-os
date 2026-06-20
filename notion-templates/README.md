# Notion Templates

The 6-database + 1-page Notion workspace structure that backs Generative Startup OS. The founder duplicates this into their own Notion workspace during onboarding (per repo `README.md` Quickstart Path 1 step 1).

## Status

The public Notion template URL is not yet published. This directory documents the schema in markdown so a maintainer (or curious founder) can rebuild it manually. Once the public template is live, the URL will be added to the root `README.md` step 1.

To build the template manually in Notion:

1. Create a new page in a private Notion workspace
2. Title: "Generative Startup OS Workspace"
3. Add the [Notion "Home" page IA](#notion-home-page-ia) layout described below
4. Inside, create the 7 databases listed in [DB schemas](#db-schemas), one at a time

When published as a public Notion template, founders click 1 link → "Duplicate" → done in 30 seconds.

## Notion "Home" page IA

The single most important UX decision: when the founder opens Notion on Monday morning, what do they see first?

The Home page (= the page you duplicate) renders **3 linked database views in this order**:

```
┌────────────────────────────────────────────────────────────────┐
│  Generative Startup OS Workspace                               │
│  ─────────────────────────────────────────────────────────────  │
│                                                                │
│  ## Quick actions                                              │
│  Type these in your Claude.ai Project chat:                    │
│  • /okr-set       — initial setup or quarterly rollover         │
│  • /sync-all      — daily morning, ingest yesterday's meetings  │
│  • /today         — daily morning, pick 1-3 actions             │
│  • /weekly-roast  — Friday afternoon, week reflection           │
│  • /investor-update — month start, draft monthly update          │
│                                                                │
│  ## Today's Focus  ← top of page, founder's first glance        │
│  [linked DB view: Today's Focus filtered by date = today]      │
│                                                                │
│  ## This Week's Commitments                                    │
│  [linked DB view: Weekly Commitment filtered by current ISO    │
│   week, sorted by KR status (behind > at risk > on track)]     │
│                                                                │
│  ## OKR Quarter progress                                       │
│  [linked DB view: OKR Quarter, current quarter only,           │
│   showing KR_id / KR_text / current_value / target_metric /    │
│   status]                                                      │
│                                                                │
│  ─────────────────────────────────────────────────────────────  │
│  → Mission & Strategy (collapsed link)                         │
│  → Meeting Notes / Investor Updates / Decisions Log            │
│    (collapsed links to subpages)                               │
└────────────────────────────────────────────────────────────────┘
```

**Why this order**: Monday-morning drift is the founder's actual pain. Today's Focus must be visible without scrolling. Mission and reference databases can be one click away — they don't need to fight for screen real estate.

**Quick actions block at top**: founders forget skill names. Putting them at the top of Notion means whenever the founder opens Notion to check something, they re-see the skill catalog. Reduces cognitive load — they don't have to remember `/sync-all` vs `/syncall` vs `/sync`.

## DB schemas

All databases include 3 standard properties (do not omit):

- `schema_version` — number, default `1`. Used by `/migrate` skill (Phase 2) for schema upgrades.
- `created_by_skill` — text. Records which skill created the row (helps debugging).
- `last_modified_at` — Notion built-in `last_edited_time`. Used by skills for change detection and by opt-in telemetry to count active usage.

User-added properties: prefix with `_user_*` (e.g., `_user_priority`, `_user_notes`). Skills read these but never write to them.

**Status value vocabulary.** The `status` select options below are the
template-canonical values. Founders who build the workspace by hand or start
from a Notion task template often have the **capitalized Notion-default** sets
instead (`Not Started` / `In Progress` / `Done` for completion fields;
`Not Started` / `On Track` / `At Risk` / `Done` for KR status). Both are
supported: skills normalize either set to internal tokens per
[`docs/schema-vocab.md`](../docs/schema-vocab.md), where "incomplete" is defined
as *not in the Done-family and not in the Dropped-family* — not a literal `open`.
A status value that maps to no recognized token triggers the value-vocab mismatch
abort (`docs/error-rescue-map.md`). You do **not** need to rename Notion's
default options to the canonical lowercase set.

**Confidence encodings.** The `confidence` property (OKR Quarter, Decisions Log)
also varies across real workspaces — numeric `7-10` selects, `High` / `Medium` /
`Low` selects, and a `0–1` float `classification_confidence` (`/sync-all`-derived
Decisions Log) all appear in the wild. Skills resolve each to a single
`high_confidence` token (`7-10` OR `High` OR `>= 0.9`) rather than comparing to a
raw `7`. The authoritative confidence-encoding table is in
[`docs/schema-vocab.md`](../docs/schema-vocab.md).

**Decisions Log schema variants.** A recognized variant Decisions Log
(`D-ID` / `The Trade-off` / `Assumption` / `Decision Type` / `Status` /
`classification_confidence`) is mapped to the canonical columns automatically per
the Decisions Log field-mapping table in
[`docs/schema-vocab.md`](../docs/schema-vocab.md) — you do not need to rebuild it
to the canonical column names.

### Mission & Strategy (page, not DB)

A single page with 5 H1 sections + metadata:

```
# Mission
{2-3 sentences in the founder's own voice}

# Thesis
{Why now, why us, why this market}

# Target user
{Specific human, not category}

# Wedge
{Narrowest version someone would pay for this week}

# 5-year vision
{How does the world look different in 2031?}

---

Metadata (page properties — set via the "Add a property" button at top of the page):
- meeting_source: select (circleback / granola_zapier / granola_enterprise) — controls /sync-all path
- today_weekend: checkbox (default off) — overrides /today weekend skip
- lock_token: text (managed by /okr-set, do not set manually)
- committed_meeting_ids: text (managed by /sync-all retry logic)
- last_revised: date
- revision_count: number
```

The `/okr-set` skill writes the 5 H1 section bodies. Founder edits freely. Properties are managed by skills (founder shouldn't touch `lock_token` or `committed_meeting_ids`).

### OKR Quarter

| Property | Type | Required | Notes |
|---|---|---|---|
| `Quarter` | select | yes | Options: `2026 Q2`, `2026 Q3`, `2026 Q4`, `2027 Q1`, ... add as needed |
| `Objective` | rich text | yes | 1 Objective per Quarter (or skip — KRs can stand alone) |
| `KR_id` | formula | yes | `"KR" + index` — sortable, stable identifier |
| `KR_text` | rich text | yes | 1-line KR description |
| `target_metric` | text | yes | "30 investor meetings" or "ARR target" or "5 pilot customers signed" — the number you're aiming at |
| `current_value` | text | no | Founder updates manually or `/weekly-roast` proposes update |
| `status` | select | yes | `on track` / `at risk` / `behind` / `done` |
| `confidence` | select | yes | `1-3` / `4-6` / `7-10` |
| `linked_PRRs` | relation | no | → Weekly Commitment DB |
| `linked_decisions` | relation | no | → Decisions Log DB |
| `schema_version` | number | yes | default `1` |
| `created_by_skill` | text | yes | `/okr-set` typically |
| `last_modified_at` | last_edited_time | yes | auto |

### Weekly Commitment / PRR

| Property | Type | Required | Notes |
|---|---|---|---|
| `Week` | text | yes | `2026-W18` (ISO week format) |
| `title` | title | yes | Action-oriented: "Schedule 3 customer interviews" or "Ship checkout fix" |
| `related_KR` | relation | yes | → OKR Quarter DB. Required — commitments without KR linkage trigger drift detection in `/weekly-roast` |
| `source` | select | yes | `founder` / `weekly-roast` / `from_meeting` |
| `source_meeting` | relation | no | → Meeting Notes DB. Set when source = `from_meeting` |
| `status` | select | yes | `open` / `done` / `dropped` |
| `due` | date | no | Self-imposed deadline |
| `done_at` | date | no | When status flipped to `done` |
| `reflection` | rich text | no | Founder writes during `/weekly-roast` |
| `schema_version` | number | yes | default `1` |
| `created_by_skill` | text | yes | `/okr-set` / `/sync-all` / `/weekly-roast` / `manual` |
| `last_modified_at` | last_edited_time | yes | auto |

### Today's Focus

| Property | Type | Required | Notes |
|---|---|---|---|
| `date` | date | yes | The day this row applies to |
| `title` | title | yes | Mirrors the Weekly Commitment it derives from |
| `related_PRR` | relation | yes | → Weekly Commitment DB. Required — Today's Focus is always a child of a weekly commitment |
| `status` | select | yes | `open` / `done` |
| `generated_by` | select | yes | `/today` / `manual` |
| `time_block` | text | no | "9:00-11:00" — for optional Calendar block creation |
| `schema_version` | number | yes | default `1` |
| `created_by_skill` | text | yes | `/today` typically |
| `last_modified_at` | last_edited_time | yes | auto |

### Meeting Notes

| Property | Type | Required | Notes |
|---|---|---|---|
| `date` | date | yes | The meeting date |
| `title` | title | yes | Meeting subject (from Circleback / Granola) |
| `attendees` | multi-select or text | no | Names of meeting participants |
| `type` | select | yes | `investor` / `customer` / `co-founder candidate` / `team` / `advisor` / `other` |
| `raw_transcript_url` | URL | no | Link to full transcript in Circleback/Granola |
| `summary` | rich text | no | AI-generated 1-3 paragraph summary |
| `extracted_actions` | rich text | no | AI-extracted action items, raw |
| `related_KR` | relation | no | → OKR Quarter DB |
| `mentioned_decisions` | relation | no | → Decisions Log DB |
| `status` | select | no | `pending_review` / `reviewed` (used by `/sync-all` for incremental processing) |
| `schema_version` | number | yes | default `1` |
| `created_by_skill` | text | yes | `/sync-all` typically |
| `last_modified_at` | last_edited_time | yes | auto |

### Investor Updates

| Property | Type | Required | Notes |
|---|---|---|---|
| `month` | text | yes | `2026-05` |
| `audience` | select | yes | `all LPs` / `lead VC` / `specific LP` / `public` |
| `draft_url` | URL | no | Google Doc link |
| `highlights` | rich text | no | Wins, KR done |
| `asks` | rich text | no | Intros, hires, resources |
| `linked_KRs` | relation | no | → OKR Quarter DB |
| `generated_at` | date | yes | When `/investor-update` ran |
| `sent_at` | date | no | When founder actually sent it. Empty = unsent |
| `schema_version` | number | yes | default `1` |
| `created_by_skill` | text | yes | `/investor-update` |
| `last_modified_at` | last_edited_time | yes | auto |

### Decisions Log

| Property | Type | Required | Notes |
|---|---|---|---|
| `D_ID` | formula | yes | `"D-" + zfill(index, 3)` → `D-001`, `D-002`, ... |
| `date` | date | yes | When the decision was made |
| `decision` | title | yes | "Raise seed to $1M, not $500K" |
| `alternatives_considered` | rich text | no | What other options were on the table |
| `rationale` | rich text | no | Why this decision |
| `impact_KR` | relation | no | → OKR Quarter DB |
| `source_meeting` | relation | no | → Meeting Notes DB. If decision came from a specific meeting |
| `confidence` | select | yes | `1-3` / `4-6` / `7-10` |
| `revisit_date` | date | no | When to re-evaluate |
| `schema_version` | number | yes | default `1` |
| `created_by_skill` | text | yes | `manual` (Phase 1) or `/decision` (Phase 2) |
| `last_modified_at` | last_edited_time | yes | auto |

## Relations checklist

When building manually in Notion, set these relations after all 7 databases exist:

| Source | Property | Target |
|---|---|---|
| OKR Quarter | `linked_PRRs` | Weekly Commitment |
| OKR Quarter | `linked_decisions` | Decisions Log |
| Weekly Commitment | `related_KR` | OKR Quarter |
| Weekly Commitment | `source_meeting` | Meeting Notes |
| Today's Focus | `related_PRR` | Weekly Commitment |
| Meeting Notes | `related_KR` | OKR Quarter |
| Meeting Notes | `mentioned_decisions` | Decisions Log |
| Investor Updates | `linked_KRs` | OKR Quarter |
| Decisions Log | `impact_KR` | OKR Quarter |
| Decisions Log | `source_meeting` | Meeting Notes |

## Customization rules

When the founder customizes the schema (adds columns, changes views, renames pages):

- **Add new columns**: prefix with `_user_*` (e.g., `_user_priority`). Skills will read but never write to them. They survive `/migrate`.
- **Rename a required column** (e.g., `related_KR` → `kr_link`): skills will detect via the DB schema validator (see `docs/error-rescue-map.md` row 8) and abort with a repair message. To customize, add a new `_user_*` column instead and copy data.
- **Delete a required column**: same as rename — skills will abort. Re-duplicate the template if you need a fresh start.
- **Add new views**: free-for-all. Skills don't depend on view configurations.

The 6-DB + Mission page schema is **frozen for the first 90 days post-launch**. Schema-breaking changes (rename, delete, type-change of required columns) are deferred to v2 with a `/migrate` skill (Phase 2).

## Phase 2 expansion candidates

- Public Notion template URL published — 1-click duplicate for founders (replaces this manual build doc as the primary path)
- Per-DB Notion view recommendations (e.g., calendar view for Today's Focus, gallery view for Investor Updates)
- Bilingual property names (English / Japanese) — currently English only
- `/migrate` skill spec — automates schema upgrades for existing founders without breaking their data

---

*Generative Startup OS — Notion Templates v0.1, 2026-05-03*
