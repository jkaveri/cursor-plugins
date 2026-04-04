---
description: Draft PR title and body for the current branch (draft-pr-summary skill).
---

# Git PR draft

Use the **draft-pr-summary** skill. Draft a **PR title** and **Markdown body** for my open branch.

Assume I can provide or you infer:

- **Base branch** (e.g. `main`) and **branch name**
- **Commit list** since merge-base (`git log <base>..HEAD --oneline`) — I may paste this
- Optional: issue link, rollout notes, how reviewers should test

Produce:

1. A concise **title** (outcome-oriented, no trailing period).
2. A paste-ready **description** with: What / Why / How to test / Risk (if any)—skip sections that don’t apply.
3. Do **not** embed the full diff; `--stat` or high-level file list is enough.

One pass, no sub-agents.
