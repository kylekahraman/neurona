/// Abstract model diagrams use the circuit renderer and need no biological cells.
#import "circuits.typ": circuit, projection

/// A functional component. Custom ports are offsets from its center in canvas units.
#let block(id, body, at: (0, 0), width: 2, height: 0.8, radius: 0.12,
  fill: rgb("edf2f6"), color: rgb("344c66"), ports: (:)) = (
  id: id, label: body, at: at, width: width, height: height, radius: radius,
  shape: "block", fill: fill, color: color, ports: ports,
)

/// A circular state or abstract computational unit; body may contain Typst math.
#let node(id, body, at: (0, 0), radius: 0.3,
  fill: white, color: rgb("344c66"), ports: (:)) = (
  id: id, label: body, at: at, width: radius * 2, height: radius * 2,
  radius: 0, shape: "circle", fill: fill, color: color, ports: ports,
)

/// A schematic array of activity, drawn as perspective planes.
/// Grid density and plane count describe the glyph, not inferred model dimensions.
#let model-layer(id, body: none, at: (0, 0), width: 0.9, height: 1.8,
  planes: 3, offset: (0.14, 0.1), slant: 0.25, grid: (4, 6),
  fill: rgb("e6f0f2"), color: rgb("397986"), ports: (:)) = (
  id: id, label: body, at: at, width: width, height: height, radius: 0,
  shape: "layer", planes: planes, offset: offset, slant: slant, grid: grid,
  fill: fill, color: color, ports: ports,
)

/// A background frame. Position/extent are explicit; labels sit inside its top edge.
/// Groups do not transform their contents. Draw outer frames before inner frames.
#let group(label: none, at: (0, 0), width: 3, height: 3,
  fill: rgb("f5f7fa"), color: rgb("b0bdca"), label-color: rgb("536371"), dashed: false) = (
  label: label, at: at, width: width, height: height,
  fill: fill, color: color, label-color: label-color, dashed: dashed,
)

/// Signal flow has no implied excitatory/inhibitory biological meaning.
/// Use controls for curved/recurrent paths, via for explicit polygonal routes.
#let link(source, target, directed: true, color: rgb("426f91"),
  via: (), controls: (), dashed: false, label: none,
  label-at: 0.5, label-offset: (0, 0.15), weight: 1, target-gap: 0.04) = projection(
  source, target, effect: if directed { "directed" } else { "unspecified" },
  color: color, via: via, controls: controls, dashed: dashed, label: label,
  label-at: label-at, label-offset: label-offset, weight: weight, target-gap: target-gap,
)

/// The same scene as circuit, with optional nodes/groups and no required neurons.
#let diagram(..args) = circuit(..args)
