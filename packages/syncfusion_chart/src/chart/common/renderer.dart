part of charts;

// ignore: must_be_immutable
class _DataLabelRenderer extends StatefulWidget {
  // ignore: prefer_const_constructors_in_immutables
  _DataLabelRenderer({this.cartesianChart, this.show});

  final SfCartesianChart cartesianChart;

  bool show;

  _DataLabelRendererState state;

  @override
  State<StatefulWidget> createState() => _DataLabelRendererState();
}

class _DataLabelRendererState extends State<_DataLabelRenderer>
    with SingleTickerProviderStateMixin {
  List<AnimationController> animationControllersList;

  /// Animation controller for series
  AnimationController animationController;

  /// Repaint notifier for crosshair container
  ValueNotifier<int> dataLabelRepaintNotifier;

  @override
  void initState() {
    dataLabelRepaintNotifier = ValueNotifier<int>(0);
    animationController = AnimationController(vsync: this)
      ..addListener(repaintDataLabelElements);
    super.initState();
  }

  @override
  void dispose() {
    if (animationController != null) {
      animationController.removeListener(repaintDataLabelElements);
      animationController.dispose();
      animationController = null;
    }
    super.dispose();
  }

  void repaintDataLabelElements() {
    dataLabelRepaintNotifier.value++;
  }

  void render() {
    setState(() {
      widget.show = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    widget.state = this;
    animationController.duration = Duration(
        milliseconds:
            widget.cartesianChart._chartState.initialRender ? 500 : 0);
    final Animation<double> dataLabelAnimation =
        Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
      parent: animationController,
      curve: const Interval(0.1, 0.8, curve: Curves.decelerate),
    ));
    if (widget.show) {
      widget.cartesianChart._chartState.initialRender = false;
    }
    animationController.forward(from: 0.0);
    return Container(
        child: CustomPaint(
            painter: _DataLabelPainter(
                cartesianChart: widget.cartesianChart,
                animation: dataLabelAnimation,
                state: this,
                animationController: animationController,
                notifier: dataLabelRepaintNotifier)));
  }
}

class _DataLabelPainter extends CustomPainter {
  _DataLabelPainter(
      {this.cartesianChart,
      this.state,
      this.animationController,
      this.animation,
      ValueNotifier<num> notifier})
      : super(repaint: notifier);

  final SfCartesianChart cartesianChart;

  final _DataLabelRendererState state;

  final AnimationController animationController;

  final Animation<double> animation;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.clipRect(cartesianChart._chartAxis._axisClipRect);
    cartesianChart._chartState.renderDatalabelRegions = <Rect>[];
    for (int i = 0;
        i < cartesianChart._chartSeries.visibleSeriesRenderers.length;
        i++) {
      final CartesianSeriesRenderer seriesRenderer =
          cartesianChart._chartSeries.visibleSeriesRenderers[i];
      if (seriesRenderer._series.dataLabelSettings.isVisible &&
          (cartesianChart._chartState.animationController.status ==
                  AnimationStatus.completed ||
              !cartesianChart._chartState.initialRender) &&
          (!seriesRenderer._needAnimateSeriesElements ||
              cartesianChart._seriesDurationFactor <
                  cartesianChart._chartState.animationController.value) &&
          seriesRenderer._series.dataLabelSettings.builder == null) {
        for (int j = 0; j < seriesRenderer._dataPoints.length; j++) {
          if (seriesRenderer._visible &&
              seriesRenderer._series.dataLabelSettings != null) {
            seriesRenderer._series.dataLabelSettings?.renderDataLabel(
                cartesianChart,
                seriesRenderer,
                seriesRenderer._dataPoints[j],
                animation,
                canvas,
                j);
          }
        }
      }
    }
  }

  @override
  bool shouldRepaint(_DataLabelPainter oldDelegate) => true;
}

