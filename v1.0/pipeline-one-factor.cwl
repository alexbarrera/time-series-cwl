class: Workflow
cwlVersion: v1.0
doc: 'Create score matrices of reads in windows of fixed length around TSSs '
requirements:
  - class: ScatterFeatureRequirement
  - class: StepInputExpressionRequirement
  - class: InlineJavascriptRequirement
  - class: SubworkflowFeatureRequirement
inputs:
  nextend_bins_tuples:
    doc: 'Tuples of:   1.Number of bases PER SIDE to extend around the reference
      TSS     (e.g. nbases_to_extend=1000 if a region of size 2000 is desired);   2.Bin
      size that will determine the number of columns for the generated     output
      matrices. '
    type: int[][]
  nthreads:
    doc: Number of threads.
    type: int
  regions_bedfile:
    doc: 'Bedfile of the regions (e.g. TSSs) used as reference points to extend
      the region read counts. '
    type: File
  bigwigs:
    doc: BigWig files. Multiple replicates per time point can be included
    type: File[]
steps:
  flatten-resolution-array:
    in:
      arrays: process-each-resolution/reps_same_tp_merged
    run: flatten-nested-arrays.cwl
    out:
    - flattened_array
  merge-resolutions:
    in:
      files: process-each-resolution/flattened_array
      stackaxis:
        valueFrom: $(2)
      out_file_name:
        source: process-each-resolution/flattened_array
        valueFrom: "${\n  return self[0].path.replace(/^.*[\\\\\\/]/, '').replace(/\\\
          .[^/.]+$/, '').replace(/\\.\\d+\\_\\d+\\.merged$/,'') + '.h5';\n}"
    run: merge-hdf5.cwl
    out:
    - out
  split-arrays-by-resolution:
    run: split-arrays-by-resolution.cwl
    in:
      arrays: bigwig-to-tss-matrix/output_matrices
    scatter: arrays
    out:
    - array_by_res
  process-each-resolution:
    run: pipeline-one-resolution.cwl
    in:
      matrices_nested: split-arrays-by-resolution/array_by_res
    scatter: matrices_nested
    out:
    - output_matrices
    - reps_same_tp_merged
    - output_mean_hdf5_files
  bigwig-to-tss-matrix:
    run: bigwig-to-tss-matrix.cwl
    in:
      nextend_bins_tuples: nextend_bins_tuples
      nthreads: nthreads
      regions_bedfile: regions_bedfile
      bigwigs: bigwigs
    scatterMethod: nested_crossproduct
    scatter:
    - nextend_bins_tuples
    - bigwigs
    out:
    - output_matrices
outputs:
  reps_same_tp_merged:
    outputSource: process-each-resolution/reps_same_tp_merged
    type: File[][]
  all_res_merged:
    outputSource: merge-resolutions/out
    type: File
  output_matrices:
    outputSource: process-each-resolution/output_matrices
    type: File[][][][]
  output_mean_hdf5_files:
    outputSource: process-each-resolution/output_mean_hdf5_files
    type: File[][][]
