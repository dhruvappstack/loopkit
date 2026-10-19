#!/usr/bin/env bash
# LoopKit installer: copies the .loop/ spine and agent adapters into a target project.
# Non-destructive by default: existing files are never overwritten unless asked.
set -euo pipefail

VERSION="0.1.0"
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SRC="$ROOT/templates"
TARGET="."
AGENT="all"
FORCE=0
UPGRADE=0

usage() {
  cat <<USAGE
LoopKit $VERSION - loop engineering kit for AI coding agents

Usage: ./install.sh [options]

Options:
  -t, --target DIR    Project directory to install into (default: current directory)
  -a, --agent NAME    claude | copilot | cursor | generic | all | none   (default: all)
  -u, --upgrade       Update LOOP.md and playbooks only; never touch your spine state files
  -f, --force         Overwrite every file LoopKit manages (spine state included)
  -h, --help          Show this help
      --version       Print version
USAGE
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    -t|--target)  [[ $# -ge 2 ]] || { echo "Missing value for $1" >&2; exit 2; }; TARGET="$2"; shift 2 ;;
    -a|--agent)   [[ $# -ge 2 ]] || { echo "Missing value for $1" >&2; exit 2; }; AGENT="$2"; shift 2 ;;
    -u|--upgrade) UPGRADE=1; shift ;;
    -f|--force)   FORCE=1; shift ;;
    -h|--help)    usage; exit 0 ;;
    --version)    echo "$VERSION"; exit 0 ;;
    *) echo "Unknown option: $1" >&2; usage >&2; exit 2 ;;
  esac
done

case "$AGENT" in
  claude|copilot|cursor|generic|all|none) ;;
  *) echo "Invalid --agent '$AGENT'" >&2; exit 2 ;;
esac

[[ -d "$TARGET" ]] || { echo "Target directory not found: $TARGET" >&2; exit 1; }
TARGET="$(cd "$TARGET" && pwd)"
[[ -d "$SRC/.loop" ]] || { echo "Templates not found at $SRC (run from a full checkout)" >&2; exit 1; }

created=0; skipped=0; updated=0

# Files that are "managed" (safe to refresh on --upgrade): the protocol and playbooks.
is_managed() {
  case "$1" in
    .loop/LOOP.md|.loop/playbooks/*) return 0 ;;
    *) return 1 ;;
  esac
}

copy_file() { # copy_file <src> <dst> <relative-path>
  local src="$1" dst="$2" rel="$3"
  mkdir -p "$(dirname "$dst")"
  if [[ -e "$dst" ]]; then
    if [[ $FORCE -eq 1 ]] || { [[ $UPGRADE -eq 1 ]] && is_managed "$rel"; }; then
      if cmp -s "$src" "$dst"; then
        skipped=$((skipped + 1))
      else
        cp "$src" "$dst"; echo "  updated  $rel"; updated=$((updated + 1))
      fi
    else
      echo "  skip     $rel (exists)"; skipped=$((skipped + 1))
    fi
  else
    cp "$src" "$dst"; echo "  created  $rel"; created=$((created + 1))
  fi
}

inject_snippet() { # inject_snippet <snippet> <dst> <relative-path>
  local snip="$1" dst="$2" rel="$3" tmp
  mkdir -p "$(dirname "$dst")"
  if [[ ! -e "$dst" ]]; then
    cp "$snip" "$dst"; echo "  created  $rel"; created=$((created + 1)); return
  fi
  if grep -q '<!-- loopkit:start -->' "$dst"; then
    if [[ $FORCE -eq 1 || $UPGRADE -eq 1 ]]; then
      tmp="$(mktemp)"
      awk '/<!-- loopkit:start -->/{skip=1} !skip{print} /<!-- loopkit:end -->/{skip=0}' "$dst" > "$tmp"
      { cat "$tmp"; [[ -s "$tmp" ]] && echo; cat "$snip"; } > "$dst"
      rm -f "$tmp"; echo "  updated  $rel (LoopKit block)"; updated=$((updated + 1))
    else
      echo "  skip     $rel (LoopKit block present)"; skipped=$((skipped + 1))
    fi
  else
    { echo; cat "$snip"; } >> "$dst"; echo "  appended $rel"; updated=$((updated + 1))
  fi
}

install_tree() { # install_tree <source-dir>; maps *.snippet to injection, copies everything else
  local base="$1" f rel
  while IFS= read -r -d '' f; do
    rel="${f#"$base"/}"
    if [[ "$rel" == *.snippet ]]; then
      inject_snippet "$f" "$TARGET/${rel%.snippet}" "${rel%.snippet}"
    else
      copy_file "$f" "$TARGET/$rel" "$rel"
    fi
  done < <(find "$base" -type f -print0 | sort -z)
}

echo "Installing LoopKit $VERSION into $TARGET"
echo "Spine (.loop/):"
while IFS= read -r -d '' f; do
  rel=".loop/${f#"$SRC"/.loop/}"
  copy_file "$f" "$TARGET/$rel" "$rel"
done < <(find "$SRC/.loop" -type f -print0 | sort -z)
echo "$VERSION" > "$TARGET/.loop/.loopkit-version"

adapters=()
case "$AGENT" in
  all) adapters=(claude-code copilot cursor generic) ;;
  claude) adapters=(claude-code) ;;
  none) adapters=() ;;
  *) adapters=("$AGENT") ;;
esac
for a in ${adapters[@]+"${adapters[@]}"}; do
  echo "Adapter ($a):"
  install_tree "$SRC/adapters/$a"
done

echo
echo "Done: $created created, $updated updated, $skipped unchanged/skipped."
echo "Next: edit .loop/intent.md, then start a task with /loop (Claude Code) or the 'loop' prompt (Copilot)."
