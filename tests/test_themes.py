import copy
import importlib.util
import json
from pathlib import Path
import tempfile
import unittest

ROOT = Path(__file__).resolve().parents[1]
spec = importlib.util.spec_from_file_location('validator', ROOT / 'scripts/validate-themes.py')
validator = importlib.util.module_from_spec(spec)
spec.loader.exec_module(validator)


class ThemeContractTests(unittest.TestCase):
    def setUp(self):
        self.theme = json.loads((ROOT / 'themes/linen/velora-plugin.json').read_text())

    def test_collection_retains_crimson_and_unique_non_standard_ids(self):
        themes = [validator.read_manifest(p) for p in (ROOT / 'themes').glob('*/velora-plugin.json')]
        ids = [item['id'] for item in themes]
        self.assertIn('crimson', ids)
        self.assertEqual(len(ids), len(set(ids)))
        self.assertFalse(set(ids) & validator.RESERVED)

    def test_rejects_web_packages_and_unsupported_versions(self):
        for key, value in [('platform', 'web'), ('plugin_api', 2), ('manifest_version', True)]:
            with self.subTest(key=key):
                data = copy.deepcopy(self.theme)
                data[key] = value
                with self.assertRaises(ValueError):
                    validator.validate(data, 'linen')

    def test_rejects_reserved_or_mismatched_ids(self):
        for value in ['system', '../linen', 'a' * 65, 'another-theme']:
            with self.subTest(value=value):
                self.theme['id'] = value
                with self.assertRaises(ValueError):
                    validator.validate(self.theme, 'linen')

    def test_rejects_script_or_unknown_tokens_and_translucent_backgrounds(self):
        for token, value in [('accent', 'url(https://example.com)'), ('paper', '#ffffff00'), ('script', '#ffffff')]:
            with self.subTest(token=token):
                data = copy.deepcopy(self.theme)
                data['colors'][token] = value
                with self.assertRaises(ValueError):
                    validator.validate(data, 'linen')

    def test_allows_optional_alpha_and_non_ascii_plain_text(self):
        self.theme['name'] = 'Café'
        self.theme['colors']['player-surface'] = '#ffffff80'
        self.assertEqual(validator.validate(self.theme, 'linen')['name'], 'Café')

    def test_rejects_duplicate_keys_before_decoding(self):
        with self.assertRaises(ValueError):
            json.loads('{"platform":"apple","platform":"web"}', object_pairs_hook=validator.unique_keys)

    def test_rejects_non_repository_urls(self):
        for url in ['http://github.com/a/b', 'https://github.com/a/b?token=x', 'https://github.com/a/b/tree/main', 'https://user@github.com/a/b']:
            with self.subTest(url=url):
                self.theme['repository'] = url
                with self.assertRaises(ValueError):
                    validator.validate(self.theme, 'linen')

    def test_rejects_oversized_or_symlinked_manifests(self):
        with tempfile.TemporaryDirectory() as temp:
            folder = Path(temp) / 'linen'
            folder.mkdir()
            path = folder / 'velora-plugin.json'
            path.write_text(' ' * 32769)
            with self.assertRaises(ValueError):
                validator.read_manifest(path)
            path.unlink()
            path.symlink_to(ROOT / 'themes/linen/velora-plugin.json')
            with self.assertRaises(ValueError):
                validator.read_manifest(path)


if __name__ == '__main__':
    unittest.main()
