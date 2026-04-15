# Tier Rationale — Hypothesis Testability

Tier is a **resource decision**, not a quality judgment. A Tier 2 hypothesis is not stronger than a Tier 1 — it is more expensive. Label clearly so the commission decision is made on cost, not status.

---

## Tier 1 — Machine-testable

Claude + Perplexity + xai-grok can test this without human reporting. The evidence exists in the public record or it doesn't. Cheap to run before the pitch.

**Assign Tier 1 when:**
- Evidence lives in public databases, financial records, blockchain, news archives, regulatory filings, court records, published journalism
- Verification requires reading documents, not interviewing people
- A negative result — evidence not found — is itself informative (it confirms absence of public action, clean docket, etc.)

**Tier 1 examples:**
- "CFTC enforcement docket has no public action referencing oil futures pre-announcement trading" → search the docket
- "CME Rule 432.W requires supervisory reporting of large trader activity" → read the rulebook
- "The April 8 trade was reported by financial media within 24 hours" → news archive search

---

## Tier 2 — Machine + human

The machine does the scaffolding. The human makes calls, files FOIAs, cultivates sources, goes places. Commission before testing — this costs reporter time.

**Assign Tier 2 when:**
- Evidence requires access to non-public records, confidential sources, or physical locations
- Verification requires human judgment about source credibility or document authenticity
- The path to evidence is a FOIA, subpoena, or source relationship

**Tier 2 examples:**
- "CME compliance logs show the April 8 trade triggered a surveillance alert" → internal records, not public
- "CFTC enforcement staff opened a preliminary inquiry that was closed at the deputy director level" → non-public internal decision

---

## Pre-commission checks on Tier 2 hypotheses

When a Tier 2 hypothesis has a machine-testable component — part of the claim is publicly verifiable before committing reporter time — label it explicitly:

```
**TIER:** 2 — machine + human
**PRE-COMMISSION MACHINE CHECK:** [what the machine can test right now, and what it would establish]
```

Run the pre-commission check before commissioning the Tier 2 work. A pre-commission check that returns negative may change the confidence level or kill the hypothesis before any reporter time is spent.

---

## Edge cases

**"I'm not sure whether this is Tier 1 or Tier 2"**
Ask: "Can the machine determine whether the evidence exists without a human making a request?" If yes, Tier 1. If the machine can only identify *where* to request, not confirm the existence of the evidence, it's Tier 2.

**"The Tier 1 check returned partial results"**
Partial confirmation is still a result. Note what was confirmed and what remains. Adjust confidence accordingly. A partial Tier 1 confirmation may be enough to commission the Tier 2 work.

**"This hypothesis is Tier 1 but I don't want to run it before the pitch"**
Flag the conflict. The pitch-gate non-negotiable is: no Tier 1 hypothesis may be left untested before a commission verdict. If it can be tested, test it.
