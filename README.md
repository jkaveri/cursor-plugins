# Plugin Marketplace

A multi-tool plugin marketplace compatible with both **Cursor** and **Claude Code**. One root manifest lists every plugin; each plugin is a folder with its own manifests.

## Plugins

| Plugin | Description |
|---|---|
| `godev` | Go rules (style, modules/tooling, logging), table-driven test writer, code review, logging audit |
| `gitworkflow` | Branch + commit, commit-only, staged-diff review, PR summaries |
| `specdocs` | Spec-driven docs: canonical `docs/` layout, feature specs, ADRs, doc sync, optional edit hook |

## Layout

```
.cursor-plugin/marketplace.json   # Cursor marketplace manifest
.claude-plugin/marketplace.json   # Claude Code marketplace manifest
<plugin-id>/
  .cursor-plugin/plugin.json      # Cursor plugin manifest
  .claude-plugin/plugin.json      # Claude Code plugin manifest
  skills/  rules/  commands/  agents/  hooks.json
```

## Install — Claude Code

Add this repo as a marketplace, then install individual plugins:

```bash
# Add the marketplace
/plugin marketplace add jkaveri/cursor-plugins

# Install a plugin
/plugin install godev@jk-stacks
/plugin install gitworkflow@jk-stacks
/plugin install specdocs@jk-stacks
```

Or configure it in your project’s `.claude/settings.json` for team auto-discovery:

```json
{
  "extraKnownMarketplaces": {
    "jk-stacks": {
      "source": {
        "source": "github",
        "repo": "jkaveri/cursor-plugins"
      }
    }
  },
  "enabledPlugins": {
    "godev@jk-stacks": true,
    "gitworkflow@jk-stacks": true,
    "specdocs@jk-stacks": true
  }
}
```

## Install — Cursor (local)

From the repo root:

```bash
./scripts/install_cursor_local.py
```

This copies each plugin listed in `.cursor-plugin/marketplace.json` into `~/.cursor/plugins/local/<name>/`, mirrors the manifest under `~/.cursor/plugins/marketplaces/<slug>/`, and registers plugins so Cursor can load them. Use `--dry-run` to preview. Restart Cursor afterward.

## Add another plugin

1. Create a new folder (short kebab-case id, e.g. `my-tool`).
2. Add both manifests:
   - `<plugin-id>/.cursor-plugin/plugin.json`
   - `<plugin-id>/.claude-plugin/plugin.json`
3. Append an entry to both root marketplace files:
   - `.cursor-plugin/marketplace.json`
   - `.claude-plugin/marketplace.json`
