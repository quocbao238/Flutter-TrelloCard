part of charts;

/// This class has the properties of the column series.
///
/// To render a column chart, create an instance of [HistogramSeries], and add it to the series collection property of [SfCartesianChart].
/// The column series is a rectangular column with heights or lengths proportional to the values that they represent. it has the spacing
/// property to separate the column.
///
/// Provide the options of color, opacity, border color, and border width to customize the appearance.
///
class HistogramSeries<T, D> extends XyDataSeries<T, D> {
  HistogramSeries(
      {ValueKey<String> key,
      ChartSeriesRendererFactory<T, D> onCreateRenderer,
      @required List<T> dataSource,
      @required ChartValueMapper<T, num> yValueMapper,
      ChartValueMapper<T, dynamic> sortFieldValueMapper,
      ChartValueMapper<T, Color> pointColorMapper,
      ChartValueMapper<T, String> dataLabelMapper,
      SortingOrder sortingOrder,
      this.isTrackVisible = false,
      String xAxisName,
      String yAxisName,
      String name,
      Color color,
      double width,
      double spacing,
      MarkerSettings markerSettings,
      List<Trendline> trendlines,
      EmptyPointSettings emptyPointSettings,
      DataLabelSettings dataLabelSettings,
      bool isVisible,
      LinearGradient gradient,
      LinearGradient borderGradient,
      BorderRadius borderRadius,
      bool enableTooltip,
      double animationDuration,
      Color trackColor,
      Color trackBorderColor,
      double trackBorderWidth,
      double trackPadding,
      Color borderColor,
      double borderWidth,
      SelectionSettings selectionSettings,
      bool isVisibleInLegend,
      LegendIconType legendIconType,
      String legendItemText,
      double opacity,
      List<double> dashArray,
      this.binInterval,
      bool showNormalDistributionCurve,
      this.curveColor = Colors.blue,
      double curveWidth,
      this.curveDashArray,
      SeriesRendererCreatedCallback onRendererCreated})
      : trackColor = trackColor ?? Colors.grey,
        trackBorderColor = trackBorderColor ?? Colors.transparent,
        trackBorderWidth = trackBorderWidth ?? 1,
        trackPadding = trackPadding ?? 0,
        spacing = spacing ?? 0,
        borderRadius = borderRadius ?? const BorderRadius.all(Radius.zero),
        showNormalDistributionCurve = showNormalDistributionCurve ?? false,
        curveWidth = curveWidth ?? 2,
        super(
            key: key,
            onCreateRenderer: onCreateRenderer,
            name: name,
            yValueMapper: yValueMapper,
            sortFieldValueMapper: sortFieldValueMapper,
            pointColorMapper: pointColorMapper,
            dataLabelMapper: dataLabelMapper,
            dataSource: dataSource,
            xAxisName: xAxisName,
            yAxisName: yAxisName,
            trendlines: trendlines,
            color: color,
            width: width ?? 0.95,
            markerSettings: markerSettings,
            dataLabelSettings: dataLabelSettings,
            isVisible: isVisible,
            gradient: gradient,
            borderGradient: borderGradient,
            emptyPointSettings: emptyPointSettings,
            enableTooltip: enableTooltip,
            animationDuration: animationDuration,
            borderColor: borderColor,
            borderWidth: borderWidth,
            selectionSettings: selectionSettings,
            legendItemText: legendItemText,
            isVisibleInLegend: isVisibleInLegend,
            legendIconType: legendIconType,
            sortingOrder: sortingOrder,
            onRendererCreated: onRendererCreated,
            opacity: opacity,
            dashArray: dashArray);

  ///Interval value by which the data points are grouped and rendered as bars, in histogram series.
  ///
  ///For example, if the [binInterval] is set to 20, the x-axis will split with 20 as the interval.
  /// The first bar in the histogram represents the count of values lying between 0 to 20
  ///  in the provided data and the second bar will represent 20 to 40.
  ///
  ///If no value is specified for this property, then the interval will be calculated
  /// automatically based on the data points count and value.
  ///
  ///Defaults to `null`
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///            selectionGesture: ActivationMode.doubleTap,
  ///            series: <HistogramSeries<SalesData, num>>[
  ///                HistogramSeries<SalesData, num>(
  ///                   binInterval: 4
  ///                ),
  ///              ],
  ///        ));
  ///}
  ///```
  final int binInterval;

