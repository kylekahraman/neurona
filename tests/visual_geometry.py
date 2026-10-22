"""Check actual rendered pyramidal paths at the apical bifurcation."""
from pathlib import Path
import re
import subprocess
import tempfile
import xml.etree.ElementTree as ET

ROOT = Path(__file__).resolve().parents[1]
TOKEN = re.compile(r'[A-Za-z]|[-+]?(?:\d*\.\d+|\d+)(?:[eE][-+]?\d+)?')


def segments(path, inherited=(0, 0)):
    """Read the line and cubic commands emitted for these CeTZ paths."""
    translate = re.search(r'translate\(([^)]+)\)', path.get('transform', ''))
    shift = [float(x) for x in translate.group(1).split()] if translate else [0, 0]
    if len(shift) == 1:
        shift.append(0)
    shift = [a + b for a, b in zip(shift, inherited)]
    tokens = iter(TOKEN.findall(path.get('d', '')))
    point = (0, 0)
    result = []
    for op in tokens:
        if op in ('M', 'm', 'L', 'l'):
            values = (float(next(tokens)), float(next(tokens)))
            end = values if op in ('M', 'L') else tuple(a + b for a, b in zip(point, values))
        elif op == 'v':
            end = (point[0], point[1] + float(next(tokens)))
        elif op in ('c', 'C'):
            values = [float(next(tokens)) for _ in range(6)]
            end = (values[4], values[5]) if op == 'C' else (point[0] + values[4], point[1] + values[5])
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
    paths = []
    def collect(element, inherited=(0, 0)):
        if element.tag.endswith('path'):
            if element.get('fill') == 'none' and element.get('stroke-width') == '1':
                paths.append(segments(element, inherited))
            return
        shift = list(inherited)
        for match in re.finditer(r'translate\(([^)]+)\)', element.get('transform', '')):
            delta = [float(x) for x in match.group(1).split()]
            shift[0] += delta[0]
            shift[1] += delta[1] if len(delta) > 1 else 0
        for child in element:
            collect(child, shift)
    collect(ET.parse(output).getroot())
    trunk = paths[0][0]
    assert abs(trunk[1][0] - trunk[2][0]) < 1e-5, 'Expected the central apical trunk'
    x = trunk[1][0]
    roots = [segment[1][1] for path in paths[1:] for segment in path
             if segment[0] in ('c', 'C') and abs(segment[1][0] - x) < 1e-5]
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
