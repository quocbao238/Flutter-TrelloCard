part of charts;

class _StepLineChartPainter extends CustomPainter {
  _StepLineChartPainter(
      {this.chart,
      this.seriesRenderer,
      this.isRepaint,
      this.animationController,
      this.seriesAnimation,
      this.chartElementAnimation,
      ValueNotifier<num> notifier,
      this.painterKey})
      : super(repaint: notifier);
  final SfCartesianChart chart;
  final bool isRepaint;
  final Animation<double> animationController;
  final Animation<double> seriesAnimation;
  final Animation<double> chartElementAnimation;
  final StepLineSeriesRenderer seriesRenderer;
  final _PainterKey painterKey;

  /// Painter method for step line series
  @override
  void paint(Canvas canvas, Size size) {
    double animationFactor;
    Rect clipRect;
    final StepLineSeries<dynamic, dynamic> series = seriesRenderer._series;
    final ChartAxis xAxis = seriesRenderer._xAxis;
    final ChartAxis yAxis = seriesRenderer._yAxis;
    final List<dynamic> dataPoints = seriesRenderer._dataPoints;
    if (seriesRenderer._visible) {
      canvas.save();
      final int seriesIndex = painterKey.index;
      seriesRenderer.storeSeriesProperties(chart, seriesIndex);
      animationFactor = seriesAnimation != null ? seriesAnimation.value : 1;
      final Rect axisClipRect = _calculatePlotOffset(
          chart._chartAxis._axisClipRect,
          Offset(xAxis.plotOffset, yAxis.plotOffset));
      canvas.clipRect(axisClipRect);
      if ((!(chart._chartState.widgetNeedUpdate ||
                  chart._chartState._isLegendToggled) ||
              !chart._chartState._oldSeriesKeys.contains(series.key)) &&
          series.animationDuration > 0) {
        _performLinearAnimation(
            seriesRenderer._chart, xAxis, canvas, animationFactor);
      }
      int segmentIndex = -1;
      CartesianChartPoint<dynamic> startPoint,
          endPoint,
          currentPoint,
          _nextPoint;
      num midX, midY;

      for (int pointIndex = 0; pointIndex < dataPoints.length; pointIndex++) {
        currentPoint = dataPoints[pointIndex];
        if ((currentPoint.isVisible && !currentPoint.isGap) &&
            startPoint == null) {
          startPoint = currentPoint;
        }
        if (pointIndex + 1 < dataPoints.length) {
          _nextPoint = dataPoints[pointIndex + 1];

          if (startPoint != null && _nextPoint.isVisible && _nextPoint.isGap) {
            startPoint = null;
          } else if (_nextPoint.isVisible && !_nextPoint.isGap) {
            endPoint = _nextPoint;
            midX = _nextPoint.xValue;
            midY = currentPoint.yValue;
          } else if (_nextPoint.isDrop) {
            _nextPoint = getDropValue(dataPoints, pointIndex);
            midX = _nextPoint?.xValue;
            midY = currentPoint.yValue;
          }
        }
        seriesRenderer.calculateRegionData(chart, seriesRenderer, seriesIndex,
            currentPoint, pointIndex, null, _nextPoint, midX, midY);
        if (startPoint != null &&
            endPoint != null &&
            midX != null &&
            midY != null) {
          seriesRenderer.drawSegment(
              canvas,
              seriesRenderer.addSegment(startPoint, midX, midY, endPoint,
                  segmentIndex += 1, seriesIndex, animationFactor));
          endPoint = startPoint = midX = midY = null;
        }
      }
      clipRect = _calculatePlotOffset(
          Rect.fromLTRB(
              chart._chartAxis._axisClipRect.left - series.markerSettings.width,
              chart._chartAxis._axisClipRect.top - series.markerSettings.height,
              chart._chartAxis._axisClipRect.right +
                  series.markerSettings.width,
              chart._chartAxis._axisClipRect.bottom +
                  series.markerSettings.height),
          Offset(xAxis.plotOffset, yAxis.plotOffset));

      canvas.restore();
      if ((series.animationDuration <= 0 ||
              (!chart._chartState.initialRender &&
                  !seriesRenderer._needAnimateSeriesElements) ||
              animationFactor >= chart._seriesDurationFactor) &&
          (series.markerSettings.isVisible ||
              series.dataLabelSettings.isVisible)) {
        canvas.clipRect(clipRect);
        seriesRenderer.renderSeriesElements(
            chart, canvas, chartElementAnimation);
      }
      if (seriesRenderer._visible && animationFactor >= 1) {
        chart._chartState.setPainterKey(seriesIndex, painterKey.name, true);
      }
    }
  }

  CartesianChartPoint<dynamic> getDropValue(
      List<CartesianChartPoint<dynamic>> points, int pointIndex) {
    CartesianChartPoint<dynamic> value;
    for (int i = pointIndex; i < points.length - 1; i++) {
      if (!points[i + 1].isDrop) {
        value = points[i + 1];
        break;
      }
    }
    return value;
  }

  @override
  bool shouldRepaint(_StepLineChartPainter oldDelegate) => isRepaint;
}
