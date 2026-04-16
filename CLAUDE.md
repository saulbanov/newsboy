# Newsboy Pipeline — Project Instructions

## Read on every session startup

1. Read `AGENTS.md` — pipeline rules, stage sequence, information isolation, mandatory procedure.
2. Read `MASTER_PLAN.md` — full system architecture and current build state.
3. State in two sentences: where we are in the pipeline test run, what's needed next.

Do not produce pipeline output until you have done this.

## What this project is

An AI-assisted newsroom pipeline. A question enters; a published story exits. Claude handles mechanical work at each stage; the human makes every real judgment call. The pipeline is currently being tested by running real stories through it end-to-end.

## Mandatory stage execution

Before producing output for any pipeline stage:
1. Read the full skill file for that stage, including all files in its `references/` subdirectory.
2. Follow the skill procedure exactly.
3. Stop and wait for explicit human approval before advancing.

Skill files live in `wiki/skills/`. See `AGENTS.md` for the full inventory and stage sequence.
