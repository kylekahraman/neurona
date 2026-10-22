#import "../lib.typ": circuit, neuron, projection
#set page(width: auto, height: auto, margin: 3mm)

#circuit(
  width: 100mm,
  neurons: (
    neuron("pc", at: (0, 0), label: [PC], axon-origin: "left"),
    neuron("in", at: (4, 0), kind: "basket", label: [IN], axon-origin: "left",
      color: rgb("bd674b")),
  ),
  connections: (
    projection("pc.axon", "in.soma-east",
      via: ((-1.2, 0), (-1.2, -1.8), (5.2, -1.8), (5.2, 0)),
      target-gap: 0.10),
    projection("in.axon", "pc.soma-east",
      effect: "inhibitory", color: rgb("bd674b"),
      target-gap: 0.10),
  ),
)
