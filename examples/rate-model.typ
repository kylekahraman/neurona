#import "../lib.typ": diagram, block, link, annotation
#set page(width: auto, height: auto, margin: 5mm)

// A rate-model illustration with explicitly authored recurrent routing.
#diagram(
  nodes: (
    block("input", $u(t)$, at: (0, 0), width: 1.3, fill: rgb("fff0cd")),
    block("state", $tau dot(x) = -x + phi(W x + u)$, at: (4, 0), width: 5.2, height: 1.2),
    block("output", $y = C x$, at: (8.2, 0), width: 1.7),
  ),
  connections: (
    link("input.east", "state.west"),
    link("state.east", "output.west"),
    link("state.north-east", "state.north-west", controls: ((6.4, 2.1), (1.6, 2.1)),
      label: [Recurrent state], color: rgb("b55b3c")),
  ),
  annotations: (annotation((4, -1.15), [Continuous-time rate model]),),
  width: 155mm, font-size: 10pt,
)
