part of charts;

class _TrendlinePainter extends CustomPainter {
  _TrendlinePainter(
      {this.chart, this.trendlineAnimation, ValueNotifier<num> notifier})
      : super(repaint: notifier);
  final SfCartesianChart chart;
  final Animation<double> trendlineAnimation;

  @override
  void paint(Canvas canvas, Size size) {
    Rect clipRect;
    double animationFactor;
    for (CartesianSeriesRenderer seriesRenderer
        in chart._chartSeries.visibleSeriesRenderers) {
      final XyDataSeries<dynamic, dynamic> series = seriesRenderer._series;
      if (series.trendlines != null) {
        for (Trendline trendline in series.trendlines) {
          if (trendline._isNeedRender && trendline.isVisible) {
            canvas.save();
            animationFactor = (trendlineAnimation != null &&
                    !seriesRenderer._chart._chartState._isLegendToggled)
                ? trendlineAnimation.value
                : 1;
            final Rect axisClipRect = _calculatePlotOffset(
                chart._chartAxis._axisClipRect,
                Offset(seriesRenderer._xAxis.plotOffset,
                    seriesRenderer._yAxis.plotOffset));
            canvas.clipRect(axisClipRect);
            final Path path = Path();
            final Paint paint = Paint();
            paint.strokeWidth = trendline.width;
            paint.color = trendline._fillColor.withOpacity(trendline._opacity);
            paint.style = PaintingStyle.stroke;
            if (series.animationDuration > 0 &&
                !(seriesRenderer._chart._chartState.widgetNeedUpdate ||
                    seriesRenderer._chart._chartState._isLegendToggled)) {
              _performLinearAnimation(seriesRenderer._chart,
                  seriesRenderer._xAxis, canvas, animationFactor);
            }
            renderTrendlineEvent(
                trendline,
                series.trendlines.indexOf(trendline),
                chart._chartSeries.visibleSeriesRenderers
                    .indexOf(seriesRenderer),
                seriesRenderer._seriesName);
            if (trendline.type == TrendlineType.linear) {
              path.moveTo(trendline.points[0].dx, trendline.points[0].dy);
              path.lineTo(trendline.points[1].dx, trendline.points[1].dy);
            } else if (trendline.type == TrendlineType.exponential ||
                trendline.type == TrendlineType.power ||
                trendline.type == TrendlineType.logarithmic) {
              path.moveTo(trendline.points[0].dx, trendline.points[0].dy);
              for (int i = 0; i < trendline.points.length - 1; i++) {
                final List<double> controlPoints =
                    trendline._getControlPoints(trendline.points, i);
                path.cubicTo(
                    controlPoints[0],
                    controlPoints[1],
                    controlPoints[2],
                    controlPoints[3],
                    trendline.points[i + 1].dx,
                    trendline.points[i + 1].dy);
              }
            } else if (trendline.type == TrendlineType.polynomial) {
              final List<Offset> polynomialPoints =
                  trendline.getPolynomialCurve(
                      trendline._pointsData, seriesRenderer, chart);
              path.moveTo(polynomialPoints[0].dx, polynomialPoints[0].dy);
              for (int i = 1; i < polynomialPoints.length; i++)
                path.lineTo(polynomialPoints[i].dx, polynomialPoints[i].dy);
            } else if (trendline.type == TrendlineType.movingAverage) {
              path.moveTo(trendline.points[0].dx, trendline.points[0].dy);
              for (int i = 1; i < trendline.points.length; i++)
                path.lineTo(trendline.points[i].dx, trendline.points[i].dy);
            }
            if (trendline._dashArray != null)
              _drawDashedLine(canvas, trendline._dashArray, paint, path);
            else
              canvas.drawPath(path, paint);
            clipRect = _calculatePlotOffset(
                Rect.fromLTRB(
                    chart._chartAxis._axisClipRect.left -
                        trendline.markerSettings.width,
                    chart._chartAxis._axisClipRect.top -
                        trendline.markerSettings.height,
                    chart._chartAxis._axisClipRect.right +
                        trendline.markerSettings.width,
                    chart._chartAxis._axisClipRect.bottom +
                        trendline.markerSettings.height),
                Offset(seriesRenderer._xAxis.plotOffset,
                    seriesRenderer._yAxis.plotOffset));
            canvas.restore();
            if (trendline._visible &&
                (animationFactor > chart._trendlineDurationFactor)) {
              canvas.clipRect(clipRect);
              if (trendline.markerSettings.isVisible) {
                for (CartesianChartPoint<dynamic> point
                    in trendline._pointsData) {
                  if (point.isVisible && point.isGap != true) {
                    if (trendline.markerSettings.shape ==
                        DataMarkerType.image) {
                      _drawImageMarker(seriesRenderer, canvas,
                          point.markerPoint.x, point.markerPoint.y);
                    }
                    final Paint strokePaint = Paint()
                      ..color = trendline.markerSettings.borderWidth == 0
                          ? Colors.transparent
                          : ((point.pointColorMapper != null)
                              ? point.pointColorMapper
                              : trendline.markerSettings.borderColor ??
                                  trendline._fillColor)
                      ..strokeWidth = trendline.markerSettings.borderWidth
                      ..style = PaintingStyle.stroke;

                    final Paint fillPaint = Paint()
                      ..color = trendline.markerSettings.color ??
                          (chart._chartState._chartTheme.brightness ==
                                  Brightness.light
                              ? Colors.white
                              : Colors.black)
                      ..style = PaintingStyle.fill;
                    final int index = trendline._pointsData.indexOf(point);
                    canvas.drawPath(
                        trendline._markerShapes[index], strokePaint);
                    canvas.drawPath(trendline._markerShapes[index], fillPaint);
                  }
                }
              }
            }
          }
        }
      }
    }
  }

  /// Setting the values of render trend line event
  void renderTrendlineEvent(Trendline trendline, int trendlineIndex,
      int seriesIndex, String seriesName) {
    TrendlineRenderArgs args;
    if (chart.onTrendlineRender != null) {
      args = TrendlineRenderArgs();
      args.intercept = trendline.intercept;
      args.trendlineIndex = trendlineIndex;
      args.trendlineName = trendline._name;
      args.seriesName = seriesName;
      args.color = trendline._fillColor;
      args.opacity = trendline._opacity;
      args.dashArray = trendline._dashArray;
      args.seriesIndex = seriesIndex;
      args.data = trendline._pointsData;
      chart.onTrendlineRender(args);
      trendline._fillColor = args.color;
      trendline._opacity = args.opacity;
      trendline._dashArray = args.dashArray;
    }
  }

  @override
  bool shouldRepaint(_TrendlinePainter oldDelegate) => true;
}
