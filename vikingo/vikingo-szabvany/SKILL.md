---
name: vikingo-szabvany
description: Vikingo Studio plugin and repo standard. MUST be applied whenever creating, naming, reviewing, or releasing anything for Vikingo Studio / vikingokft — WordPress plugins, themes, GitHub repos, apps, or tools. Covers repo naming taxonomy (wp-plugin-, app-, tool-, site- prefixes), plugin naming conventions (vk- prefixes for slugs, hooks, options, meta, CPTs, REST routes), the mandatory plugin header, folder structure, versioning and release flow, admin UI rules (native-first, no brand webfonts in wp-admin), security baseline, and the pre-release checklist. Triggers on Vikingo, vikingokft, vk- prefix, Fegyvertár, vikingo.hu / vikingo.studio / vikingoapp.hu / vikingodev.hu, or any new plugin/repo scaffolding for this organization.
---

# Vikingo Studio – Plugin és repo szabvány

Ez a dokumentum minden Vikingo Studio által fejlesztett WordPress bővítmény és GitHub repo közös alapja. Kliens oldalakra, a Fegyvertárra, a nyilvános appokra és a belső eszközökre egyaránt érvényes. A cél, hogy minden projekt belül ugyanúgy nézzen ki, előre kiszámítható legyen, ne ütközzön más pluginekkel, és a lehető legkisebb erőforrásköltséggel fusson.

## 0. Alapelvek

- A márkanév **Vikingo**, az ügynökség a **Vikingo Studio**.
- Minden általunk fejlesztett plugin szerzője **Vikingo Studio**, függetlenül attól, hogy melyik kliensnek készül.
- Kevesebb kód, kevesebb asset, kevesebb hibalehetőség. A natív WordPress megoldás mindig előrébb való a sajátnál, ha a natív elég jó.

## 1. Domainek és szerepük

| Domain | Szerep |
|---|---|
| `vikingo.hu` | Oktatás, itt él a Fegyvertár |
| `vikingo.studio` | Ügynökség, a pluginek hivatalos szerzői és support háttere |
| `vikingoapp.hu` | Nyilvános, másoknak is elérhető appok és eszközök |
| `vikingodev.hu` | Kizárólag belső használatú eszközök |

A domain besorolási tengelyként is működik. Egy nyilvános app a `vikingoapp.hu` alá települ, egy belső eszköz a `vikingodev.hu` alá. Ez a döntés a repo típusát is meghatározza.

## 2. Repo elnevezési taxonómia

A repo neve mindig két dolgot mond meg: a prefix azt, hogy **mi az artefakt**, a slug pedig azt, hogy **konkrétan melyik**. A cél domain a típusból következik.

| Repo prefix | Mi az | Cél domain |
|---|---|---|
| `wp-plugin-{slug}` | WordPress bővítmény | kliens oldal vagy Fegyvertár |
| `wp-mu-{slug}` | must-use plugin, snippet-fix | eseti |
| `wp-theme-{slug}` | egyedi téma vagy child theme | kliens oldal |
| `tool-{slug}` | belső eszköz, automatizmus | `*.vikingodev.hu` |
| `site-{domain}` | élő weboldal vagy webapp, a slug maga a domain | a névben szereplő domain |
| `skill-{slug}` | Claude Code skill | repo, nem deploy |
| `chrome-ext-{slug}` | Chrome bővítmény | Chrome Web Store |
| `edu-{slug}` | oktatási segédanyag, kurzus tartalom, mintamegoldás | repo vagy GitHub Pages |
| `archive-{slug}` | lezárt, már nem használt repo | nincs, archiválva |

Slug szabály: kisbetű, kebab-case, ékezet nélkül, tömör és beszédes. Pont és egyéb írásjel nem szerepelhet a repo nevében. Példa: "Fegyvertár hozzáférés" lesz `fegyvertar-access`.

Archiválási szabály: ha egy repo lezárult és már nem használjuk, átnevezéskor `archive-` előtagot kap (`archive-{régi-név}`), majd a GitHubon archiválva lesz. Így a listában ránézésre elkülönül az élő állománytól.

Site szabály: minden élő weboldal és webapp repója `site-{domain}` nevű, ahol a domain kötőjelesen írva szerepel: `site-onlinesorsolas-hu` az onlinesorsolas.hu-hoz, `site-elcs-wpkurzus-hu` az elcs.wpkurzus.hu-hoz. Így a repo nevéből azonnal látszik, hol él az oldal. Külön `app-` kategória nincs.

