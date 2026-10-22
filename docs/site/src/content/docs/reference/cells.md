---
title: Cells API
description: Parameters and ports for neuron, neurite, and interneuron.
---

Import `neuron`, `neurite`, and `interneuron` from the package entry point.
These constructors return records; render them inside `circuit(neurons: ...)`.

## neuron

```typst
neuron(id, at: (0, 0), kind: "pyramidal", label: none,
  label-offset: (0.4, 0.3), color: rgb("344c66"),
  apical: 3.4, basal: 1.1, spread: 0.9, scale: 1,
  orientation: 0deg, detail: "branched", axon-origin: "bottom",
  dendrites: (), axons: (), ports: (:))
```

| Parameter | Meaning |
| --- | --- |
| `id` | Unique nonempty cell ID, without dots or the reserved `__paradigm-` prefix |
| `at` | Coordinate tuple or layer `site` |
| `kind` | `pyramidal`, `granule`, `stellate`, `horizontal`, `basket`, `bipolar`, or `custom` |
| `label`, `label-offset` | Typst label and displacement from the soma |
| `apical`, `basal`, `spread` | Positive geometry dimensions in canvas units |
| `scale`, `orientation` | Positive uniform scale and rotation about the soma |
| `detail` | `branched` or `minimal` |
| `axon-origin` | `bottom`, `top`, `left`, or `right`, in cell-local axes |
| `dendrites`, `axons` | Tuples of explicit `neurite` paths |
| `ports` | Dictionary of additional cell-relative named positions |

`axon-origin` controls built-in glyph stubs. Custom cells and interneuron
recipes retain their explicitly authored axon paths. Cell paths and ports
follow rotation and scale; labels stay upright.

### Built-in ports

| Cells | Ports |
| --- | --- |
| All glyphs | `soma`, `soma-west`, `soma-east` |
| All built-in glyphs | `axon`, `dendrite` |
| Pyramidal and granule | `proximal`, `apical`, `tuft`, `tuft-west` |
| Pyramidal | `basal`, `ais`, `oblique-tip-west`, `oblique-tip-east`, `basal-tip-west`, `basal-tip-east` |
| Basket | `dendrite-top`, `dendrite-left`, `dendrite-right` |
| Bipolar | `dendrite-top`, `dendrite-bottom` |
| Each explicit path | `dendrite-0`, `axon-0`, etc., at its last point |

Refer to a port using `"cell-id.port-name"`. Custom port names cannot contain
dots or overwrite existing ports. A `custom` glyph has no default `axon` or
`dendrite` port; use the indexed path endpoints or supply named ports.

## neurite

```typst
neurite(points, controls: (), boutons: (), color: none, thickness: 1)
```

- `points`: at least two cell-relative `(x, y)` tuples.
- `controls`: one or two Bezier handles; requires exactly two endpoints.
  With no controls, points form a polyline.
- `boutons`: explicit cell-relative marker positions.
- `color`: override the cell color for this path.
- `thickness`: positive multiplier relative to the circuit line width.

## interneuron

```typst
interneuron(id, kind: "basket", at: (0, 0), scale: 1,
  orientation: 0deg, color: rgb("80639e"),
  dendrite-color: rgb("667b87"), label: none,
  label-offset: (0.4, 0.3), arbor: true)
```

`kind` accepts `basket`, `axo-axonic`, `bistratified`, or `olm`. `arbor: false`
omits the extended axonal territory. Recipes return ordinary custom neuron
records, including named `axon` and `dendrite` ports.

See [Cells guide](/neurona/guides/cells/) and
[Recipes guide](/neurona/guides/recipes/) for visual examples.
