class: ExpressionTool
cwlVersion: v1.0
doc: |
  Split array files into same time point groups. File names containing tXX_repYY
  will be group together
requirements:
  InlineJavascriptRequirement: {}
inputs:
  arrays:
    type: File[]
expression: |
  ${
    var out = {};
    inputs.arrays.forEach(function(e, i){
      var tp = e.path.match(/t[\d\.]+_rep/)[0];
      if (out[tp]){
        out[tp].push(e);
      } else {
        out[tp] = [e];
      }
    });
     var arr = [];
    for( var i in out ) {
        if (out.hasOwnProperty(i)){
           arr.push(out[i]);
        }
    }
     return {"array_by_tp": arr};
  }
outputs:
  array_by_tp:
    type: File[][]
