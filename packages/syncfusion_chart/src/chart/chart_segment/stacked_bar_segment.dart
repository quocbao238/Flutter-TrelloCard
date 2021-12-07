part of charts;

/// Creates the segments for stacked bar series.
///
/// Generates the stacked bar series points and has the [calculateSegmentPoints] method overrided to customize
/// the stacked bar segment point calculation.
///
/// Gets the path and color from the [series].
class StackedBarSegment extends ChartSegment {
  /// Stacked values
  double stackValues;
  CartesianChartPoint<dynamic> _currentPoint;

  /// Render path
  Path path;

  /// Region rect
  RRect rect;
  RRect _trackRect;
  Paint _trackerFillPaint;
  Paint _trackerStrokePaint;
  StackedBarSeries<dynamic, dynamic> _stackedBarSeries;

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

  /// Method to get series tracker fill.
  Paint _getTrackerFillPaint() {
    final StackedBarSeries<dynamic, dynamic> columnSeries = series;
    if (columnSeries.trackColor != null) {
      _trackerFillPaint = Paint()
        ..color = columnSeries.trackColor
        ..style = PaintingStyle.fill;
    }
    return _trackerFillPaint;
  }

  /// Method to get series tracker stroke color.
  Paint _getTrackerStrokePaint() {
    _stackedBarSeries = series;
    _trackerStrokePaint = Paint()
      ..color = _stackedBarSeries.trackBorderColor
      ..strokeWidth = _stackedBarSeries.trackBorderWidth
      ..style = PaintingStyle.stroke;
    _stackedBarSeries.trackBorderWidth == 0
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
    _stackedBarSeries = series;
    if (series.selectionSettings.enable) {
      series.selectionSettings._selectionRenderer._checkWithSelectionState(
          seriesRenderer._segments[currentSegmentIndex], seriesRenderer._chart);
    }
    if (_trackerFillPaint != null && _stackedBarSeries.isTrackVisible) {
      canvas.drawRRect(_trackRect, _trackerFillPaint);
    }

    if (_trackerStrokePaint != null && _stackedBarSeries.isTrackVisible) {
      canvas.drawRRect(_trackRect, _trackerStrokePaint);
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
