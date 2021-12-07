part of charts;

/// Creates the segments for 100% stacked bar series.
///
/// Generates the stacked bar100 series points and has the [calculateSegmentPoints] method overrided to customize
/// the stacked bar100 segment point calculation.
///
/// Gets the path and color from the [series].
class StackedBar100Segment extends ChartSegment {
  double stackValues;
  CartesianChartPoint<dynamic> _currentPoint;

  ///Render path.
  Path path;

  ///Rect region.
  RRect rect;

  /// Gets the color of the series.
  @override
  Paint getFillPaint() {
    /// Get and set the paint options for column series.
    if (series.gradient == null) {
      fillPaint = Paint()
        ..color = _currentPoint.isEmpty != null && _currentPoint.isEmpty
            ? series.emptyPointSettings.color
            : (_currentPoint.pointColorMapper ?? _color)
        ..style = PaintingStyle.fill;
    } else {
      fillPaint = _getLinearGradientPaint(series.gradient, _currentPoint.region,
          seriesRenderer._chart._requireInvertedAxis);
    }
    fillPaint.color =
        (series.opacity < 1 && fillPaint.color != Colors.transparent)
            ? fillPaint.color.withOpacity(series.opacity)
            : fillPaint.color;
    _defaultFillColor = fillPaint;
    return fillPaint;
  }

  /// Gets the border color of the series.
  @override
  Paint getStrokePaint() {
    strokePaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = _currentPoint.isEmpty != null && _currentPoint.isEmpty
          ? series.emptyPointSettings.borderWidth
          : _strokeWidth;
    if (series.borderGradient != null) {
      strokePaint.shader =
          series.borderGradient.createShader(_currentPoint.region);
    } else if (_strokeColor != null) {
      strokePaint.color = _currentPoint.isEmpty != null && _currentPoint.isEmpty
          ? series.emptyPointSettings.borderColor
          : _strokeColor;
    }
    _defaultStrokeColor = strokePaint;
    series.borderWidth == 0
        ? strokePaint.color = Colors.transparent
        : strokePaint.color;
    return strokePaint;
  }

  /// Calculates the rendering bounds of a segment.
  @override
  void calculateSegmentPoints() {}

  /// Draws segment in series bounds.
  @override
  void onPaint(Canvas canvas) {
    if (series.selectionSettings.enable) {
      series.selectionSettings._selectionRenderer._checkWithSelectionState(
          seriesRenderer._segments[currentSegmentIndex], seriesRenderer._chart);
    }
    _renderStackingRectSeries(
        fillPaint,
        strokePaint,
        path,
        animationFactor,
        seriesRenderer,
        canvas,
        segmentRect,
        _currentPoint,
        currentSegmentIndex);
  }
}
