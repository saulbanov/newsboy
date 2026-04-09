#!/usr/bin/env bash
# runner.sh — Newsbot pipeline stage runner
#
# Enforces information isolation mechanically: each stage gets a fresh
# claude --print invocation with ONLY the skill file content and input
# artifact injected into the prompt. The subprocess cannot read other files.
#
# Usage:
#   ./runner.sh <stage> <story-slug>
#
# Stages: 0a, 0b, 0c, 0d, 1a, 1b, 2a, 3, 4, 5
# Example:
#   ./runner.sh 0a oil-ceasefire-bet

set -euo pipefail

STAGE="${1:-}"
SLUG="${2:-}"

if [[ -z "$STAGE" || -z "$SLUG" ]]; then
  echo "Usage: ./runner.sh <stage> <story-slug>"
  echo "Stages: 0a 0b 0c 0d 1a 1b 2a 3 4 5"
  exit 1
fi

# Paths
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
WIKI="$SCRIPT_DIR/wiki"
SKILLS="$WIKI/skills"
STORY="$WIKI/stories/$SLUG"
LOGS="$STORY/gate-logs.md"
SYSLOG="$WIKI/system/pipeline-log.md"
TMP_OUTPUT=$(mktemp /tmp/runner-output-XXXXXX.md)
trap 'rm -f "$TMP_OUTPUT"' EXIT

if [[ ! -d "$STORY" ]]; then
  echo "Error: story directory not found: $STORY"
  exit 1
fi

# ── Stage configuration ────────────────────────────────────────────────────
# Each stage declares:
#   SKILL_PATH  — path to SKILL.md (for directory-based skills)
#              OR path to flat skill file
#   SKILL_IS_DIR — true if skill has a references/ subdirectory
#   INPUT_FILES — array of files to inject as input (in order)
#   OUTPUT_FILE — where to write approved output
#   STAGE_LABEL — human-readable name

configure_stage() {
  case "$STAGE" in
    0a)
      STAGE_LABEL="Stage 0a — Cause-Effect Map"
      SKILL_PATH="$SKILLS/blundell-cause-effect-map"
      SKILL_IS_DIR=true
      INPUT_FILES=("$STORY/question-package.md")
      OUTPUT_FILE="$STORY/cause-effect-map.md"
      ;;
    0b)
      STAGE_LABEL="Stage 0b — Theme Statement"
      SKILL_PATH="$SKILLS/blundell-theme-statement"
      SKILL_IS_DIR=true
      INPUT_FILES=("$STORY/cause-effect-map.md")
      OUTPUT_FILE="$STORY/theme-statement.md"
      ;;
    0c)
      STAGE_LABEL="Stage 0c — Hypothesis Formation"
      SKILL_PATH="$SKILLS/hypothesis-formation.md"
      SKILL_IS_DIR=false
      INPUT_FILES=("$STORY/cause-effect-map.md" "$STORY/theme-statement.md")
      OUTPUT_FILE="$STORY/hypotheses.md"
      ;;
    0d)
      STAGE_LABEL="Stage 0d — Pitch Gate"
      SKILL_PATH="$SKILLS/pitch-gate.md"
      SKILL_IS_DIR=false
      INPUT_FILES=("$STORY/theme-statement.md" "$STORY/hypotheses.md")
      OUTPUT_FILE="$STORY/pitch-gate-verdict.md"
      ;;
    1a)
      STAGE_LABEL="Stage 1a — Research Planning"
      SKILL_PATH="$SKILLS/blundell-six-part-guide"
      SKILL_IS_DIR=true
      INPUT_FILES=("$STORY/theme-statement.md" "$STORY/hypotheses.md")
      OUTPUT_FILE="$STORY/research-plan.md"
      ;;
    1b)
      STAGE_LABEL="Stage 1b — Note Organization"
      SKILL_PATH="$SKILLS/blundell-indexing"
      SKILL_IS_DIR=true
      INPUT_FILES=("$STORY/research-artifact.md")
      OUTPUT_FILE="$STORY/indexed-notes.md"
      ;;
    2a)
      STAGE_LABEL="Stage 2a — Structure"
      SKILL_PATH="$SKILLS/blundell-narrative-lines"
      SKILL_IS_DIR=true
      INPUT_FILES=("$STORY/indexed-notes.md" "$STORY/theme-statement.md")
      OUTPUT_FILE="$STORY/structure-plan.md"
      ;;
    3)
      STAGE_LABEL="Stage 3 — Editorial Review"
      SKILL_PATH="$SKILLS/editorial-review.md"
      SKILL_IS_DIR=false
      # Gets current draft only — no research artifact, no notes
      DRAFT=$(ls "$STORY/drafts/"*.md 2>/dev/null | sort -V | tail -1 || true)
      if [[ -z "$DRAFT" ]]; then
        echo "Error: no draft found in $STORY/drafts/"
        exit 1
      fi
      INPUT_FILES=("$DRAFT")
      OUTPUT_FILE="$STORY/editorial-notes.md"
      ;;
    4)
      STAGE_LABEL="Stage 4 — Fact Check"
      SKILL_PATH="$SKILLS/fact-check.md"
      SKILL_IS_DIR=false
      # Gets draft + citation sheet ONLY
      DRAFT=$(ls "$STORY/drafts/"*.md 2>/dev/null | sort -V | tail -1 || true)
      if [[ -z "$DRAFT" ]]; then
        echo "Error: no draft found in $STORY/drafts/"
        exit 1
      fi
      if [[ ! -f "$STORY/citation-sheet.md" ]]; then
        echo "Error: citation-sheet.md not found — build it alongside the draft"
        exit 1
      fi
      INPUT_FILES=("$DRAFT" "$STORY/citation-sheet.md")
      OUTPUT_FILE="$STORY/fact-check-verdict.md"
      ;;
    5)
      STAGE_LABEL="Stage 5 — Distribution Prep"
      SKILL_PATH="$SKILLS/distribution-prep.md"
      SKILL_IS_DIR=false
      # Gets cleared draft only
      DRAFT=$(ls "$STORY/drafts/"*.md 2>/dev/null | sort -V | tail -1 || true)
      if [[ -z "$DRAFT" ]]; then
        echo "Error: no cleared draft found in $STORY/drafts/"
        exit 1
      fi
      INPUT_FILES=("$DRAFT")
      OUTPUT_FILE="$STORY/distribution-package.md"
      ;;
    *)
      echo "Error: unknown stage '$STAGE'. Valid stages: 0a 0b 0c 0d 1a 1b 2a 3 4 5"
      exit 1
      ;;
  esac
}

