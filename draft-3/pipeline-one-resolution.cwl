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
  - id: "#matrices_nested"
    description: BigWig files. Multiple replicates per time point can be included
    type:
      type: array
      items:
        type: array
        items: File

steps:
  - id: "#split-arrays-by-timepoint"
    run: "split-arrays-by-timepoint.cwl"
    scatter: "#split-arrays-by-timepoint.arrays"
    inputs:
      - id: "#split-arrays-by-timepoint.arrays"
        source: "#matrices_nested"
    outputs:
      - id: "#split-arrays-by-timepoint.array_by_tp"

  - id: "#reps-same-tp"
    run: "take-mean-and-merge-hdf5-wf.cwl"
    scatter: "#reps-same-tp.tp_hdf5_files"
    inputs:
      - id: "#reps-same-tp.tp_hdf5_files"
        source: "#split-arrays-by-timepoint.array_by_tp"
    outputs:
      - id: "#reps-same-tp.merged_hdf5_file"
#        linkMerge: merge_flattened
      - id: "#reps-same-tp.mean_hdf5_files"

outputs:
  - id: "#output_matrices"
    source: "#split-arrays-by-timepoint.array_by_tp"
    type:
      type: array
      items:
        type: array
        items:
          type: array
          items: File

  - id: "#reps_same_tp_merged"
    source: "#reps-same-tp.merged_hdf5_file"
    type:
      type: array
      items: File

  - id: "#output_mean_hdf5_files"
    source: "#reps-same-tp.mean_hdf5_files"
    type:
      type: array
      items:
        type: array
        items: File
