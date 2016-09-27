#!/usr/bin/env cwl-runner
class: Workflow
cwlVersion: "cwl:draft-3"
description: |
  Create score matrices of reads in windows of fixed length around TSSs
requirements:
  - class: ScatterFeatureRequirement
  - class: StepInputExpressionRequirement
  - class: InlineJavascriptRequirement
  - class: SubworkflowFeatureRequirement
inputs:
  - id: "#bigwigs"
    description: BigWig files. Multiple replicates per time point can be included
    type:
      type: array
      items: File
  - id: "#nextend_bins_tuples"
    description: |
      Tuples of:
        1.Number of bases PER SIDE to extend around the reference TSS
          (e.g. nbases_to_extend=1000 if a region of size 2000 is desired);
        2.Bin size that will determine the number of columns for the generated
          output matrices.
    type:
      type: array
      items:
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
  - id: "#bigwig-to-tss-matrix"
    run: "bigwig-to-tss-matrix.cwl"
    scatter:
      - "#bigwig-to-tss-matrix.nextend_bins_tuples"
      - "#bigwig-to-tss-matrix.bigwigs"
    scatterMethod: nested_crossproduct
    inputs:
      - id: "#bigwig-to-tss-matrix.bigwigs"
        source: "#bigwigs"
      - id: "#bigwig-to-tss-matrix.nextend_bins_tuples"
        source: "#nextend_bins_tuples"
      - id: "#bigwig-to-tss-matrix.regions_bedfile"
        source: "#regions_bedfile"
      - id: "#bigwig-to-tss-matrix.nthreads"
        source: "#nthreads"
    outputs:
      - id: "#bigwig-to-tss-matrix.output_matrices"

  - id: "#split-arrays-by-resolution"
    run: "split-arrays-by-resolution.cwl"
    scatter: "#split-arrays-by-resolution.arrays"
    inputs:
      - id: "#split-arrays-by-resolution.arrays"
        source: "#bigwig-to-tss-matrix.output_matrices"
    outputs:
      - id: "#split-arrays-by-resolution.array_by_res"

  - id: "#process-each-resolution"
    run: "pipeline-one-resolution.cwl"
    scatter:  "#process-each-resolution.matrices_nested"
    inputs:
      - id: "#process-each-resolution.matrices_nested"
        source: "#split-arrays-by-resolution.array_by_res"
    outputs:
      - id: "#process-each-resolution.output_matrices"
      - id: "#process-each-resolution.reps_same_tp_merged"
      - id: "#process-each-resolution.output_mean_hdf5_files"

  - id: "#flatten-resolution-array"
    run: "flatten-nested-arrays.cwl"
    inputs:
      - id: "#flatten-nested-arrays.arrays"
        source: "#process-each-resolution.reps_same_tp_merged"
    outputs:
      - id: "#process-each-resolution.flattened_array"

  - id: "#merge-resolutions"
    run: "merge-hdf5.cwl"
    inputs:
      - id: "#merge-resolutions.files"
        source: "#process-each-resolution.flattened_array"
      - id: "#merge-resolutions.out_file_name"
        source: "#process-each-resolution.flattened_array"
        valueFrom: |
          ${
            return self[0].path.replace(/^.*[\\\/]/, '').replace(/\.[^/.]+$/, '').replace(/\.\d+\_\d+\.merged$/,'') + '.h5';
          }
    outputs:
      - id: "#merge-resolutions.out"

outputs:
  - id: "#output_matrices"
    source: "#process-each-resolution.output_matrices"
    type:
      type: array
      items:
        type: array
        items:
          type: array
          items:
            type: array
            items: File

  - id: "#reps_same_tp_merged"
    source: "#process-each-resolution.reps_same_tp_merged"
    type:
      type: array
      items:
        type: array
        items: File

  - id: "#output_mean_hdf5_files"
    source: "#process-each-resolution.output_mean_hdf5_files"
    type:
      type: array
      items:
        type: array
        items:
          type: array
          items: File

  - id: "#all_res_merged"
    source: "#merge-resolutions.out"
    type: File
