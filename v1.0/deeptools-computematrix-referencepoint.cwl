class: CommandLineTool
cwlVersion: v1.0
doc: |
  usage: An example usage is:
    computeMatrix -S <biwig file> -R <bed file> -a 3000 -b 3000
   optional arguments:
    -h, --help            show this help message and exit
   Required arguments:
    --regionsFileName File [File ...], -R File [File ...]
                          File name, in BED format, containing the regions to
                          plot. If multiple bed files are given, each one is
                          considered a group that can be plotted separately.
                          Also, adding a "#" symbol in the bed file causes all
                          the regions until the previous "#" to be considered
                          one group. (default: None)
    --scoreFileName File [File ...], -S File [File ...]
                          bigWig file(s) containing the scores to be plotted.
                          BigWig files can be obtained by using the bamCoverage
                          or bamCompare tools. More information about the bigWig
                          file format can be found at
                          http://genome.ucsc.edu/goldenPath/help/bigWig.html
                          (default: None)
   Output options:
    --outFileName OUTFILENAME, -out OUTFILENAME
                          File name to save the gzipped matrix file needed by
                          the "plotHeatmap" and "plotProfile" tools. (default:
                          None)
    --outFileNameMatrix FILE
                          If this option is given, then the matrix of values
                          underlying the heatmap will be saved using the
                          indicated name, e.g. IndividualValues.tab.This matrix
                          can easily be loaded into R or other programs.
                          (default: None)
    --outFileSortedRegions BED file
                          File name in which the regions are saved after skiping
                          zeros or min/max threshold values. The order of the
                          regions in the file follows the sorting order
                          selected. This is useful, for example, to generate
                          other heatmaps keeping the sorting of the first
                          heatmap. Example: Heatmap1sortedRegions.bed (default:
                          None)
   Optional arguments:
    --version             show program's version number and exit
    --referencePoint {TSS,TES,center}
                          The reference point for the plotting could be either
                          the region start (TSS), the region end (TES) or the
                          center of the region. Note that regardless of what you
                          specify, plotHeatmap/plotProfile will default to using
                          "TSS" as the label. (default: TSS)
    --beforeRegionStartLength INT bp, -b INT bp, --upstream INT bp
                          Distance upstream of the reference-point selected.
                          (default: 500)
    --afterRegionStartLength INT bp, -a INT bp, --downstream INT bp
                          Distance downstream of the reference-point selected.
                          (default: 1500)
    --nanAfterEnd         If set, any values after the region end are discarded.
                          This is useful to visualize the region end when not
                          using the scale-regions mode and when the reference-
                          point is set to the TSS. (default: False)
    --binSize BINSIZE, -bs BINSIZE
                          Length, in bases, of the non-overlapping bins for
                          averaging the score over the regions length. (default:
                          10)
    --sortRegions {descend,ascend,no}
                          Whether the output file should present the regions
                          sorted. The default is to not sort the regions. Note
                          that this is only useful if you plan to plot the
                          results yourself and not, for example, with
                          plotHeatmap, which will override this. (default: no)
    --sortUsing {mean,median,max,min,sum,region_length}
                          Indicate which method should be used for sorting. The
                          value is computed for each row.Note that the
                          region_length option will lead to a dotted line within
                          the heatmap that indicates the end of the regions.
                          (default: mean)
    --averageTypeBins {mean,median,min,max,std,sum}
                          Define the type of statistic that should be used over
                          the bin size range. The options are: "mean", "median",
                          "min", "max", "sum" and "std". The default is "mean".
                          (default: mean)
    --missingDataAsZero   If set, missing data (NAs) will be treated as zeros.
                          The default is to ignore such cases, which will be
                          depicted as black areas in a heatmap. (see the
                          --missingDataColor argument of the plotHeatmap command
                          for additional options). (default: False)
    --skipZeros           Whether regions with only scores of zero should be
                          included or not. Default is to include them. (default:
                          False)
    --minThreshold MINTHRESHOLD
                          Numeric value. Any region containing a value that is
                          less than or equal to this will be skipped. This is
                          useful to skip, for example, genes where the read
                          count is zero for any of the bins. This could be the
                          result of unmappable areas and can bias the overall
                          results. (default: None)
    --maxThreshold MAXTHRESHOLD
                          Numeric value. Any region containing a value greater
                          than or equal to this will be skipped. The
                          maxThreshold is useful to skip those few regions with
                          very high read counts (e.g. micro satellites) that may
                          bias the average values. (default: None)
    --quiet, -q           Set to remove any warning or processing messages.
                          (default: False)
    --scale SCALE         If set, all values are multiplied by this number.
                          (default: 1)
    --numberOfProcessors INT, -p INT
                          Number of processors to use. Type "max/2" to use half
                          the maximum number of processors or "max" to use all
                          available processors. (default: max/2)
