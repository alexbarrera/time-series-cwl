#!/usr/bin/env cwl-runner
cwlVersion: 'cwl:draft-3'
class: CommandLineTool
hints:
  - class: DockerRequirement
    dockerImageId: 'dukegcb/python-array-utils'
requirements:
  - class: InlineJavascriptRequirement
inputs:
  - id: hdf5file
    type: File
    description: HDF5 file containing a reads dataset
    inputBinding:
      position: 1
  - id: outFileName
    type: string
    description: Output filename
    inputBinding:
      position: 2
  - id: resloutions
    type:
      type: array
      items: int
    description: Resolution of the matrices (num. of bases per bin)
    inputBinding:
      position: 3
      prefix: '--resolutions'
  - id: genes_bedfile
    type:
      - 'null'
      - File
    description: "BED file used to extract the gene names (column 4)"
    inputBinding:
      position: 3
      prefix: '--genes-bedfile'
  - id: gene_names
    type:
      - 'null'
      - File
    description: "File with gene names (one per line)"
    inputBinding:
      position: 3
      prefix: '--gene-names'

outputs:
  - id: '#out'
    type: File
    outputBinding:
      glob: $(inputs.outFileName)

baseCommand:
  - add_genes_to_hdf5.py
description: |
  add gene names dataset to a HDF5 file