cwlVersion: "cwl:draft-3"
class: ExpressionTool
description: |
  Split array files into same resolution (nbins to extend _ bin size) groups.
requirements:
  - class: InlineJavascriptRequirement
inputs:
  - id: arrays
    type:
      type: array
      items: File
expression: |
  ${
    var out = {};
    inputs.arrays.forEach(function(e, i){
      var tp = e.path.match(/\d+_\d+\.txt$/)[0];
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

    return {"array_by_res": arr};
  }
outputs:
  - id: array_by_res
    type:
      type: array
      items:
        type: array
        items: File
