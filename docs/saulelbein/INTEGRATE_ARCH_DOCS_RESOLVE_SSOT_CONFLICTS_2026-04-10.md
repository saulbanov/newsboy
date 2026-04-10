---
title: "Newsbot — Integrate Arch Docs + Resolve SSOT Conflicts — lilarch Plan"
date: 2026-04-10
status: complete
fallback_policy: forbidden
owners: [saulelbein]
reviewers: []
doc_type: lilarch_change
related:
  - refactor-plan.md
  - REFACTOR_ADDENDUM.md
  - PARKED_DECISIONS.md
  - AGENTS.md
---

# TL;DR
- **Outcome:** 7 new architectural documents live in the repo, SSOT conflicts are resolved, and a future Claude session can navigate the full document set correctly without reading the wrong file or missing the ProPublica integration in refactor-plan.md.
- **Problem:** 7 documents exist on the Desktop outside the repo; the two refactor documents are unaware of each other; architecture-north-star.md has a broken filename reference; AGENTS.md has no pointer to PARKED_DECISIONS.md.
- **Approach:** Copy files, fix one broken reference, add one cross-reference line to each refactor doc, add one pointer line to AGENTS.md.
- **Plan:** 1 phase — all changes are targeted edits + file copies, no structural rewrites.
- **Non-negotiables:**
  - Do not rewrite AGENTS.md (that is a refactor task already in refactor-plan.md)
  - Do not add document references to MASTER_PLAN.md (recreates the bloat problem)
  - Do not merge the two refactor documents
  - Do not reconcile 3-machine vs 5-machine model (intentionally parked)
  - Do not create wiki/tools/registry.md (refactor task, not this task)

# North Star
## The claim (falsifiable)
> If we complete this integration, a Claude session starting cold can: (1) find PARKED_DECISIONS.md from AGENTS.md without reading it, (2) find refactor-plan.md from REFACTOR_ADDENDUM.md and vice versa, (3) resolve architecture-north-star.md's reference to the correct filename — measured by manual session startup check on a clean context.

## In scope
- Copy 7 files from Desktop into newsbot-master-plan/
- Fix broken reference `newsbot-refactor-plan.md` → `refactor-plan.md` in architecture-north-star.md
- Add one-line PARKED_DECISIONS.md pointer to AGENTS.md
- Add one-line cross-reference to REFACTOR_ADDENDUM.md pointing to refactor-plan.md
- Add one-line cross-reference to refactor-plan.md pointing to REFACTOR_ADDENDUM.md

## Out of scope
- AGENTS.md rewrite (refactor task)
- MASTER_PLAN.md content additions
- Merging refactor documents
- 3-machine vs 5-machine reconciliation
- wiki/tools/registry.md creation
- Committing or pushing

## Definition of done
- All 7 files present in newsbot-master-plan/
- `grep "newsbot-refactor-plan" architecture-north-star.md` returns nothing
- `grep "PARKED_DECISIONS" AGENTS.md` returns one line
- `grep "refactor-plan" REFACTOR_ADDENDUM.md` returns a cross-reference line
- `grep "REFACTOR_ADDENDUM" refactor-plan.md` returns a cross-reference line

## Key invariants
- AGENTS.md session startup chain must not grow — the PARKED_DECISIONS pointer is explicitly "do not read on startup"
- refactor-plan.md is the build spec SSOT; REFACTOR_ADDENDUM.md is the architectural decisions SSOT — neither supersedes the other

---

<!-- lilarch:block:requirements:start -->
# Requirements & Decisions (lilarch)

## Requirements (must)
- Copy all 7 files from `/Users/saulelbein/Desktop/refactor addenda2/` into newsbot-master-plan/
- Fix `newsbot-refactor-plan.md` → `refactor-plan.md` in architecture-north-star.md (appears at least twice)
- Add one line to AGENTS.md pointing to PARKED_DECISIONS.md with explicit "do not read on startup" framing
- Add one line near top of REFACTOR_ADDENDUM.md pointing to refactor-plan.md as build implementation spec
- Add one line near top of refactor-plan.md pointing to REFACTOR_ADDENDUM.md as architectural decisions doc

## Non-requirements (explicitly won't do)
- Do not rewrite AGENTS.md
- Do not add new references to MASTER_PLAN.md
- Do not merge refactor-plan.md and REFACTOR_ADDENDUM.md
- Do not reconcile 3-machine vs 5-machine architecture
- Do not create any new reference or registry files
- Do not commit

## Defaults (opinionated; we will do this unless you object)
- architecture-north-star.md lives at newsbot-master-plan/ root (pragmatic home until reporting-OS root exists) — because there is no reporting-OS root directory yet and the file needs to be in the repo
- tool-design-standards.md goes to wiki/tools/ not root — because REFACTOR_ADDENDUM.md creates wiki/tools/registry.md and the standards doc belongs next to it
- AGENTS.md pointer wording: `- Parked architectural decisions (do not read on session startup — check trigger conditions): PARKED_DECISIONS.md` — because it must be visible but not read-on-startup

## Clarifying questions (must answer before implementation)
- Q1: Should the AGENTS.md pointer include a note flagging that it must be preserved in the upcoming AGENTS.md rewrite? (default: yes — add a comment line immediately after)
- Q2: Confirmed: tool-design-standards.md to wiki/tools/, all other 6 files to root? (default: yes)
- Q3: The cross-references in the two refactor docs — one line at the top of each, or in a "related documents" section? (default: top, clearly labeled, one line)
<!-- lilarch:block:requirements:end -->

---

<!-- arch_skill:block:research_grounding:start -->
# Research Grounding

## Internal ground truth
- `AGENTS.md` — session startup file; every Claude session reads this; must stay lean
- `refactor-plan.md` — detailed build spec; Phases 0–3; includes ProPublica integration
- `REFACTOR_ADDENDUM.md` — 6 architectural decisions + 14-step build sequence; amends MASTER_PLAN.md
- `PARKED_DECISIONS.md` — index of 3 parked bodies of work with explicit trigger conditions; routes refactor work to REFACTOR_ADDENDUM.md
- `architecture-north-star.md` — broken reference: says `newsbot-refactor-plan.md` twice; correct filename is `refactor-plan.md`
- `wiki/` — no tools/ subdirectory exists yet; will be created as part of this task for tool-design-standards.md

## Open questions
- None remaining — red-team complete, scope locked
<!-- arch_skill:block:research_grounding:end -->

---

# Decision Log (append-only)
## 2026-04-10 — Plan started
- Context: 7 architectural documents developed in parallel with refactor planning, sitting on Desktop outside repo. Two refactor documents have no declared relationship. PARKED_DECISIONS.md has no entry point from session startup.
- Decision: lilarch flow — single phase, targeted edits only
- Notes: Red-team identified that broken filename reference is in architecture-north-star.md (not MASTER_PLAN.md as originally thought). ProPublica integration is already in refactor-plan.md — no scope addition needed.
