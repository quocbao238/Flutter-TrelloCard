part of charts;

/// Creates the segments for  step area series.
///
/// Generates the step area series points and has the [calculateSegmentPoints] method overrided to customize
/// the step area segment point calculation.
///
/// Gets the path and color from the [series].
class StepAreaSegment extends ChartSegment {
  Path _path, _strokePath;
  Rect _pathRect;

  ///Step Area series.
  XyDataSeries<dynamic, dynamic> series;

  /// Gets the color of the series.
  @override
  Paint getFillPaint() {
    fillPaint = Paint();
    if (series.gradient == null) {
      if (_color != null) {
        fillPaint.color = _color;
        fillPaint.style = PaintingStyle.fill;
      }
    } else {
      fillPaint = (_pathRect != null)
          ? _getLinearGradientPaint(series.gradient, _pathRect,
              seriesRenderer._chart._requireInvertedAxis)
          : fillPaint;
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
    final Paint strokePaint = Paint();
    if (_strokeColor != null) {
      strokePaint
        ..color = series.borderColor
        ..style = PaintingStyle.stroke
        ..strokeWidth = series.borderWidth;
      series.borderWidth == 0
          ? strokePaint.color = Colors.transparent
          : strokePaint.color;
    }
    strokePaint.strokeCap = StrokeCap.round;
    _defaultStrokeColor = strokePaint;
    return strokePaint;
  }

  /// Calculates the rendering bounds of a segment.
  @override
  void calculateSegmentPoints() {}

  /// Draws segment in series bounds.
  @override
  void onPaint(Canvas canvas) {
    _pathRect = _path.getBounds();
    series.selectionSettings._selectionRenderer._checkWithSelectionState(
        seriesRenderer._segments[0], seriesRenderer._chart);
    canvas.drawPath(
        _path, (series.gradient == null) ? fillPaint : getFillPaint());

    if (strokePaint.color != Colors.transparent)
      _drawDashedLine(canvas, series.dashArray, strokePaint, _strokePath);
  }
}