/// find rect type series region
void _calculateRectSeriesRegion(
    CartesianChartPoint<dynamic> point,
    int pointIndex,
    CartesianSeriesRenderer seriesRenderer,
    SfCartesianChart chart) {
  final ChartAxis xAxis = seriesRenderer._xAxis;
  final ChartAxis yAxis = seriesRenderer._yAxis;

  /// side by side range calculated
  final _VisibleRange sideBySideInfo =
      _calculateSideBySideInfo(seriesRenderer, chart);
  final num origin = math.max(yAxis._visibleRange.minimum, 0);

  /// Get the rectangle based on points
  final Rect rect = (seriesRenderer._seriesType.contains('stackedcolumn') ||
              seriesRenderer._seriesType.contains('stackedbar')) &&
          seriesRenderer is _StackedSeriesRenderer
      ? _calculateRectangle(
          point.xValue + sideBySideInfo.minimum,
          seriesRenderer._stackingValues[0].endValues[pointIndex],
          point.xValue + sideBySideInfo.maximum,
          seriesRenderer._stackingValues[0].startValues[pointIndex],
          seriesRenderer,
          chart)
      : _calculateRectangle(
          point.xValue + sideBySideInfo.minimum,
          seriesRenderer._seriesType == 'rangecolumn'
              ? point.high
              : point.yValue,
          point.xValue + sideBySideInfo.maximum,
          seriesRenderer._seriesType == 'rangecolumn' ? point.low : origin,
          seriesRenderer,
          chart);

  point.region = rect;
  final dynamic _series = seriesRenderer._series;

  ///Get shadow rect region
  if (seriesRenderer._seriesType != 'stackedcolumn100' &&
      seriesRenderer._seriesType != 'stackedbar100' &&
      _series.isTrackVisible) {
    final Rect shadowPointRect = _calculateShadowRectangle(
        point.xValue + sideBySideInfo.minimum,
        seriesRenderer._seriesType == 'rangecolumn' ? point.high : point.yValue,
        point.xValue + sideBySideInfo.maximum,
        seriesRenderer._seriesType == 'rangecolumn' ? point.high : origin,
        seriesRenderer,
        chart,
        Offset(xAxis?.plotOffset, yAxis?.plotOffset));

    point.trackerRectRegion = shadowPointRect;
  }
  if (seriesRenderer._seriesType == 'rangecolumn' ||
      seriesRenderer._seriesType.contains('hilo') ||
      seriesRenderer._seriesType.contains('candle')) {
    point.markerPoint = chart._requireInvertedAxis != true
        ? _ChartLocation(rect.topCenter.dx, rect.topCenter.dy)
        : _ChartLocation(rect.centerRight.dx, rect.centerRight.dy);
    point.markerPoint2 = chart._requireInvertedAxis != true
        ? _ChartLocation(rect.bottomCenter.dx, rect.bottomCenter.dy)
        : _ChartLocation(rect.centerLeft.dx, rect.centerLeft.dy);
  } else {
    point.markerPoint = chart._requireInvertedAxis != true
        ? (yAxis.isInversed
            ? (point.yValue.isNegative
                ? _ChartLocation(rect.topCenter.dx, rect.topCenter.dy)
                : _ChartLocation(rect.bottomCenter.dx, rect.bottomCenter.dy))
            : (point.yValue.isNegative
                ? _ChartLocation(rect.bottomCenter.dx, rect.bottomCenter.dy)
                : _ChartLocation(rect.topCenter.dx, rect.topCenter.dy)))
        : (yAxis.isInversed
            ? (point.yValue.isNegative
                ? _ChartLocation(rect.centerRight.dx, rect.centerRight.dy)
                : _ChartLocation(rect.centerLeft.dx, rect.centerLeft.dy))
            : (point.yValue.isNegative
                ? _ChartLocation(rect.centerLeft.dx, rect.centerLeft.dy)
                : _ChartLocation(rect.centerRight.dx, rect.centerRight.dy)));
  }
}

