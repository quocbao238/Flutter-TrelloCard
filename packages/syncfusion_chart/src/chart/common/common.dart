part of charts;

class _CustomPaintStyle {
  _CustomPaintStyle(this.strokeWidth, this.color, this.paintStyle);
  Color color;
  double strokeWidth;
  PaintingStyle paintStyle;
}

class _AxisSize {
  _AxisSize(this.axis, this.size);
  num size;
  ChartAxis axis;
}

class _PainterKey {
  _PainterKey({this.index, this.name, this.isRenderCompleted});
  final int index;
  final String name;
  bool isRenderCompleted;
}

/// Customizes the interactive tooltip.
///
///Shows the information about the segments.To enable the interactiveToolTip, set the property to true.
///
/// By using this,to customize the [color], [borderwidth], [borderRadius],
/// [format] and so on.
///
/// _Note:_ IntereactivetoolTip applicable for axis types and trackball.

class InteractiveTooltip {
  InteractiveTooltip(
      {this.enable = true,
      this.color,
      this.borderColor,
      this.borderWidth = 0,
      this.borderRadius = 5,
      this.arrowLength = 7,
      this.arrowWidth = 5,
      this.format,
      this.connectorLineColor,
      this.connectorLineWidth = 1.5,
      this.connectorLineDashArray,
      this.decimalPlaces = 3,
      TextStyle textStyle})
      : textStyle = textStyle ??
            const TextStyle(
                fontFamily: 'Roboto',
                fontStyle: FontStyle.normal,
                fontWeight: FontWeight.normal,
                fontSize: 12);

  ///Toggles the visibility of the interactive tooltip in an axis.
  ///
  /// This tooltip will be displayed at the axis for crosshair and
  /// will be displayed near to the trackline for trackball.
  ///
  ///Defaults to `true`.
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///           trackballBehavior: TrackballBehavior(enable: true,
  ///           tooltipSettings: InteractiveTooltip(enable:false)),
  ///        ));
  ///}
  ///```
  final bool enable;

  ///Color of the interactive tooltip.
  ///
  ///Used to change the color of the tooltip text.
  ///
  ///Defaults to `null`.
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///           trackballBehavior: TrackballBehavior(enable: true,
  ///           tooltipSettings: InteractiveTooltip(
  ///             color:Colors.grey)),
  ///        ));
  ///}
  ///```
  final Color color;

  ///Border color of the interactive tooltip.
  ///
  ///Used to change the stroke color of the axis tooltip.
  ///
  ///Defaults to `Colors.black`.
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///           trackballBehavior: TrackballBehavior(enable: true,
  ///           tooltipSettings: InteractiveTooltip(
  ///             borderColor:Colors.white,
  ///             borderWidth:2)),
  ///        ));
  ///}
  ///```
  final Color borderColor;

  ///Border width of the interactive tooltip.
  ///
  ///Used to change the stroke width of the axis tooltip.
  ///
  ///Defaults to `0`.
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///           trackballBehavior: TrackballBehavior(enable: true,
  ///           tooltipSettings: InteractiveTooltip(
  ///             borderColor:Colors.white,
  ///             borderWidth:2)),
  ///        ));
  ///}
  ///```
  final double borderWidth;

  ///Customizes the text in the interactive tooltip.
  ///
  ///Used to change the text color, size, font family, fontStyle, and font weight.
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///           trackballBehavior: TrackballBehavior(enable: true,
  ///           tooltipSettings: InteractiveTooltip(
  ///             textStyle: TextStyle(color:Colors.red))),
  ///        ));
  ///}
  ///```
  final TextStyle textStyle;

  ///Customizes the corners of the interactive tooltip.
  ///
  ///Each corner can be customized with a desired value or with a single value.
  ///
  ///Defaults to `Radius.zero`.
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///           trackballBehavior: TrackballBehavior(enable: true,
  ///           tooltipSettings: InteractiveTooltip(
  ///             borderColor:Colors.white,
  ///             borderWidth:3,
  ///             borderRadius:2)),
  ///        ));
  ///}
  ///```
  final double borderRadius;

  ///It Specifies the length of the tooltip.
  ///
  ///Defaults to `7`.
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///           trackballBehavior: TrackballBehavior(enable: true,
  ///           tooltipSettings: InteractiveTooltip(
  ///             arrowLength:4)),
  ///        ));
  ///}
  ///```
  final double arrowLength;

  ///It specifies the width of the tooltip arrow.
  ///
  ///Defaults to `5`.
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///           trackballBehavior: TrackballBehavior(enable: true,
  ///           tooltipSettings: InteractiveTooltip(
  ///             arrowWidth:4)),
  ///        ));
  ///}
  ///```
  final double arrowWidth;

  ///Text format of the interactive tooltip.
  ///
  /// By default, axis value will be displayed in the tooltip, and it can be customized by
  /// adding desired text as prefix or suffix.
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///           trackballBehavior: TrackballBehavior(enable: true,
  ///           tooltipSettings: InteractiveTooltip(
  ///             format:'point.x %')),
  ///        ));
  ///}
  ///```
  final String format;

  ///Width of the selection zooming tooltip connector line.
  ///
  ///Defaults to `1.5`.
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///           primaryXAxis: NumericAxis(interactiveTooltip:
  ///                               InteractiveTooltip(connectorLineWidth:2)),
  ///        ));
  ///}
  ///```
  final double connectorLineWidth;

  ///Color of the selection zooming tooltip connector line.
  ///
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///           primaryXAxis: NumericAxis(
  ///             interactiveTooltip: InteractiveTooltip(connectorLineColor:Colors.red)),
  ///        ));
  ///}
  ///```
  final Color connectorLineColor;

  ///Giving dashArray to the selection zooming tooltip connector line.
  ///
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///           primaryXAxis: NumericAxis(
  ///              interactiveTooltip: InteractiveTooltip(connectorLineDashArray:[2,3])),
  ///        ));
  ///}
  ///```
  final List<double> connectorLineDashArray;

  ///Rounding decimal places of the selection zooming tooltip or trackball tooltip label.
  ///
  ///Defaults to `3`.
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///           primaryXAxis: NumericAxis(interactiveTooltip: InteractiveTooltip(decimalPlaces:4)),
  ///        ));
  ///}
  ///```
  final int decimalPlaces;
}

class _StackedValues {
  _StackedValues(this.startValues, this.endValues);
  List<double> startValues;
  List<double> endValues;
}

class _ClusterStackedItemInfo {
  _ClusterStackedItemInfo(this.stackName, this.stackedItemInfo);
  String stackName;
  List<_StackedItemInfo> stackedItemInfo;
}

class _StackedItemInfo {
  _StackedItemInfo(this.seriesIndex, this.seriesRenderer);
  int seriesIndex;
  _StackedSeriesRenderer seriesRenderer;
}

class _ChartPointInfo {
  /// Marker x position
  double markerXPos;

  /// Marker y position
  double markerYPos;

