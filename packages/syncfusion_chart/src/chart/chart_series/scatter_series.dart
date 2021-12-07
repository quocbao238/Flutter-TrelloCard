part of charts;

/// Renders the scatter series.
///
/// To render a scatter chart, create an instance of ScatterSeries, and add it to the series collection property of [SfCartesianChart].
///
/// The following properties, such as [color], [opacity], [borderWidth], [borderColor] can be used to customize  the appearance of the scatter segment.

class ScatterSeries<T, D> extends XyDataSeries<T, D> {
  ScatterSeries(
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
      String name,
      Color color,
      MarkerSettings markerSettings,
      EmptyPointSettings emptyPointSettings,
      bool isVisible,
      DataLabelSettings dataLabelSettings,
      bool enableTooltip,
      List<Trendline> trendlines,
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
      : super(
            key: key,
            onCreateRenderer: onCreateRenderer,
            xValueMapper: xValueMapper,
            yValueMapper: yValueMapper,
            sortFieldValueMapper: sortFieldValueMapper,
            pointColorMapper: pointColorMapper,
            dataLabelMapper: dataLabelMapper,
            dataSource: dataSource,
            xAxisName: xAxisName,
            yAxisName: yAxisName,
            name: name,
            color: color,
            markerSettings: markerSettings,
            dataLabelSettings: dataLabelSettings,
            emptyPointSettings: emptyPointSettings,
            enableTooltip: enableTooltip,
            isVisible: isVisible,
            animationDuration: animationDuration,
            borderColor: borderColor,
            borderWidth: borderWidth,
            trendlines: trendlines,
            gradient: gradient,
            borderGradient: borderGradient,
            selectionSettings: selectionSettings,
            legendItemText: legendItemText,
            isVisibleInLegend: isVisibleInLegend,
            legendIconType: legendIconType,
            sortingOrder: sortingOrder,
            opacity: opacity,
            onRendererCreated: onRendererCreated,
            initialSelectedDataIndexes: initialSelectedDataIndexes);

  // Create the scatter series renderer.
  ScatterSeriesRenderer createRenderer(ChartSeries<T, D> series) {
    ScatterSeriesRenderer seriesRenderer;
    if (onCreateRenderer != null) {
      seriesRenderer = onCreateRenderer(series);
      assert(seriesRenderer != null,
          'This onCreateRenderer callback function should return value as extends from ChartSeriesRenderer class and should not be return value as null');
      return seriesRenderer;
    }
    return ScatterSeriesRenderer();
  }
}

/// Creates series renderer for Scatter series
class ScatterSeriesRenderer extends XyDataSeriesRenderer {
  ScatterSeriesRenderer();

  // ignore:unused_field
  CartesianChartPoint<dynamic> _point;

  final bool _isLineType = false;

  ///Adds the points to the segments .
  ChartSegment addSegment(CartesianChartPoint<dynamic> currentPoint,
      int pointIndex, int seriesIndex, num animateFactor) {
    final ScatterSegment segment = createSegment();
    final List<CartesianSeriesRenderer> _oldSeriesRenderers =
        _chart._chartState.oldSeriesRenderers;
    _isRectSeries = false;
    if (segment != null) {
      segment._seriesIndex = seriesIndex;
      segment.currentSegmentIndex = pointIndex;
      segment.seriesRenderer = this;
      segment.series = _series;
      segment.animationFactor = animateFactor;
      segment._point = currentPoint;
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
                segment._oldSeriesRenderer._segments[0] is ScatterSegment &&
                segment._oldSeriesRenderer._dataPoints.length - 1 >= pointIndex)
            ? segment._oldSeriesRenderer._dataPoints[pointIndex]
            : null;
      }
      final _ChartLocation location = _calculatePoint(
          currentPoint.xValue,
          currentPoint.yValue,
          _xAxis,
          _yAxis,
          _chart._requireInvertedAxis,
          _series,
          _chart._chartAxis._axisClipRect);
      segment.centerX = location.x;
      segment.centerY = location.y;
      segment.radius = _series.markerSettings.width;
      segment.segmentRect =
          RRect.fromRectAndRadius(currentPoint.region, Radius.zero);
      customizeSegment(segment);
      _segments.add(segment);
    }
    return segment;
  }

  void drawSegment(Canvas canvas, ChartSegment segment) {
    segment.onPaint(canvas);
  }

  /// Creates a segment for a data point in the series.
  @override
  ChartSegment createSegment() => ScatterSegment();

  /// Changes the series color, border color, and border width.
  @override
  void customizeSegment(ChartSegment segment) {
    final ScatterSegment scatterSegment = segment;
    scatterSegment._color = scatterSegment.seriesRenderer._seriesColor;
    scatterSegment._strokeColor = scatterSegment.series.borderColor ??
        scatterSegment.seriesRenderer._seriesColor;
    scatterSegment._strokeWidth =
        ((scatterSegment.series.markerSettings.shape ==
                        DataMarkerType.verticalLine ||
                    scatterSegment.series.markerSettings.shape ==
                        DataMarkerType.horizontalLine) &&
                scatterSegment.series.borderWidth == 0)
            ? scatterSegment.series.markerSettings.borderWidth
            : scatterSegment.series.borderWidth;
    scatterSegment.strokePaint = scatterSegment.getStrokePaint();
    scatterSegment.fillPaint = scatterSegment.getFillPaint();
  }

  ///Draws marker with different shape and color of the appropriate data point in the series.
  @override
  void drawDataMarker(int index, Canvas canvas, Paint fillPaint,
      Paint strokePaint, double pointX, double pointY,
      [CartesianSeriesRenderer seriesRenderer]) {
    final Size size =
        Size(_series.markerSettings.width, _series.markerSettings.height);
    final Path markerPath = _getMarkerShapes(_series.markerSettings.shape,
        Offset(pointX, pointY), size, seriesRenderer);
    canvas.drawPath(markerPath, fillPaint);
    canvas.drawPath(markerPath, strokePaint);
  }

  /// Draws data label text of the appropriate data point in a series.
  @override
  void drawDataLabel(int index, Canvas canvas, String dataLabel, double pointX,
          double pointY, int angle, TextStyle style) =>
      _drawText(canvas, dataLabel, Offset(pointX, pointY), style, angle);
}
