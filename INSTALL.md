# Telepítés

Ez az útmutató mindenkinek szól, aki használni szeretné a Vikingo Studio
`vikingo-studio-skills` csomagját Claude Code-ban (CLI vagy VS Code / JetBrains).

A teljes folyamat **kb. 2 perc**, három paranccsal.

---

## Mit kapsz?

Kurált agent-skilleket, amiket a Claude Code automatikusan előhúz, amikor relevánsak:

- **Fizetés** — Stripe best practices, projekt-setup, SDK-frissítés
- **Dizájn** — Google Stitch: dizájn → React/HTML, design system kezelés
- **Google** — Gemini API, és Workspace (Drive, Gmail, Sheets, Calendar, Docs…)
- **Web** — frontend biztonsági audit, Vercel/Next.js/React best practices
- **Általános AI** — Claude skillek (PDF, docx, xlsx, MCP-builder…), OpenAI skillek
- **Notion** — Notion-integráció

A teljes lista: [README.md](README.md).

---

## Előfeltételek

### 1. Claude Code
- **CLI:** https://docs.claude.com/claude-code
- **VS Code / JetBrains:** keresd a „Claude Code" extensiont a marketplace-en

A skillek **mindhárom helyen** automatikusan elérhetők lesznek a telepítés után.

### 2. Git
Mac-en alapból van. Linux: `sudo apt install git`. Windows: [git for Windows](https://git-scm.com/download/win).

### 3. Bash (Windows-os kollégáknak)
Mac és Linux: alapból van. **Windows:** Git Bash-ben vagy WSL-ben futtasd
(a `.sh` scriptek natív CMD/PowerShell-ben nem futnak).

---

## Telepítés — 3 parancs

```bash
git clone https://github.com/vikingokft/vikingo-studio-skills.git
cd vikingo-studio-skills
./install-skills.sh
```

Az `install-skills.sh`:
1. a **bemásolt** skilleket symlinkeli a `~/.claude/skills/`-be;
2. a **külső** forrásokat (Claude, OpenAI, Notion, Vercel) a `.external/` mappába
   klónozza a gépeden, majd onnan symlinkeli őket.

Az első futás letölti a külső forrásokat (internet kell hozzá).

---

## Frissítés

```bash
git pull            # bemásolt skillek frissítése
./install-skills.sh # symlinkek + külső források (git pull) frissítése
```

A bemásolt skilleket egy napi szinkron tartja naprakészen a repóban; a külső
forrásokat az `install-skills.sh` minden futáskor `git pull`-lal frissíti.

---

## Eltávolítás

```bash
# A symlinkek a ~/.claude/skills/-ben erre a repóra / a .external/ klónokra mutatnak.
# Töröld a repót, és távolítsd el az árva symlinkeket:
find ~/.claude/skills -type l ! -exec test -e {} \; -delete
```
