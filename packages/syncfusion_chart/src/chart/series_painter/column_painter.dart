part of charts;

class _ColumnChartPainter extends CustomPainter {
  _ColumnChartPainter(
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
  List<_ChartLocation> currentChartLocations = <_ChartLocation>[];
  ColumnSeriesRenderer seriesRenderer;
  final _PainterKey painterKey;

  /// Painter method for column series
  @override
  void paint(Canvas canvas, Size size) {
    final ChartAxis xAxis = seriesRenderer._xAxis;
    final ChartAxis yAxis = seriesRenderer._yAxis;
    final List<dynamic> dataPoints = seriesRenderer._dataPoints;
    final ColumnSeries<dynamic, dynamic> series = seriesRenderer._series;
    if (seriesRenderer._visible) {
      Rect axisClipRect, clipRect;
      double animationFactor;
      CartesianChartPoint<dynamic> point;
      canvas.save();
      final int seriesIndex = painterKey.index;
      seriesRenderer.storeSeriesProperties(chart, seriesIndex);
      axisClipRect = _calculatePlotOffset(chart._chartAxis._axisClipRect,
          Offset(xAxis.plotOffset, yAxis.plotOffset));
      canvas.clipRect(axisClipRect);
      animationFactor = seriesAnimation != null ? seriesAnimation.value : 1;
      int segmentIndex = -1;
      for (int pointIndex = 0; pointIndex < dataPoints.length; pointIndex++) {
        point = dataPoints[pointIndex];
        seriesRenderer.calculateRegionData(
            chart, seriesRenderer, painterKey.index, point, pointIndex);
        if (point.isVisible && !point.isGap) {
          seriesRenderer.drawSegment(
              canvas,
              seriesRenderer.addSegment(
                  point, segmentIndex += 1, painterKey.index, animationFactor));
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
      if (animationFactor >= 1) {
        chart._chartState
            .setPainterKey(painterKey.index, painterKey.name, true);
      }
    }
  }

  @override
  bool shouldRepaint(_ColumnChartPainter oldDelegate) => isRepaint;
}