Termék-névtér: ha egy repo egy konkrét termékhez tartozik (például a Fegyvertárhoz), a slug a termék nevével kezdődik a típus-előtag után: `tool-fegyvertar-{funkció}`, `skill-fegyvertar-{funkció}`. Így típuson belül a termék repói egymás mellé rendeződnek. Emellett a repo megkapja a termék GitHub topicját (`fegyvertar`), így az org repólistája egy kattintással szűrhető a teljes termék-családra, típustól függetlenül.

Láthatóság: `tool-` repo mindig privát. `edu-` és `skill-` lehet publikus, kliens- és termék-repo (`wp-plugin-`, `site-`) alapból privát.

Kód-könyvtárak (npm csomagok), sablonok és tudásbázis repók besorolása még nyitott döntés, addig a meglévő, beszédes nevük marad.

## 3. Plugin elnevezési konvenciók

Két szintet használunk. Rövid vizuális prefixet a frontend rétegen, és plugin-nevesített prefixet mindenhol, ahol az adat globális térbe kerül. Ez utóbbi azért kell, mert a csupasz `vk_` az adatbázisban vagy egy hookon ütközhetne két Vikingo plugin között. A plugin nevét ezért mindig bele kell tenni.

| Terület | Konvenció | Példa |
|---|---|---|
| CSS osztály és id | `vk-` | `.vk-panel`, `#vk-settings` |
| GitHub repo | `wp-plugin-{slug}` | `wp-plugin-fegyvertar-access` |
| Plugin slug, mappa, text domain | `vk-{funkció}` | `vk-fegyvertar-access` |
| PHP namespace (PSR-4) | `Vikingo\{PluginNév}` | `Vikingo\FegyvertarAccess` |
| Globális PHP függvény, ha muszáj | `vk_{plugin}_` | `vk_fegyvertar_render()` |
| Konstans | `VK_{PLUGINRÖVID}_` | `VK_FGV_VERSION` |
| Action és filter hook | `vk_{plugin}_` | `vk_fegyvertar_access_granted` |
| Option kulcs | `vk_{plugin}_` | `vk_fegyvertar_settings` |
| Post meta (privát) | `_vk_{plugin}_` | `_vk_fegyvertar_expiry` |
| Transient | `vk_{plugin}_` | `vk_fegyvertar_cache` |
| User meta (privát) | `_vk_{plugin}_` | `_vk_fegyvertar_level` |
| Custom post type | `vk_{rövid}`, max 20 karakter | `vk_lesson` |
| Taxonomy | `vk_{rövid}` | `vk_lesson_cat` |
| AJAX action | `vk_{plugin}_{művelet}` | `wp_ajax_vk_fegyvertar_sync` |
| Nonce action | `vk_{plugin}_{művelet}` | `vk_fegyvertar_save_settings` |
| Cron esemény | `vk_{plugin}_{művelet}` | `vk_fegyvertar_daily_sync` |
| Shortcode | `vk_{plugin}` vagy `vk_{plugin}_{funkció}` | `[vk_fegyvertar_panel]` |
| Adatbázis tábla | `{$wpdb->prefix}vk_{plugin}_{entitás}` | `wp_vk_fegyvertar_logs` |
| Capability, ha saját kell | `vk_{plugin}_{jog}` | `vk_fegyvertar_manage` |
| Cookie | `vk_{plugin}_` | `vk_fegyvertar_token` |
| REST namespace | `vikingo/v1`, a route a pluginnal kezdődik | `vikingo/v1/fegyvertar/access` |
| Gutenberg blokk | `vikingo/{blokk}` | `vikingo/lesson-list` |
| Enqueue handle | `vk-{plugin}-{context}` | `vk-fegyvertar-admin` |
| Localize JS objektum | `vk{Plugin}` camelCase | `vkFegyvertar` |
| Composer csomagnév | `vikingo/{plugin-slug}` | `vikingo/vk-fegyvertar-access` |

- A custom post type kulcs maximum 20 karakter lehet, ezt a WordPress core kényszeríti, ezért ott rövid nevet használunk plugin-nevesítés nélkül. A rövid CPT és taxonomy neveket érdemes egy közös listában nyilvántartani, hogy két plugin ne foglalja le ugyanazt.
- A REST namespace közös `vikingo/v1`, de a route első szegmense mindig a plugin neve, így két plugin sosem ütközik ugyanazon az útvonalon.

## 4. Plugin header

Minden plugin fő fájlának ez a fejléce, kitöltve. Em-dash sehol, a leírásban sem.

