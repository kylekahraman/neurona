/// Schematic glyphs, independent of anatomical identity or molecular markers.
#import "@preview/cetz:0.3.4"
#import "cell-shapes.typ" as shapes

/// A cell-relative neurite path. Boutons are explicit cell-relative positions,
/// not inferred contacts. thickness is relative to circuit line-width.
#let neurite(points, controls: (), boutons: (), color: none, thickness: 1) = (
  points: points, controls: controls, boutons: boutons,
  color: color, thickness: thickness,
)

/// apical, basal and spread describe drawing geometry, not measured morphology.
#let neuron(
  id, at: (0, 0), kind: "pyramidal", label: none,
  label-offset: (0.4, 0.3), color: rgb("344c66"),
  apical: 3.4, basal: 1.1, spread: 0.9, scale: 1,
  orientation: 0deg, detail: "branched", axon-origin: "bottom", dendrites: (), axons: (), ports: (:),
) = (
  id: id, at: at, kind: kind, label: label, label-offset: label-offset,
  color: color, apical: apical, basal: basal, spread: spread, scale: scale,
  orientation: orientation, detail: detail, axon-origin: axon-origin, dendrites: dendrites, axons: axons, ports: ports,
)

/// Default axon geometry and its connection port must use the same exit.
/// Directions are cell-local and therefore follow cell scale and rotation.
#let axon-geometry(n) = {
  if n.axon-origin == "bottom" {
    if n.kind == "bipolar" { ((0.05, -0.08), (0.20, -0.48)) }
    else { ((0, -0.12), (0, -0.48)) }
  } else {
    let rx = if n.kind == "pyramidal" { 0.117 }
      else if n.kind in ("horizontal", "custom") { 0.23 }
      else if n.kind == "bipolar" { 0.12 } else { 0.17 }
    let ry = if n.kind == "pyramidal" { 0.24 }
      else if n.kind in ("horizontal", "custom") { 0.13 }
      else if n.kind == "bipolar" { 0.20 } else { 0.17 }
    if n.axon-origin == "top" { ((0, ry), (0, 0.48)) }
    else if n.axon-origin == "left" { ((-rx, 0), (-0.48, 0)) }
    else { ((rx, 0), (0.48, 0)) }
  }
}

/// The renderer and scene validator share one definition of available ports.
#let port-names(n) = {
  let names = ("soma", "soma-west", "soma-east")
  if n.kind != "custom" { names += ("axon", "dendrite") }
  if n.kind in ("pyramidal", "granule") { names += ("proximal", "apical", "tuft", "tuft-west") }
  if n.kind == "pyramidal" { names += ("basal", "ais", "oblique-tip-west", "oblique-tip-east", "basal-tip-west", "basal-tip-east") }
  if n.kind in shapes.shapes {
    names += shapes.shapes.at(n.kind).ports.keys().filter(name => name != "dendrite")
  }
  for (kind, arbors) in (("dendrite", n.dendrites), ("axon", n.axons)) {
    for i in range(arbors.len()) { names.push(kind + "-" + str(i)) }
  }
  names + n.ports.keys()
}

