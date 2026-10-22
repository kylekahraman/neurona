---
title: Models API
description: Abstract blocks, circular states, groups, and directed signal-flow links.
---

Import `diagram`, `model-layer`, `block`, `node`, `group`, and `link` from `lib.typ`.
They are also available through the `models` module.

## diagram

`diagram(..args)` accepts the same named arguments as
[`circuit`](/neurona/reference/circuits/), including two additional collections:
`nodes: ()` for blocks/states and `groups: ()` for background frames. Both
collections also work directly in `circuit`. Every collection is optional.

This is the shared circuit renderer, with no required biological elements.
`width`, `unit`, `font-size`, and `line-width` behave identically. Block and
node bodies use native Typst text/math; dimensions are explicit and do not
automatically grow to fit the content.

## model-layer

```typst
model-layer(id, body: none, at: (0, 0), width: 0.9, height: 1.8,
  planes: 3, offset: (0.14, 0.1), slant: 0.25, grid: (4, 6),
  fill: rgb("e6f0f2"), color: rgb("397986"), ports: (:))
```

A perspective array of activity planes for architectural figures. Rear planes
are drawn first; the front face contains the optional dot grid. `planes` is
a positive integer. `offset` gives nonnegative horizontal/vertical separation
between planes. `slant` tilts the horizontal edges upward to the right.
`grid` gives positive column/row counts; use `grid: none` for plain planes.
`fill` and `color` supply the face and outline/activity colors.

`at` is the front face's center. Width and height describe that face; the
complete stack also includes its slant and rear-plane offsets. An optional
`body` label sits beneath the front face. Dot density and plane count are
editable schematic choices; annotate actual model dimensions separately.

Directional ports land on the visible stack boundary: `east` on the front
right edge, `west` on the rear left edge, `north` at the rear top, and `south`
at the front bottom. Corner ports also follow the projected plane geometry.
Custom ports remain offsets from the front face's center.

## block

```typst
block(id, body, at: (0, 0), width: 2, height: 0.8, radius: 0.12,
  fill: rgb("edf2f6"), color: rgb("344c66"), ports: (:))
```

A rounded rectangle centered at `at`. `body` accepts Typst content. `color`
sets its outline and text; `radius` sets the corner rounding in canvas units.
Use `radius: 0` for square corners. Width/height must be positive and the
corner radius nonnegative.

## node

```typst
node(id, body, at: (0, 0), radius: 0.3,
  fill: white, color: rgb("344c66"), ports: (:))
```

A circular state or computational unit. `radius` must be positive.

## Ports and IDs

All three node constructors expose `north`, `south`, `east`, `west`, `center`,
`north-east`, `north-west`, `south-east`, and `south-west`.

Circle diagonal ports sit on the circumference at 45 degrees. Block corner
ports use the rectangle's bounding corners; for rounded blocks, use cardinal
or custom boundary ports when precise attachment matters.

Custom `ports` map names to offsets from the component center. They must
have nonempty names, contain no dots, and not replace the standard ports.
For a width-2 block, `ports: (input: (-1, 0.2))` places an input on its left
edge. Address it as `"id.input"`.

IDs must be nonempty, contain no dots, and be unique across nodes, cells,
populations, and junctions. The `__paradigm-` prefix is reserved.

## group

```typst
group(label: none, at: (0, 0), width: 3, height: 3,
  fill: rgb("f5f7fa"), color: rgb("b0bdca"),
  label-color: rgb("536371"), dashed: false)
```

A background frame with an optional label inset from its top edge.
Dimensions must be positive. `color` sets the border; `label-color` sets
text color. Leave sufficient space above the contained components for the
label. `fill: none` makes the interior transparent.

Groups are drawn in tuple order before other elements. List outer groups
before inner groups to nest frames visually. Groups have no IDs, ports,
membership, or coordinate transformations. Moving a group does not move its
contents; edit their positions together when needed.

## link

```typst
link(source, target, directed: true, color: rgb("426f91"),
  via: (), controls: (), dashed: false, label: none,
  label-at: 0.5, label-offset: (0, 0.15), weight: 1, target-gap: 0.04)
```

A directed signal-flow arrow, or an unmarked line with `directed: false`.
No biological sign is implied. The returned record uses `effect: "directed"`
or `"unspecified"` and works in either `diagram` or `circuit`.

Endpoints accept coordinates, layer sites, or `"id.port"`. Use either `via`
waypoints or one/two Bezier `controls`. For a recurrent connection, select
distinct ports and supply controls outside the component.

`weight` scales stroke thickness and must be positive. It does not encode
or compute a numerical model weight. `target-gap` is a nonnegative terminal
clearance in canvas units; it only applies to marked paths. Mathematical
weights can be shown with `label: [$W$]`.

See [Models and architectures](/neurona/guides/models/) for complete examples.
