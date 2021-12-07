part of charts;

/// Renders the 100% stacked column series.
///
/// A stackedcolumn100 is an  chart series type meant to show the relative
/// percentage of multiple data series in stacked columns, where the total (cumulative) of stacked columns always equals 100%.
///
/// To render a 100% stacked column chart, create an instance of StackedColumn100Series,
///  and add it to the series collection property of [SfCartesianChart].
///
///Provides options to customize properties such as [color], [opacity],
///[borderWidth], [borderColor], [borderRadius] of the StackedColumn100 segemnts.
class StackedColumn100Series<T, D> extends _StackedSeriesBase<T, D> {
  StackedColumn100Series(
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
      List<Trendline> trendlines,
      EmptyPointSettings emptyPointSettings,
      DataLabelSettings dataLabelSettings,
      bool isVisible,
      LinearGradient gradient,
      LinearGradient borderGradient,
      BorderRadius borderRadius,
      bool enableTooltip,
      double animationDuration,
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
            trendlines: trendlines,
            xAxisName: xAxisName,
            yAxisName: yAxisName,
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
  StackedColumn100SeriesRenderer createRenderer(ChartSeries<T, D> series) {
    StackedColumn100SeriesRenderer stackedAreaSeriesRenderer;
    if (onCreateRenderer != null) {
      stackedAreaSeriesRenderer = onCreateRenderer(series);
      assert(stackedAreaSeriesRenderer != null,
          'This onCreateRenderer callback function should return value as extends from ChartSeriesRenderer class and should not be return value as null');
      return stackedAreaSeriesRenderer;
    }
    return StackedColumn100SeriesRenderer();
  }
}

/// Creates series renderer for Stacked column 100 series
class StackedColumn100SeriesRenderer extends _StackedSeriesRenderer {
  StackedColumn100SeriesRenderer();

  num _rectPosition;
  num _rectCount;

  /// Stacked Column 100 segment is created here
  ChartSegment addSegment(CartesianChartPoint<dynamic> currentPoint,
      int pointIndex, int seriesIndex, num animateFactor) {
    final StackedColumn100Segment segment = createSegment();
    final StackedColumn100Series<dynamic, dynamic> _stackedColumn100Series =
        _series;
    _isRectSeries = true;
    if (segment != null) {
      segment._seriesIndex = seriesIndex;
      segment.currentSegmentIndex = pointIndex;
      segment.seriesRenderer = this;
      segment.series = _stackedColumn100Series;
      segment._currentPoint = currentPoint;
      segment.animationFactor = animateFactor;
      segment.path =
          _dashedBorder(currentPoint, _stackedColumn100Series.borderWidth);
      segment.segmentRect = getRRectFromRect(
          currentPoint.region, _stackedColumn100Series.borderRadius);
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
  ChartSegment createSegment() => StackedColumn100Segment();

  @override
  void customizeSegment(ChartSegment segment) {
    final StackedColumn100Segment column100Segment = segment;
    column100Segment._color = column100Segment._currentPoint.pointColorMapper ??
        column100Segment.seriesRenderer._seriesColor;
    column100Segment._strokeColor = column100Segment.series.borderColor;
    column100Segment._strokeWidth = column100Segment.series.borderWidth;
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
