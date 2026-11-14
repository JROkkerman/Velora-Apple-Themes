# Velora Apple Themes

Shared native themes for the **Velora Apple** ecosystem. This is the Apple counterpart of [Velora Web Themes](https://github.com/JROkkerman/Velora-Web-Themes), with the same 47 starting palettes, including Crimson.

Each theme has its own folder, manifest, stable ID and version in this one repository. **Light, Dark and Device are built-in application choices**, not plugins. Device follows the operating system.

The palettes are suitable for Velora Music and future Velora Receipts, Finance and other Apple applications. Velora Music Apple consumes them today through the Swift Package; other apps must implement [Apple theme API 1](THEME_API.md). There is no dependency on a web server or Music-specific artwork in these packages.

## Install the Swift Package

In Xcode choose **File → Add Package Dependencies** and enter:

```
https://github.com/JROkkerman/Velora-Apple-Themes.git
```

Choose the **Commit** dependency rule and enter **113c3ffff052892d9d2bf3cafd63118874c758f5**, then add the **VeloraAppleThemes** library product to your application target. Swift Package Manager bundles all theme JSON files automatically. The package supports iOS 17+, macOS 14+, tvOS 17+, watchOS 10+ and visionOS 1+ and has no external dependencies.

For a SwiftPM application:

```swift
.package(url: "https://github.com/JROkkerman/Velora-Apple-Themes.git", revision: "113c3ffff052892d9d2bf3cafd63118874c758f5")
// Add to the consuming target's dependencies:
.product(name: "VeloraAppleThemes", package: "Velora-Apple-Themes")
```

Load the offline catalogue from the package resource bundle:

```swift
import VeloraAppleThemes

let themes = try VeloraThemeCatalog.bundled()
if let theme = themes.first(where: { $0.id == "linen" }) {
    print(theme.name, theme.backgroundHex, theme.surfaceHex, theme.accentHex)
}
```

Handle loading errors by keeping your application's neutral appearance. Full colour and preview tokens are available on each `VeloraTheme`; the three native hex conveniences omit the `#` prefix. `colorScheme` tells native controls whether a theme uses light or dark chrome.

## Velora Music integration

Velora Music Apple links **VeloraAppleThemes** in its Xcode target and reads the package directly for Settings, page backgrounds, the player and widget theme publishing. There is no copied or generated palette list in the app. **Light, Dark and Device** remain built in. Stable IDs preserve saved profile preferences.

Xcode pins the tested package commit in `Package.resolved`. Building requires the package to be resolved once; installed applications use the bundled resources without a network connection. All 47 themes ship with the app. This is an installed Swift Package dependency, not an in-app GitHub downloader or a runtime Swift plugin.

Music's logo and alternate app icons remain application assets. The app's `scripts/generate-theme-icons.py --themes-root ../Velora-Apple-Themes` reads theme data when developers regenerate icons. A theme without a bundled alternate icon uses the primary app icon.

## Themes

| Theme | Appearance | Version |
| --- | --- | --- |
| [Amethyst](themes/amethyst/) | Dark | 1.0.0 |
| [Apricot](themes/apricot/) | Light | 1.0.0 |
| [Arctic](themes/arctic/) | Light | 1.0.0 |
| [Aubergine](themes/aubergine/) | Dark | 1.0.0 |
| [Aurora](themes/aurora/) | Dark | 1.0.0 |
| [Blue Hour](themes/blue-hour/) | Dark | 1.0.0 |
| [Bordeaux](themes/bordeaux/) | Dark | 1.0.0 |
| [Breeze](themes/breeze/) | Light | 1.0.0 |
| [Buttercup](themes/buttercup/) | Light | 1.0.0 |
| [Cherry Blossom](themes/cherry-blossom/) | Light | 1.0.0 |
| [Christmas](themes/christmas/) | Dark | 1.0.0 |
| [Cobalt](themes/cobalt/) | Dark | 1.0.0 |
| [Copper](themes/copper/) | Dark | 1.0.0 |
| [Crimson](themes/crimson/) | Dark | 1.0.0 |
| [Deep Sea](themes/deep-sea/) | Dark | 1.0.0 |
| [Ember](themes/ember/) | Dark | 1.0.0 |
| [Espresso](themes/espresso/) | Dark | 1.0.0 |
| [Forest](themes/forest/) | Dark | 1.0.0 |
| [Garnet](themes/garnet/) | Dark | 1.0.0 |
| [Graphite](themes/graphite/) | Dark | 1.0.0 |
| [Harbor](themes/harbor/) | Dark | 1.0.0 |
| [Honey](themes/honey/) | Light | 1.0.0 |
| [Ink](themes/ink/) | Dark | 1.0.0 |
| [Lavender](themes/lavender/) | Light | 1.0.0 |
| [Linen](themes/linen/) | Light | 1.0.0 |
| [Marshmallow](themes/marshmallow/) | Light | 1.0.0 |
| [Matcha](themes/matcha/) | Light | 1.0.0 |
| [Midnight](themes/midnight/) | Dark | 1.0.0 |
| [Midnight Gold](themes/midnight-gold/) | Dark | 1.0.0 |
| [Monochrome](themes/monochrome/) | Dark | 1.0.0 |
| [Moonstone](themes/moonstone/) | Light | 1.0.0 |
| [Nordic](themes/nordic/) | Light | 1.0.0 |
| [Obsidian](themes/obsidian/) | Dark | 1.0.0 |
| [Ocean](themes/ocean/) | Dark | 1.0.0 |
| [Olive](themes/olive/) | Light | 1.0.0 |
| [Peach](themes/peach/) | Light | 1.0.0 |
| [Petrol](themes/petrol/) | Dark | 1.0.0 |
| [Plum](themes/plum/) | Dark | 1.0.0 |
| [Porcelain](themes/porcelain/) | Light | 1.0.0 |
| [Rosewood](themes/rosewood/) | Dark | 1.0.0 |
| [Ruby Night](themes/ruby-night/) | Dark | 1.0.0 |
| [Saffron](themes/saffron/) | Dark | 1.0.0 |
| [Sage](themes/sage/) | Light | 1.0.0 |
| [Sandstone](themes/sandstone/) | Light | 1.0.0 |
| [Sea Glass](themes/sea-glass/) | Light | 1.0.0 |
| [Slate](themes/slate/) | Dark | 1.0.0 |
| [Terracotta](themes/terracotta/) | Light | 1.0.0 |

## Create or update a theme

1. Copy a folder in `themes/` and give a new theme a unique ID, folder and name.
2. Edit `velora-plugin.json`. Keep `platform` set to `apple`, use hexadecimal colours and increment the version for updates.
3. Update the theme README; use a title such as **Terracotta for Velora Apple**.
4. Add a new ID to `catalog.json` (which controls display order).
5. Run `python3 scripts/validate-themes.py`, `python3 -m unittest discover -s tests` and `swift test`.

Themes control colours and light/dark native chrome. Layout, fonts, images, permissions and application behaviour stay with the application. IDs match the Web collection so a saved preference such as `linen` can select its native counterpart; the repositories can evolve independently.

## Provenance and licence

Initial palettes were adapted from [Velora Web Themes at 63d2a37](https://github.com/JROkkerman/Velora-Web-Themes/tree/63d2a3704c10a86702a5c28917eae016e35eedfa). [upstream.json](upstream.json) records that source. All existing per-theme licence files are preserved. Public availability does not change those licence terms.
