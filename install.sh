#!/bin/sh
# Install tdk-skills by symlinking skills/<name> into agent skill directories.
# Never copies the markdown. Never uses sudo.
set -eu

REPO_URL="${TDK_SKILLS_REPO:-https://github.com/tdk-landscape/tdk-skills.git}"
AGENT=""
SCOPE="project"

usage() {
  echo "usage: install.sh [--agent claude|codex|opencode|cursor|agents] [--global|--project]" >&2
  exit 2
}

while [ $# -gt 0 ]; do
  case "$1" in
    --agent) [ $# -ge 2 ] || usage; AGENT="$2"; shift 2 ;;
    --global) SCOPE="global"; shift ;;
    --project) SCOPE="project"; shift ;;
    -h|--help) usage ;;
    *) usage ;;
  esac
done

case "$AGENT" in ""|claude|codex|opencode|cursor|agents) ;; *) usage ;; esac

# Source: this checkout if run from one, otherwise a cached clone.
SELF_DIR=""
case "$0" in */*) SELF_DIR="$(cd "$(dirname "$0")" 2>/dev/null && pwd)" || SELF_DIR="" ;; esac
if [ -n "$SELF_DIR" ] && [ -d "$SELF_DIR/skills" ]; then
  SRC="$SELF_DIR/skills"
else
  CACHE="${XDG_DATA_HOME:-$HOME/.local/share}/tdk-skills"
  if [ -d "$CACHE/.git" ]; then
    git -C "$CACHE" pull --ff-only --quiet
  else
    git clone --depth 1 --quiet "$REPO_URL" "$CACHE"
  fi
  SRC="$CACHE/skills"
fi

if [ "$SCOPE" = "global" ]; then BASE="$HOME"; else BASE="$(pwd)"; fi

agent_dir() {
  case "$1:$SCOPE" in
    agents:*|codex:*) echo ".agents/skills" ;;
    claude:*)         echo ".claude/skills" ;;
    cursor:*)         echo ".cursor/skills" ;;
    opencode:global)  echo ".config/opencode/skills" ;;
    opencode:project) echo ".opencode/skills" ;;
  esac
}

link_all() {
  dest="$BASE/$1"
  mkdir -p "$dest" || { echo "cannot create $dest; create it manually and re-run" >&2; exit 1; }
  for d in "$SRC"/*/; do
    name="$(basename "$d")"
    target="$dest/$name"
    if [ -L "$target" ]; then rm "$target"
    elif [ -e "$target" ]; then echo "skip $target (exists, not a symlink)" >&2; continue; fi
    ln -s "${d%/}" "$target"
    echo "linked $target -> ${d%/}"
  done
}

link_all ".agents/skills"
if [ -n "$AGENT" ]; then
  dir="$(agent_dir "$AGENT")"
  [ "$dir" = ".agents/skills" ] || link_all "$dir"
fi
