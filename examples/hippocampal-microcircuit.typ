#import "../lib.typ": band, region, site, neuron, interneuron, population, junction, projection, annotation, circuit
#set page(width: auto, height: auto, margin: 3mm)
#set text(font: "Libertinus Sans", size: 9.5pt)

// First selected-cell composition inspired by Fig. 7.1B. It deliberately
// omits many cell classes and pathways; see docs/hippocampal-microcircuit.md.
// Return ordinary scene data so cells, paths and colors remain author-editable.
#let microcircuit-scene(inputs: true, excitation: rgb("b15e46"), inhibition: rgb("5069a0"),
  fills: (rgb("f4f4f4"), rgb("e5e5e5"), rgb("f0f0f0"), rgb("f7f7f7"), rgb("ededed"))) = {
  let regions = (
    region("dg", (
      band("hil", label: [Hilus], height: 1.7, fill: fills.at(0)),
      band("gcl", label: [GCL], height: 0.5, fill: fills.at(1)),
      band("iml", label: [IML], height: 0.9, fill: fills.at(2)),
      band("mml", label: [MML], height: 1.3, fill: fills.at(3)),
      band("oml", label: [OML], height: 1.8, fill: fills.at(4)),
    ), width: 6, label: [Dentate gyrus]),
    region("ca3", (
      band("so", label: [SO], height: 1.7, fill: fills.at(0)),
      band("sp", label: [SP], height: 0.5, fill: fills.at(1)),
      band("sl", label: [SL], height: 0.75, fill: fills.at(2)),
      band("sr", label: [SR], height: 1.45, fill: fills.at(3)),
      band("slm", label: [SLM], height: 1.8, fill: fills.at(4)),
    ), at: (7.3, 0), width: 6.5, label: [CA3]),
    region("ca1", (
      band("so", label: [SO], height: 1.7, fill: fills.at(0)),
      band("sp", label: [SP], height: 0.5, fill: fills.at(1)),
      band("sr", label: [SR], height: 2.2, fill: fills.at(3)),
      band("slm", label: [SLM], height: 1.8, fill: fills.at(4)),
    ), at: (15.1, 0), width: 11, label: [CA1]),
  )
  let neurons = (
    neuron("gc", at: site("dg", "gcl", 2.9), kind: "granule", apical: 3.7,
      spread: 0.75, color: excitation),
    neuron("dg-bc", at: site("dg", "gcl", 4.9), kind: "basket", apical: 1.25,
      basal: 0.6, spread: 0.55, color: inhibition),
    neuron("ca3-pc", at: site("ca3", "sp", 4.7), apical: 3.7, basal: 1.1,
      spread: 0.65, color: excitation),
    neuron("ca3-in", at: site("ca3", "sp", 1.5), kind: "basket", apical: 1.25,
      basal: 0.6, spread: 0.55, color: inhibition),
    neuron("ca1-pc", at: site("ca1", "sp", 5.3), apical: 3.7, basal: 1.1,
      spread: 0.65, color: excitation,
      ports: (oblique-west: (-0.65 * 0.75, 3.7 * 0.42),
        oblique-east: (0.65 * 1.09, 3.7 * 0.68), basal-east: (0.65 * 0.9, -1.1))),
    interneuron("ca1-bc", at: site("ca1", "sp", 2.9), kind: "basket",
      scale: 0.6, arbor: false, color: inhibition, dendrite-color: inhibition),
    interneuron("aac", at: site("ca1", "sp", 7.9), kind: "axo-axonic",
      scale: 0.55, arbor: false, color: inhibition, dendrite-color: inhibition),
    interneuron("bic", at: site("ca1", "sp", 9.9), kind: "bistratified",
      scale: 0.55, arbor: false, color: inhibition, dendrite-color: inhibition),
    interneuron("olm", at: site("ca1", "so", 1.5), kind: "olm",
      scale: 0.7, arbor: false, color: inhibition, dendrite-color: inhibition),
  )
  let junctions = (
    junction("gc-out", at: (2.9, 0.35), color: excitation),
    junction("mf", at: (10.3, 2.616), color: excitation),
    junction("ca3-out", at: (12, 0.35), color: excitation),
    junction("sc", at: (19, 3.504), color: excitation),
    junction("ca1-out", at: (20.4, 0.35), color: excitation),
    junction("bic-out", at: (24.1, 0.65), color: inhibition),
  )
  let exc(source, target, ..options) = projection(source, target,
    color: excitation, target-gap: 0.07, ..options)
  let inh(source, target, ..options) = projection(source, target,
    color: inhibition, effect: "inhibitory", target-gap: 0.07, ..options)
  let trunk(source, target, ..options) = projection(source, target,
    color: excitation, effect: "unspecified", ..options)
  let connections = (
    trunk("gc.axon", "gc-out.center"),
    trunk("gc-out.center", "mf.center", via: ((2.9, -0.85), (10.3, -0.85))),
    exc("mf.center", "ca3-pc.proximal"),
    exc("mf.center", "ca3-in.dendrite-top", controls: ((10.3, 3.9), (8.8, 3.9))),
    exc("gc-out.center", "dg-bc.dendrite-left", controls: ((3.8, 0.35), (3.9, 2.4))),
    inh("dg-bc.axon", "gc.soma-east", controls: ((4.9, 1.0), (3.7, 1.95))),
    trunk("ca3-pc.axon", "ca3-out.center"),
    trunk("ca3-out.center", "sc.center", via: ((12, -1.25), (19, -1.25))),
    exc("sc.center", "ca1-pc.oblique-west"),
    exc("sc.center", "ca1-bc.dendrite", controls: ((18, 3.5),)),
    exc("ca3-out.center", "ca3-in.dendrite-right", controls: ((10.3, 0.35), (9.7, 2.5))),
    inh("ca3-in.axon", "ca3-pc.soma-west", controls: ((9.5, 1.0), (11.2, 1.95))),
    inh("ca1-bc.axon", "ca1-pc.soma-west", controls: ((18.8, 1.25), (19.6, 1.95))),
    trunk("ca1-pc.axon", "ca1-out.center"),
    exc("ca1-out.center", "ca1-bc.dendrite-4", controls: ((19.6, 0.35), (19, 2.58))),
    exc("ca1-out.center", "olm.dendrite", controls: ((19.4, 0.35), (18.2, 0.906))),
    inh("olm.axon", "ca1-pc.tuft-west", via: ((15.6, 0.514), (15.6, 5.65))),
    inh("aac.axon", "ca1-pc.ais", controls: ((22.7, 0.5), (20.4, 0.5))),
    projection("bic.axon", "bic-out.center", color: inhibition, effect: "unspecified"),
    inh("bic-out.center", "ca1-pc.oblique-east", controls: ((24.1, 4.8), (22.4, 4.8))),
    inh("bic-out.center", "ca1-pc.basal-east", controls: ((22.5, 0.65),)),
    exc("ca1-out.center", "bic.dendrite-1", via: ((26, 0.35), (26, 2.775))),
  )
  let populations = ()
  if inputs {
    populations = (
      population("ec2", [EC II], at: (2.9, 7.5), width: 1.4, height: 0.6,
        fill: white, color: excitation),
      population("ec3", [EC III], at: (20.4, 7.5), width: 1.4, height: 0.6,
        fill: white, color: excitation),
    )
    connections += (
      exc("ec2.south", "gc.tuft", dashed: true),
      exc("ec2.east", "ca3-pc.tuft-west", controls: ((8.4, 8.5), (11.3, 7)), dashed: true),
      exc("ec3.south", "ca1-pc.tuft", dashed: true),
    )
  }
  let annotations = (
    annotation((2.1, 1.95), [GC], anchor: "east", color: excitation),
    annotation((4.9, 3.55), [BC], color: inhibition),
    annotation((12.8, 1.95), [PC], anchor: "west", color: excitation),
    annotation((8.05, 1.95), [IN], anchor: "east", color: inhibition),
    annotation((21.2, 1.95), [PC], anchor: "west", color: excitation),
    annotation((17.45, 3.25), [BC], anchor: "east", color: inhibition),
    annotation((23, 3.2), [AAC], color: inhibition),
    annotation((25, 3.2), [BiC], color: inhibition),
    annotation((16.6, -0.45), [O-LM], color: inhibition),
    annotation((6.5, -1.5), [Mossy fibers], color: excitation),
    annotation((15.7, -1.9), [Schaffer collaterals], color: excitation),
    annotation((6, -2.7), [Excitatory], color: excitation),
    annotation((13, -2.7), [Inhibitory], color: inhibition),
    annotation((21, -2.7), [#box(circle(radius: 1.2pt, fill: excitation, stroke: none)) #h(1mm) Axon branch]),
  )
  (regions: regions, neurons: neurons, junctions: junctions,
    connections: connections, populations: populations, annotations: annotations)
}

#let microcircuit-figure(width: 240mm, inputs: true,
  excitation: rgb("b15e46"), inhibition: rgb("5069a0"),
  fills: (rgb("f4f4f4"), rgb("e5e5e5"), rgb("f0f0f0"), rgb("f7f7f7"), rgb("ededed"))) = circuit(
  ..microcircuit-scene(inputs: inputs, excitation: excitation, inhibition: inhibition, fills: fills),
  width: width, font-size: 10pt, line-width: 1pt,
)

#microcircuit-figure()
