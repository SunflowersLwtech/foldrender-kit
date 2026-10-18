#!/bin/sh
# Installs the FoldRender Artifacts command and the agent skill.
#
#   curl -fsSL https://foldrender.dev/install.sh | sh
#   sh install.sh [--skills-dir DIR] [--no-skill]
#
# Safe to run again: it replaces the command and the skill with the current
# versions. It does not edit shell profiles. If ~/.local/bin is not on PATH,
# it prints the line to add.

set -eu

BASE="${FOLDRENDER_BASE:-https://foldrender.dev}"
BASE="${BASE%/}"
BIN_DIR="$HOME/.local/bin"
SKILL_NAME="foldrender-artifacts"
INSTALL_SKILL=1
SKILLS_DIR=""

usage() {
  cat <<'EOF'
Usage: install.sh [--skills-dir DIR] [--no-skill]

  --skills-dir DIR  also install the skill into DIR/foldrender-artifacts/
  --no-skill        install only the foldrender command
EOF
}

fail() {
  echo "install.sh: $*" >&2
  exit 1
}

while [ $# -gt 0 ]; do
  case "$1" in
    --no-skill)
      INSTALL_SKILL=0
      shift
      ;;
    --skills-dir)
      [ $# -ge 2 ] || { echo "install.sh: --skills-dir needs a directory" >&2; exit 2; }
      SKILLS_DIR="$2"
      shift 2
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    *)
      echo "install.sh: unknown option: $1" >&2
      usage >&2
      exit 2
      ;;
  esac
done

command -v curl >/dev/null 2>&1 || fail "curl is required"

tmp="$(mktemp -d "${TMPDIR:-/tmp}/foldrender-install.XXXXXX")"
trap 'rm -rf "$tmp"' EXIT INT TERM

fetch() {
  curl -fsSL "$BASE/$1" -o "$2" || fail "could not download $BASE/$1"
}

# Fetch everything before writing anything, so a failed download leaves the
# machine as it was.
fetch "install/foldrender" "$tmp/foldrender"
head -n 1 "$tmp/foldrender" | grep -q '^#!/' || fail "$BASE/install/foldrender did not return the command"
if [ "$INSTALL_SKILL" = 1 ]; then
  fetch "install/SKILL.md" "$tmp/SKILL.md"
  head -n 1 "$tmp/SKILL.md" | grep -q '^---' || fail "$BASE/install/SKILL.md did not return the skill"
fi

mkdir -p "$BIN_DIR"
cp "$tmp/foldrender" "$BIN_DIR/.foldrender.new"
chmod 755 "$BIN_DIR/.foldrender.new"
mv -f "$BIN_DIR/.foldrender.new" "$BIN_DIR/foldrender"
echo "Installed the command: $BIN_DIR/foldrender"

install_skill() {
  dest="$1/$SKILL_NAME"
  mkdir -p "$dest"
  cp "$tmp/SKILL.md" "$dest/SKILL.md.new"
  mv -f "$dest/SKILL.md.new" "$dest/SKILL.md"
  echo "Installed the skill:   $dest/SKILL.md"
}

if [ "$INSTALL_SKILL" = 1 ]; then
  found=0
  for home in "$HOME/.claude" "$HOME/.codex" "$HOME/.agents"; do
    if [ -d "$home" ]; then
      install_skill "$home/skills"
      found=1
    fi
  done
  if [ -n "$SKILLS_DIR" ]; then
    install_skill "$SKILLS_DIR"
    found=1
  fi
  if [ "$found" = 0 ]; then
    echo "No agent home found (~/.claude, ~/.codex, ~/.agents), so no skill was installed."
    echo "To install it anyway, run again with --skills-dir DIR."
  fi
fi

case ":$PATH:" in
  *":$BIN_DIR:"*)
    cmd="foldrender"
    ;;
  *)
    cmd="$BIN_DIR/foldrender"
    echo ""
    echo "$BIN_DIR is not on your PATH. To use foldrender by name, add this line to your"
    echo "shell profile (for example ~/.zshrc or ~/.bashrc) and open a new terminal:"
    echo "  export PATH=\"\$HOME/.local/bin:\$PATH\""
    ;;
esac

echo ""
echo "Next step: $cmd login"
