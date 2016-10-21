class: CommandLineTool
cwlVersion: v1.0
doc: |-
  Transform a GTF file into a chrom,strand,gene and exons tab-delimited file
requirements:
  InlineJavascriptRequirement: {}
hints:
  DockerRequirement:
    dockerImageId: dukegcb/python-array-utils
inputs:
  out_file_name:
    type: string
    doc: Output filename
  nthreads:
    type: int?
    inputBinding:
      position: 2
    doc: Number of threads
  gtf:
    type: File
    inputBinding:
      position: 1
    doc: Input GTF file
outputs:
  out:
    type: File
    outputBinding:
      glob: $(inputs.out_file_name)
baseCommand:
  - gtf_to_exons_per_gene_array.py
stdout: $(inputs.out_file_name)
