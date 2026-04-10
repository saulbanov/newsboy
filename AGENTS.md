# AGENTS.md — Newsbot Master Plan
## Claude reads this file first, every session.

---

## What this project is

An AI-assisted newsroom pipeline. The system takes a question and produces a published story, with Claude handling mechanical work at each stage and a human making every real judgment call.

This is not a design project. It is a build-test-break-fix project. The pipeline exists on paper. The job now is to run real material through it, find what breaks, and fix it.

---

## Session startup — every time

1. Read this file.
2. Read `newsbot-master-plan-system.md`.
3. Read `MASTER_PLAN.md` for current pipeline state.
4. State in two sentences: where we are in the test run, what's needed next.

Do NOT recap full history. Do NOT redesign things that are working. Do NOT skip to a later stage because an earlier one seems hard.

---

## The development methodology

**Build it. Run real material through it. Try to break it. Fix what breaks.**

This is the loop. Not: design exhaustively, then build. Not: build, then test with synthetic examples. Real material, real friction, real fixes.

Current test case: see MASTER_PLAN.md for the active story and stage.

Move one stage at a time. Complete each stage fully before advancing. When something breaks — a skill produces bad output, a handoff drops information, a gate doesn't catch what it should — fix the skill before moving on. Log what broke and how it was fixed.

---

## HOW TO BEHAVE: REPORTER MODEL

**Act like a reporter, not a script executor.**

The human is the editor. Editors commission stories and approve drafts. They do not approve cause-effect maps or theme statement drafts in isolation — those are reporter work.

**Three editorial moments. Everything else runs silently.**

1. **The Pitch** — Run 0a, 0b, 0c as a unit without interruption. Then surface to the editor: theme statement + key hypotheses + what can be proved today vs. what needs reporting. One brief. One decision: commission / kill / needs more.

2. **The Draft** — Run research and structure internally. Bring the editor a draft with a reporter's note: what the story is, what I'm uncertain about, where I need direction.

3. **Clearance** — Surface the editorial review and fact-check verdict. Editor makes the final call.

Do not interrupt the editor for intermediate mechanical steps. Do not ask for approval on the cause-effect map, the theme statement in isolation, or the research plan. Do the work; bring findings.

**Future state note:** At some point when this pipeline is mature and reliable, a more granular gate-at-every-stage model may make sense. We are nowhere near that. Until explicitly told otherwise, stay in reporter mode.

---

## MANDATORY SKILL EXECUTION PROCEDURE

**This applies to every stage, whether it surfaces to the editor or runs silently.**

Before producing ANY output for a pipeline stage:

1. **Read the skill file completely.** Find the skill file for the current stage (see Skills inventory below). Read it — including all files in its `references/` subdirectory. Do not produce output until you have read it.
2. **Follow the skill file's procedure exactly.** Not your approximation of it. Not what it sounds like it probably says. The actual procedure in the file.
3. **Produce the exact output format the skill specifies.** If the skill says "return four sections," return four sections. If it says "IF/THEN/AT format," use that format.

**If you find yourself about to produce pipeline output without having read the skill file: stop. Read the skill file. Then proceed.**

The entire point of the skill files is to prevent you from pattern-matching to what a stage sounds like and producing plausible-seeming output. That is the failure mode this system is designed to prevent. Do not do it.

---

## RUNNER — how stages execute

`runner.sh` is the mechanical enforcement layer. **All stage execution goes through runner.sh. No manual stage execution in the conversation.**

### Normal flow (conversation-native gates)

1. Claude runs: `./runner.sh <stage> <slug> --run-only`
2. Runner executes the subprocess in isolation, writes output to `wiki/stories/<slug>/.pending/<stage>.md`, prints output to stdout.
3. Claude reads the pending file, presents it to the editor with the QA summary highlighted.
4. Editor approves or rejects in the conversation.
5. If **approved**: Claude runs `./runner.sh <stage> <slug> --log-approved "<note>"` — commits pending output to the output file, writes gate log.
6. If **rejected**: Claude runs `./runner.sh <stage> <slug> --log-rejected "<reason>"` — clears pending, writes gate log.

Claude does not write output files directly. The runner writes them. This is the mechanical enforcement.

### [file not found] errors

These mean a required input file is missing — the previous stage was not completed and gated. Do not work around this by writing the file manually. Complete the previous stage through the runner first.

### Interactive mode (terminal fallback)

`./runner.sh <stage> <slug>` — original interactive behavior, for use when running from a terminal directly. Gate prompt appears in terminal.

---

## Pipeline stage sequence (always in this order)

