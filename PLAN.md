# vikingo-studio-skills — terv (v3: vendored multi-source, a wp-agent-skills mintára)

> **Állapot:** terv (review alatt). A repo még nem létezik.
> **Frissítve:** 2026-06-07
> **Modell:** a bevált `wp-agent-skills` minta kiterjesztése TÖBB forrásra. A skillek
> a repóban élnek (vendored, birtoklod), domain-mappákba szervezve, symlinkkel telepítve.
> Egy sync workflow tartja frissen több upstreamből; te kontrollálod.

## 1. Cél és filozófia

Egy **publikus**, kurált, kézzelfogható skill-gyűjtemény, ami több megbízható forrásból
**bemásolt** (vendored) skilleket egységesít egy helyen, és sync-kel naprakészen tart.

Miért vendored (nem élő pointer / nem kétféle csatorna):
- **Egységes**: ha a `SKILL.md`-t bemásoljuk, nem számít, az upstream plugin- vagy nyers formátumú
  volt — egy formátum, egy telepítő, egy frissítés.
- **Birtoklod és kontrollálod**: tesztelhető, PR-ben látható, visszavonható, stabil.
- **Bevált**: pontosan a `wp-agent-skills` modellje, csak több forrással.

## 2. A modell (a wp-agent-skills mintára)

- **Skillek a repóban**, domain-mappákban (pl. `ai/`, `payments/`, `design/`, `google/`, `web/`, `docs/`).
- **Telepítés**: `git clone` + `./install-skills.sh` → symlinkeli mindet a `~/.claude/skills/`-be.
  `git pull` után azonnal frissül (symlink, nem másolat).
- **Sync**: `scripts/sync-upstream.sh` (helyi, egy lépésben) + `.github/workflows/upstream-sync.yml`
  (ütemezett, PR-t nyit). A `wp-agent-skills` mintát általánosítja több forrásra.
- **Magyar README-k** domainenként + gyökér dokumentáció; a skillek angolul (1:1 upstream).

## 3. Eltérés a wp-agent-skills-től: multi-source másolás

A `wp-agent-skills` **egy fork** (közös git history az upstreammal), ezért megy nála a
`git checkout upstream/main -- <domain>`. A `vikingo-studio-skills` **több forrásból** aggregál,
ezért a másolás forrásonként: **klónoz (sparse) + bemásol** a `sources.yml` alapján.

## 4. Repo-struktúra

```
vikingo-studio-skills/
├── README.md                 — HU: mi ez, mit kapsz, hogyan telepítsd
├── INSTALL.md                — HU: telepítés 3 paranccsal (git clone + install-skills.sh)
├── install-skills.sh         — symlinkeli az összes SKILL.md-t ~/.claude/skills-be
├── sources.yml               — forrás-manifest: repo + skill-path + cél domain + trust
├── scripts/
│   └── sync-upstream.sh      — multi-source: minden forrásból bemásolja a skilleket
├── .github/workflows/
│   ├── upstream-sync.yml     — ütemezett sync → PR (high-trust auto-merge)
│   └── validate.yml          — SKILL.md frontmatter lint
├── NOTICE                    — attribúció: forrásonként repo + licenc (publikus repo!)
├── LICENSE
├── ai/                       — Claude (anthropics) + OpenAI
│   ├── README.md (HU)
│   └── <skill>/SKILL.md
├── payments/                 — Stripe
├── design/                   — Figma + Stitch (google-labs)
├── google/                   — Gemini (+ Workspace CLI, ha skill-része van)
├── web/                      — Vercel + frontend-security
└── docs/                     — Notion
```

## 5. sources.yml (a multi-source manifest)

```yaml
sources:
  - id: anthropics
    repo: https://github.com/anthropics/skills.git
    ref: main
    trust: high                 # high → a sync auto-mergeli a frissítést
    skills:
      - from: skills/skill-creator        # repón belüli path
        to:   ai/skill-creator            # cél domain-mappa
      - from: skills/web-artifacts-builder
        to:   ai/web-artifacts-builder

  - id: stripe
    repo: https://github.com/stripe/agent-toolkit.git
    ref: <SHA>                  # medium/low → pinned, PR-ben véleményezed
    trust: medium
    skills:
      - from: <skills-path>
        to:   payments/stripe-best-practices

  - id: vercel
    repo: https://github.com/vercel-labs/skills.git
    ref: main
    trust: high
    skills:
      - from: skills/next-best-practices
        to:   web/next-best-practices

  - id: schalk-webdev
    repo: https://github.com/schalkneethling/webdev-agent-skills.git
    ref: <SHA>
    trust: low
    archived: true              # read-only upstream → ritka/kézi frissítés
    skills:
      - from: frontend-security
        to:   web/frontend-security
```