# ── Build prompt ───────────────────────────────────────────────────────────
build_prompt() {
  local prompt=""

  prompt+="You are running a single stage of a journalism pipeline. You have been given:"
  prompt+=$'\n'"1. A skill file that defines exactly what you must do and exactly what output to produce."
  prompt+=$'\n'"2. Input from the previous stage."
  prompt+=$'\n\n'"You must follow the skill file procedure exactly. Produce only the output format it specifies. Nothing else."
  prompt+=$'\n\n'"---"
  prompt+=$'\n\n'"SKILL FILE:"
  prompt+=$'\n\n'

  if [[ "$SKILL_IS_DIR" == true ]]; then
    prompt+=$(cat "$SKILL_PATH/SKILL.md")
    prompt+=$'\n\n'"REFERENCE FILES:"$'\n'
    if [[ -d "$SKILL_PATH/references" ]]; then
      for ref in "$SKILL_PATH/references/"*.md; do
        [[ -f "$ref" ]] || continue
        prompt+=$'\n'"=== $(basename "$ref") ==="$'\n'
        prompt+=$(cat "$ref")
        prompt+=$'\n'
      done
    fi
  else
    prompt+=$(cat "$SKILL_PATH")
  fi

  prompt+=$'\n\n'"---"
  prompt+=$'\n\n'"INPUT:"$'\n'

  for f in "${INPUT_FILES[@]}"; do
    if [[ ! -f "$f" ]]; then
      echo "Error: input file not found: $f" >&2
      exit 1
    fi
    prompt+=$'\n'"=== $(basename "$f") ==="$'\n'
    prompt+=$(cat "$f")
    prompt+=$'\n'
  done

  echo "$prompt"
}

