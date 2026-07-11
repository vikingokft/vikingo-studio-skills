# Changelog

A formátum a [Keep a Changelog](https://keepachangelog.com/) elvét követi.

## [Unreleased]

### Added
- **Saját skill domain (`vikingo/`):** az első saját skill a `vikingo-szabvany`, a
  Vikingo plugin- és repo-szabvány. A mappa nincs a sources.conf-ban, a napi sync
  nem érinti, kézzel, PR-rel módosul.
- `install-skills.sh`: névütközés-figyelmeztetés (ha két forrás azonos nevű skillt ad),
  és a célt vesztett symlinkek automatikus eltávolítása telepítéskor.

### Changed
- A `vikingokft/wp-agent-skills` fork 2026-07-10-én törölve lett; a WordPress készlet
  forrása közvetlenül a `Lonsdale201/wp-agent-skills` upstream.

### Fixed
- `upstream-sync.yml`: a PR számát a nem létező `gh pr create --json` helyett
  `gh pr list`-tel kérjük le (eddig csak a fallback ág miatt működött).
- **WordPress készlet egyesítése:** a `Lonsdale201/wp-agent-skills` (MIT) 5 megtartott
  domainje (wordpress, woocommerce, jet-engine, plugin-scaffold, wp-rocket = 62 skill)
  bemásolva. Ezzel a `vikingokft/wp-agent-skills` fork nyugdíjazható: ez a repó lett a
  Vikingo Stúdió egyetlen skill-forrása (összesen 178 vendored skill).
- A `sync-upstream.sh` egy repót csak egyszer klónoz akkor is, ha több domaint hoz belőle
  (azonos `id` a sources.conf-ban).
- Induló kiadás: multi-source kurátor a vikingo-studio-skills repóhoz.
- **Vendored hibrid:** 116 skill 5 nyílt-licencű forrásból bemásolva
  (Stripe, Google Stitch, Gemini, Google Workspace CLI, frontend-security),
  domain-mappákban (`payments/`, `design/`, `google/`, `web/`).
- **External források:** Claude (anthropics), OpenAI, Notion, Vercel — licenc híján
  nem bemásolva, telepítéskor a felhasználó gépére klónozva (`install-skills.sh`).
- `sources.conf` forrás-manifest; `scripts/sync-upstream.sh` vendored másolás +
  licenc-megőrzés a `licenses/` mappába.
- `install-skills.sh`: vendored symlink + external klón → `~/.claude/skills`.
- Napi `upstream-sync` workflow high-trust auto-merge-dzsel; `validate` workflow
  (SKILL.md frontmatter lint).
- Magyar `README.md`, `INSTALL.md`, `CLAUDE.md`; `NOTICE` attribúció; `LICENSE` (MIT).
