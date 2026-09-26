---
name: vikingo-elementor-ready-design
description: Design-system guidelines for generating website designs that will afterwards be rebuilt by hand in WordPress + Elementor. Enforces only the system layer, never the creative direction: pixel-based type scale, 8-point spacing scale, a capped global color palette (max 11 tokens, one primary + one accent), Google Fonts only, Font Awesome compatible icons, Elementor default breakpoints (767 / 1024 / 1366), and two mandatory handoff outputs — a DESIGN-TOKENS.md spec sheet that maps straight into Elementor Site Settings, and a live /arculat styleguide page rendered from the real CSS tokens. Use when generating or designing a website, landing page, section or UI that will later be built in Elementor. Triggers on /vikingo-elementor-ready-design, design system for Elementor, design tokens, styleguide page, "Elementor-kompatibilis dizájn", "arculat oldal", "készíts dizájnrendszert az oldalhoz".
metadata:
  version: 1.1.0
  utolso-frissites: 2026-09-04
---

# Elementor-ready dizájn

A dizájn kreatív része szabad. A **rendszer** része kötött.

Ez a skill nem mondja meg, hogy milyen legyen az oldal — hanem hogy a kész dizájn olyan
számokból és nevekből álljon, amiket egy fejlesztő Elementorban egy óra alatt beállít,
nem pedig kitalál. Ha a brief mást kér, mint amit itt olvasol, a brief nyer — de akkor
írd le a `DESIGN-TOKENS.md`-ben, hogy miért.

## A négy nem-tárgyalható pont

1. Minden méret **pixelben** van megadva a specifikációban (CSS-ben lehet `rem`, a rendszer px alapú).
2. Minden szöveg, szín, spacing egy **előre definiált tokenre** hivatkozik — ad-hoc érték nincs.
3. Két átadási kimenet **mindig** elkészül: a `DESIGN-TOKENS.md` (olvasható spec)
   és az `/arculat` oldal (látható spec). Egyik sem opcionális.
4. A breakpointok az **Elementor defaultjai**: mobile 767px, tablet 1024px, desktop 1366px.

## Tipográfia

**Type scale — px, egy skála az egész oldalon.**

Javasolt kiindulás (felülírható, de a projekten belül csak EGY skála létezhet):

| Token | Desktop | Mobile | Használat |
|---|---|---|---|
| `H1` | 56 | 36 | oldalanként egy, hero |
| `H2` | 40 | 28 | szekció címek |
| `H3` | 28 | 22 | kártya / blokk címek |
| `H4` | 22 | 18 | alcímek, kiemelés |
| `Body L` | 18 | 17 | bevezető, lead |
| `Body` | 16 | 16 | törzsszöveg |
| `Small` | 14 | 14 | label, meta, caption |

Szabályok:
- **Ugyanaz a hierarchiaszint ugyanaz a méret.** Ha két H2 vizuálisan egyenrangú,
  nem lehet az egyik 48, a másik 36. Ha eltérő méretet akarsz, az más szint — nevezd el.
- Egy szintből maximum **egy variáns** engedett, és annak legyen neve (`H2 / large` a herohoz).
- Line-height: címeknél 1.1–1.3, szövegnél 1.5–1.7. Ezt is tokenként add meg.

**Font family**
- Csak **Google Fonts**. Adobe Fonts, self-hosted, system stack nem.
- Maximum **2 család** (display + body). Harmadik csak akkor, ha valóban hozzáad az
  egyediséghez (pl. mono egy tech oldalon) — és írd le a tokenfájlban, hogy hol használható.
- Minden fonthoz adj valós fallback stacket.

**Font weight**
- Maximum **3 weight** összesen (pl. 400 / 600 / 800). Több weight = több betöltött fájl
  és több inkonzisztencia. A 300-as light-ot kerüld törzsszövegen.

## Spacing

**8-as rendszer.** Csak ezekből válassz:

```
4 · 8 · 12 · 16 · 24 · 32 · 48 · 64 · 80 · 96 · 120
```

Tilos: 13, 27, 35, 42, 57 — bármi, ami nem a listán van. Ha úgy érzed, kell egy 35px,
akkor 32 vagy 40 kell.

**Gap-first szemlélet**
- Szekciók, gridek, kártyalisták, kártyán belüli elemek közti távolság → **`gap`**
  (flex / grid), nem egyedi margin.
- Ne marginozz elemeket egyesével. Ha egy listában minden 3. elemnek külön margója van,
  a konténer gap-je rossz.
- Auto layout gondolkodás: konténer dönt a távolságról, a gyerek nem tud magáról semmit.
- Egyetlen kivétel: opcikai korrekció (pl. ikon 2px feljebb) — ezt kommenteld.

**Szekció ritmus**
- Definiálj 2-3 szekció-padding tokent (pl. `section / default 96px`, `section / tight 64px`,
  `section / hero 120px`) és csak ezeket használd. Mobilra minden szekció-padding
  egy fokkal lejjebb csúszik a skálán (96 → 64, 64 → 48).

## Padding és container

- **Container max-width**: egy érték az egész oldalra (jellemzően 1140 vagy 1200px).
  Ha kell egy szűkebb (szövegoldal, 720px) vagy egy full-width, azt is tokenként.
- **Container oldalsó padding**: desktop 24 vagy 32px, mobile 16 vagy 20px — de
  minden szekcióban ugyanaz. Ez adja az oldal élét; ha szekciónként más, azonnal látszik.
- Hasonló komponensek padding-ja legyen azonos. Ha három kártyatípus van az oldalon,
  mindhárom 24 vagy mindhárom 32 — ne 24 / 28 / 32.
- Mobilt és desktopot **külön gondold át**, ne skálázd le automatikusan:
  a nagy szekció-paddingok csökkennek, a belső 8/12/16-os spacingek jellemzően maradnak.

## Színek

Maximum **11 globális szín**, ez a struktúra:

| Token | Szerep |
|---|---|
| `primary` | fő márkaszín — CTA, linkek |
| `secondary` | támogató márkaszín |
| `accent` | kiemelés, ritkán, figyelemirányításra |
| `background` | oldal alap háttér |
| `surface` | kártya / kiemelt blokk háttere |
| `border` | vonalak, keretek, elválasztók |
| `text-primary` | törzsszöveg és címek |
| `text-secondary` | másodlagos szöveg, meta |
| `success` / `warning` / `error` | státusz |

Szabályok:
- **Egy primary és egy accent.** Nem kettő "primary-ish" szín.
- Egy színnek ne legyen 6 árnyalata indoklás nélkül. Ha kell hover/active, akkor
  `primary` + `primary-hover` (max `primary-dark`) — és ezek is nevesített tokenek.
- **Random `rgba()` tilos.** Ha átlátszóság kell (overlay, subtle háttér), az is token
  legyen (`overlay-dark`, `primary-subtle`), fix értékkel.
- Minden színnek HEX értéke van a tokenfájlban. Kontraszt: szövegen minimum WCAG AA (4.5:1).

## Ikonok

- **Font Awesome kompatibilis** ikonok (Elementor beépítve tartalmazza), vagy egységes
  SVG szett. A tokenfájlban nevezd meg a pontos ikonneveket (`fa-solid fa-check`).
- **Emoji nem ikon.** Se listákban, se kártyákon, se badge-eken.
- Ikon méret: 2-3 fix méret az egész oldalon (pl. 16 / 20 / 24px).
- **Ikonbox konzisztencia**: ha ikonokat dobozban használsz, a doboz padding, méret,
  háttérszín, szegélyszín és border-radius mindenhol ugyanaz (pl. 48×48px, 14px padding,
  `primary-subtle` háttér, `border` szegély, 12px radius). Egy ikonbox-stílus, maximum kettő.

## Breakpointok