- `trust: high` + `ref: main` → a sync a frissítést **auto-mergeli** (ha a validate zöld).
- `trust: medium/low` + `ref: <SHA>` → csak kézi SHA-emeléssel jön új, és **PR-be megy** review-ra.
- `archived: true` → ritka/kézi (az upstream nem változik).

## 6. Sync logika (scripts/sync-upstream.sh, multi-source)

```
minden forrásra a sources.yml-ből (kihagyva archived):
  sparse-clone a repo a ref-en, csak a felsorolt 'from' path-ok
  minden skillre:
    rsync/cp  <clone>/<from>  →  <repo>/<to>     (vendoring, felülír)
git diff → ha van változás:
  → high-trust forrás + validate zöld → commit + (auto-)merge
  → kurált / medium-low → PR review-ra
./install-skills.sh   # symlinkek frissítése
```

A workflow (`upstream-sync.yml`) ugyanaz a PR-minta, mint a wp-agent-skills-nél (branch
`automation/upstream-sync`, idempotens PR megnyitás/frissítés), kiegészítve a trust-alapú
auto-merge-dzsel (`gh pr merge --auto`).

## 7. Frissesség vs stabilitás

- A bevált wp-minta 1/15-én fut. Mivel itt „minél frissebb" a cél, javaslat: **napi** cron
  (`0 6 * * *`) a high-trust forrásokra auto-merge-dzsel → gyakorlatilag mindig friss,
  kézi munka nélkül, de **kontrollált** (vendored, validált, visszavonható).
- A medium/low és kurált források PR-ben maradnak — ott te döntesz.

## 8. Telepítés egy gépen / projektben (felhasználó oldal)

```bash
git clone https://github.com/vikingokft/vikingo-studio-skills.git
cd vikingo-studio-skills
./install-skills.sh        # symlink → ~/.claude/skills
# Frissítés később:
git pull && ./install-skills.sh
```

A skillek a Claude Code-ban (CLI + VS Code + JetBrains) automatikusan elérhetők, amikor relevánsak.

## 9. Új forrás hozzáadása (folyamat)

1. **Felfedezés:** VoltAgent katalógus (vagy bárhol) → a *valódi* upstream repo (`gh api repos/<o>/<r>`).
2. **Path-azonosítás:** hol vannak a skillek a repóban (`skills/`, `agent_skills/`, `.curated`…).
3. **Manifest:** új bejegyzés a `sources.yml`-be (repo, ref/SHA, trust, from→to skill-párok).
4. **Bootstrap:** `bash scripts/sync-upstream.sh` (vagy workflow_dispatch) → bemásolja a skilleket.
5. **Domain README:** magyar leírás a cél domain-mappához (ha új domain).
6. **Attribúció:** `NOTICE` bővítése (repo + licenc) — publikus repo, kötelező.
7. **Commit → (auto vagy PR) → kész.**

## 10. A 9 kért forrás besorolása (verifikálva, 2026-06-07)

Most már MIND vendored (egységes) — a formátum csak a forrás-path-ot befolyásolja:

| Forrás | Valódi repó | Skillek helye a repóban | Cél domain |
|---|---|---|---|
| Claude | `anthropics/skills` | `skills/` | `ai/` |
| OpenAI | `openai/skills` | `skills/.curated`, `.experimental` | `ai/` |
| Stripe | `stripe/agent-toolkit` | `.claude-plugin`/`skills` (verifikálandó) | `payments/` |
| Notion | `makenotion/claude-code-notion-plugin` | `skills/` | `docs/` |
| Stitch | `google-labs-code/stitch-skills` | `plugins/{stitch-*}/skills` | `design/` |
| Figma | `figma/community-resources` | `agent_skills/` | `design/` |
| Vercel | `vercel-labs/skills` | `skills/` | `web/` |
| Gemini | `google-gemini/gemini-skills` | `skills/` | `google/` |
| Workspace CLI | `googleworkspace/cli` | `.agent`/`.claude` (verifikálandó, lehet, hogy nem skill) | `google/` |
| (frontend-sec) | `schalkneethling/webdev-agent-skills` | `frontend-security/` (archivált) | `web/` |

A pontos `from` path-okat a bootstrapkor `gh api`-val verifikáljuk forrásonként.

## 11. Döntések állapota

- [x] Modell: vendored multi-source, a wp-agent-skills mintára (NEM élő pointer)
- [x] Telepítés: install-skills.sh symlink + git pull
- [x] Szervezés: domain-mappák, magyar README-k, angol skillek
- [x] Frissítés: high-trust auto-merge, medium/low + kurált → PR
- [x] Láthatóság: publikus → NOTICE attribúció kötelező
- [ ] Sync gyakoriság megerősítése (javaslat: napi a high-trust forrásokra)
- [ ] 9 forrás pontos skill-path verifikálása (`gh api`)
- [ ] Végső jóváhagyás a repo felépítéséhez
```

