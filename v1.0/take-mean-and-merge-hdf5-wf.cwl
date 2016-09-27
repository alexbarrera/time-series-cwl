class: Workflow
cwlVersion: v1.0
doc: Take mean of hdf5 files and merge them
inputs:
  tp_hdf5_files:
    type: File[][]
steps:
  merge-hdf5:
    in:
      files: take-mean-save-hdf5/out
      out_file_name:
        source: take-mean-save-hdf5/out
        valueFrom: "${\n  return self[0].path.replace(/^.*[\\\\\\/]/, '').replace(/\\\
          .[^/.]+$/, '').replace(/\\.t\\d+/,'') + '.merged.h5';\n}"
    run: merge-hdf5.cwl
    out:
    - out
  take-mean-save-hdf5:
    run: take-mean-save-hdf5.cwl
    in:
      arrays: tp_hdf5_files
      out_file_name:
        source: tp_hdf5_files
        valueFrom: "${\n  return self[0].path.replace(/^.*[\\\\\\/]/, '').replace(/\\\
          .[^/.]+$/, '').replace(/_rep\\d+/,'') + '.h5';\n}"
    scatterMethod: dotproduct
    scatter:
    - arrays
    - out_file_name
    out:
    - out
outputs:
  merged_hdf5_file:
    outputSource: merge-hdf5/out
    type: File
  mean_hdf5_files:
    outputSource: take-mean-save-hdf5/out
    type: File[]
