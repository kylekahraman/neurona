/// Original schematic drawing recipes for rodent CA1 interneuron domains.
/// Sources, anatomical scope and omitted detail: docs/cell-recipes.md.
/// Geometry is cell-relative and is never fitted to a region automatically.
#import "cells.typ": neuron, neurite

/// All recipes use the ordinary neuron record and scene renderer. The axon
/// arbor is optional for circuit motifs; its source port always stays fixed.
#let interneuron(
  id, kind: "basket", at: (0, 0), scale: 1, orientation: 0deg,
  color: rgb("80639e"), dendrite-color: rgb("667b87"),
  label: none, label-offset: (0.4, 0.3), arbor: true,
) = {
  assert(kind in ("basket", "axo-axonic", "bistratified", "olm"),
    message: "Unknown interneuron recipe")
  let dendrites = if kind == "olm" {
    (
      neurite(((-1.15, 0.08), (0, 0), (1.15, 0.08))),
      neurite(((-0.65, 0.045), (-0.95, 0.32), (-1.3, 0.4))),
      neurite(((0.65, 0.045), (0.95, -0.25), (1.35, -0.28))),
    )
  } else {
    (
      neurite(((0, 0), (-0.08, 0.75), (-0.38, 1.5))),
      neurite(((-0.08, 0.75), (0.28, 1.15), (0.48, 1.5))),
      neurite(((0, 0), (-0.5, 0.6), (-0.9, 1.1))),
      neurite(((-0.5, 0.6), (-0.92, 0.65), (-1.12, 0.85))),
      neurite(((0, 0), (0.55, 0.55), (0.9, 1.05))),
      neurite(((0.55, 0.55), (1.05, 0.55), (1.25, 0.78))),
      neurite(((0, 0), (-0.55, -0.48), (-0.9, -0.8))),
      neurite(((0, 0), (0.55, -0.48), (0.9, -0.8))),
    )
  }
  dendrites = dendrites.map(d => d + (color: dendrite-color, thickness: 1.1))
  let axons = (neurite(((0, -0.12), (0, -0.48)), thickness: 0.75),)
  if arbor {
    axons = (neurite(if kind == "olm" { ((0, 0.13), (0, 0.48)) }
      else { ((0.23, 0), (0.48, 0)) }, thickness: 0.75),)
    if kind == "basket" {
      axons += (
        neurite(((0.48, 0), (2.7, 0)), thickness: 0.7),
      )
      for x in (1.2, 1.9, 2.6) {
        for side in (-1, 1) {
          axons.push(neurite(((x - 0.2, 0), (x + 0.15, side * 0.17)),
            controls: ((x - 0.12, side * 0.17),),
            boutons: ((x - 0.0725, side * 0.1275), (x + 0.15, side * 0.17)), thickness: 0.7))
        }
      }
    } else if kind == "axo-axonic" {
      axons.push(neurite(((0.48, 0), (1.5, 0), (1.5, -0.48), (2.7, -0.48)), thickness: 0.7))
      for x in (1.5, 2.0, 2.5) {
        axons.push(neurite(((x, -0.48), (x, -1.05)),
          boutons: ((x, -0.62), (x, -0.8), (x, -0.98)), thickness: 0.7))
      }
    } else if kind == "bistratified" {
      axons.push(neurite(((0.48, 0), (1.6, 0), (1.6, 1.1)), thickness: 0.7))
      for y in (-0.7, 0.65, 1.1) {
        axons.push(neurite(((1.6, y), (2.75, y)),
          boutons: ((1.7, y), (2.0, y), (2.3, y), (2.65, y)), thickness: 0.7))
        axons.push(neurite(((1.6, y), (1.6, 0)), thickness: 0.7))
      }
    } else {
      axons.push(neurite(((0, 0.48), (0, 2.65)), thickness: 0.7))
      axons.push(neurite(((-0.4, 2.65), (2.7, 2.65)), thickness: 0.7))
      for x in (0, 0.75, 1.5, 2.35) {
        axons.push(neurite(((x, 2.65), (x + 0.2, 2.85)),
          boutons: ((x + 0.1, 2.75), (x + 0.2, 2.85)), thickness: 0.7))
        axons.push(neurite(((x, 2.65), (x + 0.3, 2.4)),
          boutons: ((x + 0.15, 2.525), (x + 0.3, 2.4)), thickness: 0.7))
      }
    }
  }
  neuron(id, at: at, kind: "custom", scale: scale, orientation: orientation,
    color: color, label: label, label-offset: label-offset,
    dendrites: dendrites, axons: axons,
    ports: (axon: if not arbor { (0, -0.48) } else if kind == "olm" { (0, 0.48) } else { (0.48, 0) },
      dendrite: if kind == "olm" { (1.15, 0.08) } else { (-0.38, 1.5) }),
  ) + (recipe: kind, anatomical-context: "rodent CA1 schematic")
}
