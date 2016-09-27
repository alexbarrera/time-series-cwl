class: CommandLineTool
cwlVersion: v1.0
doc: |-
  add gene names dataset to a HDF5 file
requirements:
  InlineJavascriptRequirement: {}
hints:
  DockerRequirement:
    dockerImageId: dukegcb/python-array-utils
inputs:
  outFileName:
    type: string
    inputBinding:
      position: 3
    doc: Output filename
  gene_names:
    type: File?
    inputBinding:
      position: 1
      prefix: --gene-names
    doc: File with gene names (one per line)
  hdf5file:
    type: File
    inputBinding:
      position: 2
    doc: HDF5 file containing a reads dataset
  genes_bedfile:
    type: File?
    inputBinding:
      position: 1
      prefix: --genes-bedfile
    doc: BED file used to extract the gene names (column 4)
outputs:
  out:
    type: File
    outputBinding:
      glob: $(inputs.outFileName)

baseCommand:
  - add_genes_to_hdf5.py