///calculate scatter, bubble series datapoints region
void _calculatePointSeriesRegion(
    CartesianChartPoint<dynamic> point,
    int pointIndex,
    CartesianSeriesRenderer seriesRenderer,
    SfCartesianChart chart,
    Rect rect) {
  final ChartAxis xAxis = seriesRenderer._xAxis;
  final ChartAxis yAxis = seriesRenderer._yAxis;
  final dynamic series = seriesRenderer._series;
  final _ChartLocation currentPoint = _calculatePoint(
      point.xValue,
      point.yValue,
      xAxis,
      yAxis,
      chart._requireInvertedAxis,
      seriesRenderer._series,
      rect);
  point.markerPoint = currentPoint;
  if (seriesRenderer._seriesType == 'scatter') {
    point.region = Rect.fromLTRB(
        currentPoint.x - series.markerSettings.width,
        currentPoint.y - series.markerSettings.width,
        currentPoint.x + series.markerSettings.width,
        currentPoint.y + series.markerSettings.width);
  } else {
    final BubbleSeries<dynamic, dynamic> bubbleSeries = series;
    num bubbleRadius, sizeRange, radiusRange, bubbleSize;
    if (seriesRenderer is BubbleSeriesRenderer)
      sizeRange = seriesRenderer._maxSize - seriesRenderer._minSize;
    bubbleSize = ((point.bubbleSize) ?? 4).toDouble();
    if (bubbleSeries.sizeValueMapper == null)
      bubbleSeries.minimumRadius != null
          ? bubbleRadius = bubbleSeries.minimumRadius
          : bubbleRadius = bubbleSeries.maximumRadius;
    else {
      if ((bubbleSeries.maximumRadius != null) &&
          (bubbleSeries.minimumRadius != null)) {
        if (sizeRange == 0)
          bubbleRadius = bubbleSeries.maximumRadius;
        else {
          radiusRange =
              (bubbleSeries.maximumRadius - bubbleSeries.minimumRadius) * 2;
          if (seriesRenderer is BubbleSeriesRenderer)
            bubbleRadius =
                (((bubbleSize.abs() - seriesRenderer._minSize) * radiusRange) /
                        sizeRange) +
                    bubbleSeries.minimumRadius;
        }
      }
    }
    point.region = Rect.fromLTRB(
        currentPoint.x - 2 * bubbleRadius,
        currentPoint.y - 2 * bubbleRadius,
        currentPoint.x + 2 * bubbleRadius,
        currentPoint.y + 2 * bubbleRadius);
  }
}

