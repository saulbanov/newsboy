# Newsboy — Session Startup

## What this is
AI-assisted newsroom pipeline. Question in, published story out.
Human gates at pitch, draft, and clearance. Everything else runs silently.

---

## Read on startup
1. Read this file.
2. Check `MASTER_PLAN.md` — current story, current stage, current status.
3. State in two sentences: where we are, what's next.

Do not recap history. Do not redesign working stages. Do not skip stages.

---

## Current story and next action
See `MASTER_PLAN.md` — Current State section.

To run a stage:
```
./runner.sh <stage> <slug> --run-only
```
To approve or reject after reviewing output:
```
./runner.sh <stage> <slug> --log-approved "<note>"
./runner.sh <stage> <slug> --log-rejected "<reason>"
```

---

## Reporter model — three gates, everything else silent

**Gate 1 — Pitch:** Stages 0a/0b/0c run as a unit. Surface to editor: theme + hypotheses + what can be proved. One decision: commission / kill / needs more.

**Gate 2 — Draft:** Research and structure run internally. Bring the editor a draft with a reporter's note: what the story is, what's uncertain, where you need direction.

**Gate 3 — Clearance:** Surface editorial review + fact-check verdict. Editor makes the final call.

Do not interrupt for intermediate steps. Do the work; bring findings.

---

## When a stage breaks
1. Log what broke in `gate-logs.md` for the current story.
2. Identify: skill design, information handoff, or gate boundary?
3. Fix the skill or prompt file. Do not work around it.
4. Re-run the stage.
5. If the fix changes information access or output format, update `MASTER_PLAN.md`.

---

## What NOT to do
- Skip the theme statement for any reason
- Run a stage with information it shouldn't have
- Move to the next stage before the current one produces clean output
- Redesign stages that haven't been tested yet
- Build the integration/automation layer before the manual run is complete

---

## Reference docs (load only when needed)
- Full pipeline sequence + routing: `wiki/skills/pipeline.md`
- Methodology reference: `wiki/reference/` (Blundell, ProPublica LRN)
- Prompt-writing standards: `wiki/reference/prompt-craft/prompt-pattern-contract.md`
- AGENTS.md-writing standards: `wiki/reference/prompt-craft/agents-md-pattern-contract.md`
- Tool registry: `wiki/tools/registry.md` (created in refactor Phase 0.6)
- Full refactor build spec: `refactor-plan.md`
- Architectural decisions: `REFACTOR_ADDENDUM.md`

## Parked architectural decisions
Do not read on session startup. Check trigger conditions before acting on any work outside the current newsboy pipeline: `PARKED_DECISIONS.md`
