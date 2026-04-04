# Git Workflow (`gitworkflow`)

Cursor plugin for **branch naming**, **commit message drafting**, **staged-diff review**, and **PR summaries** via four **skills** and matching **commands**, plus a small **rule** file for naming and review scope.

It lives in [`jkaveri/cursor-plugins`](https://github.com/jkaveri/cursor-plugins); see the root [README](../README.md) for marketplace layout.

Manifest: [`.cursor-plugin/plugin.json`](.cursor-plugin/plugin.json).

## Requirements

- [Cursor](https://cursor.com) with support for **rules**, **skills**, and **commands** from installed plugins ([Cursor Plugins](https://cursor.com/docs/plugins)).

## Install (recommended)

From the **repository root** (`cursor-plugins`):

```bash
./scripts/install_cursor_local.py
```

That installs plugins listed in `.cursor-plugin/marketplace.json` under `~/.cursor/plugins/local/<name>/` and registers them. Use `./scripts/install_cursor_local.py --dry-run` to preview. **Restart Cursor** after installing.

Enable the **gitworkflow** / **Git Workflow** plugin in Cursor’s plugin UI when applicable.

## Layout (this plugin)

Paths are relative to the `gitworkflow/` folder:

| Path | Role |
|------|------|
| [`rules/git-branches-commits.mdc`](rules/git-branches-commits.mdc) | Branch shape (`<type>/<short-kebab-slug>`), commit style, prefer **staged** review, PR summary expectations. |
| [`skills/create-branch/`](skills/create-branch/) | Propose branch names from context; safe `git checkout -b` / push steps. |
| [`skills/prepare-commit/`](skills/prepare-commit/) | Inspect **staged** diff; split commits when needed; draft imperative (optionally Conventional) messages. |
| [`skills/review-staged-changes/`](skills/review-staged-changes/) | Structured review of **`git diff --cached`** (correctness, tests, risk). |
| [`skills/draft-pr-summary/`](skills/draft-pr-summary/) | PR title and Markdown body from branch, commits, and context. |
| [`commands/git-branch-name.md`](commands/git-branch-name.md) | Command prompt wired to **create-branch**. |
| [`commands/git-commit-draft.md`](commands/git-commit-draft.md) | Command prompt wired to **prepare-commit**. |
| [`commands/git-review-staged.md`](commands/git-review-staged.md) | Command prompt wired to **review-staged-changes**. |
| [`commands/git-pr-draft.md`](commands/git-pr-draft.md) | Command prompt wired to **draft-pr-summary**. |

## Use without the full marketplace (manual copy)

Copy into a project as needed:

1. `rules/*.mdc` → `.cursor/rules/`
2. `skills/*/` → `.cursor/skills/`
3. `commands/*.md` → `.cursor/commands/` (or your Cursor version’s command path)

Merge with existing files; avoid duplicate skill or command names.

## Global skills (all workspaces)

To use a skill everywhere:

```bash
mkdir -p ~/.cursor/skills
ln -s /path/to/cursor-plugins/gitworkflow/skills/create-branch ~/.cursor/skills/create-branch
# repeat for prepare-commit, review-staged-changes, draft-pr-summary
```

Do **not** install custom skills under `~/.cursor/skills-cursor/`.

## Verify

1. Open the **Commands** palette (or your Cursor entry point for plugin commands) and run a workflow command, or ask the agent to follow a skill by name (e.g. “review my staged changes using review-staged-changes”).
2. Confirm [`git-branches-commits`](rules/git-branches-commits.mdc) appears for Git-related work if project rules are enabled.

## Updating

Pull `cursor-plugins`, rerun `./scripts/install_cursor_local.py`, or refresh manual copies/symlinks.

## Customizing

Adjust [`git-branches-commits.mdc`](rules/git-branches-commits.mdc) for team branch/ticket conventions; tune `SKILL.md` and command prompts to match your Git host and PR templates. Fork or vendor the `gitworkflow/` tree if you need a long-lived fork.
