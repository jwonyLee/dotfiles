# Output Templates

Templates for Decision Log and STAR Resume output formats.

---

## Decision Log Template

```markdown
---
date: YYYY-MM-DD
type: decision-log
tags:
  - decisions
  - session-analysis
status: draft
project: {project-name}
date_range: "{from} ~ {to}"
sessions_analyzed: N
decisions_found: K
---

# Session Decision Log

> Extracted from {N} Claude Code sessions ({project}, {date_range})

## Summary

- **Sessions analyzed**: {N} total, {M} with significant decisions
- **Decisions found**: {K} across {categories}
- **Key themes**: {theme1}, {theme2}, {theme3}

---

## Architecture Decisions

### AD-1: {Decision Title}

**Date**: YYYY-MM-DD
**Session**: {session display text preview}
**Attribution**: {user-directed | user-rejected | user-feedback}
**User Quote**: "{exact user message in original language}"
**Context**: {What problem/situation prompted this decision}

**Options Considered**:
1. **{Option A}**: {Brief description}
   - Pros: {advantages}
   - Cons: {disadvantages}
2. **{Option B}**: {Brief description}
   - Pros: {advantages}
   - Cons: {disadvantages}

**Decision**: {What was chosen}

**Rationale**: {Why this was chosen — the key reasoning}

**Outcome**: {What happened — if visible in session or subsequent sessions}

**Technical Details**:
- {Specific API/pattern/framework detail}
- {Code approach or configuration choice}

---

## Technology Selection

### TS-1: {Decision Title}

**Date**: YYYY-MM-DD
**Session**: {preview}
**Attribution**: {user-directed | user-rejected | user-feedback}
**User Quote**: "{exact user message in original language}"
**Context**: {What needed to be decided}

**Compared**:
| Criteria | {Option A} | {Option B} |
|----------|-----------|-----------|
| {criterion1} | {detail} | {detail} |
| {criterion2} | {detail} | {detail} |

**Decision**: {What was chosen}

**Rationale**: {Why — focus on the decisive factor}

---

## Problem-Solving

### PS-1: {Decision Title}

**Date**: YYYY-MM-DD
**Session**: {preview}
**Attribution**: {user-directed | user-rejected | user-feedback}
**User Quote**: "{exact user message in original language}"
**Problem**: {What was broken/blocked}

**Investigation Path**:
1. {First hypothesis and result}
2. {Second hypothesis and result}
3. {Breakthrough/root cause discovery}

**Solution**: {What ultimately worked}

**Key Insight**: {The non-obvious learning that made the difference}

---

## Process Improvements

### PI-1: {Decision Title}

**Date**: YYYY-MM-DD
**Session**: {preview}
**Attribution**: {user-directed | user-rejected | user-feedback}
**User Quote**: "{exact user message in original language}"
**Before**: {Previous approach}
**After**: {Improved approach}
**Impact**: {What improved and by how much}
```

---

## STAR Resume Template

```markdown
---
date: YYYY-MM-DD
type: star-resume
tags:
  - resume
  - star-format
  - decisions
status: draft
source: decision-log
---

# Resume Stories (STAR Format)

> Transformed from session decision log. Review and refine before using in your resume.

---

## Story 1: {Compelling Action-Oriented Title}

**Situation**:
{2-3 sentences describing the project context and challenge.
 Draw from the "Context" field of the decision log.
 Frame in terms a hiring manager understands.}

**Task**:
{1-2 sentences about your specific responsibility.
 What were you personally accountable for?}

**Action**:
{3-5 sentences about what you did.
 Include specific technical decisions and WHY you made them.
 Mention alternatives considered to show analytical thinking.
 Use concrete technology names.}

**Result**:
{2-3 sentences about the outcome.
 Quantify if possible (performance improvement, time saved, bugs prevented).
 If no metrics available from session, mark with [TODO: add metrics].}

**Keywords**: {tech1}, {tech2}, {pattern} — for ATS optimization

---
```

---

## STAR Transformation Rules

When converting Decision Log entries to STAR format:

1. **Combine related decisions** from the same project/feature into one Story
2. **Elevate "why" reasoning** into the Action section — this is what interviewers care about
3. **Convert jargon to impact language** where possible (e.g., "reduced coupling" → "improved maintainability, reducing bug introduction rate")
4. **Insert `[TODO: add metrics]`** where quantitative results are not visible in session data
5. **Add Keywords** section with technology terms for ATS (Applicant Tracking System) optimization
6. **Use active voice** throughout: "Designed...", "Implemented...", "Migrated...", "Optimized..."

---

## Frontmatter Schema

Required fields for Obsidian compatibility:

| Field | Type | Description |
|-------|------|-------------|
| `date` | string | YYYY-MM-DD format |
| `type` | string | `decision-log` or `star-resume` |
| `tags` | list | Searchable tags |
| `status` | string | Always `draft` on creation |
| `project` | string | Project name |
| `date_range` | string | Session date range analyzed |
| `sessions_analyzed` | number | Total sessions processed |
| `decisions_found` | number | Total decisions extracted |
| `source` | string | For STAR: reference to source decision-log |
