#!/usr/bin/env python3
"""
Remove plugins installed by install_cursor_local.py from ~/.cursor/plugins/local and
unregister them in ~/.claude/ (installed_plugins.json + settings.json).

Usage:
  ./scripts/uninstall_cursor_local.py
  ./scripts/uninstall_cursor_local.py --dry-run
  ./scripts/uninstall_cursor_local.py --repo-root /path/to/cursor-plugins
"""

from __future__ import annotations

import argparse
import json
import re
import shutil
import sys
from pathlib import Path


def _slug(s: str) -> str:
    s = s.strip().lower()
    s = re.sub(r"[^a-z0-9]+", "-", s)
    return s.strip("-") or "marketplace"


def _load_json(path: Path) -> dict:
    if not path.is_file():
        return {}
    try:
        return json.loads(path.read_text(encoding="utf-8"))
    except json.JSONDecodeError:
        return {}


def _save_json(path: Path, data: dict) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_text(json.dumps(data, indent=2) + "\n", encoding="utf-8")


def remove_installed_plugin_entry(installed_path: Path, plugin_id: str) -> None:
    data = _load_json(installed_path)
    plugins = data.get("plugins") or {}
    plugins.pop(plugin_id, None)
    data["plugins"] = plugins
    _save_json(installed_path, data)


def remove_enabled_plugin(settings_path: Path, plugin_id: str) -> None:
    data = _load_json(settings_path)
    ep = data.get("enabledPlugins") or {}
    ep.pop(plugin_id, None)
    data["enabledPlugins"] = ep
    _save_json(settings_path, data)


def main() -> int:
    ap = argparse.ArgumentParser(description="Remove Cursor marketplace plugins installed locally.")
    ap.add_argument(
        "--repo-root",
        type=Path,
        default=Path(__file__).resolve().parent.parent,
        help="Repository root (default: parent of scripts/)",
    )
    ap.add_argument("--dry-run", action="store_true", help="Print actions without writing files.")
    args = ap.parse_args()

    repo = args.repo_root.resolve()
    mp_path = repo / ".cursor-plugin" / "marketplace.json"
    if not mp_path.is_file():
        print(f"Missing marketplace manifest: {mp_path}", file=sys.stderr)
        return 1

    marketplace = json.loads(mp_path.read_text(encoding="utf-8"))
    mp_name = marketplace.get("name", "marketplace")
    plugins_meta = marketplace.get("plugins") or []

    home = Path.home()
    local_root = home / ".cursor" / "plugins" / "local"
    marketplaces_dir = home / ".cursor" / "plugins" / "marketplaces" / _slug(mp_name)
    claude_plugins = home / ".claude" / "plugins" / "installed_plugins.json"
    claude_settings = home / ".claude" / "settings.json"

    print(f"Repository: {repo}")
    print(f"Marketplace: {mp_name} ({len(plugins_meta)} plugin(s) in manifest)")
    print(f"Local plugins dir: {local_root}")
    if args.dry_run:
        print("(dry-run: no dirs removed, no Claude config updates)")

    removed: list[tuple[str, Path]] = []

    for entry in plugins_meta:
        name = entry.get("name")
        source = entry.get("source")
        if not name or not source:
            print(f"  skip: invalid entry (need name + source): {entry!r}", file=sys.stderr)
            continue
        src = (repo / source).resolve()
        if not src.is_dir():
            print(f"  skip: missing folder for {name!r}: {src}", file=sys.stderr)
            continue
        dst = local_root / name
        plugin_id = f"{name}@local"
        print(f"  {name}: remove {dst} + unregister {plugin_id}")

        if not args.dry_run:
            if dst.exists():
                shutil.rmtree(dst)
            remove_installed_plugin_entry(claude_plugins, plugin_id)
            remove_enabled_plugin(claude_settings, plugin_id)
        removed.append((name, dst))

    if not removed:
        print("No plugins processed (check marketplace.json and plugin folders).", file=sys.stderr)
        return 2

    if not args.dry_run and marketplaces_dir.exists():
        shutil.rmtree(marketplaces_dir)
        print(f"Removed marketplace copy: {marketplaces_dir}")

    print()
    print("Done. Restart Cursor (or Reload Window) so changes take effect.")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
