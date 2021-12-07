part of charts;

/// Creates the segments for stacked column series.
///
/// Generates the stacked column series points and has the [calculateSegmentPoints] method overrided to customize
/// the stacked column segment point calculation.
///
/// Gets the path and color from the [series].
class StackedColumnSegment extends ChartSegment {
  /// Stack values.
  double stackValues;
  CartesianChartPoint<dynamic> _currentPoint;

  /// Rendering path.
  Path path;
  RRect _trackRect;

  /// Value of top left of region.
  dynamic topLeft;

  /// Value of top right of region.
  dynamic topRight;

  /// Value of top right of region.
  dynamic bottomRight;

  /// Value of bottom left of region.
  dynamic bottomLeft;
  Paint _trackerFillPaint;
  Paint _trackerStrokePaint;
  StackedColumnSeries<dynamic, dynamic> _stackedColumnSeries;

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
    _stackedColumnSeries = series;
    if (_stackedColumnSeries.trackColor != null) {
      _trackerFillPaint = Paint()
        ..color = _stackedColumnSeries.trackColor
        ..style = PaintingStyle.fill;
    }
    return _trackerFillPaint;
  }

  /// Method to get series tracker stroke color.
  Paint _getTrackerStrokePaint() {
    _stackedColumnSeries = series;
    _trackerStrokePaint = Paint()
      ..color = _stackedColumnSeries.trackBorderColor
      ..strokeWidth = _stackedColumnSeries.trackBorderWidth
      ..style = PaintingStyle.stroke;
    _stackedColumnSeries.trackBorderWidth == 0
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
    _stackedColumnSeries = series;
    if (series.selectionSettings.enable) {
      series.selectionSettings._selectionRenderer._checkWithSelectionState(
          seriesRenderer._segments[currentSegmentIndex], seriesRenderer._chart);
    }
    if (_trackerFillPaint != null && _stackedColumnSeries.isTrackVisible) {
      canvas.drawRRect(_trackRect, _trackerFillPaint);
    }
    if (_trackerStrokePaint != null && _stackedColumnSeries.isTrackVisible) {
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
