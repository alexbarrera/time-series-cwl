#!/usr/bin/env cwl-runner
cwlVersion: "cwl:draft-3"
class: CommandLineTool
description: "Extracts the base name of a file"

hints:
  - class: DockerRequirement
    dockerImageId: 'dukegcb/workflow-utils'
requirements:
  - class: InlineJavascriptRequirement
inputs:
  - id: "#input_file"
    type: File
    inputBinding:
      position: 1
outputs:
  - id: "#output_basename"
    type: string
    outputBinding:
      outputEval: $(inputs.input_file.path.substr(inputs.input_file.path.lastIndexOf('/') + 1, inputs.input_file.path.lastIndexOf('.') - (inputs.input_file.path.lastIndexOf('/') + 1)))

baseCommand: echo