requirements:
  InlineJavascriptRequirement: {}
hints:
  DockerRequirement:
    dockerImageId: dukegcb/deeptools
inputs:
  afterRegionStartLength:
    type: int?
    inputBinding:
      position: 1
      prefix: --afterRegionStartLength
    doc: |
      INT bp, -a INT bp, --downstream INT bp
      Distance downstream of the reference-point selected.
      (default: 1500)
  averageTypeBins:
    type: string?
    inputBinding:
      position: 1
      prefix: --averageTypeBins
    doc: |
      {mean,median,min,max,std,sum}
      Define the type of statistic that should be used over
      the bin size range. The options are: "mean", "median",
      "min", "max", "sum" and "std". The default is "mean".
      (default: mean)
  scale:
    type: float?
    inputBinding:
      position: 1
      prefix: --scale
    doc: |
      SCALE         If set, all values are multiplied by this number.
      (default: 1)
  beforeRegionStartLength:
    type: int?
    inputBinding:
      position: 1
      prefix: --beforeRegionStartLength
    doc: |
      INT bp, -b INT bp, --upstream INT bp
      Distance upstream of the reference-point selected.
      (default: 500)
  missingDataAsZero:
    type: boolean?
    inputBinding:
      position: 1
      prefix: --missingDataAsZero
    doc: '  If set, missing data (NAs) will be treated as zeros.
       The default is to ignore such cases, which will be
       depicted as black areas in a heatmap. (see the
       --missingDataColor argument of the plotHeatmap command
       for additional options). (default: False)
       '
  outFileName:
    type: string?
    inputBinding:
      position: 1
      prefix: --outFileName
    doc: |
      OUTFILENAME, -out OUTFILENAME
      File name to save the gzipped matrix file needed by
      the "plotHeatmap" and "plotProfile" tools. (default:
      None)
  nanAfterEnd:
    type: boolean?
    inputBinding:
      position: 1
      prefix: --nanAfterEnd
    doc: '        If set, any values after the region end are discarded.
       This is useful to visualize the region end when not
       using the scale-regions mode and when the reference-
       point is set to the TSS. (default: False)
       '
  outFileSortedRegions:
    type: boolean?
    inputBinding:
      position: 1
      prefix: --outFileSortedRegions
    doc: |
      BED file
      File name in which the regions are saved after skiping
      zeros or min/max threshold values. The order of the
      regions in the file follows the sorting order
      selected. This is useful, for example, to generate
      other heatmaps keeping the sorting of the first
      heatmap. Example: Heatmap1sortedRegions.bed (default:
      None)
      Optional arguments:
  quiet:
    type: boolean?
    inputBinding:
      position: 1
      prefix: --quiet
    doc: |
      Set to remove any warning or processing messages. (default: False)
  skipZeros:
    type: boolean?
    inputBinding:
      position: 1
      prefix: --skipZeros
    doc: '          Whether regions with only scores of zero should be
       included or not. Default is to include them. (default:
       False)
       '
  referencePoint:
    type: string?
    inputBinding:
      position: 1
      prefix: --referencePoint
    doc: |
      {TSS,TES,center}
      The reference point for the plotting could be either
      the region start (TSS), the region end (TES) or the
      center of the region. Note that regardless of what you
      specify, plotHeatmap/plotProfile will default to using
      "TSS" as the label. (default: TSS)
  outFileNameMatrix:
    type: string?
    inputBinding:
      position: 1
      prefix: --outFileNameMatrix
    doc: |
      FILE
      If this option is given, then the matrix of values
      underlying the heatmap will be saved using the
      indicated name, e.g. IndividualValues.tab.This matrix
      can easily be loaded into R or other programs.
      (default: None)
  version:
    type: boolean?
    inputBinding:
      position: 1
      prefix: --version
    doc: '            show program''s version number and exit
       '
  maxThreshold:
    type: int?
    inputBinding:
      position: 1
      prefix: --maxThreshold
    doc: |
      MAXTHRESHOLD
      Numeric value. Any region containing a value greater
      than or equal to this will be skipped. The
      maxThreshold is useful to skip those few regions with
      very high read counts (e.g. micro satellites) that may
      bias the average values. (default: None)
  sortUsing:
    type: string?
    inputBinding:
      position: 1
      prefix: --sortUsing
    doc: |
      {mean,median,max,min,sum,region_length}
      Indicate which method should be used for sorting. The
      value is computed for each row.Note that the
      region_length option will lead to a dotted line within
      the heatmap that indicates the end of the regions.
      (default: mean)
  sortRegions:
    type: string?
    inputBinding:
      position: 1
      prefix: --sortRegions
    doc: |
      {descend,ascend,no}
      Whether the output file should present the regions
      sorted. The default is to not sort the regions. Note
      that this is only useful if you plan to plot the
      results yourself and not, for example, with
      plotHeatmap, which will override this. (default: no)
  numberOfProcessors:
    type:
    - 'null'
    - int
    - string
    inputBinding:
      position: 1
      prefix: --numberOfProcessors
    doc: |
      INT, -p INT
      Number of processors to use. Type "max/2" to use half
      the maximum number of processors or "max" to use all
      available processors. (default: max/2)
  binSize:
    type: int?
    inputBinding:
      position: 1
      prefix: --binSize
    doc: |
      BINSIZE, -bs BINSIZE
      Length, in bases, of the non-overlapping bins for
      averaging the score over the regions length. (default:
      10)
  regionsFiles:
    type:
      type: array
      items: File
    inputBinding:
      position: 1
      prefix: --regionsFileName
    doc: |
      File [File ...], -R File [File ...]
      File name, in BED format, containing the regions to
      plot. If multiple bed files are given, each one is
      considered a group that can be plotted separately.
      Also, adding a "#" symbol in the bed file causes all
      the regions until the previous "#" to be considered
      one group. (default: None)
  scoreFiles:
    type:
      type: array
      items: File
    inputBinding:
      position: 1
      prefix: --scoreFileName
    doc: |
      File [File ...], -S File [File ...]
      bigWig file(s) containing the scores to be plotted.
      BigWig files can be obtained by using the bamCoverage
      or bamCompare tools. More information about the bigWig
      file format can be found at
      http://genome.ucsc.edu/goldenPath/help/bigWig.html
      (default: None)
  minThreshold:
    type: int?
    inputBinding:
      position: 1
      prefix: --minThreshold
    doc: |
      MINTHRESHOLD
      Numeric value. Any region containing a value that is
      less than or equal to this will be skipped. This is
      useful to skip, for example, genes where the read
      count is zero for any of the bins. This could be the
      result of unmappable areas and can bias the overall
      results. (default: None)
outputs:
  output_matrix_for_plotting:
    type: File?
    outputBinding:
      glob: $(inputs.outFileName)
   output_matrix_txt:
    type: File?
    outputBinding:
      glob: $(inputs.outFileNameMatrix)
baseCommand:
  - computeMatrix
  - reference-point
