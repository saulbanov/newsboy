# Reporting OS Refactor Plan
*newsbot-master-plan structural redesign + journalism skills integration*
*Canonical version — 2026-04-09*
*Architectural decisions governing this build: `REFACTOR_ADDENDUM.md`*

---

## What this plan does

Converts newsbot-master-plan from a sequential, skill-heavy pipeline into a lean, parallelized, methodology-as-reference system. Fixes cross-stage contamination gaps. Integrates ProPublica LRN journalism skills as reference layer alongside existing Blundell suite. Integrates prompt-authoring and agents-md-authoring as construction discipline. Adds investigation mode. Establishes institutional memory layer with contamination controls.

---

## Current state

**What exists and works**: `runner.sh` with subprocess isolation, prerequisite checking, pending/approved gate flow, gate logging. Blundell suite (9 skills, built). Four-draft skill (built). Five flat pipeline skills (hypothesis-formation, pitch-gate, editorial-review, fact-check, distribution-prep). All 24 lean prompts written and validated. Phase 1 build complete — ready for trial run on a fresh story.

**What's broken**:
- `build_prompt()` loads SKILL.md + all references unconditionally — context bloat
- `0c.5` machine research runs in conversation — no file output, confirmed broken
- Drafting passes (2b–2e) not in runner — run in conversation, information isolation broken
- Stage 1a uses blundell-six-part-guide alone — missing ProPublica reporting-plan framework
- No `wiki/compiled/` layer — no institutional memory across stories
- No prompt/reference split defined for any stage
- No investigation mode

**What's good and stays**: runner.sh core, information isolation via subprocess, three-gate reporter model, Blundell content, four-draft content, gate logging, pipeline-log.md.

---

## Phase 0 — Foundation

*Nothing in Phase 1 starts until this is complete.*

### 0.1 Directory structure

Create what doesn't exist. Don't move content yet.

```
newsbot-master-plan/
  prompts/                          ← NEW (empty — filled in Phase 1)
  scripts/                          ← NEW
    0c5-machine-research.sh         ← NEW
    0c7-trending-context.sh         ← NEW (placeholder)
    community-discovery.sh          ← NEW
    investigation-monitor.sh        ← NEW (Phase 2)
  wiki/
    skills/
      pipeline.md                   ← NEW: routing + invariants
      blundell-*/                   ← unchanged
      four-draft/                   ← unchanged
    reference/                      ← NEW
      propublica-lrn/               ← NEW: from three journalism skill zips
      prompt-craft/                 ← NEW: from Blake skills reference docs
    stories/                        ← unchanged
    compiled/                       ← NEW: institutional memory
      beats/
      sources/
      entities/
      concepts/
      gaps/
      index.md
    investigations/                 ← NEW: Phase 2 storage
    system/                         ← unchanged
```

### 0.2 Reference layer population

**`wiki/reference/propublica-lrn/`** — extract all reference docs from the three journalism skill zips. SKILL.md files do not move here — they dissolve into lean prompts. Nine files total:
- From propublica-pitch: `pitch-questions.md`, `accountability-tests.md`, `minimum-maximum.md`
- From reporting-plan: `reporting-plan-questions.md`, `gap-audit.md`, `source-strategy.md`
- From engagement-memo: `engagement-questions.md`, `engagement-audit.md`, `community-outreach-channels.md`

**`wiki/reference/prompt-craft/`** — copy reference docs from Blake skills (prompt-authoring and agents-md-authoring). These govern how prompts and AGENTS.md files are written and maintained.

### 0.3 `wiki/skills/pipeline.md`

One page. Contains:

**Routing table** — stage name → prompt file path for every stage

**Information isolation rules** (moved from AGENTS.md):

