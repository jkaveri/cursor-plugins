# warn-missing-doc-updates

Starter hook for **Cursor** (`afterFileEdit`) and **Claude Code** (`PostToolUse` after `Write` / `Edit`): when the edited path looks like **product code** (not under `docs/`), print a one-line reminder to **`stderr`** so you consider updating **`docs/specs/<feature>/`** or **`docs/decisions/`**.

## Behavior

- Reads the hook **JSON payload from stdin**.
- If **`jq`** is installed, extracts a path from Claude’s `tool_input.file_path` / `tool_response.filePath`, or Cursor-style `file_path`, `path`, `file`, or `uri` (first match).
- Skips quietly when the path is under **`docs/`** (prefix `docs/` or contains `/docs/`).
- Always exits **0** (never blocks saves).

## Configuration

### `WARN_DOC_CODE_PREFIXES`

Optional. Comma-separated path **prefixes** (relative to repo root). When set, the script **only** warns if the edited path matches one of these prefixes (or has a path segment after `/` matching). When **unset**, any path outside `docs/` triggers the reminder.

Examples:

```bash
# Only nudge for changes under src/ or cmd/
export WARN_DOC_CODE_PREFIXES=src/,cmd/
```

Set this in the environment Cursor uses for hook subprocesses if your layout differs.

## Wiring hooks

- **Cursor** (`.cursor-plugin`): [`../../hooks.cursor.json`](../../hooks.cursor.json) — `afterFileEdit` with `command` relative to that file ([Cursor hooks](https://cursor.com/docs/hooks)).
- **Claude Code** (`.claude-plugin`): [`../../hooks.json`](../../hooks.json) — `PostToolUse` with matcher `Write|Edit` and `${CLAUDE_PLUGIN_ROOT}/hooks/warn-missing-doc-updates/warn.sh` ([Claude hooks](https://code.claude.com/docs/en/hooks)).

If your Cursor build only loads **project** hooks, copy or symlink this plugin’s `hooks.json` and `hooks/` tree into the repo’s **`.cursor/`** directory and adjust `command` paths so they resolve from that `hooks.json` location. **`chmod +x warn.sh`** if needed.

## Canonical `docs/` layout

See the **spec-driven-docs** rule and [`../../README.md`](../../README.md): `docs/planning/` (roadmap, features, ideas), `docs/architecture/`, `docs/decisions/adr-<NNN>-<title>.md`, `docs/specs/<feature>/`, `docs/runbooks/`, `docs/references/`.
