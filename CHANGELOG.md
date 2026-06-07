# Changelog

A formátum a [Keep a Changelog](https://keepachangelog.com/) elvét követi.

## [Unreleased]

### Added
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
