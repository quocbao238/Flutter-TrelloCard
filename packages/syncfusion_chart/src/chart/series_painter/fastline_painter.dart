part of charts;

class _FastLineChartPainter extends CustomPainter {
  _FastLineChartPainter(
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
  final AnimationController animationController;
  final Animation<double> seriesAnimation;
  final Animation<double> chartElementAnimation;
  final FastLineSeriesRenderer seriesRenderer;
  Path path;
  Paint pathPaint;
  final _PainterKey painterKey;

  /// Painter method for fast line series
  @override
  void paint(Canvas canvas, Size size) {
    Rect clipRect;
    double animationFactor;
    final FastLineSeries<dynamic, dynamic> series = seriesRenderer._series;
    final ChartAxis xAxis = seriesRenderer._xAxis;
    final ChartAxis yAxis = seriesRenderer._yAxis;
    if (seriesRenderer._visible) {
      canvas.save();
      final int seriesIndex = painterKey.index;
      seriesRenderer.storeSeriesProperties(chart, seriesIndex);
      animationFactor = seriesAnimation != null ? seriesAnimation.value : 1;
      final Rect axisClipRect = _calculatePlotOffset(
          chart._chartAxis._axisClipRect,
          Offset(xAxis.plotOffset, yAxis.plotOffset));
      canvas.clipRect(axisClipRect);
      if (series.animationDuration > 0 &&
          !seriesRenderer._chart._chartState._isLegendToggled) {
        _performLinearAnimation(
            seriesRenderer._chart, xAxis, canvas, animationFactor);
      }
      CartesianChartPoint<dynamic> prevPoint, point;
      _ChartLocation currentLocation;
      final _VisibleRange xVisibleRange = xAxis._visibleRange;
      final _VisibleRange yVisibleRange = yAxis._visibleRange;
      final List<CartesianChartPoint<dynamic>> seriesPoints =
          seriesRenderer._dataPoints;
      final Rect areaBounds = seriesRenderer._chart._chartAxis._axisClipRect;
      final num xTolerance = (xVisibleRange.delta / areaBounds.width).abs();
      final num yTolerance = (yVisibleRange.delta / areaBounds.height).abs();
      num prevXValue = (seriesPoints.isNotEmpty &&
              seriesPoints[0] != null &&
              seriesPoints[0].xValue > xTolerance)
          ? 0
          : xTolerance;
      num prevYValue = (seriesPoints.isNotEmpty &&
              seriesPoints[0] != null &&
              seriesPoints[0].yValue > yTolerance)
          ? 0
          : yTolerance;
      num xVal = 0;
      num yVal = 0;

      final List<CartesianChartPoint<dynamic>> dataPoints =
          <CartesianChartPoint<dynamic>>[];

      ///Eliminating nearest points
      dynamic currentPoint;
      for (int pointIndex = 0;
          pointIndex < seriesRenderer._dataPoints.length;
          pointIndex++) {
        currentPoint = seriesRenderer._dataPoints[pointIndex];
        xVal = currentPoint.xValue != null
            ? currentPoint.xValue
            : xVisibleRange.minimum;
        yVal = currentPoint.yValue != null
            ? currentPoint.yValue
            : yVisibleRange.minimum;
        if ((prevXValue - xVal).abs() >= xTolerance ||
            (prevYValue - yVal).abs() >= yTolerance) {
          point = currentPoint;
          dataPoints.add(currentPoint);
          seriesRenderer.calculateRegionData(
              chart, seriesRenderer, painterKey.index, point, pointIndex);
          if (point.isVisible) {
            currentLocation = _calculatePoint(xVal, yVal, xAxis, yAxis,
                seriesRenderer._chart._requireInvertedAxis, series, areaBounds);
            if (prevPoint == null)
              seriesRenderer._segmentPath
                  .moveTo(currentLocation.x, currentLocation.y);
            else if (seriesRenderer._dataPoints[pointIndex - 1].isVisible ==
                    false &&
                series.emptyPointSettings.mode == EmptyPointMode.gap)
              seriesRenderer._segmentPath
                  .moveTo(currentLocation.x, currentLocation.y);
            else if (point.isGap != true &&
                seriesRenderer._dataPoints[pointIndex - 1].isGap != true &&
                seriesRenderer._dataPoints[pointIndex].isVisible == true)
              seriesRenderer._segmentPath
                  .lineTo(currentLocation.x, currentLocation.y);
            else
              seriesRenderer._segmentPath
                  .moveTo(currentLocation.x, currentLocation.y);
            prevPoint = point;
          }
          prevXValue = xVal;
          prevYValue = yVal;
        }
      }

      if (seriesRenderer._segmentPath != null) {
        seriesRenderer._dataPoints = dataPoints;
        seriesRenderer.drawSegment(
            canvas,
            seriesRenderer.addSegment(
                painterKey.index, chart, animationFactor));
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
              animationFactor >= chart._seriesDurationFactor) &&
          (series.markerSettings.isVisible ||
              series.dataLabelSettings.isVisible)) {
        canvas.clipRect(clipRect);
        seriesRenderer.renderSeriesElements(
            chart, canvas, chartElementAnimation);
      }
      if (animationFactor >= 1) {
        chart._chartState
            .setPainterKey(painterKey.index, painterKey.name, true);
      }
    }
  }

  @override
  bool shouldRepaint(_FastLineChartPainter oldDelegate) => isRepaint;
}
