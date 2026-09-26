# Az `/arculat` oldal

A dizájnrendszer látható változata. Egy oldal, ami minden tokent és komponenst megmutat
úgy, ahogy a valóságban renderel — nem képként, hanem élő HTML/CSS-ként.

## Kötelező szekciók

1. **Fejléc** — projekt neve, dátum, link a `DESIGN-TOKENS.md`-re, egy sor arról, hogy ez
   belső oldal és nem kerül élesbe.
2. **Színek** — minden globális szín swatchként: névvel, HEX-szel, és a szövegkontraszt
   bemutatásával (világos + sötét szöveg a swatchon). Interakciós variánsok külön sorban.
3. **Tipográfia** — minden type scale szint egymás alatt, valódi szöveggel, mellette
   `H2 · 40px / 1.2 / 600`. Alatta a fontcsaládok és a használt weightek felsorolva.
4. **Spacing** — a skála vizuálisan: minden érték egy sáv, aminek a szélessége az érték.
   Utána a szemantikus tokenek (`section-padding-y`, `grid-gap`…) desktop/mobile értékkel.
5. **Gombok** — minden variáns × minden állapot (default, hover, focus, disabled) és
   minden méret. A hover állapotot statikusan is mutasd meg, ne csak élőben.
6. **Kártyák / surface elemek** — minden kártyatípus, ami az oldalon előfordul, valódi
   tartalommal. Itt szokott kiderülni, hogy három különböző padding van.
7. **Ikonok** — a használt ikonok listája class névvel, a három ikonméret, és az
   ikonbox-stílus(ok) pontos specifikációval.
8. **Form elemek** — input, textarea, select, checkbox, radio; normál / focus / hiba
   állapotban, labellel és segédszöveggel.
9. **Egyéb visszatérő elemek** — badge, tag, breadcrumb, pagination, blockquote,
   táblázat, lista, elválasztó, árnyék-skála, border-radius skála — amelyik létezik.
10. **Responsive minta** — legalább egy kártyagrid és egy szekció-fejléc, feliratozva,
    hogy 767 / 1024 alatt mi történik.

Ami az oldalon nincs, azt ne rakd az arculatra. Ami az oldalon van, annak itt lennie kell.

## Szabályok

- **Tokenből renderelj.** `background: var(--color-primary)` — soha nem beírt HEX.
- **A feliratokat is tokenből olvasd**, ha megoldható (lásd a snippetet lentebb).
  Így az arculat oldal nem tud elavulni.
- `noindex, nofollow` a `<head>`-ben.
- Az arculat oldal saját layoutja legyen visszafogott, hogy ne keveredjen a bemutatott
  komponensekkel — semleges háttér, egyszerű címek, sok whitespace.
- Élesítés előtt: a footer link kikerül, az oldal marad (belső dokumentáció).

## Önfrissítő címkék

Ezzel a pár sorral a swatchek és a méretek feliratai maguktól a valódi tokenértéket írják:

```html
<span class="token-label" data-token="--color-primary"></span>
```

```js
document.querySelectorAll('.token-label').forEach(el => {
  const name = el.dataset.token;
  const value = getComputedStyle(document.documentElement)
    .getPropertyValue(name).trim();
  el.textContent = `${name}: ${value}`;
});
```

## Kiindulási váz

```html
<!doctype html>
<html lang="hu">
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <meta name="robots" content="noindex, nofollow">
  <title>Arculat — [Projekt]</title>
  <link rel="stylesheet" href="/css/style.css"><!-- a valódi oldal CSS-e, a tokenekkel -->
  <style>
    /* csak az arculat oldal saját, semleges layoutja */
    .ar-wrap { max-width: 1140px; margin: 0 auto; padding: 48px 24px; }
    .ar-section { padding-block: 48px; border-top: 1px solid var(--color-border); }
    .ar-grid { display: grid; gap: 16px; grid-template-columns: repeat(auto-fill, minmax(160px, 1fr)); }
    .ar-swatch { height: 96px; border-radius: 8px; border: 1px solid var(--color-border); }
    .ar-meta { font-size: 14px; color: var(--color-text-secondary); }
  </style>
</head>
<body>
<div class="ar-wrap">

  <header>
    <h1>Arculat — [Projekt]</h1>
    <p class="ar-meta">
      Belső dizájnrendszer-oldal · [dátum] · számadatok:
      <a href="/DESIGN-TOKENS.md">DESIGN-TOKENS.md</a> · nem kerül élesbe indexelve
    </p>
  </header>

  <section class="ar-section" id="szinek">
    <h2>Színek</h2>
    <div class="ar-grid"><!-- swatch + név + hex + kontraszt minden globális színre --></div>
  </section>

  <section class="ar-section" id="tipografia">
    <h2>Tipográfia</h2>
    <!-- minden szint valódi szöveggel + "H2 · 40px / 1.2 / 600" felirattal -->
  </section>

  <section class="ar-section" id="spacing">
    <h2>Spacing</h2>
    <!-- sávok a skála értékeivel, majd a szemantikus tokenek táblázata -->
  </section>

  <section class="ar-section" id="gombok">
    <h2>Gombok</h2>
    <!-- variáns × állapot × méret -->
  </section>

  <section class="ar-section" id="kartyak">
    <h2>Kártyák</h2>
  </section>

  <section class="ar-section" id="ikonok">
    <h2>Ikonok és ikonboxok</h2>
  </section>

  <section class="ar-section" id="formok">
    <h2>Form elemek</h2>
  </section>

  <section class="ar-section" id="egyeb">
    <h2>Egyéb elemek</h2>
    <!-- badge, táblázat, lista, radius skála, árnyék skála -->
  </section>

</div>
</body>
</html>
```

## WordPress / Elementor oldalon

Az átépítés után **ott is** legyen egy `Arculat` oldal:
- Elementorban összerakva, a globális színekből és globális típusstílusokból építve
- `noindex` (Rank Math / Yoast oldalszinten), jelszóval védve vagy nem publikált státuszban
- ez lesz a regressziós teszt: ha valaki átír egy globális színt, itt azonnal látszik
