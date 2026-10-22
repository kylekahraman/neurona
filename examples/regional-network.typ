#import "../lib.typ": population, projection, circuit
#set page(width: auto, height: auto, margin: 2mm)
#set text(font: "Libertinus Sans", size: 9pt)

// Selected canonical regional pathways; layout adapted in spirit, not copied,
// from the serial/parallel organization illustrated in Fig. 3.57.
#let network-figure(width: 85mm) = {
  let major = rgb("344c66")
  let direct = rgb("788995")
  circuit(width: width, font-size: 10pt, line-width: 1pt,
    populations: (
      population("ec", [EC], at: (0, 1.6), width: 1.35, fill: rgb("e5eef6")),
      population("dg", [DG], at: (3.2, 3.2), width: 1.35, fill: rgb("e3eee4")),
      population("ca3", [CA3], at: (6.4, 3.2), width: 1.35, fill: rgb("f3e8d8")),
      population("ca1", [CA1], at: (6.4, 1.6), width: 1.35, fill: rgb("e5edf4")),
      population("sub", [Sub], at: (3.2, 0), width: 1.35, fill: rgb("eee2e5")),
    ),
    connections: (
      // Shared north exit: draw the thinner long route before the main trunk.
      projection("ec.north", "ca3.north", color: direct,
        via: ((0, 4.4), (6.4, 4.4)), weight: 0.9),
      projection("ec.north", "dg.west", color: major, via: ((0, 3.2),), weight: 1.6),
      projection("dg.east", "ca3.west", color: major, weight: 1.6),
      projection("ca3.south", "ca1.north", color: major, weight: 1.6),
      projection("ca1.south", "sub.east", color: major, via: ((6.4, 0),), weight: 1.6),
      projection("sub.west", "ec.south", color: major, via: ((0, 0),), weight: 1.6),
      projection("ec.east", "ca1.west", color: direct, weight: 0.9),
    ),
  )
}

#network-figure()
