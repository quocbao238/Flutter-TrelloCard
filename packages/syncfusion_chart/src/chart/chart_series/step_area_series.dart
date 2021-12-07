part of charts;

/// Renders the step area series.
///
///A step area chart is a form of area chart which is useful for displaying changing numeric values over a period of time.
///
///The x-axis in a step area chart represents a period of time,
///and values are plotted on the  y-axis at constant or irregular time intervals.
///
///Step area charts are similar to step line charts, except in a step area chart
///the area occupied by the data series is filled in with color.
///
///To render a spline area chart, create an instance of StepAreaSeries, and add it to the series collection property of [SfCartesianChart].
///
///Provides options to customize the [color], [opacity], [width] of the StepArea segments.
class StepAreaSeries<T, D> extends XyDataSeries<T, D> {
  StepAreaSeries(
      {ValueKey<String> key,
      ChartSeriesRendererFactory<T, D> onCreateRenderer,
      @required List<T> dataSource,
      @required ChartValueMapper<T, D> xValueMapper,
      @required ChartValueMapper<T, num> yValueMapper,
      ChartValueMapper<T, dynamic> sortFieldValueMapper,
      ChartValueMapper<T, Color> pointColorMapper,
      ChartValueMapper<T, String> dataLabelMapper,
      SortingOrder sortingOrder,
      String xAxisName,
      String yAxisName,
      String name,
      Color color,
      MarkerSettings markerSettings,
      List<Trendline> trendlines,
      EmptyPointSettings emptyPointSettings,
      DataLabelSettings dataLabelSettings,
      bool isVisible,
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
      String legendItemText,
      double opacity,
      SeriesRendererCreatedCallback onRendererCreated,
      BorderDrawMode borderDrawMode})
      : borderDrawMode = borderDrawMode ?? BorderDrawMode.top,
        super(
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
            trendlines: trendlines,
            color: color,
            markerSettings: markerSettings,
            dataLabelSettings: dataLabelSettings,
            isVisible: isVisible,
            emptyPointSettings: emptyPointSettings,
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
            onRendererCreated: onRendererCreated,
            opacity: opacity);

  ///Border type of step area series.
  ///
  ///Defaults to BorderDrawMode.top
  ///
  ///Also refer [BorderDrawMode]
  ///
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///            series: <StepAreaSeries<SalesData, num>>[
  ///                StepAreaSeries<SalesData, num>(
  ///                  borderDrawMode: BorderDrawMode.all,
  ///                ),
  ///              ],
  ///        ));
  ///}
  ///```
  final BorderDrawMode borderDrawMode;

  StepAreaSeriesRenderer createRenderer(ChartSeries<T, D> series) {
    StepAreaSeriesRenderer stepAreaRenderer;
    if (onCreateRenderer != null) {
      stepAreaRenderer = onCreateRenderer(series);
      assert(stepAreaRenderer != null,
          'This onCreateRenderer callback function should return value as extends from ChartSeriesRenderer class and should not be return value as null');
      return stepAreaRenderer;
    }
    return StepAreaSeriesRenderer();
  }
}

/// Creates series renderer for Step area series
class StepAreaSeriesRenderer extends XyDataSeriesRenderer {
  StepAreaSeriesRenderer();

  /// StepArea segment is created here
  ChartSegment addSegment(
      Path path, Path strokePath, int seriesIndex, num animateFactor) {
    final StepAreaSegment segment = createSegment();
    _isRectSeries = false;
    segment._path = path;
    segment._strokePath = strokePath;
    segment._seriesIndex = seriesIndex;
    segment.seriesRenderer = this;
    segment.series = _series;
    segment._chart = _chart;
    segment.animationFactor = animateFactor;
    segment.calculateSegmentPoints();
    customizeSegment(segment);
    segment.strokePaint = segment.getStrokePaint();
    segment.fillPaint = segment.getFillPaint();
    _segments.add(segment);
    return segment;
  }

  void drawSegment(Canvas canvas, ChartSegment segment) {
    segment.onPaint(canvas);
  }

  /// Creates a segment for a data point in the series.
  @override
  ChartSegment createSegment() => StepAreaSegment();

  /// Changes the series color, border color, and border width.
  @override
  void customizeSegment(ChartSegment segment) {
    segment._color = segment.seriesRenderer._seriesColor;
    segment._strokeColor = segment.series.borderColor;
    segment._strokeWidth = segment.series.borderWidth;
  }

  /// Draws marker with different shape and color of the appropriate data point in the series.
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
