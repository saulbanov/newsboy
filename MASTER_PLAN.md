# Newsbot — Master Plan
*Unified architecture. Modular by design. Version 1.0 — 2026-04-09*

---

## The One-Line Summary

A question enters. A published story exits. Between them: a pipeline of AI-assisted skills, human judgment at every gate, and a system that learns from every decision you make.

---

## The Three Machines

```
[ SCANNER ] ──── question packages ────► [ NEWSROOM PIPELINE ] ──── stories ────► [ AMPLIFICATION LOOP ]
     ▲                                                                                        │
     └──────────────────────── monitoring feedback ◄──────────────────────────────────────────┘
```

**Machine 1 — The Scanner:** Reads the world continuously. Surfaces questions worth investigating. Outputs structured question packages.

**Machine 2 — The Newsroom Pipeline:** Takes questions and processes them into published stories. Research, drafting, editing, critique, copy, distribution. Human gates throughout.

**Machine 3 — The Amplification Loop:** Tracks what lands, who amplifies it, what questions it generates. Feeds back into the scanner.

These three machines plus a **knowledge layer** (the wiki) and a **learning layer** (taste profile) make the full system.

---

## Full System Layer Map

| Layer | Job | Tool Slot | Built in Phase |
|-------|-----|-----------|----------------|
| **Control plane** | Stores priorities, tracked entities, active questions, triage states | [task/list tool] | Phase 1 |
| **Intake** | Ingests sources — feeds, filings, documents, bookmarks | [research tool] | Phase 3 |
| **Scoring** | Rates items for priority match and novelty; routes to triage | Claude | Phase 3 |
| **Question package** | Structures a validated question with evidence, angles, confidence | Claude | Phase 1 (manual) |
| **Research** | Source ID, document audit, reportability check, gap flag | Claude + [research tool] | Phase 1 |
| **Drafting** | Argument clarity → human experience → narrative form → readability | Claude | Phase 1 |
| **Editorial review** | Coherence, claim support, escalation flag | Claude | Phase 1 |
| **Critique check** | Counter-arguments, source diversity, right-of-reply | Claude | Phase 1 |
| **Stylistic editing** | Structure, line edit, voice check | Claude | Phase 1 |
| **Legal / copy** | Liability flag, fact verification, style compliance | Claude | Phase 1 |
| **Distribution prep** | Headlines, social copy, stakeholder list | Claude | Phase 1 |
| **Pre-pub drip** | Structured outreach to network during production | [comms tool] | Phase 4 |
| **Publication cascade** | Simultaneous distribution to stakeholder network | [pub stack] | Phase 4 |
| **Monitoring** | Mentions, shares, corrections, engagement by node | [monitoring tool] | Phase 4 |
| **Wiki maintenance** | Compiles raw intake into structured knowledge; updates index | Claude | Phase 1 (basic) |
| **Learning / synthesis** | Reads gate logs, extracts taste patterns, proposes profile updates | Claude | Phase 2 |

---

## The Knowledge Layer (Wiki)

Everything runs on markdown. Every artifact, log, draft, and profile is a markdown file. Readable by humans and AI equally. Portable. Versionable.

```
wiki/
  raw/                              ← clipped articles, documents, data, bookmarks
  
  compiled/
    beats/                          ← what we cover and why
    sources/                        ← source profiles, credibility ratings
    concepts/                       ← recurring themes, frames, terminology
    discourse/                      ← what the conversation is doing on key topics
    gaps/                           ← known unknowns, questions worth asking
    index.md                        ← auto-maintained master index
  
  stories/
    [story-slug]/
      question-package.md
      research-artifact.md
      drafts/
      gate-logs.md
      outcome.md
  
  taste-profile/
    gate-logs/                      ← raw signal from every human gate
    syntheses/                      ← periodic pattern extractions
    current-profile.md              ← living model of editorial taste
  
  relationships/
    [contact-slug].md               ← source and stakeholder profiles
    amplifiers/
  
  outputs/
    [story-slug]-publication-package.md
```

---

## The Learning Layer

The system learns from behavior, not instruction. You don't write rules. You work.

Every human gate decision — approve, override, route back, correct — is logged automatically. After each story (or weekly), a synthesis skill reads the logs and extracts patterns. It proposes updates to your taste profile. You review and approve or correct each one.

Skills have two layers:
- **Core logic** — what the skill always does. Doesn't change.
- **Taste overlay** — personalized flags drawn from your taste profile. "You consistently move the affected person earlier — flag if they appear after paragraph five."

The taste overlay never overrides the core. It adds a layer of personalized attention on top of it.

*Taste profile v1 doesn't exist yet. It builds from the first story through the pipeline.*

---

## The Scanner — Operational Detail

When the scanner is built (Phase 3), it runs two parallel lanes:

**Priority-match lane** — what in today's intake advances current investigations, tracked entities, and named hypotheses? Protects focus.