  ///Renders a spline curve for the normal distribution, calculated based on the series data points.
  ///
  ///This spline curve type can be changed using the [splineType] property.
  ///
  ///Defaults to `false`
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///            selectionGesture: ActivationMode.doubleTap,
  ///            series: <HistogramSeries<SalesData, num>>[
  ///                HistogramSeries<SalesData, num>(
  ///                   showNormalDistributionCurve: true
  ///                ),
  ///              ],
  ///        ));
  ///}
  ///```
  final bool showNormalDistributionCurve;

  ///Color of the normal distribution spline curve.
  ///
  ///Defaults to `Colors.blue`
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///            selectionGesture: ActivationMode.doubleTap,
  ///            series: <HistogramSeries<SalesData, num>>[
  ///                HistogramSeries<SalesData, num>(
  ///                   curveColor: Colors.red
  ///                ),
  ///              ],
  ///        ));
  ///}
  ///```
  final Color curveColor;

  ///Width of the normal distribution spline curve.
  ///
  ///Defaults to `2`
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///            selectionGesture: ActivationMode.doubleTap,
  ///            series: <HistogramSeries<SalesData, num>>[
  ///                HistogramSeries<SalesData, num>(
  ///                   curveWidth: 4
  ///                ),
  ///              ],
  ///        ));
  ///}
  ///```
  final double curveWidth;

  ///Dash array of the normal distribution spline curve.
  ///
  ///Defaults to `null`
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///            selectionGesture: ActivationMode.doubleTap,
  ///            series: <HistogramSeries<SalesData, num>>[
  ///                HistogramSeries<SalesData, num>(
  ///                   curveDashArray: [2, 3]
  ///                ),
  ///              ],
  ///        ));
  ///}
  ///```
  final List<double> curveDashArray;

  ///Color of the track.
  ///
  ///Defaults to `Colors.grey`
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///            selectionGesture: ActivationMode.doubleTap,
  ///            series: <HistogramSeries<SalesData, num>>[
  ///                HistogramSeries<SalesData, num>(
  ///                  isTrackVisible: true,
  ///                  trackColor: Colors.red
  ///                ),
  ///              ],
  ///        ));
  ///}
  ///```
  final Color trackColor;

  ///Color of the track border.
  ///
  ///Defaults to `Colors.transparent`
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///            selectionGesture: ActivationMode.doubleTap,
  ///            series: <HistogramSeries<SalesData, num>>[
  ///                HistogramSeries<SalesData, num>(
  ///                  isTrackVisible: true,
  ///                  trackBorderColor: Colors.red
  ///                ),
  ///              ],
  ///        ));
  ///}
  ///```
  final Color trackBorderColor;

  ///Width of the track border.
  ///
  ///Defaults to `1`
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///            selectionGesture: ActivationMode.doubleTap,
  ///            series: <HistogramSeries<SalesData, num>>[
  ///                HistogramSeries<SalesData, num>(
  ///                  isTrackVisible: true,
  ///                  trackBorderColor: Colors.red ,
  ///                  trackBorderWidth: 2
  ///                ),
  ///              ],
  ///        ));
  ///}
  ///```
  final double trackBorderWidth;

  ///Padding of the track.
  ///
  ///By default, track will be rendered based on the bar’s available width and spacing.
  /// If you wish to change the track width, you can use this property.
  ///
  ///Defaults to `0`
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///            selectionGesture: ActivationMode.doubleTap,
  ///            series: <HistogramSeries<SalesData, num>>[
  ///                HistogramSeries<SalesData, num>(
  ///                  isTrackVisible: true,
  ///                  trackPadding: 2
  ///                ),
  ///              ],
  ///        ));
  ///}
  ///```
  final double trackPadding;

  ///Spacing between the bars in histogram series.
  ///
  ///The value ranges from 0 to 1. 1 represents 100% and 0 represents 0% of the available space.
  ///
  ///Spacing also affects the width of the bar. For example, setting 20% spacing
  ///and 100% width renders the bar with 80% of total width.
  ///
  ///Defaults to `0`
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///            selectionGesture: ActivationMode.doubleTap,
  ///            series: <HistogramSeries<SalesData, num>>[
  ///                HistogramSeries<SalesData, num>(
  ///                  spacing: 0,
  ///                ),
  ///              ],
  ///        ));
  ///}
  ///```
  final double spacing;

  ///Renders the bar in histogram series with track.
  ///
  ///Track is a rectangular bar rendered from the start to the end of the axis.
  /// Bars in the histogram will be rendered above the track.
  ///
  ///Defaults to `false`
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///            selectionGesture: ActivationMode.doubleTap,
  ///            series: <HistogramSeries<SalesData, num>>[
  ///                HistogramSeries<SalesData, num>(
  ///                  isTrackVisible: true,
  ///                ),
  ///              ],
  ///        ));
  ///}
  ///```
  final bool isTrackVisible;

