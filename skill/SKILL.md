---
name: newsboy
description: "Newsboy journalism pipeline. Use when the user types /newsboy or wants to start a new story, continue an existing story, or run a demo. Handles intake interview, question-package creation, stage execution, and gate decisions. The pipeline lives at ~/Documents/Claude Code/newsbot-master-plan/. Do NOT use for general journalism questions or pipeline design."
user-invocable: true
metadata: {"openclaw":{"os":["darwin"],"requires":{"bins":["claude"]}}}
---

## What this is

Newsboy is a journalism pipeline. A question enters; a published story exits. It lives at `~/Documents/Claude Code/newsbot-master-plan/`. Stories are in `wiki/stories/<slug>/`. Each stage runs via `./runner.sh <stage> <slug>`.

Your job: run the intake interview, build the question package, execute stages, surface output here, handle gate decisions, advance automatically.

---

## On invoke

**Check for existing stories first:**

```bash
ls ~/Documents/Claude\ Code/newsbot-master-plan/wiki/stories/
```

If stories exist, ask: "Start a new story or continue an existing one? [list slugs]"

If no stories, go straight to intake.

If an argument was passed (e.g. `/newsboy johnson-county-results`), treat it as the slug and jump to [Run next stage](#run-next-stage).

---

## New story: intake interview

The goal is to produce a rich `question-package.md`. Don't use a form. Run a real interview.

**Step 1 — Get the raw material.**

Say: "Tell me what you have — paste notes, a source article, a tip, whatever you've got. Or just tell me what you know."

Wait. Read everything they give you.

**Step 2 — Interview toward the question package.**

Work through these areas, in whatever order fits what they've said. Ask one question at a time. Follow up when answers are thin.

- **Harm:** Who is being hurt, and how? Is there documented evidence or is this a tip?
- **Responsibility:** Who made the decision that caused the harm? What specifically did they do or fail to do?
- **Why now:** What's the timing hook? Why is this story publishable this week or month and not in six months?
- **What you know:** Walk me through what you have on the record (documents, on-record sources, published data) vs. what's promising but unverified vs. what you still need.
- **Minimum story:** If nothing new comes in, what can you publish today? What does that story say?
- **Maximum story:** If everything breaks right — sources go on record, documents surface, results come in — what does the full story look like?
- **Confidence:** How confident are you this story exists? That you can report it in time?

Push on vague answers. "Kids were harmed" → "How many kids? What symptoms? Is there a parent on record?" Don't move on until you have enough to fill the field.

**Step 3 — Write the question package.**

Create the story directory and write the question package:

```bash
mkdir -p ~/Documents/Claude\ Code/newsbot-master-plan/wiki/stories/<slug>
```

Then write `wiki/stories/<slug>/question-package.md` using the full template in `references/stage-gates.md`.

Confirm: "Question package written. Ready to start the pipeline — running Stage 0a now."

**Step 4 — Run Stage 0a.**

See [Run next stage](#run-next-stage).

---

## Run next stage

**Detect next stage** by checking which files exist in the story directory (stage gate table in `references/stage-gates.md`). Tell the user: "Next stage: `<stage>` — `<label>`."

**Handle manual-input blockers.** Some stages need files the reporter writes. If the next stage needs one, stop and say what's needed:

| Stage | Needs reporter to write |
|-------|------------------------|
| `1b` | `research-artifact.md` — field reporting notes |
| `4` | `citation-sheet.md` — citations built during drafting |

**Run the stage in non-interactive mode:**

```bash
cd ~/Documents/Claude\ Code/newsbot-master-plan && ./runner.sh <stage> <slug> --run-only
```

**Read and display the output:**

```bash
cat ~/Documents/Claude\ Code/newsbot-master-plan/wiki/stories/<slug>/.pending/<stage>.md
```

Show the full output to the user. Then ask: "Approve, reject, or edit?"

- **Approve:** `./runner.sh <stage> <slug> --log-approved "<note>"` → advance to next stage automatically
- **Reject:** ask for reason → `./runner.sh <stage> <slug> --log-rejected "<reason>"` → stop, tell user what to fix
- **Edit:** open the pending file for the user to edit, then treat as approve

After approving, immediately detect and run the next stage unless the user says stop.

---

## Demo mode

If the user says "demo," use `johnson-county-results`. Ask which stage to show, or default to re-running `0a`.

---

## Non-negotiables

- Always `cd` into `newsbot-master-plan/` before running `runner.sh`.
- Never skip the gate. Every stage output must be approved before the next runs.
- Never run stages directly in conversation — the pipeline depends on subprocess isolation.
- If `--run-only` fails, check that the prerequisite files exist before debugging further.
