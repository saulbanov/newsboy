# Future Heist Reporting OS — Architecture North Star
*Generated: 2026-04-09 | Status: Working draft*

---

## READ THIS FIRST (for Claude)

Before doing anything else, orient yourself:

1. Look at the directory where this file lives.
2. Determine: is this file at a project root that contains multiple machine directories (Scanner, newsboy, etc.)? Or is it sitting inside a single project directory (e.g., newsbot-master-plan)?
3. Check whether a root-level `AGENTS.md` already exists one level up.
4. State in two sentences: where this file currently lives, and what the right home for it is given what you find.

Then ask the user: "Here's what I found — [what you found]. Here's where I think this should live — [your recommendation]. Want me to move it and set up the directory structure, or keep it where it is for now?"

Do not restructure anything without explicit confirmation.

---

## What This Document Is

This is the north star for the Future Heist Reporting OS — a five-machine system that takes questions and beats and produces stories, insight, and organized action. It is not a blueprint. It is not a todo list. It is a map: here are the machines, here is how they connect, here are the principles that govern all build decisions.

Every Claude session working on any part of this system should read this document first. It prevents local optimization that breaks the bigger picture.

---

## The Five Machines

```
[ SCANNER ] ──► [ NEWSROOM PIPELINE ] ──► [ AMPLIFICATION LOOP ]
      ▲                   ▲                         │
      │                   │                         │
      └──────────[ SYNTHESIS LAYER ]◄───────────────┘
                          ▲
               [ PRIVATE RESEARCH LAYER ]
               (reporter's own material)
```

**Machine 1 — The Scanner**
Reads the world continuously. Monitors public data streams: feeds, filings, social, regulatory databases. Surfaces questions worth investigating. Outputs structured question packages.

Two lanes: priority-match (what advances current investigations?) and novelty-discovery (what's emerging that isn't on the list yet?).

*Status: Not yet built.*

**Machine 2 — The Newsroom Pipeline**
Takes questions and processes them into published stories. Runs in two modes: story mode (sprint, days) and investigation mode (ambient watch, weeks to months).

*Status: Built as newsbot-master-plan. Needs structural refactor — see `refactor-plan.md`.*

**Machine 3 — The Amplification Loop**
Tracks what lands after publication. Who amplified it, what questions it generated, what corrections came back. Feeds signal back into the Scanner.

*Status: Not yet built.*

**Machine 4 — The Private Research Layer**
The reporter's own gathered material: notes, interviews, documents, datasets, FOIA requests. Not public. Not searchable from outside. Fed in by the reporter; read by the Synthesis Layer and available to augmentation mode.

*Status: Not yet built. Directory stubs should exist in newsboy. Architecture must accommodate from the start.*

**Machine 5 — The Synthesis Layer**
The nervous system. Runs continuously across all other machines. Reads everything against everything else: public vs. public, private vs. public, private vs. private, old vs. new. Surfaces contradictions, confirmations, patterns, and gaps. Not a pipeline stage — an always-on background operation.

*Status: Not yet built. Most complex subsystem. Build last.*

---

## Operating Modes

Three reporter-facing modes. Same machines, different gates and timing.

**Story mode** — "I want to publish a story about X."
Human commissions. System runs pitch → research → draft → edit → publish. Three human gates: pitch, draft, clearance. Everything else runs silently. Sprint. Days.

**Investigation mode** — "I want to follow X over time."
Human declares intent. System creates research agenda, monitors defined channels on schedule, logs findings, surfaces alerts only when something material changes. Ambient. Weeks to months. When signal accumulates, system flags ready-to-pitch and investigation feeds into story mode.

**Augmentation mode** — "I'm actively reporting on X. Help me."
Human is in the field. System reads incoming material, cross-checks against existing findings, surfaces what human might miss, prompts for gaps. Real-time dialogue. Human stays in the captain's chair throughout.

---

## Data Layers

**Public layer:** Open web, public APIs, regulatory databases, social media, news feeds. Available to all modes. Scanner handles this layer when built.