# ── System event log (append-only, never injected into stage prompts) ─────
# Format: timestamp | stage | slug | event | detail
# Location: wiki/system/pipeline-log.md — outside wiki/stories/, structurally
# excluded from INPUT_FILES for all stages.
log_event() {
  local event="$1"
  local detail="${2:-}"
  local ts
  ts=$(date '+%Y-%m-%d %H:%M:%S')

  if [[ ! -f "$SYSLOG" ]]; then
    mkdir -p "$(dirname "$SYSLOG")"
    printf '# Pipeline Log\n\n| Timestamp | Stage | Slug | Event | Detail |\n|-----------|-------|------|-------|--------|\n' > "$SYSLOG"
  fi

  printf '| %s | %s | %s | %s | %s |\n' \
    "$ts" "$STAGE" "$SLUG" "$event" "$detail" >> "$SYSLOG"
}

# ── Log gate decision ──────────────────────────────────────────────────────
log_gate() {
  local decision="$1"
  local note="$2"
  local ts
  ts=$(date '+%Y-%m-%d %H:%M')

  if [[ ! -f "$LOGS" ]]; then
    echo "# Gate Logs — $SLUG" > "$LOGS"
    echo "" >> "$LOGS"
  fi

  {
    echo "## $ts — $STAGE_LABEL"
    echo "Decision: **$decision**"
    [[ -n "$note" ]] && echo "Note: $note"
    echo ""
  } >> "$LOGS"
}

# ── Main ───────────────────────────────────────────────────────────────────
configure_stage

echo ""
echo "════════════════════════════════════════════════════════════"
echo "  RUNNER: $STAGE_LABEL"
echo "  Story:  $SLUG"
echo "════════════════════════════════════════════════════════════"
echo ""

# Verify all input files exist before running
for f in "${INPUT_FILES[@]}"; do
  if [[ ! -f "$f" ]]; then
    echo "Error: required input file not found: $f"
    echo "Complete the previous stage first."
    exit 1
  fi
done

log_event "STAGE_START" "input files: ${INPUT_FILES[*]}"

echo "Building prompt and running stage..."
echo ""

PROMPT=$(build_prompt)

# Run Claude from /tmp so it does not pick up project CLAUDE.md — information isolation
if (cd /tmp && echo "$PROMPT" | claude --print --allowedTools "") > "$TMP_OUTPUT" 2>&1; then
  log_event "CLAUDE_OK" "output: $(wc -c < "$TMP_OUTPUT") bytes"
else
  CLAUDE_EXIT=$?
  log_event "CLAUDE_FAIL" "exit code: $CLAUDE_EXIT"
  echo "Error: claude subprocess failed (exit $CLAUDE_EXIT). Output:"
  cat "$TMP_OUTPUT"
  exit 1
fi

echo ""
echo "════════════════════════════════════════════════════════════"
echo "  OUTPUT — $STAGE_LABEL"
echo "════════════════════════════════════════════════════════════"
echo ""
cat "$TMP_OUTPUT"
echo ""
echo "════════════════════════════════════════════════════════════"
echo ""

# Human gate
while true; do
  read -rp "Gate decision — approve / reject / edit? " DECISION
  case "$DECISION" in
    approve|a|yes|y)
      cp "$TMP_OUTPUT" "$OUTPUT_FILE"
      read -rp "Gate note (press enter to skip): " GATE_NOTE
      log_gate "APPROVED" "$GATE_NOTE"
      log_event "GATE_APPROVED" "${GATE_NOTE:-no note}"
      echo ""
      echo "✓ Approved. Output written to: $(basename "$OUTPUT_FILE")"
      echo "  Next stage: run ./runner.sh <next-stage> $SLUG"
      break
      ;;
    reject|r|no|n)
      read -rp "Rejection reason: " REJECT_NOTE
      log_gate "REJECTED" "$REJECT_NOTE"
      log_event "GATE_REJECTED" "$REJECT_NOTE"
      echo ""
      echo "✗ Rejected. Stage not advanced. Re-run after fixing the issue."
      exit 1
      ;;
    edit|e)
      ${EDITOR:-vi} "$TMP_OUTPUT"
      cp "$TMP_OUTPUT" "$OUTPUT_FILE"
      read -rp "Gate note (press enter to skip): " GATE_NOTE
      log_gate "APPROVED (edited)" "$GATE_NOTE"
      log_event "GATE_APPROVED_EDITED" "${GATE_NOTE:-no note}"
      echo ""
      echo "✓ Edited and approved. Output written to: $(basename "$OUTPUT_FILE")"
      break
      ;;
    *)
      echo "Type: approve, reject, or edit"
      ;;
  esac
done