| Stage | Sees | Never sees |
|-------|------|------------|
| 0a cause-effect-map | question-package.md | Everything else |
| 0b theme-statement | cause-effect-map.md | Research, notes |
| 0c hypothesis-formation | cause-effect-map.md, theme-statement.md | Research, notes |
| 0d pitch-gate | theme-statement.md, hypotheses.md, machine-research.md | Research artifact |
| 1a research-planning | pitch-gate-verdict.md, theme-statement.md, hypotheses.md | Notes, drafts |
| 1a subagents | research-plan.md (their tier only) | Other tiers, story files |
| 1b note-organization | research-artifact.md | Drafts, gate logs |
| 1c wiki-update | indexed-notes.md, research-plan.md | Drafts, gate logs |
| 2a structure | indexed-notes.md, theme-statement.md | Research artifact |
| 2b-draft1 | structure-plan.md | Research artifact, notes |
| 2b-draft2/3/4 | previous draft only | Everything else |
| 3 editorial-review | current draft only | Research artifact, citation sheet, gate logs |
| 4 fact-check | current draft, citation-sheet.md | Research artifact, gate logs |
| 5 distribution-prep | cleared draft | Everything upstream |

**`wiki/compiled/` access rules** — invariant: *compiled/ is not in any stage's INPUT_FILES by default. Access is granted explicitly per stage after the access rules design session, which is mandatory after the second 1c run, before story #3 begins. Until then, no stage reads compiled/ from a subprocess.*