**Private layer:** Reporter's own gathered material — notes, transcripts, documents, datasets. Fed in by the reporter. Primary input for augmentation mode. Lives in `wiki/private/`.

**Cross-layer synthesis:** The Synthesis Layer reads public against private. Surfaces contradictions between the record and your notes, patterns across independent sources, gaps in the public record, anomalies that appear privately but have no public trace. This is Machine 5. Build last.

---

## Architectural Principles

**1. Methodology is a plugin, not a skeleton.**
The pipeline architecture is neutral. Blundell is one methodology currently occupying the reference layer. It can be swapped, tested against alternatives, or run in parallel for A/B comparison — without touching pipeline stages, routing logic, or information isolation rules. Same applies to research tools, LM providers, output channels, and gate logic. The pipeline is the skeleton. Everything else is a modular attachment. Never hardcode methodology into a prompt — inject it as a reference.

**2. Human in the captain's chair.**
This is a capacity expansion tool, not a delegation tool. The reporter commissions, approves, and redirects. The system executes, monitors, and surfaces. Real judgment calls stay human.

**3. Information isolation is mechanical, not behavioral.**
Each pipeline stage sees only the information it's supposed to have. Enforced by the runner, not by Claude's discipline. Contaminating a stage with upstream context defeats its purpose.

**4. The system learns from behavior, not instruction.**
Every human gate decision logs automatically. Pattern extraction runs periodically. Taste profile updates are proposed and approved — not manually written. Skills accumulate taste overlays without changing core logic.

**5. Build sequence follows value.**
Machine 2 (Pipeline) first — produces stories immediately.
Machine 1 (Scanner) second — feeds the pipeline autonomously.
Machine 3 (Amplification) third — closes the feedback loop.
Machine 4 (Private Research) integrated alongside — makes augmentation mode possible.
Machine 5 (Synthesis) last — requires all other machines generating signal.

**6. Not Saul-dependent.**
The system should work for any reporter using Future Heist infrastructure. Personal configuration (beat, sources, taste profile) is a modular overlay, not baked into the architecture.

---

## Recommended Directory Structure

When fully built, the project should look like this:

```
/reporting-os/                        ← project root
  AGENTS.md                           ← short session startup, links to this doc
  architecture-north-star.md          ← this file
  newsbot-master-plan/                ← Machine 2
    AGENTS.md                         ← newsbot-specific session startup
    refactor-plan.md                  ← active build doc
    MASTER_PLAN.md
    runner.sh
    prompts/                          ← stage prompt files (to be created)
    wiki/
      skills/
      stories/
      reference/                      ← methodology docs (Blundell etc.)
      private/                        ← reporter's own material (Machine 4 stub)
      synthesis/                      ← Synthesis Layer stub (Machine 5)
  scanner/                            ← Machine 1 (future)
  amplification/                      ← Machine 3 (future)
```

If the current structure doesn't match this, don't force it. Orient first, then propose changes to the user.

---

## What This Document Is Not

- Not a blueprint. Placeholders are valid. `[TBD]` is a legitimate state.
- Not a todo list. For active build tasks, see `refactor-plan.md`.
- Not finished. This is a living document. Update it when the architecture changes.

---

## Open Questions / Parking Lot

- Trending context injection (0c.7): Real-time social/news context enters before pitch gate. Design slot reserved in pipeline. Scanner output plugs in here when Scanner is built.
- Contact/source database: Investigation mode should surface relevant sources when reporter hits a block. Requires source database. Location and data model TBD.
- Database/data journalism: Can the system query structured databases (TCEQ, SEC, court records) automatically and surface anomalies? Future capability.
- YouTube/transcript monitoring: Automated transcript monitoring for source tracking. Future capability.
- Multi-reporter support: How does augmentation mode work when more than one reporter is on a story? Not yet scoped.
- Investigation mode → story mode transition: What happens when one investigation spawns multiple stories simultaneously?
