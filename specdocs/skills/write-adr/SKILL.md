---
name: write-adr
description: >-
  Writes or updates Architecture Decision Records under docs/decisions/ as adr-<NNN>-<kebab-title>.md
  with status, context, decision, consequences, and alternatives. Use when recording a significant
  technical decision or superseding a prior ADR.
---

# Write ADR

## Scope

- **Location:** **`docs/decisions/`**.
- **Filename:** **`adr-<NNN>-<kebab-title>.md`** — **NNN** is a zero-padded three-digit sequence (repository-wide).

## Steps

1. **Next number:** list existing `adr-*.md` files; set **NNN** to the next integer (e.g. `007` after `006`).
2. **Title slug:** short **kebab-case** phrase after the number (e.g. `adr-007-use-postgres-for-events.md`).
3. **Front matter (optional)** or heading block: **Title**, **Status** (Proposed / Accepted / Deprecated / Superseded), **Date**, **Context** (forces and constraints).
4. **Body:** **Decision** (what we chose), **Consequences** (positive and negative), **Alternatives** (what was rejected and why).
5. **Superseding:** if replacing an older ADR, set old status to **Superseded** with a link to the new file, and in the new ADR link back to the old.

## Output

- Full path for the new file and complete markdown draft.
- If updating an existing ADR for status only, keep edits minimal.

## Constraints

- Use ADRs for **significant** decisions (hard to reverse, cross-team cost). Not every small choice needs an ADR—a line in **`docs/specs/<feature>/plan.md`** may suffice.