///calculate data point region for path series like line, area, etc.,
void _calculatePathSeriesRegion(
    CartesianChartPoint<dynamic> point,
    int pointIndex,
    CartesianSeriesRenderer seriesRenderer,
    SfCartesianChart chart,
    Rect rect,
    num markerHeight,
    num markerWidth,
    [_VisibleRange sideBySideInfo,
    CartesianChartPoint<dynamic> _nextPoint,
    num midX,
    num midY]) {
  final ChartAxis xAxis = seriesRenderer._xAxis;
  final ChartAxis yAxis = seriesRenderer._yAxis;
  if (seriesRenderer._seriesType != 'rangearea' &&
      seriesRenderer._seriesType != 'splinerangearea' &&
      (!seriesRenderer._seriesType.contains('hilo')) &&
      (!seriesRenderer._seriesType.contains('candle'))) {
    if (seriesRenderer._seriesType == 'stepline' ||
        seriesRenderer._seriesType == 'spline') {
      point.currentPoint = _calculatePoint(
          point.xValue,
          point.yValue,
          seriesRenderer._xAxis,
          seriesRenderer._yAxis,
          seriesRenderer._chart._requireInvertedAxis,
          seriesRenderer._series,
          rect);
      if (_nextPoint != null) {
        point._nextPoint = _calculatePoint(
            _nextPoint.xValue,
            _nextPoint.yValue,
            seriesRenderer._xAxis,
            seriesRenderer._yAxis,
            seriesRenderer._chart._requireInvertedAxis,
            seriesRenderer._series,
            rect);
      }
      if (seriesRenderer._seriesType == 'spline' &&
          pointIndex <= seriesRenderer._dataPoints.length - 2) {
        point.controlPoint =
            seriesRenderer._drawControlPoints[pointIndex]._listControlPoints;
        point.startControl = _calculatePoint(
            point.controlPoint[0].controlPoint1,
            point.controlPoint[0].controlPoint2,
            xAxis,
            yAxis,
            seriesRenderer._chart._requireInvertedAxis,
            seriesRenderer._series,
            rect);
        point.endControl = _calculatePoint(
            point.controlPoint[1].controlPoint1,
            point.controlPoint[1].controlPoint2,
            xAxis,
            yAxis,
            seriesRenderer._chart._requireInvertedAxis,
            seriesRenderer._series,
            rect);
      }

      if (seriesRenderer._seriesType == 'stepline' &&
          midX != null &&
          midY != null)
        point._midPoint = _calculatePoint(
            midX,
            midY,
            seriesRenderer._xAxis,
            seriesRenderer._yAxis,
            seriesRenderer._chart._requireInvertedAxis,
            seriesRenderer._series,
            rect);
    }
    final _ChartLocation currentPoint =
        (seriesRenderer._seriesType == 'stackedarea' ||
                    seriesRenderer._seriesType == 'stackedarea100' ||
                    seriesRenderer._seriesType == 'stackedline' ||
                    seriesRenderer._seriesType == 'stackedline100') &&
                seriesRenderer is _StackedSeriesRenderer
            ? _calculatePoint(
                point.xValue,
                seriesRenderer._stackingValues[0].endValues[pointIndex],
                xAxis,
                yAxis,
                chart._requireInvertedAxis,
                seriesRenderer._series,
                rect)
            : _calculatePoint(point.xValue, point.yValue, xAxis, yAxis,
                chart._requireInvertedAxis, seriesRenderer._series, rect);
    point.region = Rect.fromLTWH(currentPoint.x - markerWidth,
        currentPoint.y - markerHeight, 2 * markerWidth, 2 * markerHeight);
    point.markerPoint = currentPoint;
  } else {
    num value1, value2;
    value1 = (point.low != null && point.high != null && point.low < point.high)
        ? point.high
        : point.low;
    value2 = (point.low != null && point.high != null && point.low > point.high)
        ? point.high
        : point.low;
    point.markerPoint = _calculatePoint(
        point.xValue,
        yAxis.isInversed ? value2 : value1,
        xAxis,
        yAxis,
        chart._requireInvertedAxis,
        seriesRenderer._series,
        rect);
    point.markerPoint2 = _calculatePoint(
        point.xValue,
        yAxis.isInversed ? value1 : value2,
        xAxis,
        yAxis,
        chart._requireInvertedAxis,
        seriesRenderer._series,
        rect);
    if (seriesRenderer._seriesType == 'hilo' &&
        point.low != null &&
        point.high != null) {
      point.lowPoint = _calculatePoint(
          point.xValue,
          point.low,
          seriesRenderer._xAxis,
          seriesRenderer._yAxis,
          seriesRenderer._chart._requireInvertedAxis,
          seriesRenderer._series,
          rect);
      point.highPoint = _calculatePoint(
          point.xValue,
          point.high,
          seriesRenderer._xAxis,
          seriesRenderer._yAxis,
          seriesRenderer._chart._requireInvertedAxis,
          seriesRenderer._series,
          rect);
    } else if ((seriesRenderer._seriesType == 'hiloopenclose' ||
            seriesRenderer._seriesType == 'candle') &&
        point.open != null &&
        point.close != null &&
        point.low != null &&
        point.high != null) {
      final num center = (point.xValue + sideBySideInfo.minimum) +
          (((point.xValue + sideBySideInfo.maximum) -
                  (point.xValue + sideBySideInfo.minimum)) /
              2);
      point.openPoint = _calculatePoint(
          point.xValue + sideBySideInfo.minimum,
          point.open,
          seriesRenderer._xAxis,
          seriesRenderer._yAxis,
          seriesRenderer._chart._requireInvertedAxis,
          seriesRenderer._series,
          rect);

      point.closePoint = _calculatePoint(
          point.xValue + sideBySideInfo.maximum,
          point.close,
          seriesRenderer._xAxis,
          seriesRenderer._yAxis,
          seriesRenderer._chart._requireInvertedAxis,
          seriesRenderer._series,
          rect);
      if (seriesRenderer._series.dataLabelSettings.isVisible) {
        point.centerOpenPoint = _calculatePoint(
            point.xValue,
            point.open,
            seriesRenderer._xAxis,
            seriesRenderer._yAxis,
            seriesRenderer._chart._requireInvertedAxis,
            seriesRenderer._series,
            rect);

        point.centerClosePoint = _calculatePoint(
            point.xValue,
            point.close,
            seriesRenderer._xAxis,
            seriesRenderer._yAxis,
            seriesRenderer._chart._requireInvertedAxis,
            seriesRenderer._series,
            rect);
      }

      point.centerHighPoint = _calculatePoint(
          center,
          point.high,
          seriesRenderer._xAxis,
          seriesRenderer._yAxis,
          seriesRenderer._chart._requireInvertedAxis,
          seriesRenderer._series,
          rect);

      point.centerLowPoint = _calculatePoint(
          center,
          point.low,
          seriesRenderer._xAxis,
          seriesRenderer._yAxis,
          seriesRenderer._chart._requireInvertedAxis,
          seriesRenderer._series,
          rect);

      point.lowPoint = _calculatePoint(
          point.xValue + sideBySideInfo.minimum,
          point.low,
          seriesRenderer._xAxis,
          seriesRenderer._yAxis,
          seriesRenderer._chart._requireInvertedAxis,
          seriesRenderer._series,
          rect);
      point.highPoint = _calculatePoint(
          point.xValue + sideBySideInfo.maximum,
          point.high,
          seriesRenderer._xAxis,
          seriesRenderer._yAxis,
          seriesRenderer._chart._requireInvertedAxis,
          seriesRenderer._series,
          rect);
    }
    point.region = seriesRenderer._seriesType.contains('hilo') ||
            seriesRenderer._seriesType.contains('candle')
        ? !seriesRenderer._chart._requireInvertedAxis
            ? Rect.fromLTWH(
                point.markerPoint.x,
                point.markerPoint.y,
                seriesRenderer._series.borderWidth,
                point.markerPoint2.y - point.markerPoint.y)
            : Rect.fromLTWH(
                point.markerPoint2.x,
                point.markerPoint2.y,
                (point.markerPoint.x - point.markerPoint2.x).abs(),
                seriesRenderer._series.borderWidth)
        : Rect.fromLTRB(
            point.markerPoint.x - markerWidth,
            point.markerPoint.y - markerHeight,
            point.markerPoint.x + markerWidth,
            point.markerPoint2.y);
  }
}

