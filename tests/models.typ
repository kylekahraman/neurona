#import "../lib.typ": diagram, block, node, model-layer, group, link, neuron, circuits
#import "../examples/feedback-model.typ": scene
#import "@preview/cetz:0.3.4"
#set page(width: auto, height: auto, margin: 5mm)

#let case = sys.inputs.at("case", default: "valid")
#if case == "valid" {
  // Acceptance graph: six within-step edges, four next-step edges, one time axis.
  assert.eq(scene.nodes.len(), 9)
  assert.eq(scene.connections.len(), 11)
  let edges = scene.connections.slice(0, 10).map(p => (p.source, p.target))
  assert.eq(edges, (
    ("input-0.east", "l1-0.west"), ("l1-0.east", "l2-0.west"),
    ("input-1.east", "l1-1.west"), ("l1-1.east", "l2-1.west"),
    ("input-2.east", "l1-2.west"), ("l1-2.east", "l2-2.west"),
    ("l2-0.south", "l1-1.north"), ("l1-0.south", "input-1.north"),
    ("l2-1.south", "l1-2.north"), ("l1-1.south", "input-2.north"),
  ))
  assert(scene.connections.all(p => p.effect == "directed"))
  assert.eq(link("a.east", "b.west", directed: false).effect, "unspecified")
  // Resolve actual renderer anchors, not just constructor dictionaries.
  cetz.canvas({
    circuits.draw-node(block("b", $x$, at: (3, 2), width: 4, height: 2, ports: (out: (2, 0.4))))
    circuits.draw-node(node("z", $z$, at: (8, 2), radius: 0.5))
    circuits.draw-node(model-layer("planes", at: (11, 2), width: 2, height: 3, planes: 3, offset: (0.2, 0.1), slant: 0.4))
    cetz.draw.get-ctx(ctx => {
      for (port, expected) in (("b.east", (5, 2)), ("b.north", (3, 3)),
        ("b.out", (5, 2.4)), ("z.west", (7.5, 2)),
        ("z.north-east", (8 + 0.5 * calc.sqrt(0.5), 2 + 0.5 * calc.sqrt(0.5))),
        ("planes.east", (12, 2.2)), ("planes.west", (9.6, 2)),
        ("planes.north", (10.6, 3.7)), ("planes.south", (11, 0.5))) {
        let (_, actual) = cetz.coordinate.resolve(ctx, port)
        for i in range(2) { assert(calc.abs(actual.at(i) - expected.at(i)) < 0.00001) }
      }
      ()
    })
  })
  diagram(..scene, width: 140mm)
  // Nodes can also be placed at layer sites, and coexist with biological cells.
  diagram(
    neurons: (neuron("cell", scale: 0.5),),
    nodes: (block("readout", [$y = C x$], at: (3, 0), ports: (input: (-1, 0.1))),),
    groups: (group(width: 6, height: 5, at: (1, 0)), group(width: 2.4, height: 1.5, at: (3, 0), dashed: true)),
    connections: (link("cell.soma-east", "readout.input", dashed: true, label: [$C$]),),
  )
  context {
    let s = (nodes: (node("x", $x$), block("f", $f(x)$, at: (3, 0))),
      connections: (link("x.east", "f.west"),))
    let actual = measure(diagram(..s, width: 85mm))
    assert(calc.abs(actual.width - 85mm) < 0.001pt)
  }
} else if case == "duplicate-model-id" {
  diagram(nodes: (node("x", $x$), block("x", $x$)))
} else if case == "mixed-duplicate-id" {
  diagram(neurons: (neuron("x"),), nodes: (node("x", $x$),))
} else if case == "invalid-model-port" {
  diagram(nodes: (node("x", $x$),), connections: (link("x.axon", (1, 1)),))
} else if case == "shadowed-model-port" {
  diagram(nodes: (block("x", $x$, ports: (east: (2, 0))),))
} else if case == "dotted-model-port" {
  diagram(nodes: (block("x", $x$, ports: ("port.name": (2, 0))),))
} else if case == "negative-node-size" {
  diagram(nodes: (node("x", $x$, radius: -1),))
} else if case == "negative-group-size" {
  diagram(groups: (group(width: -1),))
} else if case == "conflicting-model-route" {
  diagram(connections: (link((0, 0), (1, 1), via: ((1, 0),), controls: ((0, 1),)),))
} else if case == "invalid-plane-count" {
  diagram(nodes: (model-layer("x", planes: 0),))
} else if case == "invalid-layer-grid" {
  diagram(nodes: (model-layer("x", grid: (0, 4)),))
} else if case == "invalid-layer-offset" {
  diagram(nodes: (model-layer("x", offset: (-0.1, 0.1)),))
} else { panic("Unknown test case") }
