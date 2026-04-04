---
name: write-feature-spec
description: >-
  Creates or refreshes per-feature documentation under docs/specs/<feature-name>/ using
  spec.md, plan.md, tasks.md, rollout.md, and test-cases.md. Use when starting a feature,
  splitting a monolithic spec, or when the user asks for a feature spec in the canonical layout.
---

# Write feature spec

## Scope

- Target tree: **`docs/specs/<feature-name>/`** with **kebab-case** `feature-name`.
- Primary file: **`spec.md`**. Add **`plan.md`**, **`tasks.md`**, **`rollout.md`**, **`test-cases.md`** when they add value—do not create empty placeholders unless the user wants stubs.

## Steps

1. **Clarify:** problem, target users, success criteria, explicit **non-goals**, and dependencies on other features or systems.
2. **Name the folder:** pick a stable **kebab-case** slug; align with how the team refers to the feature in issues or APIs.
3. **`spec.md`:** summary, goals/non-goals, scenarios or user stories, acceptance criteria, risks and open questions.
4. **`plan.md`:** technical approach, milestones, key tradeoffs (keep brief; link to ADRs in `docs/decisions/` when the decision is architectural).
5. **`tasks.md`:** ordered checklist (implementation, docs, metrics, cleanup).
6. **`rollout.md`:** feature flags, migration, ordering, monitoring—only if rollout is non-trivial.
7. **`test-cases.md`:** verifiable cases; align with automated tests where they exist.

## Output

- Paths to create or update (explicit **`docs/specs/<feature>/...`**).
- Draft markdown for each file touched, or a single consolidated draft if the user asked for one document only.

## Constraints

- Prefer updating an existing **`docs/specs/<feature>/`** folder over inventing a second folder for the same feature.
- If **`docs/README.md`** or **`docs/planning/features.md`** should list or link to this feature, mention that as a follow-up line—do not rewrite planning docs unless asked.
