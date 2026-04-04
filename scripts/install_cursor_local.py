#!/usr/bin/env python3
"""
Install this repo's marketplace plugins into Cursor's local plugin directory and
register them in ~/.claude/ (installed_plugins.json + settings.json).

Uses real directory copies (not symlinks); symlinks to ~/.cursor/plugins/local/
are unreliable in some Cursor builds.

Usage:
  ./scripts/install_cursor_local.py
  ./scripts/install_cursor_local.py --dry-run
  ./scripts/install_cursor_local.py --repo-root /path/to/cursor-plugins
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


def upsert_installed_plugin(installed_path: Path, plugin_id: str, install_path: Path) -> None:
    data = _load_json(installed_path)
    plugins = data.setdefault("plugins", {})
    plugins[plugin_id] = [{"scope": "user", "installPath": str(install_path.resolve())}]
    data["plugins"] = plugins
    _save_json(installed_path, data)


def upsert_enabled(settings_path: Path, plugin_id: str, enabled: bool = True) -> None:
    data = _load_json(settings_path)
    ep = data.setdefault("enabledPlugins", {})
    ep[plugin_id] = enabled
    data["enabledPlugins"] = ep
    _save_json(settings_path, data)


def main() -> int:
    ap = argparse.ArgumentParser(description="Install Cursor marketplace plugins locally.")
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
        print("(dry-run: no files copied, no Claude config updates)")

    installed: list[tuple[str, Path, Path]] = []

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
        print(f"  {name}: {src} -> {dst}")

        if not args.dry_run:
            local_root.mkdir(parents=True, exist_ok=True)
            if dst.exists():
                shutil.rmtree(dst)
            shutil.copytree(src, dst, symlinks=False)
            upsert_installed_plugin(claude_plugins, plugin_id, dst)
            upsert_enabled(claude_settings, plugin_id, True)
        installed.append((name, src, dst))

    if not installed:
        print("No plugins installed (check marketplace.json and plugin folders).", file=sys.stderr)
        return 2

    # Optional: mirror marketplace manifest for your reference (Cursor may also use Git URL in UI).
    if not args.dry_run:
        marketplaces_dir.mkdir(parents=True, exist_ok=True)
        shutil.copy2(mp_path, marketplaces_dir / "marketplace.json")
        print(f"Copied marketplace.json -> {marketplaces_dir / 'marketplace.json'}")

    print()
    print("Done. Restart Cursor (or Reload Window) so plugins are picked up.")
    print("If commands/skills do not appear, enable third-party plugins in Cursor Settings > Features.")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
