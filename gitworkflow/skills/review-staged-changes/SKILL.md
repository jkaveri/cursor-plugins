---
name: review-staged-changes
description: >-
  Structured review of staged diffs: correctness, edge cases, tests, and risk—
  without expanding to unstaged files unless requested. Use before pushing or when
  the user asks for a quick review of what will be committed.
---

# Review staged changes

## Preconditions

- Primary source: **`git diff --cached`** (staged only).
- Mention if there are **unstaged** or **untracked** changes that might belong in the same commit; do not review them unless the user opts in.

## Review dimensions

1. **Intent fit:** Does the diff match the stated task? Any accidental edits (formatting-only noise, debug prints)?
2. **Correctness:** Logic, error paths, nil/empty handling, API contracts.
3. **Tests:** New or updated tests when behavior changes; gaps for regressions.
4. **Security & data:** Authz, secrets, PII, injection, unsafe defaults.
5. **Compatibility:** Breaking API or schema changes called out explicitly.

## Tone

- **Actionable:** file:line or hunk-level notes when possible.
- **Severity:** classify as must-fix vs nice-to-have vs question.
- Skip bike-shedding unless the user asks for style-only feedback.

## Commands

```bash
git diff --cached
git diff --cached --name-only
git status
```

## Output format

- **Summary** (2–4 sentences).
- **Findings** grouped by severity.
- **Suggested follow-ups** (tests, docs, ticket updates)—separate from must-fix items.
