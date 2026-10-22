#import "../lib.typ": circuit, neuron, neurite
#set page(width: auto, height: auto, margin: 3mm)

#circuit(
  width: 60mm,
  neurons: (
    neuron("custom", kind: "custom", label: [My cell],
      dendrites: (
        neurite(((0, 0), (0, 2))),
        neurite(((0, 1), (-0.8, 1.8))),
        neurite(((0, 1.4), (0.8, 2.2))),
      ),
      axons: (neurite(((0, 0), (0, -1)),
        color: rgb("bd674b")),),
    ),
  ),
)
