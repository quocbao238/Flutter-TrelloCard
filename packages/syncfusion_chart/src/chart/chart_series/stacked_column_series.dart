part of charts;

/// Renders the stacked column series.
///
/// In a stacked column chart, data series are stacked one on top of the other in vertical columns..
///
/// To render a stacked column chart, create an instance of StackedColumnSeries,
/// and add it to the series collection property of [SfCartesianChart].
///
///Provides options to customize properties such as [color], [opacity],
///[borderWidth], [borderColor], [borderRadius] of the Stackedcolumn segemnts.
class StackedColumnSeries<T, D> extends _StackedSeriesBase<T, D> {
  StackedColumnSeries(
      {ValueKey<String> key,
      ChartSeriesRendererFactory<T, D> onCreateRenderer,
      @required List<T> dataSource,
      @required ChartValueMapper<T, D> xValueMapper,
      @required ChartValueMapper<T, num> yValueMapper,
      ChartValueMapper<T, dynamic> sortFieldValueMapper,
      ChartValueMapper<T, Color> pointColorMapper,
      ChartValueMapper<T, String> dataLabelMapper,
      SortingOrder sortingOrder,
      bool isTrackVisible,
      String groupName,
      String xAxisName,
      String yAxisName,
      List<Trendline> trendlines,
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
            trendlines: trendlines,
            dataLabelMapper: dataLabelMapper,
            dataSource: dataSource,
            xAxisName: xAxisName,
            isTrackVisible: isTrackVisible,
            trackColor: trackColor,
            trackBorderColor: trackBorderColor,
            trackBorderWidth: trackBorderWidth,
            trackPadding: trackPadding,
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
  StackedColumnSeriesRenderer createRenderer(ChartSeries<T, D> series) {
    StackedColumnSeriesRenderer stackedAreaSeriesRenderer;
    if (onCreateRenderer != null) {
      stackedAreaSeriesRenderer = onCreateRenderer(series);
      assert(stackedAreaSeriesRenderer != null,
          'This onCreateRenderer callback function should return value as extends from ChartSeriesRenderer class and should not be return value as null');
      return stackedAreaSeriesRenderer;
    }
    return StackedColumnSeriesRenderer();
  }
}

/// Creates series renderer for Stacked column series
class StackedColumnSeriesRenderer extends _StackedSeriesRenderer {
  StackedColumnSeriesRenderer();
  num _rectPosition;
  num _rectCount;

  /// Stacked Bar segment is created here.
  ChartSegment addSegment(CartesianChartPoint<dynamic> currentPoint,
      int pointIndex, int seriesIndex, num animateFactor) {
    final StackedColumnSegment segment = createSegment();
    final StackedColumnSeries<dynamic, dynamic> _stackedColumnSeries = _series;
    _isRectSeries = true;
    if (segment != null) {
      segment._seriesIndex = seriesIndex;
      segment.currentSegmentIndex = pointIndex;
      segment.seriesRenderer = this;
      segment.series = _stackedColumnSeries;
      segment._currentPoint = currentPoint;
      segment.animationFactor = animateFactor;
      segment.path =
          _dashedBorder(currentPoint, _stackedColumnSeries.borderWidth);
      segment.segmentRect = getRRectFromRect(
          currentPoint.region, _stackedColumnSeries.borderRadius);

      //Tracker rect
      if (_stackedColumnSeries.isTrackVisible) {
        segment._trackRect = getRRectFromRect(
            currentPoint.trackerRectRegion, _stackedColumnSeries.borderRadius);
        segment._trackerFillPaint = segment._getTrackerFillPaint();
        segment._trackerStrokePaint = segment._getTrackerStrokePaint();
      }
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
  ChartSegment createSegment() => StackedColumnSegment();

  @override
  void customizeSegment(ChartSegment segment) {
    segment._color = segment.seriesRenderer._seriesColor;
    segment._strokeColor = segment.series.borderColor;
    segment._strokeWidth = segment.series.borderWidth;
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
