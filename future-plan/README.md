# future-plan/ — Materials Archive for v2 Schema and Phase 2+ Planning

This directory holds **design materials** generated during pre-reset exploration (April–May 2026), curated for selective use in future product decisions.

> **For users running Generative Startup OS today**: ignore this directory. The current product is v0.1.0, defined by the root-level `CLAUDE.md`, `README.md`, `prompts/system-prompt.md`, and `notion-templates/README.md`. None of the contents below describe v0.1.0 behavior.
>
> **For contributors and Kimura**: this directory is the materials archive for v2 schema design (target: post-90-day schema unfreeze, ~August 2026 minimum) and Phase 2+ feature exploration. It is curated as cherry-pick candidates, not as an alternative product.

---

## Status

- **Authority**: v0.1.0 is the official direction. Files in this directory are **non-authoritative** drafts.
- **Sanitization**: All content here passes the AGENTS.md trust boundary (no Tier 0/1/2 leaks).
- **Maturity**: Mixed. `ideas/` files are detailed and cherry-pick-ready. Other subdirectories are deeper context.

---

## Directory layout

```
future-plan/
├── README.md                                  ← you are here
│
├── ideas/                                     ← cherry-pick candidates (the valuable part)
│   ├── tasks-2axis-delay.md
│   ├── decisions-6-categories.md
│   ├── orgs-deeptech-stages.md
│   ├── inbox-channel-sourcetype.md
│   ├── extended-skill-catalog.md
│   └── 3-environment-model.md
│
├── notion-templates-9db-draft/                ← integrated 9-DB schema (where ideas above came from)
│   └── db-schemas.md
│
├── automation-stack-options/                  ← Make.com vs Zapier vs n8n + 5 Blueprint specs
│   ├── README.md
│   └── make-blueprints/
│       ├── README.md
│       ├── gmail-to-inbox.json
│       ├── voicememo-to-inbox.json
│       ├── calendar-to-tasks.json
│       ├── inbox-ai-filter.json
│       └── weekly-roast-trigger.json
│
└── mobile-patterns/                           ← deeper mobile workflow guides
    ├── README.md
    ├── ios-setup.md
    ├── android-setup.md
    └── apple-shortcuts.md
```

---

## What's in `ideas/` (the valuable part)

Each idea file follows a consistent structure:

```
# Idea: <title>
## Status (origin / maturity / conflict with v0.1.0)
## Problem in v0.1.0 schema
## Proposed change
## Trade-offs
## v2 PR sketch
## Open questions for hearing batch
```

This format makes each idea independently mergeable as a focused v2 PR when the schema unfreeze ends (90 days post-launch, ~August 2026 minimum).

**The 6 ideas currently in this directory:**

1. **Tasks 2-axis delay tracking** (`tasks-2axis-delay.md`)
   Split slip causes into self-caused vs external. Honest reliability metric for deep tech.

2. **Decisions Type 6 categories** (`decisions-6-categories.md`)
   Promote IP to first-class decision type, alongside Strategic / People / Technical / Partnership / Governance.

3. **Organizations DB with deep-tech Stage vocabulary** (`orgs-deeptech-stages.md`)
   First Contact / Pain Validated / PoC In Progress / Contracted / Walked Away — replaces SaaS funnel terms.

4. **Inbox DB with Channel + Source Type 2-axis** (`inbox-channel-sourcetype.md`)
   Phase 2+ unified inbox concept with semantic + technical source separation.

5. **Extended skill catalog** (`extended-skill-catalog.md`)
   13 skills beyond v0.1.0's 5. Highlights `/quick-board` as the strongest Phase 2 candidate.

6. **3-environment model** (`3-environment-model.md`)
   Why pre-reset's Foundation/Connected/Automated framing didn't survive, what's reusable.

---

## What's in `notion-templates-9db-draft/`

The integrated 9-DB schema document where ideas 1-4 originated. Useful as context when reading individual `ideas/*.md` — shows how the pieces fit together in the pre-reset version.

Not a v2 PR target as-is. v2 schema will likely cherry-pick 1-3 of the 6 ideas, not the full 9-DB structure.

---

## What's in `automation-stack-options/`

Pre-reset comparison of Make.com vs Zapier vs n8n for iPaaS automation, plus 5 Make.com Blueprint JSON specs.

