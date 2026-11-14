# Copper for Velora Apple

Charcoal with warm copper accents.

**Copper** is an independent theme in [Velora Apple Themes](https://github.com/JROkkerman/Velora-Apple-Themes). Version 1.0.0 uses **Velora Apple theme API 1**. Compatible Velora Apple applications can reuse this palette without depending on another theme or on Velora Music.

## Use

The package is **themes/copper/**. Keep `velora-plugin.json`, this README and `LICENSE` together. The stable theme ID is **copper**; its appearance is **dark**.

Velora Music Apple links the **VeloraAppleThemes** Swift Package, which bundles this palette automatically. Users choose **Copper** in Settings → Themes. Developers add the library product in Xcode and use `VeloraThemeCatalog.bundled()` to read the collection. An in-app GitHub downloader is not implemented; the package is installed as an application dependency.

See [the collection README](../../README.md) for Swift Package installation and [THEME_API.md](../../THEME_API.md) for integration into another Velora Apple app.

## Customize

Edit the colour data in [velora-plugin.json](velora-plugin.json). Keep the ID stable for updates and increase the version. For a new theme, use a new ID, folder and name. Themes contain no executable code, remote images, fonts or app-specific logos.

## License

The original licence is preserved in [LICENSE](LICENSE).
