#!/usr/bin/env bash
# sync-upstream.sh
#
# Több upstream forrásból bemásolja (vendored) a kiválasztott skilleket a megfelelő
# domain-mappákba, a sources.conf alapján. CSAK a `vendored` módú forrásokat érinti
# (a nyílt-licencűeket). Az `external` forrásokat NEM másolja be — azokat az
# install-skills.sh húzza a felhasználó gépére telepítéskor.
#
# A SKILL.md-t tartalmazó mappa neve lesz a skill neve. A `from` útvonal alatt
# rekurzívan keressük a SKILL.md-ket, így a lapos (skills/<skill>/) és a mély
# (plugins/*/skills/<skill>/) elrendezés is működik.
#
# Használat (a repó bármely pontjáról):
#   bash scripts/sync-upstream.sh
#
# Utána, ha jónak látod:
#   git add -A && git commit -m "Upstream sync" && git push
# A symlinkek frissítéséhez: ./install-skills.sh

set -euo pipefail

REPO="$(cd "$(dirname "$0")/.." && pwd)"
cd "$REPO"
SRC_CONF="$REPO/sources.conf"
TMP_ROOT="$(mktemp -d)"
trap 'rm -rf "$TMP_ROOT"' EXIT

[ -f "$SRC_CONF" ] || { echo "HIBA: nincs sources.conf ($SRC_CONF)"; exit 1; }

# A sources.conf vendored sorainak feldolgozása (kommentek és üres sorok kihagyva).
grep -E '^\s*vendored\s*\|' "$SRC_CONF" | while IFS='|' read -r mode id repo ref from to; do
  id="$(echo "$id" | xargs)"; repo="$(echo "$repo" | xargs)"; ref="$(echo "$ref" | xargs)"
  from="$(echo "$from" | xargs)"; to="$(echo "$to" | xargs)"
  [ "$from" = "." ] && from=""   # gyökér-szintű SKILL.md: a 'from' lehet üres VAGY "."
  clone="$TMP_ROOT/$id"
  if [ ! -d "$clone" ]; then
    echo "→ [$id] klónozás: $repo ($ref)"
    git clone --quiet --depth 1 --branch "$ref" --single-branch "$repo" "$clone" 2>/dev/null \
      || git clone --quiet --depth 1 "$repo" "$clone"   # ha a ref SHA, fallback teljes default branch
  fi   # azonos id-jű sorok (egy repo több domainje) újrahasználják a klónt

  src_base="$clone/$from"
  if [ ! -d "$src_base" ]; then
    echo "  ⚠ a 'from' útvonal nem létezik: $from — kihagyva"
    continue
  fi

  count=0
  while IFS= read -r skill_md; do
    skill_dir="$(dirname "$skill_md")"
    skill_name="$(basename "$skill_dir")"
    dest="$REPO/$to/$skill_name"
    rm -rf "$dest"
    mkdir -p "$REPO/$to"
    cp -R "$skill_dir" "$dest"
    rm -rf "$dest/.git"
    count=$((count + 1))
  done < <(find "$src_base" -name SKILL.md -not -path '*/.git/*' | sort)

  # Licenc-szöveg megőrzése (Apache-2.0 / MIT redistribúciós feltétel):
  # a forrás repo-szintű LICENSE-ét bemásoljuk a licenses/ mappába.
  mkdir -p "$REPO/licenses"
  lic_src="$(find "$clone" -maxdepth 1 -iname 'license*' -o -maxdepth 1 -iname 'copying*' 2>/dev/null | head -1)"
  if [ -n "$lic_src" ] && [ -f "$lic_src" ]; then
    cp "$lic_src" "$REPO/licenses/$id-LICENSE.txt"
    echo "  ✓ $count skill → $to/  (+ licenc: licenses/$id-LICENSE.txt)"
  else
    echo "  ✓ $count skill → $to/  (⚠ nincs repo-szintű LICENSE az upstreamben)"
  fi
done

if [ -z "${SKIP_INSTALL:-}" ]; then
  echo
  echo "→ symlinkek frissítése (~/.claude/skills)"
  bash "$REPO/install-skills.sh"
fi

echo
echo "✓ Kész. Ellenőrzés:  git status"
echo "  Ha jó:  git add -A && git commit -m 'Upstream sync' && git push"
