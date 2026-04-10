# Refactor Addendum — Newsbot Pipeline
*Generated: 2026-04-10 | Amends: MASTER_PLAN.md*
*Scope: Current refactor only. Do not act on anything in PARKED_DECISIONS.md.*
*Build implementation spec (detailed phases, per-stage prompt specs, ProPublica integration): `refactor-plan.md`*

---

## What This Document Is

This document contains architectural changes to the newsbot pipeline developed in April 2026. It amends MASTER_PLAN.md — it does not replace it. Read MASTER_PLAN.md first as always, then read this document to understand what is changing and why.

Everything in this document is actionable now. Nothing here is speculative or future-state.

---

## Change 1: Prompt/Skill Split

**What's changing:**
Skills currently do all the cognitive work — Claude reads thousands of words of SKILL.md plus reference files before producing any output. This is the primary source of slowness.

**The fix:**
Split every stage into two layers:

**Layer 1 — Prompts** (new directory: `prompts/`)
One file per stage. Lean. Procedural. Contains only: what this stage does, input spec, output format. No preamble. No methodology embedded.

```
prompts/
  0a-cause-effect-map.md
  0b-theme-statement.md
  0c-hypothesis-formation.md
  0c7-trending-context.md
  0d-pitch-gate.md
  1a-research-planning.md
  1b-note-organization.md
  2a-structure.md
  2b-draft-pass.md
  3-editorial-review.md
  4-fact-check.md
  5-distribution-prep.md
```

**Layer 2 — Reference docs** (new directory: `wiki/reference/`)
Blundell suite and four-draft methodology move here. Not loaded automatically. Injected by prompts only when needed. Swappable without touching pipeline stages.

```
wiki/reference/
  blundell-cause-effect/
  blundell-theme/
  blundell-indexing/
  blundell-narrative/
  blundell-leads/
  blundell-high-interest/
  four-draft/
```

**Key rule:** Prompts call reference docs. Reference docs never call prompts. Methodology is injected, never hardcoded. This makes methodologies swappable in the future without touching pipeline architecture.

**What stays the same:** Skill files remain but become thin — one page each, containing only routing information and invariants for that stage. The pipeline.md skill file contains the master routing table and information isolation rules.

---

## Change 2: AGENTS.md Split

**What's changing:**
AGENTS.md currently does too many jobs — pipeline sequence, skill inventory, methodology, gate protocol, behavior rules, runner documentation. Claude reads all of it every session even when most is irrelevant.

**The fix:**
Split into three files:

- `AGENTS.md` — two pages maximum. Session startup only. Where we are, what's next, which prompt to run. Points to everything else.
- `REFERENCE_PIPELINE.md` — full pipeline sequence. Loaded on demand only.
- `REFERENCE_METHODOLOGY.md` — methodology overview. Loaded on demand only.

**AGENTS.md template after refactor:**
```markdown
# Newsbot — Session Startup

## What this is
AI-assisted newsroom pipeline. Question in, published story out.
Human gates at pitch, draft, and clearance. Everything else runs silently.

## Read on startup
1. Read this file.
2. Check MASTER_PLAN.md for current story and stage.
3. State in two sentences: where we are, what's next.

## Current story
[slug] — Stage [X] — [brief status]

## Next action
Run: ./runner.sh [stage] [slug] --run-only
Prompt: prompts/[stage-file].md

## Reference docs (load only when needed)
- Full pipeline sequence: REFERENCE_PIPELINE.md
- Methodology overview: REFERENCE_METHODOLOGY.md
- Routing + invariants: wiki/skills/pipeline.md
- Runner documentation: RUNNER_DOCS.md
- Parked architectural decisions: PARKED_DECISIONS.md
```

---

## Change 3: Mechanical vs. LM Separation

**What's changing:**
Some stages currently use Claude where no LM is needed.

**The fix — what becomes a script (no LM):**
- `0c.5` machine research — API calls to Perplexity/XAI against Tier 1 hypotheses. Writes `machine-research.md`. No LM.
- `0c.7` trending context — new placeholder stage. API pull from XAI/Perplexity. Writes `trending-context.md` before pitch gate. No LM. Scanner output plugs in here when Scanner is built.
- Gate logging — file write. No LM.
- Wiki indexing — entity extraction. Script or lightweight model.

**What stays LM:**
- 0a, 0b, 0c, 2a, 2b-2e, 3, 4 — all require reasoning. Claude.

