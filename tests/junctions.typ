#import "../lib.typ": junction, region, band, site, circuit, projection
#import "../examples/hippocampal-microcircuit.typ": microcircuit-scene
#set page(width: auto, height: auto, margin: 3mm)

// A branch placed in a layer uses the same semantic coordinate transform as
// its cells. Both outgoing contacts originate at its named center anchor.
#circuit(
  regions: (region("r", (band("a", height: 2),), at: (3, 4), width: 4),),
  junctions: (junction("branch", at: site("r", "a", 1)),),
  connections: (
    projection((3, 4), "branch.center", effect: "unspecified"),
    projection("branch.center", (6, 4)),
    projection("branch.center", (6, 6), effect: "inhibitory"),
  ),
  width: 85mm,
)

// Exercise the reduced and input-inclusive compositions through the public
// renderer. Dropping external inputs must not remove intrinsic circuit data.
#let with-inputs = microcircuit-scene()
#let intrinsic = microcircuit-scene(inputs: false)
#assert.eq(with-inputs.neurons, intrinsic.neurons)
#assert.eq(with-inputs.junctions, intrinsic.junctions)
#for inputs in (true, false) {
  circuit(..microcircuit-scene(inputs: inputs), width: 180mm)
}
