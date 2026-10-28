# DESIGN TOKENS — [Projekt neve]

> Ez az átadási lap. Minden érték px-ben. Elementor Site Settings-be közvetlenül másolható.
> Ha valamiben eltértünk az irányelvtől, a **Megjegyzések** szekcióban van indoklás.
>
> A rendszer látható változata: **[/arculat](/arculat.html)** — ott minden token
> élőben renderelve, komponensekkel együtt.

## 1. Globális színek

| Token | HEX | Elementor Global Color | Használat |
|---|---|---|---|
| primary | #______ | Primary | CTA, linkek |
| secondary | #______ | Secondary | támogató elemek |
| accent | #______ | Accent | kiemelés |
| background | #______ | egyedi | oldal háttér |
| surface | #______ | egyedi | kártya háttér |
| border | #______ | egyedi | vonalak, keretek |
| text-primary | #______ | Text | törzsszöveg, címek |
| text-secondary | #______ | egyedi | meta, másodlagos |
| success | #______ | egyedi | |
| warning | #______ | egyedi | |
| error | #______ | egyedi | |

Interakciós variánsok (csak ha kell):
- primary-hover: #______
- primary-subtle: #______ (ikonbox / halvány háttér)
- overlay: #______ + opacity ____%

## 2. Betűtípusok

| Szerep | Google Font | Weightek | Fallback stack |
|---|---|---|---|
| Display (címek) | | | |
| Body (szöveg) | | | |
| (opcionális 3.) | | | indoklás: |

Összes használt weight: ____ / ____ / ____

## 3. Type scale

| Token | Desktop | Tablet | Mobile | Weight | Line-height | Letter-spacing |
|---|---|---|---|---|---|---|
| H1 | __px | __px | __px | | | |
| H2 | __px | __px | __px | | | |
| H3 | __px | __px | __px | | | |
| H4 | __px | __px | __px | | | |
| Body L | __px | __px | __px | | | |
| Body | 16px | 16px | 16px | | 1.6 | |
| Small | 14px | 14px | 14px | | 1.5 | |
| Button | __px | | __px | | | |

Variánsok (ha van): ______________

## 4. Spacing

Engedett skála: `4 · 8 · 12 · 16 · 24 · 32 · 48 · 64 · 80 · 96 · 120`

| Token | Desktop | Mobile | Használat |
|---|---|---|---|
| section-padding-y / default | __px | __px | szekció fel-le padding |
| section-padding-y / tight | __px | __px | |
| section-padding-y / hero | __px | __px | |
| container-padding-x | __px | __px | oldalsó margó — MINDEN szekcióban |
| grid-gap | __px | __px | kártyalisták |
| stack-gap | __px | __px | egymás alatti elemek |
| element-gap | __px | __px | ikon + szöveg, címke + input |

## 5. Layout

- Container max-width: ____px
- Szűk (szöveg) container: ____px
- Grid: ____ kolumna desktop / ____ tablet / 1 mobile
- Border-radius skála: ____ / ____ / ____ px
- Árnyékok (max 2): 
  - shadow-sm: `______________`
  - shadow-md: `______________`

## 6. Breakpointok

| | Érték | Elementor |
|---|---|---|
| Mobile | ≤ 767px | default |
| Tablet | ≤ 1024px | default |
| Desktop | ≥ 1366px | default |

## 7. Ikonrendszer

- Készlet: Font Awesome ____ (Solid / Regular / Brands) — vagy egyedi SVG szett
- Méretek: ____ / ____ / ____ px
- Ikonbox: ____×____px, padding ____px, háttér `______`, szegély `______`, radius ____px
- Használt ikonok listája:
  | Hol | Ikon class |
  |---|---|
  | | `fa-solid fa-` |

## 8. Komponens paddingek

| Komponens | Padding | Radius | Háttér | Szegély |
|---|---|---|---|---|
| Button / primary | __px __px | | | |
| Button / secondary | __px __px | | | |
| Kártya | __px | | | |
| Input | __px __px | | | |
| Badge | __px __px | | | |

## 9. Megjegyzések / eltérések

- 
