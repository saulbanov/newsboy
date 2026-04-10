# Router Plan — Reporting OS
*Generated: 2026-04-10 | Status: Working draft*

---

## What the Router Is

A lightweight entry-point layer that sits before everything else. Every input to the system — regardless of source or format — passes through the router before anything runs. The router's job is two things in sequence:

1. **Normalize** — strip the mess, identify the source, extract the signal into a common intermediate format
2. **Classify** — take that normalized input and produce a structured routing decision

These are separate steps. The normalizer handles the diversity of input surfaces. The classifier works from the normalized format every time, regardless of where the input came from.

The router does no work beyond these two steps. It directs traffic. Everything else runs downstream.

---

## The Two-Step Design

### Step 1: Normalization

Every input source gets a normalization handler. Each handler knows what its source looks like and produces the same intermediate format.

**Intermediate format:**
```json
{
  "source": "human-cli | human-interface | scanner | pipeline-alert | synthesis-alert",
  "raw": "...",
  "extracted": {
    "intent": "...",
    "entity": "...",
    "context": "...",
    "structured_fields": {}
  },
  "normalization_confidence": "high | low",
  "normalization_notes": "..."
}
```

**Known sources and their handlers:**

| Source | What it looks like | Handler approach |
|--------|-------------------|-----------------|
| Human CLI | Freeform text typed into terminal or Claude Code | LM extraction — intent, entity, any context clues |
| Human interface | Freeform text from future cursor bar or dashboard | Same as CLI, different surface tag |
| Scanner output | Structured machine package — entity, confidence score, suggested priority, beat tags | Field extraction — no LM needed |
| Pipeline alert | Internal flag from within a running stage — blocked, anomaly, ready-to-pitch | Parse alert type and stage origin |
| Synthesis alert | Pattern or contradiction surfaced by Synthesis Layer | Parse alert type, affected machines, confidence |

If normalization confidence is low — input is ambiguous, source is unclear, extraction is uncertain — the router surfaces the ambiguity to the human before proceeding. One question. One decision. No guessing.

---

### Step 2: Classification

Takes the normalized intermediate format and produces a routing decision.

**Routing decision format:**
```json
{
  "mode": "story | investigation | augmentation",
  "machine": "pipeline | scanner | amplification | synthesis",
  "entry_point": "0a | investigation-intake | augmentation-intake | ...",
  "confidence": "high | low",
  "ambiguity_note": "..."
}
```

Classification is a lightweight LM call — cheap, fast, haiku-class model. It works from the normalized intermediate format, not the raw input.

If classification confidence is low, router surfaces options to the human: "This looks like it could be a story commission or an investigation declaration. Which did you mean?" One question. One decision.

---

## What the Router Does Not Do

- Does not execute any pipeline work
- Does not read skill files or reference docs
- Does not make editorial judgments
- Does not store state beyond the routing log
- Does not know anything about the content of what it's routing — only the shape and intent

---

## Routing Log

Every routing decision logs to `wiki/system/routing-log.md`:

```markdown
## [timestamp]
**Source:** [source type]
**Raw input:** [summary, not full text if long]
**Normalized:** [extracted intent + entity]
**Decision:** [mode] → [machine] → [entry point]
**Confidence:** [high | low]
**Notes:** [ambiguity notes if any]
```

Two purposes: debugging when something routes incorrectly, and eventual training signal for improving normalization and classification.

---

## Integration with runner.sh

Primary interface becomes:
```bash
./runner.sh "<freeform input or piped structured input>"
```

Runner calls the router first. Router returns a structured decision. Runner invokes the correct entry point.

Direct stage invocation still works for manual control:
```bash
./runner.sh --direct <stage> <slug>
```

This bypasses the router entirely. Useful during development and debugging. Not for production use.

---

## Scanner Output as a Special Case

When the Scanner exists, it produces structured question packages. The normalization handler for Scanner output bypasses LM extraction entirely — fields are parsed directly from the package structure. The classifier still runs, but with high-confidence normalized input, so it should almost always produce a high-confidence routing decision without needing human confirmation.

Scanner packages should include a suggested mode field (story | investigation) based on the Scanner's own confidence scoring. The classifier treats this as a strong prior but can override it.

---

## Build Timing

The router is the **last thing added** to the system, not the first. You don't need it until you have more than one mode running. Build it after:

- Story mode is working end-to-end
- Investigation mode intake exists
- At least one non-CLI input surface exists

Before then, manual stage invocation via `--direct` is sufficient.

---

## Open Questions

- Should normalization handlers be separate scripts or a single script with source detection?
- How does the router handle inputs that arrive asynchronously (Scanner running in background, Synthesis alert firing overnight)?
- What happens if the router is called with a Pipeline alert mid-run — does it interrupt the current session or queue?
- See `input-surface-map.md` for unresolved questions about what input surfaces actually look like
