# Pipeline — Routing + Invariants
*Single source of truth for stage routing, information isolation, and system-level rules.*

---

## Routing Table

| Stage | Prompt file | Skill fallback (if no prompt file) |
|-------|-------------|-----------------------------------|
| intake | prompts/intake.md | wiki/skills/blundell-story-analyst |
| 0a | prompts/0a-cause-effect-map.md | wiki/skills/blundell-cause-effect-map |
| 0b | prompts/0b-theme-statement.md | wiki/skills/blundell-theme-statement |
| 0c | prompts/0c-hypothesis-formation.md | wiki/skills/hypothesis-formation.md |
| 0c5 | scripts/0c5-machine-research.sh | (script — no LM) |
| 0c7 | scripts/0c7-trending-context.sh | (script — no LM, placeholder) |
| 0d | prompts/0d-pitch-gate.md | wiki/skills/pitch-gate.md |
| 1a | prompts/1a-research-planning.md | wiki/skills/blundell-six-part-guide |
| 1b | prompts/1b-note-organization.md | wiki/skills/blundell-indexing |
| 1c | prompts/1c-wiki-update.md | (no fallback — new stage) |
| 2a | prompts/2a-structure.md | wiki/skills/blundell-narrative-lines |
| 2b-draft1 | prompts/2b-draft1.md | (no fallback — new stage) |
| 2b-draft2 | prompts/2b-draft2.md | (no fallback — new stage) |
| 2b-draft3 | prompts/2b-draft3.md | (no fallback — new stage) |
| 2b-draft4 | prompts/2b-draft4.md | (no fallback — new stage) |
| 3 | prompts/3-editorial-review.md | wiki/skills/editorial-review.md |
| 4 | prompts/4-fact-check.md | wiki/skills/fact-check.md |
| 5 | prompts/5-distribution-prep.md | wiki/skills/distribution-prep.md |

---

## Information Isolation Rules

Each stage sees only the files listed. No exceptions. If a stage needs something it shouldn't have, fix the stage design — do not break isolation.

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

---

## compiled/ Access Rules

**Invariant:** `wiki/compiled/` is not in any stage's INPUT_FILES by default. Access is granted explicitly per stage only after the access rules design session.

**Trigger:** Design session is mandatory after the second 1c run, before story #3 begins.

**Until then:** No stage reads `wiki/compiled/` from a subprocess.

---

## Journalism Invariants

Non-negotiables enforced at every relevant stage. A stage that violates these must be routed back, not approved.

- Harm must be concrete and documented or documentable — not implied
- Central question must be yes/no answerable
- Every major claim needs a document target or on-record source path
- Right of response is non-negotiable before publication
- A "needs more" verdict is not a soft commission

---

## Subagent Rules

- No questions: answer from repo/doc evidence only
- No recursion: subagents do not spawn subagents
- No commits: subagents do not write final outputs; main agent integrates
- No log spam: subagents write details to worklog, return summary only
- One write-capable subagent at a time
- Parallel subagents for read-only work only

---

## Skill Triggers

When writing or auditing a prompt → call prompt-authoring (`wiki/reference/prompt-craft/prompt-pattern-contract.md`)
When writing or auditing AGENTS.md → call agents-md-authoring (`wiki/reference/prompt-craft/agents-md-pattern-contract.md`)