```
Mobile   ≤ 767px
Tablet   ≤ 1024px
Desktop  ≥ 1366px   (a 1025–1365 sáv a desktop szabályokat kapja)
```

Ne vezess be saját breakpointot (pl. 900px, 1200px). Ha egy layout eltörik köztük,
a layout a hibás, nem a breakpoint. Mobile-on egy kolumna a default; a tablet
jellemzően 2 kolumna.

## Kötelező kimenet — két darab

### 1. `DESIGN-TOKENS.md` a projekt gyökerében

Az Elementorba átadható lap: minden szám, hex és fontnév egy helyen.
Sablon: `references/design-tokens-template.md`.
Az Elementor Site Settings megfeleltetés: `references/elementor-atadas.md`.

A CSS-ben a tokenek `:root` custom property-ként éljenek (`--fs-h2: 2.5rem; /* 40px */`),
hogy a kód és a tokenfájl összeolvasható legyen.

### 2. `/arculat` oldal — mindig jöjjön létre

Minden weboldal-projekthez készülj el egy **`/arculat`** oldallal, ami a dizájnrendszert
élőben, kattinthatóan megmutatja: színek, tipográfia, spacing, gombok, kártyák, ikonok,
form elemek — mindegyik a valódi CSS tokenekkel renderelve.

Ez nem dekoráció. Ez az, amit az Elementor-fejlesztő megnyit a második monitoron, amíg
épít. A `DESIGN-TOKENS.md` a szám, az `/arculat` a bizonyíték, hogy a szám működik.

Kötelező minimum:
- fájl / route: statikus projektnél `arculat.html`, keretrendszernél `/arculat` route,
  WordPressnél egy `Arculat` nevű, `noindex` oldal
- `<meta name="robots" content="noindex, nofollow">` — ez nem publikus tartalom
- minden minta a **valódi** tokenekből jön (`var(--color-primary)`), nem beírt HEX-ből;
  ha a tokent átírod, az arculat oldal magától követi
- minden minta mellett ott van a **token neve és a px/hex értéke** — kimásolható
- link rá a főoldal footeréből vagy a `DESIGN-TOKENS.md` fejéből (élesítés előtt kiveendő)

A pontos szekciólista és egy másolható kiindulási váz: `references/arculat-oldal.md`.

## Önellenőrzés befejezés előtt

Futtasd le, és a találatokat javítsd vagy indokold:

```bash
# nem 8-as rendszerű px értékek
grep -rnoE '[0-9]+px' --include=*.css --include=*.html . \
  | grep -vE '\b(0|1|2|4|8|12|16|20|24|32|48|64|80|96|120|767|1024|1140|1200|1366)px'

# random rgba
grep -rn 'rgba(' --include=*.css .

# emoji ikonként a markupban
grep -rnP '[\x{1F300}-\x{1FAFF}\x{2600}-\x{27BF}]' --include=*.html .
```

Kézi ellenőrzés:
- [ ] Minden heading szint egy méret? (vizuálisan egyenrangú címek nem térnek el)
- [ ] Globális színek száma ≤ 11, egy primary + egy accent?
- [ ] Font family ≤ 2 (vagy 3 indoklással), weight ≤ 3?
- [ ] Container padding minden szekcióban azonos?
- [ ] Szekció-távolságok gap-ből / szekció-paddingból jönnek, nem egyedi marginokból?
- [ ] Ikonboxok mérete, paddingja, színe egységes?
- [ ] `DESIGN-TOKENS.md` elkészült és hiánytalan?
- [ ] `/arculat` oldal létrejött, `noindex`, és valódi tokenekből renderel?
- [ ] Az arculat oldalon szerepel minden komponens, ami az oldalon előfordul?

## Amit ez a skill NEM szabályoz

Layout ötletek, kompozíció, képhasználat, animáció, szövegírás, márkakarakter, vizuális
merészség. Ott legyél bátor. A rendszer csak azt garantálja, hogy a bátorság
reprodukálható lesz Elementorban.
