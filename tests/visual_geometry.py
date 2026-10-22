"""Check actual rendered pyramidal paths at the apical bifurcation."""
from pathlib import Path
import re
import subprocess
import tempfile
import xml.etree.ElementTree as ET

ROOT = Path(__file__).resolve().parents[1]
TOKEN = re.compile(r'[A-Za-z]|[-+]?(?:\d*\.\d+|\d+)(?:[eE][-+]?\d+)?')


def segments(path):
    """Read the line and cubic commands emitted for these CeTZ paths."""
    translate = re.search(r'translate\(([^)]+)\)', path.get('transform', ''))
    shift = [float(x) for x in translate.group(1).split()] if translate else [0, 0]
    if len(shift) == 1:
        shift.append(0)
    tokens = iter(TOKEN.findall(path.get('d', '')))
    point = (0, 0)
    result = []
    for op in tokens:
        if op in ('M', 'm', 'l'):
            values = (float(next(tokens)), float(next(tokens)))
            end = values if op == 'M' else tuple(a + b for a, b in zip(point, values))
        elif op == 'v':
            end = (point[0], point[1] + float(next(tokens)))
        elif op == 'c':
            values = [float(next(tokens)) for _ in range(6)]
            end = (point[0] + values[4], point[1] + values[5])
        else:
            raise AssertionError(f'Unexpected path command: {op}')
        if op not in ('M', 'm'):
            result.append((op, tuple(a + b for a, b in zip(point, shift)), tuple(a + b for a, b in zip(end, shift))))
        point = end
    return result


def check(detail, directory):
    option = '' if detail is None else f', detail: "{detail}"'
    source = '#import "/lib.typ": circuit, neuron\n#set page(width:auto,height:auto)\n#circuit(neurons: (neuron("pc"' + option + '),))'
    output = directory / f'{detail or "default"}.svg'
    subprocess.run(['typst', 'compile', '--root', str(ROOT), '-', str(output)],
                   input=source, text=True, check=True, cwd=ROOT)
    paths = [p for p in ET.parse(output).iter('{http://www.w3.org/2000/svg}path')
             if p.get('fill') == 'none' and p.get('stroke-width') == '1']
    trunk = segments(paths[0])[0]
    assert trunk[0] == 'v', 'Expected the central apical trunk'
    x = trunk[1][0]
    roots = [segment[1][1] for p in paths[1:] for segment in segments(p)
             if segment[0] == 'c' and abs(segment[1][0] - x) < 1e-5]
    assert abs(min(trunk[1][1], trunk[2][1]) - min(roots)) < 1e-5, \
        f'{detail or "default"}: apical trunk protrudes above its tuft bifurcation'
    if detail in (None, 'minimal'):
        assert len(roots) == 4, 'Compact pyramidal glyph should have one oblique pair and a bifurcating tuft'
    else:
        assert len(roots) == 6, 'Detailed glyph should retain its additional oblique pair'
    print(f'PASS rendered {detail or "default"} pyramidal geometry')


if __name__ == '__main__':
    with tempfile.TemporaryDirectory(prefix='neurona-geometry-') as temp:
        for detail in (None, 'minimal', 'branched'):
            check(detail, Path(temp))
