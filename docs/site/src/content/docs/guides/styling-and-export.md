---
title: Styling and export
description: Control figure size, labels, colors, and output formats.
---

## Choose a physical size

`circuit(width: 85mm)` fits the entire drawing, including labels, to 85 mm.
It preserves aspect ratio and scales text and strokes together with geometry.

To change geometric size while keeping physical text size, omit `width` and
set `unit: 8mm, font-size: 9pt`. The default canvas unit is 1 cm.
Coordinates, branch dimensions, waypoint positions, and target gaps use
canvas units. Font sizes and line widths use Typst lengths.

## Labels and colors

Cell and projection labels accept Typst content, such as `[CA1]` or
`[Input #sub[1]]`. Move a cell label with `label-offset`. Move an edge label
with `label-offset` and place it along the path with `label-at` from 0 to 1.

Use `color: rgb("367c9e")` on cells or projections. Layer backgrounds use
`fill`. Set `line-width` and `font-size` on the circuit; a projection's
`weight` multiplies its relative stroke thickness.

## Export a standalone figure

Keep this at the top of a figure document:

```typst
#set page(width: auto, height: auto, margin: 3mm)
```

Save your drawing as `examples/figure.typ` in the starter folder, then run:

```sh
typst compile --root . examples/figure.typ figure.pdf
typst compile --root . examples/figure.typ figure.svg
typst compile --root . examples/figure.typ figure.png --ppi 300
```

PDF and SVG preserve vector artwork. Use PNG when the destination requires a
raster image. The single-page examples work with each format. In the Typst
web app, use its export menu.

## Include it in a larger document

A circuit returns normal Typst content. Put it inside `figure` to add a
caption, or a grid to make a multi-panel figure. Keep page settings in the
containing document rather than inside a reusable drawing function.

Before submitting a paper or slides, inspect the exported figure at its final
size: check label readability, line widths, and connection clearances.
