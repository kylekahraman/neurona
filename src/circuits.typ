/// Compose laminar regions, schematic cells and compartment-specific edges.
#import "@preview/cetz:0.3.4"
#import "layers.typ"
#import "cells.typ"

/// A region or population box, composed in the same scene as individual cells.
#let population(id, label, at: (0, 0), width: 1.6, height: 0.7,
  fill: rgb("edf2f6"), color: rgb("344c66")) = (
  id: id, label: label, at: at, width: width, height: height,
  fill: fill, color: color,
)

/// Explicit trajectory: via gives a polyline; controls gives 1 or 2 Bezier handles.
/// Coordinates can be semantic layer sites. No connectivity is inferred.
#let projection(
  source, target, effect: "excitatory", color: rgb("426f91"),
  via: (), controls: (), dashed: false, label: none,
  label-at: 0.5, label-offset: (0, 0.15), weight: 1, target-gap: 0,
) = (
  source: source, target: target, effect: effect, color: color,
  via: via, controls: controls, dashed: dashed, label: label,
  label-at: label-at, label-offset: label-offset,
  weight: weight, target-gap: target-gap,
)

#let annotation(at, body, anchor: "center", color: rgb("536371"), size: none) = (
  at: at, body: body, anchor: anchor, color: color, size: size,
)

/// An explicit branch point of one axon, distinct from an unmarked crossing.
/// It exposes a center port and is not a neuron or an inferred synapse.
#let junction(id, at: (0, 0), radius: 0.055, color: rgb("426f91")) = (
  id: id, at: at, radius: radius, color: color,
)

#let validate-regions(regions) = {
  assert(regions.map(r => r.id).dedup().len() == regions.len(), message: "Region IDs must be unique")
  for r in regions {
    assert(r.width > 0, message: "Region width must be positive")
    assert(r.bands.len() > 0, message: "A region needs at least one layer")
    assert(r.bands.map(b => b.id).dedup().len() == r.bands.len(), message: "Layer IDs must be unique within a region")
    for b in r.bands { assert(b.height > 0, message: "Layer heights must be positive") }
  }
}

/// Port coordinates match the visible front and rear edges of perspective layers.
#let node-anchors(n) = {
  let (w, h) = (n.width / 2, n.height / 2)
  if n.shape == "layer" {
    let (dx, dy) = (n.offset.at(0) * (n.planes - 1), n.offset.at(1) * (n.planes - 1))
    (center: (0, 0), east: (w, n.slant / 2), west: (-w - dx, -n.slant / 2 + dy),
      north: (-dx, h + dy), south: (0, -h),
      north-east: (w - dx, h + n.slant / 2 + dy), north-west: (-w - dx, h - n.slant / 2 + dy),
      south-east: (w, -h + n.slant / 2), south-west: (-w, -h - n.slant / 2))
  } else {
    let k = if n.shape == "circle" { calc.sqrt(0.5) } else { 1 }
    (center: (0, 0), north: (0, h), south: (0, -h), east: (w, 0), west: (-w, 0),
      north-east: (w * k, h * k), north-west: (-w * k, h * k),
      south-east: (w * k, -h * k), south-west: (-w * k, -h * k))
  }
}

