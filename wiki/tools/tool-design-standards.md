# Tool Design Standards — Reporting OS
*Generated: 2026-04-10 | Status: Working draft*

---

## The Problem This Solves

Tools (runner.sh, Perplexity calls, future database queries) are currently designed ad hoc. As more tools are added across more machines, inconsistent tool design becomes a reliability problem — retries create duplicates, errors return unstructured text Claude misreads, write operations run when they shouldn't.

---

## Audit Existing Tools First

Before designing new ones, catalog what exists. For each tool ask:

- Does it validate inputs?
- What happens on retry?
- What does it return on error?
- Is it read or write?

**Current tools to audit:**

| Tool | Type | Validated? | Idempotent? | Structured output? | Notes |
|------|------|------------|-------------|-------------------|-------|
| runner.sh | Write | ? | ? | ? | Most critical — audit first |
| 0c.5 machine research script | Read | ? | ? | ? | Not yet built |
| 0c.7 trending context script | Read | ? | ? | ? | Not yet built |

---

## Four Rules — Every Tool, No Exceptions

### 1. Strict Inputs
Every tool defines exactly what it accepts. Wrong input type, missing field, out-of-range value — tool rejects immediately with a clear error before doing anything. Never let a bad input reach execution.

### 2. Idempotency on Writes
Any tool that creates or modifies something — logging a gate decision, writing a story file, sending outreach — must be safe to call twice. Use a client-generated key or a content hash so retries don't create duplicates.

### 3. Structured Outputs
Tools return JSON or structured markdown, never a text blob. Claude consuming the output should never have to parse prose to find the result.

### 4. Read/Write Separation
Read tools and write tools are separate.
- **Read tools** (query database, fetch document, search web) — run freely
- **Write tools** (log decision, create file, send message) — require explicit invocation and log every call

---

## Apply to runner.sh First

It's the most critical tool and the most ad hoc. Confirm:

- [ ] Returns structured output on both success and failure
- [ ] Retries don't double-log gate decisions
- [ ] Rejects malformed stage names and slugs before executing anything
- [ ] Read operations and write operations are clearly separated

---

## Tool Registry

Maintain one file — `wiki/tools/registry.md` — listing every tool the system can call.

**Every entry must include:**
- Tool name
- Input schema
- Output schema
- Read or write
- Idempotency strategy
- Notes / known issues

**Rule:** Every new tool gets a registry entry before it gets used.

### Registry template

```markdown
## [tool-name]

**Type:** Read | Write
**Idempotency:** [strategy — e.g. content hash, client key, N/A]

**Inputs:**
| Field | Type | Required | Validation |
|-------|------|----------|------------|
| | | | |

**Output (success):**
\`\`\`json
{
  "status": "ok",
  "result": ...
}
\`\`\`

**Output (error):**
\`\`\`json
{
  "status": "error",
  "code": "...",
  "message": "..."
}
\`\`\`

**Notes:**
```

---

## Addition to Refactor Build Sequence

Insert between steps 6 and 7 of `refactor-plan.md`:

> **6a.** Audit runner.sh against tool design standards above. Fix any violations. Add `wiki/tools/registry.md` with a runner.sh entry.

---

## Open Questions

- Should the tool registry be machine-readable (YAML) rather than markdown, so tooling can validate against it automatically?
- How does idempotency work for outreach tools (sending emails/messages to sources) — content hash risks resending if content changes; what's the right key?
- As the Private Research Layer adds file-write tools, who enforces the registry discipline — human, CI check, or Claude session startup?
