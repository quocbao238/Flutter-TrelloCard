part of charts;

/// Renders the line series.
///
/// This class holds the properties of line series. To render a Line chart,
/// create an instance of [LineSeries], and add it to the series collection
/// property of [SfCartesianChart]. A line chart requires two fields (X and Y)
/// to plot a point.
///
/// Provide the options for color, opacity, border color, and border width to customize the appearance.
class LineSeries<T, D> extends XyDataSeries<T, D> {
  LineSeries(
      {ValueKey<String> key,
      ChartSeriesRendererFactory<T, D> onCreateRenderer,
      @required List<T> dataSource,
      @required ChartValueMapper<T, D> xValueMapper,
      @required ChartValueMapper<T, num> yValueMapper,
      ChartValueMapper<T, dynamic> sortFieldValueMapper,
      ChartValueMapper<T, Color> pointColorMapper,
      ChartValueMapper<T, String> dataLabelMapper,
      String xAxisName,
      String yAxisName,
      Color color,
      double width,
      MarkerSettings markerSettings,
      EmptyPointSettings emptyPointSettings,
      DataLabelSettings dataLabelSettings,
      List<Trendline> trendlines,
      bool isVisible,
      String name,
      bool enableTooltip,
      List<double> dashArray,
      double animationDuration,
      SelectionSettings selectionSettings,
      bool isVisibleInLegend,
      LegendIconType legendIconType,
      SortingOrder sortingOrder,
      String legendItemText,
      double opacity,
      List<int> initialSelectedDataIndexes,
      SeriesRendererCreatedCallback onRendererCreated})
      : super(
            key: key,
            onRendererCreated: onRendererCreated,
            onCreateRenderer: onCreateRenderer,
            name: name,
            xValueMapper: xValueMapper,
            yValueMapper: yValueMapper,
            sortFieldValueMapper: sortFieldValueMapper,
            pointColorMapper: pointColorMapper,
            dataLabelMapper: dataLabelMapper,
            dataSource: dataSource,
            xAxisName: xAxisName,
            yAxisName: yAxisName,
            color: color,
            width: width ?? 2,
            markerSettings: markerSettings,
            emptyPointSettings: emptyPointSettings,
            trendlines: trendlines,
            dataLabelSettings: dataLabelSettings,
            isVisible: isVisible,
            enableTooltip: enableTooltip,
            dashArray: dashArray,
            animationDuration: animationDuration,
            selectionSettings: selectionSettings,
            legendItemText: legendItemText,
            isVisibleInLegend: isVisibleInLegend,
            legendIconType: legendIconType,
            sortingOrder: sortingOrder,
            opacity: opacity,
            initialSelectedDataIndexes: initialSelectedDataIndexes);

  // Create the line series renderer.
  LineSeriesRenderer createRenderer(ChartSeries<T, D> series) {
    LineSeriesRenderer seriesRenderer;
    if (onCreateRenderer != null) {
      seriesRenderer = onCreateRenderer(series);
      assert(seriesRenderer != null,
          'This onCreateRenderer callback function should return value as extends from ChartSeriesRenderer class and should not be return value as null');
      return seriesRenderer;
    }
    return LineSeriesRenderer();
  }
}

/// Creates series renderer for Line series
class LineSeriesRenderer extends XyDataSeriesRenderer {
  LineSeriesRenderer();

  LineSegment _lineSegment, _segment;

  List<CartesianSeriesRenderer> _oldSeriesRenderers;

  ChartSegment addSegment(
      CartesianChartPoint<dynamic> currentPoint,
      CartesianChartPoint<dynamic> _nextPoint,
      int pointIndex,
      int seriesIndex,
      num animateFactor) {
    _segment = createSegment();
    _oldSeriesRenderers = _chart._chartState.oldSeriesRenderers;
    _segment.series = _series;
    _segment.seriesRenderer = this;
    _segment._seriesIndex = seriesIndex;
    _segment._currentPoint = currentPoint;
    _segment.currentSegmentIndex = pointIndex;
    _segment._nextPoint = _nextPoint;
    _segment._chart = _chart;
    _segment.animationFactor = animateFactor;
    _segment._pointColorMapper = currentPoint.pointColorMapper;
    if (_chart._chartState.widgetNeedUpdate &&
        _oldSeriesRenderers != null &&
        _oldSeriesRenderers.isNotEmpty &&
        _oldSeriesRenderers.length - 1 >= _segment._seriesIndex &&
        _oldSeriesRenderers[_segment._seriesIndex]._seriesName ==
            _segment.seriesRenderer._seriesName) {
      _segment._oldSeriesRenderer = _oldSeriesRenderers[_segment._seriesIndex];
    }
    _segment.calculateSegmentPoints();
    customizeSegment(_segment);
    _segments.add(_segment);
    return _segment;
  }

  void drawSegment(Canvas canvas, ChartSegment _segment) {
    _segment.onPaint(canvas);
  }

  /// Creates a _segment for a data point in the series.
  @override
  ChartSegment createSegment() => LineSegment();

  /// Changes the series color, border color, and border width.
  @override
  void customizeSegment(ChartSegment _segment) {
    _lineSegment = _segment;
    _lineSegment._color = _lineSegment._pointColorMapper ??
        _lineSegment.series.color ??
        _lineSegment.seriesRenderer._seriesColor;
    _lineSegment._strokeColor = _lineSegment._pointColorMapper ??
        _lineSegment.series.color ??
        _lineSegment.seriesRenderer._seriesColor;
    _lineSegment._strokeWidth = _lineSegment.series.width;
    _lineSegment.strokePaint = _lineSegment.getStrokePaint();
    _lineSegment.fillPaint = _lineSegment.getFillPaint();
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
