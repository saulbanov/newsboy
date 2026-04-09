---
name: blundell-high-interest-elements
description: "Filter story material using Blundell's reader-interest hierarchy to identify what earns its place and what should be cut or substituted. Use at any stage — idea selection, reporting, or editing a draft. Invoke on: 'is this story interesting enough', 'my editor says this is dull', 'I have too many experts', 'how do I make this less dry', 'audit my draft for reader interest', 'I rely too much on statistics'. Do NOT invoke for story structure or lead construction — use blundell-narrative-lines or blundell-leads."
allow_implicit_invocation: false
---

# Blundell High-Interest Elements

Based on William E. Blundell, *The Art and Craft of Feature Writing* (1988). The reader-interest hierarchy is Blundell's ranking of story material by how much readers actually engage with it — from highest to lowest. Most journalism problems with dull, unconvincing copy trace back to getting this hierarchy wrong.

## When to use

- Assessing a story idea's inherent interest before committing to report it
- Auditing a draft that an editor has called dull, thin, or unconvincing
- Planning what kinds of material to prioritize in reporting
- Identifying where a draft leans too heavily on experts, observers, or numbers

## When not to use

- The question is story structure → use `blundell-narrative-lines`
- The question is specifically about the lead → use `blundell-leads`
- The question is what to report, not what to prioritize → use `blundell-six-part-guide`

## Two modes

**Planning/idea assessment**: Forecast the interest level of a story idea by asking what kinds of material it's likely to generate. Flag sections likely to rely on observers and numbers. Identify where actors and action could be found.

**Draft audit**: Read the material and flag by interest level. Identify observer substitutions, number stacks, and generalized effects without illustration. Return specific substitution suggestions. Keep the audit to the most significant problems — 5-8 flagged passages maximum, not a line-by-line annotation.

## The hierarchy

In descending order of reader interest:
1. Action with built-in movement (development → effects → countermoves)
2. People/Actors — those pressing buttons, pulling levers, or getting ground up
3. Facts that are relevant and move the story forward
4. People/Observers — analysts, consultants, experts who only comment
5. Numbers, especially stacked in consecutive paragraphs

The most important distinction is between levels 2 and 4. Most reporters know to include people. Few understand that the *type* of person matters enormously. See `references/actor-observer.md`.

## Non-negotiables

- The actor/observer substitution is the most common and most damaging reader-interest failure. Flag every observer quote and ask: is there an actor who could say or show this instead?
- Facts earn their place only when relevant *and* moving the story forward. Trivia and tangential facts are filler covering story flaws — a lack of action, direct human experience, or clear theme.
- Numbers: never stack them in consecutive paragraphs. Round when precision doesn't matter. Translate large numbers into ratios or visual equivalents. If a number matters, give the reader a way to picture it.
- The dog rule is not a joke. Built-in movement (something happening, having effects, generating response) outperforms analytical intelligence regardless of intellectual importance. Stories with action in them cover sins of execution that static analytical pieces cannot survive.

## Output format

**Draft audit**: Flag the 5-8 highest-priority problems, each with: the passage, the specific issue (observer substitution / number stack / generalized effect / etc.), and a concrete substitution suggestion. End with the three most important changes ranked by impact.

**Planning assessment**: Interest-level forecast by story section. Which sections have strong actor potential, which are likely to rely on observers, which will require careful number handling.

Then return a **QA summary** as the final section:

```
## QA Summary

| Check | Result | Note |
|-------|--------|------|
| Actor/observer substitution failure checked (most common failure) | PASS / FLAG | |
| Number stacks identified and flagged | PASS / FLAG | |
| Output capped at 5-8 items (not exhaustive line annotation) | PASS / FLAG | |
| Three most important changes ranked by impact | PASS / FLAG | |
| Every flag includes a specific substitution suggestion (not just "add actors") | PASS / FLAG | |

**Before proceeding:** [One specific question — e.g., "Of the flagged items, which are you most uncertain about — the ones most likely to need a reporting trip rather than a rewrite?"]
```

## Reference map

- `references/hierarchy.md` — the five levels with full Blundell treatment of each
- `references/actor-observer.md` — the substitution failure pattern and how to correct it
- `references/numbers.md` — density, rounding, ratios, visual equivalents, the stacking rule
