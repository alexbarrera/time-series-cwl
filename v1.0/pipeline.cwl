class: Workflow
cwlVersion: v1.0
doc: 'Create score matrices of reads in windows of fixed length around TSSs '
requirements:
  - class: ScatterFeatureRequirement
  - class: StepInputExpressionRequirement
  - class: InlineJavascriptRequirement
  - class: SubworkflowFeatureRequirement
inputs:
  nthreads:
    doc: Number of threads.
    type: int
  nextend_bins_tuples:
    doc: 'Tuples of:   1.Number of bases PER SIDE to extend around the reference
      TSS     (e.g. nbases_to_extend=1000 if a region of size 2000 is desired);   2.Bin
      size that will determine the number of columns for the generated     output
      matrices. '
    type: int[][]
  gtf:
    doc: 'Genome annotation file in GTF format. Used to generate a exons per gene
      file. '
    type: File
  regions_bedfile:
    doc: 'Bedfile of the regions (e.g. TSSs) used as reference points to extend
      the region read counts. '
    type: File
  bigwigs:
    doc: BigWig files. Multiple replicates per time point can be included
    type: File[][]
steps:
  process-sample:
    run: pipeline-one-factor.cwl
    in:
      nextend_bins_tuples: nextend_bins_tuples
      nthreads: nthreads
      regions_bedfile: regions_bedfile
      bigwigs: bigwigs
    scatter: bigwigs
    out:
    - output_matrices
    - reps_same_tp_merged
    - output_mean_hdf5_files
    - all_res_merged
  add-gene-name:
    run: add-name-to-hdf5.cwl
    in:
      outFileName:
        source: process-sample/all_res_merged
        valueFrom: "${\n  return self.path.replace(/^.*[\\\\\\/]/, '').replace(/\\\
          .[^/.]+$/, '.with_genes.h5');\n}"
      resloutions: bins-list/flattened_array
      hdf5file: process-sample/all_res_merged
      genes_bedfile: regions_bedfile
    scatterMethod: dotproduct
    scatter:
    - hdf5file
    - outFileName
    out:
    - out
  gtf-to-exons:
    in:
      out_file_name:
        source: gtf
        valueFrom: "${\n  return self.path.replace(/^.*[\\\\\\/]/, '').replace(/\\\
          .[^/.]+$/, '.exons.tsv');\n}"
      nthreads: nthreads
      gtf: gtf
    run: gtf-to-exons-per-gene-array.cwl
    out:
    - out
  bins-list:
    in:
      arrays: nextend_bins_tuples
    run: extract-bins-from-nextend-bins-tuples.cwl
    out:
    - flattened_array
outputs:
  reps_same_tp_merged:
    outputSource: process-sample/reps_same_tp_merged
    type: File[][][]
  all_res_merged:
    outputSource: add-gene-name/out
    type: File[]
  exons_tsv:
    outputSource: gtf-to-exons/out
    type: File
  output_matrices:
    outputSource: process-sample/output_matrices
    type: File[][][][][]
  output_mean_hdf5_files:
    outputSource: process-sample/output_mean_hdf5_files
    type: File[][][][]
