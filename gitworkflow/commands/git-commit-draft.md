---
description: Draft commit message(s) from staged changes (prepare-commit skill).
---

# Git commit draft

Use the **prepare-commit** skill. Help me commit **only what is staged** right now.

1. I will paste or you assume I can run: `git status` and `git diff --cached` (staged diff). If nothing is staged, tell me how to stage (including `git add -p`) before drafting.
2. Summarize the staged change in one line, then propose:
   - **Subject line** (imperative; Conventional if my repo uses it—I’ll say `feat:` / `fix:` style or “no convention”).
   - Optional **body** only if needed (why, breaking change, follow-ups).
3. If the staged mix is **too many concerns**, recommend **splitting into multiple commits** and list what belongs in each with suggested messages—ordered so dependencies come first.

Do not run `git commit` unless I explicitly ask you to. No sub-agents.
