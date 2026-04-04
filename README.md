# Cursor plugins marketplace

This repository follows the [multi-plugin marketplace layout](https://github.com/cursor/plugins): one root manifest lists every plugin; each plugin is a folder with its own `.cursor-plugin/plugin.json`.

## Layout

- `.cursor-plugin/marketplace.json` — marketplace name, owner, and the `plugins` array (each entry points at a subdirectory).
- `<plugin-id>/` — one installable plugin (skills, rules, agents, MCP, etc. per [Cursor Plugins](https://cursor.com/docs/plugins)).
- Included plugins in this repo include `godev/`, `gitworkflow/`, and `specdocs/` (spec-driven documentation: `docs/` layout, specs, ADRs, commands, hooks).

## Install locally (this machine)

From the repo root:

```bash
./scripts/install_cursor_local.py
```

This copies each plugin listed in `.cursor-plugin/marketplace.json` into `~/.cursor/plugins/local/<name>/` (real copies, not symlinks), mirrors `marketplace.json` under `~/.cursor/plugins/marketplaces/<slug>/`, and registers plugins in `~/.claude/plugins/installed_plugins.json` and `~/.claude/settings.json` so Cursor can load them. Use `./scripts/install_cursor_local.py --dry-run` to preview paths. Restart Cursor afterward.

## Add another plugin

1. Copy an existing plugin folder (e.g. `godev/`) to a new folder (use a short kebab-case id, e.g. `my-integration`).
2. Edit `<plugin-id>/.cursor-plugin/plugin.json`: set `name`, `displayName`, `version`, `description`, paths like `skills` / `rules`, and metadata.
3. Append an object to `plugins` in `.cursor-plugin/marketplace.json` with matching `name`, `source` (the folder name), and a short `description`.

Publish the Git URL in Cursor’s marketplace flow when you are ready; optional fields such as `logo` can be added under each plugin as needed.
