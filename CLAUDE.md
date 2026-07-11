# vikingo-studio-skills — Claude Code útmutató

## Projekt célja

A Vikingo Studio **kurált agent-skill gyűjteménye** Claude Code-hoz. Több megbízható
upstream forrásból válogat össze skilleket egy helyre, és naprakészen tartja őket.
Emellett egyetlen SAJÁT domain van, a `vikingo/`: itt élnek a Vikingo Studio saját,
kézzel karbantartott skilljei (`vikingo-szabvany` = szerkezet és elnevezések,
`vikingo-stilus` = magyar nyelv és hangnem). A `vikingo/` NEM szerepel a
sources.conf-ban, a napi sync nem nyúl hozzá; kézzel, PR-rel módosítjuk.
Minden saját skill neve kötelezően `vikingo-` kezdetű, így a külső forrásokkal
sosem ütközik, és a lapos symlink-névtérben ránézésre látszik, melyik a miénk.

## A hibrid modell (ezt értsd meg először)

A skillek a forrás licencétől függően kétféleképpen kerülnek a felhasználóhoz:

- **vendored** — a forrás **nyílt licencű** (MIT/Apache). A skilleket BEMÁSOLJUK a repóba
  domain-mappákba, és a licenc-szöveget a `licenses/` mappába. Ezeket újraoszthatjuk.
- **external** — a forrásnak **nincs nyílt repo-szintű licence**. NEM másoljuk be (az
  újraosztás jogsértő lenne). Az `install-skills.sh` telepítéskor a felhasználó gépére
  klónozza őket az eredeti repóból a `.external/` mappába (git-ignorált), és onnan
  symlinkeli. Így a felhasználónál ott vannak, de ez a repó nem osztja újra őket.

**Aranyszabály új forrásnál:** ha nincs nyílt repo-szintű LICENSE → `external`. Soha ne
másolj be licenc nélküli tartalmat a repóba.

## Könyvtárstruktúra

```
vikingo-studio-skills/
├── sources.conf            — FORRÁS-MANIFEST (egyetlen igazság-forrás)
├── install-skills.sh       — vendored symlink + external klón → ~/.claude/skills
├── scripts/
│   └── sync-upstream.sh    — vendored források bemásolása + licenc-megőrzés
├── .github/workflows/
│   ├── upstream-sync.yml    — NAPI sync → PR → high-trust auto-merge
│   └── validate.yml         — SKILL.md frontmatter lint (required check)
├── licenses/               — a vendored források LICENSE-ei (Apache/MIT megőrzés)
├── vikingo/                — SAJÁT skillek (vikingo-szabvany), nem synceljük
│                             kézzel karbantartott, PR-rel módosul
├── wordpress/ woocommerce/ jet-engine/ plugin-scaffold/ wp-rocket/
│                           — vendored: WordPress készlet (Lonsdale201/wp-agent-skills)
├── payments/               — vendored: Stripe
├── design/                 — vendored: Google Stitch
├── google/                 — vendored: Gemini + Workspace CLI
├── web/                    — vendored: frontend-security (+ external: Vercel)
├── README.md / INSTALL.md  — magyar dokumentáció
├── NOTICE                  — forrás-attribúció + licencek
└── LICENSE                 — MIT (csak a repó saját anyagaira)
```

Az `ai/` és `docs/` domainek NEM léteznek mappaként, mert a hozzájuk tartozó források
(Claude, OpenAI, Notion) `external` módúak — telepítéskor jönnek, nem a repóból.

## sources.conf formátum

Pipe-elválasztott sorok: `mode | id | repo | ref | from | to`

- `mode`: `vendored` vagy `external`
- `from`: a repón belüli útvonal, ami ALATT rekurzívan keressük a `SKILL.md`-ket
- `to`: cél domain-mappa (vendored), ill. besorolás (external)
- A `SKILL.md`-t tartalmazó mappa NEVE lesz a skill neve. Ez kezeli a lapos
  (`skills/<skill>/`) és a mély (`plugins/*/skills/<skill>/`) elrendezést is.

## Konvenciók

- Az upstream skillek **angolul** maradnak (1:1 upstream); a `SKILL.md` az agentnek szóló
  utasítás, a Claude akkor is magyarul válaszol, ha magyarul kérsz. Csak a repó-szintű
  dokumentáció (README, INSTALL, CLAUDE.md, CHANGELOG) magyar.
