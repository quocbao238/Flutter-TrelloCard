part of charts;

class SplineRangeAreaSeries<T, D> extends XyDataSeries<T, D> {
  SplineRangeAreaSeries(
      {ValueKey<String> key,
      ChartSeriesRendererFactory<T, D> onCreateRenderer,
      @required List<T> dataSource,
      @required ChartValueMapper<T, D> xValueMapper,
      @required ChartValueMapper<T, num> highValueMapper,
      @required ChartValueMapper<T, num> lowValueMapper,
      ChartValueMapper<T, dynamic> sortFieldValueMapper,
      ChartValueMapper<T, String> dataLabelMapper,
      SortingOrder sortingOrder,
      String xAxisName,
      String yAxisName,
      String name,
      Color color,
      MarkerSettings markerSettings,
      this.splineType,
      List<Trendline> trendlines,
      double cardinalSplineTension,
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
      RangeAreaBorderMode borderDrawMode})
      : borderDrawMode = borderDrawMode ?? RangeAreaBorderMode.all,
        cardinalSplineTension = cardinalSplineTension ?? 0.5,
        super(
            key: key,
            onCreateRenderer: onCreateRenderer,
            xValueMapper: xValueMapper,
            lowValueMapper: lowValueMapper,
            highValueMapper: highValueMapper,
            sortFieldValueMapper: sortFieldValueMapper,
            dataLabelMapper: dataLabelMapper,
            dataSource: dataSource,
            xAxisName: xAxisName,
            yAxisName: yAxisName,
            name: name,
            color: color,
            trendlines: trendlines,
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

  ///Border type of the spline range area series.
  ///
  ///It takes the following two values:
  ///
  ///* [RangeAreaBorderMode.all] renders border for all the sides of the series.
  ///* [RangeAreaBorderMode.excludeSides] renders border at the top and bottom of the series,
  /// and excludes both sides.
  ///
  ///Defaults to `RangeAreaBorderMode.all`
  ///
  ///Also refer [RangeAreaBorderMode]

  final RangeAreaBorderMode borderDrawMode;

  ///Type of the spline curve in spline range area series.
  ///
  ///Various type of curves such as clamped, cardinal, monotonic, and natural can be rendered
  /// between the data points.
  ///
  ///Defaults to `SplineType.natural`
  ///
  ///Also refer [SplineType]

  final SplineType splineType;

  ///Line tension of the cardinal spline curve.
  ///
  ///This is applicable only when `SplineType.cardinal` is set to [splineType] property.

  final double cardinalSplineTension;

  // Create the spline area series renderer.
  SplineRangeAreaSeriesRenderer createRenderer(ChartSeries<T, D> series) {
    SplineRangeAreaSeriesRenderer seriesRenderer;
    if (onCreateRenderer != null) {
      seriesRenderer = onCreateRenderer(series);
      assert(seriesRenderer != null,
          'This onCreateRenderer callback function should return value as extends from ChartSeriesRenderer class and should not be return value as null');
      return seriesRenderer;
    }
    return SplineRangeAreaSeriesRenderer();
  }
}

/// Creates series renderer for Spline range area series
class SplineRangeAreaSeriesRenderer extends XyDataSeriesRenderer {
  SplineRangeAreaSeriesRenderer();

  //ignore: prefer_final_fields
  List<_ControlPoints> _drawLowPoints;
  //ignore: prefer_final_fields
  List<_ControlPoints> _drawHighPoints;

  /// SplineRangeArea segment is created here
  ChartSegment addSegment(int seriesIndex, SfCartesianChart chart,
      num animateFactor, Path path, Path strokePath) {
    final SplineRangeAreaSegment segment = createSegment();
    _isRectSeries = false;
    if (segment != null) {
      segment._seriesIndex = seriesIndex;
      segment.animationFactor = animateFactor;
      segment.series = _series;
      segment.seriesRenderer = this;
      segment._chart = chart;
      segment._path = path;
      segment._strokePath = strokePath;
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
  ChartSegment createSegment() => SplineRangeAreaSegment();

  /// Changes the series color, border color, and border width.
  @override
  void customizeSegment(ChartSegment segment) {
    segment._color = segment.seriesRenderer._seriesColor;
    segment._strokeColor = segment.seriesRenderer._seriesColor;
    segment._strokeWidth = segment.series.width;
  }

  ///Draws marker with different shape and color of the appropriate data point in the series.
  @override
  void drawDataMarker(int index, Canvas canvas, Paint fillPaint,
      Paint strokePaint, double pointX, double pointY,
      [CartesianSeriesRenderer seriesRenderer]) {
    canvas.drawPath(seriesRenderer._markerShapes[index], fillPaint);
    canvas.drawPath(seriesRenderer._markerShapes2[index], fillPaint);
    canvas.drawPath(seriesRenderer._markerShapes[index], strokePaint);
    canvas.drawPath(seriesRenderer._markerShapes2[index], strokePaint);
  }

  /// Draws data label text of the appropriate data point in a series.
  @override
  void drawDataLabel(int index, Canvas canvas, String dataLabel, double pointX,
          double pointY, int angle, TextStyle style) =>
      _drawText(canvas, dataLabel, Offset(pointX, pointY), style, angle);
}
