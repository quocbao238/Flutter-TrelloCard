part of charts;

/// Creates the segments for bubble series.
///
/// Generates the bubble series points and has the [calculateSegmentPoints] override method
/// used to customize the bubble series segment point calculation.
///
/// Gets the path, stroke color and fill color from the [series] to render the bubble series.
///

class BubbleSegment extends ChartSegment {
  ///Center X position of the bubble
  num _centerX;

  ///Center Y position of the bubble
  num _centerY;

  ///Radius of the bubble
  num _radius;

  ///Size of the bubble
  num _size;

  ///Bubble series.
  XyDataSeries<dynamic, dynamic> series;

  CartesianChartPoint<dynamic> _currentPoint;

  /// Gets the color of the series.
  @override
  Paint getFillPaint() {
    final bool hasPointColor = series.pointColorMapper != null ? true : false;
    if (series.gradient == null) {
      if (_color != null) {
        fillPaint = Paint()
          ..color = _currentPoint.isEmpty == true
              ? series.emptyPointSettings.color
              : ((hasPointColor && _currentPoint.pointColorMapper != null)
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
    final Paint strokePaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = _currentPoint.isEmpty == true
          ? series.emptyPointSettings.borderWidth
          : _strokeWidth;
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

  /// Calculates the rendering bounds of a segment.
  @override
  void calculateSegmentPoints() {
    _centerX = _centerY = double.nan;
    final Rect rect = _calculatePlotOffset(
        seriesRenderer._chart._chartAxis._axisClipRect,
        Offset(seriesRenderer._xAxis.plotOffset,
            seriesRenderer._yAxis.plotOffset));
    final _ChartLocation localtion = _calculatePoint(
        _currentPoint.xValue,
        _currentPoint.yValue,
        seriesRenderer._xAxis,
        seriesRenderer._yAxis,
        seriesRenderer._chart._requireInvertedAxis,
        series,
        rect);
    _centerX = localtion.x;
    _centerY = localtion.y;
    _radius = calculateBubbleRadius(seriesRenderer);
    _currentPoint.region = Rect.fromLTRB(
        localtion.x - 2 * _radius,
        localtion.y - 2 * _radius,
        localtion.x + 2 * _radius,
        localtion.y + 2 * _radius);
    _size = _radius = _currentPoint.region.width / 2;
  }

  num calculateBubbleRadius(BubbleSeriesRenderer seriesRenderer) {
    final BubbleSeries<dynamic, dynamic> bubbleSeries = series;
    num bubbleRadius, sizeRange, radiusRange, maxSize, minSize;
    maxSize = seriesRenderer._maxSize;
    minSize = seriesRenderer._minSize;
    sizeRange = maxSize - minSize;
    final num bubbleSize = ((_currentPoint.bubbleSize) ?? 4).toDouble();
    if (bubbleSeries.sizeValueMapper == null)
      bubbleSeries.minimumRadius != null
          ? bubbleRadius = bubbleSeries.minimumRadius
          : bubbleRadius = bubbleSeries.maximumRadius;
    else {
      if ((bubbleSeries.maximumRadius != null) &&
          (bubbleSeries.minimumRadius != null)) {
        if (sizeRange == 0)
          bubbleRadius = bubbleSize == 0
              ? bubbleSeries.minimumRadius
              : bubbleSeries.maximumRadius;
        else {
          radiusRange =
              (bubbleSeries.maximumRadius - bubbleSeries.minimumRadius) * 2;
          bubbleRadius =
              (((bubbleSize.abs() - minSize) * radiusRange) / sizeRange) +
                  bubbleSeries.minimumRadius;
        }
      }
    }
    return bubbleRadius;
  }

  /// Draws segment in series bounds.
  @override
  void onPaint(Canvas canvas) {
    if (series.selectionSettings.enable) {
      series.selectionSettings._selectionRenderer._checkWithSelectionState(
          seriesRenderer._segments[currentSegmentIndex], seriesRenderer._chart);
    }
    segmentRect = RRect.fromRectAndRadius(_currentPoint.region, Radius.zero);
    if (seriesRenderer._chart._chartState.widgetNeedUpdate &&
        !seriesRenderer._chart._chartState._isLegendToggled &&
        seriesRenderer._chart._chartState.oldSeriesRenderers != null &&
        seriesRenderer._chart._chartState.oldSeriesRenderers.isNotEmpty &&
        _oldSeriesRenderer != null &&
        _oldSeriesRenderer._segments.isNotEmpty &&
        _oldSeriesRenderer._segments[0] is BubbleSegment &&
        series.animationDuration > 0 &&
        _oldPoint != null) {
      final BubbleSegment currentSegment =
          seriesRenderer._segments[currentSegmentIndex];
      final BubbleSegment oldSegment =
          (currentSegment._oldSeriesRenderer._segments.length - 1 >=
                  currentSegmentIndex)
              ? currentSegment._oldSeriesRenderer._segments[currentSegmentIndex]
              : null;
      _animateBubbleSeries(
          canvas,
          _centerX,
          _centerY,
          oldSegment?._centerX,
          oldSegment?._centerY,
          oldSegment?._size,
          animationFactor,
          _radius,
          strokePaint,
          fillPaint,
          seriesRenderer);
    } else {
      canvas.drawCircle(
          Offset(_centerX, _centerY), _radius * animationFactor, fillPaint);
      canvas.drawCircle(
          Offset(_centerX, _centerY), _radius * animationFactor, strokePaint);
    }
  }
}
