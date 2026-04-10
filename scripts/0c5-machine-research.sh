#!/usr/bin/env bash
# scripts/0c5-machine-research.sh — Tier 1 machine research
#
# Reads Tier 1 hypotheses from hypotheses.md, runs one Perplexity API
# call per hypothesis, writes structured findings to machine-research.md.
#
# No LM. Fails with structured error output and non-zero exit on API failure.
# Idempotent: reruns overwrite previous output.
#
# Type: Write
# Input:  wiki/stories/[slug]/hypotheses.md
# Output: wiki/stories/[slug]/machine-research.md
#
# Usage: scripts/0c5-machine-research.sh <story-slug>
# Env:   PERPLEXITY_API_KEY (required)

set -euo pipefail

SLUG="${1:-}"

# ── Input validation ───────────────────────────────────────────────────────
if [[ -z "$SLUG" ]]; then
  printf '{"status":"error","code":"missing-argument","message":"Usage: 0c5-machine-research.sh <story-slug>"}\n' >&2
  exit 1
fi

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"
STORY="$PROJECT_DIR/wiki/stories/$SLUG"
HYPOTHESES="$STORY/hypotheses.md"
OUTPUT="$STORY/machine-research.md"

if [[ ! -f "$HYPOTHESES" ]]; then
  printf '{"status":"error","code":"missing-input","message":"hypotheses.md not found: %s"}\n' "$HYPOTHESES" >&2
  exit 1
fi

if [[ -z "${PERPLEXITY_API_KEY:-}" ]]; then
  printf '{"status":"error","code":"missing-credential","message":"PERPLEXITY_API_KEY not set"}\n' >&2
  exit 1
fi

for dep in jq curl python3; do
  if ! command -v "$dep" &>/dev/null; then
    printf '{"status":"error","code":"missing-dependency","message":"%s required but not found"}\n' "$dep" >&2
    exit 1
  fi
done

# ── Extract Tier 1 hypothesis blocks ──────────────────────────────────────
WORK_DIR=$(mktemp -d /tmp/machine-research-XXXXXX)
trap 'rm -rf "$WORK_DIR"' EXIT

TIER1_NUMS=$(python3 - "$HYPOTHESES" "$WORK_DIR" << 'PYEOF'
import sys, re

hyp_file, work_dir = sys.argv[1], sys.argv[2]
with open(hyp_file) as f:
    content = f.read()

# Split on ### Hypothesis headings
blocks = re.split(r'(?=^### Hypothesis)', content, flags=re.MULTILINE)
tier1 = []

for block in blocks:
    if not block.strip():
        continue
    if not re.search(r'\*\*TIER:\*\*\s*1', block):
        continue

    m = re.search(r'^### Hypothesis (\d+): (.+)', block)
    if not m:
        continue
    num, title = m.group(1), m.group(2).strip()

    # Extract IF field
    if_m = re.search(r'\*\*IF:\*\*\s*(.+?)(?=\n\*\*|\Z)', block, re.DOTALL)
    if_text = if_m.group(1).strip() if if_m else ""

    # Extract HOW field
    how_m = re.search(r'\*\*HOW:\*\*\s*(.+?)(?=\n\*\*|\Z)', block, re.DOTALL)
    how_text = how_m.group(1).strip() if how_m else ""

    with open(f"{work_dir}/hyp_{num}.txt", 'w') as f:
        f.write(f"TITLE\t{title}\n")
        f.write(f"IF\t{if_text}\n")
        f.write(f"HOW\t{how_text}\n")

    tier1.append(num)

print('\n'.join(tier1))
PYEOF
)

if [[ -z "$TIER1_NUMS" ]]; then
  printf '{"status":"error","code":"no-tier1","message":"No Tier 1 hypotheses found in hypotheses.md"}\n' >&2
  exit 1
fi

TOTAL=$(echo "$TIER1_NUMS" | wc -l | tr -d ' ')
echo "Found $TOTAL Tier 1 hypothesis/hypotheses. Running research..."

# ── Perplexity API call ────────────────────────────────────────────────────
call_perplexity() {
  local query="$1"
  local response
  response=$(curl -sf \
    --max-time 45 \
    -X POST "https://api.perplexity.ai/chat/completions" \
    -H "Authorization: Bearer $PERPLEXITY_API_KEY" \
    -H "Content-Type: application/json" \
    -d "$(jq -n \
      --arg q "$query" \
      '{
        model: "sonar-pro",
        messages: [
          {
            role: "system",
            content: "You are a research assistant for an investigative journalist. Find factual, source-linked information relevant to the research question. Report what the evidence shows. Be specific about sources, dates, and document names. Flag where evidence is absent, weak, or contradictory. Do not speculate beyond what sources establish."
          },
          {role: "user", content: $q}
        ],
        max_tokens: 1200,
        temperature: 0.1
      }'
    )") || return 1

  echo "$response" | jq -r '.choices[0].message.content // empty'
}

# ── Write output file ──────────────────────────────────────────────────────
TIMESTAMP=$(date '+%Y-%m-%d %H:%M:%S')

cat > "$OUTPUT" << HEADER
# Machine Research — $SLUG
*Generated: $TIMESTAMP*
*Source: Perplexity API (sonar-pro) | Tier 1 hypotheses only*
*SPECULATIVE — machine-gathered findings, not verified against primary sources*

---

HEADER

FAILURES=0

while IFS= read -r num; do
  [[ -z "$num" ]] && continue
  hyp_file="$WORK_DIR/hyp_${num}.txt"
  [[ ! -f "$hyp_file" ]] && continue

  TITLE=$(awk -F'\t' '$1=="TITLE"{print $2}' "$hyp_file")
  IF_TEXT=$(awk -F'\t' '$1=="IF"{print $2}' "$hyp_file")
  HOW_TEXT=$(awk -F'\t' '$1=="HOW"{print $2}' "$hyp_file")

  QUERY="Investigative research task for a journalist.

Hypothesis: $IF_TEXT

Research instructions: $HOW_TEXT

Provide specific findings with sources (publication names, document titles, URLs where available, dates). Note any evidence gaps, contradictions, or items that require human verification."

  echo "  H$num: $TITLE..."

  {
    printf '## Hypothesis %s: %s\n\n' "$num" "$TITLE"
    printf '**Research query:** %s\n\n' "$HOW_TEXT"
  } >> "$OUTPUT"

  RESULT=$(call_perplexity "$QUERY" 2>/dev/null) || RESULT=""

  if [[ -z "$RESULT" ]]; then
    echo "  ✗ H$num: API call failed or returned empty"
    {
      printf '**Status:** api-failure\n\n'
      printf '> API call failed or returned empty. Re-run this stage before proceeding to pitch gate.\n\n'
      printf -- '---\n\n'
    } >> "$OUTPUT"
    FAILURES=$((FAILURES + 1))
    continue
  fi

  echo "  ✓ H$num"
  {
    printf '**Status:** success\n\n'
    printf '### Findings\n\n'
    printf '%s\n\n' "$RESULT"
    printf -- '---\n\n'
  } >> "$OUTPUT"

done <<< "$TIER1_NUMS"

# ── Exit with structured status ────────────────────────────────────────────
echo ""
if [[ $FAILURES -gt 0 ]]; then
  printf '{"status":"partial","hypotheses_total":%d,"hypotheses_failed":%d,"output":"%s"}\n' \
    "$TOTAL" "$FAILURES" "$OUTPUT"
  exit 1
fi

printf '{"status":"ok","hypotheses_total":%d,"output":"%s"}\n' "$TOTAL" "$OUTPUT"
