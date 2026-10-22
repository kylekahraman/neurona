#import "../lib.typ": diagram, model-layer, link, annotation
#set page(width: auto, height: auto, margin: 5mm)
#set text(font: ("Inter", "Libertinus Sans"))

// Three copies of the same architecture, unrolled downward in time.
// Perspective planes depict layer activity; their density is schematic.
#let forward = rgb("344c56")
#let feedback = rgb("b86b43")
#let scene = (
  nodes: range(3).map(t => (
    model-layer("input-" + str(t), at: (0, -t * 4.1), planes: 1,
      fill: rgb("edf0ef"), color: rgb("657b7a")),
    model-layer("l1-" + str(t), at: (3.7, -t * 4.1),
      fill: rgb("e3f1ed"), color: rgb("3b8c7b")),
    model-layer("l2-" + str(t), at: (7.4, -t * 4.1),
      fill: rgb("e5edf7"), color: rgb("4c7dab")),
  )).flatten(),
  connections: (
    ..range(3).map(t => (
      link("input-" + str(t) + ".east", "l1-" + str(t) + ".west", color: forward),
      link("l1-" + str(t) + ".east", "l2-" + str(t) + ".west", color: forward),
    )).flatten(),
    ..range(2).map(t => (
      link("l2-" + str(t) + ".south", "l1-" + str(t + 1) + ".north", color: feedback,
        controls: ((7.4, -t * 4.1 - 2.05), (3.42, -t * 4.1 - 2.05)), dashed: true),
      link("l1-" + str(t) + ".south", "input-" + str(t + 1) + ".north", color: feedback,
        controls: ((3.7, -t * 4.1 - 2.05), (0, -t * 4.1 - 2.05)), dashed: true),
    )).flatten(),
    link((-2, 0.7), (-2, -8.9), color: rgb("9caaa9"), weight: 0.5),
  ),
  annotations: (
    annotation((0, 2), [Input], size: 11pt, color: forward),
    annotation((3.56, 2), [Layer 1], size: 11pt, color: forward),
    annotation((7.26, 2), [Layer 2], size: 11pt, color: forward),
    ..range(3).map(t => annotation((-1.1, -t * 4.1), [t = #t], size: 9pt)),
    annotation((1.55, 0.48), [Feedforward], size: 8pt, color: forward),
    annotation((5.6, -2.75), [Feedback], size: 8pt, color: feedback),
  ),
)
#diagram(..scene, width: 145mm, font-size: 9pt, line-width: 0.8pt)
