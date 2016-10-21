cwlVersion: "cwl:draft-3"
class: ExpressionTool
description: |
  Flatten nested arrays into one array (1 level flatten)
requirements:
  - class: InlineJavascriptRequirement
inputs:
  - id: arrays
    type:
      type: array
      items:
        type: array
        items: File
expression: |
  ${
    var out = [];
    inputs.arrays.forEach(function(e, i){
      e.forEach(function(ee, ii){
        out.push(ee);
      });
    });
    return {"flattened_array": out};
  }
outputs:
  - id: flattened_array
    type:
      type: array
      items: File