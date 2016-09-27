#!/usr/bin/env cwl-runner
cwlVersion: 'cwl:draft-3'
class: CommandLineTool
hints:
  - class: DockerRequirement
    dockerImageId: 'dukegcb/python-array-utils'
requirements:
  - class: InlineJavascriptRequirement
inputs:
  - id: files
    type:
      type: array
      items: File
    description: |
      File [File ...]
      HDF5 files
    inputBinding:
      position: 1
      prefix: '-files'
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
  - merge_hdf5.py
description: |
  merge hdf5 files