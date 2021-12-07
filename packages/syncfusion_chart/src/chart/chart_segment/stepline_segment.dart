part of charts;

/// Creates the segments for step line series.
///
/// Generates the step line series points and has the [calculateSegmentPoints] method overrided to customize
/// the step line segment point calculation.
///
/// Gets the path and color from the [series].
class StepLineSegment extends ChartSegment {
  ///Current point x value.
  num x1;

  ///Current point y value.
  num y1;

  /// Next point x value.
  num x2;

  /// Next point y value.
  num y2;

  /// Mid point x vlaue.
  num x3;

  /// Mid point y value.
  num y3;

  /// Render path
  Path path;

  num _x1Pos,
      _y1Pos,
      _x2Pos,
      _y2Pos,
      _midX,
      _midY,
      _oldX1,
      _oldY1,
      _oldX2,
      _oldY2,
      _oldX3,
      _oldY3;
  Color _pointColorMapper;
  bool _needAnimate;
  ChartAxis _oldXAxis, _oldYAxis;
  _ChartLocation _currentLocation, _midLocation, _nextLocation, _oldLocation;
  StepLineSegment _currentSegment, _oldSegment;

  /// Gets the color of the series.
  @override
  Paint getFillPaint() {
    final Paint fillPaint = Paint();
    if (_color != null) {
      fillPaint.color = _color.withOpacity(series.opacity);
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
      strokePaint.color = _pointColorMapper ?? _strokeColor;
      strokePaint.color =
          (series.opacity < 1 && strokePaint.color != Colors.transparent)
              ? strokePaint.color.withOpacity(series.opacity)
              : strokePaint.color;
    }
    strokePaint.strokeWidth = _strokeWidth;
    strokePaint.style = PaintingStyle.stroke;
    strokePaint.strokeCap = StrokeCap.square;
    _defaultStrokeColor = strokePaint;
    return strokePaint;
  }

  /// Calculates the rendering bounds of a segment.
  @override
  void calculateSegmentPoints() {
    _currentLocation = _currentPoint.currentPoint;
    _nextLocation = _currentPoint._nextPoint;
    _midLocation = _currentPoint._midPoint;
    x1 = _currentLocation.x;
    y1 = _currentLocation.y;
    x2 = _nextLocation.x;
    y2 = _nextLocation.y;
    x3 = _midLocation.x;
    y3 = _midLocation.y;
  }

  /// Draws segment in series bounds.
  @override
  void onPaint(Canvas canvas) {
    final Rect _rect = _calculatePlotOffset(
        seriesRenderer._chart._chartAxis._axisClipRect,
        Offset(seriesRenderer._xAxis.plotOffset,
            seriesRenderer._yAxis.plotOffset));
    path = Path();
    series.selectionSettings._selectionRenderer._checkWithSelectionState(
        seriesRenderer._segments[currentSegmentIndex], seriesRenderer._chart);
    if (series.animationDuration > 0 &&
        seriesRenderer._chart._chartState.widgetNeedUpdate &&
        !seriesRenderer._chart._chartState._isLegendToggled &&
        seriesRenderer._chart._chartState.oldSeriesRenderers != null &&
        seriesRenderer._chart._chartState.oldSeriesRenderers.isNotEmpty &&
        _oldSeriesRenderer != null &&
        _oldSeriesRenderer._segments.isNotEmpty &&
        _oldSeriesRenderer._segments[0] is StepLineSegment &&
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
      _oldX3 = _oldSegment?.x3;
      _oldY3 = _oldSegment?.y3;

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
          _oldLocation = _calculatePoint(_x1Pos, _y1Pos, _oldXAxis, _oldYAxis,
              seriesRenderer._chart._requireInvertedAxis, series, _rect);
          _oldX1 = _oldLocation.x;
          _oldY1 = _oldLocation.y;

          _oldLocation = _calculatePoint(_x2Pos, _y2Pos, _oldXAxis, _oldYAxis,
              seriesRenderer._chart._requireInvertedAxis, series, _rect);
          _oldX2 = _oldLocation.x;
          _oldY2 = _oldLocation.y;
          _oldLocation = _calculatePoint(_midX, _midY, _oldXAxis, _oldYAxis,
              seriesRenderer._chart._requireInvertedAxis, series, _rect);
          _oldX3 = _oldLocation.x;
          _oldY3 = _oldLocation.y;
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
        _currentSegment.x3,
        _currentSegment.y3,
        _oldX3,
        _oldY3,
      );
    } else {
      if (series.dashArray[0] != 0 && series.dashArray[1] != 0) {
        path.moveTo(x1, y1);
        path.lineTo(x3, y3);
        path.lineTo(x2, y2);
        _drawDashedLine(canvas, series.dashArray, strokePaint, path);
      } else {
        canvas.drawLine(Offset(x1, y1), Offset(x3, y3), strokePaint);
        canvas.drawLine(Offset(x3, y3), Offset(x2, y2), strokePaint);
      }
    }
  }
}
