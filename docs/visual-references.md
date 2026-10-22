# Visual references and next examples

## Twenty supplied screenshots, visually reviewed

All are from *The Hippocampus Book*, second edition, supplied on 2026-10-20. Times identify screenshots where a figure number or caption is cropped. The images guide original drawings; third-party illustrations are not bundled in the package.

| Screenshot time | Visible figure/content | Feasibility and current coverage |
| --- | --- | --- |
| 15.35.42 | 3.1A/B, folded anatomy and unfolded regional pathways | Unfolded composition supported; folded/perspective anatomy needs a new geometry module |
| 15.37.25 | Principal-cell arbors in a hippocampal section | Schematic cells supported; realistic section outlines and reconstructed arbors need additional geometry/data |
| 15.37.38 | 3.17, granule-cell reconstructions in three views | Requires 3D morphology data for faithful projections; a single screenshot cannot recover 3D geometry |
| 15.37.49 | 3.18A/B, reconstructed DG interneurons and symbolic layer atlas | Symbolic explicit dendritic/axonal domains supported; A requires reconstruction data |
| 15.38.14 | 3.23, axon arbors and mossy-fiber terminal detail | Schematic paths and bouton markers supported; detailed measured arbors and terminal geometry need data/custom assets |
| 15.38.57 | CA3 pyramidal reconstruction in layers | Schematic layered pyramidal glyph supported; camera-lucida fidelity requires traced/imported morphology |
| 15.39.07 | 3.26, CA2 pyramidal reconstruction | Same boundary: schematic drawing versus data-backed reconstruction |
| 15.39.21 | 3.27, CA1 pyramidal reconstruction | Same boundary: schematic drawing versus data-backed reconstruction |
| 15.39.27 | 3.28, differently oriented cells in a curved hippocampal section | Cell rotation supported; continuous curved strata and anatomical placement are future geometry work |
| 15.39.39 | 3.29, CA1 interneuron somatodendritic/axonal territories | Core symbolic representation supported by custom neurites and boutons; curated full atlas not implemented |
| 15.41.16 | 3.31, longitudinal topography across sections | Possible with reusable section outlines and explicit topographic maps; not implemented |
| 15.41.55 | 3.38, intrinsic EC projections, layer and density maps | Flat layers and explicit paths supported; density fields and spatial registration not implemented |
| 15.42.10 | 3.40, dense cortical wiring | Population boxes, explicit routing, color and weight supported; dense graph automatic routing not implemented |
| 15.42.20 | Cortical efferent wiring | Same graph primitives; manual routes currently required |
| 15.42.34 | Afferent wiring with color and thickness codes | Same primitives; weights must be explicitly mapped to source data |
| 15.43.05 | 3.56, regional/layer channels in perspective | Flat multiregion layers supported; perspective solids/channel geometry not implemented |
| 15.43.13 | 3.57, serial and parallel regional circuitry | Supported with population boxes and explicit paths; example includes selected major pathways |
| 15.43.53 | Anatomy, regional wiring and afferent/efferent lists | Boxes/paths composable; anatomical drawing and histological image panels require assets/imports |
| 15.44.04 | 5.2, CA1 dendritic inputs and oriented cell population | Compartment endpoints, rotation and layer placement supported; realistic reconstruction/curved anatomy not implemented |
| 15.44.31 | Electrophysiological traces, adaptation and bursting | Procedural illustrative waveforms are planned; reproducing the original measured recordings is not required |

## Architecture decision

Keep one package with modules sharing the same scene, coordinate model, cell ports and projection renderer. The new `population` and explicit `neurite` records extend that scene rather than creating independent diagram wrappers. An eventual morphology adapter can consume real reconstructions without making a parallel circuit engine. Curved anatomical geometry is a separate extension of regional geometry, not a reason to duplicate the entire package.

## Illustration outputs