/// Draw inside a CeTZ canvas. Named anchors address explicit compartments.
#let draw-neuron(n, at: none, line-width: 1pt) = {
  import cetz.draw: anchor, bezier, circle, group, line, translate, scale, rotate
  group(name: n.id, {
    translate(if at == none { n.at } else { at })
    scale(n.scale)
    rotate(n.orientation)
    let a = n.apical
    let b = n.basal
    let w = n.spread
    let pen = (paint: n.color, thickness: line-width, cap: "round", join: "round")
    let twig = (paint: n.color, thickness: line-width * 0.65, cap: "round")
    // Branches attach to the actual quadratic curve, including after resizing.
    let on-curve(start, control, end, t) = range(2).map(i =>
      (1 - t) * (1 - t) * start.at(i) + 2 * (1 - t) * t * control.at(i) + t * t * end.at(i))
    if n.kind == "pyramidal" {
      line((0, 0.15), (0, a * 0.76), stroke: pen)
      for side in (-1, 1) {
        for (i, level) in (if n.detail == "minimal" { (0.47,) } else { (0.28, 0.47) }).enumerate() {
          let tip = (side * w * (0.75 + i * 0.16), a * (level + 0.14))
          let start = (0, a * level)
          let ctrl = (side * w * 0.42, a * (level + 0.02))
          bezier(start, tip, ctrl, stroke: pen)
          if n.detail != "minimal" {
            line(tip, (tip.at(0) + side * w * 0.18, tip.at(1) + a * 0.07), stroke: twig)
            line(on-curve(start, ctrl, tip, 0.7),
              (tip.at(0) * 0.85, tip.at(1) + a * 0.08), stroke: twig)
          }
        }
        bezier((0, a * 0.69), (side * w * 0.83, a),
          (side * w * 0.15, a * 0.94), stroke: pen)
        if n.detail != "minimal" {
          line(on-curve((0, a * 0.69), (side * w * 0.15, a * 0.94), (side * w * 0.83, a), 0.65),
            (side * w * 0.30, a * 1.06), stroke: twig)
          line(on-curve((0, a * 0.69), (side * w * 0.15, a * 0.94), (side * w * 0.83, a), 0.85),
            (side * w * 1.05, a * 0.94), stroke: twig)
        }
        bezier((side * 0.12, -0.06), (side * w * 0.90, -b),
          (side * w * 0.44, -b * 0.42), stroke: pen)
        if n.detail != "minimal" {
          line(on-curve((side * 0.12, -0.06), (side * w * 0.44, -b * 0.42), (side * w * 0.90, -b), 0.55),
            (side * w * 0.93, -b * 0.45), stroke: twig)
          line(on-curve((side * 0.12, -0.06), (side * w * 0.44, -b * 0.42), (side * w * 0.90, -b), 0.83),
            (side * w * 0.54, -b * 1.11), stroke: twig)
        }
      }
    } else if n.kind == "granule" {
      // A fan-shaped arbor rather than a pyramidal trunk with oblique branches.
      line((0, 0.15), (0, a * 0.47), stroke: pen)
      for fraction in (if n.detail == "minimal" { (-0.83, 0, 0.83) } else { (-0.83, -0.40, 0, 0.40, 0.83) }) {
        let start = (0, a * 0.47)
        let ctrl = (fraction * w * 0.65, a * 0.75)
        let end = (fraction * w, a)
        bezier(start, end, ctrl, stroke: pen)
        if n.detail != "minimal" {
          line(on-curve(start, ctrl, end, 0.65),
            (fraction * w + 0.16 * w, a * 0.97), stroke: twig)
        }
      }
    } else if n.kind == "horizontal" {
      for side in (-1, 1) {
        bezier((side * 0.12, 0), (side * w, 0.08),
          (side * w * 0.5, 0.17), stroke: pen)
        line(on-curve((side * 0.12, 0), (side * w * 0.5, 0.17), (side * w, 0.08), 0.55),
          (side * w * 0.78, 0.39), stroke: twig)
        line(on-curve((side * 0.12, 0), (side * w * 0.5, 0.17), (side * w, 0.08), 0.75),
          (side * w * 0.94, -0.25), stroke: twig)
      }
    } else if n.kind == "stellate" {
      for angle in (20, 75, 135, 195, 255, 315) {
        let dx = calc.cos(angle * 1deg)
        let dy = calc.sin(angle * 1deg)
        line((dx * 0.13, dy * 0.13), (dx * w, dy * w), stroke: pen)
        line((dx * w * 0.72, dy * w * 0.72),
          (dx * w + 0.16 * dy, dy * w - 0.16 * dx), stroke: twig)
      }
    } else if n.kind in shapes.shapes {
      let geometry = shapes.geometry(n)
      for path in geometry.paths { line(..path, stroke: pen) }
      for (name, point) in geometry.ports {
        if name != "dendrite" { anchor(name, point) }
      }
    }
    // Axon stub; intercellular trajectories belong to the circuit renderer.
    if n.kind != "custom" { line(..axon-geometry(n), stroke: twig) }
    for (kind, arbors) in (("dendrite", n.dendrites), ("axon", n.axons)) {
      for (i, branch) in arbors.enumerate() {
        let paint = if branch.color == none { n.color } else { branch.color }
        let stroke = (paint: paint, thickness: line-width * branch.thickness, cap: "round", join: "round")
        if branch.controls.len() > 0 {
          bezier(branch.points.first(), branch.points.last(), ..branch.controls, stroke: stroke)
        } else { line(..branch.points, stroke: stroke) }
        for pos in branch.boutons { circle(pos, radius: 0.055, fill: paint, stroke: none) }
        anchor(kind + "-" + str(i), branch.points.last())
      }
    }
    if n.kind == "pyramidal" {
      line((-0.18, -0.13), (0, 0.24), (0.18, -0.13),
        close: true, fill: n.color, stroke: pen)
    } else if n.kind == "bipolar" {
      circle((0, 0), radius: (0.12, 0.20), fill: n.color, stroke: none)
    } else if n.kind in ("horizontal", "custom") {
      circle((0, 0), radius: (0.23, 0.13), fill: n.color, stroke: none)
    } else {
      circle((0, 0), radius: 0.17, fill: n.color, stroke: none)
    }
    anchor("soma", (0, 0))
    let soma-radius = if n.kind in ("horizontal", "custom") { 0.23 }
      else if n.kind == "pyramidal" { 0.117 }
      else if n.kind == "bipolar" { 0.12 } else { 0.17 }
    anchor("soma-west", (-soma-radius, 0))
    anchor("soma-east", (soma-radius, 0))
    if n.kind != "custom" { anchor("axon", axon-geometry(n).last()) }
    if n.kind in ("pyramidal", "granule") {
      anchor("proximal", (0, a * 0.18))
      anchor("apical", (0, a * 0.47))
      anchor("tuft", (w * 0.83, a))
      anchor("tuft-west", (-w * 0.83, a))
    }
    if n.kind == "pyramidal" {
      anchor("basal", (-w * 0.90, -b))
      anchor("ais", (0, -0.3))
      // Visible branch ends keep incoming connectors outside the arbor.
      let oblique-x = if n.detail == "minimal" { w * 0.75 } else { w * 1.09 }
      let oblique-y = if n.detail == "minimal" { a * 0.61 } else { a * 0.68 }
      anchor("oblique-tip-west", (-oblique-x, oblique-y))
      anchor("oblique-tip-east", (oblique-x, oblique-y))
      anchor("basal-tip-west", (-w * 0.90, -b))
      anchor("basal-tip-east", (w * 0.90, -b))
    }
    if n.kind != "custom" {
      anchor("dendrite", if n.kind == "horizontal" { (w, 0.08) }
      else if n.kind == "stellate" { (calc.cos(20deg) * w, calc.sin(20deg) * w) }
      else if n.kind in shapes.shapes { shapes.geometry(n).ports.dendrite }
      else { (0, a * 0.28) })
    }
    for (name, pos) in n.ports { anchor(name, pos) }
  })
}