**Journalism invariants** (from journalism skills' non-negotiables):
- Harm must be concrete and documented or documentable — not implied
- Central question must be yes/no answerable
- Every major claim needs a document target or on-record source path
- Right of response is non-negotiable before publication
- A "needs more" verdict is not a soft commission

**Subagent rules**: no questions, no recursion, no commits, one write-capable subagent at a time, parallel subagents for read-only only

**Skill triggers**: when writing or auditing a prompt → call prompt-authoring. When writing or auditing AGENTS.md → call agents-md-authoring.

**Flagged open question**: compiled/ access rules — design session mandatory after second 1c run.

### 0.4 AGENTS.md rewrite

Authored with agents-md-authoring. Two pages maximum.

**Remove**: "MANDATORY SKILL EXECUTION PROCEDURE" — behavioral instruction trying to solve what runner enforces mechanically. Information isolation table — moves to pipeline.md. Full skills inventory — becomes compressed docs index.

**Keep**: Reporter model (three gates, everything else silent). When-a-skill-breaks protocol. What NOT to do. Skill triggers.

**Add**: Compressed docs index pointing to prompts/, wiki/reference/, wiki/skills/pipeline.md, wiki/compiled/. Runner usage. Session startup (read this file → check MASTER_PLAN.md → state where we are in two sentences).

### 0.5 Question package format

Strengthen the existing template using propublica-pitch framework. Human-fillable. Fields: question, what prompted it, harm (concrete — who, how, documented or documentable), responsibility (named institution or decision-maker), why now, what we know, what we need, minimum story, maximum story, confidence level.

### 0.6 runner.sh — `build_prompt()` change

**This is the enabling change for all of Phase 1.**

New behavior: lean prompts declare their own reference injections via a `## References` section. Runner parses that section and loads only listed files.

```bash
build_prompt() {
  local prompt_file="$SCRIPT_DIR/prompts/$STAGE.md"

  if [[ -f "$prompt_file" ]]; then
    prompt=$(cat "$prompt_file")
    # Parse ## References section, load each listed file
    while IFS= read -r ref_path; do
      [[ -f "$SCRIPT_DIR/$ref_path" ]] && \
        prompt+=$'\n\n'"=== $(basename "$ref_path") ==="$'\n'"$(cat "$SCRIPT_DIR/$ref_path")"
    done < <(awk '/^## References/{found=1; next} found && /^- /{print substr($0,3)} found && /^##/{exit}' "$prompt_file")
  else
    # Fallback: existing SKILL.md loading (unchanged)
    ...existing logic...
  fi

  # Input files injection unchanged
}
```

Fallback means: every existing stage continues working. New stages activate one at a time as prompt files are written. No cutover moment.

**Phase 0 exit criteria**: Directory structure exists. Reference layer populated. pipeline.md written. AGENTS.md rewritten and validated against agents-md-pattern-contract. Question package template updated. `build_prompt()` fallback change deployed and tested (existing stages still pass).

---

## Phase 1 — Pipeline Prompts and Contamination Fixes

*Each prompt authored with prompt-pattern-contract: commander's intent (outcome not checklist), system context (downstream cost of weak output), quality bar (vivid strong vs. weak), output contract (what must be returned and how to validate), error handling. Anti-heuristic check before each is done.*

### 1.1 Fix 1: 0c.5 script

`scripts/0c5-machine-research.sh`

Input: `wiki/stories/[slug]/hypotheses.md` — Tier 1 hypotheses only
Process: parse Tier 1 hypotheses, run Perplexity/XAI call per hypothesis, structured output per result
Output: writes `wiki/stories/[slug]/machine-research.md`
No LM. If API call fails: write failure reason to file, exit non-zero.

`configure_stage()` addition:
```bash
0c5)
  STAGE_LABEL="Stage 0c.5 — Machine Research"
  PREREQS=("$STORY/hypotheses.md|0c")
  OUTPUT_FILE="$STORY/machine-research.md"
  # Main loop detects this stage, calls script instead of claude subprocess
  ;;
```

Remove manual prerequisite note from 0d's PREREQS. `machine-research.md` is now produced by the runner.

### 1.2 Fix 2: drafting passes in runner

Four new `configure_stage()` entries. Each runs as subprocess. Each sees only what it should.

```bash
2b-draft1)
  STAGE_LABEL="Stage 2b-draft1 — The Blurt"
  PREREQS=("$STORY/structure-plan.md|2a")
  INPUT_FILES=("$STORY/structure-plan.md")
  OUTPUT_FILE="$STORY/drafts/draft1.md"
  ;;
2b-draft2)
  STAGE_LABEL="Stage 2b-draft2 — Structure Pass"
  PREREQS=("$STORY/drafts/draft1.md|2b-draft1")
  INPUT_FILES=("$STORY/drafts/draft1.md")
  OUTPUT_FILE="$STORY/drafts/draft2.md"
  ;;
2b-draft3)
  STAGE_LABEL="Stage 2b-draft3 — Noise Removal"
  PREREQS=("$STORY/drafts/draft2.md|2b-draft2")
  INPUT_FILES=("$STORY/drafts/draft2.md")
  OUTPUT_FILE="$STORY/drafts/draft3.md"
  ;;
2b-draft4)
  STAGE_LABEL="Stage 2b-draft4 — Mot Juste"
  PREREQS=("$STORY/drafts/draft3.md|2b-draft3")
  INPUT_FILES=("$STORY/drafts/draft3.md")
  OUTPUT_FILE="$STORY/drafts/draft4.md"
  ;;
```

Stage 3 prereq changes to `drafts/draft4.md`. Compression: reporter stops after any pass by advancing to stage 3 — runner finds most recent draft via existing `ls | sort -V | tail -1` logic.

### 1.3 Pre-pitch prompts (0a–0c)

**Audit required before writing 0a and 0b**: read SKILL.md and all references for blundell-cause-effect-map and blundell-theme-statement. Classify each paragraph: procedure (stays in prompt) vs. methodology (moves to reference). Reference files already exist — audit determines which get declared.

Protocol for each unread stage: read → classify → prompt contains procedure + output contract → reference docs contain methodology + worked examples.

**`prompts/0c-hypothesis-formation.md`** — split definitive:

Prompt contains: single job, IF/THEN/AT/HOW/TIER/CONFIDENCE format (exact), ranking output structure, QA summary format.

New reference files to create at `wiki/reference/hypothesis-formation/`:
- `tier-rationale.md` — extended Tier 1 vs Tier 2 explanation, edge cases, examples
- `confidence-guide.md` — extended confidence level rationale with worked examples

References declared: `wiki/reference/hypothesis-formation/tier-rationale.md`, `wiki/reference/hypothesis-formation/confidence-guide.md`

### 1.4 Pitch gate (0d)

**`prompts/0d-pitch-gate.md`** — split definitive:

Prompt contains: adversarial posture (one sentence), two failure modes (named, tested — not elaborated), three verdicts (output spec only — what each must contain), QA summary format.

New reference files to create at `wiki/reference/pitch-gate/`:
- `adversarial-rationale.md` — extended reasoning for skeptical editor posture, examples of stories that failed
- `verdict-elaboration.md` — what "needs more" means vs. soft commission, how to state a kill

References declared: `wiki/reference/propublica-lrn/accountability-tests.md`, `wiki/reference/propublica-lrn/minimum-maximum.md`, `wiki/reference/pitch-gate/adversarial-rationale.md`, `wiki/reference/pitch-gate/verdict-elaboration.md`

Output expanded: verdict + pitch memo in propublica-pitch 14-section format assembled from inputs. Pitch memo flows into 1a as commissioned artifact.

### 1.5 Research planning — the Blundell + ProPublica merge (1a)

**`prompts/1a-research-planning.md`** — runs both frameworks in sequence.

Prompt contains: two-step sequence (Blundell first, ProPublica second), Step 1 output spec (weighted section list with specific questions — not all six, only those that dominate), Step 2 output spec (central question yes/no test stated explicitly, source list by tier, document targets, community gap flag yes/no with reason, critical path 3–5 tasks), subagent spawning instruction (which subagents to spawn based on source tiers and community flag).

References declared:
- `wiki/skills/blundell-six-part-guide/references/six-part-questions.md`
- `wiki/skills/blundell-six-part-guide/references/reasons-guidance.md`
- `wiki/skills/blundell-six-part-guide/references/countermoves-guidance.md`
- `wiki/reference/propublica-lrn/reporting-plan-questions.md`
- `wiki/reference/propublica-lrn/source-strategy.md`

Not declared: `profile-variant.md` (profile-specific), `interactive-dialogue.md` (conversation mode only).

System context: Step 1 (Blundell) identifies what story dimensions matter and what questions each requires. Step 2 (ProPublica) maps the operational path through that territory. A plan with only one produces narrative without evidence or evidence without story.

**Parallel subagents** (all read-only, spawned by runner after 1a output is written):

`prompts/1a-sub-tier1.md` — Tier 1: decision-makers and affected people. No references. Output: named targets or hypothetical with access path and likely posture. 150 words maximum.

`prompts/1a-sub-tier2.md` — Tier 2: institutional witnesses. No references. Same output structure.

`prompts/1a-sub-tier3.md` — Tier 3: expert validators. No references. Same output structure.

`prompts/1a-sub-tier4.md` — Tier 4: records sweep. No references. Output: each record — document name, where it lives, public or FOIA-able, likely exemptions, fallback if denied.

`prompts/1a-sub-coverage.md` — Past coverage. No references. Output: three most recent substantial stories, gap each left, one sentence on how this investigation advances past them.

`prompts/1a-sub-community.md` — Community discovery. Conditional on community gap flag. References: `wiki/reference/propublica-lrn/community-outreach-channels.md`. Perplexity-based: finds specific named channels findable for this community and geography — not generic channel types.

`prompts/1a-sub-engagement.md` — Engagement memo. Conditional, runs after community discovery output exists. References: `wiki/reference/propublica-lrn/engagement-questions.md`, `wiki/reference/propublica-lrn/community-outreach-channels.md`. Output: 10-section engagement memo + single biggest risk and fix.

Runner subagent spawning: after 1a output written, parse source tiers and community gap flag, spawn parallel `claude --print` processes for each applicable subagent, wait for all, main agent synthesizes into `wiki/stories/[slug]/research-plan.md`.

### 1.6 Note organization (1b)

Audit required: read blundell-indexing SKILL.md + 3 references before writing prompt. Reference files already exist — audit determines which get declared.

### 1.7 Wiki update (1c)

**`prompts/1c-wiki-update.md`**

Single job: extract durable knowledge from this story's research into the compiled wiki. Write-capable — not a subprocess. Runs in main conversation after 1b.

Input: `indexed-notes.md` + `research-plan.md`
Output: writes to `wiki/compiled/` subdirectories — source profiles, entity profiles, concepts, open questions, beat contribution, updates index.md.

Human reviews additions. Corrections logged. No Obsidian dependency — review via direct file access. (Obsidian is a future interface layer, not load-bearing for this architecture.)

`configure_stage()` addition: INPUT_FILES includes indexed-notes.md + research-plan.md. OUTPUT_FILE is a marker file (`wiki/stories/[slug]/wiki-update-complete.md`). Actual output is distributed across compiled/.

### 1.8 Structure (2a)

Audit required: read blundell-narrative-lines SKILL.md + 4 references before writing prompt.

### 1.9 Drafting passes (2b-draft1 through 2b-draft4)

All splits definitive (four-draft SKILL.md read fully).

**`prompts/2b-draft1.md`** — The Blurt
Prompt contains: single job (nucleus, not good writing), Claude's role (prompt-giver only — does not edit, does not suggest structure), what to do if writer shares draft1 prose (name the nucleus, ask one question only), advance signal.
References declared: `wiki/skills/four-draft/references/draft1-prompts.md`, `wiki/skills/four-draft/references/mcphee-source.md`

**`prompts/2b-draft2.md`** — Structure Pass
Prompt contains: single job (make it exist as a real piece), Claude's role (structural reader — where does it actually start, what is it really about vs. what it says), one structural change maximum, do not fix sentences, advance signal.
References declared: `wiki/skills/four-draft/references/mcphee-source.md`

**`prompts/2b-draft3.md`** — Noise Removal
Prompt contains: single job (cut the tin horns), Claude's role (flag clichés, throat-clearing, false transitions, over-explained moments, imitation), suggest cuts not replacements, no new scenes no structural changes, advance signal.
References declared: `wiki/skills/four-draft/references/mcphee-source.md`

**`prompts/2b-draft4.md`** — Mot Juste
Prompt contains: single job (word by word hunt), Claude's role (dictionary over thesaurus, one passage at a time, name candidates with distinctions, let writer choose), common traps (polysyllabic fog, over-boxing, losing voice), advance signal.
References declared: `wiki/skills/four-draft/references/draft4-word-method.md`, `wiki/skills/four-draft/references/mcphee-source.md`

### 1.10 Remaining prompts (3, 4, 5)

Audit required for editorial-review.md, fact-check.md, distribution-prep.md before writing. Likely splits:

**3**: References: `wiki/reference/propublica-lrn/accountability-tests.md` (second application — checks draft delivers what pitch promised). New reference likely needed for editorial coherence guidance.

**4**: Probably mostly procedural. Minimal or no references.

**5**: References: `wiki/reference/propublica-lrn/community-outreach-channels.md` (stakeholder/distribution targeting — Machine 3 seed).

### 1.11 Augmentation tools

**`prompts/aug-gap-audit.md`** — merges Blundell post-reporting diagnostic (which story dimensions are thin) + ProPublica gap-audit (which claims lack evidentiary support). Both run. One brief per active area. Prioritized gap list (dealbreakers first).
References: `wiki/skills/blundell-six-part-guide/references/`, `wiki/reference/propublica-lrn/gap-audit.md`

**`prompts/aug-engagement-audit.md`** — diagnoses a live callout that isn't working. Five-problem diagnostic, specific fixes.
References: `wiki/reference/propublica-lrn/engagement-audit.md`

**Phase 1 exit criteria**: All contamination gaps closed. All prompts written and section-validated against prompt-pattern-contract. One story through full pipeline with complete audit trail. Second story begun to validate compiled/ write from 1c.

---

## Phase 2 — Investigation Mode

*Build after Phase 1 is proven on at least one complete story.*

### 2.1 What investigation mode is

Different from story mode in operating rhythm and entry state. Three valid entries:

**Subject without question** — "I want to watch X." Monitoring generates signal that sharpens into a question. Feeds story mode at 0a when ready.

**Question needing sharpening** — Has a direction, needs evidence before pitchable. Feeds story mode at 0c or 0d already partly loaded.

**Sharp question needing accumulation** — Question exists, proof requires weeks before warranted commissioning. Feeds story mode at 0d with machine research pre-done.

### 2.2 Storage structure

```
wiki/investigations/[slug]/
  investigation-record.md     ← territory/question, why, what triggers a pitch
  monitoring-agenda.md        ← specific channels, databases, sources + cadence
  accumulation-log.md         ← append-only findings, timestamped
  signals.md                  ← events that materially advance the investigation
  ready-to-pitch.md           ← populated at threshold → becomes story mode question package
```

### 2.3 Monitoring cycle

`./runner.sh --mode investigation [slug]` runs:

1. Load investigation record + monitoring agenda
2. `scripts/0c5-machine-research.sh` against monitoring agenda targets
3. `scripts/0c7-trending-context.sh`
4. Community discovery subagent (regular — investigation mode has time for sustained community relationship building)
5. Engagement memo subagent (design mode early; audit mode if callout stalling)
6. Append new findings to `accumulation-log.md`
7. Signal detection check → update `signals.md` if material change, surface alert
8. Ready-to-pitch check → if threshold met, generate question package → feed story mode

### 2.4 Engagement memo repositioned

**Story mode**: conditional parallel subagent at 1a, triggered by community gap flag. One-time sprint.

**Investigation mode**: regular part of monitoring cycle. This is when engagement does its best work — time to build community relationships before publication pressure exists.

### 2.5 Runner mode flag

```bash
./runner.sh --mode story [stage] [slug]       ← current behavior (default)
./runner.sh --mode investigation [slug]        ← monitoring cycle
./runner.sh --mode augmentation [tool] [slug] ← aug-gap-audit or aug-engagement-audit
```

**Phase 2 exit criteria**: Investigation monitoring cycle running on at least one real beat. At least one signal surfaced. At least one investigation tipped into story mode.

---

## Phase 3 — Learning Layer

*After at least three stories through the full pipeline.*

### 3.1 Storage

```
wiki/taste-profile/
  gate-logs/          ← structured gate entries by stage
  syntheses/          ← periodic pattern extractions
  current-profile.md  ← living taste model, versioned
```

### 3.2 Gate logging enhancement

Add structured fields: what was changed (if edited before approving), what was waved through without friction, which journalism invariant the rejection mapped to.

### 3.3 Synthesis skill

Reads gate logs, extracts patterns, proposes profile updates. Output must specify: which section of which prompt should change, using prompt-pattern-contract section taxonomy. Prevents smearing updates across whole prompts.

Human reviews proposals. Approved changes applied via prompt-authoring edit mode — smallest section that owns the problem.

### 3.4 compiled/ access rules design session

Triggered after second 1c run. Mandatory before story #3. Examine what compiled/ actually contains, decide access rules per stage, scope reads using compressed index pattern. Update configure_stage() for approved stages, update pipeline.md invariants.

---

## Full Stage Sequence

```
0a  cause-effect-map
0b  theme-statement
0c  hypothesis-formation
0c5 machine-research         ← script, no LM
0c7 trending-context         ← script, no LM (placeholder)
0d  pitch-gate               ← GATE: commission / kill / needs more
1a  research-planning        ← spawns parallel subagents
    ├── sub-tier1
    ├── sub-tier2
    ├── sub-tier3
    ├── sub-tier4
    ├── sub-coverage
    ├── sub-community        ← conditional: community gap flag
    └── sub-engagement       ← conditional: after community discovery
1b  note-organization
1c  wiki-update              ← writes to wiki/compiled/
2a  structure
2b-draft1  The Blurt
2b-draft2  Structure Pass
2b-draft3  Noise Removal
2b-draft4  Mot Juste
3   editorial-review         ← GATE: approve / route back / escalate
4   fact-check
5   distribution-prep        ← GATE: clearance
```

---

## Build Order

```
Phase 0:
  → directory structure
  → reference layer (propublica-lrn, prompt-craft)
  → wiki/compiled/ structure
  → pipeline.md (routing, isolation rules, compiled/ invariant, flagged trigger)
  → AGENTS.md rewrite
  → build_prompt() fallback change + test (existing stages still pass)

Phase 1a — contamination fixes:
  → scripts/0c5-machine-research.sh + configure_stage()
  → configure_stage() for 2b-draft1 through 2b-draft4
  → test: existing story pipeline still passes

Phase 1b — audit unread stages:
  → read 0a, 0b, 1b, 2a, 3, 4, 5 skill files
  → classify procedure vs. methodology for each
  → write split spec before touching any prompt

Phase 1c — write prompts:
  → 0c (split definitive — write now)
  → 0d (split definitive — write now)
  → 1a + all subagents (split definitive — write now)
  → 2b-draft1 through 2b-draft4 (split definitive — write now)
  → 0a, 0b, 1b, 2a, 3, 4, 5 (write after audit in 1b)
  → 1c wiki-update
  → aug-gap-audit, aug-engagement-audit
  Each prompt activates in runner as written. Test each on a real story run.

Phase 1d:
  → test: full pipeline end-to-end on one story
  → test: 1c runs and writes to wiki/compiled/
  → second story begins

Phase 2 — investigation mode (after first story complete):
  → wiki/investigations/ structure
  → runner mode flag
  → investigation monitoring cycle
  → community discovery and engagement repositioned

Phase 3 — learning layer (after three stories):
  → gate logging enhancement
  → synthesis skill
  → compiled/ access rules design session (triggered by second 1c run)
```

**One rule**: test before advancing. No prompt goes to the next stage until the previous one produces clean output on a real story.

---

## Open Questions

**compiled/ access rules**: which stages read compiled/, what scope, what mechanism. Design session mandatory after second 1c run.

**OpenResearch**: could investigation mode power a public-facing research project rather than feeding a story pipeline? Needs definition before Phase 2 build.

**Obsidian**: not in current stack. Future interface layer for wiki review. Not load-bearing for this architecture.

**Multi-story parallelism**: how does the pipeline handle two stories simultaneously? Not scoped.

**Machine 5 (Synthesis Layer)**: inherits a working compiled/ layer governed by explicit access rules. Build last.

**Perplexity bookmark ingestion**: Existing Perplexity research chats contain relevant material for stories. Need `scripts/fetch-perplexity-chat.sh` that takes a Perplexity URL/ID, fetches the chat content, and transforms it into structured markdown matching machine-research.md format. Wires into 0c5 as supplementary input alongside fresh API calls. Revisit: after Phase 1d trial run confirms pipeline works, before second story begins — the second story is the natural place to test ingestion of prior research.

**Newssifter → pipeline handoff**: The newssifter (Machine 1/Scanner) finds stories; the pipeline (Machine 2) processes them. Natural handoff is a structured output from the sifter that maps to a question package for stage 0a. Sifter should output: (1) signal — what happened, who's involved, why it surfaced, (2) source URLs — articles/data that triggered the sift, (3) beat tag — which beat for compiled/ lookup, (4) timeliness flag — breaking vs. slow-burn. These four fields are 80% of a question package; reporter fills in judgment calls (harm, responsibility, minimum story). Revisit: after Phase 2 investigation mode is built — investigation monitoring and sifter intake share the same "watch the world, surface questions" architecture and should be designed together.

**Agentic newsroom architecture**: the current pipeline is explicitly designed around human workflows — correcting human frailties, preserving human judgment at gates, making the machine a capacity extension for a human reporter. The three-gate model, the reporter mode, the information isolation rules, the taste profile — all assume a human in the captain's chair whose patterns and blind spots the system learns to complement. An agentic newsroom (no human reporter, or human in a fundamentally different role) could have a quite different structure: different gate logic, different parallelization, different quality controls, potentially no taste profile in the current sense. This pipeline may be the right proof of concept and the right learning environment, but it should not be assumed to be the right architecture for a fully agentic system. Note this before scaling or replicating.
