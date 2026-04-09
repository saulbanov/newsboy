---
name: blundell-story-analyst
description: "Read a published story and extract its implicit cause-effect chain using Blundell's framework, then extend that chain forward to identify unreported developments, reporting gaps, and follow-on story opportunities. Invoke when the user pastes or links a published article and wants to know what's missing, what follows, or what stories it implies. Triggers on: 'analyze this story', 'read this article', 'what did they miss', 'what are the follow-on stories', 'map the chain in this piece', 'what gaps did this reporter leave'. Do NOT invoke for summarizing, fact-checking, rewriting, or critiquing the quality of a story's prose."
allow_implicit_invocation: false
---

# Blundell Story Analyst

## What this skill does

Takes a published story and runs two passes against Blundell's cause-effect framework:

1. **Extraction** — reverse-engineers the story's implicit map: what development is established, what effects are documented, what countermoves appear, what constituencies are present or absent, what stage the story is at (juvenile or mature).

2. **Projection** — extends the chain forward from where the story stops: what effects follow logically, what countermoves are implied but unshown, what constituencies are affected but uncontacted, what the next stories are.

Output is a story map plus a ranked pipeline of unreported chain elements.

## When to use

- Assessing what a competitor's story left unreported — and which follow-on stories they're likely working vs. which they missed
- Generating follow-on story ideas from your own published work
- Evaluating whether a press release, wire story, or trade piece contains a real development worth pursuing
- Spotting mature stories in specialized coverage that haven't crossed into general-interest journalism yet
- Running automated signal evaluation: does this data represent a development already covered, or a gap?

## When not to use

- You want a summary of what the story says → just read it
- You want to fact-check specific claims
- You want writing or editing feedback on the story's craft
- You want to know if the story's argument is correct — this skill maps structure, not truth

## First move

Read the full story text before doing anything. Do not skim. The extraction pass depends on identifying what is *present but understated* as much as what is *explicitly stated* — countermoves often appear briefly; scope is sometimes implied rather than documented.

Then run extraction before projection. Projecting from a misread map produces bad questions.

## Non-negotiables

- **Distinguish documented from implied.** The extraction pass must mark what is explicitly in the story vs. what can be reasonably inferred. These are different confidence levels and must be labeled.
- **Distinguish probable from speculative in projection.** Chain extensions must be ranked by likelihood. "Near-certain if development is real" is different from "possible but may not have materialized." Conflating them produces noise.
- **Name constituencies.** The most common gap in published stories is not missing effects — it's missing *people*. Who is affected but absent from the story? Name them specifically.
- **Assess story stage honestly.** A juvenile story's gaps are different from a mature story's gaps. See `references/story-stage-assessment.md`.
- **Don't invent.** Projection must follow logical cause-and-effect from what is established. Flag when an extension requires assumptions not supported by the story.

## Output format

Return four sections, kept tight:

**1. Story map** — one paragraph: central development, story stage, documented effects, documented countermoves, constituencies present.

**2. Structural gaps** — bullet list, 3-5 items: what Blundell categories are thin or missing *within the reported story* and why each matters.

**3. Chain extensions** — labeled list of unreported elements that logically follow, each marked:
- `near-certain` — almost certainly exists if the development is real; high priority
- `probable` — likely given time and scale; worth a check call
- `speculative` — logical but may not have materialized; hold until there's evidence

**4. Story pipeline** — 2-3 entries max. Each: a Blundell theme statement for the follow-on story (development + effect + countermove where possible), plus one line on what reporting would confirm it and what sources would have that information.

## Reference map

- `references/extraction-guide.md` — how to read a story for its implicit map, including signals for understated elements and the constituency audit
- `references/projection-guide.md` — how to extend the chain, confidence labeling, distinguishing gaps from follow-on stories
- `references/story-stage-assessment.md` — how to determine juvenile vs. mature from a published piece, and what each stage implies about gaps
- `references/pipeline-output.md` — how to construct follow-on theme statements, rank the pipeline, and use it as a competitive tool
