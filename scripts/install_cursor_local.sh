#!/usr/bin/env bash
# Install this repo's marketplace plugins into Cursor's local plugin directory and
# register them in ~/.claude/ (installed_plugins.json + settings.json).
#
# Uses real directory copies (not symlinks); symlinks to ~/.cursor/plugins/local/
# are unreliable in some Cursor builds.
#
# Requires: jq (https://jqlang.org/) for JSON merge.
#
# Usage:
#   ./scripts/install_cursor_local.sh
#   ./scripts/install_cursor_local.sh --dry-run
#   ./scripts/install_cursor_local.sh --repo-root /path/to/cursor-plugins

set -euo pipefail

usage() {
  cat <<'EOF'
Install marketplace plugins into ~/.cursor/plugins/local and register in ~/.claude/.

Usage:
  ./scripts/install_cursor_local.sh [--dry-run] [--repo-root DIR]
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

upsert_installed_plugin() {
  local installed_path="$1"
  local plugin_id="$2"
  local install_path="$3"
  local tmp
  tmp=$(mktemp)
  jq --arg id "$plugin_id" --arg path "$install_path" \
    '.plugins |= (. // {}) | .plugins[$id] = [{"scope": "user", "installPath": $path}]' \
    <(load_json_or_empty "$installed_path") >"$tmp"
  mkdir -p "$(dirname "$installed_path")"
  mv "$tmp" "$installed_path"
}

upsert_enabled() {
  local settings_path="$1"
  local plugin_id="$2"
  local tmp
  tmp=$(mktemp)
  jq --arg id "$plugin_id" \
    '.enabledPlugins |= (. // {}) | .enabledPlugins[$id] = true' \
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
  echo "install_cursor_local.sh requires jq (brew install jq)." >&2
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
  echo "(dry-run: no files copied, no Claude config updates)"
fi

installed=0

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
  echo "  $name: $src -> $dst"

  if [[ "$DRY_RUN" -eq 0 ]]; then
    mkdir -p "$LOCAL_ROOT"
    rm -rf "$dst"
    cp -R "$src" "$dst"
    dst_abs=$(cd "$dst" && pwd)
    upsert_installed_plugin "$CLAUDE_PLUGINS" "$plugin_id" "$dst_abs"
    upsert_enabled "$CLAUDE_SETTINGS" "$plugin_id"
  fi
  installed=$((installed + 1))
done

if [[ "$installed" -eq 0 ]]; then
  echo "No plugins installed (check marketplace.json and plugin folders)." >&2
  exit 2
fi

if [[ "$DRY_RUN" -eq 0 ]]; then
  mkdir -p "$MARKETPLACES_DIR"
  cp -f "$MP_PATH" "$MARKETPLACES_DIR/marketplace.json"
  echo "Copied marketplace.json -> $MARKETPLACES_DIR/marketplace.json"
fi

echo ""
echo "Done. Restart Cursor (or Reload Window) so plugins are picked up."
echo "If commands/skills do not appear, enable third-party plugins in Cursor Settings > Features."
