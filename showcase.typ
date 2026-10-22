#import "lib.typ": paradigm, stage
#import "examples/cortical-layers.typ": layers-figure
#import "examples/hippocampal-pathways.typ": pathways-figure
#import "examples/hippocampal-layers.typ": ca1-figure
#import "examples/regional-network.typ": network-figure
#import "examples/interneuron-atlas.typ": atlas-figure
#import "examples/compartment-targets.typ": targets-figure
#import "examples/circuit-motifs.typ": motifs-figure
#import "examples/hippocampal-microcircuit.typ": microcircuit-figure

#set page(width: 300mm, height: auto, margin: 12mm, fill: rgb("f6f8f7"))
#set text(font: "Inter", size: 9pt, fill: rgb("243b4a"))
#set par(leading: 0.55em)

#let muted = rgb("6b7f89")
#let accent = rgb("408b74")
#let card(number, title, body, height: 90mm) = block(
  width: 100%, height: height, inset: 5mm, radius: 3mm,
  fill: white, stroke: 0.5pt + rgb("dce4df"),
)[
  #text(size: 8.2pt, weight: "semibold", fill: accent)[#number]
  #h(2mm)
  #text(size: 9pt, weight: "semibold")[#title]
  #v(5mm)
  #align(center, body)
]

#grid(columns: (1fr, auto), align: horizon,
  text(size: 31pt, weight: "bold", tracking: -0.7pt)[neurona],
  text(size: 7.5pt, weight: "semibold", fill: muted)[DEVELOPMENT PREVIEW],
)
#v(6mm)

#grid(columns: (1fr, 1fr), gutter: 6mm,
  card("01", [Layers & compartments], layers-figure(width: 113mm, legend: false)),
  card("02", [Laminar circuits], ca1-figure(width: 105mm, legend: true)),
  card("03", [Across regions], pathways-figure(width: 123mm), height: 75mm),
  card("04", [Regional flow], network-figure(width: 84mm), height: 75mm),
  card("05", [Interneuron territories], atlas-figure(width: 123mm), height: 70mm),
  card("06", [Compartment-specific targets], targets-figure(width: 112mm), height: 70mm),
  card("07", [Circuit motifs], motifs-figure(width: 123mm), height: 55mm),
  card("08", [Experimental paradigms], {
    v(4mm)
    paradigm((
      stage("Fixation", duration: "500 ms", display: [+]),
      stage("Target", duration: "17 ms", display: line(length: 6mm, angle: 35deg, stroke: 1.5pt + accent)),
      stage("Delay", duration: "1.5 s", display: [+]),
      stage("Report", duration: "2 s", display: [?]),
    ), stage-width: 2.8, stage-height: 1.2, gap: -0.3,
      font-size: 8.5pt, fill: rgb("f4f7f5"), stroke: rgb("446173"))
  }, height: 55mm),
  grid.cell(colspan: 2,
    card("09", [Multiregion microcircuit], microcircuit-figure(width: 260mm, inputs: false), height: 115mm)),
)