  /// label for trackball and cross hair
  String label;

  /// Data point index
  int dataPointIndex;

  /// Instance of chart series
  CartesianSeries<dynamic, dynamic> series;

  /// Instance of cartesian seriesRenderer
  CartesianSeriesRenderer seriesRenderer;

  /// Chart data point
  CartesianChartPoint<dynamic> chartDataPoint;

  /// X position of the label
  double xPosition;

  /// Y position of the label
  double yPosition;

  /// Color of the segment
  Color color;

  /// header text
  String header;

  /// Low Y position of financial series
  double lowYPosition;

  /// High Y position of financial series
  double highYPosition;

  /// Open y position of financial series
  double openYPosition;

  /// close y position of financial series
  double closeYPosition;

  /// open x position of finanical series
  double openXPosition;

  /// close x position of finanical series
  double closeXPosition;

  /// series index value
  num seriesIndex;
}

/// To get cartesian type data label saturation color
Color _getDataLabelSaturationColor(CartesianChartPoint<dynamic> currentPoint,
    CartesianSeriesRenderer seriesRenderer, SfCartesianChart chart) {
  Color color;
  final DataLabelSettings dataLabel = seriesRenderer._series.dataLabelSettings;
  final ChartDataLabelAlignment labelPosition =
      (seriesRenderer._seriesType == 'rangecolumn' &&
              (dataLabel.labelAlignment == ChartDataLabelAlignment.bottom ||
                  dataLabel.labelAlignment == ChartDataLabelAlignment.middle))
          ? ChartDataLabelAlignment.auto
          : dataLabel.labelAlignment;
  final ChartAlignment alignment = dataLabel.alignment;
  final String _seriesType = seriesRenderer._seriesType == 'line' ||
          seriesRenderer._seriesType == 'stackedline' ||
          seriesRenderer._seriesType == 'stackedline100' ||
          seriesRenderer._seriesType == 'spline' ||
          seriesRenderer._seriesType == 'stepline'
      ? 'Line'
      : seriesRenderer._isRectSeries
          ? 'Column'
          : seriesRenderer._seriesType == 'bubble' ||
                  seriesRenderer._seriesType == 'scatter'
              ? 'Circle'
              : seriesRenderer._seriesType.contains('area')
                  ? 'area'
                  : 'Default';
  if (dataLabel.useSeriesColor || dataLabel._color != null) {
    color = dataLabel._color ??
        (currentPoint.pointColorMapper ?? seriesRenderer._seriesColor);
  } else {
    switch (_seriesType) {
      case 'Line':
        color = _getOuterDataLabelColor(dataLabel,
            chart.plotAreaBackgroundColor, chart._chartState._chartTheme);
        break;
      case 'Column':
        color = (!currentPoint.dataLabelSaturationRegionInside &&
                ((labelPosition == ChartDataLabelAlignment.outer &&
                        alignment != ChartAlignment.near) ||
                    (labelPosition == ChartDataLabelAlignment.top &&
                        alignment == ChartAlignment.far) ||
                    (labelPosition == ChartDataLabelAlignment.auto &&
                        (!seriesRenderer._seriesType.contains('100') &&
                            seriesRenderer._seriesType != 'stackedbar' &&
                            seriesRenderer._seriesType != 'stackedcolumn'))))
            ? _getOuterDataLabelColor(dataLabel, chart.plotAreaBackgroundColor,
                chart._chartState._chartTheme)
            : _getInnerDataLabelColor(
                currentPoint, seriesRenderer, chart._chartState._chartTheme);
        break;
      case 'Circle':
        color = (labelPosition == ChartDataLabelAlignment.middle &&
                    alignment == ChartAlignment.center ||
                labelPosition == ChartDataLabelAlignment.bottom &&
                    alignment == ChartAlignment.far ||
                labelPosition == ChartDataLabelAlignment.top &&
                    alignment == ChartAlignment.near ||
                labelPosition == ChartDataLabelAlignment.outer &&
                    alignment == ChartAlignment.near)
            ? _getInnerDataLabelColor(
                currentPoint, seriesRenderer, chart._chartState._chartTheme)
            : _getOuterDataLabelColor(dataLabel, chart.plotAreaBackgroundColor,
                chart._chartState._chartTheme);
        break;

      case 'area':
        color = (!currentPoint.dataLabelSaturationRegionInside &&
                currentPoint.labelLocation.y < currentPoint.markerPoint.y)
            ? _getOuterDataLabelColor(dataLabel, chart.plotAreaBackgroundColor,
                chart._chartState._chartTheme)
            : _getInnerDataLabelColor(
                currentPoint, seriesRenderer, chart._chartState._chartTheme);
        break;

      default:
        color = Colors.white;
    }
  }
  return _getSaturationColor(color);
}

/// Get the data label color of open-close series
Color _getOpenCloseDataLabelColor(CartesianChartPoint<dynamic> currentPoint,
    CartesianSeriesRenderer seriesRenderer, SfCartesianChart chart) {
  Color color;
  color = seriesRenderer
              ._segments[seriesRenderer._dataPoints.indexOf(currentPoint)]
              .fillPaint
              .style ==
          PaintingStyle.fill
      ? seriesRenderer
          ._segments[seriesRenderer._dataPoints.indexOf(currentPoint)]._color
      : const Color.fromRGBO(255, 255, 255, 1);
  return _getSaturationColor(color);
}

/// To get outer data label color
Color _getOuterDataLabelColor(DataLabelSettings dataLabel,
        Color backgroundColor, SfChartThemeData theme) =>
    dataLabel._color != null
        ? dataLabel._color
        : backgroundColor != null
            ? backgroundColor
            : theme.brightness == Brightness.light
                ? const Color.fromRGBO(255, 255, 255, 1)
                : Colors.black;

///To get inner data label
Color _getInnerDataLabelColor(CartesianChartPoint<dynamic> currentPoint,
    CartesianSeriesRenderer seriesRenderer, SfChartThemeData theme) {
  Color innerColor;
  final dynamic dataLabel = seriesRenderer._series.dataLabelSettings;
  innerColor = dataLabel._color != null
      ? dataLabel._color
      : currentPoint.pointColorMapper != null
          ? currentPoint.pointColorMapper
          : seriesRenderer._series.color != null
              ? seriesRenderer._series.color
              : seriesRenderer._seriesColor != null
                  ? seriesRenderer._seriesColor
                  : theme.brightness == Brightness.light
                      ? const Color.fromRGBO(255, 255, 255, 1)
                      : Colors.black;
  return innerColor;
}

