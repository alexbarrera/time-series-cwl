class: Workflow
cwlVersion: v1.0
doc: 'Create score matrices of reads in windows of fixed length around TSSs '
requirements:
  - class: ScatterFeatureRequirement
  - class: StepInputExpressionRequirement
  - class: InlineJavascriptRequirement
  - class: SubworkflowFeatureRequirement
inputs:
  matrices_nested:
    doc: BigWig files. Multiple replicates per time point can be included
    type: File[][]
steps:
  reps-same-tp:
    run: take-mean-and-merge-hdf5-wf.cwl
    in:
      tp_hdf5_files: split-arrays-by-timepoint/array_by_tp
    scatter: tp_hdf5_files
    out:
    - merged_hdf5_file
    - mean_hdf5_files
  split-arrays-by-timepoint:
    run: split-arrays-by-timepoint.cwl
    in:
      arrays: matrices_nested
    scatter: arrays
    out:
    - array_by_tp
outputs:
  reps_same_tp_merged:
    outputSource: reps-same-tp/merged_hdf5_file
    type: File[]
  output_matrices:
    outputSource: split-arrays-by-timepoint/array_by_tp
    type: File[][][]
  output_mean_hdf5_files:
    outputSource: reps-same-tp/mean_hdf5_files
    type: File[][]
