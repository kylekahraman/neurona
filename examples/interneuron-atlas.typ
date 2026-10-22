#import "../lib.typ": interneuron, band, region, site, circuit, annotation
#set page(width: auto, height: auto, margin: 2mm)
#set text(font: "Libertinus Sans", size: 9pt)

// Independent CA1 schematic domain panels; sources in docs/cell-recipes.md.
#let atlas-figure(width: 180mm) = {
  let names = ([Basket], [Axo-axonic], [Bistratified], [O-LM])
  let kinds = ("basket", "axo-axonic", "bistratified", "olm")
  let colors = (rgb("367c9e"), rgb("408b74"), rgb("80639e"), rgb("aa5c35"))
  let regions = ()
  let neurons = ()
  let annotations = ()
  for (i, kind) in kinds.enumerate() {
    let id = "panel" + str(i)
    let x = i * 5.15
    regions.push(region(id, (
      band("so", label: [SO], height: 0.9, fill: rgb("edf2ef")),
      band("sp", label: [SP], height: 0.4, fill: rgb("dfe8e5")),
      band("sr", label: [SR], height: 1.4, fill: rgb("f2f5f8")),
      band("slm", label: [SLM], height: 0.9, fill: rgb("e5edf4")),
    ), at: (x, 0), width: 4.5, show-layer-labels: i == 0))
    neurons.push(interneuron(kind, kind: kind,
      at: site(id, if kind == "olm" { "so" } else { "sp" }, 1.4),
      color: colors.at(i)))
    annotations.push(annotation((x + 2.25, -0.48), names.at(i), color: colors.at(i)))
  }
  annotations += (
    annotation((4, -1.2), [Gray: dendrites], color: rgb("667b87")),
    annotation((10, -1.2), [Color: soma + axon]),
    annotation((16, -1.2), [#box(circle(radius: 1.2pt, fill: rgb("667b87"), stroke: none)) #h(1mm) Bouton]),
  )
  circuit(regions: regions, neurons: neurons, annotations: annotations,
    width: width, font-size: 10pt, line-width: 0.95pt)
}

#atlas-figure()
