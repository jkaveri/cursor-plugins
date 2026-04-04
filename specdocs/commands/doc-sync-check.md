---
description: Check docs vs code/APIs and runbooks (check-doc-sync skill).
---

# Doc sync check

Use the **check-doc-sync** skill.

1. I will specify **scope** (feature, paths, or whole-repo intent). If I do not, ask what to compare.
2. Compare **`docs/specs/`**, **`docs/planning/`** (roadmap, feature list, ideas), **`docs/architecture/`**, **`docs/references/`** with the implementation or contracts I point to; include **`docs/runbooks/`** when operator or release steps may have drifted.
3. Return a **gap list** with priorities and suggested doc updates—not unrelated code refactors unless I ask.
