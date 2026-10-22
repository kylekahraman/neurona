---
title: Layers API
description: Bands, regional stacks, layer sites, cortical presets, and legends.
---

## band

```typst
band(id, label: none, name: none, height: 1,
  fill: rgb("f3f5f7"), label-offset: (0, 0))
```

A single layer. Height must be positive. `label: none` displays the ID;
`name` optionally supplies a longer name for legends. The label offset moves
the edge label in canvas units.

## region

```typst
region(id, bands, at: (0, 0), width: 10, label: none,
  show-layer-labels: true)
```

A nonempty stack of bands listed **bottom-to-top**. `at` positions its
bottom-left corner, and `width` must be positive. The optional region label
appears above the stack. Layer IDs must be unique within a region.

## site

```typst
site(region, layer, x, depth: 0.5)
```

A position inside a region's layer. `region` and `layer` are IDs; `x` is
measured from the region's left edge and must lie within its width. `depth`
runs from 0 at the band's bottom to 1 at its top. This is a geometric fraction,
not a cortical-depth convention.

Sites are accepted for cell placement and connection positions. They are
resolved when the circuit draws, so changes to the stack update placement.

## cortical-layers

```typst
cortical-layers(numbering: "roman",
  heights: (0.45, 0.45, 0.65, 0.5, 0.8, 0.75),
  fills: (rgb("f0f4f6"), rgb("e8eff2"), rgb("dfe9ee"),
    rgb("e8eeea"), rgb("dce7df"), rgb("edf2ed")))
```

Supply six heights and fills **I-to-VI**. The returned bands are ordered
VI-to-I so layer I appears at the top. IDs stay `l1` through `l6`;
`numbering: "arabic"` changes only their printed labels.

These are schematic heights. Use ordinary bands for hippocampal strata,
merged layers, or regions that do not follow a six-layer organization.

## layer-legend

```typst
layer-legend(regions, columns: 1, font-size: 7.5pt, width: none)
```

Returns a normal Typst legend using band labels, names, and fills. Entries
are grouped by region and listed top-to-bottom. `columns` is a positive
integer. `width` optionally constrains the complete legend width.

To include a legend directly in an illustration, set `legend: true` and
optionally `legend-columns` on `circuit`.

See [Regions and layers](/neurona/guides/layers/) for worked examples.
