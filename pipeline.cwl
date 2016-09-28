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
      items:
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
  - id: "#gtf"
    description: |
      Genome annotation file in GTF format. Used to generate a exons per
      gene file.
    type: File
  - id: "#nthreads"
    description: Number of threads.
    type: int

steps:

  - id: "#process-sample"
    run: "pipeline-one-factor.cwl"
    scatter: "#process-sample.bigwigs"
    inputs:
      - id: "#process-sample.bigwigs"
        source: "#bigwigs"
      - id: "#process-sample.nextend_bins_tuples"
        source: "#nextend_bins_tuples"
      - id: "#process-sample.regions_bedfile"
        source: "#regions_bedfile"
      - id: "#process-sample.nthreads"
        source: "#nthreads"
    outputs:
      - id: "#process-sample.output_matrices"
      - id: "#process-sample.reps_same_tp_merged"
      - id: "#process-sample.output_mean_hdf5_files"
      - id: "#process-sample.all_res_merged"

  - id: "#add-gene-name"
    run: "add-name-to-hdf5.cwl"
    scatter:
      - "#add-gene-name.hdf5file"
      - "#add-gene-name.outFileName"
    scatterMethod: dotproduct
    inputs:
      - id: "#add-gene-name.hdf5file"
        source: "#process-sample.all_res_merged"
      - id: "#add-gene-name.outFileName"
        source: "#process-sample.all_res_merged"
        valueFrom: |
          ${
            return self.path.replace(/^.*[\\\/]/, '').replace(/\.[^/.]+$/, '.with_genes.h5');
          }
      - id: "#add-gene-name.genes_bedfile"
        source: "#regions_bedfile"
    outputs:
      - id: "#add-gene-name.out"

  - id: "#gtf-to-exons"
    run: "gtf-to-exons-per-gene-array.cwl"
    inputs:
      - id: "#gtf-to-exons.gtf"
        source: "#gtf"
      - id: "#gtf-to-exons.out_file_name"
        source: "#gtf"
        valueFrom: |
          ${
            return self.path.replace(/^.*[\\\/]/, '').replace(/\.[^/.]+$/, '.exons.tsv');
          }
      - id: "#gtf-to-exons.nthreads"
        source: "#nthreads"
    outputs:
      - id: "#gtf-to-exons.out"

outputs:
  - id: "#output_matrices"
    source: "#process-sample.output_matrices"
    type:
      type: array
      items:
        type: array
        items:
          type: array
          items:
            type: array
            items:
              type: array
              items: File

  - id: "#reps_same_tp_merged"
    source: "#process-sample.reps_same_tp_merged"
    type:
      type: array
      items:
        type: array
        items:
          type: array
          items: File

  - id: "#output_mean_hdf5_files"
    source: "#process-sample.output_mean_hdf5_files"
    type:
      type: array
      items:
        type: array
        items:
          type: array
          items:
            type: array
            items: File

  - id: "#all_res_merged"
    source: "#add-gene-name.out" #"#process-sample.all_res_merged"
    type:
      type: array
      items: File
  - id: "#exons_tsv"
    source: "#gtf-to-exons.out"
    type: File