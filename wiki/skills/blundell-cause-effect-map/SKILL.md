---
name: blundell-cause-effect-map
description: "Map a journalism story idea as a cause-and-effect chain before reporting begins, then fence it to a scope that can actually be covered. Use before reporting to avoid the two classic range errors: thinking too small (development exhausted in two pages) or too big (trying to cover too much to do any of it well). Invoke on: 'help me scope this story', 'I have a story idea', 'is this story too big', 'what are all the angles on this', 'I don't know where to start reporting', 'help me think through this'. Do NOT invoke after reporting is underway — use blundell-six-part-guide or blundell-indexing instead."
allow_implicit_invocation: false
---

# Blundell Cause-Effect Map

Based on William E. Blundell, *The Art and Craft of Feature Writing* (1988). The cause-effect map is how Blundell scopes stories before reporting: treat the central development as a cause, generate its logical effects, treat each effect as a cause of further effects, then draw a fence around the portion that can actually be reported.

The map serves exclusion as much as inclusion. Its purpose is to let you decide what to leave out before you waste time on it.

## When to use

- You have a story idea and don't know where to start or where to stop
- Your editor says the story is too big or too vague
- You're not sure which angle is the real story
- You want to identify reporting priorities before going into the field

## When not to use

- Reporting is already underway → use `blundell-six-part-guide` for planning remaining gaps
- You have material in hand → use `blundell-indexing` to organize it
- You have a theme statement and are ready to structure → use `blundell-narrative-lines`

## First move

Ask: what is the central development — the thing that is happening or has happened, stated as a plain verb sentence? If the reporter can't answer in one sentence, the idea isn't ready to map yet. Push until you have it.

If they genuinely can't produce a development sentence after a few exchanges, stop and name the problem: they have a topic, not a story. The map can't be built until a development exists.

## Non-negotiables

- Only action and reaction count in the map. No details, explanations, or context. The map is a skeleton of events causing events.
- The map is a hypothesis, not a contract. Events, not preconceptions, shape the final story. Flag the map as a starting point, not a reporting assignment.
- Apply three scrutiny tests to every remote element before including it: Has it had time to materialize? Could external forces have disrupted the logic? Is there early evidence it exists? See `references/scrutiny-tests.md`.
- Name constituencies — the interest groups and institutions touched by the development. The obvious ones are never all of them.
- The fence is the deliverable. A map without a fence is just a list. The fence is the decision about which portion of the chain this reporter can cover in the time and space available.

## Output format

Return four things:

1. **The map** — a chain of developments linked by cause and effect, branching where the logic branches. Keep it tight: events only, no prose explanation.
2. **The fence** — a clear statement of which portion of the map this story covers, and why that portion was chosen over others.
3. **Remote elements to watch** — chain elements outside the fence worth monitoring. Label each `near-certain`, `probable`, or `speculative` using the scrutiny tests.
4. **QA summary** — a brief table of what was checked and what flagged, followed by one specific question the human must answer before proceeding to the theme statement.

Format the QA summary as:

```
## QA Summary

| Check | Result | Note |
|-------|--------|------|
| Development sentence is a single plain verb sentence | PASS / FLAG | |
| Map branches (not a single chain) | PASS / FLAG | |
| Fence is explicit — states what is in and what is out | PASS / FLAG | |
| Fence justification given | PASS / FLAG | |
| All remote elements labeled near-certain / probable / speculative | PASS / FLAG | |
| Constituencies named beyond the obvious | PASS / FLAG | |

**Before proceeding:** [One specific question for the human — e.g., "Is the fence in the right place, or should [element] be inside it?"]
```

FLAG means the check did not pass cleanly and warrants human attention. PASS means it passed. If any check is FLAG, note why in the Note column.

## Reference map

- `references/failure-modes.md` — too-small and too-big, with diagnostic signals for each
- `references/scrutiny-tests.md` — time, distance, constituencies: how to assess remote chain elements
- `references/mapping-method.md` — step-by-step method for building the chain and drawing the fence
