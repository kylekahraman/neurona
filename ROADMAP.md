# neurona roadmap

A composable toolkit for neuroscience illustrations in Typst: one scene renderer, coordinate model, styling system and set of anchors, shared across cells, layers, circuits and illustrative signals.

See [reference classes](docs/reference-classes.md) for the reviewed examples and [open illustration candidates](docs/open-assets.md) for potential external SVG assets. A compiled [showcase](showcase.png) and its [editable source](showcase.typ) live in the repository root.

| Stage | Scope | Status |
| --- | --- | --- |
| Foundation | Experimental timelines; schematic cells; custom neurites and boutons; independent regional layers; explicit projections; population boxes; exact output width; rotation and minimal detail; I-VI labels and optional layer legends | Implemented |
| 1. Cell illustration presets | Basket, axo-axonic, bistratified and O-LM domain recipes with sources; optional axon territories and CA1 target-compartment example | Initial four recipes implemented; expand regional coverage next |
| 2. Local motifs and interventions | Editable feedforward inhibition, feedback inhibition and disinhibition scenes | Three motifs implemented; recurrence, electrical coupling and intervention comparisons next |
| 3. Illustrative electrophysiology | Procedural schematic traces, spike marks and oscillation panels | Next |
| 4. Anatomical geometry | Curved layers, anatomical region outlines, local orientation, later perspective blocks and routing assistance | Later |
| 5. Detailed morphology and drawings | Adapters for SWC reconstructions, digital tracings and attributed vector drawings, using the existing cell/anchor model | Later |
| 6. Synaptic detail | Boutons, spines, shafts, multiple contacts and zoomed terminal drawings | Later |
| 7. Brain templates | Human/mouse 2D templates with species/view metadata and region anchors; atlas-aligned or true 3D anatomy is a further stage | Long-term / optional |

## Next illustration targets

Author controls for dendrite replacement/counts and label/connection clearance remain priorities while prototyping denser figures. Explicit shared axon branching is now supported by named `junction` records. Built-in branch counts and the current interneuron dendritic recipes are still fixed; custom paths/record edits supply arbitrary shapes. Routing and collision avoidance are manual.

Prioritize Figure 7.1B as the design reference for a compact multi-region laminar microcircuit: independent DG/CA3/CA1 layer stacks, distinct soma/dendrite/axon territories, and explicit contacts on named target compartments. Build this from the common cell presets and projection primitives. Keep references, species context and biological scope in accompanying documentation rather than adding prose to the figure.

A first selected nine-cell [multiregion microcircuit](examples/hippocampal-microcircuit.typ) is implemented and included on page 9 of the illustration gallery and in the showcase. It includes local feedback, selected feedforward inhibition, mossy fibers, Schaffer collaterals, optional EC II/III inputs and explicit axon junctions. Most interneuron classes from the reference and recurrent principal-cell excitation remain to be added; see [scope and sources](docs/hippocampal-microcircuit.md).

Pair this with the regional overview suggested by Figure 7.1A: parallel pathways, recurrent projections and distinct input/output channels, with optional emphasis of one selected route. These are complementary views of an explicitly authored circuit, not automatic conversion between a region box and an inferred cellular connectome.

Compact comparison panels for feedforward inhibition, feedback inhibition and disinhibition, an atlas of basket/axo-axonic/bistratified/O-LM domains and a CA1 target-compartment diagram are implemented and included in the showcase. Sources and recipe geometry are documented in [cell recipes](docs/cell-recipes.md). Their first multiregion composition is now available; next expand its cell/pathway coverage and add schematic spike/EPSP/IPSP strips. The current showcase does not yet implement the full complexity of Figure 7.1.

## Cell illustration library

Start with regional pyramidal cells, dentate granule cells, basket cells, axo-axonic cells, bistratified cells, O-LM cells and neurogliaform-like cells. These are schematic illustration presets, not a new exhaustive biological taxonomy. The supplied reference figures are sufficient to start; the user does not need to obtain a dataset for these presets.

A recipe specifies soma/dendrite/axon geometry, named compartments and optional layer placement. Molecular labels, transmitter labels, colors and projection targets remain independently configurable. A generic shape alone does not establish biological identity. Curated anatomical recipes require references, species/region context and a statement of omitted details. Selecting a cell preset must not automatically invent connections to other cells.

Deliverable: an atlas of compact editable cell illustrations. Figures 3.18, 3.29 and 5.33 motivate the range of visual forms.

## Circuit motifs and interventions

Compose motif recipes from the same neurons, populations and projections. Add gap-junction symbols, explicit branch/junction markers and additional synaptic terminal styles. Baseline/perturbed comparisons should change individual objects' visual properties (visibility, opacity, emphasis), keeping the rest of the scene consistent. References: Figures 7.2, 7.10, 5.33A and the supplied optogenetic/pharmacological comparison panels.

## Illustrative electrophysiology

Generate shapes procedurally to explain what activity can look like:

- Single action potentials, afterhyperpolarization shapes, regular spike trains, bursts and spike-frequency adaptation.
- EPSP/IPSP-like transients, rise/decay envelopes, repeated responses and illustrative depression/facilitation sequences.
- Oscillations, phase-positioned spike marks, current pulses, event markers and scale bars.

Expose drawing parameters such as onset, duration, amplitude, rise/decay times, interspike interval, burst spacing and phase. Start with analytic/stylized shapes and deterministic sequences; no physiological simulation engine is required. Units and scale bars, when shown, follow the illustrative parameters supplied by the author.

Measured electrophysiology ingestion and experimental-data analysis are outside the current scope. Schematic traces are not presented as measured recordings or validated biophysical simulations. Figures 5.4, 5.40 and 7.4 motivate this drawing vocabulary without requiring their original recordings. Deliverable: compact signal strips and insets composable with cells and circuits.

## Detailed geometry and morphology

Curved region outlines and layer coordinates should allow a cell to follow local anatomical orientation. Add perspective blocks once flat/curved layouts are reliable. Detailed cells can later enter through reconstruction data (e.g. SWC), user-created digital tracings or attributed vector drawings; preserve source identity, scale and the distinction between reconstructed and schematic geometry. Evaluate an adapter to an existing morphology renderer such as Axodendron before building another parser/renderer.

A reconstruction does not establish synaptic connectivity. Do not fabricate missing processes or contacts. Alternate faithful camera views require 3D morphology; a screenshot alone does not recover that geometry. Figures 3.23 and the supplied single/compound synaptic-contact panel additionally need bouton/spine geometry, beyond the simple terminal markers already available.

Whole-brain templates remain optional and do not block useful cell, layer and circuit illustrations.

## Completion criteria

- Compact examples use shared primitives and retain editable parameters; illustration outputs contain diagram labels and optional legends, with references kept in documentation.
- Existing examples continue to compile, geometry-sensitive changes preserve anchors and output sizing, and visual review checks labels/crossings at intended sizes.
- Anatomical presets record their sources/context and distinguish illustration parameters from measurements.
- Features extend or compose the common renderer instead of creating an independent wrapper for each textbook figure.