/// To animate column and bar series
void _animateRectSeries(
    Canvas canvas,
    CartesianSeriesRenderer seriesRenderer,
    Paint fillPaint,
    RRect segmentRect,
    num yPoint,
    double animationFactor,
    Rect oldSegmentRect,
    num oldYValue,
    bool oldSeriesVisible) {
  final bool comparePrev = seriesRenderer._chart._chartState.widgetNeedUpdate &&
      oldYValue != null &&
      oldSegmentRect != null;
  final bool isLargePrev = oldYValue != null ? oldYValue > yPoint : false;
  final bool isSingleSeries = seriesRenderer._chart._chartState._isLegendToggled
      ? _checkSingleSeries(seriesRenderer)
      : false;
  if ((seriesRenderer._seriesType == 'column' &&
          seriesRenderer._chart.isTransposed) ||
      (seriesRenderer._seriesType == 'bar' &&
          !seriesRenderer._chart.isTransposed) ||
      (seriesRenderer._seriesType == 'histogram' &&
          seriesRenderer._chart.isTransposed)) {
    _animateTransposedRectSeries(
        canvas,
        seriesRenderer,
        fillPaint,
        segmentRect,
        yPoint,
        animationFactor,
        oldSegmentRect,
        oldSeriesVisible,
        comparePrev,
        isLargePrev,
        isSingleSeries);
  } else {
    _animateNormalRectSeries(
        canvas,
        seriesRenderer,
        fillPaint,
        segmentRect,
        yPoint,
        animationFactor,
        oldSegmentRect,
        oldSeriesVisible,
        comparePrev,
        isLargePrev,
        isSingleSeries);
  }
}

/// To animate transposed bar and column series
void _animateTransposedRectSeries(
    Canvas canvas,
    CartesianSeriesRenderer seriesRenderer,
    Paint fillPaint,
    RRect segmentRect,
    num yPoint,
    double animationFactor,
    Rect oldSegmentRect,
    bool oldSeriesVisible,
    bool comparePrev,
    bool isLargePrev,
    bool isSingleSeries) {
  double width = segmentRect.width;
  final double height = segmentRect.height;
  final double top = segmentRect.top;
  double left = segmentRect.left, right = segmentRect.right;
  Rect rect;
  seriesRenderer._needAnimateSeriesElements =
      seriesRenderer._needAnimateSeriesElements ||
          segmentRect.outerRect != oldSegmentRect;
  if (!seriesRenderer._chart._chartState._isLegendToggled) {
    width = segmentRect.width *
        ((!comparePrev &&
                !seriesRenderer._chart._chartState.initialRender &&
                oldSegmentRect == null &&
                seriesRenderer._chart._chartState._oldSeriesKeys
                    .contains(seriesRenderer._series.key))
            ? 1
            : animationFactor);
    if (!seriesRenderer._yAxis.isInversed) {
      if (comparePrev) {
        if (yPoint < 0) {
          left = isLargePrev
              ? oldSegmentRect.left -
                  (animationFactor * (oldSegmentRect.left - segmentRect.left))
              : oldSegmentRect.left +
                  (animationFactor * (segmentRect.left - oldSegmentRect.left));
          right = segmentRect.right;
          width = right - left;
        } else {
          right = isLargePrev
              ? oldSegmentRect.right +
                  (animationFactor * (segmentRect.right - oldSegmentRect.right))
              : oldSegmentRect.right -
                  (animationFactor *
                      (oldSegmentRect.right - segmentRect.right));
          width = right - segmentRect.left;
        }
      } else {
        right = yPoint < 0
            ? segmentRect.right
            : (segmentRect.right - segmentRect.width) + width;
      }
    } else {
      if (comparePrev) {
        if (yPoint < 0) {
          right = isLargePrev
              ? oldSegmentRect.right +
                  (animationFactor * (segmentRect.right - oldSegmentRect.right))
              : oldSegmentRect.right -
                  (animationFactor *
                      (oldSegmentRect.right - segmentRect.right));
          width = right - segmentRect.left;
        } else {
          left = isLargePrev
              ? oldSegmentRect.left -
                  (animationFactor * (oldSegmentRect.left - segmentRect.left))
              : oldSegmentRect.left +
                  (animationFactor * (segmentRect.left - oldSegmentRect.left));
          right = segmentRect.right;
          width = right - left;
        }
      } else {
        right = yPoint < 0
            ? (segmentRect.right - segmentRect.width) + width
            : segmentRect.right;
      }
    }
    rect = Rect.fromLTWH(right - width, top, width, height);
  } else if (seriesRenderer._chart._chartState._isLegendToggled &&
      oldSegmentRect != null) {
    rect = _performTransposedLegendToggleAnimation(seriesRenderer, segmentRect,
        oldSegmentRect, oldSeriesVisible, isSingleSeries, animationFactor);
  }

  canvas.drawRRect(
      RRect.fromRectAndRadius(
          rect == null ? segmentRect?.middleRect : rect, segmentRect.blRadius),
      fillPaint);
}

/// To perform legend toggled animation on transposed chart
Rect _performTransposedLegendToggleAnimation(
    CartesianSeriesRenderer seriesRenderer,
    RRect segmentRect,
    Rect oldSegmentRect,
    bool oldSeriesVisible,
    bool isSingleSeries,
    double animationFactor) {
  final dynamic series = seriesRenderer._series;
  num bottom;
  double height = segmentRect.height;
  double top = segmentRect.top;
  double right = segmentRect.right;
  final double width = segmentRect.width;
  if (oldSeriesVisible != null && oldSeriesVisible) {
    bottom = oldSegmentRect.bottom > segmentRect.bottom
        ? oldSegmentRect.bottom +
            (animationFactor * (segmentRect.bottom - oldSegmentRect.bottom))
        : oldSegmentRect.bottom -
            (animationFactor * (oldSegmentRect.bottom - segmentRect.bottom));
    top = oldSegmentRect.top > segmentRect.top
        ? oldSegmentRect.top -
            (animationFactor * (oldSegmentRect.top - segmentRect.top))
        : oldSegmentRect.top +
            (animationFactor * (segmentRect.top - oldSegmentRect.top));
    height = bottom - top;
  } else {
    if (series == seriesRenderer._chart.series[0] && !isSingleSeries) {
      bottom = segmentRect.bottom;
      top = bottom - (segmentRect.height * animationFactor);
      height = bottom - top;
    } else if (series ==
            seriesRenderer
                ._chart.series[seriesRenderer._chart.series.length - 1] &&
        !isSingleSeries) {
      top = segmentRect.top;
      height = segmentRect.height * animationFactor;
    } else {
      height = segmentRect.height * animationFactor;
      top = segmentRect.center.dy - height / 2;
    }
  }
  right = segmentRect.right;
  return Rect.fromLTWH(right - width, top, width, height);
}

