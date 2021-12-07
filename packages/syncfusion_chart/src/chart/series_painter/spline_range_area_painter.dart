part of charts;

class _SplineRangeAreaChartPainter extends CustomPainter {
  _SplineRangeAreaChartPainter(
      {this.chart,
      this.isRepaint,
      this.animationController,
      this.seriesAnimation,
      this.chartElementAnimation,
      ValueNotifier<num> notifier,
      this.painterKey,
      this.seriesRenderer})
      : super(repaint: notifier);
  final SfCartesianChart chart;
  final bool isRepaint;
  final Animation<double> seriesAnimation;
  final Animation<double> chartElementAnimation;
  final Animation<double> animationController;
  final SplineRangeAreaSeriesRenderer seriesRenderer;
  final _PainterKey painterKey;

  /// Painter method for spline range area series
  @override
  void paint(Canvas canvas, Size size) {
    Rect clipRect;
    double animationFactor;
    _ChartLocation currentPointLow,
        currentPointHigh,
        renderPointlow,
        renderPointhigh;
    final int pointsLength = seriesRenderer._dataPoints.length;
    CartesianChartPoint<dynamic> prevPoint, point;
    List<_ControlPoints> controlPointslow;
    List<_ControlPoints> controlPointshigh;
    final Path _path = Path();
    final Path _strokePath = Path();
    final List<dynamic> dataPoints = seriesRenderer._dataPoints;
    _ChartLocation renderControlPointlow1,
        renderControlPointlow2,
        renderControlPointhigh1,
        renderControlPointhigh2;
    seriesRenderer?._drawHighControlPoints?.clear();
    seriesRenderer?._drawLowControlPoints?.clear();

    /// Clip rect will be added for series.
    if (seriesRenderer._visible) {
      canvas.save();
      final int seriesIndex = painterKey.index;
      seriesRenderer.storeSeriesProperties(chart, seriesIndex);
      final bool isTransposed = chart._requireInvertedAxis;
      final SplineRangeAreaSeries<dynamic, dynamic> series =
          seriesRenderer._series;
      SplineRangeAreaSegment splineRangeAreaSegment;
      final ChartAxis xAxis = seriesRenderer._xAxis;
      final ChartAxis yAxis = seriesRenderer._yAxis;
      final Rect axisClipRect = _calculatePlotOffset(
          chart._chartAxis._axisClipRect,
          Offset(xAxis.plotOffset, yAxis.plotOffset));
      canvas.clipRect(axisClipRect);
      animationFactor = seriesAnimation != null ? seriesAnimation.value : 1;
      if ((!(chart._chartState.widgetNeedUpdate ||
                  chart._chartState._isLegendToggled) ||
              !chart._chartState._oldSeriesKeys.contains(series.key)) &&
          series.animationDuration > 0) {
        _performLinearAnimation(
            seriesRenderer._chart, xAxis, canvas, animationFactor);
      }
      _calculateSplineAreaControlPoints(seriesRenderer);

      for (int pointIndex = 0; pointIndex < pointsLength; pointIndex++) {
        point = seriesRenderer._dataPoints[pointIndex];
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
            _strokePath.moveTo(currentPointHigh.x, currentPointHigh.y);
          } else if (pointIndex == dataPoints.length - 1 ||
              dataPoints[pointIndex + 1].isGap == true) {
            controlPointshigh = seriesRenderer
                ._drawHighControlPoints[
                    seriesRenderer._dataPoints.indexOf(point) - 1]
                ._listControlPoints;

            renderPointhigh = _calculatePoint(point.xValue, point.high, xAxis,
                yAxis, isTransposed, series, axisClipRect);

            renderControlPointhigh1 = _calculatePoint(
                controlPointshigh[0].controlPoint1,
                controlPointshigh[0].controlPoint2,
                xAxis,
                yAxis,
                isTransposed,
                series,
                axisClipRect);

            renderControlPointhigh2 = _calculatePoint(
                controlPointshigh[1].controlPoint1,
                controlPointshigh[1].controlPoint2,
                xAxis,
                yAxis,
                isTransposed,
                series,
                axisClipRect);

            _path.cubicTo(
                renderControlPointhigh1.x,
                renderControlPointhigh1.y,
                renderControlPointhigh2.x,
                renderControlPointhigh2.y,
                renderPointhigh.x,
                renderPointhigh.y);
            _strokePath.cubicTo(
                renderControlPointhigh1.x,
                renderControlPointhigh1.y,
                renderControlPointhigh2.x,
                renderControlPointhigh2.y,
                renderPointhigh.x,
                renderPointhigh.y);
            _path.lineTo(currentPointLow.x, currentPointLow.y);
            _strokePath.lineTo(currentPointHigh.x, currentPointHigh.y);
            _strokePath.moveTo(currentPointLow.x, currentPointLow.y);
          } else {
            controlPointshigh = seriesRenderer
                ._drawHighControlPoints[
                    seriesRenderer._dataPoints.indexOf(point) - 1]
                ._listControlPoints;

            renderPointhigh = _calculatePoint(point.xValue, point.high, xAxis,
                yAxis, isTransposed, series, axisClipRect);

            renderControlPointhigh1 = _calculatePoint(
                controlPointshigh[0].controlPoint1,
                controlPointshigh[0].controlPoint2,
                xAxis,
                yAxis,
                isTransposed,
                series,
                axisClipRect);

            renderControlPointhigh2 = _calculatePoint(
                controlPointshigh[1].controlPoint1,
                controlPointshigh[1].controlPoint2,
                xAxis,
                yAxis,
                isTransposed,
                series,
                axisClipRect);

            _path.cubicTo(
                renderControlPointhigh1.x,
                renderControlPointhigh1.y,
                renderControlPointhigh2.x,
                renderControlPointhigh2.y,
                renderPointhigh.x,
                renderPointhigh.y);

            _strokePath.cubicTo(
                renderControlPointhigh1.x,
                renderControlPointhigh1.y,
                renderControlPointhigh2.x,
                renderControlPointhigh2.y,
                renderPointhigh.x,
                renderPointhigh.y);
          }

          prevPoint = point;
        }
        if (pointIndex >= dataPoints.length - 1) {
          seriesRenderer.addSegment(
              painterKey.index, chart, animationFactor, _path, _strokePath);
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
            _strokePath.moveTo(currentPointLow.x, currentPointLow.y);
            _path.moveTo(currentPointLow.x, currentPointLow.y);
          } else if (dataPoints[pointIndex].isGap != true) {
            if (pointIndex + 1 == dataPoints.length - 1 &&
                dataPoints[pointIndex + 1].isDrop) {
              _strokePath.moveTo(currentPointLow.x, currentPointLow.y);
            } else {
              controlPointslow = seriesRenderer
                  ._drawLowControlPoints[
                      seriesRenderer._dataPoints.indexOf(point)]
                  ._listControlPoints;

              renderPointlow = _calculatePoint(
                  point.xValue,
                  point.low,
                  xAxis,
                  yAxis,
                  seriesRenderer._chart._requireInvertedAxis,
                  series,
                  axisClipRect);

              renderControlPointlow1 = _calculatePoint(
                  controlPointslow[0].controlPoint1,
                  controlPointslow[0].controlPoint2,
                  xAxis,
                  yAxis,
                  seriesRenderer._chart._requireInvertedAxis,
                  series,
                  axisClipRect);

              renderControlPointlow2 = _calculatePoint(
                  controlPointslow[1].controlPoint1,
                  controlPointslow[1].controlPoint2,
                  xAxis,
                  yAxis,
                  seriesRenderer._chart._requireInvertedAxis,
                  series,
                  axisClipRect);
              _strokePath.cubicTo(
                  renderControlPointlow2.x,
                  renderControlPointlow2.y,
                  renderControlPointlow1.x,
                  renderControlPointlow1.y,
                  renderPointlow.x,
                  renderPointlow.y);
            }
            controlPointslow = seriesRenderer
                ._drawLowControlPoints[
                    seriesRenderer._dataPoints.indexOf(point)]
                ._listControlPoints;

            renderPointlow = _calculatePoint(
                point.xValue,
                point.low,
                xAxis,
                yAxis,
                seriesRenderer._chart._requireInvertedAxis,
                series,
                axisClipRect);

            renderControlPointlow1 = _calculatePoint(
                controlPointslow[0].controlPoint1,
                controlPointslow[0].controlPoint2,
                xAxis,
                yAxis,
                seriesRenderer._chart._requireInvertedAxis,
                series,
                axisClipRect);

            renderControlPointlow2 = _calculatePoint(
                controlPointslow[1].controlPoint1,
                controlPointslow[1].controlPoint2,
                xAxis,
                yAxis,
                seriesRenderer._chart._requireInvertedAxis,
                series,
                axisClipRect);

            _path.cubicTo(
                renderControlPointlow2.x,
                renderControlPointlow2.y,
                renderControlPointlow1.x,
                renderControlPointlow1.y,
                renderPointlow.x,
                renderPointlow.y);
          }
        }
      }

      /// Draw the spline range area series
      if (_path != null &&
          seriesRenderer._segments != null &&
          seriesRenderer._segments.isNotEmpty) {
        splineRangeAreaSegment = seriesRenderer._segments[0];
        seriesRenderer.drawSegment(
            canvas,
            splineRangeAreaSegment
              .._path = _path
              .._strokePath = _strokePath);
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
  bool shouldRepaint(_SplineRangeAreaChartPainter oldDelegate) => isRepaint;
}