```php
<?php
/**
 * Plugin Name:       Vikingo Fegyvertár Access
 * Plugin URI:        https://vikingo.studio
 * Description:       Fegyvertár hozzáférés-kezelés Circle és Stripe alapon.
 * Version:           1.0.0
 * Requires at least: 6.4
 * Requires PHP:      8.0
 * Author:            Vikingo Studio
 * Author URI:        https://vikingo.studio
 * License:           GPL-2.0-or-later
 * License URI:       https://www.gnu.org/licenses/gpl-2.0.html
 * Text Domain:       vk-fegyvertar-access
 * Domain Path:       /languages
 * Update URI:        https://vikingo.studio
 */

if ( ! defined( 'ABSPATH' ) ) {
	exit;
}
```

- Az **Author** mindig `Vikingo Studio`, az **Author URI** és a **Plugin URI** mindig `https://vikingo.studio`, aloldal nélkül.
- A **License** GPL-2.0-or-later, ez nem opció, privát pluginnél is így csináljuk.
- A **Text Domain** kötelezően azonos a plugin sluggal és a mappanévvel.
- Az **Update URI** azért kell, hogy a wp.org frissítő soha ne toljon rá egy azonos slugú publikus plugint.
- A **Requires PHP** minimum 8.0, a támogatott WP verzió az aktuális és az azt megelőző fő verzió.

## 5. Mappa- és fájlstruktúra

Egységes váz, csak azzal, amire tényleg szükség van.

```
wp-plugin-fegyvertar-access/
├── vk-fegyvertar-access.php      # fő fájl, csak bootstrap
├── uninstall.php                 # takarítás eltávolításkor
├── composer.json                 # PSR-4 autoload, dev függőségek
├── readme.md
├── CHANGELOG.md
├── .editorconfig
├── .gitignore
├── languages/
│   └── vk-fegyvertar-access.pot
├── src/                          # PHP osztályok, Vikingo\FegyvertarAccess namespace
│   ├── Plugin.php
│   ├── Admin/
│   ├── Frontend/
│   └── Rest/
└── assets/
    ├── css/                      # csak ha muszáj, minimalizálva
    ├── js/
    └── img/
```

A fő fájl csak betölt és indít. A logika a `src/` alatt van PSR-4 autoloaddal. A `node_modules` és a build köztes fájljai soha nem kerülnek a repóba, csak a release zipbe.

## 6. Tárolás, verziózás, megosztás, frissítés

- Minden plugin külön privát GitHub repo a Vikingo org alatt, `wp-plugin-{slug}` néven.
- A `main` mindig telepíthető állapotban van, a fejlesztés feature branchen.
- Szemantikus verziózás, `MAJOR.MINOR.PATCH`. Minden kiadás egy git tag `v1.0.0` formában. A header `Version` és a tag mindig egyezik.
- A `CHANGELOG.md` a Keep a Changelog formátumot követi, magyarul.
- Kliens oldalakon a privát pluginek automatikus frissítéséhez a **plugin-update-checker** (YahnisElsts) könyvtárat használjuk, GitHub release-ekre kötve, privát repónál tokennel.
- Release-enként tiszta, build utáni zipet töltünk fel release asset-ként, dev függőség és `node_modules` nélkül. A build GitHub Actionben fut, kézzel nem rakunk össze zipet.
- Ha egy plugin később a Fegyvertár tagoknak megy ki, opcionálisan bekerülhet egy egyszerű licenc- vagy token-ellenőrzés. Ezt csak tényleges fizetős terjesztésnél építjük be.

## 7. Arculat és admin felület

Az arculat itt szándékosan minimális. Egy erősen brandelt admin oldal jól mutat, de minden extra CSS és font fájl letöltési költség plusz hibafelület. A szabály natív-first.

Amit használunk:

- WordPress natív admin komponensek: `.button`, `.button-primary`, `.notice`, `postbox`, Settings API mezők.
- A saját arculat maximum néhány CSS custom property a saját admin oldal gyökerén, semmi globális felülírás.
- A logó inline SVG, nem külön képfájl, nem külön kérés.

Amit nem csinálunk:

- A Clash Display vagy bármilyen brand webfont soha nem töltődik be a wp-adminba. Az adminban a WP alapértelmezett rendszer-fontstackje megy. A brand fontok a frontendre valók, ott is csak indokolt esetben.
- Nincs globális admin CSS. A plugin admin stílusa csak a saját képernyőin töltődik, feltételesen:

