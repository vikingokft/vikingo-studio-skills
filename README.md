# vikingo-studio-skills

A Vikingo Stúdió kurált **agent-skill** gyűjteménye Claude Code-hoz: több megbízható
forrásból összeválogatott skillek egy helyen, naprakészen.

Egy skill egy specializált tudás-csomag, amit a Claude Code automatikusan előhúz,
amikor releváns (pl. WordPress/WooCommerce fejlesztés, Stripe-integráció, biztonsági
audit, dizájn-generálás). Ez a repó a Vikingo Stúdió **egyetlen** skill-forrása:
a WordPress készlet és az általános dev/SaaS skillek is itt élnek.

---

## Hogyan működik?

A skillek **két módon** kerülnek hozzád, a forrás licencétől függően:

- **Bemásolt (vendored):** a nyílt-licencű források skilljei itt élnek a repóban,
  domain-mappákban (`wordpress/`, `woocommerce/`, `jet-engine/`, `plugin-scaffold/`,
  `wp-rocket/`, `payments/`, `design/`, `google/`, `web/`). Egy napi szinkron tartja
  őket naprakészen az upstreamből.
- **Külső (external):** a licenc nélküli források (Claude, OpenAI, Notion, Vercel)
  **nincsenek bemásolva** — a telepítő a te gépedre klónozza őket közvetlenül az
  eredeti repóból. Így mindig frissek, és ez a repó nem oszt újra licenc nélküli
  tartalmat (jogtiszta marad).

Mindkettőt ugyanaz az egy parancs telepíti, és a Claude Code mindkettőt automatikusan
előhúzza, amikor releváns.

---

## Telepítés

Lásd: [INSTALL.md](INSTALL.md). Röviden:

```bash
git clone https://github.com/vikingokft/vikingo-studio-skills.git
cd vikingo-studio-skills
./install-skills.sh
```

Frissítés később:

```bash
git pull && ./install-skills.sh
```

---

## Források

### Saját skillek — a Vikingo Stúdió sajátjai

| Skill | Terület | Mappa |
|---|---|---|
| `vikingo-szabvany` | Vikingo plugin- és repo-szabvány: elnevezések, header, struktúra, release, checklist | `vikingo/` |

Ezek kézzel karbantartott skillek, nem a napi szinkron hozza őket. Módosításuk PR-rel történik.

### Bemásolt (vendored) — nyílt licenc

| Forrás | Terület | Licenc | Mappa |
|---|---|---|---|
| [wp-agent-skills (Lonsdale201)](https://github.com/Lonsdale201/wp-agent-skills) | WordPress, WooCommerce, JetEngine, WP Rocket, plugin-scaffold | MIT | `wordpress/` `woocommerce/` `jet-engine/` `plugin-scaffold/` `wp-rocket/` |
| [Stripe agent-toolkit](https://github.com/stripe/agent-toolkit) | fizetés | MIT | `payments/` |
| [Google Labs Stitch](https://github.com/google-labs-code/stitch-skills) | dizájn → kód | Apache-2.0 | `design/` |
| [Google Gemini](https://github.com/google-gemini/gemini-skills) | Gemini API | Apache-2.0 | `google/` |
| [Google Workspace CLI](https://github.com/googleworkspace/cli) | Drive, Gmail, Sheets… | Apache-2.0 | `google/` |
| [webdev frontend-security](https://github.com/schalkneethling/webdev-agent-skills) | frontend biztonság | MIT | `web/` |
| [web-scraper (yfe404)](https://github.com/yfe404/web-scraper) | web scraping, Apify Actor | MIT | `web/` |

### Külső (external) — telepítéskor húzva

| Forrás | Terület | Besorolás |
|---|---|---|
| [Anthropic Claude skills](https://github.com/anthropics/skills) | általános (PDF, docx, MCP…) | `ai/` |
| [OpenAI skills](https://github.com/openai/skills) | fejlesztés, Figma, GitHub… | `ai/` |
| [Notion](https://github.com/makenotion/claude-code-notion-plugin) | Notion | `docs/` |
| [Vercel agent-skills](https://github.com/vercel-labs/agent-skills) | Next.js, React, deploy | `web/` |

A teljes, gépi forrás-lista: [sources.conf](sources.conf).
Az attribúció és a licencek: [NOTICE](NOTICE).

---

## Karbantartás

Hogyan adj hozzá új forrást, hogyan működik a szinkron: a forrás-lista a
[sources.conf](sources.conf)-ban él, a napi szinkront a
[.github/workflows/upstream-sync.yml](.github/workflows/upstream-sync.yml) végzi.

Új forrás felvétele:
1. Vegyél fel egy sort a `sources.conf`-ba (`vendored` vagy `external` módban).
2. `vendored` esetén: `bash scripts/sync-upstream.sh` (bemásolja a skilleket).
   `external` esetén: `./install-skills.sh` (a gépedre klónozza).
3. Egészítsd ki a `NOTICE`-t és ezt a táblázatot.
