/// Small authored topology recipes, independent of region and cell markers.
#import "cells.typ": neuron
#import "circuits.typ": circuit, population, projection, annotation

/// Return ordinary scene arguments for editing, extending or placing in a
/// larger figure: circuit(..motif-scene("feedforward"), width: 60mm).
#let motif-scene(kind, excitation: rgb("367c9e"), inhibition: rgb("aa5c35")) = {
  assert(kind in ("feedforward", "feedback", "disinhibition"), message: "Unknown circuit motif")
  let principal(at) = neuron("e", at: at, apical: 1.25, basal: 0.5,
    spread: 0.4, detail: "minimal", color: excitation)
  // Abstract inhibitory somata keep topology legible at small panel sizes.
  let inhibitory(id, at) = neuron(id, at: at, kind: "custom",
    color: inhibition, ports: (axon: (0, -0.13)))
  if kind == "feedback" {
    (
      populations: (population("input", [Input], at: (0, 0), width: 1, height: 0.6,
        fill: rgb("edf4f7"), color: excitation),),
      neurons: (principal((2.5, 0)), inhibitory("i", (5.1, 1.45)) + (ports: (axon: (0, 0.13)),)),
      connections: (
        projection("input.east", "e.soma-west", color: excitation, target-gap: 0.06),
        projection("e.axon", "i.soma-west", color: excitation,
          via: ((2.5, -0.95), (4.05, -0.95), (4.05, 1.45)), target-gap: 0.06),
        projection("i.axon", "e.tuft", effect: "inhibitory", color: inhibition,
          via: ((5.1, 2.3), (3.5, 2.3), (3.5, 1.25)), target-gap: 0.12),
      ),
      annotations: (annotation((2.5, -1.3), [E], color: excitation),
        annotation((5.8, 1.45), [I], color: inhibition)),
    )
  } else {
    let dis = kind == "disinhibition"
    let ex = if dis { 7.1 } else { 5.1 }
    let ix = if dis { 4.8 } else { 2.7 }
    let nodes = (principal((ex, 0)), inhibitory("i", (ix, 1.85)) +
      (ports: (axon: (0.23, 0)),))
    let edges = (
      projection("input.east", "e.soma-west", color: excitation, target-gap: 0.06),
      projection("i.axon", "e.apical", effect: "inhibitory", color: inhibition,
        target-gap: 0.22),
    )
    let labels = (annotation((ex, -0.95), [E], color: excitation),
      annotation((ix + 0.65, 2.15), if dis { [I#sub[2]] } else { [I] }, color: inhibition))
    if dis {
      nodes.push(inhibitory("i1", (1.8, 1.85)) + (ports: (axon: (0.23, 0)),))
      edges += (
        projection("input.north", "i1.soma-west", color: excitation,
          controls: ((0, 1.85), (0.8, 1.85)), target-gap: 0.06),
        projection("i1.axon", "i.soma-west", effect: "inhibitory", color: inhibition,
          target-gap: 0.12),
      )
      labels.push(annotation((1.8, 2.65), [I#sub[1]], color: inhibition))
    } else {
      edges.push(projection("input.north", "i.soma-west", color: excitation,
        controls: ((0, 1.85), (1.5, 1.85)), target-gap: 0.06))
    }
    (
      populations: (population("input", [Input], at: (0, 0), width: 1, height: 0.6,
        fill: rgb("edf4f7"), color: excitation),),
      neurons: nodes, connections: edges, annotations: labels,
    )
  }
}

/// One compact editable motif. No timing, firing rate or net gain is inferred.
#let motif(kind, width: 60mm, font-size: 9pt, line-width: 1pt,
  excitation: rgb("367c9e"), inhibition: rgb("aa5c35")) = circuit(
  ..motif-scene(kind, excitation: excitation, inhibition: inhibition),
  width: width, font-size: font-size, line-width: line-width,
)
