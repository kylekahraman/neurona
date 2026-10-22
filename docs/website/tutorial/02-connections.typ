#import "../lib.typ": circuit, neuron, projection
#set page(width: auto, height: auto, margin: 3mm)

#circuit(
  width: 100mm,
  neurons: (
    neuron("pc", at: (0, 0), label: [PC]),
    neuron("in", at: (3, 0), kind: "basket", label: [IN],
      color: rgb("bd674b")),
  ),
  connections: (
    projection("pc.axon", "in.soma-west",
      via: ((0, -1.6), (2, -1.6))),
    projection("in.axon", "pc.soma-east",
      effect: "inhibitory", color: rgb("bd674b"),
      via: ((3, -0.9), (1, -0.9)), target-gap: 0.07),
  ),
)
