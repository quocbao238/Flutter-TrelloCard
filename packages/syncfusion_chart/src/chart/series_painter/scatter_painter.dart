part of charts;

class _ScatterChartPainter extends CustomPainter {
  _ScatterChartPainter(
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
  final ScatterSeriesRenderer seriesRenderer;
  final _PainterKey painterKey;

  /// Painter method for scatter series
  @override
  void paint(Canvas canvas, Size size) {
    canvas.save();
    double animationFactor;
    final ScatterSeries<dynamic, dynamic> series = seriesRenderer._series;
    if (seriesRenderer._visible) {
      final ChartAxis xAxis = seriesRenderer._xAxis;
      final ChartAxis yAxis = seriesRenderer._yAxis;
      final List<dynamic> dataPoints = seriesRenderer._dataPoints;
      animationFactor = seriesAnimation != null ? seriesAnimation.value : 1;
      final Rect axisClipRect = _calculatePlotOffset(
          chart._chartAxis._axisClipRect,
          Offset(xAxis.plotOffset, yAxis.plotOffset));
      canvas.clipRect(axisClipRect);
      final int seriesIndex = painterKey.index;
      seriesRenderer.storeSeriesProperties(chart, seriesIndex);
      int segmentIndex = -1;
      for (int pointIndex = 0; pointIndex < dataPoints.length; pointIndex++) {
        final CartesianChartPoint<dynamic> currentPoint =
            dataPoints[pointIndex];
        seriesRenderer.calculateRegionData(
            chart, seriesRenderer, painterKey.index, currentPoint, pointIndex);
        if (currentPoint.isVisible && !currentPoint.isGap) {
          seriesRenderer.drawSegment(
              canvas,
              seriesRenderer.addSegment(currentPoint, segmentIndex += 1,
                  seriesIndex, animationFactor));
        }
      }
      if (series.animationDuration <= 0 ||
          animationFactor >= chart._seriesDurationFactor) {
        seriesRenderer.renderSeriesElements(
            chart, canvas, chartElementAnimation);
      }
      if (animationFactor >= 1) {
        chart._chartState
            .setPainterKey(painterKey.index, painterKey.name, true);
      }
    }
    canvas.restore();
  }

  @override
  bool shouldRepaint(_ScatterChartPainter oldDelegate) => isRepaint;
}