Reserved for Phase 2+ if/when Inbox concept (idea #4) gets adopted. v0.1.0 explicitly chose no-automation, so these are deferred.

---

## What's in `mobile-patterns/`

Deeper mobile workflow guides for iOS / Android / Apple Shortcuts. v0.1.0 README has a basic Compatibility table; these guides go further.

May inform Phase 2 documentation expansion.

---

## Sunset criteria — when to delete from this directory

This is an idea-stock, not a graveyard. The default state of any file here is "will be deleted unless adopted." Concrete dates:

- **`ideas/*.md`**: Each file expires **2026-12-01** (~7 months after creation). If the idea hasn't been adopted into live code (`notion-templates/`, `prompts/`, etc.) or explicitly extended via PR by that date, delete the file. Decay is the default; preservation requires action.
- **`notion-templates-9db-draft/`**: Delete when v2 schema work begins (regardless of which ideas land). The 9-DB framing is explicitly non-authoritative; once v2 has its own integrated schema, this archive is obsolete.
- **`automation-stack-options/`**: Delete when Phase 2 makes a concrete iPaaS choice OR when Phase 2 ends without one. Either way, the optionality survey loses value.
- **`mobile-patterns/`**: Promote into `docs/mobile.md` (or similar) at Phase 2 documentation expansion, then delete from here. If Phase 2 ships without expanded mobile docs, delete.

The cherry-pick process below removes individual files when ideas graduate. The sunset dates above catch everything that *doesn't* graduate.

---

## Cherry-pick process (for future PRs)

When a hearing-batch signal or Phase 2 prioritization decision points to a specific idea:

1. Open a GitHub Discussion in **Founder Lounge** referencing the relevant `ideas/*.md` file
2. Discuss applicability to the current v0.1.0+ direction
3. If approved by Kimura, open a focused PR that:
   - Promotes the idea content into the appropriate live location (e.g., `notion-templates/README.md` if a schema change, `prompts/system-prompt.md` if a skill addition)
   - Updates `docs/error-rescue-map.md` if new failure modes are introduced
   - Updates `docs/chat-transcripts.md` if new flows are introduced
   - References `prompts/system-prompt.md` `/migrate` skill registry if schema_version bumps
   - Removes the corresponding `ideas/*.md` from `future-plan/` (it has graduated)
4. Sanitization gate: `python3 tools/oss_screening_scan.py --mode edit` must pass for the new live content

This process keeps `future-plan/ideas/` lean — only un-shipped candidates remain.

---

## Adding new ideas to this directory

Use `scripts/future-plan-add.sh`:

```bash
./scripts/future-plan-add.sh "<topic>" <zip-path>
./scripts/future-plan-add.sh --retry "<topic>" <zip-path>   # after fixing scan hits
```

The script handles branch creation, sanitization scan, and draft PR creation. Requires `gh` CLI installed and authenticated. Run with no arguments to see full usage.

For naming patterns and contributor guidance, see the future-plan PR template at `.github/PULL_REQUEST_TEMPLATE/future-plan.md`.

---

## Sanitization status

All files in this directory have been authored to the AGENTS.md trust boundary:
- No real LP / fund / portfolio metrics
- No real founder names; LtV team names anonymized to role placeholders
- Pilot company references replaced with `[Portfolio A]` / `[Portfolio B]` / `[Portfolio C]` style
- All content is Tier 3 (publicly disclosable)

**Action required before any cherry-pick into main**: re-run `tools/oss_screening_scan.py` against the new live content. Sanitization rules apply equally regardless of subdirectory.

---

## Provenance

These materials originated in multi-session AI design discussions in late April / early May 2026, prior to the 2026-05-02 foundation reset. The reset narrowed the product hypothesis; this archive preserves the *reusable* portion of the wider exploration in curated form.

The pre-reset Claude Code-first design itself (18 skills, 3-environment model, full v6.1 drafts) is **not** preserved in this public repo. The 4 patterns from that work that survived rejection are promoted here as `ideas/` candidates; the rest is held privately and is not intended for public reference.

Co-Authored-By: Claude Opus 4.7 <noreply@anthropic.com>

---

*future-plan/README.md — restructured 2026-05-04 to align with v0.1.0 ship and add sunset criteria*
