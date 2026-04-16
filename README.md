# Newsboy

An AI-assisted reporting pipeline. A journalist feeds in a question. A published, fact-checked story comes out the other end. The machine handles mechanical work at each stage. The human makes every real decision.

---

## What this is

Newsboy is a bash pipeline that walks a reporter through the full arc of producing an investigative story: scoping, hypothesis formation, research planning, source development, note organization, drafting, editing, fact-checking, and distribution prep.

At each stage, Claude reads a prompt file, receives only the inputs that stage is allowed to see, and produces structured output. The reporter reviews that output and either approves, edits, or rejects it before the next stage runs. Nothing advances without a human gate decision.

The methodology comes from two sources: William Blundell's feature-writing framework (cause-effect mapping, theme statements, six-part structure, indexing, narrative lines) and ProPublica's Local Reporting Network tools (accountability tests, source strategy, community engagement, gap audits). The pipeline merges both: Blundell identifies what the story needs, ProPublica maps how to get it.

The system is designed around a human reporter with machine coaching, not the reverse. The machine doesn't report. It asks the right questions, enforces the frameworks, and blocks advancement when the work isn't done.

---

## How to use it

### Requirements

- [Claude CLI](https://docs.anthropic.com/en/docs/claude-code) installed and authenticated
- Bash shell
- A story to report

### Start a story

Create a story directory and write a question package:

```bash
mkdir -p wiki/stories/my-story-slug
# Write wiki/stories/my-story-slug/question-package.md
# (What's the question? What prompted it? Who's harmed? Who's responsible?)
```

### Run a stage

```bash
./runner.sh 0a my-story-slug
```

The runner builds a prompt from the stage's lean prompt file, injects only the declared input files, runs Claude in isolation (from `/tmp`, no access to project files), and presents the output for your gate decision: approve, edit, or reject.

### The full sequence

```
0a  Cause-effect map        — scope the story
0b  Theme statement          — crystallize what it's about
0c  Hypothesis formation     — what to test, ranked by tier
0c5 Machine research         — API calls against Tier 1 hypotheses (no LLM)
0d  Pitch gate               — commission, kill, or needs more
1a  Research planning        — Blundell dimensions + ProPublica operational plan
1a-sub  Subagent development — parallel source/records/coverage development
1b  Note organization        — index reporter's raw material
1c  Wiki update              — extract durable knowledge to compiled wiki
2a  Structure plan           — choose narrative line, plan sections
2b  Drafting (4 passes)      — blurt, structure, noise removal, word choice
3   Editorial review         — cold read, no upstream context
4   Fact-check               — zero-trust verification against citation sheet
5   Distribution prep        — headlines, social copy, stakeholder map
```

Three editorial gates: pitch (0d), draft (3), clearance (4). Everything else runs between gates without interrupting the editor.

### Augmentation tools

Run these anytime during active reporting:

```bash
./runner.sh aug-gap-audit my-story-slug      # what's thin, ranked by consequence
./runner.sh aug-engagement-audit my-story-slug  # diagnose stalled community outreach
```

---

## How it works

### Information isolation

Each stage runs as a subprocess that sees only its declared inputs. The runner builds the prompt, pipes it to `claude --print` from `/tmp` (so it can't read project files), and captures the output. No stage sees upstream research, gate logs, or editorial history unless explicitly declared. This is the mechanism that makes editorial review and fact-check work: they read cold because they literally cannot see the reporter's notes.

### Prompt architecture

Each stage has a lean prompt file at `prompts/<stage>.md`. The prompt declares its own reference files in a `## References` section. The runner parses that section and loads only the listed files. No bulk loading.

Every prompt follows the same contract: single-job preamble, identity, system context (what breaks downstream if this stage is weak), quality bar (vivid strong/weak contrast), process, output format, QA summary.

The original skill files (Blundell suite, four-draft method) remain at `wiki/skills/` as the fallback path. If a lean prompt doesn't exist for a stage, the runner loads the full skill directory.

### Subagent spawning (stage 1a-sub)

After the research plan is approved, the runner parses it for source tiers and a community gap flag, then spawns parallel `claude --print` processes:

- Always: tier 1-4 source development, past coverage assessment
- Conditional: community discovery (if gap flag = Yes), engagement memo (after community discovery)

Each subagent gets its own prompt and only the research plan as input. Outputs are synthesized into a developed research plan.

### The wiki

Everything is markdown. Stories live at `wiki/stories/<slug>/`. Compiled institutional knowledge lives at `wiki/compiled/` (sources, entities, concepts, open questions, beat contributions). The wiki gets smarter with each story via stage 1c.

### What's built, what isn't

**Built (Phase 1):** The full pipeline from 0a through 5, all 24 prompt files, runner with subagent spawning, augmentation tools, information isolation, gate logging.

**Not built yet:** Investigation mode (ongoing monitoring that feeds stories when ready), learning layer (taste profile from gate log patterns), scanner (automated intake), amplification loop (post-publication tracking).

See `refactor-plan.md` for the full build spec and `MASTER_PLAN.md` for system architecture.

## License

CC BY-NC-SA 4.0 -- see LICENSE.
