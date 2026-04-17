# Stage Gates and Question-Package Template

## Stage gate table

To detect next stage: walk this table top to bottom. The next stage is the first row where the output file is missing but all input files exist. If all outputs exist, the story is complete.

| Stage | Input files (must exist) | Output file (must be missing) | Manual input? |
|-------|--------------------------|-------------------------------|---------------|
| `0a` | `question-package.md` | `cause-effect-map.md` | No |
| `0b` | `cause-effect-map.md` | `theme-statement.md` | No |
| `0c` | `cause-effect-map.md`, `theme-statement.md` | `hypotheses.md` | No |
| `0c5` | `hypotheses.md` | `machine-research.md` | No |
| `0d` | `theme-statement.md`, `hypotheses.md`, `machine-research.md` | `pitch-gate-verdict.md` | No |
| `1a` | `pitch-gate-verdict.md`, `theme-statement.md`, `hypotheses.md` | `research-plan.md` | No |
| `1a-sub` | `research-plan.md` | `research-plan-developed.md` | No |
| `1b` | `research-artifact.md`, `research-plan.md` | `indexed-notes.md` | Yes — `research-artifact.md` |
| `1c` | `indexed-notes.md`, `research-plan.md` | `wiki-update-complete.md` | No |
| `2a` | `indexed-notes.md`, `theme-statement.md` | `structure-plan.md` | No |
| `2b-draft1` | `structure-plan.md` | `drafts/draft1.md` | No |
| `2b-draft2` | `drafts/draft1.md` | `drafts/draft2.md` | No |
| `2b-draft3` | `drafts/draft2.md` | `drafts/draft3.md` | No |
| `2b-draft4` | `drafts/draft3.md` | `drafts/draft4.md` | No |
| `3` | `structure-plan.md`, any `drafts/*.md` | `editorial-notes.md` | No |
| `4` | `editorial-notes.md`, `citation-sheet.md` | `fact-check-verdict.md` | Yes — `citation-sheet.md` |
| `5` | `fact-check-verdict.md`, any `drafts/*.md` | `distribution-package.md` | No |

If `question-package.md` is missing, the story cannot start — go back to the new story flow and collect the question package first.

---

## Question-package template

Write this file to `wiki/stories/<slug>/question-package.md` after the intake interview. Use the reporter's words. Don't editorialize — Stage 0a sharpens the framing.

```markdown
# Question Package — <slug>
*Created: <date>*

---

## Central development sentence

<One sentence: what is happening, to whom, where, and when — the anchor the story hangs on.>

---

## What prompted this question

<What tipped you to this story. Prior coverage, source contact, document, event. Why this and not something else.>

---

## Harm

Who is harmed: <people, communities>
How they are harmed: <physical, financial, informational — be specific>
Scale / documented evidence: <what's confirmed vs. what's alleged>

---

## Responsibility

Responsible party: <who — institution, official, company>
The decision or failure: <what specifically they did or failed to do>

---

## Why now

<The timing hook. Hard anchor (results due, hearing scheduled, deadline) or soft (prior coverage, source availability, news cycle). Why publishable now and not in six months.>

---

## What we know

**Solid** (documents, on-record sources, data seen):
- <item>

**Promising but unverified** (tips, background sources, circumstantial):
- <item>

**Gaps** (what the story needs but we don't have):
- <item>

---

## Minimum story

<What you can publish today with what you have. Specific and honest.>

---

## Maximum story

<What the story becomes if everything breaks right. Sources go on record, documents surface, results confirm.>

---

## Key variables

- If <condition>, then <story consequence>
- If <condition>, then <story consequence>

---

## Confidence level

- Story exists: <high / medium / low> — <one line why>
- Reportable in time: <high / medium / low> — <one line why>
- Differentiates from existing coverage: <high / medium / low> — <one line why>

---

## Source angle

<Why you and not someone else. Prior coverage, source relationships, documents you hold, distribution network.>
```
