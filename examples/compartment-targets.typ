#import "../lib.typ": band, region, site, neuron, interneuron, projection, circuit, annotation
#set page(width: auto, height: auto, margin: 2mm)
#set text(font: "Libertinus Sans", size: 9pt)

// Selected CA1 GABAergic target domains; sources in docs/cell-recipes.md.
#let targets-figure(width: 165mm, legend: false) = {
  let basket = rgb("367c9e")
  let axo = rgb("408b74")
  let bis = rgb("80639e")
  let olm = rgb("aa5c35")
  let ink = rgb("344c66")
  circuit(width: width, font-size: 9.5pt, line-width: 1pt,
    legend: legend, legend-columns: 1,
    regions: (region("ca1", (
      band("so", label: [SO], name: [Stratum oriens], height: 1.5, fill: rgb("edf2ef")),
      band("sp", label: [SP], name: [Stratum pyramidale], height: 0.6, fill: rgb("dfe8e5")),
      band("sr", label: [SR], name: [Stratum radiatum], height: 2, fill: rgb("f2f5f8")),
      band("slm", label: [SLM], name: [Stratum lacunosum-moleculare], height: 1.4, fill: rgb("e5edf4")),
    ), width: 14.5, label: [CA1]),),
    neurons: (
      neuron("pc", at: site("ca1", "sp", 8), apical: 3.1, basal: 1,
        spread: 0.9, color: ink,
        ports: (basal-east: (0.81, -1), apical-east: (0.981, 3.1 * 0.68))),
      interneuron("olm", kind: "olm", at: site("ca1", "so", 1.8),
        color: olm, dendrite-color: olm, scale: 0.5, arbor: false),
      interneuron("axo", kind: "axo-axonic", at: site("ca1", "sp", 4.5),
        color: axo, dendrite-color: axo, scale: 0.5, arbor: false),
      interneuron("bc", kind: "basket", at: site("ca1", "sp", 10.5),
        color: basket, dendrite-color: basket, scale: 0.5, arbor: false),
      interneuron("bis", kind: "bistratified", at: site("ca1", "sp", 12.8),
        color: bis, dendrite-color: bis, scale: 0.5, arbor: false),
    ),
    connections: (
      projection("olm.axon", "pc.tuft-west", effect: "inhibitory", color: olm, target-gap: 0.07,
        via: ((0.55, 0.51), (0.55, 4.9))),
      projection("axo.axon", "pc.ais", effect: "inhibitory", color: axo,
        controls: ((4.5, -0.15), (8, -0.15)), target-gap: 0.18),
      projection("bc.axon", "pc.soma-east", effect: "inhibitory", color: basket,
        controls: ((10.2, 1.25), (9.1, 1.8)), target-gap: 0.07),
      // One axon, one explicit branch point, two dendritic targets.
      projection("bis.axon", (11.8, 1.0), effect: "unspecified", color: bis),
      projection((11.8, 1.0), "pc.apical-east", effect: "inhibitory", color: bis,
        controls: ((11.8, 3.8), (10.2, 4.1)), target-gap: 0.18),
      projection((11.8, 1.0), "pc.basal-east", effect: "inhibitory", color: bis,
        controls: ((10.4, 0.75),), target-gap: 0.07),
    ),
    annotations: (
      annotation((11.8, 1.0), circle(radius: 1.2pt, fill: bis, stroke: none)),
      annotation((1.8, -0.5), [O-LM], color: olm),
      annotation((4.5, -0.5), [Axo-axonic], color: axo),
      annotation((8, -0.5), [Pyramidal], color: ink),
      annotation((10.5, -0.5), [Basket], color: basket),
      annotation((12.8, -0.5), [Bistratified], color: bis),
    ),
  )
}

#targets-figure()
