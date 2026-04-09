---
name: blundell-leads
description: "Construct or evaluate a feature story lead using Blundell's framework. Use when a reporter needs to write the lead or when an existing lead isn't working. Invoke on: 'help me write my lead', 'my lead isn't working', 'audit this lead', 'I can't figure out how to start', 'should this be anecdotal or summary'. Requires a theme statement to be useful — run blundell-theme-statement first if one doesn't exist. Do NOT invoke for story structure or section order — use blundell-narrative-lines."
allow_implicit_invocation: false
---

# Blundell Leads

Based on William E. Blundell, *The Art and Craft of Feature Writing* (1988). The lead's only job is Stage One of reader involvement: tease me. Give the reader a reason to continue rather than doing something else. The lead doesn't prove anything, doesn't explain anything, and doesn't tell everything.

## When to use

- Reporter has a theme statement and needs to write the lead
- An existing lead isn't working and needs diagnosis
- Choosing between anecdotal and general lead types

## When not to use

- Theme statement doesn't exist yet → run `blundell-theme-statement` first; the lead can't be built without knowing what the story is
- The reporter is blocked on the lead but the body isn't written yet → recommend writing the body first before attempting the lead (see Non-negotiables); this is different from having no theme statement
- The question is story structure, not the opening → use `blundell-narrative-lines`

## First move

Determine mode:
- **Audit**: reporter has a lead and wants to know if it works. Run against the four standards in `references/anecdotal-standards.md` or the general lead principles in `references/general-leads.md`.
- **Construct**: reporter needs to write a lead. Ask which type they're considering, or recommend one based on the story's nature.

## Non-negotiables

- The lead's only job is Stage One: tease and intrigue. It does not prove, explain, or summarize. The nut graf handles Stage Two (tell me what you're up to).
- The anecdotal lead is overused. Many stories would be better served by a general lead. The ease of writing an anecdotal lead is not a reason to choose it.
- Anecdotal leads fail most often on theme relevance — the example is evocative but contrary to the story's direction. This forces a 180-degree correction the reader resents.
- Fruit-salad leads — multiple unrelated details tossed together — are the most common structural failure. They signal the reporter hasn't committed to a story.
- General leads are harder to write but preserve focus-points-and-people material for the body. Don't blow the best anecdote on a lead you don't need.
- The strategic mystery principle: in general leads, deliberately omit one important element from the theme statement to force the reader forward.
- If the reporter is blocked on the lead and hasn't written the body: recommend writing the body first. The right brain delivers leads unbidden while the left brain writes prose. Forcing the lead first usually produces worse results.

## Output format

**Audit**: Verdict on lead type. Assessment against the relevant standards. Specific diagnosis of what's failing. A suggested revision. If the lead fails on theme relevance, name where the misused material actually belongs in the story.

**Construct**: Two options — one anecdotal, one general — with a brief rationale for each, plus a clear recommendation for which to try first. Let the reporter make the final call, but give them a lean.

Then return a **QA summary** as the final section:

```
## QA Summary

| Check | Result | Note |
|-------|--------|------|
| Lead anchored to theme statement (not contrary to story's direction) | PASS / FLAG | |
| Lead does not prove, explain, or summarize (Stage One only: tease) | PASS / FLAG | |
| Fruit-salad failure checked (multiple unrelated details tossed together) | PASS / FLAG | |
| Anecdotal lead (if used): assessed against all four standards | PASS / FLAG | |
| If construct mode: both anecdotal and general options provided | PASS / FLAG | |
| Recommendation given (not just options) | PASS / FLAG | |

**Before proceeding:** [One specific question — e.g., "Does this lead make you want to read the next sentence, or does it explain too much before the reader has asked?"]
```

## Reference map

- `references/progressive-involvement.md` — the four stages of reader involvement and what each demands
- `references/anecdotal-standards.md` — the four standards with failure examples
- `references/general-leads.md` — when to use, how to build from the theme statement, the mystery principle
- `references/worked-examples.md` — annotated leads from Blundell's own stories
