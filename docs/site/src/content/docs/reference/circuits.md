---
title: Circuits API
description: Compose scenes, projections, population boxes, labels, and branch points.
---

## circuit

```typst
circuit(neurons: (), regions: (), populations: (), junctions: (), nodes: (), groups: (),
  connections: (), annotations: (), unit: 1cm, width: none,
  font-size: 8pt, line-width: 1pt, legend: false, legend-columns: 1)
```

Each collection is a tuple of constructor records. Canvas coordinates use
`unit`; x increases right and y increases up. `width` optionally fits all
artwork, including text, to an exact physical width. `legend` displays the
region bands using their labels and fills.

IDs must be unique across neurons, populations, abstract nodes, and junctions. Region IDs
are unique across regions, and band IDs are unique within each region.

## projection

```typst
projection(source, target, effect: "excitatory", color: rgb("426f91"),
  via: (), controls: (), dashed: false, label: none,
  label-at: 0.5, label-offset: (0, 0.15), weight: 1, target-gap: 0)
```

| Parameter | Meaning |
| --- | --- |
| `source`, `target` | Coordinate tuple, `site`, or `"id.port"` |
| `effect` | `excitatory` arrow, `inhibitory` bar, `directed` neutral arrow, or `unspecified` unmarked line |
| `via` | Polyline waypoints |
| `controls` | One or two Bezier handles; mutually exclusive with `via` |
| `dashed` | Dashed stroke when true |
| `label` | Typst label content |
| `label-at` | Label position from 0 to 1 along the path |
| `label-offset` | Label displacement in canvas axes |
| `weight` | Positive relative stroke thickness |
| `target-gap` | Nonnegative terminal clearance in canvas units |

Waypoints and controls accept the same position forms as endpoints. Target
gaps apply to marked excitatory, inhibitory, and directed connections. Unmarked paths
retain their complete length. Routes do not automatically avoid other objects.

## population

```typst
population(id, label, at: (0, 0), width: 1.6, height: 0.7,
  fill: rgb("edf2f6"), color: rgb("344c66"))
```

A labeled box in the same canvas as cells. Ports: `north`, `south`, `east`,
`west`, `center`, `north-east`, `north-west`, `south-east`, `south-west`.
Dimensions must be positive. `at` is the center position.

## junction

```typst
junction(id, at: (0, 0), radius: 0.055, color: rgb("426f91"))
```

An explicit branch point with a `center` port. Use it to author a common
axon stem followed by separate terminal paths.

## annotation

```typst
annotation(at, body, anchor: "center", color: rgb("536371"), size: none)
```

Place Typst content at a coordinate or resolved scene position. `size: none`
uses the circuit font size. `anchor` controls text alignment at that position.

## motif and motif-scene

```typst
motif(kind, width: 60mm, font-size: 9pt, line-width: 1pt,
  excitation: rgb("367c9e"), inhibition: rgb("aa5c35"))

motif-scene(kind, excitation: rgb("367c9e"), inhibition: rgb("aa5c35"))
```

`kind` is `feedforward`, `feedback`, or `disinhibition`. `motif` renders the
scene. `motif-scene` returns editable `neurons`, `populations`, `connections`,
and `annotations` arguments for composition with `circuit`.

See [Connections](/neurona/guides/connections/) for practical routing examples.

For abstract blocks, state nodes, background groups, and neutral signal-flow
arrows, see the [Models API](/neurona/reference/models/).
