part of charts;

class _HistogramChartPainter extends CustomPainter {
  _HistogramChartPainter(
      {this.chart,
      this.seriesRenderer,
      this.chartSeries,
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
  HistogramSeriesRenderer seriesRenderer;
  _ChartSeries chartSeries;
  final _PainterKey painterKey;

  /// Painter method for histogram series
  @override
  void paint(Canvas canvas, Size size) {
    Rect axisClipRect, clipRect;
    double animationFactor;
    CartesianChartPoint<dynamic> point;
    final ChartAxis xAxis = seriesRenderer._xAxis;
    final ChartAxis yAxis = seriesRenderer._yAxis;
    final List<dynamic> dataPoints = seriesRenderer._dataPoints;

    /// Clip rect added
    if (seriesRenderer._visible) {
      final HistogramSeries<dynamic, dynamic> series = seriesRenderer._series;
      canvas.save();
      final int seriesIndex = painterKey.index;
      seriesRenderer.storeSeriesProperties(chart, seriesIndex);
      axisClipRect = _calculatePlotOffset(chart._chartAxis._axisClipRect,
          Offset(xAxis.plotOffset, yAxis.plotOffset));
      canvas.clipRect(axisClipRect);
      animationFactor = seriesAnimation != null ? seriesAnimation.value : 1;

      /// side by side range calculated
      final _VisibleRange sideBySideInfo =
          _calculateSideBySideInfo(seriesRenderer, chart);

      int segmentIndex = -1;
      for (int pointIndex = 0; pointIndex < dataPoints.length; pointIndex++) {
        point = dataPoints[pointIndex];
        seriesRenderer.calculateRegionData(chart, seriesRenderer,
            painterKey.index, point, pointIndex, sideBySideInfo);
        if (point.isVisible && !point.isGap) {
          seriesRenderer.drawSegment(
              canvas,
              seriesRenderer.addSegment(point, segmentIndex += 1,
                  sideBySideInfo, painterKey.index, animationFactor));
        }
      }
      if (series.showNormalDistributionCurve) {
        if ((!(chart._chartState.widgetNeedUpdate ||
                    chart._chartState._isLegendToggled) ||
                !chart._chartState._oldSeriesKeys.contains(series.key)) &&
            series.animationDuration > 0) {
          _performLinearAnimation(
              seriesRenderer._chart, xAxis, canvas, animationFactor);
        }
        final Path _path =
            seriesRenderer._findNormalDistributionPath(series, chart);
        final Paint _paint = Paint()
          ..strokeWidth = series.curveWidth
          ..color = series.curveColor
          ..style = PaintingStyle.stroke;
        series.curveDashArray == null
            ? canvas.drawPath(_path, _paint)
            : _drawDashedLine(canvas, series.curveDashArray, _paint, _path);
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
              !chart._chartState.initialRender ||
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
  bool shouldRepaint(_HistogramChartPainter oldDelegate) => isRepaint;
}
