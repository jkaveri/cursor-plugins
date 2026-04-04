---
name: create-branch
description: >-
  Proposes a branch name from task context, checks naming against repo conventions,
  and outlines safe `git checkout -b` / push commands. Use when starting work, after
  an issue/ticket is known, or when the user asks to create or name a branch.
---

# Create branch

## Inputs to collect

- **Intent:** feature, bugfix, chore, docs, refactor, or test.
- **Scope:** few words that identify the change (not the whole backlog).
- **Ticket ID:** optional; include only if the repo’s branches always carry IDs (e.g. `JIRA-123-feat-slug`).

## Naming algorithm

1. Pick `type` from policy: `feat`, `fix`, `chore`, `docs`, `refactor`, `test`.
2. Build `short-kebab-slug` from scope: lowercase, hyphens, no spaces; drop filler words (`the`, `a`, `update`).
3. If the remote uses ticket prefixes, prepend or append per existing branches (`git branch -a` pattern).
4. **Collision check:** if the name exists locally or on `origin`, suggest `-2` or a more specific slug—never silently reuse.

## Commands (suggest, do not assume default branch name)

```bash
git fetch origin
git branch --show-current
git branch -a | head   # sample existing names
git checkout -b <type>/<short-kebab-slug>   # after user confirms default base
git push -u origin HEAD    # when ready to publish
```

## Output

- One **recommended** branch name with one **alternate** if ambiguous.
- **Base branch** called out explicitly (`main`, `master`, or team default).
- Short **rationale** (≤2 lines) tied to policy, not generic Git advice.
