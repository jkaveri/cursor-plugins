---
description: Review staged diff before commit or push (review-staged-changes skill).
---

# Git review staged

Use the **review-staged-changes** skill. Review **only the staged diff** (`git diff --cached`).

- I can paste `git diff --cached` output, or describe that I’ll run it locally—prefer concrete findings with **severity** (must-fix vs nice-to-have vs question).
- If I have **unstaged** changes, mention they exist but do **not** review them unless I ask to expand scope.
- Cover: intent fit, correctness, tests, security/data, breaking changes.
- End with a short **summary** and **ordered follow-ups**.

Stay in one response; no sub-agents.
