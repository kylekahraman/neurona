#import "../lib.typ": interneuron, neuron, motif, motif-scene, circuit, cells
#import "@preview/cetz:0.3.4"
#set page(width: auto, height: auto, margin: 3mm)

// Ports must stay attached to the drawing after rotation and scaling, with
// the optional decorative territory shown or hidden.
#for kind in ("basket", "axo-axonic", "bistratified", "olm") {
  for arbor in (false, true) {
    cetz.canvas({
      cells.draw-neuron(interneuron("i", kind: kind, at: (3, 2), scale: 2, orientation: 90deg, arbor: arbor))
      cetz.draw.get-ctx(ctx => {
        let (_, point) = cetz.coordinate.resolve(ctx, "i.axon")
        let expected-port = if not arbor { (3.96, 2) }
          else if kind == "olm" { (2.04, 2) } else { (3, 2.96) }
        for (actual, expected) in point.zip(expected-port) {
          assert(calc.abs(actual - expected) < 0.00001)
        }
        ()
      })
    })
  }
}

// Axo-axonic terminals use the initial-segment port on the drawn axon stub.
#cetz.canvas({
  cells.draw-neuron(neuron("p", at: (3, 2), scale: 2, orientation: 90deg))
  cetz.draw.get-ctx(ctx => {
    let (_, point) = cetz.coordinate.resolve(ctx, "p.ais")
    for (actual, expected) in point.zip((3.6, 2)) {
      assert(calc.abs(actual - expected) < 0.00001)
    }
    ()
  })
})

// Exercise both editable scene records and the convenience drawing API.
#for kind in ("feedforward", "feedback", "disinhibition") {
  circuit(..motif-scene(kind), width: 60mm)
  context {
    for width in (45mm, 85mm, 125mm) {
      let actual = measure(motif(kind, width: width)).width
      assert(calc.abs(actual - width) < 0.001pt)
    }
  }
}

// Reversing either inhibitory link changes the disinhibitory mechanism.
#let dis = motif-scene("disinhibition")
#let inhibitory = dis.connections.filter(edge => edge.effect == "inhibitory")
#assert(inhibitory.any(edge => edge.source == "i1.axon" and edge.target == "i.soma-west"))
#assert(inhibitory.any(edge => edge.source == "i.axon" and edge.target == "e.apical"))
