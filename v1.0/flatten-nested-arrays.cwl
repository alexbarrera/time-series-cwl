class: ExpressionTool
cwlVersion: v1.0
doc: |
  Flatten nested arrays into one array (1 level flatten)
requirements:
  InlineJavascriptRequirement: {}
inputs:
  arrays:
    type: File[][]
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
  flattened_array:
    type: File[]
