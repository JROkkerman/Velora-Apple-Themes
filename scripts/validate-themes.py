#!/usr/bin/env python3
"""Validate data-only Velora Apple theme packages. No third-party dependencies."""
import argparse
import json
from pathlib import Path
import re
from urllib.parse import urlsplit

FIELDS = set('manifest_version plugin_api platform type id name author description version repository color_scheme colors preview'.split())
REQUIRED_COLORS = set('paper surface ink muted accent line soft'.split())
OPTIONAL_COLORS = set('green primary-text primary-hover primary-background player-surface nav-text nav-icon nav-hover selected-text cover-surface avatar-surface avatar-text badge-surface badge-text badge-overlay fact-text star unavailable summary search-surface search-icon player-art-surface player-glow toast-surface toast-text error feedback-error eyebrow'.split())
PREVIEW = set('paper surface line ink accent art-from art-to'.split())
RESERVED = {'light', 'dark', 'system', 'none'}


def require(condition, message):
    if not condition:
        raise ValueError(message)


def unique_keys(pairs):
    result = {}
    for key, value in pairs:
        require(key not in result, 'Duplicate JSON key: ' + key)
        result[key] = value
    return result


def validate(data, folder):
    require(isinstance(data, dict) and set(data) == FIELDS, 'Unexpected or missing manifest fields')
    for key in ('manifest_version', 'plugin_api'):
        require(type(data[key]) is int and data[key] == 1, 'Unsupported ' + key)
    require(data['platform'] == 'apple' and data['type'] == 'theme', 'Expected an Apple theme')
    theme_id = data['id']
    require(isinstance(theme_id, str) and re.fullmatch(r'[a-z][a-z0-9-]{0,63}', theme_id), 'Invalid ID')
    require(theme_id not in RESERVED and theme_id == folder, 'Reserved ID or folder/ID mismatch')
    for key, maximum in [('name', 80), ('author', 120), ('description', 300)]:
        value = data[key]
        require(isinstance(value, str) and 0 < len(value) <= maximum and not any(ord(c) < 32 or 127 <= ord(c) < 160 for c in value), 'Invalid text: ' + key)
    require(isinstance(data['version'], str) and re.fullmatch(r'(0|[1-9][0-9]*)\.(0|[1-9][0-9]*)\.(0|[1-9][0-9]*)', data['version']), 'Invalid version')
    require(isinstance(data['repository'], str), 'Invalid repository URL')
    url = urlsplit(data['repository'])
    require(url.scheme == 'https' and url.netloc == 'github.com' and not url.query and not url.fragment and re.fullmatch(r'/[A-Za-z0-9-]+/[A-Za-z0-9_.-]+', url.path), 'Expected an HTTPS GitHub repository root')
    require(data['color_scheme'] in ('light', 'dark'), 'Invalid colour scheme')
    for key, required, allowed in [('colors', REQUIRED_COLORS, REQUIRED_COLORS | OPTIONAL_COLORS), ('preview', PREVIEW, PREVIEW)]:
        colors = data[key]
        require(isinstance(colors, dict) and required <= set(colors) <= allowed, 'Unexpected or missing ' + key + ' tokens')
        for token, value in colors.items():
            pattern = r'#[0-9a-fA-F]{6}' if token in ('paper', 'surface', 'accent') else r'#[0-9a-fA-F]{6}([0-9a-fA-F]{2})?'
            require(isinstance(value, str) and re.fullmatch(pattern, value), 'Invalid colour: ' + key + '.' + token)
    return data


def read_manifest(path):
    require(not path.is_symlink() and not path.parent.is_symlink(), 'Symlinked theme packages are not supported')
    require(path.stat().st_size <= 32768, 'Manifest exceeds 32 KiB')
    return validate(json.loads(path.read_text(encoding='utf-8'), object_pairs_hook=unique_keys), path.parent.name)


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--themes-root', type=Path, default=Path(__file__).resolve().parents[1] / 'themes')
    args = parser.parse_args()
    folders = sorted(args.themes_root.iterdir())
    require(0 < len(folders) <= 256, 'Expected between 1 and 256 theme folders')
    catalog = json.loads((args.themes_root.parent / 'catalog.json').read_text(), object_pairs_hook=unique_keys)
    require(set(catalog) == {'format', 'themes'} and type(catalog['format']) is int and catalog['format'] == 1, 'Invalid catalog format')
    ids = catalog['themes']
    require(isinstance(ids, list) and all(isinstance(item, str) for item in ids), 'Invalid catalog IDs')
    require(len(ids) == len(set(ids)) and set(ids) == {folder.name for folder in folders}, 'Catalog must list every theme exactly once')
    for folder in folders:
        data = read_manifest(folder / 'velora-plugin.json')
        require((folder / 'README.md').read_text().startswith('# ' + data['name'] + ' for Velora Apple\n'), 'README title must name the Apple theme')
        require((folder / 'LICENSE').is_file(), 'Missing theme licence')
    print(f'{len(folders)} Apple theme packages are valid. Light, Dark and Device remain built in.')


if __name__ == '__main__':
    main()
