#import "../lib.typ": circuit, region, cortical-layers, neuron, site
#set page(width: auto, height: auto, margin: 3mm)

#circuit(
  width: 60mm,
  regions: (
    region("ctx", cortical-layers(), width: 3.4),
  ),
  neurons: (
    neuron("pc", at: site("ctx", "l5", 1.7),
      apical: 2.2, basal: 0.75, spread: 0.52),
  ),
)
