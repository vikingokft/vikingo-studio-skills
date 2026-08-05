---
name: vikingo-elementor-atomic
description: Elementor V4 atomic widget development patterns for Vikingo plugins. MUST be applied when creating or modifying Elementor widgets, dynamic tags, or editor previews in any Vikingo WordPress plugin — the atomic API (Elementor\Modules\AtomicWidgets) is undocumented and internal, so this skill captures the proven guard patterns (class_exists + experiment check + try/catch), the widget anatomy (define_props_schema, define_atomic_controls, get_atomic_settings computing rendered_html server-side), the Twig template contract, the REST-based live editor preview hydration, prop/control type reference, the post-Elementor-update checklist, and known pitfalls. Triggers on Elementor widget, atomic widget, Atomic_Widget_Base, twig template, dynamic tag, editor preview, e_atomic_elements, Elementor V4, or any vk- plugin Elementor integration.
---

# Vikingo – Elementor V4 atomic widget minták

A V4 atomic API (`Elementor\Modules\AtomicWidgets\*`) BELSŐ, nem dokumentált és
experiment mögött él. Ez a skill a három élesben bizonyított Vikingo
implementáció (vk-tematika, vk-ajanlas, vikingo-bunny-video) desztillált
tudása. Az itteni minták kötelezők minden új Vikingo atomic widgetnél.

## 0. Alapelvek

- **Minden Elementor-érintés guard mögött.** Ha az API változik vagy hiányzik,
  a widget csendben nem regisztrálódik; az oldal nem törhet el.
- **Mindig van shortcode-tartalék.** A render logika Elementor-független
  osztályban él (`Frontend/Renderer` minta), a widget és a shortcode ugyanazt
  hívja. Elementor nélkül is mindennek működnie kell.
- **A HTML szerveroldalon készül.** A twig sablon csak beilleszti a kész
  `rendered_html`-t; a szerkesztői vászonra REST-hidratálás hozza az élő képet.

## 1. Referencia-források (helyi gépen)

| Mi | Hol |
|---|---|
| Elementor teljes forrás | `~/Documents/Github/reference-elementor/` |
| Elementor Pro teljes forrás | `~/Documents/Github/reference-elementor-pro/` |
| Atomic alaposztály | `reference-elementor/modules/atomic-widgets/elements/base/atomic-widget-base.php` |
| Has_Template trait (render + twig kontextus) | `.../elements/base/has-template.php` |
| Core minta-widget | `reference-elementor/modules/atomic-widgets/elements/atomic-youtube/` |
| Control típusok | `reference-elementor/modules/atomic-widgets/controls/types/` |
| Prop típusok | `reference-elementor/modules/atomic-widgets/prop-types/` |
| Működő Vikingo minták | `wp-plugin-vikingo-hu-tematika/src/Elementor/`, `wp-plugin-vikingo-ajanlas/src/Elementor/` |

A referencia-repók verzióját Elementor-frissítéskor cserélni kell, és utána a
9. pont ellenőrzőlistáját végigfutni. (Utolsó ismert állapot: 4.2.1.)

## 2. Regisztráció és guardok

A belépési pont egy `Elementor/Module` osztály, amit a Plugin csak akkor hív,
ha egyáltalán van Elementor. A minta:

```php
public static function register(): void {
	// Atomic widgetek: csak ha a V4 atomic alaposztály elérhető.
	if ( class_exists( \Elementor\Modules\AtomicWidgets\Elements\Base\Atomic_Widget_Base::class ) ) {
		add_filter(
			'elementor/widgets/register',
			static function ( $widgets_manager ) {
				$widgets_manager->register( new Widgets\SajatWidget() );
				return $widgets_manager;
			}
		);
	}
}
```

Szigorúbb környezetben (ha klasszikus fallback widget is van, mint a bunny-nál)
a teljes ellenőrzés: minden HASZNÁLT osztályra `class_exists` (alaposztály,
minden control, minden prop type), PLUSZ az experiment:

```php
$experiments = \Elementor\Plugin::$instance->experiments;
$atomic_ok   = $experiments && $experiments->is_feature_active( 'e_atomic_elements' );
```

és a `$widgets_manager->register()` hívás `try/catch (\Throwable)` blokkban,
hogy egy Elementor-frissítés okozta törés soha ne legyen fatal, csak fallback.

## 3. A widget anatómiája

