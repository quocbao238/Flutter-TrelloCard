part of charts;

/// Creates the segments for 100% stacked line series.
///
/// Generates the stacked line100 series points and has the [calculateSegmentPoints] method overrided to customize
/// the stacked line100 segment point calculation.
///
/// Gets the path and color from the [series].
class StackedLine100Segment extends ChartSegment {
  /// Current chart point x value.
  num x1;

  /// Current chart point y value.
  num y1;

  /// Next point x value.
  num x2;

  /// Next point y value.
  num y2;
  num _currentCummulativePos;
  num _nextCummulativePos;

  /// Current cummulative value.
  num currentCummulativeValue;

  /// Next cummulative value.
  num nextCummulativeValue;
  Color _pointColorMapper;

  /// Gets the color of the series.
  @override
  Paint getFillPaint() {
    final Paint fillPaint = Paint();
    if (_color != null) {
      fillPaint.color = _pointColorMapper ?? _color.withOpacity(series.opacity);
    }
    fillPaint.strokeWidth = _strokeWidth;
    fillPaint.style = PaintingStyle.fill;
    _defaultFillColor = fillPaint;
    return fillPaint;
  }

  /// Gets the stroke color of the series.
  @override
  Paint getStrokePaint() {
    final Paint strokePaint = Paint();
    if (_strokeColor != null) {
      strokePaint.color = _pointColorMapper ?? _strokeColor;
      strokePaint.color =
          (series.opacity < 1 && strokePaint.color != Colors.transparent)
              ? strokePaint.color.withOpacity(series.opacity)
              : strokePaint.color;
    }
    strokePaint.strokeWidth = _strokeWidth;
    strokePaint.style = PaintingStyle.stroke;
    strokePaint.strokeCap = StrokeCap.round;
    _defaultStrokeColor = strokePaint;
    return strokePaint;
  }

  /// Calculates the rendering bounds of a segment.
  @override
  void calculateSegmentPoints() {
    final Rect rect = _calculatePlotOffset(
        seriesRenderer._chart._chartAxis._axisClipRect,
        Offset(seriesRenderer._xAxis.plotOffset,
            seriesRenderer._yAxis.plotOffset));
    final _ChartLocation currentChartPoint = _calculatePoint(
        _currentPoint.xValue,
        _currentCummulativePos,
        seriesRenderer._xAxis,
        seriesRenderer._yAxis,
        seriesRenderer._chart._requireInvertedAxis,
        series,
        rect);
    final _ChartLocation _nextLocation = _calculatePoint(
        _nextPoint.xValue,
        _nextCummulativePos,
        seriesRenderer._xAxis,
        seriesRenderer._yAxis,
        seriesRenderer._chart._requireInvertedAxis,
        series,
        rect);

    final _ChartLocation currentCummulativePoint = _calculatePoint(
        _currentPoint.xValue,
        _currentCummulativePos,
        seriesRenderer._xAxis,
        seriesRenderer._yAxis,
        seriesRenderer._chart._requireInvertedAxis,
        series,
        rect);

    final _ChartLocation nextCummulativePoint = _calculatePoint(
        _nextPoint.xValue,
        _nextCummulativePos,
        seriesRenderer._xAxis,
        seriesRenderer._yAxis,
        seriesRenderer._chart._requireInvertedAxis,
        series,
        rect);

    x1 = currentChartPoint.x;
    y1 = currentChartPoint.y;
    x2 = _nextLocation.x;
    y2 = _nextLocation.y;
    currentCummulativeValue = currentCummulativePoint.y;
    nextCummulativeValue = nextCummulativePoint.y;
  }

  /// Draws segment in series bounds.
  @override
  void onPaint(Canvas canvas) {
    series.selectionSettings._selectionRenderer._checkWithSelectionState(
        seriesRenderer._segments[currentSegmentIndex], seriesRenderer._chart);
    _renderStackedLineSeries(series, canvas, strokePaint, x1, y1, x2, y2);
  }
}