- A saját `vikingo/` skillek törzse magyar (a szabvány maga magyar dokumentum), de a
  frontmatter `description` angol, mert a skill-kiválasztás arra illeszt.
- A felhasználói szövegekben **nincs em-dash (—)**; helyette vessző + kötőszó, kettőspont
  vagy zárójel. Kódkommentben/CLAUDE.md-ben OK.
- Stílus: tegező, közvetlen.
- Ellipsis: `…` (egyetlen karakter), nem `...`.
- **Elsőbbség ütközésnél:** az upstream skillek generikus konvenciói (pl. `includes/`
  mappa, angol forrás-stringek, `yourprefix_`) ütközhetnek a Vikingo szabvánnyal. Az
  upstream skilleket NEM szerkesztjük (a sync visszaírná); helyette a saját `vikingo/`
  skillek deklarálják, hogy ütközésnél ők nyernek, és felsorolják a tipikus eseteket.
  Új ütközés észlelésekor a vikingo-szabvany 0.1. táblázatát kell bővíteni.

## Új forrás hozzáadása

1. **Felfedezés:** VoltAgent katalógus (github.com/VoltAgent/awesome-agent-skills) vagy
   bárhol → a *valódi* upstream repo (`gh api repos/<owner>/<repo>`).
2. **Licenc-ellenőrzés:** `gh api repos/<o>/<r> --jq .license.spdx_id`
   - nyílt (MIT/Apache/…) → `vendored`
   - nincs / `null` → `external`
3. **Path-azonosítás:** hol vannak a `SKILL.md`-k (`gh api .../git/trees/<branch>?recursive=1`).
4. **sources.conf:** új sor a megfelelő módban.
5. **Behúzás:** `vendored` → `bash scripts/sync-upstream.sh`; `external` → `./install-skills.sh`.
6. **NOTICE + README** táblázat bővítése. Új domain esetén domain-mappa magától létrejön.

## Szinkron és frissítés

- **Napi** GitHub Action (`upstream-sync.yml`, cron `0 6 * * *`): bemásolja a vendored
  források friss tartalmát, és ha van eltérés, PR-t nyit. A vendored források high-trust
  (main követés), ezért a PR a `validate` zöldje után **auto-mergelődik** (`gh pr merge --auto`).
- A felhasználó oldalán: `git pull && ./install-skills.sh`.
- Az external források mindig frissek: az `install-skills.sh` `git pull`-lal hozza őket.

## Egyszeri beállítás a publikálás után

- **SYNC_PAT secret:** ha a `vikingokft` org letiltja a `GITHUB_TOKEN` write-jogát (mint a
  wp-agent-skills-nél), hozz létre fine-grained PAT-ot (Contents: RW + Pull requests: RW),
  és tedd be repo secretként `SYNC_PAT` néven.
- **Branch protection / auto-merge:** a repón engedélyezni kell az auto-merge-öt, és a
  `validate` checket required-dá tenni, hogy az auto-merge csak zöld validáció után fusson.

## Egyesített készlet — ez az egyetlen forrás

Ez a repó a Vikingo Studio EGYETLEN skill-gyűjteménye. A WordPress készletet közvetlenül a
`Lonsdale201/wp-agent-skills` upstreamből húzzuk (MIT), a megtartott 5 domainnel
(`wordpress`, `woocommerce`, `jet-engine`, `plugin-scaffold`, `wp-rocket`). A korábbi
`vikingokft/wp-agent-skills` fork 2026-07-10-én TÖRÖLVE lett, a tartalma ide került.

## Tudott korlátok

- A `sync-upstream.sh` a bemásolást frissíti, de NEM törli azokat a skilleket, amiket az
  upstream időközben eltávolított. Az ilyen zombikat kézzel kell kigyomlálni (a napi sync
  PR diffjéből látszik, ha egy upstream nagyot változott).
- A `validate` workflow csak a repóba bemásolt skilleket látja; az external forrásokból
  telepítéskor jövő skillek névütközését nem tudja előre jelezni. Ezt az
  `install-skills.sh` figyelmeztetése fogja meg a felhasználó gépén.

## Kapcsolódó repó

- `Lonsdale201/wp-agent-skills` — a WordPress készlet upstream forrása (a `wp` id a sources.conf-ban).
