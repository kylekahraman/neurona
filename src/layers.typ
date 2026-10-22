/// Region-specific laminar geometry; all numeric distances use canvas units.
#import "@preview/cetz:0.3.4"

/// One layer. Regions list layers from bottom to top in the figure.
#let band(id, label: none, name: none, height: 1, fill: rgb("f3f5f7"), label-offset: (0, 0)) = (
  id: id, label: if label == none { id } else { label },
  name: name, height: height, fill: fill, label-offset: label-offset,
)

/// Data preset, not a new renderer. Heights/fills are supplied I-to-VI;
/// output follows the canvas convention VI-to-I, putting I at the top.
/// Heights are schematic and do not imply measured layer proportions.
#let cortical-layers(
  numbering: "roman", heights: (0.45, 0.45, 0.65, 0.5, 0.8, 0.75),
  fills: (rgb("f0f4f6"), rgb("e8eff2"), rgb("dfe9ee"),
    rgb("e8eeea"), rgb("dce7df"), rgb("edf2ed")),
) = {
  assert(numbering in ("roman", "arabic"), message: "Cortical numbering must be roman or arabic")
  assert(heights.len() == 6 and fills.len() == 6, message: "Supply six cortical heights and fills, ordered I-to-VI")
  for h in heights { assert(h > 0, message: "Cortical layer heights must be positive") }
  let roman = ("I", "II", "III", "IV", "V", "VI")
  let names = ([Molecular], [External granular], [External pyramidal],
    [Internal granular], [Internal pyramidal], [Multiform])
  range(6).rev().map(i => band("l" + str(i + 1),
    label: if numbering == "roman" { roman.at(i) } else { str(i + 1) },
    name: names.at(i), height: heights.at(i), fill: fills.at(i)))
}

/// A rectangular, unfolded region, with its own independent layer stack.
#let region(id, bands, at: (0, 0), width: 10, label: none, show-layer-labels: true) = (
  id: id, bands: bands, at: at, width: width, label: label,
  show-layer-labels: show-layer-labels,
)

/// A normal Typst legend, also usable separately from circuit(). One section
/// per region prevents coincident labels from merging different layer systems.
/// Order is top-to-bottom in the figure; labels and colors come from the bands.
#let layer-legend(regions, columns: 1, font-size: 7.5pt, width: none) = {
  assert(type(columns) == int and columns >= 1, message: "Legend columns must be a positive integer")
  set align(left)
  let sections = regions.map(r => {
    let entries = r.bands.rev().map(b => (
      box(width: 8pt, height: 6pt, fill: b.fill, stroke: 0.35pt + rgb("b4c0c8")),
      text(size: font-size, weight: "bold")[#b.label],
      text(size: font-size)[#if b.name != none { b.name }],
    )).flatten()
    stack(dir: ttb, spacing: 3pt,
      text(size: font-size, weight: "bold")[#if r.label == none { r.id } else { r.label }],
      grid(columns: (9pt, auto, 1fr), column-gutter: 4pt,
        row-gutter: 3pt, align: left + horizon, ..entries),
    )
  })
  let columns = if width == none { (auto,) * columns } else { (1fr,) * columns }
  let body = grid(columns: columns, column-gutter: 5mm, row-gutter: 3mm, ..sections)
  if width == none { body } else { block(width: width, body) }
}

/// Semantic location within a layer; x is measured from the region's left edge.
/// depth runs from 0 (bottom of band) to 1 (top of band), not cortical depth.
#let site(region, layer, x, depth: 0.5) = (
  region: region, layer: layer, x: x, depth: depth,
)

/// Resolve a semantic site to an absolute canvas coordinate.
#let resolve-site(position, regions) = {
  if type(position) == array { return position }
  let matches = regions.filter(r => r.id == position.region)
  assert(matches.len() == 1, message: "Unknown or duplicate region: " + position.region)
  let r = matches.first()
  assert(position.depth >= 0 and position.depth <= 1, message: "site depth must be between 0 and 1")
  assert(position.x >= 0 and position.x <= r.width, message: "site x must lie inside its region")
  let y = r.at.at(1)
  for b in r.bands {
    if b.id == position.layer {
      return (r.at.at(0) + position.x, y + b.height * position.depth)
    }
    y += b.height
  }
  panic("Unknown layer '" + position.layer + "' in region '" + r.id + "'")
}

#let draw-region(r, font-size: 8pt, stroke: rgb("cdd5dc")) = {
  import cetz.draw: rect, content
  let y = r.at.at(1)
  for b in r.bands {
    rect((r.at.at(0), y), (r.at.at(0) + r.width, y + b.height),
      fill: b.fill, stroke: (paint: stroke, thickness: 0.4pt))
    if r.show-layer-labels {
      content((r.at.at(0) - 0.22 + b.label-offset.at(0), y + b.height / 2 + b.label-offset.at(1)),
        text(size: font-size, fill: rgb("536371"))[#b.label], anchor: "east")
    }
    y += b.height
  }
  if r.label != none {
    content((r.at.at(0), y + 0.35),
      text(size: font-size * 1.15, weight: "bold")[#r.label], anchor: "south-west")
  }
}