/// Rect animation for bar and column series
void _animateNormalRectSeries(
    Canvas canvas,
    CartesianSeriesRenderer seriesRenderer,
    Paint fillPaint,
    RRect segmentRect,
    num yPoint,
    double animationFactor,
    Rect oldSegmentRect,
    bool oldSeriesVisible,
    bool comparePrev,
    bool isLargePrev,
    bool isSingleSeries) {
  double height = segmentRect.height;
  final double width = segmentRect.width;
  final double left = segmentRect.left;
  double top = segmentRect.top, bottom;
  Rect rect;
  seriesRenderer._needAnimateSeriesElements =
      seriesRenderer._needAnimateSeriesElements ||
          segmentRect.outerRect != oldSegmentRect;
  if (!seriesRenderer._chart._chartState._isLegendToggled) {
    height = segmentRect.height *
        ((!comparePrev &&
                !seriesRenderer._chart._chartState.initialRender &&
                oldSegmentRect == null &&
                seriesRenderer._chart._chartState._oldSeriesKeys
                    .contains(seriesRenderer._series.key))
            ? 1
            : animationFactor);
    if (!seriesRenderer._yAxis.isInversed) {
      if (comparePrev) {
        if (yPoint < 0) {
          bottom = isLargePrev
              ? oldSegmentRect.bottom -
                  (animationFactor *
                      (oldSegmentRect.bottom - segmentRect.bottom))
              : oldSegmentRect.bottom +
                  (animationFactor *
                      (segmentRect.bottom - oldSegmentRect.bottom));
          height = bottom - top;
        } else {
          top = isLargePrev
              ? oldSegmentRect.top +
                  (animationFactor * (segmentRect.top - oldSegmentRect.top))
              : oldSegmentRect.top -
                  (animationFactor * (oldSegmentRect.top - segmentRect.top));
          height = segmentRect.bottom - top;
        }
      } else {
        top = yPoint < 0
            ? segmentRect.top
            : (segmentRect.top + segmentRect.height) - height;
      }
    } else {
      if (comparePrev) {
        if (yPoint < 0) {
          top = isLargePrev
              ? oldSegmentRect.top +
                  (animationFactor * (segmentRect.top - oldSegmentRect.top))
              : oldSegmentRect.top -
                  (animationFactor * (oldSegmentRect.top - segmentRect.top));
          height = segmentRect.bottom - top;
        } else {
          bottom = isLargePrev
              ? oldSegmentRect.bottom -
                  (animationFactor *
                      (oldSegmentRect.bottom - segmentRect.bottom))
              : oldSegmentRect.bottom +
                  (animationFactor *
                      (segmentRect.bottom - oldSegmentRect.bottom));
          height = bottom - top;
        }
      } else {
        top = yPoint < 0
            ? (segmentRect.top + segmentRect.height) - height
            : segmentRect.top;
      }
    }
    rect = Rect.fromLTWH(left, top, width, height);
  } else if (seriesRenderer._chart._chartState._isLegendToggled &&
      oldSegmentRect != null &&
      oldSeriesVisible != null) {
    rect = _performLegendToggleAnimation(seriesRenderer, segmentRect,
        oldSegmentRect, oldSeriesVisible, isSingleSeries, animationFactor);
  }
  canvas.drawRRect(
      RRect.fromRectAndRadius(
          rect == null ? segmentRect?.middleRect : rect, segmentRect.blRadius),
      fillPaint);
}

/// Perform legend toggle animation
Rect _performLegendToggleAnimation(
    CartesianSeriesRenderer seriesRenderer,
    RRect segmentRect,
    Rect oldSegmentRect,
    bool oldSeriesVisible,
    bool isSingleSeries,
    double animationFactor) {
  num right;
  final CartesianSeries<dynamic, dynamic> series = seriesRenderer._series;
  final double height = segmentRect.height;
  double width = segmentRect.width;
  double left = segmentRect.left;
  final double top = segmentRect.top;
  if (oldSeriesVisible) {
    right = oldSegmentRect.right > segmentRect.right
        ? oldSegmentRect.right +
            (animationFactor * (segmentRect.right - oldSegmentRect.right))
        : oldSegmentRect.right -
            (animationFactor * (oldSegmentRect.right - segmentRect.right));
    left = oldSegmentRect.left > segmentRect.left
        ? oldSegmentRect.left -
            (animationFactor * (oldSegmentRect.left - segmentRect.left))
        : oldSegmentRect.left +
            (animationFactor * (segmentRect.left - oldSegmentRect.left));
    width = right - left;
  } else {
    if (series == seriesRenderer._chart.series[0] && !isSingleSeries) {
      left = segmentRect.left;
      width = segmentRect.width * animationFactor;
    } else if (series ==
            seriesRenderer
                ._chart.series[seriesRenderer._chart.series.length - 1] &&
        !isSingleSeries) {
      right = segmentRect.right;
      left = right - (segmentRect.width * animationFactor);
      width = right - left;
    } else {
      width = segmentRect.width * animationFactor;
      left = segmentRect.center.dx - width / 2;
    }
  }
  return Rect.fromLTWH(left, top, width, height);
}

/// To animation rect for stacked column series
void _animateStackedRectSeries(
    Canvas canvas,
    RRect segmentRect,
    Paint fillPaint,
    CartesianSeriesRenderer seriesRenderer,
    double animationFactor,
    CartesianChartPoint<dynamic> currentPoint,
    SfCartesianChart chart) {
  int index, seriesIndex;
  List<CartesianSeriesRenderer> seriesCollection;
  Rect prevRegion;
  final _StackedSeriesBase<dynamic, dynamic> series = seriesRenderer._series;
  index = seriesRenderer._dataPoints.indexOf(currentPoint);
  seriesCollection = _findSeriesCollection(chart);
  seriesIndex = seriesCollection.indexOf(seriesRenderer);
  bool isStackLine = false;
  if (seriesIndex != 0) {
    if (seriesRenderer
                ._chart._chartSeries.visibleSeriesRenderers[seriesIndex - 1]
            is StackedLineSeriesRenderer ||
        seriesRenderer
                ._chart._chartSeries.visibleSeriesRenderers[seriesIndex - 1]
            is StackedLine100SeriesRenderer) {
      isStackLine = true;
    }
    if (!isStackLine) {
      for (int j = 0;
          j < chart._chartSeries.clusterStackedItemInfo.length;
          j++) {
        final _ClusterStackedItemInfo clusterStackedItemInfo =
            chart._chartSeries.clusterStackedItemInfo[j];
        if (clusterStackedItemInfo.stackName == series.groupName) {
          if (clusterStackedItemInfo.stackedItemInfo.length >= 2) {
            for (int k = 0;
                k < clusterStackedItemInfo.stackedItemInfo.length;
                k++) {
              final _StackedItemInfo stackedItemInfo =
                  clusterStackedItemInfo.stackedItemInfo[k];
              if (stackedItemInfo.seriesIndex == seriesIndex &&
                  k != 0 &&
                  index <
                      clusterStackedItemInfo.stackedItemInfo[k - 1]
                          .seriesRenderer._dataPoints.length) {
                if ((currentPoint.yValue > 0 &&
                        clusterStackedItemInfo.stackedItemInfo[k - 1]
                                .seriesRenderer._dataPoints[index].yValue >
                            0) ||
                    (currentPoint.yValue < 0 &&
                        clusterStackedItemInfo.stackedItemInfo[k - 1]
                                .seriesRenderer._dataPoints[index].yValue <
                            0)) {
                  prevRegion = clusterStackedItemInfo.stackedItemInfo[k - 1]
                      .seriesRenderer._dataPoints[index].region;
                } else {
                  if (k > 1)
                    prevRegion = clusterStackedItemInfo
                        .stackedItemInfo[(k - 1) - 1]
                        .seriesRenderer
                        ._dataPoints[index]
                        .region;
                }
              }
            }
          }
        }
      }
    }
  }
  _drawAnimatedStackedRect(canvas, segmentRect, fillPaint, seriesRenderer,
      animationFactor, currentPoint, index, prevRegion);
}

