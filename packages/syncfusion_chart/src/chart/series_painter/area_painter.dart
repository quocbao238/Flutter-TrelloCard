part of charts;

class _AreaChartPainter extends CustomPainter {
  _AreaChartPainter(
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
  final Animation<double> seriesAnimation;
  final Animation<double> chartElementAnimation;
  final Animation<double> animationController;
  final AreaSeriesRenderer seriesRenderer;
  final _PainterKey painterKey;

  /// Painter method for area series
  @override
  void paint(Canvas canvas, Size size) {
    final int seriesIndex = painterKey.index;
    Rect clipRect;
    final AreaSeries<dynamic, dynamic> series = seriesRenderer._series;
    seriesRenderer.storeSeriesProperties(chart, seriesIndex);
    double animationFactor;
    CartesianChartPoint<dynamic> prevPoint, point, _point;
    _ChartLocation currentPoint, originPoint, _oldPoint;
    final ChartAxis xAxis = seriesRenderer._xAxis;
    final ChartAxis yAxis = seriesRenderer._yAxis;
    CartesianSeriesRenderer oldSeriesRenderer;
    final Path _path = Path();
    final Path _strokePath = Path();
    if (seriesRenderer._visible) {
      final List<dynamic> oldSeriesRenderers =
          chart._chartState.oldSeriesRenderers;
      final List<dynamic> dataPoints = seriesRenderer._dataPoints;
      final bool widgetNeedUpdate = chart._chartState.widgetNeedUpdate;
      final bool isLegendToggled = chart._chartState._isLegendToggled;
      final bool isTransposed = seriesRenderer._chart._requireInvertedAxis;
      canvas.save();
      animationFactor = seriesAnimation != null ? seriesAnimation.value : 1;
      final Rect axisClipRect = _calculatePlotOffset(
          chart._chartAxis._axisClipRect,
          Offset(xAxis.plotOffset, yAxis.plotOffset));
      canvas.clipRect(axisClipRect);
      if (widgetNeedUpdate &&
          xAxis._zoomFactor == 1 &&
          yAxis._zoomFactor == 1 &&
          oldSeriesRenderers != null &&
          oldSeriesRenderers.isNotEmpty &&
          oldSeriesRenderers.length - 1 >= seriesIndex &&
          oldSeriesRenderers[seriesIndex]._seriesName ==
              seriesRenderer._seriesName) {
        oldSeriesRenderer = oldSeriesRenderers[seriesIndex];
      }
      if ((!(widgetNeedUpdate || isLegendToggled) ||
              !chart._chartState._oldSeriesKeys.contains(series.key)) &&
          series.animationDuration > 0) {
        _performLinearAnimation(chart, xAxis, canvas, animationFactor);
      }
      for (int pointIndex = 0; pointIndex < dataPoints.length; pointIndex++) {
        point = dataPoints[pointIndex];
        seriesRenderer.calculateRegionData(
            chart, seriesRenderer, painterKey.index, point, pointIndex);
        if (point.isVisible && !point.isDrop) {
          _point = (series.animationDuration > 0 &&
                  widgetNeedUpdate &&
                  !isLegendToggled &&
                  oldSeriesRenderers != null &&
                  oldSeriesRenderers.isNotEmpty &&
                  oldSeriesRenderer != null &&
                  oldSeriesRenderer._segments.isNotEmpty &&
                  oldSeriesRenderer._segments[0] is AreaSegment &&
                  oldSeriesRenderers.length - 1 >= seriesIndex &&
                  oldSeriesRenderer._dataPoints.length - 1 >= pointIndex)
              ? oldSeriesRenderer._dataPoints[pointIndex]
              : null;
          _oldPoint = _point != null
              ? _calculatePoint(
                  _point.xValue,
                  _point.yValue,
                  oldSeriesRenderer._xAxis,
                  oldSeriesRenderer._yAxis,
                  isTransposed,
                  oldSeriesRenderer._series,
                  axisClipRect)
              : null;
          currentPoint = _calculatePoint(point.xValue, point.yValue, xAxis,
              yAxis, isTransposed, series, axisClipRect);
          originPoint = _calculatePoint(
              point.xValue,
              math_lib.max(yAxis._visibleRange.minimum, 0),
              xAxis,
              yAxis,
              isTransposed,
              series,
              axisClipRect);
          num x = currentPoint.x;
          num y = currentPoint.y;
          final bool closed =
              series.emptyPointSettings.mode == EmptyPointMode.drop
                  ? _getVisibility(dataPoints, pointIndex)
                  : false;
          if (_oldPoint != null) {
            if (isTransposed) {
              x = _getValue(animationFactor, x, _oldPoint.x, currentPoint.x,
                  seriesRenderer);
            } else {
              y = _getValue(animationFactor, y, _oldPoint.y, currentPoint.y,
                  seriesRenderer);
            }
          }
          if (prevPoint == null ||
              dataPoints[pointIndex - 1].isGap == true ||
              (dataPoints[pointIndex].isGap == true) ||
              (dataPoints[pointIndex - 1].isVisible == false &&
                  series.emptyPointSettings.mode == EmptyPointMode.gap)) {
            _path.moveTo(originPoint.x, originPoint.y);
            if (series.borderDrawMode == BorderDrawMode.excludeBottom ||
                series.borderDrawMode == BorderDrawMode.all) {
              if (dataPoints[pointIndex].isGap != true) {
                _strokePath.moveTo(originPoint.x, originPoint.y);
                _strokePath.lineTo(x, y);
              }
            } else if (series.borderDrawMode == BorderDrawMode.top) {
              _strokePath.moveTo(x, y);
            }
            _path.lineTo(x, y);
          } else if (pointIndex == dataPoints.length - 1 ||
              dataPoints[pointIndex + 1].isGap == true) {
            _strokePath.lineTo(x, y);
            if (series.borderDrawMode == BorderDrawMode.excludeBottom)
              _strokePath.lineTo(originPoint.x, originPoint.y);
            else if (series.borderDrawMode == BorderDrawMode.all) {
              _strokePath.lineTo(originPoint.x, originPoint.y);
              _strokePath.close();
            }
            _path.lineTo(x, y);
            _path.lineTo(originPoint.x, originPoint.y);
          } else {
            _strokePath.lineTo(x, y);
            _path.lineTo(x, y);

            if (closed) {
              _path.lineTo(originPoint.x, originPoint.y);
              if (series.borderDrawMode == BorderDrawMode.excludeBottom) {
                _strokePath.lineTo(originPoint.x, originPoint.y);
              } else if (series.borderDrawMode == BorderDrawMode.all) {
                _strokePath.lineTo(originPoint.x, originPoint.y);
                _strokePath.close();
              }
            }
          }
          prevPoint = point;
        }
      }

      if (_path != null) {
        seriesRenderer.drawSegment(
            canvas,
            seriesRenderer.addSegment(
                _path, _strokePath, painterKey.index, animationFactor));
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

  /// It returns the visibility of area series
  bool _getVisibility(List<CartesianChartPoint<dynamic>> points, int index) {
    for (int i = index; i < points.length - 1; i++) {
      if (!points[i + 1].isDrop) {
        return false;
      }
    }
    return true;
  }

  @override
  bool shouldRepaint(_AreaChartPainter oldDelegate) => isRepaint;
}
