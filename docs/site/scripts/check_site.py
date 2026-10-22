"""Check built documentation links, anchors, images, and generated downloads."""
from html.parser import HTMLParser
from pathlib import Path
from urllib.parse import unquote, urlsplit
import json
import zipfile

SITE = Path(__file__).resolve().parents[1]
DIST = SITE / 'dist'
BASE = '/neurona/'


class Page(HTMLParser):
    def __init__(self, path):
        super().__init__()
        self.ids = set()
        self.tables = 0
        self.links = []
        self.feed(path.read_text())

    def handle_starttag(self, tag, attrs):
        attrs = dict(attrs)
        if tag == "table":
            self.tables += 1
        if 'id' in attrs:
            self.ids.add(attrs['id'])
        for key in ('href', 'src'):
            if key in attrs:
                self.links.append(attrs[key])


def main():
    pages = {p: Page(p) for p in DIST.rglob('*.html')}
    errors = []
    for path, page in pages.items():
        for link in page.links:
            url = urlsplit(link)
            if url.scheme or url.netloc:
                continue
            target = unquote(url.path)
            if target.startswith('/'):
                if not target.startswith(BASE):
                    # External links back to the author's site are absolute URLs.
                    errors.append(f'{path.relative_to(DIST)}: link escapes the docs base: {link}')
                    continue
                resolved = DIST / target[len(BASE):]
            else:
                resolved = path.parent / target if target else path
            if resolved.is_dir():
                resolved = resolved / 'index.html'
            if not resolved.exists():
                errors.append(f'{path.relative_to(DIST)}: missing {link}')
            elif url.fragment and resolved.suffix == '.html':
                destination = pages.get(resolved) or Page(resolved)
                if unquote(url.fragment) not in destination.ids:
                    errors.append(f'{path.relative_to(DIST)}: missing anchor {link}')
    for guide in ('cells', 'connections'):
        assert pages[DIST / 'guides' / guide / 'index.html'].tables > 0, f'MDX table not rendered in {guide}'
    manifest = json.loads((SITE / 'src/generated/examples.json').read_text())
    for slug, example in manifest.items():
        assert (DIST / 'files' / f'{slug}.typ').read_text() == example['source'], slug
        assert (DIST / 'files' / f'{slug}.svg').stat().st_size > 0, slug
    with zipfile.ZipFile(DIST / 'files/neurona-starter.zip') as archive:
        assert archive.testzip() is None
        for slug, example in manifest.items():
            assert archive.read(f'neurona-starter/examples/{slug}.typ').decode() == example['source'], slug
    assert (DIST / 'pagefind/pagefind.js').is_file(), 'Search index missing'
    if errors:
        raise SystemExit('\n'.join(errors))
    print(f'Checked {len(pages)} pages, internal links and anchors, search assets, and {len(manifest)} example downloads.')


if __name__ == '__main__':
    main()
