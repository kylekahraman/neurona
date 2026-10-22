#import "../lib.typ": diagram, node, block, group, link, annotation
#set page(width: auto, height: auto, margin: 5mm)

// Small fully connected architecture. Each edge is explicitly generated;
// the renderer never infers connectivity from layout or grouping.
#diagram(
  nodes: (
    ..range(3).map(i => node("x" + str(i), $x_(#(i + 1))$, at: (0, 2 - i), radius: 0.24, fill: rgb("fff0cd"))),
    ..range(3).map(i => node("h" + str(i), $h_(#(i + 1))$, at: (3, 2 - i), radius: 0.24,
      ports: (in0: (-calc.sqrt(0.24 * 0.24 - 0.12 * 0.12), 0.12), in1: (-0.24, 0),
        in2: (-calc.sqrt(0.24 * 0.24 - 0.12 * 0.12), -0.12)))),
    block("y", $y = C h$, at: (6.5, 1), width: 1.8, ports: (in0: (-0.9, 0.25), in1: (-0.9, 0), in2: (-0.9, -0.25))),
  ),
  groups: (
    group(label: [Input], at: (0, 1), width: 1.6, height: 3.8),
    group(label: [Hidden layer], at: (3, 1), width: 2, height: 3.8),
  ),
  connections: (
    ..range(3).map(i => range(3).map(j =>
      link("x" + str(i) + ".east", "h" + str(j) + ".in" + str(i), color: rgb("91a6b7"), weight: 0.55)
    )).flatten(),
    ..range(3).map(i => link("h" + str(i) + ".east", "y.in" + str(i), color: rgb("426f91"))),
  ),
  annotations: (
    annotation((1.5, -1.5), $h = phi(W x + b)$),
    annotation((6.5, -1.5), [Readout]),
  ),
  width: 150mm, font-size: 9pt,
)
