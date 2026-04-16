# Newsboy Master Plan — System File
*Created: 2026-04-09 | Last updated: 2026-04-09*

---

## Problem Statement
Two partial architecture documents describe the same system from different angles — one operational and tool-specific (reporting-os-architecture.md), one conceptual and pipeline-focused (numbered docs 01–06). There is no single master document that unifies them. Without it, building is directionless and the two versions will continue to drift.

---

## Success Condition
One master plan document that: maps the full system in layers, shows how the two source docs fit together, names what gets built in what order, and keeps tool slots modular so the architecture isn't locked to any specific product or beat.

---

## Problem Type
Primary: **System / tools**
The architecture exists in two partial forms; the right structure (one unified map) would unlock building.

Secondary: **Clarity / decision**
A few genuine conflicts between the two docs need a call before the master plan can be written cleanly.

---

## Key Principles
1. **Modular over specific.** Tool slots stay open until there's a reason to commit. Beat/client specificity is a modular attachment, not the skeleton.
2. **Map before blueprint.** The master plan shows the whole system and build order — not internal implementation of every part.
3. **Build-first, expand.** Something functional and growing beats a complete spec that never ships. The master plan should make daily build decisions easier, not replace them.
4. **Placeholders are valid.** `[TBD]` is a legitimate state. Don't block the plan on open questions.

---

## Current Working Theory
**Version:** 1 | **Set:** 2026-04-09

The two source documents are not competing versions — they cover different parts of the same system. The `reporting-os-architecture.md` describes what the numbered docs call "The Scanner" (intake → scoring → triage), but with concrete tools named. The numbered docs cover the full pipeline from question to published story, but are deliberately tool-agnostic. Merging them means: adopt the numbered docs' layer structure as the skeleton, absorb the reporting-os's operational detail into the Scanner layer, and leave tool slots open throughout.

The first conflict to resolve: the reporting-os is climate-specific; the numbered docs are modular. The user has confirmed: keep it modular. Climate/Texas/Future Heist are use-case examples, not architectural constraints.

---

## Hypothesized Next Steps
- [ ] Step 1: Write the master plan document — one file, full system map, build order, modular tool slots
- [ ] Step 2: Read the remaining source docs (04–06) and fold in anything the master plan missed
- [ ] Step 3: Identify the first buildable unit and scope it
- [ ] Step 4: Build something functional; run a real input through it (candidate: Perplexity bookmarks as intake test case)

---

## Session Log

### 2026-04-09 — Intake
**What happened:** Problem intake completed. Both source documents read in full.
**What we learned:**
- The two docs cover different layers of the same system, not the same layer twice
- User wants a modular architecture — no tool lock, no beat lock
- User's instinct: build-first, expand is right; but a north star map is needed first
- Potential first real input: Perplexity bookmarks as intake test case
- Master plan = map not blueprint; placeholders are fine
**Theory impact:** Working theory set. Docs are complementary, not conflicting. The merge is additive.
**Next step:** Step 1 — Write the master plan document

---

## Evidence Log
| Date | Source | Observation | Theory impact |
|------|--------|-------------|---------------|
| 2026-04-09 | reporting-os-architecture.md | Covers intake → scoring → Workflowy triage with specific tools | Maps to Scanner layer in numbered docs |
| 2026-04-09 | 01_Architecture_Overview.md | Establishes Scanner + Newsroom Pipeline + Amplification Loop as the three machines | Provides the skeleton for the master plan |
| 2026-04-09 | 02_Full_System_Map.md | Detailed stage-by-stage breakdown of all three machines | Source for layer detail in master plan |
| 2026-04-09 | 03_MVP_Build_Plan.md | 7-phase build sequence, question-in to story-out, no scanner yet | Defines MVP scope and build order |
| 2026-04-09 | User conversation | User confirmed: modular architecture, placeholders fine, build-first instinct | Shapes how master plan should be written |
| 2026-04-09 | User conversation | Perplexity bookmarks named as potential first real input | Candidate for Step 4 intake test |

---

## Hypotheses
| # | Hypothesis | Status | Evidence for | Evidence against |
|---|-----------|--------|-------------|-----------------|
| 1 | The two docs are complementary, not conflicting | Active | Different layers covered; user confirmed modular intent | Minor tool-specificity conflict (resolved: keep modular) |
| 2 | MVP should start with the pipeline (question → story), not the scanner | Active | Doc 03 explicitly scopes MVP this way | reporting-os suggests starting with intake |

---

## Blockers and Dependencies
| Blocker | What's needed | Who/when | Status |
|---------|--------------|----------|--------|
| Docs 04–06 not yet read | Need to check for anything that changes the master plan | Read in Step 1 session | Open |

---

## Resolved Blockers
- Tool/beat lock question: resolved. Keep modular. Placeholders fine.

---

## Decision Log
| Date | Decision | Rationale | Alternatives |
|------|----------|-----------|--------------|
| 2026-04-09 | Keep architecture modular, no tool or beat lock | User confirmed explicitly | Lock to FH/Texas/Perplexity stack |
| 2026-04-09 | Master plan = map not blueprint | Build-first instinct; plan should enable decisions not replace them | Full spec before building |
| 2026-04-09 | Numbered docs provide the skeleton; reporting-os provides Scanner-layer detail | Numbered docs are more complete architecturally | reporting-os as primary |

---

## Model Drift Flags
None yet.

---

## Parking Lot
- Perplexity bookmarks as intake test case — valid for Step 4, not Step 1
- Future Heist / Texas / climate specifics — valid as a use-case example layer, not architectural constraint
- Tool integrations (Workflowy, Obsidian, Perplexity, Claude, Slack, EspoCRM) — all modular, decide per layer when building
- Scanner build: doc 03 explicitly defers this post-MVP; flag for Step 3 scoping

---

## Archive
Nothing yet.

---

## Meta notes
- User's working style: instinct-first, doesn't always know the answer but knows the wrong question fast
- Move at pace — user wants to run something today; don't over-interview
- Source docs live at: `/Users/saulelbein/Documents/Claude Code/Newsboy/source documents/`
- Docs 04–06 not yet read: `04_Iterative_Roadmap.md`, `05_Learning_Layer.md`, `06_Implementation_Spec.md`
