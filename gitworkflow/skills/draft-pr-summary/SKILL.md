---
name: draft-pr-summary
description: >-
  Builds a PR title and description from branch purpose, commits, and optionally
  staged or merged diff context—suited for GitHub/GitLab templates. Use when opening
  a PR, updating a description, or when the user asks for a PR summary.
---

# Draft PR summary

## Inputs

- **Branch name** and **base** (e.g. `main`).
- **Commit messages** since merge-base: `git log origin/<base>..HEAD --oneline` (adjust if no `origin`).
- Optional: **issue/ticket** link and **reviewer** focus areas.

## Title

- Prefer **outcome-oriented** phrasing: what merges and why it matters.
- Match team length limits (often ~72 characters); no trailing period.

## Body structure (adapt to repo template)

1. **What** — user-visible behavior or refactor scope.
2. **Why** — problem or motivation (one short paragraph).
3. **How to test** — steps or commands; note feature flags or env vars.
4. **Risk / rollout** — migrations, backwards compatibility, feature flags.
5. **Checklist** — only if the project uses one (tests, docs, changelog).

## What to avoid

- Pasting full diffs into the description.
- Vague “fixed stuff” or-only commit hashes without context.
- Internal-only identifiers in the title unless required.

## Commands

```bash
git merge-base HEAD origin/main   # or main
git log --oneline <base>..HEAD
git diff <base>...HEAD --stat
```

## Output

- **Title** (one line).
- **Description** in Markdown, ready to paste into the PR form.
- Optional **labels** suggestions if the user names their tracker system.
