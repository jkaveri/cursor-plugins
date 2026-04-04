---
description: Propose a Git branch name from task context (create-branch skill).
---

# Git branch name

Use the **create-branch** skill. I need a branch name for work with this profile:

- **Type:** (feat / fix / chore / docs / refactor / test)
- **Short description:** (what changes, in a few words)
- **Ticket / issue:** (optional, e.g. PROJ-123 or URL)
- **Base branch I’m using:** (e.g. `main` — say if unsure)

Reply with:

1. The **recommended** branch name and one **alternate** if naming is ambiguous.
2. Whether existing remote branches suggest a different **prefix or ticket pattern** (infer from what I tell you about the repo, or say what to check with `git branch -a`).
3. Exact commands to run: `git fetch`, `git checkout <base>`, `git checkout -b …`, and optional `git push -u origin HEAD`.

Do not create sub-agents; do this in one pass.
