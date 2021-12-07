part of charts;

/// Renders the 100% stacked bar series.
///
/// A StackedBar100Series is a chart series type designed to show the relative percentage of multiple data series in stacked bars,
///  where the total (cumulative) of each stacked bar always equals 100.
///
/// To render a 100% stacked bar chart, create an instance of StackedBar100Series, and add it to
///  the series collection property of [SfCartesianChart].
///
///Provides options to customize properties such as [color], [opacity],
///[borderWidth], [borderColor], [borderRadius] of the Stackedbar100 segments.
class StackedBar100Series<T, D> extends _StackedSeriesBase<T, D> {
  StackedBar100Series(
      {ValueKey<String> key,
      ChartSeriesRendererFactory<T, D> onCreateRenderer,
      @required List<T> dataSource,
      @required ChartValueMapper<T, D> xValueMapper,
      @required ChartValueMapper<T, num> yValueMapper,
      ChartValueMapper<T, dynamic> sortFieldValueMapper,
      ChartValueMapper<T, Color> pointColorMapper,
      ChartValueMapper<T, String> dataLabelMapper,
      SortingOrder sortingOrder,
      String groupName,
      String xAxisName,
      String yAxisName,
      String name,
      Color color,
      double width,
      double spacing,
      MarkerSettings markerSettings,
      EmptyPointSettings emptyPointSettings,
      DataLabelSettings dataLabelSettings,
      bool isVisible,
      LinearGradient gradient,
      LinearGradient borderGradient,
      BorderRadius borderRadius,
      bool enableTooltip,
      double animationDuration,
      List<Trendline> trendlines,
      Color borderColor,
      double borderWidth,
      SelectionSettings selectionSettings,
      bool isVisibleInLegend,
      LegendIconType legendIconType,
      String legendItemText,
      List<double> dashArray,
      double opacity,
      SeriesRendererCreatedCallback onRendererCreated,
      List<int> initialSelectedDataIndexes})
      : super(
            key: key,
            onCreateRenderer: onCreateRenderer,
            name: name,
            dashArray: dashArray,
            groupName: groupName,
            spacing: spacing,
            xValueMapper: xValueMapper,
            yValueMapper: yValueMapper,
            sortFieldValueMapper: sortFieldValueMapper,
            pointColorMapper: pointColorMapper,
            dataLabelMapper: dataLabelMapper,
            dataSource: dataSource,
            xAxisName: xAxisName,
            yAxisName: yAxisName,
            trendlines: trendlines,
            color: color,
            width: width ?? 0.7,
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
            borderRadius: borderRadius,
            selectionSettings: selectionSettings,
            legendItemText: legendItemText,
            isVisibleInLegend: isVisibleInLegend,
            legendIconType: legendIconType,
            sortingOrder: sortingOrder,
            opacity: opacity,
            onRendererCreated: onRendererCreated,
            initialSelectedDataIndexes: initialSelectedDataIndexes);

  // Create the stacked area series renderer.
  StackedBar100SeriesRenderer createRenderer(ChartSeries<T, D> series) {
    StackedBar100SeriesRenderer stackedBarSeriesRenderer;
    if (onCreateRenderer != null) {
      stackedBarSeriesRenderer = onCreateRenderer(series);
      assert(stackedBarSeriesRenderer != null,
          'This onCreateRenderer callback function should return value as extends from ChartSeriesRenderer class and should not be return value as null');
      return stackedBarSeriesRenderer;
    }
    return StackedBar100SeriesRenderer();
  }
}

/// Creates series renderer for Stacked bar 100 series
class StackedBar100SeriesRenderer extends _StackedSeriesRenderer {
  StackedBar100SeriesRenderer();

  num _rectPosition;
  num _rectCount;

  /// Stacked Bar segment is created here
  ChartSegment addSegment(CartesianChartPoint<dynamic> currentPoint,
      int pointIndex, int seriesIndex, num animateFactor) {
    final StackedBar100Segment segment = createSegment();
    final StackedBar100Series<dynamic, dynamic> _stackedBar100Series = _series;
    _isRectSeries = true;
    if (segment != null) {
      segment._seriesIndex = seriesIndex;
      segment.currentSegmentIndex = pointIndex;
      segment.seriesRenderer = this;
      segment.series = _stackedBar100Series;
      segment._currentPoint = currentPoint;
      segment.animationFactor = animateFactor;
      segment.path =
          _dashedBorder(currentPoint, _stackedBar100Series.borderWidth);
      segment.segmentRect = getRRectFromRect(
          currentPoint.region, _stackedBar100Series.borderRadius);
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

  @override
  ChartSegment createSegment() => StackedBar100Segment();

  @override
  void customizeSegment(ChartSegment segment) {
    final StackedBar100Segment bar100Segment = segment;
    bar100Segment._color = bar100Segment._currentPoint.pointColorMapper ??
        bar100Segment.seriesRenderer._seriesColor;
    bar100Segment._strokeColor = bar100Segment.series.borderColor;
    bar100Segment._strokeWidth = bar100Segment.series.borderWidth;
  }

  @override
  void drawDataLabel(int index, Canvas canvas, String dataLabel, double pointX,
          double pointY, int angle, TextStyle style) =>
      _drawText(canvas, dataLabel, Offset(pointX, pointY), style, angle);

  @override
  void drawDataMarker(int index, Canvas canvas, Paint fillPaint,
      Paint strokePaint, double pointX, double pointY,
      [CartesianSeriesRenderer seriesRenderer]) {
    canvas.drawPath(seriesRenderer._markerShapes[index], fillPaint);
    canvas.drawPath(seriesRenderer._markerShapes[index], strokePaint);
  }
}
