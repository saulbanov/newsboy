# Content Budget And Docs Index

Use this file when deciding what belongs inside always-on instructions, what should move out, and how to add a docs map without bloating prompt context.

## Table of contents

- Always-on budget doctrine
- Order the content by operational value
- Non-inferable detail only
- Compressed docs index pattern
- Skills plus AGENTS integration
- Anti-bloat checklist
- Source notes

## Always-on budget doctrine

`AGENTS.md` is expensive context. It rides along with work that may have nothing to do with the file itself.

Write with three assumptions:

- the agent already knows generic engineering practice
- the repo already encodes many conventions in code, config, and tooling
- the instruction budget is shared with the system prompt, conversation history, and tool results

A good `AGENTS.md` therefore prefers:

- compact rules
- exact commands
- exceptions to default behavior
- pointers to deeper docs

It rejects:

- motivational prose
- generic style opinions
- copied architecture docs
- encyclopedic reference material

## Order the content by operational value

The most reliable ordering is:

1. **Setup, build, lint, test, and typecheck commands**
2. **Definition of done**
3. **Blocked-state and escalation rules**
4. **Dangerous paths, approvals, and red lines**
5. **Docs map, skills triggers, and source-of-truth pointers**
6. **Only then: non-standard conventions that are not already enforced elsewhere**

Why this order works:

- fresh agents need runnable commands before they need philosophy
- definition of done prevents false "finished" claims
- escalation rules prevent destructive improvisation when blocked
- docs pointers tell the agent where to go next without forcing every detail into prompt context

## Non-inferable detail only

The strongest research-backed rule is simple:

Only spend `AGENTS.md` budget on information the agent is likely to miss, misinfer, or need before it can safely explore.

High-value examples:

- `pnpm test packages/payments/src/foo.test.ts`
- "Never edit generated fixtures under `src/__snapshots__` by hand"
- "Use `make dev-api` before any integration test"
- "If schema or migration changes are needed, stop and ask"
- "Docs for the deploy flow live in `docs/deploy/index.md`"

Low-value examples:

- "We value clean code"
- "This repo uses React and TypeScript"
- "Prefer readable names"
- a full inventory of directories the agent can discover with `rg --files`

## Compressed docs index pattern

When the repo has more domain knowledge than should fit in `AGENTS.md`, add a compact docs map instead of copying full docs.

Goal:

- keep durable "where to look" context always visible
- let the agent fetch deeper docs on demand

Useful pattern:

```text
[Docs Index] root: ./docs/agent
| IMPORTANT: prefer retrieval-led reasoning over guesswork
| build/: {setup.md, ci.md, release.md}
| backend/: {api-contracts.md, auth.md, workers.md}
| frontend/: {design-system.md, routing.md, testing.md}
| data/: {migrations.md, seeds.md, privacy.md}
```

Rules for good indexes:

- compress paths, not prose
- include only directories or files the agent is likely to need during real work
- add one sentence of routing advice when the docs tree is easy to misuse
- keep names stable and literal
- prefer one compact map over several overlapping mini-maps

## Skills plus AGENTS integration

`AGENTS.md` and skills should complement each other:

- `AGENTS.md` supplies always-on repo rules
- skills supply on-demand, reusable procedures

Good pattern:

- "Before changing release metadata, call `$changeset-validation`."
- "If the task is skill design, call `$skill-authoring`."
- "If the task is AGENTS authorship, call `$agents-md-authoring`."

Do not move repo-global rules into skills. Do not move large reusable procedures into `AGENTS.md`.

## Anti-bloat checklist

Cut or move content when:

- it is discoverable from standard tool output
- it is already enforced by lint, test, CI, or code review tooling
- it duplicates README or architecture docs
- it explains a whole subsystem when a pointer would do
- it contains more examples than rules
- it tries to solve multiple unrelated workflows in one always-on file

Keep content when:

- it prevents repeated failure
- it encodes a dangerous exception
- it exposes the right verification command
- it routes to the correct docs or skill
- it defines a real stop condition

## Source notes

Derived from:

- OpenAI Codex guidance on concise `AGENTS.md`
- Vercel's compressed-docs-index results and passive-context pattern
- ETH Zurich AGENTbench findings on concise human-authored context
- community anti-pattern writeups on vague, auto-generated, or overlong AGENTS files
