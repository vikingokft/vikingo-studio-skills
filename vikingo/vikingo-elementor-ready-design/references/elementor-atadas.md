# Átadás Elementorba

A tokenfájl beállítási sorrendje. Ha ez megvan, a szekciók építése már csak összeszerelés.

## 1. Site Settings → Global Colors

Elementor 4 nevesített globális színt ad (Primary, Secondary, Text, Accent) — a többit
**Custom Colors**-ként add hozzá, a tokenfájlban szereplő névvel (`surface`, `border`,
`text-secondary`, `success`…). A nevek egyezzenek a tokenfájllal, különben elveszik a nyom.

Töröld a nem használt default színeket, hogy ne kerülhessenek be véletlenül.

## 2. Site Settings → Global Fonts

Vegyél fel globális típusstílusokat a type scale sorai szerint: `H1`, `H2`, `H3`, `H4`,
`Body L`, `Body`, `Small`, `Button`. Mindegyiknél állítsd a családot, weightet,
méretet (px), line-heightot — és a tablet/mobile méretet is a responsive ikonnal.

Ezután minden widget a globális stílust hivatkozza, nem kap egyedi méretet.

## 3. Site Settings → Layout

- Content Width = tokenfájl container max-width
- Widgets Space = a `stack-gap` értéke
- Breakpointok: hagyd az Elementor defaultokon (mobile 767 / tablet 1024 / desktop 1366).

## 4. Container padding

Flexbox / Grid Container esetén:
- külső container: `padding` fel-le = `section-padding-y`, jobb-bal = `container-padding-x`
- belső elemek távolsága: a container **Gap** értéke, nem az elemek margója
- egyedi margin csak indokolt optikai korrekcióra

Érdemes 2-3 szekció-containert **globális widgetként / mentett containerként** eltenni
(hero, default szekció, tight szekció), és azokat másolni.

## 5. CSS változók (opcionális, de javasolt)

Site Settings → Custom CSS:

```css
:root {
  --color-primary: #______;
  --color-surface: #______;
  --space-24: 24px;
  --fs-h2: 40px;
}
```

Így a custom CSS-ekben és a generált kódban ugyanazok a nevek élnek, mint a tokenfájlban.

## 6. Ikonok

Font Awesome az Elementorban beépített — a tokenfájl ikonlistája alapján közvetlenül
kiválasztható. Ikonboxnál a méret / padding / szín / szegély értékeket egyszer állítsd be,
majd mentsd el globális widgetként, és ne állítsd újra elemenként.

## 7. Átvételi ellenőrzés

- [ ] Nincs olyan widget, ami egyedi (nem globális) betűméretet használ
- [ ] Nincs olyan szín, ami nincs a globális palettában
- [ ] Nincs olyan px érték, ami nincs a spacing skálán
- [ ] Mobile és tablet nézet minden szekcióban átnézve
- [ ] Egyedi margin csak ott, ahol a tokenfájl indokolja
