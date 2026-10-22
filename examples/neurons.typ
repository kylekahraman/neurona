#import "../lib.typ": neuron, circuit, annotation
#set page(width: auto, height: auto, margin: 6mm)
#set text(font: "Libertinus Sans", size: 9pt)

#let glyphs-figure(width: 105mm) = circuit(
  width: width,
  neurons: (
    neuron("p", at: (0, 0), apical: 2.6, basal: 0.8, spread: 0.65),
    neuron("g", at: (3.1, 0), kind: "granule", apical: 1.8,
      spread: 0.7, color: rgb("367c9e")),
    neuron("s", at: (6.2, 0.5), kind: "stellate", spread: 0.8,
      color: rgb("80639e")),
    neuron("h", at: (9.3, 0.5), kind: "horizontal", spread: 0.8,
      color: rgb("aa5c35")),
  ),
  annotations: (
    annotation((0, -1.3), [Pyramidal]),
    annotation((3.1, -1.3), [Granule]),
    annotation((6.2, -1.3), [Stellate]),
    annotation((9.3, -1.3), [Horizontal]),
  ),
)

#glyphs-figure()
