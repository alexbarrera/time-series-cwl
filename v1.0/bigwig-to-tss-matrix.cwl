class: Workflow
cwlVersion: v1.0
doc: 'Create score matrices of reads in windows of fixed length around TSSs '
requirements:
  - class: ScatterFeatureRequirement
  - class: StepInputExpressionRequirement
  - class: InlineJavascriptRequirement
inputs:
  nextend_bins_tuples:
    doc: 'Tuples of:   1.Number of bases PER SIDE to extend around the reference
      TSS     (e.g. nbases_to_extend=1000 if a region of size 2000 is desired);   2.Bin
      size that will determine the number of columns for the generated     output
      matrices. '
    type: int[]
  nthreads:
    doc: Number of threads.
    type: int
  regions_bedfile:
    doc: 'Bedfile of the regions (e.g. TSSs) used as reference points to extend
      the region read counts. '
    type: File
  bigwigs:
    doc: BigWig files. Multiple replicates per time point can be included
    type: File
steps:
  basename:
    in:
      input_file: bigwigs
    run: extract-basename.cwl
    out:
    - output_basename
  compute_matrix:
    in:
      afterRegionStartLength:
        source: nextend_bins_tuples
        valueFrom: $(self[0])
      numberOfProcessors:
        valueFrom: max
      beforeRegionStartLength:
        source: nextend_bins_tuples
        valueFrom: $(self[0])
      scoreFiles:
        source: bigwigs
        valueFrom: $([self])
      outFileName:
        source: extract-basename/output_basename
        valueFrom: "${\n  return self + \".\" + String(inputs['binSize']).replace(/,/,\
          \ \"_\") + \".toPlot.gz\";\n}"
      missingDataAsZero:
        valueFrom: $(true)
      outFileNameMatrix:
        source: extract-basename/output_basename
        valueFrom: "${\n  return self + \".\" + String(inputs['binSize']).replace(/,/,\
          \ \"_\") + \".txt\";\n}"
      averageTypeBins:
        valueFrom: sum
      sortRegions:
        valueFrom: no
      binSize:
        source: nextend_bins_tuples
        valueFrom: $(self[1])
      regionsFiles:
        source: regions_bedfile
        valueFrom: $([self])
      referencePoint:
        valueFrom: center
    run: deeptools-computematrix-referencepoint.cwl
    out:
    - output_matrix_txt
outputs:
  output_matrices:
    outputSource: compute_matrix/output_matrix_txt
    type: File
