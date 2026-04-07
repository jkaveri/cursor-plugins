#!/usr/bin/env bash
# Remove plugins installed by install_cursor_local.sh from ~/.cursor/plugins/local and
# unregister them in ~/.claude/ (installed_plugins.json + settings.json).
#
# Requires: jq (https://jqlang.org/).
#
# Usage:
#   ./scripts/uninstall_cursor_local.sh
#   ./scripts/uninstall_cursor_local.sh --dry-run
#   ./scripts/uninstall_cursor_local.sh --repo-root /path/to/cursor-plugins

set -euo pipefail

usage() {
  cat <<'EOF'
Remove marketplace plugins installed into ~/.cursor/plugins/local and Claude config.

Usage:
  ./scripts/uninstall_cursor_local.sh [--dry-run] [--repo-root DIR]
EOF
}

slug() {
  local s
  s=$(printf '%s' "$1" | tr '[:upper:]' '[:lower:]')
  s=$(printf '%s' "$s" | sed -E 's/[^a-z0-9]+/-/g')
  s=$(printf '%s' "$s" | sed -E 's/^-+|-+$//g')
  if [[ -z "$s" ]]; then
    s=marketplace
  fi
  printf '%s' "$s"
}

load_json_or_empty() {
  local f="$1"
  if [[ -f "$f" ]] && jq empty "$f" 2>/dev/null; then
    cat "$f"
  else
    printf '%s\n' '{}'
  fi
}

remove_installed_plugin_entry() {
  local installed_path="$1"
  local plugin_id="$2"
  local tmp
  tmp=$(mktemp)
  jq --arg id "$plugin_id" \
    '.plugins |= (. // {} | del(.[$id]))' \
    <(load_json_or_empty "$installed_path") >"$tmp"
  mkdir -p "$(dirname "$installed_path")"
  mv "$tmp" "$installed_path"
}

remove_enabled_plugin() {
  local settings_path="$1"
  local plugin_id="$2"
  local tmp
  tmp=$(mktemp)
  jq --arg id "$plugin_id" \
    '.enabledPlugins |= (. // {} | del(.[$id]))' \
    <(load_json_or_empty "$settings_path") >"$tmp"
  mkdir -p "$(dirname "$settings_path")"
  mv "$tmp" "$settings_path"
}

SCRIPT_DIR=$(cd "$(dirname "$0")" && pwd)
REPO_ROOT=$(cd "$SCRIPT_DIR/.." && pwd)
DRY_RUN=0

while [[ $# -gt 0 ]]; do
  case "$1" in
    --dry-run)
      DRY_RUN=1
      shift
      ;;
    --repo-root)
      REPO_ROOT=$(cd "$2" && pwd)
      shift 2
      ;;
    -h | --help)
      usage
      exit 0
      ;;
    *)
      echo "Unknown option: $1" >&2
      usage >&2
      exit 1
      ;;
  esac
done

if ! command -v jq >/dev/null 2>&1; then
  echo "uninstall_cursor_local.sh requires jq (brew install jq)." >&2
  exit 1
fi

MP_PATH="$REPO_ROOT/.cursor-plugin/marketplace.json"
if [[ ! -f "$MP_PATH" ]]; then
  echo "Missing marketplace manifest: $MP_PATH" >&2
  exit 1
fi

MP_NAME=$(jq -r '.name // "marketplace"' "$MP_PATH")
PLUGIN_COUNT=$(jq '.plugins // [] | length' "$MP_PATH")

HOME_DIR="${HOME:?}"
LOCAL_ROOT="$HOME_DIR/.cursor/plugins/local"
MARKETPLACES_DIR="$HOME_DIR/.cursor/plugins/marketplaces/$(slug "$MP_NAME")"
CLAUDE_PLUGINS="$HOME_DIR/.claude/plugins/installed_plugins.json"
CLAUDE_SETTINGS="$HOME_DIR/.claude/settings.json"

echo "Repository: $REPO_ROOT"
echo "Marketplace: $MP_NAME ($PLUGIN_COUNT plugin(s) in manifest)"
echo "Local plugins dir: $LOCAL_ROOT"
if [[ "$DRY_RUN" -eq 1 ]]; then
  echo "(dry-run: no dirs removed, no Claude config updates)"
fi

removed=0

for ((i = 0; i < PLUGIN_COUNT; i++)); do
  name=$(jq -r ".plugins[$i].name // empty" "$MP_PATH")
  source=$(jq -r ".plugins[$i].source // empty" "$MP_PATH")
  if [[ -z "$name" || -z "$source" ]]; then
    echo "  skip: invalid entry (need name + source): index $i" >&2
    continue
  fi
  src=$(cd "$REPO_ROOT" && cd "$source" && pwd)
  if [[ ! -d "$src" ]]; then
    echo "  skip: missing folder for '$name': $src" >&2
    continue
  fi
  dst="$LOCAL_ROOT/$name"
  plugin_id="${name}@local"
  echo "  $name: remove $dst + unregister $plugin_id"

  if [[ "$DRY_RUN" -eq 0 ]]; then
    if [[ -d "$dst" ]]; then
      rm -rf "$dst"
    fi
    remove_installed_plugin_entry "$CLAUDE_PLUGINS" "$plugin_id"
    remove_enabled_plugin "$CLAUDE_SETTINGS" "$plugin_id"
  fi
  removed=$((removed + 1))
done

if [[ "$removed" -eq 0 ]]; then
  echo "No plugins processed (check marketplace.json and plugin folders)." >&2
  exit 2
fi

if [[ "$DRY_RUN" -eq 0 ]]; then
  if [[ -d "$MARKETPLACES_DIR" ]]; then
    rm -rf "$MARKETPLACES_DIR"
    echo "Removed marketplace copy: $MARKETPLACES_DIR"
  fi
fi

echo ""
echo "Done. Restart Cursor (or Reload Window) so changes take effect."