  ///Customizes the corners of the bars in histogram series.
  ///
  ///Each corner can be customized individually or can be customized together, by specifying a single value.
  ///
  ///Defaults to `Radius.zero`
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///            selectionGesture: ActivationMode.doubleTap,
  ///            series: <HistogramSeries<SalesData, num>>[
  ///                HistogramSeries<SalesData, num>(
  ///                  borderRadius: BorderRadius.circular(5),
  ///                ),
  ///              ],
  ///        ));
  ///}
  ///```
  final BorderRadius borderRadius;

  // Create the Histogram series renderer.
  HistogramSeriesRenderer createRenderer(ChartSeries<T, D> series) {
    HistogramSeriesRenderer seriesRenderer;
    if (onCreateRenderer != null) {
      seriesRenderer = onCreateRenderer(series);
      assert(seriesRenderer != null,
          'This onCreateRenderer callback function should return value as extends from ChartSeriesRenderer class and should not be return value as null');
      return seriesRenderer;
    }
    return HistogramSeriesRenderer();
  }
}

class _HistogramValues {
  _HistogramValues(
      {this.sDValue, this.mean, this.binWidth, this.yValues, this.minValue});
  num sDValue;
  num mean;
  num binWidth;
  num minValue;
  List<num> yValues = <num>[];
}

/// Creates series renderer for Histogram series
class HistogramSeriesRenderer extends XyDataSeriesRenderer {
  num _rectPosition;
  num _rectCount;
  _HistogramValues _histogramValues;

  /// To get the proper data for histogram series
  void _processData(HistogramSeries<dynamic, dynamic> series, List<num> yValues,
      num yValuesCount) {
    _histogramValues = _HistogramValues();
    _histogramValues.yValues = yValues;
    final num mean = yValuesCount / _histogramValues.yValues.length;
    _histogramValues.mean = mean;
    num sumValue = 0;
    dynamic sDValue;
    for (int value = 0; value < _histogramValues.yValues.length; value++) {
      sumValue += (_histogramValues.yValues[value] - _histogramValues.mean) *
          (_histogramValues.yValues[value] - _histogramValues.mean);
    }
    sDValue = math.sqrt(sumValue / _histogramValues.yValues.length - 1).isNaN
        ? 0
        : (math.sqrt(sumValue / _histogramValues.yValues.length - 1)).round();
    _histogramValues.sDValue = sDValue;
  }

  /// Find the path for distribution line in the histogram
  Path _findNormalDistributionPath(
      HistogramSeries<dynamic, dynamic> series, SfCartesianChart chart) {
    final num min = _xAxis._visibleRange.minimum;
    final num max = _xAxis._visibleRange.maximum;
    num xValue, yValue;
    final Path path = Path();
    _ChartLocation pointLocation;
    const num pointsCount = 500;
    final num del = (max - min) / (pointsCount - 1);
    for (int i = 0; i < pointsCount; i++) {
      xValue = min + i * del;
      yValue = math.exp(-(xValue - _histogramValues.mean) *
              (xValue - _histogramValues.mean) /
              (2 * _histogramValues.sDValue * _histogramValues.sDValue)) /
          (_histogramValues.sDValue * math.sqrt(2 * math.pi));
      pointLocation = _calculatePoint(
          xValue,
          yValue * _histogramValues.binWidth * _histogramValues.yValues.length,
          _xAxis,
          _yAxis,
          _chart._requireInvertedAxis,
          series,
          _chart._chartAxis._axisClipRect);
      i == 0
          ? path.moveTo(pointLocation.x, pointLocation.y)
          : path.lineTo(pointLocation.x, pointLocation.y);
    }
    return path;
  }

