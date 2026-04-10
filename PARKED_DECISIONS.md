# Parked Decisions — Reporting OS
*Generated: 2026-04-10 | Status: Do not act on this document during the newsbot refactor*

---

## What This Document Is

This document preserves three bodies of architectural thinking developed in April 2026 that are not yet relevant to build. Each one has a specific trigger condition. Do not open the referenced documents or act on their contents until the trigger condition is met.

If you are currently working on the newsbot refactor, close this document and return to `REFACTOR_ADDENDUM.md`.

---

## Parked Decision 1: Five-Machine Architecture and Operating Modes

**What it is:**
A north star map of the full reporting OS — five machines (Scanner, Newsroom Pipeline, Amplification Loop, Private Research Layer, Synthesis Layer), three operating modes (story, investigation, augmentation), and the architectural principles that govern all build decisions.

**Where it lives:**
`architecture-north-star.md` at the project root.

**Trigger:**
Read this before designing any component that exists outside the current newsbot pipeline — i.e. before beginning work on Scanner, Amplification Loop, investigation mode, or augmentation mode.

**Do not use it to:**
Redesign the current newsbot pipeline. The refactor is governed by `REFACTOR_ADDENDUM.md`.

---

## Parked Decision 2: Router and Input Surface Design

**What it is:**
Two documents. A router plan describing how inputs from multiple surfaces (human CLI, future interfaces, Scanner output, pipeline alerts) get normalized and classified before anything runs. An input surface map describing what we know and don't know about those surfaces — written as a problem space, not a plan.

**Where it lives:**
- `router-plan.md`
- `input-surface-map.md`

**Trigger:**
Read both before building any of the following:
- A second operating mode (investigation or augmentation)
- Any non-CLI input surface
- The Scanner's output format

Do not build the router until story mode is working end-to-end and at least one other mode exists.

**Do not use it to:**
Add routing logic to the current newsbot refactor. The current pipeline uses direct stage invocation via runner.sh. That is correct for now.

---

## Parked Decision 3: Risk Assessment

**What it is:**
An honest accounting of nine failure modes specific to this system — hallucination treated as verified fact, source protection failure, legal exposure, competitive exposure, prompt injection, outbound communication risk, data contamination, credential exposure, and taste profile manipulation. Mitigations are assessed honestly, including where they are weak or not yet designed.

**Where it lives:**
`risk-assessment.md`

**Staged triggers — read the relevant section when:**

| Section | Read before |
|---------|-------------|
| Hallucination | Running first real story through the refactored pipeline |
| Source protection | Any real investigation material enters the wiki |
| Legal exposure | Any draft names a real person in connection with wrongdoing |
| Prompt injection | Building any automated ingestion pipeline |
| Outbound communication | Building any tool that sends messages outside the system |
| Competitive exposure | System is used by more than one person or at scale |
| Data contamination | Second story runs through the pipeline |
| Credential exposure | Tool surface expands beyond current API keys |

**Do not use it to:**
Add risk mitigations to the current newsbot refactor. The one exception: speculation markers on early-stage outputs and primary source links in the citation sheet are low-cost and worth incorporating. See `REFACTOR_ADDENDUM.md`.

---

## How This Document Gets Retired

This document is retired when all three parked decisions have been acted on and their contents have been incorporated into the relevant machine's design. At that point, delete this file and confirm each parked document has been either integrated or superseded.
