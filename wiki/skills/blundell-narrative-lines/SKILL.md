---
name: blundell-narrative-lines
description: "Choose the right narrative line — Block Progression, Time Line, or Theme Line — for a feature story and apply its organizing principles. Use after indexing and before writing, when the reporter has organized material and needs to decide how to string it together. Invoke on: 'how should I structure this story', 'what order should my sections go in', 'how do I organize this', 'I have my material and don't know how to start writing', 'my story feels jumbled'. Do NOT invoke for lead construction — use blundell-leads. Do NOT invoke for organizing notes — use blundell-indexing first."
allow_implicit_invocation: false
---

# Blundell Narrative Lines

Based on William E. Blundell, *The Art and Craft of Feature Writing* (1988). Every story is a river — the reader must always sense the current of action and progression beneath them, even through the still-water passages of explanation and digression. The narrative line is the vessel that carries the reader down that river.

Blundell uses three lines. Most stories use one predominantly; some combine two or all three.

## When to use

- Notes are indexed, theme statement is final, and it's time to decide how to string the story together
- The story structure feels wrong or unclear after drafting has begun
- An editor has said the story is hard to follow or jumps around

## When not to use

- Material isn't organized yet → use `blundell-indexing` first
- Theme statement isn't finalized → use `blundell-theme-statement` first
- The question is specifically about the lead → use `blundell-leads`

## First move

Ask two questions before recommending a line:
1. Does any single element in the story dominate — is there one section so important it needs to be foregrounded regardless of when it happened?
2. Is the story's purpose to give a broad general impression of a subject, or to deliver a specific set of messages?

These two answers usually determine the line. See `references/three-lines.md`.

## Non-negotiables

- There is no perfect fixed order for block progression sections. Plan the first one or two carefully — after that, let what you've written suggest what comes next. Don't preplan the whole order before you write.
- History is never a standalone block. It gets sprinkled throughout wherever it lends contrast, authenticity, or understanding of present events.
- "Digress often, but don't digress long." Every observation, explanation, and quote is a digression from action. Get in and out fast. The digression serves the story; the action stitches it together. See `references/digress-rule.md`.
- Most real stories combine lines. A block progression story may contain a time-line episode and a theme-line miniprofile. Name the primary line; note where other lines are embedded.

## Output format

Return based on recommended line:

**Block progression**: Which section leads and why (based on theme statement emphasis). Which section follows. Note that after two sections the story should suggest its own next move. Key principle: keep related material together.

**Time line**: The action thread — what event or sequence serves as the spine. How digressions attach to action beats. Expected digression length (rarely more than 2-3 paragraphs before returning to action).

**Theme line**: The two or three facets being hammered, confirmed against the theme statement. Note that chronology is ignored — most dramatic material plays first regardless of when it happened.

For all: note where other lines are embedded if relevant, and flag the primary line clearly.

Then return a **QA summary** as the final section:

```
## QA Summary

| Check | Result | Note |
|-------|--------|------|
| Primary line explicitly named and justified | PASS / FLAG | |
| Line choice tied directly to the theme statement | PASS / FLAG | |
| Digression rule acknowledged (digress often, don't digress long) | PASS / FLAG | |
| History placement addressed (not a standalone block) | PASS / FLAG | |
| Embedded secondary lines noted if present | PASS / FLAG | |

**Before proceeding:** [One specific question — e.g., "Does the recommended line match how you want the reader to experience this story, or is there a structural reason to try a different approach?"]
```

## Reference map

- `references/three-lines.md` — each line with strengths, weaknesses, and when to use
- `references/block-progression-order.md` — how to determine section order from the theme statement
- `references/digress-rule.md` — the principle with the cowboy story as illustration
- `references/combining-lines.md` — how and when to mix all three