/// Render one abstract node; exported for geometry checks and CeTZ composition.
#let draw-node(n, at: none, font-size: 8pt, line-width: 1pt) = {
  import cetz.draw: group, translate, circle, rect, anchor, content, line
  group(name: n.id, {
    translate(if at == none { n.at } else { at })
    let pen = (paint: n.color, thickness: line-width * 0.75)
    if n.shape == "circle" {
      circle((0, 0), radius: (n.width / 2, n.height / 2), fill: n.fill, stroke: pen)
    } else if n.shape == "layer" {
      // Rear planes first; the opaque front plane hides the rear interiors.
      for index in range(n.planes).rev() {
        let (dx, dy) = (-index * n.offset.at(0), index * n.offset.at(1))
        let (w, h, t) = (n.width / 2, n.height / 2, n.slant / 2)
        line((dx - w, dy - h - t), (dx + w, dy - h + t),
          (dx + w, dy + h + t), (dx - w, dy + h - t), close: true,
          fill: if index == 0 { n.fill } else { n.fill.darken(8% * index / n.planes) },
          stroke: (paint: n.color.lighten(25%), thickness: line-width * 0.5))
      }
      if n.grid != none {
        let (columns, rows) = n.grid
        let radius = calc.min(n.width / (columns + 1), n.height / (rows + 1)) * 0.2
        for column in range(columns) {
          let x = -n.width / 2 + n.width * (column + 1) / (columns + 1)
          for row in range(rows) {
            let y = -n.height / 2 + n.height * (row + 1) / (rows + 1) + n.slant * x / n.width
            circle((x, y), radius: (radius, radius * 1.25), fill: n.color.lighten(28%), stroke: none)
          }
        }
      }
    } else {
      rect((-n.width / 2, -n.height / 2), (n.width / 2, n.height / 2),
        radius: n.radius, fill: n.fill, stroke: pen)
    }
    for (name, point) in node-anchors(n) { anchor(name, point) }
    for (name, point) in n.ports { anchor(name, point) }
    if n.label != none {
      content(if n.shape == "layer" { (0, -n.height / 2 - n.slant / 2 - 0.4) } else { (0, 0) },
        text(size: font-size, fill: n.color)[#n.label])
    }
  })
}

/// Distances use canvas units (default 1 cm). Layers are listed bottom-to-top.
#let circuit(
  neurons: (), regions: (), populations: (), junctions: (), nodes: (), groups: (), connections: (), annotations: (),
  unit: 1cm, width: none, font-size: 8pt, line-width: 1pt,
  legend: false, legend-columns: 1,
) = {
  validate-regions(regions)
  assert(neurons.map(n => n.id).dedup().len() == neurons.len(), message: "Neuron IDs must be unique")
  let elements = neurons + populations
  assert(elements.map(n => n.id).dedup().len() == elements.len(), message: "Cell and population IDs must be unique")
  elements += nodes
  assert(elements.map(n => n.id).dedup().len() == elements.len(), message: "Diagram element IDs must be unique")
  elements += junctions
  assert(elements.map(n => n.id).dedup().len() == elements.len(), message: "Junction IDs must be unique across scene elements")
  for n in elements {
    assert(n.id != "" and not n.id.contains("."), message: "Neuron IDs must be nonempty and cannot contain dots")
    assert(not n.id.starts-with("__paradigm-"), message: "The __paradigm- prefix is reserved")
  }
  for n in neurons {
    assert(n.kind in ("pyramidal", "granule", "horizontal", "stellate", "basket", "bipolar", "custom"), message: "Unknown neuron glyph")
    assert(n.scale > 0 and n.apical > 0 and n.basal > 0 and n.spread > 0, message: "Neuron dimensions must be positive")
    assert(n.detail in ("minimal", "branched"), message: "Unknown cell detail level")
    assert(n.axon-origin in ("bottom", "top", "left", "right"), message: "Unknown axon origin")
    let ports = cells.port-names(n)
    assert(ports.dedup().len() == ports.len(), message: "Custom port names must not shadow existing compartments")
    for name in n.ports.keys() {
      assert(name != "" and not name.contains("."), message: "Port names must be nonempty and cannot contain dots")
    }
    for branch in n.dendrites + n.axons {
      assert(branch.points.len() >= 2 and branch.thickness > 0, message: "Neurites need at least two points and positive thickness")
      assert(branch.controls.len() <= 2, message: "Use at most two neurite control points")
      assert(branch.controls.len() == 0 or branch.points.len() == 2, message: "Curved neurites need exactly two endpoints")
    }
  }
  for n in populations {
    assert(n.width > 0 and n.height > 0, message: "Population dimensions must be positive")
  }
  for n in nodes {
    assert(n.shape in ("block", "circle", "layer"), message: "Unknown diagram node shape")
    assert(n.width > 0 and n.height > 0, message: "Diagram node dimensions must be positive")
    assert(n.radius >= 0, message: "Corner radius must be nonnegative")
    if n.shape == "layer" {
      assert(type(n.planes) == int and n.planes > 0, message: "Layer planes must be a positive integer")
      assert(n.offset.len() == 2 and n.offset.all(v => v >= 0), message: "Layer offsets must be nonnegative")
      assert(n.slant >= 0, message: "Layer slant must be nonnegative")
      if n.grid != none {
        assert(n.grid.len() == 2 and n.grid.all(v => type(v) == int and v > 0),
          message: "Layer grid needs two positive integers")
      }
    }
    assert(n.ports.keys().all(k => k != "" and not k.contains(".") and not k in
      ("north", "south", "east", "west", "center", "north-east", "north-west", "south-east", "south-west")),
      message: "Custom diagram ports must not shadow standard ports or contain dots")
  }
  for g in groups {
    assert(g.width > 0 and g.height > 0, message: "Group dimensions must be positive")
  }
  for n in junctions { assert(n.radius > 0, message: "Junction radius must be positive") }
  let resolve(p) = if type(p) == dictionary and "region" in p { layers.resolve-site(p, regions) } else { p }
  let validate-endpoint(p) = {
    if type(p) == str {
      let parts = p.split(".")
      assert(parts.len() == 2, message: "Use a cell.compartment endpoint")
      let matches = elements.filter(n => n.id == parts.first())
      assert(matches.len() == 1, message: "Unknown neuron endpoint or population: " + p)
      let n = matches.first()
      let ports = if "kind" in n { cells.port-names(n) }
        else if "radius" in n and not "shape" in n { ("center",) }
        else { ("north", "south", "east", "west", "center", "north-east", "north-west", "south-east", "south-west") + n.at("ports", default: (:)).keys() }
      assert(parts.last() in ports, message: "Unknown compartment: " + p)
    }
  }
  for p in connections {
    assert(p.effect in ("excitatory", "inhibitory", "unspecified", "directed"), message: "Unknown connection effect")
    assert(p.via.len() == 0 or p.controls.len() == 0, message: "Choose via or controls for a projection")
    assert(p.controls.len() <= 2, message: "Use at most two Bezier control points")
    assert(p.label-at >= 0 and p.label-at <= 1, message: "label-at must be between 0 and 1")
    assert(p.weight > 0, message: "Projection weight must be positive")
    assert(p.target-gap >= 0, message: "Target gap must be nonnegative")
    for endpoint in (p.source, p.target, ..p.via, ..p.controls) { validate-endpoint(endpoint) }
  }
  let drawing = cetz.canvas(length: unit, {
    import cetz.draw: bezier, content, line, rect, circle
    // Background frames are explicit geometry; they never imply membership or edges.
    for g in groups {
      let (x, y) = resolve(g.at)
      rect((x - g.width / 2, y - g.height / 2), (x + g.width / 2, y + g.height / 2),
        radius: 0.12, fill: g.fill,
        stroke: (paint: g.color, thickness: line-width * 0.5, dash: if g.dashed { "dashed" } else { "solid" }))
      if g.label != none {
        content((x, y + g.height / 2 - 0.24), text(size: font-size, fill: g.label-color)[#g.label], anchor: "north")
      }
    }
    for r in regions { layers.draw-region(r, font-size: font-size) }
    for n in neurons { cells.draw-neuron(n, at: resolve(n.at), line-width: line-width) }
    for n in populations {
      let pos = resolve(n.at)
      rect((pos.at(0) - n.width / 2, pos.at(1) - n.height / 2),
        (pos.at(0) + n.width / 2, pos.at(1) + n.height / 2),
        name: n.id, fill: n.fill, stroke: (paint: n.color, thickness: line-width * 0.75))
      content(pos, text(size: font-size, weight: "bold", fill: n.color)[#n.label])
    }
    for n in nodes {
      draw-node(n, at: resolve(n.at), font-size: font-size, line-width: line-width)
    }
    for n in junctions {
      circle(resolve(n.at), radius: n.radius, name: n.id, fill: n.color, stroke: none)
    }
    for (i, p) in connections.enumerate() {
      let name = "__paradigm-edge-" + str(i)
      let pen = (paint: p.color, thickness: line-width * 0.85 * p.weight,
        cap: "round", join: "round", dash: if p.dashed { "dashed" } else { "solid" })
      let mark = if p.effect == "inhibitory" { (end: "|", scale: 1.3, offset: p.target-gap) }
        else if p.effect in ("excitatory", "directed") { (end: ">", scale: 1.1, offset: p.target-gap) } else { none }
      if p.controls.len() > 0 {
        bezier(resolve(p.source), resolve(p.target), ..p.controls.map(resolve),
          name: name, stroke: pen, mark: mark)
      } else {
        line(resolve(p.source), ..p.via.map(resolve), resolve(p.target),
          name: name, stroke: pen, mark: mark)
      }
      if p.label != none {
        content((rel: p.label-offset, to: (name: name, anchor: p.label-at * 100%)),
          text(size: font-size, fill: p.color)[#p.label], anchor: "south")
      }
    }
    for n in neurons {
      if n.label != none {
        let pos = resolve(n.at)
        content((pos.at(0) + n.label-offset.at(0), pos.at(1) + n.label-offset.at(1)),
          text(size: font-size, weight: "bold", fill: n.color)[#n.label], anchor: "west")
      }
    }
    for a in annotations {
      content(resolve(a.at), text(size: if a.size == none { font-size } else { a.size }, fill: a.color)[#a.body], anchor: a.anchor)
    }
  })
  let artwork = if legend and regions.len() > 0 {
    context {
      let size = measure(drawing)
      stack(dir: ttb, spacing: 3mm, drawing,
        layers.layer-legend(regions, columns: legend-columns,
          font-size: font-size * 0.9, width: size.width))
    }
  } else { drawing }
  if width == none { artwork } else {
    context {
      let target = width.to-absolute()
      assert(target > 0pt, message: "Figure width must be positive")
      let factor = target / measure(artwork).width
      scale(x: factor * 100%, y: factor * 100%, reflow: true, artwork)
    }
  }
}
