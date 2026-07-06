# Founder Operating Method — reference

The operating method GSOS coaches the founder *toward*. Adapted from Matt Mochary's
**The Great CEO Within** and the **Mochary Method** curriculum, re-weighted for the
GSOS user: a **pre-team / pre-seed founder**, biased toward **deep-tech and life-science**.

This is the substance layer. It is *not* a set of rules for how the GSOS AI behaves —
those five non-negotiable AI-behavior rules live in [CLAUDE.md → "Operating principles
(non-negotiable)"](../../../CLAUDE.md) and are unchanged. Keep the two layers distinct:

| Layer | What it governs | Where |
|---|---|---|
| **AI-behavior rules** | How the Chief-of-Staff AI acts (never write OKRs blank, yes/no, founder-triggered, Notion SoT, pre-flight) | CLAUDE.md, unchanged |
| **Founder operating method** (this doc) | What good looks like for the *founder* running themselves + a tiny team; what the AI nudges toward | this file + the 4 promoted principles in CLAUDE.md |

When a GSOS command coaches the founder (drafting OKRs, picking today's focus, running
the weekly roast, framing an investor update), it embodies this method. It does **not**
lecture the founder with it. The AI applies the method silently in *how* it structures
drafts and questions; it surfaces a principle by name only when the founder asks why.

---

## §0 — What GSOS already embodies (don't re-teach)

Several Mochary ideas are already load-bearing in GSOS. This doc names their source so
they stop being implicit, but does not re-import them:

- **Write, don't talk** (GCW ch7, ch11) → GSOS's entire premise: the founder's voice is
  already in their meetings; GSOS *structures what they said in writing*.
- **Getting things out of your head / GTD** (GCW ch3) → `/sync-all` (capture from
  meetings) + `/today` (next actions).
- **Notion as single source of truth** → GSOS AI-behavior rule #4.
- **Top Goal** (GCW ch5) → the intent behind `/today` (1-3 KR-linked actions) and the
  quarter Objective in `/okr-set`. Promoted — see §2.1.

---

## §1 — The emphasis thesis (the 濃淡)

Mochary's book has eight parts. Its own structure draws a line: **Parts I–III** are about
the *founder as an individual and a tiny founding team*; **Parts IV–VIII** are the
machinery that "activates at the 10→20-person transition" (Part V's own words) — OKR
infrastructure, meeting systems, recruiting engines, boards, org design.

**The GSOS user sits *before* that transition.** So GSOS imports Parts I–III deeply
(§2), reframes the goal-setting spine for deep-tech (§3), and keeps Parts IV–VIII as a
named **graduation path** rather than active instruction (§4). This is not a rejection of
the scaling material — it is correct sequencing. A pre-seed founder who installs RAPID,
AOR lists, and a board cadence for a 2-person company is applying the method backwards.

**Deep-tech / life-science overlay.** The book is written from a B2B-SaaS vantage point
(PMF ≈ $1M ARR, progress ≈ revenue growth, customers reachable today). Deep-tech and
life-science founders differ on three axes, and the method must bend to them:

1. **Progress is de-risking, not revenue.** The product may be years from a customer.
   Progress = *units of technical, market, and regulatory uncertainty removed*. This
   replaces "revenue growth" as the definition of progress everywhere it appears (§3.1).
2. **Timelines are long and lumpy.** A single technical milestone can span multiple
   quarters. OKRs must decompose into *leading indicators* the founder can move weekly,
   not just the terminal milestone (§3.2).
3. **The founder's energy has to survive years, not months.** Binary technical risk,
   long dark stretches, and grant-rejection cycles make Mochary's Fear-and-Anger and
   Health material *more* central here, not less (§2.3, §2.9).

---

## §2 — Core habits (import in full)

These apply to a founder of one to a handful of people, today, with high leverage.

### 2.1 Top Goal *(promoted to CLAUDE.md)*
Every working day, protect a block (target 2 hours, start at 30 min if that's all you
can hold) for the single most important thing this quarter — and do it *first*, before
inbox, Slack, or meetings. Startups don't fail from too little activity; they fail from
weeks of activity that never touched the one thing that mattered. GSOS applies this in
`/today`: the top pick is the Top-Goal block, not the easiest task.

### 2.2 Getting things out of your head — GTD + Inbox Zero (GCW ch3–4)
Nothing important should live only in the founder's head. Every open loop goes into a
system: Next Actions (context-tagged, written so they can be executed on sight), Waiting
For, Someday/Maybe, Agenda (batch per recurring person), Projects. Process inboxes to
zero on a batched cadence (e.g. twice a day), not continuously. GSOS is the founder's
externalized system: `/sync-all` captures loops from meetings; `/today` surfaces the next
actions. The AI writes commitments as *single executable actions*, never vague goals.

### 2.3 Fear and Anger give bad advice *(promoted to CLAUDE.md)*
Decisions made from fear or anger are reliably worse than decisions made from curiosity
or calm. The discipline: notice when fear/anger has hold of your thinking, name it, let
it move, and return to a curious state *before* deciding. For a deep-tech founder facing
binary technical risk and long uncertainty, this is a survival skill, not a nicety.

**AI boundary (non-negotiable).** The AI does **not** diagnose the founder's emotional
state, and never says "you seem anxious." It offers the *self-check* passively and **rarely** — reserved for genuinely high-stakes,
irreversible (Type-1) decisions, not sprinkled on routine choices. Fired too often, even
a gentle "calm or scared?" becomes nagging and violates the don't-lecture rule. On such a
call it can offer once: "Worth a gut-check on whether this is a calm decision or a scared
one before you commit?" The founder does the noticing. This mirrors the GSOS AI-behavior
rule (yes/no over interrogation) and the "don't tell the founder what they feel" tone rule.

### 2.4 Zone of Genius + Energy Audit (GCW ch9)
Four zones: incompetence, competence, excellence (good at it, don't love it — the
*trap*), genius (uniquely good at it *and* love it). A founder cannot do everything, and
the excellence zone is the seductive time-sink. The Energy Audit — color each calendar
block green (gives energy) or red (drains) for a week, aim for 75%+ green — surfaces what
to stop, delegate, or (later) hire away first. For a scientific founder this clarifies
what only *they* can do (the core science, the vision, key relationships) versus what is
draining borrowed time. GSOS can reflect energy patterns in `/weekly-roast`.

### 2.5 Decision ≠ implementation + Issue / Proposed Solution + DRI *(promoted to CLAUDE.md)*
Separate *deciding* from *doing*. When raising an issue — even with one co-founder —
write it down with a **proposed solution** attached, stated boldly ("we do X"), even at
10% confidence. Written beats spoken (faster to read, fair to the quiet person). Once
decided, every resulting action gets a **DRI** (Directly Responsible Individual) and a
date. An issue with no DRI is not "shared" — it is unowned and will not happen. Never
drop an issue for lack of an owner; assign a provisional DRI ("[owner TBD]") rather than
letting it evaporate. GSOS applies this to the Decisions Log and to every commitment row
(each carries an owner and a due date). *RAPID* — the heavier multi-role decision
framework — is a scaling tool; see §4.

### 2.6 Impeccable Agreements (GCW ch13)
An agreement is impeccable when it is (a) precisely defined — a third party could
objectively verify it was met — and (b) genuinely agreed by everyone, almost always in
writing. "Ship after lunch" is not verifiable; "merged by 15:00 today" is. If you can't
keep an agreement, tell the circle the moment you know, and say what you'll do instead.
This is the anti-virus for the #1 source of startup dysfunction: sloppy commitments. GSOS
enforces this by writing every commitment as measurable + dated, and by tracking
done/not-done honestly in `/weekly-roast`.

### 2.7 Gratitude + Appreciation (GCW ch8)
Attention follows the question you ask. "What's wrong here?" and "What's good here?"
surface different realities, and people (including founders) perform best when they feel
good. A daily gratitude habit, and telling people directly what you appreciate about
them (specifically), is a cheap, high-return practice — especially for a co-founder
relationship under strain. `/weekly-roast` opens with what went *right* this week before
the critique, so the roast builds from a true baseline rather than pure fault-finding.

### 2.8 On Time and Present (GCW ch6)
Be on time, or tell people the moment you know you'll be late — lateness silently steals
the other person's productivity, and with a customer/investor/candidate it can end the
relationship. Be *present*: phone away in meetings, arrive with the context loaded. Cheap
signal of respect, compounding trust.

### 2.9 Health, sleep, mental health (GCW ch10)
Building a company exacts a physical and emotional toll; sacrifice your health and the
whole effort collapses. Sleep, regular exercise, and someone to process emotion with
(peer CEO group, therapist) are load-bearing, not indulgences. For a deep-tech founder on
a multi-year, often isolating slog, this is weighted *up*. GSOS stays a work-OS — it does
not track health — but `/weekly-roast` may offer a light sustainability check-in when the
week's pattern shows the founder running hot for several weeks straight.

---

## §3 — Deep-tech reframes (import, but bent to the audience)

This is where GSOS deliberately departs from the book.

### 3.1 De-risk as progress *(promoted to CLAUDE.md — the hard reframe)*
**Everywhere the method (or the founder) equates progress with revenue growth, GSOS
replaces it with uncertainty removed.** For a deep-tech / life-science company, progress
is measured by which *risks are now closed*: does the science work at the required
threshold? Will a defined user actually adopt and pay? Can it be manufactured / scaled /
approved? A quarter that shipped many tasks but closed no material risk did not make
progress, and GSOS should say so.

This is a *replacement* of the lens, not a denial of revenue. Where a deep-tech company
does have early revenue (a diagnostic, a hardware pilot, a paid design partner), that
revenue **counts — as the signal that market/adoption risk closed**, i.e. it is one
de-risking event, not a competing definition of progress. De-risking subsumes revenue; it
does not oppose it. The failure mode this guards against is treating activity volume, or a
vanity metric, as progress when the load-bearing risk hasn't moved.

**Concretely, this reshapes goal-setting and the roast:**

- `/okr-set`: KRs should be **de-risking milestones** (e.g. "assay reproduces effect at
  N samples with p<X", "3 target users sign LOIs / paid pilots", "regulatory pathway
  confirmed with a specialist") — not vanity metrics.
- `/weekly-roast`: "drift" and "stagnate" are judged against *risk closed*, not activity
  volume. A KR whose underlying risk hasn't moved in 4 weeks is stagnating even if tasks
  were completed under it.
- The forcing question is framed around risk: "What is the single biggest unknown that,
  if resolved, most increases the odds this company works — and did this week touch it?"

### 3.2 Long, lumpy timelines
A terminal technical/clinical milestone may span multiple quarters. Decompose it into
**leading indicators** the founder can actually move week to week (experiments run,
protocols validated, partner conversations advanced), so the weekly cadence stays
meaningful and the roast has something honest to measure. Don't force a multi-quarter
milestone into a single quarter's KR and then declare failure quarterly.

### 3.3 Customer obsession, when the customer is years out (GCW ch1, ch17)
The book's rule — build only around a real customer with a real problem — still holds,
but the "customer" may be distant. Reframe: obsess over the **problem and the end-user
pull**, and validate *demand* early even before there's a product to sell (letters of
intent, design-partner interest, paid pilots for a precursor). For life-science, keep
three distinct roles separate — conflating them is a common founder error:

- **Regulator** (FDA / PMDA equivalent) = the *gate*, not the customer. Satisfy the
  clinical/regulatory endpoint or nothing ships. This is a risk to close (§3.1), not a
  buyer to sell.
- **Payer / acquirer** (insurer, health system, pharma partner) = the actual *customer*
  whose willingness to pay/acquire is the market-risk signal.
- **Patient / end-user** = the *beneficiary* whose problem you obsess over.

The failure mode to guard against is building deep tech in a lab for years with no
demand-side signal from the payer/acquirer, on the assumption that clearing the gate is
the same as having a customer. It isn't.

### 3.4 Fundraising — the Relationship Method (GCW ch27)
Mochary's core advice travels well: build investor relationships *before* you need money;
treat investors as long-term relationships, not transactions; run a tight process. But
GCW ch27's mechanics are written for a generalist (usually SaaS) raise. For deep-tech /
life-science, flag the differences rather than importing the mechanics wholesale:

- **Non-dilutive / grant funding** (government R&D grants, foundation and prize capital)
  is often a first pillar and changes the timeline and dilution math.
- **Specialist investors** who can underwrite technical and regulatory risk matter more
  than generalist logo-chasing.
- **Rounds are milestone-gated:** the raise narrative is "we closed risk A, this round
  closes risk B," which ties directly back to §3.1.

`/investor-update` should lead with *risk closed this period* and the next risk the
capital buys down — the relationship-method framing applied to a de-risking story.

### 3.5 Founding-team dynamics — including the solo and the spinout founder (GCW ch2, ch15)
Two audience realities the book underweights, both first-class for GSOS (whose user is a
*pre-team* founder):

- **The solo deep-tech founder is common and legitimate.** A scientist spinning a company
  out alone is a normal starting state, not a defect to fix. Mochary discourages solo
  founders (ch2) because of the emotional load — so for the solo founder the load-bearing
  substitute is a **support structure**: a strong peer group and, ideally, a peer-founder
  or CEO group to process the isolation and fear (ties to §2.3, §2.9). GSOS should not
  nag a solo founder to "find a co-founder"; it should help them build the support and
  first-hire plan that carries the same weight.
- **University / research-institute spinouts carry equity + IP entanglement early.** The
  "co-founders" may be academic PIs, and the institution holds IP, licensing terms, and
  sometimes equity. Get these into **impeccable, written agreements** (§2.6) *early* —
  founder/PI equity split, IP assignment and license scope, decision rights, time
  commitment of an academic who keeps their lab. Ambiguity here is a slow-acting poison
  that surfaces exactly when the company gets valuable.

Co-founder conflict is a top killer of early startups, and it *forms* at pre-seed —
around equity, IP, and diverging visions, often between scientific co-founders. Import
the relevant Mochary tools, scoped to a founding team of two-to-a-handful, not an org:

- **Conflict resolution** (ch15): most conflict comes from someone not feeling *heard*.
  The simple move: reflect back what the other said until they say "exactly." The full
  written five-emotion process (anger/fear/sadness/joy/excitement, each as
  feeling→fact→story) is powerful but heavy; GSOS offers a *lightweight* version by
  default and points to the full process for serious ruptures.
- **Feedback** (ch25): give it as *Issue + suggestion*; receive it with the 5 A's
  (Acknowledge, Appreciate, Accept-or-not, whichever fits — the point is to make the
  giver feel heard). Scope: co-founder, advisors, early hires, investors.
- **Impeccable agreements** (§2.6) between co-founders prevent most of it in the first
  place — especially agreements about equity, roles, and decision rights, in writing,
  early.

---

## §4 — Graduation path (named, not taught yet)

These are the Part IV–VIII scaling tools. GSOS names them so the founder knows they
exist and roughly when they activate, but does **not** instruct on them at pre-seed. The
generalist trigger is the **~15-20-person / post-PMF transition** where information stops
flowing by osmosis.

**Deep-tech caveat — the trigger is complexity, not just PMF.** A deep-tech / life-science
company routinely grows to 15-30 people (lab scientists, engineers) *years before* PMF or
revenue. Mochary's headcount trigger assumes people-count and PMF arrive together; for
this audience they don't. So judge the trigger by **organizational complexity and
critical-knowledge concentration**, not revenue. Two Part-IV tools in particular can — and
should — activate **before** PMF once a technical team is scaling:

- **Write-it-down-when-you-say-it-twice / process documentation** for experimental
  protocols and know-how (the §0 seed, applied harder).
- **No single point of failure** for critical know-how: if exactly one person knows the
  assay, the fab recipe, or the model pipeline, that is an existential risk long before
  the org chart needs AORs. Cross-train and document it early.

The rest of the table below still waits for the post-PMF / true-org transition.

| Tool | Activates when | One-line why-later |
|---|---|---|
| **RAPID** decision framework | Team too big to fit one room; 5-min discussion can't reach agreement | At 1-3 people, use §2.5 (Issue/Proposed Solution + one decider) |
| **Meeting system** (calendar cadence, exec/all-hands/review meetings, war room) | You have a team to run meetings *for* | Nothing to systematize yet |
| **Recruiting & onboarding engine** (interview loops, anti-sell, offers, comp, grade-level planning) | Hiring beyond the first 1-2 people | First hires are relationship-driven, not a machine |
| **Board of Directors & board meetings** | Usually post-seed, once you have a board | No board to run yet |
| **AORs, no-single-point-of-failure, KPI dashboards, process audit, company wiki/folder structure** | ~20+ people; information stops flowing by osmosis | The "write it down when you say it twice" seed (§0) is enough for now |
| **Culture / Values formalization, Fun, Meals, Celebration-as-system, Transparency policy, Politics defense** | ~30 people (values are *discovered then codified*, not chosen early) | At pre-seed only the Mission/thesis is real; personal gratitude (§2.7) already covers the individual layer |
| **Firing well, performance reviews, motivating a team, keeping star performers** | You manage a team | Managing a team you don't have yet |
| **Blitzscaling, hiring a COO / Exec Ops / human Chief of Staff** | Post-PMF, when you scale | Post-PMF (and GSOS *is* your Chief of Staff until then) |

**Out of scope for GSOS entirely:** IPO, liquidity programs, late-stage / secondary
mechanics, remote-happiness-at-scale.

When the founder crosses the transition, the graduation path is where GSOS's own roadmap
(and the founder's reading of the full book) picks up.

---

## §5 — How each cadence command applies this method

The wiring below is live: each command references this method at the specific workflow
step noted (thin `§`-pointers, no philosophy re-stated in the command).

- **`/okr-set`** — Objective = the quarter's Top Goal (§2.1). KRs = de-risking milestones
  (§3.1), decomposed into leading indicators for long timelines (§3.2). Anchor demand
  validation even pre-product (§3.3). **Cold-start hook:** a lab-stage founder may have
  too few meetings for the meeting-derived path (GSOS falls back to a short free-text
  prompt when meetings < 5). The de-risk framing *is* that scaffold — extend the
  cold-start questions with "what is the biggest technical / market / regulatory unknown,
  and what would close it this quarter?" This keeps AI-behavior rule #1 (never invent; structure the
  founder's own answers) intact while giving the cold-start founder a real spine.
- **`/today`** — top pick is the Top-Goal block (§2.1), written as a single executable
  next action (§2.2). Owner + date implied (§2.5, §2.6).
- **`/sync-all`** — capture open loops out of the founder's head (§2.2); every accepted
  commitment carries a DRI and a due date (§2.5, §2.6).
- **`/weekly-roast`** — open with what went right (§2.7); judge drift/stagnate by *risk
  closed*, not activity (§3.1); forcing question framed around the biggest unknown
  (§3.1); passive Fear-and-Anger gut-check on high-stakes calls (§2.3); light
  sustainability check-in when the founder's run hot for weeks (§2.9).
- **`/investor-update`** — lead with risk closed this period + the next risk the capital
  buys down (§3.4); relationship-method framing.

---

## §6 — Source attribution & crosslinks

- Primary source: Matt Mochary, *The Great CEO Within* (Parts I–VIII) and the public
  Mochary Method curriculum.
- Chapter references (ch#) are to *The Great CEO Within*.
- Related GSOS layers: [CLAUDE.md operating principles](../../../CLAUDE.md) (AI-behavior
  rules — distinct layer), [core-operating-principles](../core-operating-principles/SKILL.md),
  [tone-and-style](../tone-and-style/SKILL.md).
- Sibling implementation: a LtV-internal (VC-firm-facing) adaptation of the same source
  exists in the private edge-stream repo; this GSOS version is re-weighted for the
  pre-seed founder audience and is independent of it.

*This is public design philosophy (Tier 3). It contains no LtV-internal, portfolio, or
LP data.*
