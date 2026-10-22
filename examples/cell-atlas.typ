#import "../lib.typ": neuron, projection, circuit, annotation
#set page(width: auto, height: auto, margin: 5mm)
#set text(font: "Libertinus Sans", size: 9pt)

#let atlas-figure(width: 125mm) = circuit(
  width: width,
  neurons: (
    neuron("p", at: (0, 4.3), apical: 2.0, basal: 0.65, spread: 0.7, color: rgb("286A78")),
    neuron("g", at: (3.8, 4.3), kind: "granule", apical: 1.65, spread: 0.7, color: rgb("467D66")),
    neuron("s", at: (7.6, 4.8), kind: "stellate", spread: 0.75, color: rgb("A26B35")),
    neuron("h", at: (0, 0), kind: "horizontal", spread: 0.9, color: rgb("A26B35")),
    neuron("b", at: (3.8, 0), kind: "basket", apical: 0.9, basal: 0.40, spread: 0.8, color: rgb("80518D")),
    neuron("v", at: (7.6, 0), kind: "bipolar", apical: 0.9, basal: 0.9, spread: 0.30, color: rgb("467D66")),
  ),
  annotations: (
    annotation((0, 3.0), [Pyramidal]), annotation((3.8, 3.0), [Granule]), annotation((7.6, 3.0), [Stellate]),
    annotation((0, -1.4), [Horizontal]), annotation((3.8, -1.4), [Basket-like]), annotation((7.6, -1.4), [Bipolar]),
  ),
)

#let targets-figure(width: 125mm) = circuit(
  width: width,
  neurons: (
    neuron("target", at: (5, 0), apical: 2.4, basal: 0.7, spread: 0.85, color: rgb("286A78")),
    neuron("bipolar", at: (10, 1), kind: "bipolar", apical: 0.9, basal: 0.9, spread: 0.30,
      color: rgb("467D66")),
  ),
  connections: (
    projection((0.5, 1.128), "target.apical", label: [Apical dendrite], color: rgb("286A78")),
    projection((0.5, -0.7), "target.basal", label: [Basal dendrite], color: rgb("A26B35")),
    projection("bipolar.axon", "target.soma-east", effect: "inhibitory", label: [Soma],
      color: rgb("80518D"), controls: ((8.7, 0), (6.8, 0))),
    projection((12.3, 1.0 + 0.9 * 0.65 / 0.89), "bipolar.dendrite-top",
      label: [Dendritic target], label-offset: (0.55, 0.15), color: rgb("A26B35")),
    projection("target.axon", (7.8, -1.5), via: ((5, -1.5),), effect: "unspecified", color: rgb("286A78")),
  ),
  annotations: (annotation((8.0, -1.5), [Axon output], anchor: "west"),),
)

#atlas-figure()
#pagebreak()
#targets-figure()