  ChartSegment addSegment(
      CartesianChartPoint<dynamic> currentPoint,
      int pointIndex,
      _VisibleRange sideBySideInfo,
      int seriesIndex,
      num animateFactor) {
    final HistogramSegment segment = createSegment();
    final List<CartesianSeriesRenderer> _oldSeriesRenderers =
        _chart._chartState.oldSeriesRenderers;
    final HistogramSeries<dynamic, dynamic> _histogramSeries = _series;
    final BorderRadius borderRadius = _histogramSeries.borderRadius;
    segment.seriesRenderer = this;
    segment.series = _histogramSeries;
    segment._chart = _chart;
    segment._seriesIndex = seriesIndex;
    segment.currentSegmentIndex = pointIndex;
    segment.animationFactor = animateFactor;
    final num origin = math.max(_yAxis._visibleRange.minimum, 0);
    currentPoint.region = _calculateRectangle(
        currentPoint.xValue + sideBySideInfo.minimum,
        currentPoint.yValue,
        currentPoint.xValue + sideBySideInfo.maximum,
        math.max(_yAxis._visibleRange.minimum, 0),
        this,
        _chart);
    segment._currentPoint = currentPoint;
    if (_chart._chartState.widgetNeedUpdate &&
        !_chart._chartState._isLegendToggled &&
        _oldSeriesRenderers != null &&
        _oldSeriesRenderers.isNotEmpty &&
        _oldSeriesRenderers.length - 1 >= segment._seriesIndex &&
        _oldSeriesRenderers[segment._seriesIndex]._seriesName ==
            segment.seriesRenderer._seriesName) {
      segment._oldSeriesRenderer = _oldSeriesRenderers[segment._seriesIndex];
      segment._oldPoint = (segment._oldSeriesRenderer._segments.isNotEmpty &&
              segment._oldSeriesRenderer._segments[0] is HistogramSegment &&
              segment._oldSeriesRenderer._dataPoints.length - 1 >= pointIndex)
          ? segment._oldSeriesRenderer._dataPoints[pointIndex]
          : null;
    } else if (_chart._chartState._isLegendToggled &&
        _chart._chartState.segments != null &&
        _chart._chartState.segments.isNotEmpty) {
      segment._oldSeriesVisible =
          _chart._chartState._oldSeriesVisible[segment._seriesIndex];
      for (int i = 0; i < _chart._chartState.segments.length; i++) {
        final ChartSegment oldSegment = _chart._chartState.segments[i];
        if (oldSegment.currentSegmentIndex == segment.currentSegmentIndex &&
            oldSegment._seriesIndex == segment._seriesIndex) {
          segment._oldRegion = oldSegment.segmentRect.outerRect;
        }
      }
    }
    segment.path = _dashedBorder(currentPoint, _histogramSeries.borderWidth);
    if (borderRadius != null) {
      segment.segmentRect = getRRectFromRect(currentPoint.region, borderRadius);
    }
    //Tracker rect
    if (_histogramSeries.isTrackVisible) {
      currentPoint.trackerRectRegion = _calculateShadowRectangle(
          currentPoint.xValue + sideBySideInfo.minimum,
          currentPoint.yValue,
          currentPoint.xValue + sideBySideInfo.maximum,
          origin,
          this,
          _chart,
          Offset(segment.seriesRenderer._xAxis?.plotOffset,
              segment.seriesRenderer._yAxis?.plotOffset));
      if (borderRadius != null) {
        segment._trackRect =
            getRRectFromRect(currentPoint.trackerRectRegion, borderRadius);
      }
    }
    customizeSegment(segment);
    _segments.add(segment);
    return segment;
  }

  void drawSegment(Canvas canvas, ChartSegment segment) {
    segment.onPaint(canvas);
  }

  /// Creates a segment for a data point in the series.
  @override
  ChartSegment createSegment() => HistogramSegment();

  /// Changes the series color, border color, and border width.
  @override
  void customizeSegment(ChartSegment segment) {
    final HistogramSegment histogramSegment = segment;
    histogramSegment._color = histogramSegment._currentPoint.pointColorMapper ??
        segment.seriesRenderer._seriesColor;
    histogramSegment._strokeColor = segment.series.borderColor;
    histogramSegment._strokeWidth = segment.series.borderWidth;
    histogramSegment.strokePaint = histogramSegment.getStrokePaint();
    histogramSegment.fillPaint = histogramSegment.getFillPaint();
    histogramSegment._trackerFillPaint =
        histogramSegment._getTrackerFillPaint();
    histogramSegment._trackerStrokePaint =
        histogramSegment._getTrackerStrokePaint();
  }

  ///Draws marker with different shape and color of the appropriate data point in the series.
  @override
  void drawDataMarker(int index, Canvas canvas, Paint fillPaint,
      Paint strokePaint, double pointX, double pointY,
      [CartesianSeriesRenderer seriesRenderer]) {
    canvas.drawPath(seriesRenderer._markerShapes[index], fillPaint);
    canvas.drawPath(seriesRenderer._markerShapes[index], strokePaint);
  }

  /// Draws data label text of the appropriate data point in a series.
  @override
  void drawDataLabel(int index, Canvas canvas, String dataLabel, double pointX,
          double pointY, int angle, TextStyle style) =>
      _drawText(canvas, dataLabel, Offset(pointX, pointY), style, angle);
}
