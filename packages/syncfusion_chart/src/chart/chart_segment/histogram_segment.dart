part of charts;

/// Creates the segments for column series.
///
/// This generates the column series points and has the [calculateSegmentPoints] override method
/// used to customize the column series segment point calculation.
///
/// It gets the path, stroke color and fill color from the [series] to render the column segment.
///
class HistogramSegment extends ChartSegment {
  /// X1 & Y1 & X2 & y2 value.
  num x1, y1, x2, y2;

  /// Render path.
  Path path;
  RRect _trackRect;
  CartesianChartPoint<dynamic> _currentPoint;
  Paint _trackerFillPaint, _trackerStrokePaint;

  /// Gets the color of the series.
  @override
  Paint getFillPaint() {
    // final bool hasPointColor = series.pointColorMapper != null ? true : false;

    /// Get and set the paint options for column series.
    if (series.gradient == null) {
      if (_color != null) {
        fillPaint = Paint()
          ..color = _currentPoint.isEmpty == true
              ? series.emptyPointSettings.color
              : ((_currentPoint.pointColorMapper != null)
                  ? _currentPoint.pointColorMapper
                  : _color)
          ..style = PaintingStyle.fill;
      }
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
    if (series.borderGradient != null) {
      strokePaint.shader =
          series.borderGradient.createShader(_currentPoint.region);
    } else if (_strokeColor != null) {
      strokePaint.color = _currentPoint.isEmpty == true
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
    final HistogramSeries<dynamic, dynamic> histogramSeries = series;
    if (_color != null) {
      _trackerFillPaint = Paint()
        ..color = histogramSeries.trackColor
        ..style = PaintingStyle.fill;
    }
    return _trackerFillPaint;
  }

  /// Method to get series tracker stroke color.
  Paint _getTrackerStrokePaint() {
    final HistogramSeries<dynamic, dynamic> histogramSeries = series;
    _trackerStrokePaint = Paint()
      ..color = histogramSeries.trackBorderColor
      ..strokeWidth = histogramSeries.trackBorderWidth
      ..style = PaintingStyle.stroke;
    histogramSeries.trackBorderWidth == 0
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
    final HistogramSeries<dynamic, dynamic> histogramSeries = series;

    series.selectionSettings._selectionRenderer._checkWithSelectionState(
        seriesRenderer._segments[currentSegmentIndex], seriesRenderer._chart);

    if (_trackerFillPaint != null && histogramSeries.isTrackVisible) {
      _drawSegmentRect(_trackerFillPaint, canvas, _trackRect);
    }

    if (_trackerStrokePaint != null && histogramSeries.isTrackVisible) {
      _drawSegmentRect(_trackerStrokePaint, canvas, _trackRect);
    }

    if (fillPaint != null) {
      _drawSegmentRect(fillPaint, canvas, segmentRect);
    }
    if (strokePaint != null) {
      if (series.dashArray[0] != 0 && series.dashArray[1] != 0) {
        _drawDashedLine(canvas, series.dashArray, strokePaint, path);
      } else {
        _drawSegmentRect(strokePaint, canvas, segmentRect);
      }
    }
  }

  /// To draw the rect of a given segment
  void _drawSegmentRect(Paint getPaint, Canvas canvas, RRect getRect) {
    ((_chart._chartState.initialRender ||
                _chart._chartState._isLegendToggled ||
                !_chart._chartState._oldSeriesKeys.contains(series.key)) &&
            series.animationDuration > 0)
        ? _animateRectSeries(
            canvas,
            seriesRenderer,
            getPaint,
            getRect,
            _currentPoint.yValue,
            animationFactor,
            _oldPoint != null ? _oldPoint.region : _oldRegion,
            _oldPoint?.yValue,
            _oldSeriesVisible)
        : canvas.drawRRect(getRect, getPaint);
  }
}
