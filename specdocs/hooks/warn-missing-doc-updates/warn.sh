#!/usr/bin/env bash
# Cursor: afterFileEdit. Claude Code: PostToolUse (Write|Edit).
# Reminds to update docs when product code changes. Exits 0 always.
#
# Optional env (comma-separated path prefixes, relative to repo root): WARN_DOC_CODE_PREFIXES
# Default if unset: warn for any path not under docs/

set -euo pipefail

payload="$(cat || true)"

path=""
if command -v jq >/dev/null 2>&1 && [[ -n "${payload//[$'\t\r\n ']/}" ]]; then
  path="$(echo "$payload" | jq -r '
    (try .tool_input.file_path catch empty)
    // (try .tool_response.filePath catch empty)
    // (try .file_path catch empty)
    // (try .path catch empty)
    // (try .file catch empty)
    // (try .uri catch empty)
    // empty
  ' 2>/dev/null | head -1)"
fi

# Normalize: strip file:// and leading ./
path="${path#file://}"
path="${path#./}"

if [[ -z "$path" ]]; then
  exit 0
fi

# Skip documentation tree
case "$path" in
  docs/*|*/docs/*) exit 0 ;;
esac

# Optional: only warn when path matches one of WARN_DOC_CODE_PREFIXES (comma-separated)
if [[ -n "${WARN_DOC_CODE_PREFIXES:-}" ]]; then
  matched=0
  IFS=',' read -ra _prefixes <<< "${WARN_DOC_CODE_PREFIXES}"
  for p in "${_prefixes[@]}"; do
    p="${p#"${p%%[![:space:]]*}"}"
    p="${p%"${p##*[![:space:]]}"}"
    [[ -z "$p" ]] && continue
    case "$path" in
      ${p}*|*/${p}*) matched=1; break ;;
    esac
  done
  if [[ "$matched" -eq 0 ]]; then
    exit 0
  fi
fi

echo "specdocs: consider updating docs/specs/ or docs/decisions/ after changing: ${path}" >&2
exit 0
