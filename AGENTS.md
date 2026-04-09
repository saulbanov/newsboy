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

Current test case: the $950M oil ceasefire bet story.
Current stage: cause-effect-map → theme-statement → pitch-gate.

Move one stage at a time. Complete each stage fully before advancing. When something breaks — a skill produces bad output, a handoff drops information, a gate doesn't catch what it should — fix the skill before moving on. Log what broke and how it was fixed.

---

## Pipeline stage sequence (always in this order)

```
0a. cause-effect-map        blundell-cause-effect-map
0b. theme-statement         blundell-theme-statement     ← ALWAYS runs, no exceptions
0c. pitch-gate              wiki/skills/pitch-gate.md

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

**Blundell suite** (built, do not rewrite):
`/Users/saulelbein/Documents/Claude Code/blundell-skills/`
- blundell-cause-effect-map, blundell-theme-statement, blundell-six-part-guide
- blundell-indexing, blundell-narrative-lines, blundell-high-interest-elements
- blundell-leads, blundell-profile, blundell-story-analyst

**Four-draft** (built):
`/Users/saulelbein/Documents/Claude Code/master-journo-skills/`

**Pipeline skills** (built, test and refine):
`wiki/skills/`
- pitch-gate.md, editorial-review.md, fact-check.md, distribution-prep.md

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