```php
class SajatWidget extends Atomic_Widget_Base {
	use Has_Template;

	// Saját újradeklarálás, különben a közös ős STATIKUS property-jét írnánk,
	// és két Vikingo widget egymás leírását mutatná.
	public static $widget_description = null;

	public function __construct( $data = array(), $args = null ) {
		static::$widget_description = __( 'Leírás…', 'vk-plugin' );
		parent::__construct( $data, $args );
	}

	public static function get_element_type(): string {
		return 'vk-sajat'; // ez kerül az Elementor oldal-JSON-ba: SOHA nem változhat!
	}

	protected static function define_props_schema(): array { /* STATIKUS! */ }
	protected function define_atomic_controls(): array { /* Section-ök */ }

	public function get_atomic_settings(): array {
		$settings = parent::get_atomic_settings();
		// A HTML-t ITT számoljuk szerveroldalon; a mellékhatások (asset enqueue,
		// JSON-LD regisztráció) is itt indulnak, mert a twig-ben már késő.
		$settings['rendered_html'] = $this->render_html( $settings );
		return $settings;
	}

	protected function get_templates(): array {
		return array( 'vikingo/sajat' => VK_X_PATH . 'assets/twig/sajat.html.twig' );
	}
}
```

Kritikus tudnivalók:

- **`get_element_type()` értéke bekerül minden Elementor oldal adatai közé.**
  Átnevezése az összes meglévő oldalon eltünteti a widgetet. Refaktornál,
  plugin-összevonásnál a widget-név VÁLTOZATLAN marad.
- **`define_props_schema()` statikus**, ezért a közös prop-készletet is statikus
  metódusban add tovább (`common_props_schema()` minta az ajanlas
  `AbstractTestimonialWidget`-jében).
- A `classes` prop kötelező eleme a sémának:
  `'classes' => Classes_Prop_Type::make()->default( array() )`.
- A `Has_Template::render()` a kivételeket lenyeli (csak `ELEMENTOR_DEBUG`
  mellett dobja tovább) — némán üres widget = valószínűleg twig- vagy
  kontextushiba, debug módban derül ki.

## 4. Prop típusok és controlok (a használt készlet)

| Prop type (`PropTypes\…`) | Control (`Controls\Types\…`) | Megjegyzés |
|---|---|---|
| `Primitives\String_Prop_Type` | `Text_Control`, `Textarea_Control`, `Select_Control` | `->enum([...])` a select értékkészletéhez |
| `Primitives\Boolean_Prop_Type` | `Switch_Control` | |
| `Primitives\Number_Prop_Type` | `Number_Control` | |
| `Image_Prop_Type` | `Image_Control` | médiatár-választó |
| `Link_Prop_Type` | `Link_Control` | |
| `Classes_Prop_Type` | – | kötelező, az Elementor kezeli |

- `Select_Control::set_options()` formátuma:
  `array( array( 'value' => 'x', 'label' => 'X' ), … )` — NEM kulcs=>érték!
- A controlok `Section::make()->set_label()->set_id()->set_items([...])`
  szekciókba rendezve mennek, `Xxx_Control::bind_to( 'prop_nev' )` kötéssel.
- Dinamikus tartalom-választáshoz (pl. CPT bejegyzések) létezik `Query_Control`
  (`set_query_config()`), de a bevált Vikingo minta az egyszerű
  `Select_Control` + saját options-forrás (lásd tematika `CourseOptions`).

## 5. A twig sablon szerződése

A `Has_Template::render()` kontextusa: `id`, `interaction_id`, `type`,
`settings`, `base_styles`. A Vikingo sablon-minta:

```twig
{% set classes = settings.classes | default([]) | join(' ') %}
<div data-id="{{ id }}" data-e-type="{{ type }}" class="{{ classes }}"
	data-vk-course="{{ settings.course }}">
{% if settings.rendered_html is defined and settings.rendered_html %}
{{ settings.rendered_html | raw }}
{% else %}
<div style="border:1px dashed #FF544D;…">Vikingo X – előnézet betöltése…</div>
{% endif %}
</div>
```

- A sablon CSAK beilleszt (`| raw`), logika nincs benne.
- Minden beállítás, amit az előnézetnek látnia kell, `data-vk-*` attribútumként
  is kikerül — ebből dolgozik a hidratáló JS.
- A helyettesítő doboz azért kell, mert a szerkesztőben a twig KLIENS oldalon
  fut, ahol a `rendered_html` nem létezik.

## 6. Szerkesztői élő előnézet (REST-hidratálás)

A szerkesztő vásznán a twig kliens oldalon fut, a szerveroldali
`rendered_html` ott nem érhető el. A bevált megoldás három elem:

