#import "../lib.typ": band, region, site, neuron, projection, circuit, annotation
#set page(width: auto, height: auto, margin: 2mm)
#set text(font: "Libertinus Sans", size: 9pt)

#let excitation = rgb("367c9e")
#let distal-inhibition = rgb("aa5c35")
#let somatic-inhibition = rgb("80639e")

// Selected rodent CA1 pathways; sources and scope are in docs/visual-references.md.
#let ca1-figure(width: 85mm, legend: false) = circuit(
    width: width, legend: legend, legend-columns: 2,
    regions: (region("ca1", (
      band("so", label: [SO], name: [Stratum oriens], height: 1.6, fill: rgb("edf2ef")),
      band("sp", label: [SP], name: [Stratum pyramidale], height: 0.7, fill: rgb("dfe8e5")),
      band("sr", label: [SR], name: [Stratum radiatum], height: 2.2, fill: rgb("f2f5f8")),
      band("slm", label: [SLM], name: [Stratum lacunosum-moleculare], height: 1.4, fill: rgb("e5edf4")),
    ), width: 13, label: [CA1]),),
    neurons: (
      neuron("pc", at: site("ca1", "sp", 6.4), apical: 3.45,
        basal: 1.05, spread: 1.05, color: rgb("344c66"),
        ports: (oblique-west: (-1.05 * 0.75, 3.45 * 0.42))),
      neuron("olm", at: site("ca1", "so", 1.2), kind: "horizontal",
        spread: 0.9, color: distal-inhibition, axon-origin: "top"),
      neuron("bc", at: site("ca1", "sp", 10.5), kind: "stellate",
        spread: 0.55, orientation: 180deg,
        color: somatic-inhibition, axon-origin: "right"),
    ),
    connections: (
      projection(site("ca1", "slm", 12.5, depth: 0.64), "pc.tuft",
        color: excitation, label: [EC layer III], label-at: 0.45, target-gap: 0.07),
      projection(site("ca1", "sr", 1.4, depth: 0.5), "pc.oblique-west",
        color: excitation, label: [CA3 · Schaffer collaterals], label-at: 0.45,
        label-offset: (0, 0.22), target-gap: 0.26),
      projection("olm.axon", "pc.tuft-west", effect: "inhibitory",
        color: distal-inhibition, target-gap: 0.07,
        via: (site("ca1", "slm", 1.2, depth: 0.64),)),
      projection("bc.axon", "pc.soma-east", effect: "inhibitory",
        color: somatic-inhibition, target-gap: 0.17),
    ),
    annotations: (
      annotation((6.4, -0.45), [CA1 pyramidal cell], color: rgb("344c66")),
      annotation((1.2, -0.45), [O-LM cell], color: distal-inhibition),
      annotation((10.5, -0.45), [Basket cell], color: somatic-inhibition),
    ),
    font-size: 10pt,
  )

#ca1-figure()
