# Spec-Driven Docs (`specdocs`)

Cursor plugin for **spec-driven documentation**: a canonical **`docs/`** tree, skills for feature specs and ADRs, doc sync checks, slash-style **commands**, and an optional **`afterFileEdit`** hook reminder. It lives in the [`jkaveri/cursor-plugins`](https://github.com/jkaveri/cursor-plugins) multi-plugin repo; see the root [README](../README.md) for marketplace layout.

Manifest: [`.cursor-plugin/plugin.json`](.cursor-plugin/plugin.json).

## Requirements

- [Cursor](https://cursor.com) with support for **rules**, **skills**, **commands**, and **hooks** as loaded from installed plugins (see [Cursor Plugins](https://cursor.com/docs/plugins)).

## Documentation layout (convention)

Default tree for consuming repositories (adapt if your org already standardizes something else):

```text
docs/
  README.md
  planning/
    roadmap.md
    features.md
    ideas.md
  architecture/
    system-overview.md
    folder-structure.md
    integrations.md
  decisions/
    adr-001-<title>.md
    adr-002-<title>.md
  specs/
    <feature-name>/
      spec.md
      plan.md
      tasks.md
      rollout.md
      test-cases.md
  runbooks/
    local-development.md
    release.md
    incident-response.md
  references/
    api.md
    domain-glossary.md
```

**Planning** (`docs/planning/`): **roadmap** (themes and horizons), **features** (inventory with status and links to `docs/specs/<feature>/`), and **ideas** (backlog to triage). Full policy and globs: [`rules/spec-driven-docs.mdc`](rules/spec-driven-docs.mdc).

## Install (recommended)

From the **repository root** (`cursor-plugins`):

```bash
./scripts/install_cursor_local.py
```

That installs plugins listed in `.cursor-plugin/marketplace.json` under `~/.cursor/plugins/local/<name>/` and registers them. Use `./scripts/install_cursor_local.py --dry-run` to preview. **Restart Cursor** after installing.

Add or enable the **specdocs** / **Spec-Driven Docs** plugin from Cursor’s plugin UI if your flow uses marketplace or local plugins.

## Layout (this plugin)

Paths are relative to the `specdocs/` folder:

| Path | Role |
|------|------|
| [`rules/spec-driven-docs.mdc`](rules/spec-driven-docs.mdc) | Canonical **`docs/`** layout (including **`planning/`** for roadmap, feature list, ideas), when to update specs/ADRs/runbooks, review checklist. |
| [`skills/write-feature-spec/`](skills/write-feature-spec/) | Create or refresh **`docs/specs/<feature>/`** (`spec.md`, plus optional `plan`, `tasks`, `rollout`, `test-cases`). |
| [`skills/update-spec-from-change/`](skills/update-spec-from-change/) | Map diffs or descriptions to the right spec files and related docs. |
| [`skills/check-doc-sync/`](skills/check-doc-sync/) | Compare **`docs/specs/`**, **`docs/planning/`**, architecture, references, and runbooks vs code or APIs. |
| [`skills/write-adr/`](skills/write-adr/) | ADRs under **`docs/decisions/adr-<NNN>-<title>.md`**. |
| [`commands/spec-start.md`](commands/spec-start.md) | Entry: **write-feature-spec**. |
| [`commands/spec-update.md`](commands/spec-update.md) | Entry: **update-spec-from-change**. |
| [`commands/doc-sync-check.md`](commands/doc-sync-check.md) | Entry: **check-doc-sync**. |
| [`commands/write-adr.md`](commands/write-adr.md) | Entry: **write-adr**. |
| [`hooks.json`](hooks.json) | **`afterFileEdit`** → [`hooks/warn-missing-doc-updates/warn.sh`](hooks/warn-missing-doc-updates/warn.sh). |
| [`hooks/warn-missing-doc-updates/README.md`](hooks/warn-missing-doc-updates/README.md) | Hook behavior, **`WARN_DOC_CODE_PREFIXES`**, project-local wiring. |

## Use without the full marketplace (manual copy)

1. Copy `rules/*.mdc` into your project’s `.cursor/rules/` (merge with existing rules).
2. Copy each folder under `skills/` into `.cursor/skills/` (avoid duplicate skill names).
3. Copy `commands/*.md` into `.cursor/commands/` if your Cursor version loads project commands from there.
4. For hooks, copy `hooks.json` and the `hooks/` directory into `.cursor/` and adjust paths; see [`hooks/warn-missing-doc-updates/README.md`](hooks/warn-missing-doc-updates/README.md).

## Team Marketplace

To distribute this marketplace to a team:

- Publish or share this repository’s URL and add it in Cursor’s **Team** (or org) marketplace flow when available.
- Ensure **`.cursor-plugin/marketplace.json`** in the repo lists **`specdocs`** with `"source": "specdocs"` so `./scripts/install_cursor_local.py` installs it.
- Members run the install script (or sync plugins from your internal mirror) and enable **Spec-Driven Docs** in the plugin UI.

## Verify

1. Open a file under `docs/` or source code in a project using the rule; confirm **spec-driven-docs** appears where your Cursor version lists rules (when globs match).
2. Run a command or prompt that references **write-feature-spec**, **update-spec-from-change**, **check-doc-sync**, or **write-adr**.

## Updating

Pull `cursor-plugins`, rerun `./scripts/install_cursor_local.py` (or sync manual copies / symlinks).

## Customizing

Edit the `.mdc` files and `SKILL.md` files to match your team’s folder names; keep **one main concern per rule file** where possible.
