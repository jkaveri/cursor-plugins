# Go Development (`godev`)

Cursor plugin with **Go project rules** (`.mdc`), **skills** (`SKILL.md`), and a **go-test-writer** agent for strict table-driven Go tests. It lives in the [`jkaveri/cursor-plugins`](https://github.com/jkaveri/cursor-plugins) multi-plugin repo; see the root [README](../README.md) for marketplace layout.

Manifest: [`.cursor-plugin/plugin.json`](.cursor-plugin/plugin.json).

## Requirements

- [Cursor](https://cursor.com) with support for **rules**, **skills**, and **agents** as loaded from installed plugins (see [Cursor Plugins](https://cursor.com/docs/plugins)).

## Install (recommended)

From the **repository root** (`cursor-plugins`):

```bash
./scripts/install_cursor_local.py
```

That installs plugins listed in `.cursor-plugin/marketplace.json` under `~/.cursor/plugins/local/<name>/` and registers them. Use `./scripts/install_cursor_local.py --dry-run` to preview. **Restart Cursor** after installing.

Add or enable the **godev** / **Go Development** plugin from Cursor’s plugin UI if your flow uses marketplace or local plugins.

## Layout (this plugin)

Paths are relative to the `godev/` folder:

| Path | Role |
|------|------|
| [`rules/go-style.mdc`](rules/go-style.mdc) | Formatting, naming, errors, concurrency, packages; prefer repo `golangci-lint` / `godev` when present. |
| [`rules/go-modules-tooling.mdc`](rules/go-modules-tooling.mdc) | **godev** CLI, **golangci-lint**, **gofumpt** / **golines**, verification, `go.mod` / `go.work`. |
| [`skills/go-write-test/`](skills/go-write-test/) | Strict table-driven tests (Args / Expects / Deps), testify, mocks, arrange/act/assert. |
| [`skills/go-code-review/`](skills/go-code-review/) | Go PR/diff review: correctness, concurrency, errors, tests, API. |
| [`agents/go-test-writer.md`](agents/go-test-writer.md) | Sub-agent for writing/updating Go unit tests using the same strict TDT conventions as **go-write-test**. |

There is **no** bundled `examples/` tree in this plugin copy.

## Use without the full marketplace (manual copy)

If you are not using the plugin installer, you can mirror pieces into a Go project:

1. Copy `rules/*.mdc` into your project’s `.cursor/rules/` (merge with existing rules).
2. Copy each folder under `skills/` into `.cursor/skills/` (avoid duplicate skill names).
3. Copy `agents/go-test-writer.md` into `.cursor/agents/` if your Cursor version loads agents from the project.

Open the project in Cursor; rules apply when `globs` match, and skills/agents are picked when the task fits their descriptions.

## Global skills (all workspaces)

To use a skill in **every** workspace, symlink it into your user skills directory, for example:

```bash
mkdir -p ~/.cursor/skills
ln -s /path/to/cursor-plugins/godev/skills/go-code-review ~/.cursor/skills/go-code-review
ln -s /path/to/cursor-plugins/godev/skills/go-write-test ~/.cursor/skills/go-write-test
```

Do **not** use `~/.cursor/skills-cursor/` for custom skills—that area is reserved for Cursor’s built-in skills.

**Rules** are usually project-local; copy `rules/` into each repo’s `.cursor/rules/` or use Cursor **user rules** for global Go guidance.

## Verify

1. Open a `.go` file and confirm the Go rules show up where your Cursor version lists project rules.
2. Try prompts that match a skill or agent, e.g. “Review this Go change with the Go code review skill” or “Add tests using strict TDT / go-write-test.”

## Updating

Pull `cursor-plugins`, rerun `./scripts/install_cursor_local.py` (or sync your manual copies / symlinks).

## Customizing

Edit the `.mdc` files, `SKILL.md` files, or the agent markdown to match your team; prefer **one main concern per rule file** to keep context small and predictable. Fork or vendor the `godev/` tree if you need a long-lived fork.
