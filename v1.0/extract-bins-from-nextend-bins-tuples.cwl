class: ExpressionTool
cwlVersion: v1.0
doc: |
  Flatten nested arrays into one array (1 level flatten)
requirements:
  InlineJavascriptRequirement: {}
inputs:
  arrays:
    type: int[][]
expression: |
  ${
    var out = [];
    inputs.arrays.forEach(function(e, i){
        out.push(e[1]);
    });
    return {"flattened_array": out};
  }
outputs:
  flattened_array:
    type: int[]
