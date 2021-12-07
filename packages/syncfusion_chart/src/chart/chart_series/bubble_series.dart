part of charts;

/// This class holds the properties of the bubble series.
///
/// To render a bubble chart, create an instance of [BubbleSeries], and add it to the series collection property of [SfCartesianChart].
/// A bubble chart requires three fields (X, Y, and Size) to plot a point. Here, [sizeValueMapper] is used to map the size of each bubble segment from the data source.
///
/// Provide the options for color, opacity, border color, and border width to customize the appearance.
///
class BubbleSeries<T, D> extends XyDataSeries<T, D> {
  BubbleSeries(
      {ValueKey<String> key,
      ChartSeriesRendererFactory<T, D> onCreateRenderer,
      @required List<T> dataSource,
      @required ChartValueMapper<T, D> xValueMapper,
      @required ChartValueMapper<T, num> yValueMapper,
      ChartValueMapper<T, dynamic> sortFieldValueMapper,
      ChartValueMapper<T, num> sizeValueMapper,
      ChartValueMapper<T, Color> pointColorMapper,
      ChartValueMapper<T, String> dataLabelMapper,
      String xAxisName,
      String yAxisName,
      Color color,
      MarkerSettings markerSettings,
      List<Trendline> trendlines,
      num minimumRadius,
      num maximumRadius,
      EmptyPointSettings emptyPointSettings,
      DataLabelSettings dataLabelSettings,
      bool isVisible,
      String name,
      bool enableTooltip,
      List<double> dashArray,
      double animationDuration,
      Color borderColor,
      double borderWidth,
      LinearGradient gradient,
      LinearGradient borderGradient,
      SelectionSettings selectionSettings,
      bool isVisibleInLegend,
      LegendIconType legendIconType,
      SortingOrder sortingOrder,
      String legendItemText,
      double opacity,
      SeriesRendererCreatedCallback onRendererCreated,
      List<int> initialSelectedDataIndexes})
      : minimumRadius = minimumRadius ?? 3,
        maximumRadius = maximumRadius ?? 10,
        super(
            key: key,
            onCreateRenderer: onCreateRenderer,
            name: name,
            onRendererCreated: onRendererCreated,
            xValueMapper: xValueMapper,
            yValueMapper: yValueMapper,
            sortFieldValueMapper: sortFieldValueMapper,
            pointColorMapper: pointColorMapper,
            dataLabelMapper: dataLabelMapper,
            sizeValueMapper: sizeValueMapper,
            dataSource: dataSource,
            trendlines: trendlines,
            xAxisName: xAxisName,
            yAxisName: yAxisName,
            color: color,
            markerSettings: markerSettings,
            emptyPointSettings: emptyPointSettings,
            dataLabelSettings: dataLabelSettings,
            isVisible: isVisible,
            enableTooltip: enableTooltip,
            dashArray: dashArray,
            animationDuration: animationDuration,
            borderColor: borderColor,
            borderWidth: borderWidth,
            gradient: gradient,
            borderGradient: borderGradient,
            selectionSettings: selectionSettings,
            legendItemText: legendItemText,
            isVisibleInLegend: isVisibleInLegend,
            legendIconType: legendIconType,
            sortingOrder: sortingOrder,
            opacity: opacity,
            initialSelectedDataIndexes: initialSelectedDataIndexes);

  ///Maximum radius value of the bubble in the series.
  ///
  ///Defaults to `10`
  ///
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///            selectionGesture: ActivationMode.doubleTap,
  ///            series: <BubbleSeries<BubbleColors, num>>[
  ///                BubbleSeries<BubbleColors, num>(
  ///                  maximumRadius: 9
  ///                ),
  ///              ],
  ///        ));
  ///}
  ///```
  final num maximumRadius;

  ///Minimum radius value of the bubble in the series.
  ///
  ///Defaults to `3`
  ///
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///            selectionGesture: ActivationMode.doubleTap,
  ///            series: <BubbleSeries<BubbleColors, num>>[
  ///                BubbleSeries<BubbleColors, num>(
  ///                  minimumRadius: 2
  ///                ),
  ///              ],
  ///        ));
  ///}
  ///```
  final num minimumRadius;

  // Create the bubble series renderer.
  BubbleSeriesRenderer createRenderer(ChartSeries<T, D> series) {
    BubbleSeriesRenderer seriesRenderer;
    if (onCreateRenderer != null) {
      seriesRenderer = onCreateRenderer(series);
      assert(seriesRenderer != null,
          'This onCreateRenderer callback function should return value as extends from ChartSeriesRenderer class and should not be return value as null');
      return seriesRenderer;
    }
    return BubbleSeriesRenderer();
  }
}

/// Creates series renderer for Bubble series
class BubbleSeriesRenderer extends XyDataSeriesRenderer {
  BubbleSeriesRenderer();

  // Store the maximum size //
  num _maxSize;

  // Store the minimum size //
  num _minSize;

  ChartSegment addSegment(CartesianChartPoint<dynamic> currentPoint,
      int pointIndex, int seriesIndex, num animateFactor) {
    final BubbleSegment segment = createSegment();
    final List<CartesianSeriesRenderer> _oldSeriesRenderers =
        _chart._chartState.oldSeriesRenderers;
    _isRectSeries = false;
    if (segment != null) {
      segment._seriesIndex = seriesIndex;
      segment.currentSegmentIndex = pointIndex;
      segment._seriesIndex = seriesIndex;
      segment.series = _series;
      segment.animationFactor = animateFactor;
      segment._currentPoint = currentPoint;
      segment.seriesRenderer = this;
      if (_chart._chartState.widgetNeedUpdate &&
          _oldSeriesRenderers != null &&
          _oldSeriesRenderers.isNotEmpty &&
          _oldSeriesRenderers.length - 1 >= segment._seriesIndex &&
          _oldSeriesRenderers[segment._seriesIndex]._seriesName ==
              segment.seriesRenderer._seriesName) {
        segment._oldSeriesRenderer = _oldSeriesRenderers[segment._seriesIndex];
        segment._oldPoint =
            (segment._oldSeriesRenderer._dataPoints.length - 1 >= pointIndex)
                ? segment._oldSeriesRenderer._dataPoints[pointIndex]
                : null;
      }
      segment.calculateSegmentPoints();
      customizeSegment(segment);
      segment.strokePaint = segment.getStrokePaint();
      segment.fillPaint = segment.getFillPaint();
      _segments.add(segment);
    }
    return segment;
  }

  void drawSegment(Canvas canvas, ChartSegment segment) {
    segment.onPaint(canvas);
  }

  /// Creates a segment for a data point in the series.
  @override
  ChartSegment createSegment() => BubbleSegment();

  /// Changes the series color, border color, and border width.
  @override
  void customizeSegment(ChartSegment segment) {
    final BubbleSegment bubbleSegment = segment;
    bubbleSegment._color = bubbleSegment.seriesRenderer._seriesColor;
    bubbleSegment._strokeColor = bubbleSegment.series.borderColor ??
        bubbleSegment.seriesRenderer._seriesColor;
    bubbleSegment._strokeWidth = bubbleSegment.series.borderWidth;
    bubbleSegment.strokePaint = bubbleSegment.getStrokePaint();
    bubbleSegment.fillPaint = bubbleSegment.getFillPaint();
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
