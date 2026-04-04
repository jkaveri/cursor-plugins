---
name: check-doc-sync
description: >-
  Compares documentation under docs/specs/, docs/planning/, docs/architecture/, and
  docs/references/ with stated code or API behavior; flags gaps and suggests updates to
  runbooks when operator steps change. Use for review, pre-release, or doc audits.
---

# Check doc sync

## Scope

- **Specs:** **`docs/specs/**`** — behavior, rollout, and test cases vs implementation.
- **Planning:** **`docs/planning/`** — roadmap, **`features.md`** inventory, and **`ideas.md`** vs what is actually shipped or in progress (stale status, broken links to specs).
- **Architecture / references:** **`docs/architecture/`**, **`docs/references/`** — boundaries, integrations, APIs, glossary vs current code or contracts.
- **Runbooks:** **`docs/runbooks/`** — when commands, env vars, or incident steps drift from reality.

## Steps

1. **Establish scope:** which feature, service, or paths the user cares about (or whole `docs/` vs `src/`).
2. **Gather signals:** relevant source files, OpenAPI/proto, config, or tests the user points to—or infer from repo layout and name clearly what was assumed.
3. **Compare:** for each doc claim (behavior, error cases, rollout, SLO), mark **aligned**, **unclear**, or **likely wrong** with evidence (file/symbol).
4. **Planning:** if roadmap or feature list claims conflict with **`docs/specs/`** or code, flag **`roadmap.md`**, **`features.md`**, or **`ideas.md`** updates.
5. **Runbooks:** if local dev, release, or incident steps changed in code or scripts, check **`docs/runbooks/`** for matching updates.
6. **Output:** prioritized gap list—**must fix** vs **nice to have**—and suggested doc edits (not drive-by code refactors unless the user asks).

## Output format

- **Summary** (short).
- **Gaps** as bullets: doc path → issue → suggested fix.
- Optional **follow-ups** (e.g. “consider ADR if …”).

## Constraints

- If the codebase is not available or too large, scope to paths the user provides and state assumptions.
