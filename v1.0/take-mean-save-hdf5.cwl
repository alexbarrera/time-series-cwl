class: CommandLineTool
cwlVersion: v1.0
doc: |-
  take mean from numpy arrays and store a gzipped file
requirements:
  InlineJavascriptRequirement: {}
hints:
  DockerRequirement:
    dockerImageId: dukegcb/python-array-utils
inputs:
  arrays:
    type:
      type: array
      items: File
    inputBinding:
      position: 1
      prefix: -arrays
    doc: |
      File [File ...]
      Matrices files produced by deepTools calculateMatrix command
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
  - take_mean_save_hdf5.py
