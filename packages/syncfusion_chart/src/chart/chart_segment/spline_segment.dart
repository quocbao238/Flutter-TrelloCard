part of charts;

/// Creates the segments for spline series.
///
/// Generates the spline series points and has the [calculateSegmentPoints] method overrided to customize
/// the spline segment point calculation.
///
/// Gets the path and color from the [series].
class SplineSegment extends ChartSegment {
  /// Point x1
  num x1;

  /// Point y1
  num y1;

  /// Point x2
  num x2;

  /// Point y2
  num y2;

  /// Start point X value
  double startControlX;

  /// Start point Y value
  double startControlY;

  /// End point X value
  double endControlX;

  /// End point Y value
  double endControlY;
  CartesianChartPoint<dynamic> _currentPoint;
  CartesianChartPoint<dynamic> _nextPoint;
  Color _pointColorMapper;
  _ChartLocation _currentPointLocation, _nextPointLocation;
  ChartAxis _xAxis, _yAxis;
  Rect _axisClipRect;
  ChartAxis _oldXAxis, _oldYAxis;
  SplineSegment _currentSegment, _oldSegment;
  num _oldX1, _oldY1, _oldX2, _oldY2, _oldX3, _oldY3, _oldX4, _oldY4;
  bool _needAnimate;

  /// Gets the color of the series.
  @override
  Paint getFillPaint() {
    final Paint fillPaint = Paint();
    if (_strokeColor != null) {
      fillPaint.color = _strokeColor.withOpacity(series.opacity);
    }
    fillPaint.strokeWidth = _strokeWidth;
    fillPaint.style = PaintingStyle.stroke;
    _defaultFillColor = fillPaint;
    return fillPaint;
  }

  /// Gets the stroke color of the series.
  @override
  Paint getStrokePaint() {
    final Paint strokePaint = Paint();
    if (_strokeColor != null) {
      strokePaint.color =
          _pointColorMapper ?? _strokeColor.withOpacity(series.opacity);
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

    startControlX = _currentPoint.startControl.x;
    startControlY = _currentPoint.startControl.y;
    endControlX = _currentPoint.endControl.x;
    endControlY = _currentPoint.endControl.y;
  }

  /// Draws segment in series bounds.
  @override
  void onPaint(Canvas canvas) {
    final Rect rect = _calculatePlotOffset(
        seriesRenderer._chart._chartAxis._axisClipRect,
        Offset(seriesRenderer._xAxis.plotOffset,
            seriesRenderer._yAxis.plotOffset));
    if (series.selectionSettings.enable) {
      series.selectionSettings._selectionRenderer._checkWithSelectionState(
          seriesRenderer._segments[currentSegmentIndex], seriesRenderer._chart);
    }

    /// Draw spline series
    if (series.animationDuration > 0 &&
        seriesRenderer._chart._chartState.widgetNeedUpdate &&
        !seriesRenderer._chart._chartState._isLegendToggled &&
        seriesRenderer._chart._chartState.oldSeriesRenderers != null &&
        seriesRenderer._chart._chartState.oldSeriesRenderers.isNotEmpty &&
        _oldSeries != null &&
        _oldSeriesRenderer._segments.isNotEmpty &&
        _oldSeriesRenderer._segments[0] is SplineSegment &&
        seriesRenderer._chart._chartState.oldSeriesRenderers.length - 1 >=
            seriesRenderer._segments[currentSegmentIndex]._seriesIndex &&
        seriesRenderer._segments[currentSegmentIndex]._oldSeriesRenderer
            ._segments.isNotEmpty &&
        _currentPoint.isGap != true &&
        _nextPoint.isGap != true) {
      _currentSegment = seriesRenderer._segments[currentSegmentIndex];
      _oldSegment = (_currentSegment._oldSeriesRenderer._segments.length - 1 >=
              currentSegmentIndex)
          ? _currentSegment._oldSeriesRenderer._segments[currentSegmentIndex]
          : null;
      _oldX1 = _oldSegment?.x1;
      _oldY1 = _oldSegment?.y1;
      _oldX2 = _oldSegment?.x2;
      _oldY2 = _oldSegment?.y2;
      _oldX3 = _oldSegment?.startControlX;
      _oldY3 = _oldSegment?.startControlY;
      _oldX4 = _oldSegment?.endControlX;
      _oldY4 = _oldSegment?.endControlY;

      if (_oldSegment != null &&
          (_oldX1.isNaN || _oldX2.isNaN) &&
          seriesRenderer._chart._chartState.oldAxes != null) {
        _ChartLocation _oldPoint;
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
          _oldPoint = _calculatePoint(
              _currentPoint.xValue,
              _currentPoint.yValue,
              _oldXAxis,
              _oldYAxis,
              seriesRenderer._chart._requireInvertedAxis,
              series,
              rect);
          _oldX1 = _oldPoint.x;
          _oldY1 = _oldPoint.y;
          _oldPoint = _calculatePoint(
              _nextPoint.xValue,
              _nextPoint.xValue,
              _oldXAxis,
              _oldYAxis,
              seriesRenderer._chart._requireInvertedAxis,
              series,
              rect);
          _oldX2 = _oldPoint.x;
          _oldY2 = _oldPoint.y;
          _oldPoint = _calculatePoint(
              startControlX,
              startControlY,
              _oldXAxis,
              _oldYAxis,
              seriesRenderer._chart._requireInvertedAxis,
              series,
              rect);
          _oldX3 = _oldPoint.x;
          _oldY3 = _oldPoint.y;
          _oldPoint = _calculatePoint(
              endControlX,
              endControlY,
              _oldXAxis,
              _oldYAxis,
              seriesRenderer._chart._requireInvertedAxis,
              series,
              rect);
          _oldX4 = _oldPoint.x;
          _oldY4 = _oldPoint.y;
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
        _currentSegment?.startControlX,
        _currentSegment?.startControlY,
        _oldX3,
        _oldY3,
        _currentSegment.endControlX,
        _currentSegment.endControlY,
        _oldX4,
        _oldY4,
      );
    } else {
      final Path path = Path();
      path.moveTo(x1, y1);
      if (_currentPoint.isGap != true && _nextPoint.isGap != true) {
        path.cubicTo(
            startControlX, startControlY, endControlX, endControlY, x2, y2);
        _drawDashedLine(canvas, series.dashArray, strokePaint, path);
      }
    }
  }
}
