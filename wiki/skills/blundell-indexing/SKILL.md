---
name: blundell-indexing
description: "Organize post-reporting material by sorting every interview and document fragment into Blundell's six-part categories using a shorthand coding system. Converts a formless heap of notes into an ordered picture of what you have, what it says, and what's missing. Invoke when the user has finished reporting and needs to organize before writing. Triggers on: 'I have all my notes and don't know where to start', 'help me organize my reporting', 'index my notes', 'I have too much material', 'I don't know what I have'. Do NOT invoke for story structure or section ordering — use blundell-narrative-lines after indexing is complete."
allow_implicit_invocation: false
---

# Blundell Indexing

Based on William E. Blundell, *The Art and Craft of Feature Writing* (1988). Indexing is the pick-and-shovel phase of organization: sorting every fragment of reporting into the six-part categories so you can see what you have, what it says, and what's still missing — before you write a word.

Blundell: "I hate doing it. I do it anyway because I hate even more what happens when I don't. Confusion happens. Multiple drafts happen."

## When to use

- You have finished reporting and face a pile of notes, transcripts, and documents
- You have too much material and no clear story shape
- You're about to start writing but feel uncertain about what you actually have
- You want to identify gaps before writing reveals them at cost

## When not to use

- Reporting isn't done yet → use `blundell-six-part-guide` to identify what to go get
- The story is simple enough (one source, one document, clear thread) that indexing would cost more than it saves
- You're ready to order sections and choose structure → use `blundell-narrative-lines` after indexing

## Two sub-modes

**Index it for me**: Paste interview notes, transcripts, or document excerpts. I apply the coding system and return a structured index by category, noting the nature of each entry (quote, observation, figure, illustration).

**Teach me the system**: You want to do it yourself. I explain the coding method with the worked example and send you off.

Ask which the reporter wants before starting: "Do you want me to index your material, or would you prefer to learn the system and do it yourself?"

## Non-negotiables

- Organize by story aspect, not by source. The same interview may appear under three categories. This is correct.
- Multi-use material gets logged in multiple categories. A quote addressing both scope and reasons gets two entries.
- History is the exception: don't force it into one block. Log history entries wherever they appear in the material; they'll be sprinkled in the writing rather than clumped.
- The categories with many entries are the story's spine. Categories with few or no entries are either reporting gaps or sections that don't belong in this story — figure out which.
- The index is a writing tool, not an archive. Write off the index; check original sources only when you need to verify exact wording.

## Output format

**Index it for me**: A structured index organized under the six headings, with each entry coded by source and content type. Followed by a category summary (2-3 sentences per category): what's there, what's thin, what's empty, and what each gap implies for the story.

**Teach me the system**: Explanation of the coding system, the worked example from the Indian water rights story, and the three things to do with the finished index.

Then return a **QA summary** as the final section:

```
## QA Summary

| Check | Result | Note |
|-------|--------|------|
| All six categories present or explicitly noted as empty | PASS / FLAG | |
| Multi-use material logged in multiple categories | PASS / FLAG | |
| History distributed (not clumped in one block) | PASS / FLAG | |
| Categories with few/no entries assessed: gap vs. section-doesn't-apply | PASS / FLAG | |
| Category summary is honest (thin/empty noted, not glossed) | PASS / FLAG | |

**Before proceeding:** [One specific question — e.g., "Does the thin coverage in [category] represent a reporting gap to close before writing, or a deliberate choice to leave that section out?"]
```

## Reference map

- `references/coding-system.md` — the shorthand codes with examples
- `references/worked-example.md` — the Indian water rights interview fully annotated
- `references/what-to-do-with-the-index.md` — how the index feeds into narrative line selection and writing
