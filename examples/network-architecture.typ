#import "../lib.typ": diagram, model-layer, link, annotation
#set page(width: auto, height: auto, margin: 5mm)
#set text(font: ("Inter", "Libertinus Sans"))

// An abstract learned architecture. Plane and dot counts are illustrative;
// annotate actual dimensions when a particular model requires them.
#diagram(
  nodes: (
    model-layer("input", at: (0, 0), planes: 1, height: 2,
      fill: rgb("edf0ef"), color: rgb("657b7a")),
    model-layer("hidden", at: (3.4, 0), planes: 5, height: 2.4, width: 1.1,
      fill: rgb("e3f1ed"), color: rgb("3b8c7b")),
    model-layer("state", at: (6.8, 0), planes: 3, height: 1.6,
      fill: rgb("e5edf7"), color: rgb("4c7dab")),
    model-layer("readout", at: (10.2, 0), planes: 1, height: 0.35, width: 1.3, grid: none,
      fill: rgb("e9e5df"), color: rgb("91785f")),
  ),
  connections: (
    link("input.east", "hidden.west"),
    link("hidden.east", "state.west"),
    link("state.east", "readout.west"),
  ),
  annotations: (
    annotation((0, 2), [Input]),
    annotation((3.12, 2), [Hidden layer]),
    annotation((6.66, 2), [Representation]),
    annotation((10.2, 2), [Readout]),
    annotation((0, -1.8), $x$),
    annotation((3.3, -1.8), $h = phi(W x + b)$),
    annotation((6.8, -1.8), $z = f(h)$),
    annotation((10.2, -1.8), $y = C z$),
  ),
  width: 170mm, font-size: 9pt, line-width: 0.8pt,
)
