part of charts;

/// Creates the segments for Hilo series.
///
/// Generates the Hilo series points and has the [calculateSegmentPoints] method overrided to customize
/// the Hilo segment point calculation.
///
/// Gets the path and color from the [series].
class HiloSegment extends ChartSegment {
  /// Current point X value
  num x;

  /// Low value
  num low;

  /// High value
  num high;

  /// Position of x
  num xPos;

  /// Low position
  num lowPos;

  /// High position
  num highPos;

  /// Center of x
  num centerX;

  /// High value of x
  num highX;

  /// Low value of x
  num lowX;

  /// Center of y
  num centerY;

  /// High value of y
  num highY;

  /// Low value of y
  num lowY;

  /// Start position
  num startPos;

  /// End position
  num endPos;
  Color _pointColorMapper;

  /// Stores low point location
  _ChartLocation lowPoint;

  /// High point location
  _ChartLocation highPoint;

  /// Render path.
  Path path;

  bool _showSameValue, _isTransposed;

  HiloSeries<dynamic, dynamic> _hiloSeries;

  HiloSegment _currentSegment, _oldSegment;

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
      strokePaint.color = _currentPoint.isEmpty != null && _currentPoint.isEmpty
          ? series.emptyPointSettings.color
          : _pointColorMapper ?? _strokeColor;
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
    _hiloSeries = series;
    x = high = low = double.nan;
    lowPoint = _currentPoint.lowPoint;
    highPoint = _currentPoint.highPoint;

    _isTransposed = seriesRenderer._chart._requireInvertedAxis;

    x = lowPoint.x;
    low = lowPoint.y;
    high = highPoint.y;

    _showSameValue = _hiloSeries.showIndicationForSameValues &&
        (!_isTransposed ? low == high : lowPoint.x == highPoint.x);

    if (_showSameValue) {
      if (_isTransposed) {
        x = lowPoint.x = lowPoint.x - 2;
        highPoint.x = highPoint.x + 2;
      } else {
        low = lowPoint.y = lowPoint.y - 2;
        high = highPoint.y = highPoint.y + 2;
      }
    }
  }

  /// Draws segment in series bounds.
  @override
  void onPaint(Canvas canvas) {
    if (series.selectionSettings.enable) {
      series.selectionSettings._selectionRenderer._checkWithSelectionState(
          seriesRenderer._segments[currentSegmentIndex], seriesRenderer._chart);
    }
    if (series.animationDuration > 0 &&
        !seriesRenderer._chart._chartState._isLegendToggled) {
      if (!seriesRenderer._chart._chartState.widgetNeedUpdate) {
        if (_isTransposed) {
          lowX = lowPoint.x;
          highX = highPoint.x;
          centerX = highX + ((lowX - highX) / 2);
          highX = centerX + ((centerX - highX).abs() * animationFactor);
          lowX = centerX - ((lowX - centerX).abs() * animationFactor);
          canvas.drawLine(Offset(lowX, lowPoint.y), Offset(highX, highPoint.y),
              strokePaint);
        } else {
          centerY = high + ((low - high) / 2);
          highY = centerY - ((centerY - high) * animationFactor);
          lowY = centerY + ((low - centerY) * animationFactor);
          canvas.drawLine(Offset(lowPoint.x, highY), Offset(highPoint.x, lowY),
              strokePaint);
        }
      } else {
        _currentSegment = seriesRenderer._segments[currentSegmentIndex];
        _oldSegment = (_currentSegment._oldSeriesRenderer != null &&
                _currentSegment._oldSeriesRenderer._segments.isNotEmpty &&
                _currentSegment._oldSeriesRenderer._segments[0]
                    is HiloSegment &&
                _currentSegment._oldSeriesRenderer._segments.length - 1 >=
                    currentSegmentIndex)
            ? _currentSegment._oldSeriesRenderer._segments[currentSegmentIndex]
            : null;
        _animateHiloSeries(
            _isTransposed,
            lowPoint,
            highPoint,
            _oldSegment?.lowPoint,
            _oldSegment?.highPoint,
            animationFactor,
            strokePaint,
            canvas,
            seriesRenderer);
      }
    } else {
      if (series.dashArray[0] != 0 && series.dashArray[1] != 0) {
        path = Path();
        path.moveTo(lowPoint.x, high);
        path.lineTo(highPoint.x, low);
        _drawDashedLine(canvas, series.dashArray, strokePaint, path);
      } else {
        canvas.drawLine(
            Offset(lowPoint.x, high), Offset(highPoint.x, low), strokePaint);
      }
    }
  }
}
