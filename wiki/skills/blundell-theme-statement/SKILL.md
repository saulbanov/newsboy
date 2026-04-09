---
name: blundell-theme-statement
description: "Develop or pressure-test a journalism story's main theme statement — the 2-3 sentence action-reaction chain that governs all reporting and writing decisions. Use when a journalist needs to crystallize what their story is actually about, before or after reporting. Invoke on: 'help me figure out my story', 'what is my story really about', 'I have notes and don't know what I have', 'my editor wants a pitch', or when the user pastes notes or a draft whose central action chain is unclear. Do NOT invoke for copy editing, headline writing, or lead construction once a theme statement already exists."
allow_implicit_invocation: false
---

# Blundell Theme Statement

Based on William E. Blundell, *The Art and Craft of Feature Writing* (1988). Blundell called the theme statement "the single most important bit of writing" on any story — it crystallizes the action chain, governs reporting emphasis, and often becomes the lead.

## When to use

- Reporter has an idea and needs to test whether it holds before reporting
- Reporter has finished reporting and can't determine what the story adds up to
- Editor needs a pitch summary that accurately describes the story's movement
- Draft is unfocused and the underlying action chain needs to be surfaced

## When not to use

- A theme statement already exists and the work is story organization → use the six-part guide or narrative lines skill instead
- The request is copy editing, headline writing, or general writing feedback
- The reporter wants structural help with a story whose central argument is already clear

## First move

**Determine mode before doing anything else.**

Ask exactly one question if unclear:

> "Do you have reporting in hand, or are you still figuring out what to go get?"

- **Yes, I have reporting** → Analytical mode. Run `references/analytical-mode.md`.
- **No, still early** → Interactive mode. Run `references/interactive-dialogue.md`.

## Non-negotiables

- The finished theme statement must contain movement: something causing something else. "X is happening" is a topic, not a theme statement. Minimum: development + one consequence. Ideal for a mature story: development + consequence + countermove.
- No details — no names, numbers, or specifics. Those belong in the story, not the map.
- The statement must honestly reflect story stage: juvenile (the development itself is news) or mature (the development is known; effects or countermoves are the story). See `references/juvenile-vs-mature.md`.
- If the idea can't survive cause-and-effect scrutiny, say so before drafting anything.

## Output format

Return four things:

1. **Theme statement** — 2-3 sentences, plainly written, no jargon. Set it apart visually so it reads as a finished artifact.
2. **Reporting implication** — one or two sentences stating what the theme statement requires the reporter to prove or document, and what it allows them to treat as given.
3. **Gap list** — always required, not only in analytical mode. What the current material can't yet support that the theme statement claims. Three to five items, ranked by consequence: dealbreakers first, nice-to-haves last.
4. **QA summary** — a brief table of what was checked and what flagged, followed by one specific question the human must answer before proceeding to hypothesis formation.

Format the QA summary as:

```
## QA Summary

| Check | Result | Note |
|-------|--------|------|
| Statement contains movement (development + at least one consequence) | PASS / FLAG | |
| No details — no names, numbers, or specifics in the statement | PASS / FLAG | |
| Story stage correctly identified (juvenile or mature) | PASS / FLAG | |
| Central development survives cause-and-effect scrutiny | PASS / FLAG | |
| Gap list contains at least one item | PASS / FLAG | |
| Dealbreakers (if any) explicitly labeled | PASS / FLAG | |

**Before proceeding:** [One specific question — e.g., "Does this theme statement describe the story you want to pursue, or does [gap] change the framing?"]
```

FLAG means the check did not pass cleanly. If any dealbreaker gaps exist, flag them prominently — they must be resolved or acknowledged before hypothesis formation runs.

## Reference map

- `references/interactive-dialogue.md` — staged question sequence for early-stage ideas
- `references/analytical-mode.md` — how to extract a theme statement from existing material, including the six-category sort and gap list
- `references/juvenile-vs-mature.md` — how story stage changes what the theme statement should stress, including mixed cases
- `references/worked-examples.md` — annotated Blundell examples, structural skeleton first
