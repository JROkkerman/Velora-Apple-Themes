# Cherry Blossom for Velora Apple

Pale pink, ivory and dusty rose.

**Cherry Blossom** is an independent theme in [Velora Apple Themes](https://github.com/JROkkerman/Velora-Apple-Themes). Version 1.0.0 uses **Velora Apple theme API 1**. Compatible Velora Apple applications can reuse this palette without depending on another theme or on Velora Music.

## Use

The package is **themes/cherry-blossom/**. Keep `velora-plugin.json`, this README and `LICENSE` together. The stable theme ID is **cherry-blossom**; its appearance is **light**.

Velora Music Apple bundles these palettes at build time. Developers sync this repository with `scripts/sync-apple-themes.py` in the app repository, then rebuild. Users choose **Cherry Blossom** in Settings → Themes. An in-app GitHub downloader is not implemented yet; copying a folder onto an iPhone does not install it.

See [the collection README](../../README.md) for the build workflow and [THEME_API.md](../../THEME_API.md) for integration into another Velora Apple app.

## Customize

Edit the colour data in [velora-plugin.json](velora-plugin.json). Keep the ID stable for updates and increase the version. For a new theme, use a new ID, folder and name. Themes contain no executable code, remote images, fonts or app-specific logos.

## License

The original licence is preserved in [LICENSE](LICENSE).
