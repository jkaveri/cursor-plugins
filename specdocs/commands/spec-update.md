---
description: Update specs and related docs from a change or diff (update-spec-from-change skill).
---

# Spec update

Use the **update-spec-from-change** skill.

1. I will paste **`git diff`**, a file list, a PR summary, or describe the change—use what I give; if scope is unclear, ask one clarifying question.
2. Map the change to **`docs/specs/<feature>/`** files (**`spec.md`**, **`plan.md`**, **`tasks.md`**, **`rollout.md`**, **`test-cases.md`**) and to **`docs/planning/`** when roadmap, feature list, or ideas need updating; use **`docs/architecture/`** or **`docs/references/`** when the change is cross-cutting.
3. Propose **minimal edits**; flag contradictions between docs and code.
4. If an architectural decision is locked, point out whether a new ADR under **`docs/decisions/`** is appropriate.