///Finding tooltip region
void _calculateTooltipRegion(
    CartesianChartPoint<dynamic> point,
    int seriesIndex,
    CartesianSeriesRenderer seriesRenderer,
    SfCartesianChart chart,
    [Trendline trendline,
    int trendlineIndex]) {
  final ChartAxis xAxis = seriesRenderer._xAxis;
  final dynamic series = seriesRenderer._series;
  if ((series.enableTooltip != null ||
          seriesRenderer._chart.trackballBehavior != null) &&
      (series.enableTooltip ||
          seriesRenderer._chart.trackballBehavior.enable) &&
      point != null &&
      !point.isGap &&
      !point.isDrop &&
      seriesRenderer._regionalData != null) {
    bool isTrendline = false;
    if (trendline != null) {
      isTrendline = true;
    }
    final List<String> regionData = <String>[];
    num binWidth = 0;
    String date;
    final List<dynamic> regionRect = <dynamic>[];
    if (seriesRenderer is HistogramSeriesRenderer) {
      binWidth = seriesRenderer._histogramValues.binWidth;
    }
    if (xAxis is DateTimeAxis) {
      final DateFormat dateFormat =
          xAxis.dateFormat ?? xAxis._getLabelFormat(xAxis);
      date = dateFormat
          .format(DateTime.fromMillisecondsSinceEpoch(point.xValue.floor()));
    }
    xAxis is CategoryAxis
        ? regionData.add(point.x.toString())
        : xAxis is DateTimeAxis
            ? regionData.add(date.toString())
            : seriesRenderer._seriesType != 'histogram'
                ? regionData.add(_getLabelValue(point.xValue, xAxis,
                        chart.tooltipBehavior.decimalPlaces)
                    .toString())
                : regionData.add((_getLabelValue(point.xValue - binWidth / 2,
                            xAxis, chart.tooltipBehavior.decimalPlaces)
                        .toString()) +
                    ' - ' +
                    (_getLabelValue(point.xValue + binWidth / 2, xAxis,
                            chart.tooltipBehavior.decimalPlaces)
                        .toString()));

    if (seriesRenderer._seriesType.contains('range') && !isTrendline ||
        seriesRenderer._seriesType.contains('hilo') ||
        seriesRenderer._seriesType.contains('candle')) {
      if (seriesRenderer._seriesType != 'hiloopenclose' &&
          seriesRenderer._seriesType != 'candle') {
        regionData.add(point.high.toString());
        regionData.add(point.low.toString());
      } else {
        regionData.add(point.high.toString());
        regionData.add(point.low.toString());
        regionData.add(point.open.toString());
        regionData.add(point.close.toString());
      }
    } else {
      regionData.add(point.yValue.toString());
    }
    regionData.add(
        isTrendline ? trendline._name : series.name ?? 'series $seriesIndex');
    regionRect.add(point.region);
    regionRect.add((seriesRenderer._isRectSeries) ||
            seriesRenderer._seriesType.contains('hilo') ||
            seriesRenderer._seriesType.contains('candle')
        ? seriesRenderer._seriesType == 'column' ||
                seriesRenderer._seriesType.contains('stackedcolumn') ||
                seriesRenderer._seriesType == 'histogram'
            ? point.yValue > 0
                ? point.region.topCenter
                : point.region.bottomCenter
            : seriesRenderer._seriesType.contains('hilo') ||
                    seriesRenderer._seriesType.contains('candle')
                ? point.region.topCenter
                : point.region.topCenter
        : (seriesRenderer._seriesType.contains('rangearea')
            ? (isTrendline
                ? Offset(point.markerPoint.x, point.markerPoint.y)
                : Offset(point.markerPoint.x, point.markerPoint.y))
            : point.region.center));
    regionRect.add(isTrendline ? trendline._fillColor : point.pointColorMapper);
    regionRect.add(point.bubbleSize);
    regionRect.add(point);
    if (seriesRenderer._seriesType.contains('stacked')) {
      regionData.add((point.cumulativeValue).toString());
    }
    regionData.add('$isTrendline');
    if (isTrendline) {
      regionRect.add(trendline);
    }
    seriesRenderer._regionalData[regionRect] = regionData;
    point.regionData = regionData;
  }
}

