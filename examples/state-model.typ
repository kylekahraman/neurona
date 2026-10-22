#import "../lib.typ": diagram, node, group, link, annotation
#set page(width: auto, height: auto, margin: 5mm)

// A generic state-space graphical model. These arrows express dependencies,
// without assuming a particular probability distribution or transition rule.
#diagram(
  nodes: (
    ..range(3).map(t => node("z" + str(t), $z_(#(t + 1))$, at: (t * 2.8, 1.8), fill: rgb("e3efdf"))),
    ..range(3).map(t => node("x" + str(t), $x_(#(t + 1))$, at: (t * 2.8, 0), fill: rgb("e5e4f5"))),
  ),
  groups: (group(label: [Latent dynamics], at: (2.8, 1.8), width: 7.2, height: 1.8),),
  connections: (
    ..range(2).map(t => link("z" + str(t) + ".east", "z" + str(t + 1) + ".west")),
    ..range(3).map(t => link("z" + str(t) + ".south", "x" + str(t) + ".north")),
  ),
  annotations: (annotation((2.8, -0.85), [Observations]),),
  font-size: 11pt, width: 125mm,
)