**Novelty-discovery lane** — what recurring entities, issue clusters, absences, or anomalous relationships are showing up that are *not* yet on the list? Prevents tunnel vision.

Both lanes output to the control plane. The control plane holds the editorial intent that both lanes test against.

**Intake sources (modular — use any combination):**
- News feeds (wire, local, trade, regulatory)
- Saved bookmarks / reading lists
- Court and agency filings
- Social discourse
- Academic and NGO publications
- Community signals, tip lines
- Monitoring feedback from previous stories

**Scoring output per item:**
- Priority score: 1–5 (advances current priorities)
- Novelty score: 1–5 (new entity/issue not yet on watchlist)
- Routing: Act now / Watch / New candidate / Archive

---

## Build Order

### Phase 1 — MVP Newsroom Pipeline
*Question arrives. Story gets published. Nothing else yet.*

Build the 7-stage pipeline manually. Human-submitted questions only. No scanner, no automated amplification. One story through, end to end, with a complete audit trail.

**Done when:** One story has cleared all seven stages. Every stage has a working skill and defined output format. At least one human found it useful.

**First action:** Build the question package template. One document. Human-fillable. This is the input interface for everything downstream.

---

### Phase 2 — Values Layer and Refinement
*Make it better. Make it ours.*

Add editorial identity to relevant skills. Bake in voice, style criteria, stakeholder profiles. Fix what broke in Phase 1.

**Done when:** A journalist unfamiliar with the system can pick up a story mid-pipeline and know exactly what happened.

---

### Phase 3 — The Scanner
*Find the questions, not just answer them.*

Build the intake layer: ingestion, discourse analysis, gap detection, relevance scoring, question package formulation.

**Done when:** Scanner is generating question packages that journalists find useful. At least one story has moved from scanner output through the full pipeline to publication.

---

### Phase 4 — Amplification and Monitoring Loop
*Close the feedback loop.*

Build pre-publication drip, publication cascade, monitoring layer, relationship profile updates, feedback-to-scanner connection.

**Done when:** The flywheel turns. Scanner finds questions → pipeline answers them → amplification distributes them → monitoring feeds the next cycle.

---

### Phase 5 — Scale and Replication
*Run multiple stories. Run other operations.*

Multiple simultaneous stories. Values layer cleanly modular and documented. Scanner handles multiple beats. The architecture becomes infrastructure.

---

## Existing Skills (Already Built)

The Blundell suite covers the core editorial intelligence layer of the pipeline. These are not to be rewritten — they are the pipeline.

| Skill | What it does | Pipeline stage |
|-------|-------------|----------------|
| blundell-cause-effect-map | Scope the story, map cause-effect chain before reporting | Stage 0 — Scoping |
| blundell-theme-statement | Crystallize what the story is (development + consequence + countermove) | Stage 0 — Theme |
| blundell-six-part-guide | Plan reporting using History/Scope/Reasons/Impacts/Countermoves/Futures | Stage 1 — Research planning |
| blundell-indexing | Organize post-reporting notes into six-part categories | Stage 1 — Note organization |
| blundell-narrative-lines | Choose story structure (Block, Time Line, or Theme Line) | Stage 2 — Structure |
| blundell-high-interest-elements | Filter material for reader interest; identify what earns its place | Stage 2 — Drafting |
| blundell-leads | Construct or evaluate the lead | Stage 2 — Lead |
| blundell-profile | Plan or evaluate profile stories | Stage 2 — Profile variant |
| blundell-story-analyst | Analyze published stories for gaps and follow-on opportunities | Scanner — Gap analysis |

Skills live at: `/Users/saulelbein/Documents/Claude Code/blundell-skills/`

---

## Skills Still to Build (4 Remaining)

| Stage | Role it models | Information access | Adversarial posture |
|-------|---------------|-------------------|---------------------|
| Pitch gate | Editor commissioning — does this story exist? | Theme statement + initial evidence only | "Prove to me this is a story" |
| Editorial review | Editor reading cold, 3-4 rounds | Draft only — never the research artifact | Naive reader; catches what reporter context hides |
| Fact-check | Fact-checker spun up cold | Draft + citation sheet only — nothing else | Assumes fabrication; verifies every claim against primary source |
| Distribution prep | Audience team | Cleared draft only | Translates for each channel |

**Reporter's running obligation throughout drafting:** At every draft pass, the reporter maintains a citation sheet — every factual claim in the story mapped to a primary source (interview, article, database). This is not assembled at the end; it is built alongside the draft. The citation sheet is the only upstream document the fact-checker ever sees.

---

## The Pipeline in Detail (Phase 1 Build)

Each stage hands off a structured artifact. The artifact always includes: current story state, what passed, what was flagged and how resolved, what the next stage needs to know.

**Information isolation is a first-class design constraint.** Some roles must not see upstream context — an editor reading cold catches what a naive reader will miss. Contaminating a role with reporter context defeats its purpose.

