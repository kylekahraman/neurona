"""Stage the Universe submission and test package imports in isolated projects."""
from pathlib import Path
import argparse
import json
import re
import shutil
import subprocess
import tempfile
import tomllib
import zipfile

ROOT = Path(__file__).resolve().parents[1]
METADATA = tomllib.loads((ROOT / 'typst.toml').read_text())['package']
SPEC = f"@preview/{METADATA['name']}:{METADATA['version']}"


def package_source(source):
    return re.sub(r'#import "(?:\.\./|/)?lib\.typ"', f'#import "{SPEC}"', source)


def submission_readme(revision):
    source = (ROOT / 'README.md').read_text()
    # Links are pinned to the source revision; the runtime bundle needs no gallery assets.
    def link(match):
        image, title, target = match.groups()
        if re.match(r'\w+:|#', target):
            return match.group(0)
        path = ROOT / target.split('#')[0]
        if not path.exists():
            raise ValueError(f'Broken README link: {target}')
        url = f'https://raw.githubusercontent.com/kylekahraman/neurona/{revision}/{target}' if image else \
              f'https://github.com/kylekahraman/neurona/blob/{revision}/{target}'
        return f'{image}[{title}]({url})'
    source = re.sub(r'(!?)\[([^\]]*)\]\(([^)]+)\)', link, source)
    source = package_source(source).replace('In a file beside `lib.typ`:', 'In a new Typst document:')
    start = source.index('`neurona` is the new development name')
    end = source.index('\n\n', start)
    source = source[:start] + ('Neurona provides schematic cells, circuits, layers, and experimental sequences. '
        'The original `paradigm()`, `stage()`, and `timeline()` functions remain available. '
        'Examples below use the versioned package import for this submission.') + source[end:]
    source = source.replace('These APIs are a development preview, not a claim that a new release is available on Typst Universe.',
                            'The layer and cell APIs share the same scene renderer.')
    source = source.replace("The relative import above is for a document in this repository's `examples/` directory; adjust it to your local checkout. ", '')
    return source


def stage_submission(output):
    revision = subprocess.check_output(['git', 'rev-parse', 'HEAD'], cwd=ROOT, text=True).strip()
    # Replace only this package/version, never the surrounding submission directory.
    package = output / 'preview' / METADATA['name'] / METADATA['version']
    if package.exists():
        shutil.rmtree(package)
    package.mkdir(parents=True)
    for name in ('lib.typ', 'typst.toml', 'LICENSE'):
        shutil.copyfile(ROOT / name, package / name)
    shutil.copytree(ROOT / 'src', package / 'src', ignore=shutil.ignore_patterns('.*'))
    (package / 'README.md').write_text(submission_readme(revision))
    expected = {'lib.typ', 'typst.toml', 'LICENSE', 'README.md'} | {
        str(p.relative_to(ROOT)) for p in (ROOT / 'src').glob('*.typ')}
    actual = {str(p.relative_to(package)) for p in package.rglob('*') if p.is_file()}
    assert actual == expected, f'Unexpected release files: {actual ^ expected}'
    return package, revision


def compile_client(typst, packages, client, source, output):
    result = subprocess.run([typst, 'compile', '--root', str(client), '--package-path', str(packages),
                             str(source), str(output)], text=True, capture_output=True)
    if result.returncode:
        raise SystemExit(f'{source.name}:\n{result.stderr}')


def check_submission(typst, packages, package):
    checked = []
    with tempfile.TemporaryDirectory(prefix='neurona-client-') as temp:
        client = Path(temp)
        (client / 'examples').mkdir()
        sources = []
        for path in sorted((ROOT / 'examples').glob('*.typ')):
            target = client / 'examples' / path.name
            target.write_text(package_source(path.read_text()))
            sources.append(target)
        for path in sorted((ROOT / 'docs/website/tutorial').glob('*.typ')):
            target = client / path.name
            target.write_text(package_source(path.read_text()))
            sources.append(target)
        # Compile every Typst example presented on Universe, independently.
        readme = (package / 'README.md').read_text()
        for i, code in enumerate(re.findall(r'```typst\n(.*?)```', readme, re.S)):
            target = client / f'readme-{i + 1}.typ'
            target.write_text(code)
            sources.append(target)
        assert not (client / 'lib.typ').exists(), 'Client must not have a checkout entry point'
        assert not (client / 'src').exists(), 'Client must not have package source files'
        for i, source in enumerate(sources):
            compile_client(typst, packages, client, source, client / f'check-{i}.pdf')
            checked.append(str(source.relative_to(client)))
        # Export a diagram through each intended user-facing output format.
        for extension in ('svg', 'png'):
            compile_client(typst, packages, client, client / '02-connections.typ', client / f'export.{extension}')
            checked.append(f'export.{extension}')
    return checked


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--output', type=Path, default=ROOT / 'build/submission')
    parser.add_argument('--check', action='store_true')
    parser.add_argument('--typst', default='typst')
    args = parser.parse_args()
    output = args.output.resolve()
    package, revision = stage_submission(output)
    checks = check_submission(args.typst, output, package) if args.check else []
    trial = output.parent / 'try-neurona.typ'
    trial.write_text(f'#import "{SPEC}": circuit, neuron, projection\n'
                     '#set page(width: auto, height: auto, margin: 5mm)\n'
                     '#circuit(neurons: (neuron("pc", label: [My first cell]),), width: 85mm)\n')
    if args.check:
        compile_client(args.typst, output, output.parent, trial, trial.with_suffix('.pdf'))
    archive = output.parent / f"{METADATA['name']}-{METADATA['version']}-candidate.zip"
    with zipfile.ZipFile(archive, 'w', zipfile.ZIP_DEFLATED) as bundle:
        for path in sorted(package.rglob('*')):
            if path.is_file():
                bundle.write(path, path.relative_to(output))
    report = dict(package=SPEC, source_revision=revision,
                  compiler=subprocess.check_output([args.typst, '--version'], text=True).strip(),
                  runtime_bytes=sum(p.stat().st_size for p in package.rglob('*') if p.is_file()),
                  files=sorted(str(p.relative_to(package)) for p in package.rglob('*') if p.is_file()),
                  checks=checks)
    (output.parent / 'release-check.json').write_text(json.dumps(report, indent=2) + '\n')
    print(json.dumps(report, indent=2))
    print(f'Submission directory: {package}\nCandidate ZIP: {archive}')


if __name__ == '__main__':
    main()
