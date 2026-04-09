---
name: hypothesis-formation
description: "Take candidate cause-effect chains from blundell-cause-effect-map and convert each into a testable hypothesis with a confidence level and testability tier. Runs between cause-effect-map and blundell-theme-statement. Do NOT scope or generate new chains — that is cause-effect-map's job. Do NOT crystallize the story — that is blundell-theme-statement's job. This skill's only job is to make each chain falsifiable and label how it can be tested."
allow_implicit_invocation: false
---

# Hypothesis Formation

Takes cause-effect chains and makes them scientifically useful: falsifiable, labeled by testability, ranked by confidence.

A chain that can't be tested isn't a hypothesis — it's speculation. A hypothesis that requires a human to test when a machine could do it is a resource decision disguised as an editorial one. This skill separates those.

## What this skill sees

The output of blundell-cause-effect-map: candidate chains, ranked and scoped.

## What this skill does not do

- Does not generate new chains — cause-effect-map did that
- Does not pick the story — blundell-theme-statement does that
- Does not scope the reporting — cause-effect-map did that
- Does not evaluate newsworthiness — pitch-gate does that

## The hypothesis contract

Every chain becomes a hypothesis in this form:

**IF** [the cause-effect relationship is real]
**THEN** [specific observable evidence should exist]
**AT** [specific location — database, document, blockchain, public record, source]
**TESTABLE BY** [Tier 1: machine / Tier 2: machine + human]
**CONFIDENCE** [high / medium / low — based on how directly the evidence maps to the claim]

This is not a description of what to report. It is a prediction about what evidence exists and where to find it.

## Testability tiers

**Tier 1 — Machine-testable**
Claude + Perplexity + xai-grok can test this hypothesis by scanning publicly available sources. No human reporting required. The evidence either exists in the public record or it doesn't. Fast and cheap to test before commissioning.

Signals that a hypothesis is Tier 1:
- Evidence lives in public databases, financial records, blockchain, news archives, regulatory filings, court records
- Verification requires finding and reading documents, not interviewing people
- A negative result (evidence not found) is itself informative

**Tier 2 — Machine + human**
The machine does the scaffolding — identifies the target, maps the source network, drafts requests, analyzes documents once obtained. The human makes calls, files FOIAs, cultivates sources, goes places. Slower and expensive. Commission before testing.

Signals that a hypothesis is Tier 2:
- Evidence requires access to non-public records, confidential sources, or physical locations
- Verification requires human judgment about source credibility
- A FOIA, subpoena, or source relationship is the path to the evidence

## Confidence levels

**High** — the cause-effect relationship is strongly implied by established facts; if the hypothesis is true, the evidence should be unambiguous and locatable

**Medium** — the relationship is plausible but depends on assumptions; evidence may be partial or require interpretation

**Low** — speculative; the chain is logical but several steps removed from what's established; evidence may not exist or may be uninterpretable without additional context

## Output per hypothesis

For each chain from cause-effect-map:

```
Hypothesis [n]: [plain-language statement of the IF-THEN claim]

IF:    [the causal claim]
THEN:  [specific observable evidence that would confirm it]
AT:    [specific location or source type]
HOW:   [Perplexity search / blockchain scan / FOIA target / source call / etc.]
TIER:  [1 — machine / 2 — machine + human]
CONFIDENCE: [high / medium / low]
RATIONALE: [one sentence on why this confidence level]
```

## Ranking output

After forming all hypotheses, return a ranked list:

**Commission candidates (Tier 1, high/medium confidence):** Test these before the pitch meeting. Results inform the theme statement and pitch.

**Commission candidates (Tier 2, high confidence):** Strong enough to commission on the chain alone. Pitch-gate decides.

**Hold (Tier 2, medium/low confidence):** Chain is real but evidence path is uncertain. Park until a Tier 1 test produces supporting signal.

**Kill (any tier, low confidence + weak evidence path):** Speculation without a clear route to confirmation.

Then return a **QA summary** as the final section:

```
## QA Summary

| Check | Result | Note |
|-------|--------|------|
| Every hypothesis is falsifiable | PASS / FLAG | |
| No hypothesis restates its conclusion as evidence | PASS / FLAG | |
| Tier 1 and Tier 2 are correctly assigned (resource decision, not quality) | PASS / FLAG | |
| Confidence levels reflect the chain, not the evidence availability | PASS / FLAG | |
| At least one Tier 1 hypothesis exists (machine-testable before pitch) | PASS / FLAG | |
| Dependency chain is explicit (what blocks what) | PASS / FLAG | |

**Before proceeding:** [One specific question — e.g., "Are the Tier 1 hypotheses strong enough to run before the pitch, or does [hypothesis] need to be reframed first?"]
```

FLAG any hypothesis that required a judgment call about falsifiability or tier assignment — the human should know where the close calls were.

## Non-negotiables

- Every hypothesis must be falsifiable. "Someone with inside knowledge placed the trade" is not falsifiable. "The March 22 and April 7 trades share a common clearing account, which would appear in CFTC records" is falsifiable.
- Tier 1 and Tier 2 are resource decisions, not quality judgments. A Tier 2 hypothesis is not better than a Tier 1 — it's more expensive. Say so plainly.
- A hypothesis that can be partially tested by machine and partially requires human work is Tier 2. Label the machine-testable component separately as a pre-commission check.
- Confidence is about the chain, not the evidence. High confidence means: if this hypothesis is true, we know what the evidence looks like. Low confidence means: even if we find the evidence, we might not be sure what it proves.
