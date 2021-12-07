part of charts;

/// Renders the HiloOpenClose series.
///
/// HiLoOpenClose series is used to represent the low, high, open and closing values over time.
///
///To render a HiloOpenClose chart, create an instance of _hiloOpenCloseSeries,
/// and add it to the series collection property of [SfCartesianChart].
class HiloOpenCloseSeries<T, D> extends _FinancialSeriesBase<T, D> {
  HiloOpenCloseSeries(
      {ValueKey<String> key,
      ChartSeriesRendererFactory<T, D> onCreateRenderer,
      @required List<T> dataSource,
      @required ChartValueMapper<T, D> xValueMapper,
      @required ChartValueMapper<T, num> lowValueMapper,
      @required ChartValueMapper<T, num> highValueMapper,
      @required ChartValueMapper<T, num> openValueMapper,
      @required ChartValueMapper<T, num> closeValueMapper,
      ChartValueMapper<T, num> volumeValueMapper,
      ChartValueMapper<T, dynamic> sortFieldValueMapper,
      ChartValueMapper<T, Color> pointColorMapper,
      ChartValueMapper<T, String> dataLabelMapper,
      SortingOrder sortingOrder,
      String xAxisName,
      String yAxisName,
      String name,
      Color bearColor,
      Color bullColor,
      EmptyPointSettings emptyPointSettings,
      DataLabelSettings dataLabelSettings,
      bool isVisible,
      bool enableTooltip,
      double animationDuration,
      double borderWidth,
      SelectionSettings selectionSettings,
      bool isVisibleInLegend,
      LegendIconType legendIconType,
      String legendItemText,
      List<double> dashArray,
      double opacity,
      double spacing,
      List<int> initialSelectedDataIndexes,
      bool showIndicationForSameValues,
      List<Trendline> trendlines,
      SeriesRendererCreatedCallback onRendererCreated})
      : super(
            key: key,
            onCreateRenderer: onCreateRenderer,
            name: name,
            dashArray: dashArray,
            spacing: spacing,
            xValueMapper: xValueMapper,
            lowValueMapper: lowValueMapper,
            highValueMapper: highValueMapper,
            openValueMapper: openValueMapper != null
                ? (int index) => openValueMapper(dataSource[index], index)
                : null,
            closeValueMapper: closeValueMapper != null
                ? (int index) => closeValueMapper(dataSource[index], index)
                : null,
            volumeValueMapper: volumeValueMapper != null
                ? (int index) => volumeValueMapper(dataSource[index], index)
                : null,
            sortFieldValueMapper: sortFieldValueMapper,
            pointColorMapper: pointColorMapper,
            dataLabelMapper: dataLabelMapper,
            dataSource: dataSource,
            xAxisName: xAxisName,
            yAxisName: yAxisName,
            dataLabelSettings: dataLabelSettings,
            isVisible: isVisible,
            emptyPointSettings: emptyPointSettings,
            enableTooltip: enableTooltip,
            animationDuration: animationDuration,
            borderWidth: borderWidth ?? 2,
            selectionSettings: selectionSettings,
            legendItemText: legendItemText,
            isVisibleInLegend: isVisibleInLegend,
            legendIconType: legendIconType,
            sortingOrder: sortingOrder,
            opacity: opacity,
            bearColor: bearColor ?? Colors.red,
            bullColor: bullColor ?? Colors.green,
            initialSelectedDataIndexes: initialSelectedDataIndexes,
            onRendererCreated: onRendererCreated,
            showIndicationForSameValues: showIndicationForSameValues ?? false,
            trendlines: trendlines);

  // Create the hilo open close series renderer.
  HiloOpenCloseSeriesRenderer createRenderer(ChartSeries<T, D> series) {
    HiloOpenCloseSeriesRenderer seriesRenderer;
    if (onCreateRenderer != null) {
      seriesRenderer = onCreateRenderer(series);
      assert(seriesRenderer != null,
          'This onCreateRenderer callback function should return value as extends from ChartSeriesRenderer class and should not be return value as null');
      return seriesRenderer;
    }
    return HiloOpenCloseSeriesRenderer();
  }
}

/// Creates series renderer for Hilo open close series
class HiloOpenCloseSeriesRenderer extends XyDataSeriesRenderer {
  HiloOpenCloseSeriesRenderer();

  // Store the rect position //
  num _rectPosition;

  // Store the rect count //
  num _rectCount;

  HiloOpenCloseSeries<dynamic, dynamic> _hiloOpenCloseSeries;

  HiloOpenCloseSegment _segment;

  List<CartesianSeriesRenderer> _oldSeriesRenderers;

  /// HiloOpenClose _segment is created here
  ChartSegment addSegment(CartesianChartPoint<dynamic> currentPoint,
      int pointIndex, int seriesIndex, num animateFactor) {
    _segment = createSegment();
    _oldSeriesRenderers = _chart._chartState.oldSeriesRenderers;
    _isRectSeries = false;
    if (_segment != null) {
      _segment._seriesIndex = seriesIndex;
      _segment.currentSegmentIndex = pointIndex;
      _segment.seriesRenderer = this;
      _segment.series = _series;
      _segment.animationFactor = animateFactor;
      _segment._pointColorMapper = currentPoint.pointColorMapper;
      _segment._currentPoint = currentPoint;
      if (_chart._chartState.widgetNeedUpdate &&
          !_chart._chartState._isLegendToggled &&
          _oldSeriesRenderers != null &&
          _oldSeriesRenderers.isNotEmpty &&
          _oldSeriesRenderers.length - 1 >= _segment._seriesIndex &&
          _oldSeriesRenderers[_segment._seriesIndex]._seriesName ==
              _segment.seriesRenderer._seriesName) {
        _segment._oldSeriesRenderer =
            _oldSeriesRenderers[_segment._seriesIndex];
      }
      _segment.calculateSegmentPoints();
      customizeSegment(_segment);
      _segment.strokePaint = _segment.getStrokePaint();
      _segment.fillPaint = _segment.getFillPaint();
      _segments.add(_segment);
    }
    return _segment;
  }

  void drawSegment(Canvas canvas, ChartSegment _segment) {
    _segment.onPaint(canvas);
  }

  @override
  ChartSegment createSegment() => HiloOpenCloseSegment();

  /// Changes the series color, border color, and border width.
  @override
  void customizeSegment(ChartSegment _segment) {
    _hiloOpenCloseSeries = _series;
    _segment._color = _segment.seriesRenderer._seriesColor;
    _segment._strokeColor = _segment is HiloOpenCloseSegment && _segment._isBull
        ? _hiloOpenCloseSeries.bullColor
        : _hiloOpenCloseSeries.bearColor;
    _segment._strokeWidth = _segment.series.borderWidth;
  }

  ///Draws marker with different shape and color of the appropriate data point in the series.
  @override
  void drawDataMarker(int index, Canvas canvas, Paint fillPaint,
      Paint strokePaint, double pointX, double pointY,
      [CartesianSeriesRenderer seriesRenderer]) {}

  /// Draws data label text of the appropriate data point in a series.
  @override
  void drawDataLabel(int index, Canvas canvas, String dataLabel, double pointX,
          double pointY, int angle, TextStyle style) =>
      _drawText(canvas, dataLabel, Offset(pointX, pointY), style, angle);
}
