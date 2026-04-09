---
name: pitch-gate
description: "Evaluate a story idea at the commissioning threshold — does this story exist, is it provable, and is it worth telling? Run after blundell-theme-statement produces a theme statement and the reporter has assembled initial evidence. Output is commission, kill, or needs-more with specific reasoning. Do NOT use mid-reporting or after a draft exists — this gate runs once, before reporting begins."
allow_implicit_invocation: false
---

# Pitch Gate

The single most consequential gate in the pipeline. Everything downstream of a bad commissioning decision is wasted work. This skill plays the editor who says no.

## What this skill does

Reads the theme statement and initial evidence and asks one question: **is this actually a story, and can it actually be proved?**

It is not here to help develop the story. The Blundell suite does that. This skill's job is to kill bad commissions before they consume reporting time and tokens.

## What it sees

- The theme statement (from blundell-theme-statement)
- Initial evidence: sources, documents, tips, data — whatever prompted the question
- Nothing else. No research artifact. No notes. No enthusiasm from the reporter.

## Two failure modes to catch

**1. The exciting unprovable claim.**
A single tantalizing finding that hasn't been independently verified and may not hold up. The story exists only as long as you don't look hard at it. Signal: the evidence rests on one source, one document, or one claim that hasn't been corroborated. The reporter is excited; the foundation is thin.

Test: *What is the minimum evidence required to publish this? Does it currently exist, or is it merely achievable if everything goes right?*

**2. The improperly focused theme statement.**
The story may be real but framed in a way that can never converge — too broad, too abstract, or requiring proof of something unprovable. Eats reporting time without producing a publishable story.

Test: *Can the theme statement's central claim be documented with specific, obtainable evidence? Or does proving it require proving everything at once?*

## Adversarial posture

Assume the story does not exist until demonstrated. The reporter's job is to prove it does. Default position is skepticism, not encouragement.

This is not hostile — it's protective. A story that fails this gate fails here, not after a week of reporting.

## Output: one of three verdicts

**Commission** — theme holds, evidence is sufficient or clearly obtainable, central claim is provable. State specifically what the reporting must establish.

**Needs more** — story may exist but the evidence base is too thin to commit. State exactly what is missing and what would justify a commission.

**Kill** — theme statement is unprovable as framed, or evidence does not support the central claim. State why, and whether a different angle on the same territory might be commissionable.

## Non-negotiables

- Never commission a story whose central claim rests on a single unverified source.
- Never commission a theme statement that requires proving an unfalsifiable claim.
- A "needs more" is not a soft commission. It means: do not report until this gap is closed.
- Do not suggest story development. That is not this skill's job. Route back to blundell-cause-effect-map or blundell-theme-statement if the framing needs work.
- State the reasoning for every verdict. "This feels thin" is not a verdict. "The central claim requires X, and the evidence currently provides only Y" is a verdict.

## First move

Read the theme statement. Then ask: what would have to be true for this story to be publishable? Then check whether the initial evidence establishes any of it.