/// To draw the animated rect for stacked series
void _drawAnimatedStackedRect(
    Canvas canvas,
    RRect segmentRect,
    Paint fillPaint,
    CartesianSeriesRenderer seriesRenderer,
    double animationFactor,
    CartesianChartPoint<dynamic> currentPoint,
    int index,
    Rect prevRegion) {
  double top = segmentRect.top, height = segmentRect.height;
  double right = segmentRect.right, width = segmentRect.width;
  final double height1 = segmentRect.height, top1 = segmentRect.top;
  height = segmentRect.height * animationFactor;
  width = segmentRect.width * animationFactor;
  if ((seriesRenderer._seriesType.contains('stackedcolumn')) &&
          seriesRenderer._chart.isTransposed != true ||
      (seriesRenderer._seriesType.contains('stackedbar')) &&
          seriesRenderer._chart.isTransposed == true) {
    seriesRenderer._yAxis.isInversed != true
        ? seriesRenderer._dataPoints[index].y > 0
            ? prevRegion == null
                ? top = (segmentRect.top + segmentRect.height) - height
                : top = prevRegion.top - height
            : prevRegion == null
                ? top = segmentRect.top
                : top = prevRegion.bottom
        : seriesRenderer._dataPoints[index].y > 0
            ? prevRegion == null
                ? top = segmentRect.top
                : top = prevRegion.bottom
            : prevRegion == null
                ? top = (segmentRect.top + segmentRect.height) - height
                : top = prevRegion.top - height;

    segmentRect = RRect.fromRectAndRadius(
        Rect.fromLTWH(segmentRect.left, top, segmentRect.width, height),
        segmentRect.blRadius);
    currentPoint.region =
        Rect.fromLTWH(segmentRect.left, top, segmentRect.width, height);
    canvas.drawRRect(segmentRect, fillPaint);
  } else if ((seriesRenderer._seriesType.contains('stackedcolumn')) &&
          seriesRenderer._chart.isTransposed == true ||
      (seriesRenderer._seriesType.contains('stackedbar')) &&
          seriesRenderer._chart.isTransposed != true) {
    seriesRenderer._yAxis.isInversed != true
        ? seriesRenderer._dataPoints[index].y > 0
            ? prevRegion == null
                ? right = (segmentRect.right - segmentRect.width) + width
                : right = prevRegion.right + width
            : prevRegion == null
                ? right = segmentRect.right
                : right = prevRegion.left
        : seriesRenderer._dataPoints[index].y > 0
            ? prevRegion == null
                ? right = segmentRect.right
                : right = prevRegion.left
            : prevRegion == null
                ? right = (segmentRect.right - segmentRect.width) + width
                : right = prevRegion.right + width;

    segmentRect = RRect.fromRectAndRadius(
        Rect.fromLTWH(right - width, top1, width, height1),
        segmentRect.blRadius);
    currentPoint.region =
        Rect.fromLTWH(segmentRect.left, right, segmentRect.width, width);
    canvas.drawRRect(segmentRect, fillPaint);
  }
}

/// To check the series count
bool _checkSingleSeries(CartesianSeriesRenderer seriesRenderer) {
  int count = 0;
  for (int i = 0;
      i < seriesRenderer._chart._chartSeries.visibleSeriesRenderers.length;
      i++) {
    if (seriesRenderer._chart._chartSeries.visibleSeriesRenderers[i]._visible) {
      count++;
    }
  }
  return count == 1 ? true : false;
}

/// to animate dynamic update in line, spline, stepLine series
void _animateLineTypeSeries(
    Canvas canvas,
    CartesianSeriesRenderer seriesRenderer,
    Paint strokePaint,
    double animationFactor,
    num newX1,
    num newY1,
    num newX2,
    num newY2,
    num _oldX1,
    num _oldY1,
    num _oldX2,
    num _oldY2,
    [num newX3,
    num newY3,
    num _oldX3,
    num _oldY3,
    num newX4,
    num newY4,
    num oldX4,
    num oldY4]) {
  num x1 = newX1;
  num y1 = newY1;
  num x2 = newX2;
  num y2 = newY2;
  num x3 = newX3;
  num y3 = newY3;
  num x4 = newX4;
  num y4 = newY4;
  // if (!series._chart.isTransposed) {
  y1 = _getValue(animationFactor, y1, _oldY1, newY1, seriesRenderer);
  y2 = _getValue(animationFactor, y2, _oldY2, newY2, seriesRenderer);
  y3 = _getValue(animationFactor, y3, _oldY3, newY3, seriesRenderer);
  y4 = _getValue(animationFactor, y4, oldY4, newY4, seriesRenderer);
  // } else {
  x1 = _getValue(animationFactor, x1, _oldX1, newX1, seriesRenderer);
  x2 = _getValue(animationFactor, x2, _oldX2, newX2, seriesRenderer);
  x3 = _getValue(animationFactor, x3, _oldX3, newX3, seriesRenderer);
  x4 = _getValue(animationFactor, x4, oldX4, newX4, seriesRenderer);
  // }

  final Path path = Path();
  path.moveTo(x1, y1);
  if (seriesRenderer._seriesType == 'stepline') {
    path.lineTo(x3, y3);
  }
  seriesRenderer._seriesType == 'spline'
      ? path.cubicTo(x3, y3, x4, y4, x2, y2)
      : path.lineTo(x2, y2);
  _drawDashedLine(canvas, seriesRenderer._series.dashArray, strokePaint, path);
}

// this method returns the value through which the oldValue could be animated to the newValue based on animationFactor
num _getValue(double animationFactor, double value, num oldvalue, num newValue,
    [CartesianSeriesRenderer seriesRenderer]) {
  if (seriesRenderer != null) {
    seriesRenderer._needAnimateSeriesElements =
        seriesRenderer._needAnimateSeriesElements || oldvalue != newValue;
  }
  return (oldvalue != null && newValue != null && !oldvalue.isNaN)
      ? ((oldvalue > newValue)
          ? oldvalue - ((oldvalue - newValue) * animationFactor)
          : oldvalue + ((newValue - oldvalue) * animationFactor))
      : value;
}

