class: ExpressionTool
cwlVersion: v1.0
doc: |
  Split array files into same resolution (nbins to extend _ bin size) groups.
requirements:
  InlineJavascriptRequirement: {}
inputs:
  arrays:
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
  array_by_res:
    type:
      type: array
      items:
        type: array
        items: File
