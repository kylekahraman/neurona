"""Compile the displayed sources and prepare a self-contained starter download."""
from pathlib import Path
import json
import shutil
import subprocess
import tempfile
import zipfile

SITE = Path(__file__).resolve().parents[1]
ROOT = SITE.parents[1]
TUTORIAL = ROOT / 'docs/website/tutorial'
EXAMPLES = [
    ('feedback-model', ROOT / 'examples/feedback-model.typ', 'Feedback across time', 'Perspective activity planes in three rows: feedforward flow within a time step and curved feedback into the next.', 'guides/models/'),
    ('rate-model', ROOT / 'examples/rate-model.typ', 'Mathematical rate model', 'An equation block with input, readout, and a curved recurrent-state connection.', 'guides/models/'),
    ('state-model', ROOT / 'examples/state-model.typ', 'Hidden and observed states', 'Three latent states connected across time and to their observations.', 'guides/models/'),
    ('network-architecture', ROOT / 'examples/network-architecture.typ', 'Neural network architecture', 'Perspective plane arrays for an input, hidden layer, representation, and readout.', 'guides/models/'),
    ('01-cell', TUTORIAL / '01-cell.typ', 'Your first cell', 'A labeled pyramidal cell.', 'getting-started/first-figure/'),
    ('02-connections', TUTORIAL / '02-connections.typ', 'Two connected cells', 'Excitatory and inhibitory projections between two cells.', 'guides/connections/'),
    ('03-layers', TUTORIAL / '03-layers.typ', 'Cortical layers', 'A pyramidal cell in a six-layer cortical stack.', 'guides/layers/'),
    ('04-timeline', TUTORIAL / '04-timeline.typ', 'Stimulus panels', 'Fixation, target, delay, and response panels.', 'guides/timelines/'),
    ('05-motif', TUTORIAL / '05-motif.typ', 'Feedforward inhibition', 'An input population, inhibitory cell, and principal cell.', 'guides/recipes/'),
    ('06-custom', TUTORIAL / '06-custom.typ', 'Custom branches', 'A cell authored with explicit neurite paths.', 'guides/cells/'),
    ('interneuron-atlas', ROOT / 'examples/interneuron-atlas.typ', 'Interneuron recipes', 'Four schematic rodent CA1 interneuron domain recipes.', 'guides/recipes/'),
    ('hippocampal-layers', ROOT / 'examples/hippocampal-layers.typ', 'CA1 layers', 'Selected inputs and inhibitory targets in CA1.', 'guides/layers/'),
    ('axis', ROOT / 'examples/axis.typ', 'Time axis', 'Experimental stages placed on a numeric time axis.', 'guides/timelines/'),
    ('lanes', ROOT / 'examples/lanes.typ', 'Parallel tracks', 'Overlapping experimental events in named lanes.', 'guides/timelines/'),
]


def main():
    if not shutil.which('typst'):
        raise SystemExit('Install the Typst CLI before building the documentation examples.')
    output = SITE / 'public/files'
    output.mkdir(parents=True, exist_ok=True)
    manifest = {}
    with tempfile.TemporaryDirectory(prefix='neurona-docs-') as temp:
        stage = Path(temp) / 'neurona-starter'
        (stage / 'examples').mkdir(parents=True)
        shutil.copytree(ROOT / 'src', stage / 'src', ignore=shutil.ignore_patterns('.*'))
        shutil.copytree(ROOT / 'assets/fonts', stage / 'fonts')
        for name in ('lib.typ', 'LICENSE', 'README.md'):
            shutil.copyfile(ROOT / name, stage / name)
        for slug, path, title, alt, guide in EXAMPLES:
            source = path.read_text()
            staged = stage / 'examples' / f'{slug}.typ'
            staged.write_text(source)
            subprocess.run(['typst', 'compile', '--root', str(stage), '--font-path', str(stage / 'fonts'), str(staged), str(output / f'{slug}.svg')], check=True)
            subprocess.run(['typst', 'compile', '--root', str(stage), '--font-path', str(stage / 'fonts'), str(staged), str(output / f'{slug}.pdf')], check=True)
            (output / f'{slug}.typ').write_text(source)
            manifest[slug] = dict(title=title, alt=alt, source=source, guide=guide)
        notes = stage / 'docs'
        notes.mkdir()
        for path in (ROOT / 'docs').glob('*.md'):
            shutil.copyfile(path, notes / path.name)
        with zipfile.ZipFile(output / 'neurona-starter.zip', 'w', zipfile.ZIP_DEFLATED) as archive:
            for path in sorted(stage.rglob('*')):
                if path.is_file():
                    archive.write(path, path.relative_to(stage.parent))
    generated = SITE / 'src/generated'
    generated.mkdir(parents=True, exist_ok=True)
    (generated / 'examples.json').write_text(json.dumps(manifest, indent=2) + '\n')
    print(f'Compiled {len(manifest)} examples and prepared the starter ZIP.')


if __name__ == '__main__':
    main()
