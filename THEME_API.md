# Velora Apple theme API 1

Themes contain colour data for native Velora applications. They do not contain
Swift code, scripts, remote assets, fonts, account data or application logos.
This format is independent of the Web theme API, although the initial IDs and
colour tokens match so preferences can be shared across clients.

## Package layout

```
themes/<id>/
  velora-plugin.json
  README.md
  LICENSE
```

Each theme has its own version. Its package path is `themes/<id>` within
`https://github.com/JROkkerman/Velora-Apple-Themes`. Other repositories can publish
compatible packages using their own repository URL.

## Manifest

| Field | Contract |
| --- | --- |
| `manifest_version`, `plugin_api` | Integer `1` |
| `platform` | `apple` |
| `type` | `theme` |
| `id` | 1–64 lowercase ASCII letters, digits and hyphens, starting with a letter |
| `name`, `author`, `description` | Plain text; at most 80, 120 and 300 characters |
| `version` | Numeric `major.minor.patch`, without leading zeroes |
| `repository` | HTTPS GitHub repository root, without credentials, query or fragment |
| `color_scheme` | `light` or `dark` |
| `colors` | Allowed named hexadecimal colour tokens below |
| `preview` | `paper`, `surface`, `line`, `ink`, `accent`, `art-from`, `art-to` |

`light`, `dark`, `system` and `none` are reserved for built-in choices. Reject
unknown fields/tokens, duplicate JSON keys, unsupported versions and non-colour
values. A manifest is limited to 32 KiB. Treat symlinked theme folders and
manifests as invalid. This collection's validator is `scripts/validate-themes.py`.

Required colour tokens:

```
paper surface ink muted accent line soft
```

Optional tokens:

```
green primary-text primary-hover primary-background player-surface
nav-text nav-icon nav-hover selected-text cover-surface
avatar-surface avatar-text badge-surface badge-text badge-overlay
fact-text star unavailable summary search-surface search-icon
player-art-surface player-glow toast-surface toast-text
error feedback-error eyebrow
```

Colours use sRGB `#RRGGBB` or `#RRGGBBAA`. `paper`, `surface` and `accent` must
be opaque `#RRGGBB`, including in previews. Alpha is the last byte. The collection
defines every token; missing optional tokens use the application's neutral
light/dark defaults.

## Current Velora Music Apple mapping

| Manifest | Native palette |
| --- | --- |
| `id`, `name` | Stable selection ID and display title |
| `colors.paper` | Page background (`Palette.background`) |
| `colors.surface` | Panels and cards (`Palette.surface`) |
| `colors.accent` | Controls, icons and player accent (`Palette.accent`) |
| `color_scheme` | Native light/dark controls and default foreground colours |

The remaining tokens and preview colours are retained for other native apps and
future refinements. They do not currently change Music's native foregrounds or
layout. Matching palettes does not imply pixel-identical native and Web screens.

## Application behaviour

- Keep neutral Light, Dark and Device available without any theme package.
- Store Device as `system` and resolve it from the window's current appearance.
- Keep theme IDs stable in saved profile preferences. For an unavailable theme,
  use a neutral fallback instead of crashing. Music currently falls back to Light.
- Validate packages before use. Keep a previously valid bundled theme if an
  installed replacement is invalid. Future installers should override only the
  same ID, not replace the whole collection.
- Keep fonts, layout, application features and app icons under application control.
- Record repository, source commit, manifest hash, package path and version in
  the consuming application's lock file. Update only through an explicit sync.

Music currently compiles all palettes into the application and bundles generated
icons. `scripts/sync-apple-themes.py` in the app repository performs the mapping.
It does not fetch or execute remote code. Runtime installation, updates and
third-party theme browsing on an iPhone are future features, not part of API 1's
current integration. Receipts, Finance and other apps need their own native
consumer; these packages do not add those integrations automatically.