```
0a. cause-effect-map        blundell-cause-effect-map
    input: central development sentence (one plain verb sentence — not a theme statement)
    output: map + fence + remote elements
0b. theme-statement         blundell-theme-statement     ← ALWAYS runs, no exceptions
    input: fenced portion of cause-effect-map
    output: theme statement (development + consequence + countermove)
0c. hypothesis-formation    wiki/skills/hypothesis-formation.md
    input: theme statement + candidate chains
    output: IF/THEN hypotheses, Tier 1/2 labeled, confidence levels
0c.5 machine-research       [conversation-native — no subprocess]
    input: Tier 1 hypotheses from 0c
    output: machine-research.md — findings written to story directory before 0d runs
    NOTE: this step runs in the conversation (web search, document fetch). Results MUST
    be written to machine-research.md. Stage 0d will not run without this file.
0d. pitch-gate              wiki/skills/pitch-gate.md
    input: theme statement + hypotheses + machine-research.md
    output: commission / kill / needs more

1a. research-planning       blundell-six-part-guide
1b. note-organization       blundell-indexing

2a. structure               blundell-narrative-lines
2b–2e. drafting (×3–4)      four-draft
                            blundell-high-interest-elements
                            blundell-leads
                            [citation sheet built alongside every draft pass]

3. editorial-review         wiki/skills/editorial-review.md
                            [runs cold — sees draft only]

4. fact-check               wiki/skills/fact-check.md
                            [spun up cold — sees draft + citation sheet only]
                            [assumes fabrication]
                            [new findings route back to reporter]

5. distribution-prep        wiki/skills/distribution-prep.md
```

**Theme statement always runs. No exceptions. No skipping.**

---

## Information isolation rules (non-negotiable)

| Role | Sees | Never sees |
|------|------|------------|
| cause-effect-map | Question only | Research, notes |
| theme-statement | Question + cause-effect map | Research, notes |
| pitch-gate | Theme statement + initial evidence | Research artifact |
| editorial-review | Draft only | Research artifact, citation sheet, gate logs |
| fact-check | Draft + citation sheet | Research artifact, gate logs, editorial notes |
| distribution-prep | Cleared draft | Everything upstream |

Contaminating a role with context it shouldn't have defeats its purpose. If a stage needs to see something it's not supposed to see, that is a skill design problem — fix the skill, don't break the isolation.

---

## The reporter's running obligation

The reporter (Claude in reporting mode) maintains a citation sheet alongside every draft pass. Every factual claim mapped to a primary source. Built continuously, not assembled at the end. The fact-checker will test every item on it.

---

## Wiki folder structure for every story

```
wiki/stories/[slug]/
  question-package.md
  cause-effect-map.md          ← all candidate chains, ranked
  theme-statements/
    [theme-v1-commissioned].md
    [theme-v2-hold].md
    [theme-v3-killed].md
  research-artifact.md
  citation-sheet.md
  drafts/
    v1.md
    v1-audit.md
    v2.md
    ...
  gate-logs.md
  outcome.md
```

Anything that surfaces entities, concepts, or recurring patterns gets written to `wiki/compiled/` — that is how the wiki becomes institutional memory.

---

## Skills inventory

All skills live in `wiki/skills/` (relative to this project root). Full paths below.

**Blundell suite** (built, do not rewrite):
- `wiki/skills/blundell-cause-effect-map/` — SKILL.md + references/
- `wiki/skills/blundell-theme-statement/` — SKILL.md + references/
- `wiki/skills/blundell-six-part-guide/` — SKILL.md + references/
- `wiki/skills/blundell-indexing/` — SKILL.md + references/
- `wiki/skills/blundell-narrative-lines/` — SKILL.md + references/
- `wiki/skills/blundell-high-interest-elements/` — SKILL.md + references/
- `wiki/skills/blundell-leads/` — SKILL.md + references/
- `wiki/skills/blundell-profile/` — SKILL.md + references/
- `wiki/skills/blundell-story-analyst/` — SKILL.md + references/

**Four-draft** (built):
- `wiki/skills/four-draft/` — SKILL.md + references/

**Pipeline skills** (built, test and refine):
- `wiki/skills/hypothesis-formation.md`
- `wiki/skills/pitch-gate.md`
- `wiki/skills/editorial-review.md`
- `wiki/skills/fact-check.md`
- `wiki/skills/distribution-prep.md`

**Research tools** (active):
- Perplexity API (key in session)
- xai-grok (requires XAI_API_KEY)

**Meta-skills** (use when writing or refining skills):
`/Users/saulelbein/Documents/Claude Code/Blake Skills/`
- skill-authoring, prompt-authoring, agents-md-authoring

---

## When a skill breaks

1. Log what broke in gate-logs.md for the current story.
2. Identify whether the problem is: skill design, information handoff, or gate boundary.
3. Fix the skill file. Do not work around the problem.
4. Re-run the stage.
5. If the fix changes the skill's information access or output format, update MASTER_PLAN.md.

---

## What NOT to do

- Skip the theme statement for any reason
- Run a stage with information it shouldn't have
- Move to the next stage before the current one produces clean output
- Redesign stages that haven't been tested yet
- Build the integration/automation layer before the manual run is complete

---

## Parked architectural decisions
Do not read on session startup. Check trigger conditions before acting on any work outside the current newsbot pipeline: `PARKED_DECISIONS.md`
<!-- PRESERVE IN AGENTS.md REWRITE: this pointer is required. Rewrite is specified in refactor-plan.md Phase 0.4. -->
