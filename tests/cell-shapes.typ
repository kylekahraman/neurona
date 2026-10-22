#import "../lib.typ": cells, neuron, projection, circuit
#import "@preview/cetz:0.3.4"
#set page(width: auto, height: auto, margin: 5mm)

// Check real renderer anchors under independent arbor resizing, rotation and
// uniform scale. Both detail levels must preserve the connection targets.
#for detail in ("minimal", "branched") {
  cetz.canvas({
    cells.draw-neuron(neuron("basket", kind: "basket", at: (2, 3),
      apical: 1.56, basal: 0.66, spread: 1.6, scale: 2, orientation: 90deg, detail: detail))
    cells.draw-neuron(neuron("bipolar", kind: "bipolar", at: (10, 3),
      apical: 1.78, basal: 1.8, spread: 0.64, scale: 2, orientation: 90deg, detail: detail))
    cetz.draw.get-ctx(ctx => {
      for (port, expected) in (
        ("basket.dendrite-top", (-0.24, 3)),
        ("basket.dendrite-left", (0.88, 0.68)),
        ("basket.dendrite-right", (0.84, 5.28)),
        ("bipolar.dendrite-top", (7.4, 3)),
        ("bipolar.dendrite-bottom", (12.6, 3)),
        ("bipolar.axon", (10.96, 3.4)),
        ("bipolar.soma-east", (10, 3.24)),
      ) {
        let (_, actual) = cetz.coordinate.resolve(ctx, port)
        for i in range(2) { assert(calc.abs(actual.at(i) - expected.at(i)) < 0.000001, message: "misplaced port: " + port) }
      }
      ()
    })
  })
}

// Render through the public validator too: all new targets must be accepted.
#circuit(
  neurons: (
    neuron("basket", kind: "basket", apical: 0.9, basal: 0.4, spread: 0.8),
    neuron("bipolar", kind: "bipolar", at: (4, 0), apical: 0.9, basal: 0.9, spread: 0.3),
  ),
  connections: (
    projection((0, 2), "basket.dendrite-top"),
    projection((-2, 0.4), "basket.dendrite-left"),
    projection((2, 0.4), "basket.dendrite-right"),
    projection((4, 2), "bipolar.dendrite-top"),
    projection((4, -2), "bipolar.dendrite-bottom"),
  ),
)
