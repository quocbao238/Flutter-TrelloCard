part of charts;

/// Creates the segments for range column series.
///
/// Generates the range column series points and has the [calculateSegmentPoints] method overrided to customize
/// the range column segment point calculation.
///
/// Gets the path and color from the [series].
class RangeColumnSegment extends ChartSegment {
  ///Current point
  num x1;

  ///Path of the series
  Path path;

  ///Low value
  num low1;

  ///High value
  num high1;
  RRect _trackRect;
  CartesianChartPoint<dynamic> _currentPoint;
  Paint _trackerFillPaint;
  Paint _trackerStrokePaint;

  /// Gets the color of the series.
  @override
  Paint getFillPaint() {
    final bool hasPointColor = series.pointColorMapper != null ? true : false;

    /// Get and set the paint options for range column series.
    if (series.gradient == null) {
      fillPaint = Paint()
        ..color = _currentPoint.isEmpty == true
            ? series.emptyPointSettings.color
            : ((hasPointColor && _currentPoint.pointColorMapper != null)
                ? _currentPoint.pointColorMapper
                : _color)
        ..style = PaintingStyle.fill;
    } else {
      fillPaint = _getLinearGradientPaint(series.gradient, _currentPoint.region,
          seriesRenderer._chart._requireInvertedAxis);
    }
    if (fillPaint.color != null)
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
      ..strokeWidth = _currentPoint.isEmpty == true
          ? series.emptyPointSettings.borderWidth
          : _strokeWidth;
    _defaultStrokeColor = strokePaint;
    if (series.borderGradient != null) {
      strokePaint.shader =
          series.borderGradient.createShader(_currentPoint.region);
    } else {
      strokePaint.color = _currentPoint.isEmpty == true
          ? series.emptyPointSettings.borderColor
          : _strokeColor;
    }
    series.borderWidth == 0
        ? strokePaint.color = Colors.transparent
        : strokePaint.color;
    return strokePaint;
  }

  /// Method to get series tracker fill.
  Paint _getTrackerFillPaint() {
    final RangeColumnSeries<dynamic, dynamic> _series = series;

    _trackerFillPaint = Paint()
      ..color = _series.trackColor
      ..style = PaintingStyle.fill;

    return _trackerFillPaint;
  }

  /// Method to get series tracker stroke color.
  Paint _getTrackerStrokePaint() {
    final RangeColumnSeries<dynamic, dynamic> _series = series;
    _trackerStrokePaint = Paint()
      ..color = _series.trackBorderColor
      ..strokeWidth = _series.trackBorderWidth
      ..style = PaintingStyle.stroke;
    _series.trackBorderWidth == 0
        ? _trackerStrokePaint.color = Colors.transparent
        : _trackerStrokePaint.color;
    return _trackerStrokePaint;
  }

  /// Calculates the rendering bounds of a segment.
  @override
  void calculateSegmentPoints() {}

  /// Draws segment in series bounds.
  @override
  void onPaint(Canvas canvas) {
    final RangeColumnSeries<dynamic, dynamic> _series = series;

    series.selectionSettings._selectionRenderer._checkWithSelectionState(
        seriesRenderer._segments[currentSegmentIndex], seriesRenderer._chart);

    if (_trackerFillPaint != null && _series.isTrackVisible) {
      canvas.drawRRect(_trackRect, _trackerFillPaint);
    }

    if (_trackerStrokePaint != null && _series.isTrackVisible) {
      canvas.drawRRect(_trackRect, _trackerStrokePaint);
    }

    if (fillPaint != null) {
      (series.animationDuration > 0 &&
              !seriesRenderer._chart._chartState._isLegendToggled)
          ? _animateRangeColumn(
              canvas,
              seriesRenderer,
              fillPaint,
              segmentRect,
              _oldPoint != null ? _oldPoint.region : _oldRegion,
              animationFactor)
          : canvas.drawRRect(segmentRect, fillPaint);
    }
    if (strokePaint != null) {
      if (series.dashArray[0] != 0 && series.dashArray[1] != 0) {
        _drawDashedLine(canvas, series.dashArray, strokePaint, path);
      } else {
        (series.animationDuration > 0 &&
                !seriesRenderer._chart._chartState._isLegendToggled)
            ? _animateRangeColumn(
                canvas,
                seriesRenderer,
                strokePaint,
                segmentRect,
                _oldPoint != null ? _oldPoint.region : _oldRegion,
                animationFactor)
            : canvas.drawRRect(segmentRect, strokePaint);
      }
    }
  }
}
