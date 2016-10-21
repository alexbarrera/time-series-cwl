#!/usr/bin/env cwl-runner
cwlVersion: 'cwl:draft-3'
class: CommandLineTool
hints:
  - class: DockerRequirement
    dockerImageId: 'dukegcb/python-array-utils'
requirements:
  - class: InlineJavascriptRequirement
inputs:
  - id: arrays
    type:
      type: array
      items: File
    description: |
      File [File ...]
      Matrices files produced by deepTools calculateMatrix command
    inputBinding:
      position: 1
      prefix: '-arrays'
  - id: out_file_name
    type: string
    description: "Output filename"
    inputBinding:
      position: 1
      prefix: '-out'

outputs:
  - id: '#out'
    type: File
    outputBinding:
      glob: $(inputs.out_file_name)

baseCommand:
  - take_mean_save_hdf5.py
description: |
  take mean from numpy arrays and store a gzipped file