```php
add_action( 'admin_enqueue_scripts', function ( $hook ) {
	// Miért: csak a saját beállítási oldalon töltjük be, hogy ne lassítsuk a teljes admint.
	if ( 'settings_page_vk-fegyvertar-access' !== $hook ) {
		return;
	}
	wp_enqueue_style(
		'vk-fegyvertar-admin',
		VK_FGV_URL . 'assets/css/admin.css',
		array(),
		VK_FGV_VERSION
	);
} );
```

Arculati konstansok egy helyen, a konkrét értékeket a hivatalos Vikingo arculatból kell kitölteni:

```css
:root .vk-admin {
	--vk-color-primary: #___;   /* coral */
	--vk-color-accent:  #___;   /* aubergine */
	--vk-radius: 8px;
}
```

Az arculati elemek egységesek minden pluginben, ugyanaz a logó, ugyanaz a két szín, ugyanaz a szerzői link. A plugin listában a support és dokumentáció linket a `plugin_row_meta` szűrővel adjuk hozzá, mindig a `vikingo.studio` alá mutatva.

## 8. Biztonsági alapkövetelmények

- `ABSPATH` guard minden PHP fájl tetején.
- Jogosultság-ellenőrzés minden művelet előtt: `current_user_can()`.
- Nonce minden űrlapnál és AJAX hívásnál.
- Bemenet tisztítása, kimenet escapelése: `sanitize_*`, `esc_html`, `esc_attr`, `esc_url`, összetett HTML-nél `wp_kses`.
- Adatbázis lekérdezés mindig `$wpdb->prepare()`.
- Debug adat csak `WP_DEBUG` mögött.

## 9. Teljesítmény

- Nem futtatunk kódot minden kérésnél, amit nem kell. Adminban csak adminra, frontendben csak frontendre.
- Nagy option értékeknél az `autoload` legyen `no`.
- Asset verziózás a plugin verzió konstanssal a cache-buster miatt, fejlesztés alatt `filemtime`.
- Külső PHP könyvtárat composerrel prefixelve szállítunk (PHP-Scoper vagy Mozart), hogy két plugin ne ütközzön ugyanazon a verzión.

## 10. Fordíthatóság és szövegek

- A forrás-szövegeket magyarul írjuk, de minden felhasználónak látható szöveg fordítható függvényben áll: `__()`, `esc_html__()`. Így a plugin bármikor fordíthatóvá válik a kód átírása nélkül.
- A text domain mindig a plugin slug, a betöltés az `init` hookon.
- POT fájl a `languages/` mappában.
- A szövegek hangneme, helyesírása és terminológiája a **vikingo-stilus** skillben van szabályozva (tegező hangnem, magyar tipográfia, egységes szótár, üzenet-minták). Minden felületi szöveg aszerint készül.

## 11. Kód-konvenciók

- WordPress Coding Standards PHPCS-sel ellenőrizve, dev függőségként.
- `.editorconfig` minden repóban.
- Nincs em-dash sehol, se kódban, se leírásban.
- A kommentek magyarul, a miért és nem a mit elv szerint. A kód megmutatja mit csinál, a komment megmagyarázza miért van rá szükség.
- OOP alapú felépítés namespace-szel, globális függvény csak indokolt esetben.

## 12. Aktiválás, deaktiválás, eltávolítás

- `register_activation_hook`: kezdeti option-ök, adatbázis tábla, jogosultságok.
- `register_deactivation_hook`: ütemezett feladatok törlése, cache ürítés.
- `uninstall.php`: az adatok végleges takarítása. Alapból legyen egy beállítás, ami eldönti, hogy eltávolításkor törlődjenek-e az adatok.

## 13. Kiadás előtti ellenőrzőlista

- [ ] Header teljesen kitöltve, Author és Author URI a Vikingo Studio.
- [ ] Text domain azonos a sluggal és a mappanévvel.
- [ ] Verzió a headerben és a git tagen egyezik.
- [ ] Nincs csupasz `vk_` az adatbázisban, hookon, AJAX actionben, cron eseményen vagy cookie-ban, mindenhol plugin-nevesített.
- [ ] REST route a plugin nevével kezdődik a `vikingo/v1` namespace alatt.
- [ ] Admin CSS és JS csak a saját képernyőkön töltődik.
- [ ] Nincs brand webfont az adminban.
- [ ] Minden bemenet tisztítva, minden kimenet escapelve, nonce és capability minden műveletnél.
- [ ] Nincs em-dash sehol.
- [ ] Release zip tiszta, dev függőség és node_modules nélkül.
- [ ] plugin-update-checker beállítva a repóra.
