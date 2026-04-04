---
name: update-spec-from-change
description: >-
  Updates docs/specs/<feature>/ and related docs (architecture, references) from a code
  change, diff, or description. Maps edits to spec.md vs plan.md vs rollout.md vs test-cases.md;
  flags contradictions. Use after implementation, before merge, or when reconciling docs with code.
---

# Update spec from change

## Scope

- Inputs: **`git diff`**, file list, PR description, or narrative of what changed.
- Primary targets: **`docs/specs/<feature>/`**; also **`docs/architecture/`**, **`docs/references/`** when the change is cross-cutting or API-wide.

## Steps

1. **Infer feature:** from paths, package names, or user-provided feature slug; if ambiguous, ask once or propose the best **`docs/specs/<feature>/`** folder.
2. **Classify the change:** user-visible behavior, internal refactor only, config/ops, breaking API, rollout-related.
3. **Map to files:**
   - Behavior / product story → **`spec.md`** (and **`test-cases.md`** if scenarios change).
   - Approach or sequencing → **`plan.md`**.
   - Checklist / completion → **`tasks.md`**.
   - Flags, migration, deploy order → **`rollout.md`**.
   - Roadmap or feature status (shipped, parked, renamed) → **`docs/planning/roadmap.md`** or **`docs/planning/features.md`** (and **`ideas.md`** when demoting or parking work).
   - System diagram–level impact → **`docs/architecture/`**.
   - Stable API or domain terms → **`docs/references/`**.
4. **Minimal edits:** patch sections that are wrong; avoid rewriting unrelated sections.
5. **Contradictions:** call out if **`spec.md`** and code disagree, or if an ADR should be added in **`docs/decisions/`**.

## Output

- List of files to touch with a one-line rationale each.
- Concrete suggested markdown edits (diff-style or section replacements).

## Constraints

- Do not invent a new feature folder if an existing one clearly matches—prefer consolidation.
- If the repo does not yet have **`docs/specs/`**, offer to create the folder using the **write-feature-spec** flow first.
