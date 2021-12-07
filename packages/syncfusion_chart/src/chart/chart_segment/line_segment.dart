part of charts;

/// Creates the segments for line series.
///
/// Line segment is a part of a line series that is bounded by two distinct end point.
/// Generates the line series points and has the [calculateSegmentPoints] override method
/// used to customize the line series segment point calculation.
///
/// Gets the path, stroke color and fill color from the [series].
///
/// _Note:_ This is only applicable for [SfCartesianChart].
class LineSegment extends ChartSegment {
  /// X1 value
  num x1;

  /// Y1 value
  num y1;

  /// X2 value
  num x2;

  /// Y2 value
  num y2;

  /// Render path
  Path path;

  Color _pointColorMapper;

  ChartAxis _oldXAxis, _oldYAxis;

  bool _needAnimate;

  Rect _axisClipRect;

  _ChartLocation _first, _second, _currentPointLocation, _nextPointLocation;

  ChartAxis _xAxis, _yAxis;

  LineSegment _currentSegment, _oldSegment;

  num _oldX1, _oldY1, _oldX2, _oldY2;

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
    _xAxis = seriesRenderer._xAxis;
    _yAxis = seriesRenderer._yAxis;
    _axisClipRect = _calculatePlotOffset(
        _chart._chartAxis._axisClipRect,
        Offset(seriesRenderer._xAxis.plotOffset,
            seriesRenderer._yAxis.plotOffset));
    _currentPointLocation = _calculatePoint(
        _currentPoint.xValue,
        _currentPoint.yValue,
        _xAxis,
        _yAxis,
        _chart._requireInvertedAxis,
        series,
        _axisClipRect);
    x1 = _currentPointLocation.x;
    y1 = _currentPointLocation.y;
    _nextPointLocation = _calculatePoint(_nextPoint.xValue, _nextPoint.yValue,
        _xAxis, _yAxis, _chart._requireInvertedAxis, series, _axisClipRect);
    x2 = _nextPointLocation.x;
    y2 = _nextPointLocation.y;
  }

  /// Draws segment in series bounds.
  @override
  void onPaint(Canvas canvas) {
    final Rect rect = _calculatePlotOffset(
        seriesRenderer._chart._chartAxis._axisClipRect,
        Offset(seriesRenderer._xAxis.plotOffset,
            seriesRenderer._yAxis.plotOffset));
    path = Path();
    if (series.selectionSettings.enable) {
      series.selectionSettings._selectionRenderer._checkWithSelectionState(
          seriesRenderer._segments[currentSegmentIndex], seriesRenderer._chart);
    }
    if (series.animationDuration > 0 &&
        _oldSeriesRenderer != null &&
        _oldSeriesRenderer._segments.isNotEmpty &&
        _oldSeriesRenderer._segments[0] is LineSegment &&
        seriesRenderer._chart._chartState.oldSeriesRenderers.length - 1 >=
            seriesRenderer._segments[currentSegmentIndex]._seriesIndex &&
        seriesRenderer._segments[currentSegmentIndex]._oldSeriesRenderer
            ._segments.isNotEmpty) {
      _currentSegment = seriesRenderer._segments[currentSegmentIndex];
      _oldSegment = (_currentSegment._oldSeriesRenderer._segments.length - 1 >=
              currentSegmentIndex)
          ? _currentSegment._oldSeriesRenderer._segments[currentSegmentIndex]
          : null;
      _oldX1 = _oldSegment?.x1;
      _oldY1 = _oldSegment?.y1;
      _oldX2 = _oldSegment?.x2;
      _oldY2 = _oldSegment?.y2;

      if (_oldSegment != null &&
          (_oldX1.isNaN || _oldX2.isNaN) &&
          seriesRenderer._chart._chartState.oldAxes != null) {
        _oldXAxis = _getOldAxis(
            seriesRenderer._xAxis, seriesRenderer._chart._chartState.oldAxes);
        _oldYAxis = _getOldAxis(
            seriesRenderer._yAxis, seriesRenderer._chart._chartState.oldAxes);
        if (_oldYAxis != null && _oldXAxis != null) {
          _needAnimate = _oldYAxis._visibleRange.minimum !=
                  seriesRenderer._yAxis._visibleRange.minimum ||
              _oldYAxis._visibleRange.maximum !=
                  seriesRenderer._yAxis._visibleRange.maximum ||
              _oldXAxis._visibleRange.minimum !=
                  seriesRenderer._xAxis._visibleRange.minimum ||
              _oldXAxis._visibleRange.maximum !=
                  seriesRenderer._xAxis._visibleRange.maximum;
        }
        if (_needAnimate) {
          _first = _calculatePoint(
              _currentPoint.xValue,
              _currentPoint.yValue,
              _oldXAxis,
              _oldYAxis,
              seriesRenderer._chart._requireInvertedAxis,
              series,
              rect);
          _second = _calculatePoint(
              _nextPoint.xValue,
              _nextPoint.yValue,
              _oldXAxis,
              _oldYAxis,
              seriesRenderer._chart._requireInvertedAxis,
              series,
              rect);
          _oldX1 = _first.x;
          _oldX2 = _second.x;
          _oldY1 = _first.y;
          _oldY2 = _second.y;
        }
      }
      _animateLineTypeSeries(
        canvas,
        seriesRenderer,
        strokePaint,
        animationFactor,
        _currentSegment.x1,
        _currentSegment.y1,
        _currentSegment.x2,
        _currentSegment.y2,
        _oldX1,
        _oldY1,
        _oldX2,
        _oldY2,
      );
    } else {
      if (series.dashArray[0] != 0 && series.dashArray[1] != 0) {
        path.moveTo(x1, y1);
        path.lineTo(x2, y2);
        _drawDashedLine(canvas, series.dashArray, strokePaint, path);
      } else {
        canvas.drawLine(Offset(x1, y1), Offset(x2, y2), strokePaint);
      }
    }
  }
}