/// Paint the image marker
void _drawImageMarker(CartesianSeriesRenderer seriesRenderer, Canvas canvas,
    double pointX, double pointY) {
  if (seriesRenderer._series.markerSettings._image != null) {
    final double imageWidth = 2 * seriesRenderer._series.markerSettings.width;
    final double imageHeight = 2 * seriesRenderer._series.markerSettings.height;
    final Rect positionRect = Rect.fromLTWH(pointX - imageWidth / 2,
        pointY - imageHeight / 2, imageWidth, imageHeight);
    paintImage(
        canvas: canvas,
        rect: positionRect,
        image: seriesRenderer._series.markerSettings._image,
        fit: BoxFit.fill);
  }
}

/// This method is for to calculate and rendering the length and Offsets of the dashed lines
void _drawDashedLine(
    Canvas canvas, List<double> dashArray, Paint paint, Path path) {
  bool even = false;
  for (int i = 1; i < dashArray.length; i = i + 2) {
    if (dashArray[i] == 0) {
      even = true;
    }
  }
  if (even == false && !kIsWeb) {
    paint.isAntiAlias = false;
    canvas.drawPath(
        _dashPath(
          path,
          dashArray: _CircularIntervalList<double>(dashArray),
        ),
        paint);
  } else
    canvas.drawPath(path, paint);
}
