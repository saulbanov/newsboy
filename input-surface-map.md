# Input Surface Map — Problem Space
*Generated: 2026-04-10 | Status: Open questions, not a plan*

---

## What This Document Is

This is not a plan. It is a map of an unsolved problem.

The reporting OS receives inputs from multiple surfaces that look different from each other. Before the input layer can be designed, these surfaces need to be named, their formats need to be understood, and the gaps need to be acknowledged. This document does that. It does not pretend to have answers where there aren't any yet.

---

## What We Know

### There are at least four input surfaces

**1. Human CLI**
A person typing into a terminal or Claude Code. Freeform natural language. This exists now. It's what runs newsboy today.

**2. Human interface (future)**
Some kind of cursor bar, dashboard, or web interface. Also freeform natural language, probably. This does not exist yet. What it looks like is unknown — see open questions.

**3. Scanner output (future)**
Machine-generated. Structured. The Scanner identifies something worth surfacing and produces a package. What that package looks like structurally is not yet designed — see open questions.

**4. Internal pipeline alerts**
Generated from within a running pipeline stage. A stage flags: blocked, anomaly detected, ready-to-pitch, gate rejected. These exist implicitly in runner.sh today (error messages, exit codes) but are not structured as router-readable inputs.

**5. Synthesis Layer alerts (future)**
The Synthesis Layer surfaces a pattern, contradiction, or anomaly across data streams. What this looks like structurally is unknown — Synthesis Layer itself is not yet designed.

### Inputs arrive at different times

Some inputs are synchronous — a human types something and waits for a response. Some are asynchronous — the Scanner runs overnight and produces a package while no human is present. Some are event-driven — a pipeline stage hits a blocker and raises an alert mid-run.

The router has to handle all three timing modes. How it handles asynchronous and event-driven inputs is not yet designed.

### Inputs carry different levels of structure

| Surface | Structure level | LM needed to parse? |
|---------|----------------|---------------------|
| Human CLI | None — freeform | Yes |
| Human interface | None — freeform | Yes |
| Scanner output | High — machine generated | No (field extraction) |
| Pipeline alert | Medium — typed errors and flags | Maybe |
| Synthesis alert | Unknown | Unknown |

---

## What We Don't Know

### About Scanner output
- What does a Scanner package actually look like? Fields, format, confidence scoring?
- Does the Scanner suggest a mode (story vs. investigation) or leave that to the router?
- How does the Scanner deliver its output — write to a file, call runner.sh, push to a queue?
- What happens if the Scanner produces multiple packages simultaneously?

### About internal pipeline alerts
- What alert types exist beyond "blocked" and "ready-to-pitch"?
- Do alerts interrupt a running session or queue for the next session?
- Who sees the alert — the human immediately, or the router first?
- What information does an alert carry — just the flag, or context about what caused it?

### About the human interface
- What does the human actually use day-to-day? Terminal? A web dashboard? Slack? Something else?
- Is there one interface or multiple depending on mode (story vs. investigation vs. augmentation)?
- Does the interface pre-structure input (dropdowns, mode selection) or is it always freeform?
- How does a non-Saul reporter enter the system — same interface, different credentials, different view?

### About augmentation mode triggering
- Does augmentation mode get explicitly invoked ("help me report on X") or does it get inferred from context?
- If a human is mid-investigation and drops in a document, does that automatically trigger augmentation mode?
- How does the system know the difference between "I'm asking a question" and "I'm starting an augmentation session"?

### About asynchronous inputs
- When the Scanner or Synthesis Layer produces output while no human is present, where does it go?
- Is there a queue? A notification? Does it wait until the human opens a session?
- How does the human get notified — email, Slack, dashboard indicator?

---

## What Needs To Be Decided Before The Input Layer Can Be Designed

In rough order of dependency:

1. **What does the human actually use?** The primary human interface determines the shape of human inputs. This is a product decision, not a technical one. Answer this first.

2. **What does a Scanner package look like?** The Scanner's output format determines the normalization handler for machine inputs. Can't design that handler without knowing the format. Design Scanner output format when Scanner design begins.

3. **How are asynchronous inputs delivered?** File write, queue, push notification — this determines the runtime architecture of the router. Needs a decision before router is built.

4. **What alert types does the pipeline produce?** Audit runner.sh for all current exit conditions and error states. These become the pipeline alert taxonomy. This can be done now.

5. **How does augmentation mode get triggered?** Explicit invocation vs. inferred from context. This is a UX decision that affects normalization logic. Needs a decision before augmentation mode is built.

---

## Parking Lot

- Multi-reporter scenario: if two reporters are using the system simultaneously, do their inputs share a router or does each get an isolated instance?
- Mobile input surface: is there ever a scenario where input comes from a phone (voice memo, quick note)?
- Webhook inputs: could external systems (a tip line, a FOIA tracker) push inputs into the system directly?
- Priority handling: if the Scanner produces a high-confidence Tier 1 package while a human is mid-session on something else, what happens?

---

## How To Use This Document

When designing any component that touches input — the router, the Scanner, the human interface, augmentation mode — read this document first. Add to the "what we know" section as decisions get made. Move items from "what we don't know" to "what we know" as they get resolved. This document is done when every open question has an answer and the input layer has been designed.
