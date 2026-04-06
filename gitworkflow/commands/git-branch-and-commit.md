---
description: Create a branch from change context, then draft and run a commit (create-branch + prepare-commit).
---

# Git branch and commit

Use the **create-branch** and **prepare-commit** skills in one flow. **Run the Git commands** in the repo (fetch/checkout, branch, stage, commit)—do not only suggest text.

## 1. Choose the diff to drive branch name and commit message

1. Run `git status` and inspect staged vs unstaged changes.
2. **Prefer staged changes:** if `git diff --cached` is non-empty, use **only** the staged diff for naming and the commit payload.
3. **Otherwise use the working tree:** if the index is empty but `git diff` (or `git status --short`) shows changes, use the **working tree** diff for naming and message, then **stage** those same paths before committing (e.g. `git add` on the files you summarized, or `git add -u` when the whole change set should ship—avoid staging unrelated files).
4. If there is nothing to commit (clean index and working tree), stop and say so.

## 2. Create the branch

From the chosen diff (and any context the user gave: ticket, type, base branch):

1. Propose a branch name per **create-branch** (`<type>/<short-kebab-slug>`; align with **git-branches-commits** if loaded).
2. Run: `git fetch` if needed, `git checkout <base>`, then `git checkout -b <branch>`.
3. If you are already on a feature branch and the user did not ask to branch off `main`, confirm base or follow their stated base.

## 3. Stage (if needed) and commit

1. Use **prepare-commit** on the same diff you used above: imperative subject (Conventional if the repo uses it); body only when useful; split into multiple commits **only** if the user asked or the mix is clearly multiple concerns **and** they want more than one commit (default: **one** commit for this command).
2. If the working tree was used because nothing was staged, stage the intended files **before** `git commit`.
3. Run **`git commit -m "..."`** (and `-m` for body if needed). Do not skip the commit unless the user cancels or the repo blocks the operation (then explain).

## 4. Optional follow-up

Give the exact `git push -u origin HEAD` command for the new branch.

Do not create sub-agents; do this in one pass.