- `hippocampal-layers.typ`: 85 mm CA1 illustration, containing diagram labels only.
- `hippocampal-pathways.typ`: 125 mm DG-CA3-CA1 with region-specific strata, EC inputs, mossy fibers and Schaffer collaterals.
- `laminar-domains.typ`: 105 mm symbolic Basket/Bistratified/O-LM somatodendritic and axonal territories, inspired by the visual grammar of 3.29, without claiming to reproduce a full atlas.
- `regional-network.typ`: 85 mm selected canonical serial/parallel pathways using the same scene renderer.
- `cortical-layers.typ`: CA1/neocortex comparison with optional roman/Arabic labels and layer legend.
- `interneuron-atlas.typ`: four sourced rodent CA1 schematic domain recipes with dendrites and axons distinguished by color.
- `compartment-targets.typ`: selected CA1 inhibitory targets on soma, AIS, apical/basal dendrites and distal tuft.
- `circuit-motifs.typ`: feedforward inhibition, feedback inhibition and disinhibition, with editable scene records.
- `hippocampal-microcircuit.typ`: first selected nine-cell DG/CA3/CA1 laminar microcircuit, with shared axon junctions and optional EC inputs; scope and sources in [the microcircuit notes](hippocampal-microcircuit.md).
- `illustrations.typ`: nine illustration-only pages, including the current layout corrections and the new multiregion microcircuit on page 9.

Layer heights, cell geometry and trajectory coordinates are illustration parameters, not measurements. Afferent lines in the pathway example show selected rodent pathways; no direct CA1-DG projection is implied. The symbolic atlas omits many arbors and targets. Reference 3.29 motivates the domain representation, not a complete cell-type database.

## Resources

### Hippocampome: freely accessible, anatomy first

- [Portal](https://hippocampome.org/php/)
- [Morphology matrix](https://hippocampome.org/php/morphology.php)
- [Wheeler et al. (2015), figures and legends](https://elifesciences.org/articles/09960/figures)

The resource describes rodent hippocampal neuron types, with region- and layer-specific distributions of axons, dendrites and somata, and links properties to published evidence. Its morphology matrix is useful for choosing cells and the layers their processes occupy. Axonal-dendritic overlap supports potential connectivity; it is not itself a demonstrated synapse.

### The Hippocampus Book: textbook reference

- [Second edition (2025)](https://academic.oup.com/book/59509)
- Chapter 3: *Hippocampal Neuroanatomy*
- Chapter 5: *Structural and Functional Properties of Hippocampal Neurons*
- Chapter 7: *Local Circuits*
- [First-edition neuroanatomy chapter, Amaral and Lavenex](https://academic.oup.com/book/25965/chapter-abstract/193768286)

These chapters match the three scales we need: regional anatomy, individual cells and local circuitry. Full text may require institutional access. Figure-specific choices should be made from the actual pages, rather than inferred from chapter titles.

### Concrete open article figure

[Ferrante and Ascoli (2015), Figure 1A](https://www.frontiersin.org/journals/cellular-neuroscience/articles/10.3389/fncel.2015.00439/full#F1): the left panel distinguishes perisomatic basket-cell input from apical and basal dendritic input by bistratified cells on a CA1 pyramidal morphology. Useful for how a figure encodes targets at different compartments.

## Sources behind the first CA1 example

- Leão et al. (2012). *OLM interneurons differentially modulate CA3 and entorhinal inputs to hippocampal CA1 neurons*. Nature Neuroscience 15, 1524-1530. [doi:10.1038/nn.3235](https://doi.org/10.1038/nn.3235). Distal dendritic inhibition and the distinction between CA3 and EC inputs. [Author-hosted full text](https://neuro.ufrn.br/static/core/_pdf/richardson/1027.pdf).
- Ferrante and Ascoli (2015). *Distinct and synergistic feedforward inhibition of pyramidal cells by basket and bistratified interneurons*. Frontiers in Cellular Neuroscience 9, 439. [doi:10.3389/fncel.2015.00439](https://doi.org/10.3389/fncel.2015.00439). Perisomatic basket-cell targeting.
- Wheeler et al. (2015). *Hippocampome.org: a knowledge base of neuron types in the rodent hippocampus*. eLife 4, e09960. [doi:10.7554/eLife.09960](https://doi.org/10.7554/eLife.09960). Laminar vocabulary and morphology representation.

The example selects EC layer III and CA3 excitation, O-LM inhibition of distal dendrites, and basket-cell inhibition at the soma. It omits other connections, including inputs to interneurons. Its relative layer thicknesses, cell shapes, branching patterns, positions, and axon routes are illustration parameters, not measurements.
