#import "../lib.typ": diagram, block, group, link, annotation
#set page(width: auto, height: auto, margin: 5mm)
#set text(font: "Libertinus Sans")

// The reference model, unrolled in time. Feedback goes to the next step;
// no update equations or extra connections are assumed.
#let feedforward = rgb("2878a0")
#let feedback = rgb("b55b3c")
#let scene = (
  groups: range(3).map(t => group(label: [Step #str(t + 1)],
    at: (t * 4.5, 1.8), width: 3.1, height: 5.8, color: rgb("d2dce3"))),
  nodes: range(3).map(t => (
    block("input-" + str(t), [Input], at: (t * 4.5, 0), fill: rgb("fff0cd")),
    block("l1-" + str(t), [Layer 1], at: (t * 4.5, 1.8)),
    block("l2-" + str(t), [Layer 2], at: (t * 4.5, 3.6)),
  )).flatten(),
  connections: (
    ..range(3).map(t => (
      link("input-" + str(t) + ".north", "l1-" + str(t) + ".south", color: feedforward),
      link("l1-" + str(t) + ".north", "l2-" + str(t) + ".south", color: feedforward),
    )).flatten(),
    ..range(2).map(t => (
      link("l2-" + str(t) + ".east", "l1-" + str(t + 1) + ".west", color: feedback),
      link("l1-" + str(t) + ".east", "input-" + str(t + 1) + ".west", color: feedback),
    )).flatten(),
    link((-1.5, -1.45), (10.5, -1.45), color: rgb("536371")),
  ),
  annotations: (
    annotation((4.5, 5.2), [Hierarchical feedback across time], size: 12pt),
    annotation((4.5, -1.9), [Time / steps], size: 8pt),
    annotation((1.7, -2.55), [Feedforward · within step], color: feedforward),
    annotation((7.2, -2.55), [Feedback · next step], color: feedback),
  ),
)
#diagram(..scene, unit: 10mm, font-size: 10pt, width: 170mm)
