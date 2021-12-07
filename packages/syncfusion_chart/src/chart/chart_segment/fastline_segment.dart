part of charts;

/// Creates the segments for fast line series.
///
/// This generates the fast line series points and has the [calculateSegmentPoints] method overrided to customize
/// the fast line segment point calculation.
///
/// Gets the path and color from the [series].
class FastLineSegment extends ChartSegment {
  /// Gets the color of the series.
  @override
  Paint getFillPaint() {
    final Paint fillPaint = Paint();
    if (_color != null) {
      fillPaint.color = _color.withOpacity(series.opacity);
    }
    fillPaint.style = PaintingStyle.fill;
    _defaultFillColor = fillPaint;
    return fillPaint;
  }

  /// Gets the stroke color of the series.
  @override
  Paint getStrokePaint() {
    final Paint strokePaint = Paint();
    if (series.gradient == null) {
      if (_strokeColor != null) {
        strokePaint.color =
            (series.opacity < 1 && _strokeColor != Colors.transparent)
                ? _strokeColor.withOpacity(series.opacity)
                : _strokeColor;
      }
    } else {
      strokePaint.shader =
          series.gradient.createShader(seriesRenderer._segmentPath.getBounds());
    }
    strokePaint.strokeWidth = _strokeWidth;
    strokePaint.style = PaintingStyle.stroke;
    strokePaint.strokeCap = StrokeCap.round;
    _defaultStrokeColor = strokePaint;
    return strokePaint;
  }

  /// Draws segment in series bounds.
  @override
  void onPaint(Canvas canvas) {
    if (series.selectionSettings.enable) {
      series.selectionSettings._selectionRenderer._checkWithSelectionState(
          seriesRenderer._segments[0], seriesRenderer._chart);
    }
    series.dashArray != null
        ? _drawDashedLine(
            canvas, series.dashArray, strokePaint, seriesRenderer._segmentPath)
        : canvas.drawPath(seriesRenderer._segmentPath, strokePaint);
  }

  /// Calculates the rendering bounds of a segment.
  @override
  void calculateSegmentPoints() {}
}
