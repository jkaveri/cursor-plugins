# cursor-go-skills

Reusable **Cursor** rules (`.cursor/rules/*.mdc`) and agent skills (`.cursor/skills/*/SKILL.md`) for **Go** development (including strict table-driven tests via **`go-write-test`**). Copy or symlink this content into Go projects or into your personal Cursor skills directory.

This repository is packaged as a **[Cursor plugin](https://cursor.com/docs/plugins)** via [`.cursor-plugin/plugin.json`](.cursor-plugin/plugin.json) (rules and skills paths match the layout described in the [plugin specification](https://github.com/cursor/plugins)). Install or add it from Cursor’s plugin UI when your Cursor version supports marketplace or local plugins.

## Requirements

- [Cursor](https://cursor.com) with **project rules** and **agent skills** available in your workflow (see Cursor documentation for how rules and skills are loaded in your version).

## Use in a Go project (recommended)

1. Clone or download this repository.
2. Copy the entire `.cursor/` directory into your Go project **root** (the same directory as `go.mod`).
3. If the project already has `.cursor/`, **merge** instead of overwriting:
   - Copy `.mdc` files into `.cursor/rules/`.
   - Copy each skill folder into `.cursor/skills/` (avoid duplicate skill names).
4. Open the Go project folder in Cursor.
5. **Rules** apply when their `globs` match files you work with (and when Cursor includes them per your settings). **Skills** are selected by the agent when the task matches their `description`.

## Git submodule (stay linked to upstream)

1. Add this repo as a submodule, for example:

   ```bash
   git submodule add <this-repo-url> third_party/cursor-go-skills
   ```

2. Copy or symlink from the submodule into your project root:

   ```bash
   cp -R third_party/cursor-go-skills/.cursor .
   ```

   After updating the submodule (`git submodule update --remote`), run the copy again or use a small script so `.cursor/` stays in sync.

3. **Alternative**: Open a multi-root workspace in Cursor that includes both your app and this repository (advanced; copying `.cursor/` into the app root is simpler).

## Global skills (all projects)

To use the bundled skills in **every** workspace:

1. Copy or symlink each skill directory into your user skills folder, for example:

   ```bash
   mkdir -p ~/.cursor/skills
   ln -s /path/to/cursor-go-skills/.cursor/skills/go-code-review ~/.cursor/skills/go-code-review
   ln -s /path/to/cursor-go-skills/.cursor/skills/go-change-workflow ~/.cursor/skills/go-change-workflow
   ln -s /path/to/cursor-go-skills/.cursor/skills/go-write-test ~/.cursor/skills/go-write-test
   ```

2. Do **not** install custom skills under `~/.cursor/skills-cursor/` — that directory is reserved for Cursor’s built-in skills.

**Rules** are normally **project-local** (`.cursor/rules/` in each repo). To get the same Go rules everywhere, copy `.cursor/rules/` into each repository or use Cursor **user rules** for global guidance outside this pack.

## Verify it works

1. Open a `.go` file in your project and confirm project rules appear in Cursor’s rules UI (wording and location depend on your Cursor version).
2. Ask the agent to do something that matches a skill, for example: “Review this Go change using the Go code review skill”, “Follow the Go change workflow for this fix”, or “Add Go tests using the go-write-test skill.”

## Updating

Pull the latest changes in this repository, then repeat the copy, symlink, or submodule sync step so your project’s `.cursor/` (or `~/.cursor/skills`) matches.

## Customizing

Edit the `.mdc` files and `SKILL.md` files to match your team, or fork this repository. Prefer **one main concern per rule file** to keep context use small and predictable.

## Contents

| Path | Purpose |
|------|---------|
| `.cursor/rules/go-style.mdc` | Errors, context, naming, packages |
| `.cursor/rules/go-modules-tooling.mdc` | `go mod`, vet, lint, dependencies |
| `.cursor/skills/go-write-test/` | Strict Go TDT (Args/Expects/Deps), testify, mocks — use via skill |
| `.cursor/skills/go-code-review/` | PR / diff review checklist |
| `.cursor/skills/go-change-workflow/` | Implement → test → tidy workflow |

## Example module

The [`examples/`](examples/) directory contains a runnable nested Go module ([`examples/demo`](examples/demo)) that exercises the bundled rules and skills. See [`examples/README.md`](examples/README.md) for layout, symlink notes, and how each package maps to the rules and skills.