| Stage | Skill | What it sees | Output | Human gate |
|-------|-------|-------------|--------|------------|
| **0a. Scoping** | blundell-cause-effect-map | Question only | Scoped cause-effect map | Reporter confirms scope |
| **0b. Theme** | blundell-theme-statement | Question + scope map | Theme statement | Reporter confirms theme holds |
| **0c. Pitch** | [to be built] | Theme statement + initial evidence | Commission / kill / needs more | Editor decides |
| **1a. Research planning** | blundell-six-part-guide | Theme statement | Reporting plan (six categories) | Reporter confirms gaps |
| **1b. Note organization** | blundell-indexing | Raw notes + research artifact | Indexed material by category | Reporter confirms index is complete |
| **2a. Structure** | blundell-narrative-lines | Indexed material | Narrative line choice + section order | Reporter approves structure |
| **2b–2e. Drafting (×3–4)** | four-draft + blundell-high-interest-elements + blundell-leads | Indexed material + structure; citation sheet built alongside | Draft v1–v4 + citation sheet (grows each round) | Reporter approves each round; editor checks in |
| **3. Editorial review** | [to be built] | Draft only — no research artifact, no citation sheet | Verdict + gap list; routes back or clears | Editor approves or routes back |
| **4. Fact-check** | [to be built] | Draft + citation sheet only — spun up cold, never sees anything else | Verified/failed per claim; new information flagged | Reporter integrates corrections + new findings |
| **5. Distribution prep** | [to be built] | Cleared draft | Publication package | Audience team approves |

---

## Governing Principles

**Single responsibility.** Each skill only touches its own part of the process. Any stage can be improved, replaced, or retried without breaking everything else.

**Skills before tools.** Define what each stage needs to do before deciding what tool does it. Tools are interchangeable. Logic is not.

**Humans are not bottlenecks.** Gates exist because judgment is irreplaceable at those points. If a gate feels like friction, the upstream stage isn't giving the human what they need. Fix that — don't remove the gate.

**The audit trail is the memory.** If it's not in the trail, it didn't happen. Build the trail first, optimize later.

**Run it before you scale it.** Every phase must produce something useful before the next begins.

**Modular by design.** No layer is locked to a specific tool, beat, or client. Tool slots are named, not prescribed. The values layer is an attachment — not the skeleton.

---

## Current State

As of 2026-04-09, the following exists:

- **WorkFlowy** — set up and in active use. Serves as control plane.
- **Perplexity** — set up and in active use. Contains a backlog of saved bookmarks (potential story leads / questions).
- **EspoCRM + Claude** — set up. Serves as CRM and relationship layer.
- **Questions** — exist in Saul's head and informally in Perplexity. Not formalized or captured anywhere yet.
- **Pipeline** — does not exist. Phase 1 build starts from here.
- **Wiki / knowledge store** — does not exist yet.
- **Question package format** — does not exist yet. First build artifact.

Everything else is state zero.

---

## Tool Slots

| Slot | What it needs to do | Tool | Committed? |
|------|--------------------|--------------------|------------|
| Research / web | Source discovery, current information, document lookup | Perplexity | Yes |
| Control plane | Task tracking, triage states, active questions | WorkFlowy | Yes |
| CRM / relationships | Source and stakeholder profiles | EspoCRM | Yes |
| Primary AI | Skills, synthesis, wiki maintenance | Claude | Yes |
| Knowledge store | Markdown wiki, structured notes, search | [TBD] | No |
| Notifications | Gate prompts delivered to human | [TBD] | No |
| Pub stack | CMS, distribution, publication | [TBD] | No |

---

## Deliberate Blanks

*These fill in through use, not upfront configuration:*

- Preferred input method for new questions (Slack, Obsidian, voice memo, other)
- Preferred notification method for gate prompts
- Escalation path for sensitive stories (who is the senior editor?)
- Legal review process at MVP stage
- CMS and publication stack
- Exact tool commitments per slot
- Voice memo integration if relevant
- Mobile workflow specifics
- Beat/client specifics (modular attachment — added when architecture is stable)

The first story through the pipeline will answer most of these by revealing how you actually want to work.

---

## Source Documents

This master plan synthesizes and supersedes:

- `reporting-os-architecture.md` — Scanner layer operational detail; Perplexity/Workflowy/Obsidian as candidate tool stack
- `01_Architecture_Overview.md` — Core architecture logic and principles
- `02_Full_System_Map.md` — Full stage-by-stage system map
- `03_MVP_Build_Plan.md` — MVP scope and 7-stage build sequence
- `04_Iterative_Roadmap.md` — 5-phase build order
- `05_Learning_Layer.md` — Taste profile and synthesis mechanism
- `06_Implementation_Spec.md` — Wiki structure and daily operational detail

Those documents remain as reference. This one is the decision-making source.
