class: CommandLineTool
cwlVersion: v1.0
doc: |-
  merge hdf5 files
requirements:
  InlineJavascriptRequirement: {}
hints:
  DockerRequirement:
    dockerImageId: dukegcb/python-array-utils
inputs:
  files:
    type:
      type: array
      items: File
    inputBinding:
      position: 1
      prefix: -files
    doc: |
      File [File ...]
      HDF5 files
  out_file_name:
    type: string
    inputBinding:
      position: 1
      prefix: -out
    doc: Output filename
outputs:
  out:
    type: File
    outputBinding:
      glob: $(inputs.out_file_name)

baseCommand:
  - merge_hdf5.py
