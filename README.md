# Velora Apple Themes

Shared native themes for the **Velora Apple** ecosystem. This is the Apple counterpart of [Velora Web Themes](https://github.com/JROkkerman/Velora-Web-Themes), with the same 47 starting palettes, including Crimson.

Each theme has its own folder, manifest, stable ID and version in this one repository. **Light, Dark and Device are built-in application choices**, not plugins. Device follows the operating system.

The palettes are suitable for Velora Music and future Velora Receipts, Finance and other Apple applications. Velora Music Apple consumes them today through its build-time sync workflow; other apps must implement [Apple theme API 1](THEME_API.md). There is no dependency on a web server or Music-specific artwork in these packages.

## Use in Velora Music Apple

Clone this repository alongside the Apple app checkout:

```sh
git clone https://github.com/JROkkerman/Velora-Apple-Themes.git
cd Velora_Music_Apple
python3 scripts/sync-apple-themes.py --themes-root ../Velora-Apple-Themes
python3 scripts/generate-theme-icons.py
python3 scripts/generate_project.py
```

Then build the app in Xcode. **All themes ship with the app** and work offline. The app keeps its own logo and generates its own themed icons. The sync command records each source manifest's hash, version, repository path and commit. Run the same command with `--check` to check the native palette catalog without changing files.

This is a collection of colour-data packages, not a Swift Package or executable plugin. Runtime GitHub downloading/importing on iOS is not implemented yet. Future installers can select one `themes/<id>/` folder without installing the full collection. Each theme remains independently versioned.

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
4. Run `python3 scripts/validate-themes.py` and `python3 -m unittest discover -s tests`.

Themes control colours and light/dark native chrome. Layout, fonts, images, permissions and application behaviour stay with the application. IDs match the Web collection so a saved preference such as `linen` can select its native counterpart; the repositories can evolve independently.

## Provenance and licence

Initial palettes were adapted from [Velora Web Themes at 63d2a37](https://github.com/JROkkerman/Velora-Web-Themes/tree/63d2a3704c10a86702a5c28917eae016e35eedfa). [upstream.json](upstream.json) records that source. All existing per-theme licence files are preserved. Public availability does not change those licence terms.
