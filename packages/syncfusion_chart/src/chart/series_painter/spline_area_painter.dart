part of charts;

class _SplineAreaChartPainter extends CustomPainter {
  _SplineAreaChartPainter(
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
  final SplineAreaSeriesRenderer seriesRenderer;
  final _PainterKey painterKey;
  final Path _path = Path();
  final Path _strokePath = Path();

  /// Painter method for spline area series
  @override
  void paint(Canvas canvas, Size size) {
    Rect clipRect;
    double animationFactor;
    final ChartAxis xAxis = seriesRenderer._xAxis;
    final ChartAxis yAxis = seriesRenderer._yAxis;
    final SplineAreaSeries<dynamic, dynamic> splineAreaSeries =
        seriesRenderer._series;
    SplineAreaSegment splineAreaSegment;
    _ChartLocation startPoint, renderPoint;
    final int pointsLength = seriesRenderer._dataPoints.length;
    CartesianChartPoint<dynamic> firstPoint, point;
    seriesRenderer?._drawControlPoints?.clear();

    /// Clip rect will be added for series.
    if (seriesRenderer._visible) {
      canvas.save();
      final int seriesIndex = painterKey.index;
      seriesRenderer.storeSeriesProperties(chart, seriesIndex);
      final Rect axisClipRect = _calculatePlotOffset(
          chart._chartAxis._axisClipRect,
          Offset(xAxis.plotOffset, yAxis.plotOffset));
      canvas.clipRect(axisClipRect);
      animationFactor = seriesAnimation != null ? seriesAnimation.value : 1;
      if ((!(chart._chartState.widgetNeedUpdate ||
                  chart._chartState._isLegendToggled) ||
              !chart._chartState._oldSeriesKeys
                  .contains(splineAreaSeries.key)) &&
          splineAreaSeries.animationDuration > 0) {
        _performLinearAnimation(
            seriesRenderer._chart, xAxis, canvas, animationFactor);
      }
      _calculateSplineAreaControlPoints(seriesRenderer);

      for (int i = 0; i < pointsLength; i++) {
        point = seriesRenderer._dataPoints[i];
        seriesRenderer.calculateRegionData(
            chart, seriesRenderer, painterKey.index, point, i);
        if (point.isVisible) {
          final List<_ChartLocation> _list = _renderSplineAreaSeries(
              i,
              firstPoint,
              point,
              startPoint,
              renderPoint,
              axisClipRect,
              xAxis,
              yAxis,
              splineAreaSeries);
          renderPoint = _list[0];
          startPoint = _list[1];
          firstPoint = point;
        } else {
          firstPoint = (i != 0 && point.isDrop == true) ? point : null;
        }
        if (((i + 1 < pointsLength &&
                    !seriesRenderer._dataPoints[i + 1].isVisible) ||
                i == pointsLength - 1) &&
            renderPoint != null &&
            startPoint != null) {
          startPoint = _calculatePoint(
              i + 1 < pointsLength && seriesRenderer._dataPoints[i + 1].isDrop
                  ? seriesRenderer._dataPoints[i].xValue
                  : i == pointsLength - 1 &&
                          seriesRenderer._dataPoints[i].isDrop
                      ? seriesRenderer._dataPoints[i - 1].xValue
                      : seriesRenderer._dataPoints[i].xValue,
              i + 1 < pointsLength && seriesRenderer._dataPoints[i + 1].isDrop
                  ? seriesRenderer._dataPoints[i].yValue
                  : math_lib.max(yAxis._visibleRange.minimum, 0),
              xAxis,
              yAxis,
              seriesRenderer._chart._requireInvertedAxis,
              splineAreaSeries,
              axisClipRect);
          _path.lineTo(startPoint.x, startPoint.y);
          if (splineAreaSeries.borderDrawMode != BorderDrawMode.top)
            _strokePath.lineTo(startPoint.x, startPoint.y);
        }
        if (i >= pointsLength - 1) {
          seriesRenderer.addSegment(
              painterKey.index, chart, animationFactor, _path, _strokePath);
        }
      }
      if (splineAreaSeries.borderDrawMode == BorderDrawMode.all) {
        _strokePath.close();
      }
      if (_path != null &&
          seriesRenderer._segments != null &&
          seriesRenderer._segments.isNotEmpty) {
        splineAreaSegment = seriesRenderer._segments[0];
        seriesRenderer.drawSegment(
            canvas,
            splineAreaSegment
              .._path = _path
              .._strokePath = _strokePath);
      }

      clipRect = _calculatePlotOffset(
          Rect.fromLTRB(
              chart._chartAxis._axisClipRect.left -
                  splineAreaSeries.markerSettings.width,
              chart._chartAxis._axisClipRect.top -
                  splineAreaSeries.markerSettings.height,
              chart._chartAxis._axisClipRect.right +
                  splineAreaSeries.markerSettings.width,
              chart._chartAxis._axisClipRect.bottom +
                  splineAreaSeries.markerSettings.height),
          Offset(xAxis.plotOffset, yAxis.plotOffset));
      canvas.restore();
      if ((splineAreaSeries.animationDuration <= 0 ||
              !chart._chartState.initialRender ||
              animationFactor >= chart._seriesDurationFactor) &&
          (splineAreaSeries.markerSettings.isVisible ||
              splineAreaSeries.dataLabelSettings.isVisible)) {
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
  bool shouldRepaint(_SplineAreaChartPainter oldDelegate) => isRepaint;

  List<_ChartLocation> _renderSplineAreaSeries(
      int i,
      CartesianChartPoint<dynamic> firstPoint,
      CartesianChartPoint<dynamic> point,
      _ChartLocation startPoint,
      _ChartLocation renderPoint,
      Rect rect,
      ChartAxis xAxis,
      ChartAxis yAxis,
      SplineAreaSeries<dynamic, dynamic> splineAreaSeries) {
    List<_ControlPoints> controlPoint;
    _ChartLocation renderControlPoint1, startPoint1, renderControlPoint2;
    if (firstPoint != null) {
      controlPoint = seriesRenderer
          ._drawControlPoints[seriesRenderer._dataPoints.indexOf(point) - 1]
          ._listControlPoints;
      renderPoint = _calculatePoint(point.xValue, point.yValue, xAxis, yAxis,
          seriesRenderer._chart._requireInvertedAxis, splineAreaSeries, rect);
      renderControlPoint1 = _calculatePoint(
          controlPoint[0].controlPoint1,
          controlPoint[0].controlPoint2,
          xAxis,
          yAxis,
          seriesRenderer._chart._requireInvertedAxis,
          splineAreaSeries,
          rect);
      renderControlPoint2 = _calculatePoint(
          controlPoint[1].controlPoint1,
          controlPoint[1].controlPoint2,
          xAxis,
          yAxis,
          seriesRenderer._chart._requireInvertedAxis,
          splineAreaSeries,
          rect);
      _path.cubicTo(
          renderControlPoint1.x,
          renderControlPoint1.y,
          renderControlPoint2.x,
          renderControlPoint2.y,
          renderPoint.x,
          renderPoint.y);
      _strokePath.cubicTo(
          renderControlPoint1.x,
          renderControlPoint1.y,
          renderControlPoint2.x,
          renderControlPoint2.y,
          renderPoint.x,
          renderPoint.y);
    } else {
      startPoint = _calculatePoint(
          seriesRenderer._dataPoints[i].xValue,
          math_lib.max(yAxis._visibleRange.minimum, 0),
          xAxis,
          yAxis,
          seriesRenderer._chart._requireInvertedAxis,
          splineAreaSeries,
          rect);
      _path.moveTo(startPoint.x, startPoint.y);
      if (splineAreaSeries.borderDrawMode != BorderDrawMode.top)
        _strokePath.moveTo(startPoint.x, startPoint.y);
      startPoint1 = _calculatePoint(
          seriesRenderer._dataPoints[i].xValue,
          seriesRenderer._dataPoints[i].yValue,
          xAxis,
          yAxis,
          seriesRenderer._chart._requireInvertedAxis,
          splineAreaSeries,
          rect);
      _path.lineTo(startPoint1.x, startPoint1.y);
      if (splineAreaSeries.borderDrawMode == BorderDrawMode.top)
        _strokePath.moveTo(startPoint1.x, startPoint1.y);
      _strokePath.lineTo(startPoint1.x, startPoint1.y);
    }
    return <_ChartLocation>[renderPoint, startPoint];
  }
}
