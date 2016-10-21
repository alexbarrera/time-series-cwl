#!/usr/bin/env cwl-runner
class: Workflow
cwlVersion: "cwl:draft-3"
description: |
  Create score matrices of reads in windows of fixed length around TSSs
requirements:
  - class: ScatterFeatureRequirement
  - class: StepInputExpressionRequirement
  - class: InlineJavascriptRequirement
inputs:
  - id: "#bigwigs"
    description: BigWig files. Multiple replicates per time point can be included
    type: File
#  - id: "#nbases_to_extend"
#    description: |
#      Number of bases PER SIDE to extend around the reference TSS
#      (e.g. nbases_to_extend=1000 if a region of size 2000 is desired).
#    type:
#      type: array
#      items: int
#  - id: "#bin_size"
#    description: |
#      Bin size that will determine the number of columns for the generated
#      output matrices.
#      Please note that number should be sufficiently smaller than the number
#      bases in the region to be useful.
#    type:
#      type: array
#      items: int
  - id: "#nextend_bins_tuples"
    description: |
      Tuples of:
        1.Number of bases PER SIDE to extend around the reference TSS
          (e.g. nbases_to_extend=1000 if a region of size 2000 is desired);
        2.Bin size that will determine the number of columns for the generated
          output matrices.
    type:
      type: array
      items: int
  - id: "#regions_bedfile"
    description: |
      Bedfile of the regions (e.g. TSSs) used as reference points to extend
      the region read counts.
    type: File
  - id: "#nthreads"
    description: Number of threads.
    type: int

steps:
  - id: "#basename"
    run: "extract-basename.cwl"
#    scatter: "#extract-basename.input_file"
    inputs:
      - id: "#extract-basename.input_file"
        source: "#bigwigs"
    outputs:
      - id: "#extract-basename.output_basename"
  - id: "#compute_matrix"
    run: deeptools-computematrix-referencepoint.cwl
#    scatter:
#      - "#compute_matrix.scoreFiles"
#      - "#compute_matrix.outFileName"
#      - "#compute_matrix.outFileNameMatrix"
#      - "#compute_matrix.beforeRegionStartLength"
#      - "#compute_matrix.afterRegionStartLength"
#      - "#compute_matrix.binSize"
#    scatterMethod: dotproduct
    inputs:
      - id: "#compute_matrix.numberOfProcessors"
        valueFrom: 'max'
      - id: "#compute_matrix.referencePoint"
        valueFrom: 'center'
      - id: "#compute_matrix.regionsFiles"
        source: "#regions_bedfile"
        valueFrom: $([self])
      - id: "#compute_matrix.scoreFiles"
        source: "#bigwigs"
        valueFrom: $([self])
      - id: "#compute_matrix.missingDataAsZero"
        valueFrom: $(true)
      - id: "#compute_matrix.sortRegions"
        valueFrom: 'no'
      - id: "#compute_matrix.beforeRegionStartLength"
        source: "#nextend_bins_tuples"
        valueFrom: $(self[0])
      - id: "#compute_matrix.afterRegionStartLength"
        source: "#nextend_bins_tuples"
        valueFrom: $(self[0])
      - id: "#compute_matrix.averageTypeBins"
        valueFrom: 'sum'
      - id: "#compute_matrix.outFileNameMatrix"
        source: "#extract-basename.output_basename"
        valueFrom: |
          ${
            return self + "." + String(inputs['binSize']).replace(/,/, "_") + ".txt";
          }
      - id: "#compute_matrix.outFileName"
        source: "#extract-basename.output_basename"
        valueFrom: |
          ${
            return self + "." + String(inputs['binSize']).replace(/,/, "_") + ".toPlot.gz";
          }
      - id: "#compute_matrix.binSize"
        source: "#nextend_bins_tuples"
        valueFrom: $(self[1])
    outputs:
      - id: "#compute_matrix.output_matrix_txt"

outputs:
  - id: "#output_matrices"
    source: "#compute_matrix.output_matrix_txt"
    type: File
