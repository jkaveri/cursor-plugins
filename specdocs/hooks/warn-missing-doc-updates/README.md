# warn-missing-doc-updates

Starter hook for Cursor **`afterFileEdit`**: when a saved path looks like **product code** (not under `docs/`), print a one-line reminder to **`stderr`** so you consider updating **`docs/specs/<feature>/`** or **`docs/decisions/`**.

## Behavior

- Reads the hook **JSON payload from stdin** (Cursor supplies this for `afterFileEdit`).
- If **`jq`** is installed, extracts a path from `file_path`, `path`, `file`, or `uri` (first match).
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

This plugin ships [`../../hooks.json`](../../hooks.json) with:

```json
"command": "hooks/warn-missing-doc-updates/warn.sh"
```

Paths are **relative to the `hooks.json` file** (the [Cursor hooks](https://cursor.com/docs/hooks) convention).

If your Cursor build only loads **project** hooks, copy or symlink this plugin’s `hooks.json` and `hooks/` tree into the repo’s **`.cursor/`** directory and adjust `command` paths so they resolve from that `hooks.json` location. **`chmod +x warn.sh`** if needed.

## Canonical `docs/` layout

See the **spec-driven-docs** rule and [`../../README.md`](../../README.md): `docs/planning/` (roadmap, features, ideas), `docs/architecture/`, `docs/decisions/adr-<NNN>-<title>.md`, `docs/specs/<feature>/`, `docs/runbooks/`, `docs/references/`.
