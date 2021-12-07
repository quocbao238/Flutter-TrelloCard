part of charts;

class _StepAreaChartPainter extends CustomPainter {
  _StepAreaChartPainter(
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
  final StepAreaSeriesRenderer seriesRenderer;
  final _PainterKey painterKey;

  /// Painter method for step area series
  @override
  void paint(Canvas canvas, Size size) {
    Rect clipRect;
    double animationFactor;
    CartesianChartPoint<dynamic> prevPoint, point;
    _ChartLocation currentPoint, originPoint, previousPoint;
    final ChartAxis xAxis = seriesRenderer._xAxis;
    final ChartAxis yAxis = seriesRenderer._yAxis;
    final StepAreaSeries<dynamic, dynamic> _series = seriesRenderer._series;
    final Path _path = Path();
    final Path _strokePath = Path();

    /// Clip rect will be added for series.
    if (seriesRenderer._visible) {
      canvas.save();
      final List<dynamic> dataPoints = seriesRenderer._dataPoints;
      final int seriesIndex = painterKey.index;
      final StepAreaSeries<dynamic, dynamic> series = seriesRenderer._series;
      final Rect axisClipRect = _calculatePlotOffset(
          chart._chartAxis._axisClipRect,
          Offset(seriesRenderer._xAxis.plotOffset,
              seriesRenderer._yAxis.plotOffset));
      canvas.clipRect(axisClipRect);
      seriesRenderer.storeSeriesProperties(chart, seriesIndex);
      animationFactor = seriesAnimation != null ? seriesAnimation.value : 1;
      if ((!(chart._chartState.widgetNeedUpdate ||
                  chart._chartState._isLegendToggled) ||
              !chart._chartState._oldSeriesKeys
                  .contains(seriesRenderer._series.key)) &&
          seriesRenderer._series.animationDuration > 0) {
        _performLinearAnimation(seriesRenderer._chart, seriesRenderer._xAxis,
            canvas, animationFactor);
      }

      for (int pointIndex = 0; pointIndex < dataPoints.length; pointIndex++) {
        point = dataPoints[pointIndex];
        seriesRenderer.calculateRegionData(
            chart, seriesRenderer, painterKey.index, point, pointIndex);
        if (point.isVisible) {
          currentPoint = _calculatePoint(
              point.xValue,
              point.yValue,
              xAxis,
              yAxis,
              seriesRenderer._chart._requireInvertedAxis,
              series,
              axisClipRect);
          previousPoint = prevPoint != null
              ? _calculatePoint(
                  prevPoint?.xValue,
                  prevPoint?.yValue,
                  xAxis,
                  yAxis,
                  seriesRenderer._chart._requireInvertedAxis,
                  series,
                  axisClipRect)
              : prevPoint;
          originPoint = _calculatePoint(
              point.xValue,
              math_lib.max(yAxis._visibleRange.minimum, 0),
              xAxis,
              yAxis,
              seriesRenderer._chart._requireInvertedAxis,
              series,
              axisClipRect);
          _drawStepAreaPath(_path, _strokePath, prevPoint, currentPoint,
              originPoint, previousPoint, pointIndex, _series);
          prevPoint = point;
        }
      }

      if (_path != null && _strokePath != null) {
        seriesRenderer.drawSegment(
            canvas,
            seriesRenderer.addSegment(
                _path, _strokePath, painterKey.index, animationFactor));
      }

      clipRect = _calculatePlotOffset(
          Rect.fromLTRB(
              chart._chartAxis._axisClipRect.left -
                  seriesRenderer._series.markerSettings.width,
              chart._chartAxis._axisClipRect.top -
                  seriesRenderer._series.markerSettings.height,
              chart._chartAxis._axisClipRect.right +
                  seriesRenderer._series.markerSettings.width,
              chart._chartAxis._axisClipRect.bottom +
                  seriesRenderer._series.markerSettings.height),
          Offset(seriesRenderer._xAxis.plotOffset,
              seriesRenderer._yAxis.plotOffset));
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
  bool shouldRepaint(_StepAreaChartPainter oldDelegate) => isRepaint;

  /// To draw the step area path
  void _drawStepAreaPath(
      Path _path,
      Path _strokePath,
      CartesianChartPoint<dynamic> prevPoint,
      _ChartLocation currentPoint,
      _ChartLocation originPoint,
      _ChartLocation previousPoint,
      int pointIndex,
      StepAreaSeries<dynamic, dynamic> stepAreaSeries) {
    final num x = currentPoint.x;
    final num y = currentPoint.y;
    final bool closed =
        stepAreaSeries.emptyPointSettings.mode == EmptyPointMode.drop
            ? _getVisibility(seriesRenderer._dataPoints, pointIndex)
            : false;
    if (prevPoint == null ||
        seriesRenderer._dataPoints[pointIndex - 1].isGap == true ||
        (seriesRenderer._dataPoints[pointIndex].isGap == true) ||
        (seriesRenderer._dataPoints[pointIndex - 1].isVisible == false &&
            stepAreaSeries.emptyPointSettings.mode == EmptyPointMode.gap)) {
      _path.moveTo(originPoint.x, originPoint.y);
      if (stepAreaSeries.borderDrawMode == BorderDrawMode.excludeBottom) {
        if (seriesRenderer._dataPoints[pointIndex].isGap != true) {
          _strokePath.moveTo(originPoint.x, originPoint.y);
          _strokePath.lineTo(x, y);
        }
      } else if (stepAreaSeries.borderDrawMode == BorderDrawMode.all) {
        if (seriesRenderer._dataPoints[pointIndex].isGap != true) {
          _strokePath.moveTo(originPoint.x, originPoint.y);
          _strokePath.lineTo(x, y);
        }
      } else if (stepAreaSeries.borderDrawMode == BorderDrawMode.top) {
        _strokePath.moveTo(x, y);
      }
      _path.lineTo(x, y);
    } else if (pointIndex == seriesRenderer._dataPoints.length - 1 ||
        seriesRenderer._dataPoints[pointIndex + 1].isGap == true) {
      _strokePath.lineTo(x, previousPoint.y);
      _strokePath.lineTo(x, y);
      if (stepAreaSeries.borderDrawMode == BorderDrawMode.excludeBottom)
        _strokePath.lineTo(originPoint.x, originPoint.y);
      else if (stepAreaSeries.borderDrawMode == BorderDrawMode.all) {
        _strokePath.lineTo(originPoint.x, originPoint.y);
        _strokePath.close();
      }
      _path.lineTo(x, previousPoint.y);
      _path.lineTo(x, y);
      _path.lineTo(originPoint.x, originPoint.y);
    } else {
      _path.lineTo(x, previousPoint.y);
      _strokePath.lineTo(x, previousPoint.y);
      _strokePath.lineTo(x, y);
      _path.lineTo(x, y);
      if (closed) {
        _path.lineTo(originPoint.x, originPoint.y);
        if (stepAreaSeries.borderDrawMode == BorderDrawMode.excludeBottom) {
          _strokePath.lineTo(originPoint.x, originPoint.y);
        } else if (stepAreaSeries.borderDrawMode == BorderDrawMode.all) {
          _strokePath.lineTo(originPoint.x, originPoint.y);
          _strokePath.close();
        }
      }
    }
  }

  /// To find the visibility of a series
  bool _getVisibility(List<CartesianChartPoint<dynamic>> points, int index) {
    for (int i = index; i < points.length - 1; i++) {
      if (!points[i + 1].isDrop) {
        return false;
      }
    }
    return true;
  }
}
