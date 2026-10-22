// Additional schematic morphology data, expressed in cell-local coordinates.
// These shapes describe drawing conventions, not molecular cell identity.
#let shapes = (
  basket: (
    width: 0.8, upper: 0.78, lower: 0.33,
    paths: (
      ((0, 0), (-0.02, 0.32), (0, 0.56), (-0.14, 0.78)),
      ((0, 0.56), (0.21, 0.78)),
      ((0, 0), (-0.27, 0.20), (-0.58, 0.28), (-0.76, 0.45)),
      ((-0.27, 0.20), (-0.30, 0.50), (-0.48, 0.65)),
      ((0, 0), (0.25, 0.16), (0.57, 0.29), (0.77, 0.48)),
      ((0.25, 0.16), (0.30, 0.48), (0.49, 0.62)),
      ((0, 0), (-0.34, -0.23), (-0.65, -0.30)),
      ((0, 0), (0.35, -0.22), (0.65, -0.33)),
    ),
    minimal-paths: (0, 1, 2, 4, 6, 7),
    ports: (dendrite: (0, 0.56), dendrite-top: (0, 0.56),
      dendrite-left: (-0.58, 0.28), dendrite-right: (0.57, 0.29)),
  ),
  bipolar: (
    width: 0.32, upper: 0.89, lower: 0.90,
    paths: (
      ((0, 0), (0.02, 0.37), (0, 0.65), (-0.18, 0.87)),
      ((0, 0.65), (0.18, 0.89)),
      ((0.02, 0.37), (0.23, 0.55), (0.32, 0.72)),
      ((0, 0), (-0.02, -0.36), (0, -0.65), (-0.17, -0.87)),
      ((0, -0.65), (0.17, -0.90)),
      ((-0.02, -0.36), (-0.24, -0.55), (-0.32, -0.72)),
    ),
    minimal-paths: (0, 1, 3, 4),
    ports: (dendrite: (0, 0.65), dendrite-top: (0, 0.65), dendrite-bottom: (0, -0.65)),
  ),
)

// Use the same transformation for paths AND anchors when dimensions change.
#let geometry(n) = {
  let shape = shapes.at(n.kind)
  let fit(p) = (p.at(0) * n.spread / shape.width,
    p.at(1) * if p.at(1) >= 0 { n.apical / shape.upper } else { n.basal / shape.lower })
  let paths = if n.detail == "minimal" {
    shape.minimal-paths.map(i => shape.paths.at(i))
  } else { shape.paths }
  let ports = (:)
  for (name, point) in shape.ports { ports.insert(name, fit(point)) }
  (paths: paths.map(path => path.map(fit)), ports: ports)
}
