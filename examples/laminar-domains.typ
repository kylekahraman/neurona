#import "../lib.typ": band, region, site, neuron, neurite, circuit, annotation
#set page(width: auto, height: auto, margin: 2mm)
#set text(font: "Libertinus Sans", size: 9pt)

// Symbolic somatodendritic and axonal territories, inspired by Fig. 3.29.
// Explicit paths illustrate selected domains; they are not reconstructions.
#let domains-figure(width: 105mm) = {
  let dendrite = rgb("55636d")
  let bc = rgb("367c9e")
  let bis = rgb("80639e")
  let olm = rgb("aa5c35")
  circuit(width: width, font-size: 9.5pt, line-width: 1pt,
    regions: (region("ca1", (
      band("so", label: [SO], height: 0.9, fill: rgb("f0f3ef")),
      band("sp", label: [SP], height: 0.4, fill: rgb("e0e8e0")),
      band("sr", label: [SR], height: 1.4, fill: rgb("f3f6f8")),
      band("slm", label: [SLM], height: 0.9, fill: rgb("e7eef3")),
    ), width: 10),),
    neurons: (
      neuron("bc", at: site("ca1", "sp", 1.7), kind: "custom", color: bc,
        dendrites: (neurite(((0, -0.7), (0, 1.5)), color: dendrite, thickness: 1.8),),
        axons: (
          neurite(((0, 0), (0.65, 0)), thickness: 0.65),
          neurite(((0.65, -0.15), (0.65, 0.15)), thickness: 0.65,
            boutons: ((0.65, -0.15), (0.65, 0), (0.65, 0.15))),
        )),
      neuron("bis", at: site("ca1", "sp", 4.9), kind: "custom", color: bis,
        dendrites: (neurite(((0, -0.7), (0, 1.35)), color: dendrite, thickness: 1.8),),
        axons: (
          neurite(((0, 0), (0.65, 0), (0.65, 1.25)), thickness: 0.65,
            boutons: ((0.65, 0.55), (0.65, 0.8), (0.65, 1.05), (0.65, 1.25))),
          neurite(((0.65, 0), (0.65, -0.75)), thickness: 0.65,
            boutons: ((0.65, -0.4), (0.65, -0.65))),
        )),
      neuron("olm", at: site("ca1", "so", 8.1), kind: "custom", color: olm,
        dendrites: (neurite(((-0.7, 0), (0.7, 0)), color: dendrite, thickness: 1.8),),
        axons: (neurite(((0, 0.13), (0, 2.85)), thickness: 0.65,
          boutons: ((0, 2.4), (0, 2.6), (0, 2.8))),)),
    ),
    annotations: (
      annotation((1.9, -0.4), [Basket]),
      annotation((5.1, -0.4), [Bistratified]),
      annotation((8.3, -0.4), [O-LM]),
    ),
  )
}

#domains-figure()
