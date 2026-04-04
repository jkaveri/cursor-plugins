---
name: prepare-commit
description: >-
  Reviews what is staged, groups changes into logical commits when needed, and
  drafts imperative commit messages (optionally Conventional). Use before committing,
  when amending, or when the user asks to prepare or split a commit.
---

# Prepare commit

## Scope

- Work from **staged** diff first: `git diff --cached` (and `git status` for file list).
- If nothing is staged, say so and offer: stage by file / stage by hunk (`git add -p`), or draft a message for a future stage—do not invent staged content.

## Steps

1. **Inventory:** list paths with meaningful change categories (e.g. prod code vs tests vs config).
2. **Split check:** if unrelated concerns are mixed, recommend **multiple commits** with separate staging steps; order commits dependency-first (shared types before callers).
3. **Message draft:**
   - Single line, imperative: `Add …`, `Fix …`, `Refactor …`, `Document …`.
   - If the repo uses Conventional Commits, use `type(scope): subject` when scope is obvious.
   - Body: bullets for *why*, breaking changes, or follow-ups—only when needed.
4. **Safety:** no secrets in message; no “WIP” on commits intended for mainline unless the user asks.

## Useful commands

```bash
git status
git diff --cached --stat
git diff --cached
git add -p
```

## Output

- Proposed **subject line** (and optional body).
- If split recommended: **ordered list of commits** with what to include in each and suggested messages.
- **Do not** run `git commit` unless the user explicitly asks the agent to commit.
