#!/usr/bin/env cwl-runner
cwlVersion: 'cwl:draft-3'
class: CommandLineTool
hints:
  - class: DockerRequirement
    dockerImageId: 'dukegcb/python-array-utils'
requirements:
  - class: InlineJavascriptRequirement
inputs:
  - id: gtf
    type: File
    description: Input GTF file
    inputBinding:
      position: 1
  - id: nthreads
    type:
      - 'null'
      - int
    description: Number of threads
    inputBinding:
      position: 2
  - id: out_file_name
    type: string
    description: "Output filename"

outputs:
  - id: '#out'
    type: File
    outputBinding:
      glob: $(inputs.out_file_name)
stdout: $(inputs.out_file_name)
baseCommand:
  - gtf_to_exons_per_gene_array.py
description: |
  Transform a GTF file into a chrom,strand,gene and exons tab-delimited file