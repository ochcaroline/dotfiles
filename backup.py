#!/usr/bin/env python3
"""Backup dotfiles from default config locations to the current directory."""

import shutil
import subprocess
import sys
from pathlib import Path

HOME = Path.home()
DEST = Path.cwd()

DOTFILES = [
    (HOME / ".tmux.conf", DEST / ".tmux.conf"),
    (HOME / ".zshrc", DEST / ".zshrc"),
    (HOME / ".skhdrc", DEST / ".skhdrc"),
    (HOME / "nvim", DEST / "nvim"),
    (HOME / "yazi", DEST / "yazi"),
    (HOME / ".config" / "starship.toml", DEST / ".config" / "starship.toml"),
]


def is_git_repo(path: Path) -> bool:
    result = subprocess.run(
        ["git", "-C", str(path), "rev-parse", "--is-inside-work-tree"],
        capture_output=True,
        text=True,
    )
    return result.returncode == 0


def copy(src: Path, dest: Path) -> None:
    if not src.exists():
        print(f"  [skip] {src} — not found")
        return

    dest.parent.mkdir(parents=True, exist_ok=True)

    if src.is_dir():
        if dest.exists():
            shutil.rmtree(dest)
        shutil.copytree(src, dest)
    else:
        shutil.copy2(src, dest)

    print(f"  [ok]   {src} → {dest.relative_to(DEST)}")


def main() -> None:
    if not is_git_repo(DEST):
        print(f"Error: '{DEST}' is not a git repository. Aborting.")
        sys.exit(1)

    print(f"Backing up dotfiles to: {DEST}\n")
    for src, dest in DOTFILES:
        copy(src, dest)

    print("\nDone.")


if __name__ == "__main__":
    main()
