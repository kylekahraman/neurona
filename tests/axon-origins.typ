#import "../lib.typ": neuron, cells
#import "@preview/cetz:0.3.4"
#set page(width: auto, height: auto, margin: 3mm)

// A rerouted axon must expose its new drawn endpoint after both scale and
// rotation; connectors may not keep attaching to the previous bottom stub.
#for kind in ("horizontal", "stellate", "pyramidal") {
  for (origin, expected) in (
    ("bottom", (3.96, 2)), ("top", (2.04, 2)),
    ("left", (3, 1.04)), ("right", (3, 2.96)),
  ) {
    cetz.canvas({
      cells.draw-neuron(neuron("cell", kind: kind, at: (3, 2), scale: 2,
        orientation: 90deg, axon-origin: origin))
      cetz.draw.get-ctx(ctx => {
        let (_, actual) = cetz.coordinate.resolve(ctx, "cell.axon")
        for i in range(2) { assert(calc.abs(actual.at(i) - expected.at(i)) < 0.00001) }
        ()
      })
    })
  }
}
