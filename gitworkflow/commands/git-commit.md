---
description: Draft a commit message and commit (prepare-commit); no new branch.
---

# Git commit

Use the **prepare-commit** skill. **Run `git commit`** in the repo—do not only suggest text. **Do not** create a branch or change the checked-out branch unless a Git error requires it.

## 1. Choose the diff for the message and payload

1. Run `git status` and inspect staged vs unstaged changes.
2. **Prefer staged changes:** if `git diff --cached` is non-empty, use **only** the staged diff for the commit message and what gets committed.
3. **Otherwise use the working tree:** if the index is empty but `git diff` (or `git status --short`) shows changes, use the **working tree** diff for the message, then **stage** those same paths before committing (e.g. `git add` on the files you summarized, or `git add -u` when the whole change set should ship—avoid staging unrelated files).
4. If there is nothing to commit (clean index and working tree), stop and say so.

## 2. Message and commit

1. Draft the message: imperative subject (Conventional if the repo uses it); body only when useful. Split into multiple commits **only** if the user asked or they clearly want more than one (default: **one** commit).
2. If you relied on the working tree because nothing was staged, stage the intended files **before** `git commit`.
3. Run **`git commit -m "..."`** (and `-m` for body if needed). Do not skip the commit unless the user cancels or the repo blocks the operation (then explain).

Do not create sub-agents; do this in one pass.
