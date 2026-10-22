# External branch contacts

Pyramidal glyphs expose `oblique-tip-west`, `oblique-tip-east`, `basal-tip-west` and `basal-tip-east`. These anchors follow the visible branch ends when arbor dimensions, detail, scale or rotation change. Existing ports remain available.

Use an external branch tip plus `projection(target-gap: 0.27)` when an arrow arriving from outside would otherwise cross the arbor to reach the central `apical` anchor. `target-gap` remains an explicit drawing distance, not a biological synaptic distance.

The new `examples/ca2-presentation.typ` includes three laminar circuits selected with `--input mode=overview`, `mode=ca3ca2` or `mode=modulation`.

Superficial and deep CA1 pyramidal somata are both placed within SP, at different depths in that band. Their dendrites extend into other strata. CA2 drive is shown qualitatively as stronger to deep cells, with a thinner dashed projection to superficial cells; widths are not measured strength ratios. Separate EC II boxes represent aggregate projection populations, not a claim that one EC neuron sends identical information to both regions. Selected direct routes omit DG, which is covered by the canonical circuit example. The CA3 recurrence loop represents a population motif, not a single-neuron autapse.

Labels remain outside layer panels and away from routed paths. Explicit routes and label positions still need visual inspection; these ports are not an automatic collision-avoidance algorithm.