// To animate scatter series
void _animateScatterSeries(
    CartesianSeriesRenderer seriesRenderer,
    CartesianChartPoint<dynamic> point,
    CartesianChartPoint<dynamic> _oldPoint,
    double animationFactor,
    Canvas canvas,
    Paint fillPaint,
    Paint strokePaint) {
  final CartesianSeries<dynamic, dynamic> series = seriesRenderer._series;
  final num width = series.markerSettings.width,
      height = series.markerSettings.height;
  final DataMarkerType markerType = series.markerSettings.shape;
  num x = point.markerPoint.x;
  num y = point.markerPoint.y;
  if (seriesRenderer._chart._chartState.widgetNeedUpdate &&
      _oldPoint != null &&
      _oldPoint.markerPoint != null) {
    x = _getValue(
        animationFactor, x, _oldPoint.markerPoint.x, x, seriesRenderer);
    y = _getValue(
        animationFactor, y, _oldPoint.markerPoint.y, y, seriesRenderer);
    animationFactor = 1;
  }

  final Path path = Path();
  {
    switch (markerType) {
      case DataMarkerType.circle:
        _ChartShapeUtils._drawCircle(
            path, x, y, animationFactor * width, animationFactor * height);
        break;
      case DataMarkerType.rectangle:
        _ChartShapeUtils._drawRectangle(
            path, x, y, animationFactor * width, animationFactor * height);
        break;
      case DataMarkerType.image:
        _drawImageMarker(seriesRenderer, canvas, x, y);
        break;
      case DataMarkerType.pentagon:
        _ChartShapeUtils._drawPentagon(
            path, x, y, animationFactor * width, animationFactor * height);
        break;
      case DataMarkerType.verticalLine:
        _ChartShapeUtils._drawVerticalLine(
            path, x, y, animationFactor * width, animationFactor * height);
        break;
      case DataMarkerType.invertedTriangle:
        _ChartShapeUtils._drawInvertedTriangle(
            path, x, y, animationFactor * width, animationFactor * height);
        break;
      case DataMarkerType.horizontalLine:
        _ChartShapeUtils._drawHorizontalLine(
            path, x, y, animationFactor * width, animationFactor * height);
        break;
      case DataMarkerType.diamond:
        _ChartShapeUtils._drawDiamond(
            path, x, y, animationFactor * width, animationFactor * height);
        break;
      case DataMarkerType.triangle:
        _ChartShapeUtils._drawTriangle(
            path, x, y, animationFactor * width, animationFactor * height);
        break;
      case DataMarkerType.none:
        break;
    }
  }
  canvas.drawPath(path, strokePaint);
  canvas.drawPath(path, fillPaint);
}

/// To animate bubble series
void _animateBubbleSeries(
    Canvas canvas,
    num newX,
    num newY,
    num oldX,
    num oldY,
    num oldSize,
    double animationFactor,
    num radius,
    Paint strokePaint,
    Paint fillPaint,
    CartesianSeriesRenderer seriesRenderer) {
  num x = newX;
  num y = newY;
  num size = radius;
  // if (isTransposed) {
  x = _getValue(animationFactor, x, oldX, newX, seriesRenderer);
  // } else {
  y = _getValue(animationFactor, y, oldY, newY, seriesRenderer);
  // }
  size = _getValue(animationFactor, size, oldSize, radius, seriesRenderer);
  canvas.drawCircle(Offset(x, y), size, fillPaint);
  canvas.drawCircle(Offset(x, y), size, strokePaint);
}

/// To animates range column series
void _animateRangeColumn(
    Canvas canvas,
    CartesianSeriesRenderer seriesRenderer,
    Paint fillPaint,
    RRect segmentRect,
    Rect oldSegmentRect,
    double animationFactor) {
  double height = segmentRect.height;
  double width = segmentRect.width;
  double left = segmentRect.left;
  double top = segmentRect.top;
  if (oldSegmentRect == null) {
    if (!seriesRenderer._chart.isTransposed) {
      height = segmentRect.height * animationFactor;
      top = segmentRect.center.dy - height / 2;
    } else {
      width = segmentRect.width * animationFactor;
      left = segmentRect.center.dx - width / 2;
    }
  } else {
    if (!seriesRenderer._chart.isTransposed) {
      height = _getValue(animationFactor, height, oldSegmentRect.height,
          segmentRect.height, seriesRenderer);
      top = _getValue(animationFactor, top, oldSegmentRect.top, segmentRect.top,
          seriesRenderer);
    } else {
      width = _getValue(animationFactor, width, oldSegmentRect.width,
          segmentRect.width, seriesRenderer);
      left = _getValue(animationFactor, left, oldSegmentRect.left,
          segmentRect.left, seriesRenderer);
    }
  }
  canvas.drawRRect(
      RRect.fromRectAndRadius(
          Rect.fromLTWH(left, top, width, height), segmentRect.blRadius),
      fillPaint);
}

// To animate linear type animation
void _performLinearAnimation(SfCartesianChart chart, ChartAxis axis,
    Canvas canvas, double animationFactor) {
  chart.isTransposed
      ? canvas.clipRect(Rect.fromLTRB(
          0,
          axis.isInversed
              ? 0
              : (1 - animationFactor) * chart._chartAxis._axisClipRect.bottom,
          chart._chartAxis._axisClipRect.left +
              chart._chartAxis._axisClipRect.width,
          axis.isInversed
              ? animationFactor *
                  (chart._chartAxis._axisClipRect.top +
                      chart._chartAxis._axisClipRect.height)
              : chart._chartAxis._axisClipRect.top +
                  chart._chartAxis._axisClipRect.height))
      : canvas.clipRect(Rect.fromLTRB(
          axis.isInversed
              ? (1 - animationFactor) * (chart._chartAxis._axisClipRect.right)
              : 0,
          0,
          axis.isInversed
              ? chart._chartAxis._axisClipRect.left +
                  chart._chartAxis._axisClipRect.width
              : animationFactor *
                  (chart._chartAxis._axisClipRect.left +
                      chart._chartAxis._axisClipRect.width),
          chart._chartAxis._axisClipRect.top +
              chart._chartAxis._axisClipRect.height));
}

/// To animate Hilo series
void _animateHiloSeries(
    bool transposed,
    _ChartLocation newLow,
    _ChartLocation newHigh,
    _ChartLocation oldLow,
    _ChartLocation oldHigh,
    double animationFactor,
    Paint paint,
    Canvas canvas,
    CartesianSeriesRenderer seriesRenderer) {
  if (transposed) {
    num lowX = newLow.x;
    num highX = newHigh.x;
    num y = newLow.y;
    y = _getValue(animationFactor, y, oldLow?.y, newLow.y, seriesRenderer);
    lowX =
        _getValue(animationFactor, lowX, oldLow?.x, newLow.x, seriesRenderer);
    highX = _getValue(
        animationFactor, highX, oldHigh?.x, newHigh.x, seriesRenderer);
    canvas.drawLine(Offset(lowX, y), Offset(highX, y), paint);
  } else {
    num low = newLow.y;
    num high = newHigh.y;
    num x = newLow.x;
    x = _getValue(animationFactor, x, oldLow?.x, newLow.x, seriesRenderer);
    low = _getValue(animationFactor, low, oldLow?.y, newLow.y, seriesRenderer);
    high =
        _getValue(animationFactor, high, oldHigh?.y, newHigh.y, seriesRenderer);
    canvas.drawLine(Offset(x, low), Offset(x, high), paint);
  }
}