---

## Change 4: Subagent Pattern for Research Phase

**What's changing:**
Everything currently runs sequentially. Research phases with multiple Tier 1 hypotheses wait in line.

**The fix:**
When 0c produces 2+ Tier 1 hypotheses, spawn parallel read-only subagents — one per hypothesis — to run machine research simultaneously. Main agent synthesizes results before proceeding to pitch gate.

**Before finalizing parallel execution design for any phase:** evaluate whether a lightweight synthesis pass is needed between parallel work and the next sequential LLM stage. Ask: do the parallel outputs need to be checked for coherence and contradictions before the next stage consumes them? If yes, design an explicit fast verification step at that boundary. If no, explain why the next stage can safely consume unverified parallel outputs directly.

**Subagent rules:**
- No questions: answer from repo/doc evidence only
- No recursion: subagents do not spawn subagents
- No commits: subagents do not write final outputs; main agent integrates
- No log spam: subagents write details to worklog, return summary only
- One write-capable subagent at a time
- Parallel subagents for read-only work only

---

## Change 5: Tool Registry

**What's changing:**
Tools (runner.sh, API scripts) are designed ad hoc with no standards.

**The fix:**
Add `wiki/tools/registry.md`. Every tool the system calls gets an entry before it gets used. Entry includes: input schema, output schema, read or write, idempotency strategy.

**Audit runner.sh first:**
- [ ] Returns structured output on both success and failure
- [ ] Retries don't double-log gate decisions
- [ ] Rejects malformed stage names and slugs before executing
- [ ] Read and write operations are clearly separated

**Four rules every tool must follow:**
1. Strict input validation — reject bad inputs before execution
2. Idempotency on writes — safe to call twice
3. Structured outputs — JSON or structured markdown, never prose
4. Read/write separation — read tools run freely, write tools log every call

---

## Change 6: Two Low-Cost Risk Mitigations

These come from the risk assessment (see `PARKED_DECISIONS.md` for full context) and are cheap enough to incorporate now without scope creep.

**Speculation markers on early-stage outputs:**
Cause-effect map and hypothesis outputs should carry an explicit marker — e.g. a header line stating "SPECULATIVE — not verified, not established fact" — so later stages cannot inadvertently consume them as established findings.

**Primary source links in citation sheet:**
The citation sheet should include direct links to primary sources, not just source names. The human at the clearance gate needs to be able to verify claims directly, not just trust that the system checked them.

---

## Directory Stubs to Create Now

These don't need content yet. Create the directories so future machines integrate cleanly:

```
wiki/private/
  notes/
  interviews/
  documents/
  datasets/
  index.md          ← placeholder only

wiki/synthesis/
  flags/
  confirmations/
  patterns/
  log.md            ← placeholder only

wiki/tools/
  registry.md       ← start with runner.sh entry
```

---

## Build Sequence

In order. Complete each step before starting the next.

1. Create `prompts/` directory. Write `prompts/0a-cause-effect-map.md` — extract procedure from current skill, condense to lean prompt.
2. Write `wiki/skills/pipeline.md` — routing table + invariants. One page.
3. Rewrite `AGENTS.md` — strip to session startup. Move content to `REFERENCE_PIPELINE.md` and `REFERENCE_METHODOLOGY.md`.
4. Move Blundell methodology files to `wiki/reference/`. Update prompts to inject them.
5. Split `0c.5` into a script. Remove LM from machine research step.
6. Add `0c.7` as a data-pull script placeholder. Wire in XAI/Perplexity.
7. Audit `runner.sh` against tool design standards. Create `wiki/tools/registry.md` with runner.sh entry.
8. Update `runner.sh` to call prompts directly instead of loading skill files.
9. Add speculation markers to 0a and 0c output formats.
10. Add primary source link field to citation sheet template.
11. Create `wiki/private/`, `wiki/synthesis/` directory stubs.
12. Add subagent spawning to research phase for 2+ Tier 1 hypotheses.
13. Test on one real story end-to-end. Break it. Fix it.
14. Repeat for remaining stages.

---

## What Does Not Change

- Information isolation rules — correct, enforced mechanically by runner.sh
- Three-gate reporter model — pitch, draft, clearance
- Wiki folder structure for stories
- Blundell methodology content — relocated to reference layer, not rewritten
- Gate logging behavior
- The fundamental pipeline sequence (0a through 5)
- MASTER_PLAN.md as the session-by-session state tracker
