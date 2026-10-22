#import "../lib.typ": band, region, site, neuron, population, projection, circuit, annotation
#set page(width: auto, height: auto, margin: 2mm)
#set text(font: "Libertinus Sans", size: 9pt)

// Selected pathways in an unfolded arrangement, not anatomical proximity.
#let pathways-figure(width: 125mm) = {
  let blue = rgb("367c9e")
  let green = rgb("408b74")
  let orange = rgb("ae713d")
  circuit(width: width, font-size: 9.5pt, line-width: 0.9pt,
    regions: (
      region("dg", (
        band("hil", label: [Hil], height: 0.8, fill: rgb("f1f4ef")),
        band("gcl", label: [GCL], height: 0.45, fill: rgb("dce8dc")),
        band("iml", label: [iML], height: 0.45, fill: rgb("f1f5ef")),
        band("mml", label: [mML], height: 0.65, fill: rgb("e8f0e5")),
        band("oml", label: [oML], height: 0.85, fill: rgb("f1f5ef")),
      ), width: 3, label: [DG]),
      region("ca3", (
        band("so", label: [SO], height: 0.8, fill: rgb("f6f1eb")),
        band("sp", label: [SP], height: 0.45, fill: rgb("eadccc")),
        band("sl", label: [SL], height: 0.38, fill: rgb("f3e5d1")),
        band("sr", label: [SR], height: 1, fill: rgb("faf6f0")),
        band("slm", label: [SLM], height: 0.57, fill: rgb("f1e9df")),
      ), at: (4.4, 0), width: 3, label: [CA3]),
      region("ca1", (
        band("so", label: [SO], height: 0.8, fill: rgb("edf2f6")),
        band("sp", label: [SP], height: 0.45, fill: rgb("dbe5ef")),
        band("sr", label: [SR], height: 1.38, fill: rgb("f2f6f9"), label-offset: (0, 0.28)),
        band("slm", label: [SLM], height: 0.57, fill: rgb("e5edf4")),
      ), at: (8.8, 0), width: 3, label: [CA1]),
    ),
    neurons: (
      neuron("gc", at: site("dg", "gcl", 1.5), kind: "granule", detail: "minimal",
        apical: 1.65, spread: 0.5, color: green),
      neuron("ca3pc", at: site("ca3", "sp", 1.5), detail: "minimal",
        apical: 1.65, basal: 0.65, spread: 0.5, color: orange),
      neuron("ca1pc", at: site("ca1", "sp", 1.5), detail: "minimal",
        apical: 1.65, basal: 0.65, spread: 0.5, color: blue),
    ),
    populations: (
      population("ec2", [EC II], at: (1.5, 4.5), width: 1.4, height: 0.6, color: green),
      population("ec3", [EC III], at: (10.3, 4.5), width: 1.4, height: 0.6, color: blue),
    ),
    connections: (
      projection("ec2.south", "gc.tuft", color: green, target-gap: 0.06),
      projection("ec2.east", "ca3pc.tuft-west", color: green,
        controls: ((5.1, 5.3), (6.4, 3.6)), target-gap: 0.06),
      projection("ec3.south", "ca1pc.tuft", color: blue, target-gap: 0.06),
      projection("gc.axon", "ca3pc.proximal", color: green,
        via: ((2.7, 0.1), (4.8, 0.1), (4.8, 1.322)), target-gap: 0.06),
      projection("ca3pc.axon", "ca1pc.apical", color: orange,
        via: ((5.9, 0.1), (7.8, 0.1), (7.8, 1.8005)), target-gap: 0.12),
    ),
    annotations: (
      annotation((3.7, -0.4), [Mossy fibers], color: green),
      annotation((8.2, -0.4), [Schaffer collaterals], color: orange),
    ),
  )
}

#pathways-figure()
