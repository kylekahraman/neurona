#import "../lib.typ": band, region, site, neuron, cortical-layers, circuit
#set page(width: auto, height: auto, margin: 2mm)
#set text(font: "Libertinus Sans", size: 9pt)

// Independent laminar systems, not a claim of I-VI homology in CA1.
#let layers-figure(width: 105mm, legend: true, numbering: "roman") = circuit(
  width: width, legend: legend, legend-columns: 2, font-size: 9pt,
  regions: (
    region("ca1", (
      band("so", label: [SO], name: [Stratum oriens], height: 0.8, fill: rgb("edf2ef")),
      band("sp", label: [SP], name: [Stratum pyramidale], height: 0.45, fill: rgb("dfe8e5")),
      band("sr", label: [SR], name: [Stratum radiatum], height: 1.65, fill: rgb("f2f5f8")),
      band("slm", label: [SLM], name: [Stratum lacunosum-moleculare], height: 0.7, fill: rgb("e5edf4")),
    ), width: 3.4, label: [CA1]),
    region("ctx", cortical-layers(numbering: numbering),
      at: (5.5, 0), width: 3.4, label: [Neocortex]),
  ),
  neurons: (
    neuron("hip", at: site("ca1", "sp", 1.7), apical: 2.1,
      basal: 0.65, spread: 0.52, color: rgb("344c66")),
    neuron("ctx", at: site("ctx", "l5", 1.7), apical: 2.2,
      basal: 0.75, spread: 0.52, color: rgb("408b74")),
  ),
)

#layers-figure()