1. **REST végpont** (`vikingo/v1/{plugin}/render`, GET, publikus — ugyanazt a
   HTML-t adja, ami a frontenden is megjelenik): a paraméterekből lerendereli
   a widgetet és `{ html: … }`-t ad vissza.
2. **Preview enqueue**: az `elementor/preview/enqueue_styles` és
   `…/enqueue_scripts` hookon betöltjük a frontend CSS/JS-t és az
   `editor-preview.js`-t, `wp_add_inline_script`-tel átadva a REST URL-t.
3. **editor-preview.js**: `MutationObserver` figyeli a vásznat (250 ms
   debounce), a `[data-e-type="vk-…"]` elemeket a `data-vk-*` attribútumokból
   épített query-vel hidratálja. A lekért query-t `data-vk-hydrated`-ben
   tárolja, így változatlan beállításnál nincs újabb fetch. Hidratálás után
   meghívja a frontend init függvényt (`window.vkXInit`), hogy az interakciók
   a vásznon is éljenek.

Teljes referencia: tematika `assets/js/editor-preview.js` +
`src/Rest/RenderController.php` + `src/Elementor/Module.php`.

## 7. Dynamic tag (stabil API, nem atomic)

A dynamic tag a RÉGI, dokumentált API-ra épül (`Elementor\Core\DynamicTags\Tag`),
guard: `class_exists( \Elementor\Core\DynamicTags\Tag::class )`, regisztráció az
`elementor/dynamic_tags/register` hookon. A tag alap az ingyenes Elementorban
van, a beszúró felület a Pro-ban. Controlok a klasszikus
`Controls_Manager::SELECT` stílusban. Minta: tematika `TematikaAdatTag`.

## 8. CSS az Elementor kit ellen

Az Elementor kit globális button/h2/p stílusai felülírják a widget CSS-ét.
Vikingo szabály: minden szabály a widget gyökérosztályával prefixelve
(`.vk-x .vk-x-gomb` — dupla osztály-specificitás) és explicit resetekkel.
Tokenek: `--vkx-*` lokális változók `var(--vk-*, fallback)` értékkel, hogy az
oldal design systeme felülbírálhasson. JSON-LD SOHA nem a widget kimenetébe
megy, hanem `wp_footer`-be, mert az Elementor content pipeline megrongálhatja.

## 9. Elementor-frissítés utáni ellenőrzőlista

Frissítéskor a referencia-repókat lecserélni, majd ellenőrizni:

- [ ] `Atomic_Widget_Base` és `Has_Template` létezik-e még ugyanazon a néven
      (`elements/base/`), változott-e a konstruktor vagy az absztrakt metódusok.
- [ ] A `Has_Template::render()` twig kontextus-kulcsai változatlanok-e
      (`id`, `interaction_id`, `type`, `settings`, `base_styles`).
- [ ] A használt controlok (`Select_Control::set_options` formátum!) és prop
      típusok megvannak-e.
- [ ] Az `e_atomic_elements` experiment neve/állapota változott-e
      (`modules/atomic-widgets/module.php`, `EXPERIMENT_NAME`).
- [ ] Éles teszt: widget behúzása a szerkesztőben, beállítás-változtatás
      (hidratálás frissül-e), mentés, frontend render, shortcode render.
- [ ] `ELEMENTOR_DEBUG` bekapcsolásával nincs-e lenyelt twig-kivétel.

## 10. Ismert buktatók

- **Widget-név = adat.** `get_element_type()` átnevezése minden meglévő
  oldalról törli a widgetet. Összevonásnál, átnevezésnél tilos hozzányúlni.
- **`$widget_description` statikus és közös** — minden widgetben újra kell
  deklarálni, különben az utoljára konstruált widget leírása jelenik meg
  mindenhol.
- **A `define_props_schema()` statikus**, nem fér hozzá `$this`-hez; a
  dinamikus alapértékek (pl. fordított stringek) mehetnek bele, de
  példány-állapot nem.
- **Mellékhatások helye a `get_atomic_settings()`** (asset enqueue, schema):
  a `render()`-t a `Has_Template` adja, oda nem nyúlunk bele.
- **A szerkesztői vászon nem futtat PHP-t** — bármi, ami a frontenden PHP-ból
  jön, a vásznon csak REST-hidratálással jelenik meg.
- **Üres widget a frontenden, hiba nélkül**: a `Has_Template::render()`
  try/catch-e nyelte le — `ELEMENTOR_DEBUG` mellett újratesztelni.
- **File:// alapú headless Chrome teszt megbízhatatlan** — vizuális
  ellenőrzéshez mindig `php -S` szerver + Playwright (channel: chrome).