/// To animate the Hilo open-close series
void _animateHiloOpenCloseSeries(
    bool transposed,
    num newLow,
    num newHigh,
    num oldLow,
    num oldHigh,
    num newOpenX,
    num newOpenY,
    num newCloseX,
    num newCloseY,
    num newCenterLow,
    num newCenterHigh,
    num oldOpenX,
    num oldOpenY,
    num oldCloseX,
    num oldCloseY,
    num oldCenterLow,
    num oldCenterHigh,
    double animationFactor,
    Paint paint,
    Canvas canvas,
    CartesianSeriesRenderer seriesRenderer) {
  num low = newLow;
  num high = newHigh;
  num openX = newOpenX;
  num openY = newOpenY;
  num closeX = newCloseX;
  num closeY = newCloseY;
  num centerHigh = newCenterHigh;
  num centerLow = newCenterLow;
  low = _getValue(animationFactor, low, oldLow, newLow, seriesRenderer);
  high = _getValue(animationFactor, high, oldHigh, newHigh, seriesRenderer);
  openX = _getValue(animationFactor, openX, oldOpenX, newOpenX, seriesRenderer);
  openY = _getValue(animationFactor, openY, oldOpenY, newOpenY, seriesRenderer);
  closeX =
      _getValue(animationFactor, closeX, oldCloseX, newCloseX, seriesRenderer);
  closeY =
      _getValue(animationFactor, closeY, oldCloseY, newCloseY, seriesRenderer);
  centerHigh = _getValue(animationFactor, centerHigh, oldCenterHigh,
      newCenterHigh, seriesRenderer);
  centerLow = _getValue(
      animationFactor, centerLow, oldCenterLow, newCenterLow, seriesRenderer);
  if (transposed) {
    canvas.drawLine(Offset(low, centerLow), Offset(high, centerHigh), paint);
    canvas.drawLine(Offset(openX, openY), Offset(openX, centerHigh), paint);
    canvas.drawLine(Offset(closeX, centerLow), Offset(closeX, closeY), paint);
  } else {
    canvas.drawLine(Offset(centerHigh, low), Offset(centerLow, high), paint);
    canvas.drawLine(Offset(openX, openY), Offset(centerHigh, openY), paint);
    canvas.drawLine(Offset(centerLow, closeY), Offset(closeX, closeY), paint);
  }
}

/// To animate the candle series
void _animateCandleSeries(
    bool showSameValue,
    num high,
    bool transposed,
    num open1,
    num close1,
    num newLow,
    num newHigh,
    num oldLow,
    num oldHigh,
    num newOpenX,
    num newOpenY,
    num newCloseX,
    num newCloseY,
    num newCenterLow,
    num newCenterHigh,
    num oldOpenX,
    num oldOpenY,
    num oldCloseX,
    num oldCloseY,
    num oldCenterLow,
    num oldCenterHigh,
    double animationFactor,
    Paint paint,
    Canvas canvas,
    CartesianSeriesRenderer seriesRenderer) {
  final num open = open1;
  final num close = close1;
  num lowY = newLow;
  num highY = newHigh;
  num openX = newOpenX;
  num openY = newOpenY;
  num closeX = newCloseX;
  num closeY = newCloseY;
  num centerHigh = newCenterHigh;
  num centerLow = newCenterLow;
  lowY = _getValue(animationFactor, lowY, oldLow, newLow, seriesRenderer);
  highY = _getValue(animationFactor, highY, oldHigh, newHigh, seriesRenderer);
  openX = _getValue(animationFactor, openX, oldOpenX, newOpenX, seriesRenderer);
  openY = _getValue(animationFactor, openY, oldOpenY, newOpenY, seriesRenderer);
  closeX =
      _getValue(animationFactor, closeX, oldCloseX, newCloseX, seriesRenderer);
  closeY =
      _getValue(animationFactor, closeY, oldCloseY, newCloseY, seriesRenderer);
  centerHigh = _getValue(animationFactor, centerHigh, oldCenterHigh,
      newCenterHigh, seriesRenderer);
  centerLow = _getValue(
      animationFactor, centerLow, oldCenterLow, newCenterLow, seriesRenderer);
  final Path path = Path();
  if (!transposed && open > close) {
    final num temp = closeY;
    closeY = openY;
    openY = temp;
  }
  if (transposed) {
    if (showSameValue) {
      canvas.drawLine(
          Offset(centerHigh, highY), Offset(centerLow, highY), paint);
    } else {
      path.moveTo(centerHigh, highY);
      if (centerHigh < closeX) {
        path.lineTo(closeX, highY);
      } else
        path.lineTo(closeX, highY);
      path.moveTo(centerLow, highY);
      if (centerLow > openX) {
        path.lineTo(openX, highY);
      } else
        path.lineTo(openX, highY);
    }
    if (openX == closeX) {
      canvas.drawLine(Offset(openX, openY), Offset(closeX, closeY), paint);
    } else {
      path.moveTo(closeX, closeY);
      path.lineTo(closeX, openY);
      path.lineTo(openX, openY);
      path.lineTo(openX, closeY);
      path.lineTo(closeX, closeY);
      path.close();
    }
  } else {
    if (open > close) {
      final num temp = closeY;
      closeY = openY;
      openY = temp;
    }
    if (showSameValue) {
      canvas.drawLine(
          Offset(centerHigh, high), Offset(centerHigh, lowY), paint);
    } else {
      canvas.drawLine(
          Offset(centerHigh, closeY), Offset(centerHigh, highY), paint);
      canvas.drawLine(Offset(centerLow, openY), Offset(centerLow, lowY), paint);
    }
    if (openY == closeY) {
      canvas.drawLine(Offset(openX, openY), Offset(closeX, closeY), paint);
    } else {
      path.moveTo(openX, openY);
      path.lineTo(closeX, openY);
      path.lineTo(closeX, closeY);
      path.lineTo(openX, closeY);
      path.lineTo(openX, openY);
      path.close();
    }
  }
  canvas.drawPath(path, paint);
  if (paint.style == PaintingStyle.fill) {
    if (transposed) {
      if (open > close) {
        if (showSameValue) {
          canvas.drawLine(
              Offset(centerHigh, highY), Offset(centerLow, highY), paint);
        } else {
          canvas.drawLine(
              Offset(centerHigh, highY), Offset(closeX, highY), paint);
          canvas.drawLine(
              Offset(centerLow, highY), Offset(openX, highY), paint);
        }
      } else {
        if (showSameValue) {
          canvas.drawLine(
              Offset(centerHigh, highY), Offset(centerLow, highY), paint);
        } else {
          canvas.drawLine(
              Offset(centerHigh, highY), Offset(closeX, highY), paint);
          canvas.drawLine(
              Offset(centerLow, highY), Offset(openX, highY), paint);
        }
      }
    } else {
      if (showSameValue) {
        canvas.drawLine(
            Offset(centerHigh, high), Offset(centerHigh, lowY), paint);
      } else {
        canvas.drawLine(
            Offset(centerHigh, closeY), Offset(centerHigh, highY), paint);
        canvas.drawLine(
            Offset(centerLow, openY), Offset(centerLow, lowY), paint);
      }
    }
  }
}

