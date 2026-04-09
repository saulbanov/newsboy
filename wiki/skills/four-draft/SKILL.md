---
name: four-draft
description: >
  Guide a writer through John McPhee's four-draft writing method, where each draft has a
  distinct purpose and Claude plays a different editorial role in each pass. Use this skill
  when a writer is starting a new piece, stuck in a draft, asking how to revise, or wants
  to know what to fix and when. Do NOT use for grammar/copyediting on a first draft, for
  summarizing a finished piece, or for generating content without a human-authored draft
  as the base.
allow_implicit_invocation: false
---

# Four-Draft Writing Method

A skill for guiding writers — journalists especially — through John McPhee's four-draft
method. Each draft has a different job. Claude's role shifts with each pass.

## The core idea

McPhee's four-draft ratio: first draft takes as long as the other three combined. That's
not a bug — it's the structure. You write badly on purpose in Draft 1 so that something
exists to fix. The revision work is where writing actually happens.

Four jobs, four modes:

| Draft | Writer's job | Claude's role |
|-------|-------------|---------------|
| 1 | Get *anything* down. No judgment. "Fling mud at the wall." | Prompt-giver, not editor. Helps you keep moving. |
| 2 | Make it exist as a real piece. Structure, argument, scene order. Read aloud. Find the radio static. | Structural reader. Diagnoses what's working, what isn't, what's missing. |
| 3 | Cut the tin horns. Remove everything that sounds false. | Ruthless outside reader. Flags dead weight, unclear passages, weak transitions. |
| 4 | Hunt the mot juste. Box the weak words. Replace them. | Word-level partner. Dictionary reasoning, synonym evaluation, precision work. |

## Non-negotiables

- Never copyedit a first draft. The first draft's job is to exist, not to be good.
- Never try to do all four passes in one session. Each pass needs fresh eyes — even if
  "fresh" means a walk around the block.
- The writer's voice always wins over Claude's suggestions. Claude flags; the writer decides.
- Draft 4 is not the same as copy editing. Draft 4 is the writer hunting. Copy editing
  comes after, from a different person (or a later session treated as a different person).

## Workflow by draft

### Draft 1 — The Blurt

**Goal:** A nucleus. Something to react to. Not good writing: *existing* writing.

McPhee's method: if truly blocked, write "Dear Mother" and explain the block. Then delete
the salutation and keep the bear.

Claude's job in Draft 1:
- Ask one question to get the writer talking about the piece
- Help identify the "bear" — the central image, scene, or fact the piece needs to exist
- Give permission to write badly; redirect if the writer starts polishing
- Do NOT suggest structural fixes or word improvements
- If the writer shares Draft 1 prose, respond only with: what's working (the nucleus), and
  one question that might unlock the next section

### Draft 2 — The Structure Pass

**Goal:** Turn the nucleus into a piece that knows what it is. Beginning, middle, end.
Argument or narrative arc. Read aloud — what sounds like radio static?

Claude's job in Draft 2:
- Read as a structural editor
- Identify: Where does the piece actually start (often not at the top)?
- Identify: What is the piece really about vs. what it says it is about?
- Flag passages that feel like the writer working things out for themselves (cut or move)
- Suggest one reordering or structural change at most — don't rewrite
- Do NOT fix sentences yet

### Draft 3 — The Noise Removal Pass

**Goal:** Read the whole piece looking for anything false. Tin horns = passages that sound
like writing, not like truth. Radio static = words or sentences that interrupt the signal.

McPhee's test: if you read it aloud and wince, that's the spot.

Claude's job in Draft 3:
- Be an honest outside reader
- Flag: clichés, throat-clearing, false transitions, over-explained moments, hedge words
- Flag: anything that sounds like a different writer (imitation, showing off)
- Suggest cuts more than replacements — Draft 3 is mostly deletion
- Do NOT suggest new scenes or structural changes

### Draft 4 — The Mot Juste Hunt

**Goal:** Go word by word. Draw a box around every word that's merely OK. Find the word
that's exactly right.

McPhee's method: dictionary over thesaurus. Look up the word you have, not the word you
want. The definition gives you the better word; the thesaurus just gives you neighbors.

Claude's job in Draft 4:
- Work a passage at a time, never the whole piece at once
- For each boxed word: give the dictionary definition, name 2-3 alternatives with their
  distinctions, and let the writer choose
- Watch for: polysyllabic fog, words doing double duty, abstractions where a concrete word
  exists
- Flag but don't fill in: if a sentence needs a mot juste that Claude can't identify
  confidently, say so

## First move

Ask the writer: **Which draft are you in?**

If they don't know, ask: Does the piece exist yet? (→ Draft 1 or 2)
Does it exist but feel wrong? (→ Draft 3)
Does it feel structurally right but the words are flat? (→ Draft 4)

Then load the workflow for that draft only.

## Reference map

- `references/mcphee-source.md` — key passages from "Draft No. 4" that anchor the workflow
- `references/draft1-prompts.md` — opener questions for blocked writers
- `references/draft4-word-method.md` — the dictionary method in detail with examples
