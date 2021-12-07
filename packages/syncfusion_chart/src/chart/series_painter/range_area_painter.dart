part of charts;

class _RangeAreaChartPainter extends CustomPainter {
  _RangeAreaChartPainter(
      {this.chart,
      this.seriesRenderer,
      this.isRepaint,
      this.animationController,
      this.seriesAnimation,
      this.chartElementAnimation,
      this.painterKey,
      ValueNotifier<num> notifier})
      : super(repaint: notifier);
  final SfCartesianChart chart;
  final bool isRepaint;
  final Animation<double> seriesAnimation;
  final Animation<double> chartElementAnimation;
  final Animation<double> animationController;
  final RangeAreaSeriesRenderer seriesRenderer;
  final _PainterKey painterKey;

  /// Painter method for range area series
  @override
  void paint(Canvas canvas, Size size) {
    final RangeAreaSeries<dynamic, dynamic> series = seriesRenderer._series;
    Rect clipRect;
    final ChartAxis xAxis = seriesRenderer._xAxis;
    final ChartAxis yAxis = seriesRenderer._yAxis;
    final List<dynamic> dataPoints = seriesRenderer._dataPoints;
    CartesianChartPoint<dynamic> point, prevPoint;
    final Path _path = Path();
    _ChartLocation currentPointLow, currentPointHigh;
    double animationFactor;
    final Path _borderPath = Path();
    RangeAreaSegment rangeAreaSegment;
    if (seriesRenderer._visible) {
      final int seriesIndex = painterKey.index;
      seriesRenderer.storeSeriesProperties(chart, seriesIndex);
      final bool isTransposed = chart._requireInvertedAxis;
      final Rect axisClipRect = _calculatePlotOffset(
          chart._chartAxis._axisClipRect,
          Offset(xAxis.plotOffset, yAxis.plotOffset));
      canvas.save();
      canvas.clipRect(axisClipRect);
      animationFactor = seriesAnimation != null ? seriesAnimation.value : 1;
      if ((!(chart._chartState.widgetNeedUpdate ||
                  chart._chartState._isLegendToggled) ||
              !chart._chartState._oldSeriesKeys.contains(series.key)) &&
          series.animationDuration > 0) {
        _performLinearAnimation(
            seriesRenderer._chart, xAxis, canvas, animationFactor);
      }
      for (int pointIndex = 0; pointIndex < dataPoints.length; pointIndex++) {
        point = dataPoints[pointIndex];
        seriesRenderer.calculateRegionData(
            chart, seriesRenderer, painterKey.index, point, pointIndex);
        if (point.isVisible && !point.isDrop) {
          currentPointLow = _calculatePoint(point.xValue, point.low, xAxis,
              yAxis, isTransposed, series, axisClipRect);
          currentPointHigh = _calculatePoint(point.xValue, point.high, xAxis,
              yAxis, isTransposed, series, axisClipRect);

          if (prevPoint == null ||
              dataPoints[pointIndex - 1].isGap == true ||
              (dataPoints[pointIndex].isGap == true) ||
              (dataPoints[pointIndex - 1].isVisible == false &&
                  series.emptyPointSettings.mode == EmptyPointMode.gap)) {
            _path.moveTo(currentPointLow.x, currentPointLow.y);
            _path.lineTo(currentPointHigh.x, currentPointHigh.y);
            _borderPath.moveTo(currentPointHigh.x, currentPointHigh.y);
          } else if (pointIndex == dataPoints.length - 1 ||
              dataPoints[pointIndex + 1].isGap == true) {
            _path.lineTo(currentPointHigh.x, currentPointHigh.y);
            _path.lineTo(currentPointLow.x, currentPointLow.y);
            _borderPath.lineTo(currentPointHigh.x, currentPointHigh.y);
            _borderPath.moveTo(currentPointLow.x, currentPointLow.y);
          } else {
            _borderPath.lineTo(currentPointHigh.x, currentPointHigh.y);
            _path.lineTo(currentPointHigh.x, currentPointHigh.y);
          }
          prevPoint = point;
        }
        if (pointIndex >= dataPoints.length - 1) {
          seriesRenderer.addSegment(painterKey.index, chart, animationFactor);
        }
      }
      for (int pointIndex = dataPoints.length - 2;
          pointIndex >= 0;
          pointIndex--) {
        point = dataPoints[pointIndex];
        if (point.isVisible && !point.isDrop) {
          currentPointLow = _calculatePoint(point.xValue, point.low, xAxis,
              yAxis, isTransposed, series, axisClipRect);
          currentPointHigh = _calculatePoint(point.xValue, point.high, xAxis,
              yAxis, isTransposed, series, axisClipRect);

          if (dataPoints[pointIndex + 1].isGap == true) {
            _borderPath.moveTo(currentPointLow.x, currentPointLow.y);
            _path.moveTo(currentPointLow.x, currentPointLow.y);
          } else if (dataPoints[pointIndex].isGap != true) {
            if (pointIndex + 1 == dataPoints.length - 1 &&
                dataPoints[pointIndex + 1].isDrop) {
              _borderPath.moveTo(currentPointLow.x, currentPointLow.y);
            } else {
              _borderPath.lineTo(currentPointLow.x, currentPointLow.y);
            }
            _path.lineTo(currentPointLow.x, currentPointLow.y);
          }

          prevPoint = point;
        }
      }

      if (_path != null &&
          seriesRenderer._segments != null &&
          seriesRenderer._segments.isNotEmpty) {
        rangeAreaSegment = seriesRenderer._segments[0];
        seriesRenderer.drawSegment(
            canvas,
            rangeAreaSegment
              .._path = _path
              .._borderPath = _borderPath);
      }

      clipRect = _calculatePlotOffset(
          Rect.fromLTWH(
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
  bool shouldRepaint(_RangeAreaChartPainter oldDelegate) => isRepaint;
}
