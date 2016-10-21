#!/usr/bin/env cwl-runner
class: Workflow
cwlVersion: "cwl:draft-3"
description: |
  Take mean of hdf5 files and merge them
inputs:
  - id: "#tp_hdf5_files"
    type:
      type: array
      items:
        type: array
        items: File

steps:

  - id: "#take-mean-save-hdf5"
    run: "take-mean-save-hdf5.cwl"
    scatter:
      - "#take-mean-save-hdf5.arrays"
      - "#take-mean-save-hdf5.out_file_name"
    scatterMethod: dotproduct
    inputs:
      - id: "#take-mean-save-hdf5.arrays"
        source: "#tp_hdf5_files"
      - id: "#take-mean-save-hdf5.out_file_name"
        source: "#tp_hdf5_files"
        valueFrom: |
          ${
            return self[0].path.replace(/^.*[\\\/]/, '').replace(/\.[^/.]+$/, '').replace(/_rep\d+/,'') + '.h5';
          }
    outputs:
      - id: "#take-mean-save-hdf5.out"

  - id: "#merge-hdf5"
    run: "merge-hdf5.cwl"
    inputs:
      - id: "#merge-hdf5.files"
        source: "#take-mean-save-hdf5.out"
      - id: "#merge-hdf5.out_file_name"
        source: "#take-mean-save-hdf5.out"
        valueFrom: |
          ${
            return self[0].path.replace(/^.*[\\\/]/, '').replace(/\.[^/.]+$/, '').replace(/\.t\d+/,'') + '.merged.h5';
          }
    outputs:
      - id: "#merge-hdf5.out"


outputs:
  - id: "#merged_hdf5_file"
    source: "#merge-hdf5.out"
    type: File
  - id: "#mean_hdf5_files"
    source: "#take-mean-save-hdf5.out"
    type:
      type: array
      items: File
