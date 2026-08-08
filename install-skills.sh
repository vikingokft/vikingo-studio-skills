#!/usr/bin/env bash
# install-skills.sh
#
# Két dolgot csinál:
#   1) A repóba BEMÁSOLT (vendored) skilleket symlinkeli ~/.claude/skills/-be.
#   2) Az EXTERNAL forrásokat (licenc nélküli, nem bemásolt) a GÉPEDRE klónozza a
#      .external/ mappába, majd onnan symlinkeli a skilleket. Így a licenc nélküli
#      tartalmat nem ez a repó osztja újra — te húzod le közvetlenül az eredetiből.
#
# Újrafuttatás biztonságos: frissíti a meglévő symlinkeket, az external klónokat
# pedig `git pull`-lal naprakészre hozza.
#
# Használat:
#   ./install-skills.sh

set -euo pipefail

REPO="$(cd "$(dirname "$0")" && pwd)"
SKILLS_DIR="${CLAUDE_SKILLS_DIR:-$HOME/.claude/skills}"
EXT_DIR="$REPO/.external"
SRC_CONF="$REPO/sources.conf"

mkdir -p "$SKILLS_DIR"

link_skill() {  # $1 = skill könyvtár
  local skill_dir="$1" name existing
  name="$(basename "$skill_dir")"
  # Miért: a symlink-névtér lapos, két azonos nevű skill némán felülírná egymást.
  # Ütközésnél szólunk, hogy látszódjon, melyik forrás nyert.
  if [ -L "$SKILLS_DIR/$name" ] && [ -e "$SKILLS_DIR/$name" ]; then
    existing="$(readlink "$SKILLS_DIR/$name")"
    if [ "$existing" != "$skill_dir" ]; then
      echo "  ⚠ névütközés: $name — eddig: $existing, most erre áll át: $skill_dir"
    fi
  fi
  ln -sfn "$skill_dir" "$SKILLS_DIR/$name"
}

# 1) Vendored skillek (a repóban) — minden SKILL.md a domain-mappákban.
vendored=0
while IFS= read -r skill_md; do
  link_skill "$(dirname "$skill_md")"
  vendored=$((vendored + 1))
done < <(find "$REPO" -name SKILL.md -not -path '*/.git/*' -not -path "$EXT_DIR/*")
echo "→ $vendored vendored skill symlinkelve"

# 2) External források — klónozás a gépedre, majd symlink.
if [ -f "$SRC_CONF" ]; then
  mkdir -p "$EXT_DIR"
  grep -E '^\s*external\s*\|' "$SRC_CONF" | while IFS='|' read -r mode id repo ref from to; do
    id="$(echo "$id" | xargs)"; repo="$(echo "$repo" | xargs)"; ref="$(echo "$ref" | xargs)"
    from="$(echo "$from" | xargs)"
    clone="$EXT_DIR/$id"
    if [ -d "$clone/.git" ]; then
      echo "→ [$id] frissítés (git pull)"
      git -C "$clone" pull --quiet --ff-only 2>/dev/null || echo "  ⚠ pull sikertelen, a meglévő klónt használom"
    else
      echo "→ [$id] klónozás: $repo ($ref)"
      git clone --quiet --depth 1 --branch "$ref" --single-branch "$repo" "$clone" 2>/dev/null \
        || git clone --quiet --depth 1 "$repo" "$clone"
    fi
    ext=0
    if [ -d "$clone/$from" ]; then
      while IFS= read -r skill_md; do
        link_skill "$(dirname "$skill_md")"
        ext=$((ext + 1))
      done < <(find "$clone/$from" -name SKILL.md -not -path '*/.git/*')
    fi
    echo "  ✓ $ext external skill symlinkelve ($id)"
  done
fi

# 3) MCP-szerverek regisztrálása (mcp.conf) — user hatókörrel, hogy minden
# projektben elérhetők legyenek. A már regisztráltat kihagyjuk, így az
# újrafuttatás biztonságos. Ha nincs claude CLI, a lépés némán kimarad.
MCP_CONF="$REPO/mcp.conf"
if [ -f "$MCP_CONF" ] && command -v claude >/dev/null 2>&1; then
  grep -Ev '^\s*(#|$)' "$MCP_CONF" | while IFS='|' read -r name cmd; do
    name="$(echo "$name" | xargs)"; cmd="$(echo "$cmd" | xargs)"
    [ -n "$name" ] && [ -n "$cmd" ] || continue
    if claude mcp get "$name" >/dev/null 2>&1; then
      echo "→ [mcp] $name már regisztrálva, kihagyva"
    else
      # shellcheck disable=SC2086 — a parancs szándékosan szavakra bontva megy át.
      if claude mcp add --scope user "$name" -- $cmd >/dev/null 2>&1; then
        echo "→ [mcp] $name regisztrálva (user hatókör): $cmd"
      else
        echo "  ⚠ [mcp] $name regisztrálása nem sikerült"
      fi
    fi
  done
fi

# 4) Takarítás: az ebből a repóból (vagy a klónjaiból) származó, de célt vesztett
# symlinkek eltávolítása. Miért: átnevezett vagy törölt skill után ne maradjon
# eltört link, ami a Claude Code-ot zavarná.
removed=0
for link in "$SKILLS_DIR"/*; do
  [ -L "$link" ] || continue
  case "$(readlink "$link")" in
    "$REPO"/*)
      if [ ! -e "$link" ]; then
        rm "$link"
        removed=$((removed + 1))
      fi
      ;;
  esac
done
[ "$removed" -gt 0 ] && echo "→ $removed eltört symlink eltávolítva"

echo "✓ Kész → $SKILLS_DIR"
