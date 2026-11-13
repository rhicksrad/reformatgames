#!/usr/bin/env bash
# Starts a new Reformat Games repository from templates/new-game/.
#   tools/new_game.sh <target-dir> "<Display Name>" <Namespace> <slug>
#   tools/new_game.sh ../StarFarm "Star Farm" StarFarm star-farm
# Copies the template (dotfiles included) into an empty or new directory and
# replaces GAME_NAME, GameNs and game-slug in file contents and file names.
# It does not run git; read the result, then make the first commit.
set -euo pipefail
if [ $# -ne 4 ]; then
  sed -n '2,6p' "$0" >&2
  exit 64
fi
target=$1 name=$2 ns=$3 slug=$4
[[ $ns =~ ^[A-Z][A-Za-z0-9]*$ ]] || { echo "Namespace must be PascalCase letters and digits: $ns" >&2; exit 64; }
[[ $slug =~ ^[a-z0-9]+(-[a-z0-9]+)*$ ]] || { echo "slug must be lowercase words joined by hyphens: $slug" >&2; exit 64; }
src="$(cd "$(dirname "$0")/.." && pwd)/templates/new-game"
if [ -e "$target" ] && [ -n "$(ls -A "$target" 2>/dev/null | grep -v '^\.git$' || true)" ]; then
  echo "$target is not empty" >&2
  exit 1
fi
mkdir -p "$target"
cp -R "$src/." "$target/"
cd "$target"
# Rename paths deepest first so parent renames do not break child paths.
find . -depth -name '*GameNs*' -not -path './.git/*' | while read -r p; do
  mv "$p" "$(dirname "$p")/$(basename "$p" | sed "s/GameNs/$ns/g")"
done
esc_name=$(printf '%s' "$name" | sed 's/[&/\]/\\&/g')
grep -rlI -e GAME_NAME -e GameNs -e game-slug --exclude-dir=.git . | while read -r f; do
  sed -i.bak -e "s/GAME_NAME/$esc_name/g" -e "s/GameNs/$ns/g" -e "s/game-slug/$slug/g" "$f" && rm -f "$f.bak"
done
chmod +x tools/hooks/pre-push tools/ci/*.sh
echo "Created $name in $target. Next: standards/NEW_GAME.md, step 2 onward."