// To get nearest chart points from the touch point
List<dynamic> _getNearestChartPoints(
    double pointX,
    double pointY,
    ChartAxis actualXAxis,
    ChartAxis actualYAxis,
    CartesianSeriesRenderer cartesianSeriesRenderer,
    [List<dynamic> firstNearestDataPoints]) {
  final List<dynamic> dataPointList = <dynamic>[];
  List<dynamic> dataList = <dynamic>[];
  final List<num> xValues = <num>[];
  final List<num> yValues = <num>[];

  firstNearestDataPoints != null
      ? dataList = firstNearestDataPoints
      : dataList = cartesianSeriesRenderer._dataPoints;

  for (int i = 0; i < dataList.length; i++) {
    xValues.add(dataList[i].xValue);
    yValues.add(dataList[i].yValue ?? (dataList[i].high + dataList[i].low) / 2);
  }
  num nearPointX = actualXAxis._visibleRange.minimum;
  num nearPointY = actualYAxis._visibleRange.minimum;

  final Rect rect = _calculatePlotOffset(
      cartesianSeriesRenderer._chart._chartAxis._axisClipRect,
      Offset(cartesianSeriesRenderer._xAxis.plotOffset,
          cartesianSeriesRenderer._yAxis.plotOffset));

  final num touchXValue = _pointToXValue(
      cartesianSeriesRenderer._chart,
      actualXAxis,
      actualXAxis.isVisible
          ? actualXAxis._bounds
          : cartesianSeriesRenderer._chart._chartAxis._axisClipRect,
      pointX - rect.left,
      pointY - rect.top);
  final num touchYValue = _pointToYValue(
      cartesianSeriesRenderer._chart,
      actualYAxis,
      actualYAxis.isVisible
          ? actualYAxis._bounds
          : cartesianSeriesRenderer._chart._chartAxis._axisClipRect,
      pointX - rect.left,
      pointY - rect.top);
  double delta = 0;
  for (int i = 0; i < dataList.length; i++) {
    final double currX = xValues[i].toDouble();
    final double currY = yValues[i].toDouble();
    if (delta == touchXValue - currX) {
      final CartesianChartPoint<dynamic> dataPoint = dataList[i];
      if (dataPoint.isDrop != true && dataPoint.isGap != true) {
        if ((touchYValue - currY).abs() > (touchYValue - nearPointY).abs())
          dataPointList.clear();
        dataPointList.add(dataPoint);
      }
    } else if ((touchXValue - currX).abs() <=
        (touchXValue - nearPointX).abs()) {
      nearPointX = currX;
      nearPointY = currY;
      delta = touchXValue - currX;
      final CartesianChartPoint<dynamic> dataPoint = dataList[i];
      dataPointList.clear();
      if (dataPoint.isDrop != true && dataPoint.isGap != true) {
        dataPointList.add(dataPoint);
      }
    }
  }
  return dataPointList;
}

/// Return the arguments for zoom event
ZoomPanArgs _zoomEvent(SfCartesianChart chart, dynamic axis,
    ZoomPanArgs zoomPanArgs, ChartZoomingCallback zoomEventType) {
  zoomPanArgs = ZoomPanArgs();
  zoomPanArgs.axis = axis;
  zoomPanArgs.currentZoomFactor = axis._zoomFactor;
  zoomPanArgs.currentZoomPosition = axis._zoomPosition;
  zoomPanArgs.previousZoomFactor = axis._previousZoomFactor;
  zoomPanArgs.previousZoomPosition = axis._previousZoomPosition;
  zoomEventType == chart.onZoomStart
      ? chart.onZoomStart(zoomPanArgs)
      : zoomEventType == chart.onZoomEnd
          ? chart.onZoomEnd(zoomPanArgs)
          : zoomEventType == chart.onZooming
              ? chart.onZooming(zoomPanArgs)
              : chart.onZoomReset(zoomPanArgs);

  return zoomPanArgs;
}

//Method to returning path for dashed border in rect type series
Path _dashedBorder(
    CartesianChartPoint<dynamic> _currentPoint, double borderWidth) {
  Path path;
  dynamic topLeft, topRight, bottomRight, bottomLeft, width;
  topLeft = _currentPoint.region.topLeft;
  topRight = _currentPoint.region.topRight;
  bottomLeft = _currentPoint.region.bottomLeft;
  bottomRight = _currentPoint.region.bottomRight;
  width = borderWidth / 2;
  path = Path();
  path.moveTo(topLeft.dx + width, topLeft.dy + width);
  path.lineTo(topRight.dx - width, topRight.dy + width);
  path.lineTo(bottomRight.dx - width, bottomRight.dy - width);
  path.lineTo(bottomLeft.dx + width, bottomLeft.dy - width);
  path.lineTo(topLeft.dx + width, topLeft.dy + width);
  path.close();
  return path;
}

/// below method is for getting image from the imageprovider
Future<dart_ui.Image> _getImageInfo(ImageProvider imageProvider) async {
  final Completer<ImageInfo> completer = Completer<ImageInfo>();
  imageProvider
      .resolve(const ImageConfiguration())
      .addListener(ImageStreamListener((ImageInfo info, bool _) {
    completer.complete(info);
    return completer.future;
  }));
  final ImageInfo imageInfo = await completer.future;
  return imageInfo.image;
}

//ignore: avoid_void_async
void _calculateImage([dynamic chart, dynamic seriesRenderer]) async {
  if (chart != null && seriesRenderer == null) {
    if (chart.plotAreaBackgroundImage != null) {
      chart._chartState._backgroundImage =
          await _getImageInfo(chart.plotAreaBackgroundImage);
      chart._chartState.renderAxis.state.axisRepaintNotifier.values++;
    }
    if (chart.legend.image != null) {
      chart._chartState._legendIconImage =
          await _getImageInfo(chart.legend.image);
      chart._chartLegend.legendRepaintNotifier.values++;
    }
  } else {
    final dynamic series = seriesRenderer._series;
    if (series.markerSettings.image != null) {
      series.markerSettings._image =
          await _getImageInfo(series.markerSettings.image);
      seriesRenderer._chart._chartState.seriesRepaintNotifier.values++;
      if (seriesRenderer._seriesType == 'scatter' &&
          seriesRenderer._chart.legend.isVisible)
        seriesRenderer._chart._chartLegend.legendRepaintNotifier.values++;
    }
  }
}
