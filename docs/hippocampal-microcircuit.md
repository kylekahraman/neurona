# First multiregion microcircuit

`examples/hippocampal-microcircuit.typ` is a reduced, original schematic composition inspired by the supplied Figure 7.1B from *The Hippocampus Book*, second edition. It is page 9 of `examples/illustrations.pdf`. The first eight pages retain the current layout/terminal-clearance corrections.

## Implemented composition

The example contains independent DG, CA3 and CA1 layer stacks and nine cell glyphs. It combines selected long-range excitation with local feedforward/feedback motifs. Grey layers demonstrate that fills do not depend on cell colors. Red identifies the selected excitatory pathways; blue identifies inhibitory cells/outputs. These colors are author choices, not molecular markers.

| Region | Drawn cells | Selected pathways |
| --- | --- | --- |
| DG | One granule cell (GC), one schematic basket cell (BC) | GC -> BC -> GC feedback; mossy-fiber output to CA3 |
| CA3 | One pyramidal cell (PC), one generic inhibitory interneuron (IN) | Mossy-fiber excitation of PC and IN; local PC -> IN -> PC feedback; Schaffer output to CA1 |
| CA1 | One PC, BC, axo-axonic cell (AAC), bistratified cell (BiC), O-LM cell | Schaffer excitation of PC and BC; selected PC feedback to BC/BiC/O-LM; inhibition of soma, AIS, basal/apical dendrites and distal tuft |

External EC II and EC III boxes can be shown or hidden. Dashed routes distinguish these selected external inputs from intrinsic pathways; dashed lines do not denote uncertain evidence. All heights, arbor geometry, contact positions and routes are illustration parameters. The long-range routes below the panels emphasize topology and do not claim that axons follow those anatomical trajectories.

The CA3 `IN` is deliberately generic: its multipolar glyph does not identify a molecular or morphological subtype. CA1 recipe context is not silently applied to DG/CA3 cells. A generic dendritic anchor indicates an authored target on the drawn glyph, not a measured contact location. A single displayed PC represents a cell-class motif, rather than evidence that every reciprocal contact was demonstrated on the same recorded pair.

## Editable source

```typst
#import "examples/hippocampal-microcircuit.typ": microcircuit-scene
#import "lib.typ": circuit
#let scene = microcircuit-scene(inputs: false)
#circuit(..scene, width: 180mm)
```

`microcircuit-figure(width:, inputs:, excitation:, inhibition:, fills:)` renders the scene directly. `microcircuit-scene` exposes the ordinary region/cell/junction/connection/annotation records for modification. Its five `fills` are bottom-to-top grey tones mapped onto the corresponding regional band groups; individual band dictionaries remain editable for independent layer colors. Changing layer heights requires reviewing geometry and explicitly routed waypoints. No automatic collision avoidance is implied.

## Axon branches

The new `junction(id, at:, radius:, color:)` scene record marks an explicit branch point of one axon. Pass these in `circuit(junctions: (...))` and address `"id.center"` from projections. A common unmarked stem can then divide into two marked terminal branches. Sites are accepted for layer-relative placement, and IDs share the cell/population namespace. Junction dots are not additional neurons or inferred synapses; crossings without a dot do not establish a connection.

## Scope still missing from Figure 7.1B

This is a first composition, not a reproduction of the full reference. It omits dentate mossy cells and most dentate interneuron classes, most CA3 interneuron classes, and CA1 NGFC/Ivy/PPA/SCA/ISI/TL classes. Recurrent principal-cell excitation, the complete afferent set and interneuron-to-interneuron connectivity are not yet represented. The AAC has a selected output but no depicted excitation source. Feedforward/feedback roles are represented by the selected paths rather than claiming the reference's full classification for every subtype.

## Evidence and reference context

The supplied textbook Figure 7.1B is the visual and topological starting point. Primary sources support the selected circuit vocabulary; none supplies the illustrative coordinates:

- Geiger et al. (1997), *Submillisecond AMPA receptor-mediated signaling at a principal neuron–interneuron synapse*, Neuron 18, 1009–1023. [doi:10.1016/S0896-6273(00)80339-6](https://doi.org/10.1016/S0896-6273(00)80339-6). Rat principal-cell/interneuron excitation; the DG granule/basket motif is also present in the supplied reference.
- Torborg et al. (2010), *Control of CA3 output by feedforward inhibition despite developmental changes in the excitation-inhibition balance*. [PubMed](https://pubmed.ncbi.nlm.nih.gov/21084618/), [full text](https://pmc.ncbi.nlm.nih.gov/articles/PMC3023412/). Mossy-fiber excitation of PCs and inhibitory interneurons; the example does not infer a specific CA3 IN subtype from this evidence.
- Miles and Wong (1984), *Unitary inhibitory synaptic potentials in the guinea-pig hippocampus in vitro*. [PubMed](https://pubmed.ncbi.nlm.nih.gov/6097680/). Primary evidence for recurrent inhibitory motifs; species context differs from the rodent CA1 drawing recipes.
- Ali et al. (1998), *CA1 pyramidal to basket and bistratified cell EPSPs: dual intracellular recordings in rat hippocampal slices*. [doi:10.1111/j.1469-7793.1998.201bu.x](https://doi.org/10.1111/j.1469-7793.1998.201bu.x). CA1 PC excitation of basket and bistratified interneurons.
- Wierenga and Wadman (2003), *Excitatory Inputs to CA1 Interneurons Show Selective Synaptic Dynamics*. [doi:10.1152/jn.00865.2002](https://doi.org/10.1152/jn.00865.2002). Schaffer feedforward and local feedback excitation of CA1 interneurons.
- *Action Potential Modulation in CA1 Pyramidal Neuron Axons Facilitates OLM Interneuron Activation in Recurrent Inhibitory Microcircuits of Rat Hippocampus* (2014). [doi:10.1371/journal.pone.0113124](https://doi.org/10.1371/journal.pone.0113124). Paired PC/O-LM recordings.

The compartment-selective inhibitory outputs and the interpretation of named strata retain the [cell-recipe sources](cell-recipes.md) and [initial pathway sources](visual-references.md).
