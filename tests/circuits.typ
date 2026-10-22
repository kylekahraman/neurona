#import "../lib.typ": band, region, site, cortical-layers, layer-legend, neuron, neurite, population, projection, circuit, annotation, layers, cells, junction
#import "@preview/cetz:0.3.4"
#set page(width: auto, height: auto, margin: 5mm)

#let regions = (
  region("a", (band("lower", height: 2), band("upper", height: 3)), at: (2, 3), width: 6),
  region("b", (band("upper", height: 1),), at: (11, 0), width: 3),
)
// A shared layer name has different geometry in each region. Check translation
// and bottom/top semantics independently of the figure's visual appearance.
#assert.eq(layers.resolve-site(site("a", "upper", 1, depth: 0), regions), (3, 5))
#assert.eq(layers.resolve-site(site("a", "upper", 1, depth: 1), regions), (3, 8))
#assert.eq(layers.resolve-site(site("b", "upper", 1, depth: 0.5), regions), (12, 0.5))

// Numbering is presentation only. Both schemes must preserve the same sites,
// with anatomical layer I at the top even when supplied heights are unequal.
#let roman = region("ctx", cortical-layers(heights: (1, 2, 3, 4, 5, 6)), width: 3)
#let arabic = region("ctx", cortical-layers(numbering: "arabic", heights: (1, 2, 3, 4, 5, 6)), width: 3)
#assert.eq(roman.bands.map(b => b.id), ("l6", "l5", "l4", "l3", "l2", "l1"))
#assert.eq(roman.bands.map(b => b.label), ("VI", "V", "IV", "III", "II", "I"))
#assert.eq(arabic.bands.map(b => b.label), ("6", "5", "4", "3", "2", "1"))
#for i in range(1, 7) {
  assert.eq(layers.resolve-site(site("ctx", "l" + str(i), 1), (roman,)),
    layers.resolve-site(site("ctx", "l" + str(i), 1), (arabic,)))
}
#assert.eq(layers.resolve-site(site("ctx", "l1", 1, depth: 1), (roman,)), (1, 21))
#assert.eq(layers.resolve-site(site("ctx", "l6", 1, depth: 0), (roman,)), (1, 0))

#let case = sys.inputs.at("case", default: "valid")
#if case == "valid" {
  // Check actual CeTZ anchors after cell translation and scaling, so a connector
  // cannot silently miss its compartment when a glyph changes size.
  cetz.canvas({
    cells.draw-neuron(neuron("scaled", at: (3, 2), apical: 1.5, scale: 2))
    cetz.draw.get-ctx(ctx => {
      let (_, soma) = cetz.coordinate.resolve(ctx, "scaled.soma")
      let (_, apical) = cetz.coordinate.resolve(ctx, "scaled.apical")
      let (_, tuft) = cetz.coordinate.resolve(ctx, "scaled.tuft-west")
      for (actual, expected) in ((soma, (3, 2)), (apical, (3, 3.41)), (tuft, (1.506, 5))) {
        for i in range(2) { assert(calc.abs(actual.at(i) - expected.at(i)) < 0.00001) }
      }
      ()
    })
  })
  // Custom branches and ports share the same scaled, rotated coordinate frame.
  cetz.canvas({
    cells.draw-neuron(neuron("custom", kind: "custom", at: (2, 3), scale: 2, orientation: 90deg,
      dendrites: (neurite(((0, 0), (1, 1))),),
      axons: (neurite(((0, 0), (-0.5, -1)), boutons: ((-0.5, -1),)),),
      ports: (tip: (0, 2))))
    cetz.draw.get-ctx(ctx => {
      for (port, expected) in (("custom.dendrite-0", (0, 5)),
        ("custom.axon-0", (4, 2)), ("custom.tip", (-2, 3))) {
        let (_, actual) = cetz.coordinate.resolve(ctx, port)
        for i in range(2) { assert(calc.abs(actual.at(i) - expected.at(i)) < 0.00001) }
      }
      ()
    })
  })
  context {
    let scene = (
      populations: (population("source", [Source]), population("target", [Target], at: (3, 1))),
      connections: (projection("source.east", "target.west"),),
    )
    let natural = measure(circuit(..scene))
    for target in (45mm, 85mm, 125mm) {
      let fitted = measure(circuit(..scene, width: target))
      assert(calc.abs(fitted.width - target) < 0.001pt, message: "Requested figure width is not honored")
      assert(calc.abs(fitted.height - natural.height * (target / natural.width)) < 0.001pt,
        message: "Fitting must preserve aspect ratio")
    }
    let r = region("ctx", cortical-layers(), width: 3)
    let plain = measure(circuit(regions: (r,), width: 85mm))
    let keyed = measure(circuit(regions: (r,), width: 85mm, legend: true))
    assert(calc.abs(keyed.width - 85mm) < 0.001pt)
    assert(keyed.height > plain.height, message: "The optional legend must be included in layout")
  }
  layer-legend((roman, arabic), columns: 2)
  circuit(
    regions: regions,
    neurons: (neuron("pc", at: site("a", "lower", 2), scale: 0.5, label: [PC]),
      neuron("in", at: site("b", "upper", 1), kind: "stellate", scale: 0.5)),
    connections: (
      projection("in.axon", "pc.soma-east", effect: "inhibitory", controls: ((9, 1), (8, 4)), label: [I]),
      projection("pc.axon", "in.dendrite", effect: "unspecified", dashed: true, via: ((8, 1),)),
      projection(site("a", "upper", 0.5), "pc.apical", label: [E], controls: ((2, 7),)),
    ),
    annotations: (annotation(site("b", "upper", 2), [B], anchor: "west"),),
  )
} else if case == "unknown-layer" {
  circuit(regions: regions, neurons: (neuron("pc", at: site("a", "missing", 1)),))
} else if case == "unknown-target" {
  circuit(neurons: (neuron("pc"),), connections: (projection("pc.axon", "missing.soma"),))
} else if case == "wrong-compartment" {
  circuit(neurons: (neuron("i", kind: "stellate"),), connections: (projection((0, 1), "i.apical"),))
} else if case == "duplicate-region" {
  circuit(regions: (regions.first(), regions.first()))
} else if case == "conflicting-route" {
  circuit(connections: (projection((0, 0), (1, 1), via: ((1, 0),), controls: ((0, 1),)),))
} else if case == "zero-width" {
  circuit(width: 0mm, populations: (population("p", [P]),))
} else if case == "duplicate-element" {
  circuit(neurons: (neuron("same"),), populations: (population("same", [P]),))
} else if case == "shadowed-port" {
  circuit(neurons: (neuron("p", kind: "custom", ports: (soma: (1, 1))),))
} else if case == "incomplete-cortex" {
  circuit(regions: (region("ctx", cortical-layers(heights: (1, 2, 3))),))
} else if case == "invalid-legend-columns" {
  circuit(regions: regions, legend: true, legend-columns: 0)
} else if case == "duplicate-junction" {
  circuit(neurons: (neuron("same"),), junctions: (junction("same"),))
} else if case == "wrong-junction-port" {
  circuit(junctions: (junction("j"),), connections: (projection((0, 1), "j.soma"),))
} else { panic("Unknown test case") }
