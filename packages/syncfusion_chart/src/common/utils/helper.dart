part of charts;

///To get saturation color
Color _getSaturationColor(Color color) {
  Color saturationColor;
  final num contrast =
      ((color.red * 299 + color.green * 587 + color.blue * 114) / 1000).round();
  saturationColor = contrast >= 128 ? Colors.black : Colors.white;
  return saturationColor;
}

CartesianChartPoint<dynamic> _getPointFromData(
    CartesianSeriesRenderer seriesRenderer, int pointIndex) {
  final XyDataSeries<dynamic, dynamic> series = seriesRenderer._series;
  final dynamic xValue = series.xValueMapper;
  final dynamic yValue = series.yValueMapper;
  final dynamic xVal = xValue(pointIndex);
  final dynamic yVal = (seriesRenderer._seriesType.contains('range') ||
          seriesRenderer._seriesType.contains('hilo') ||
          seriesRenderer._seriesType == 'candle')
      ? null
      : yValue(pointIndex);

  final CartesianChartPoint<dynamic> point =
      CartesianChartPoint<dynamic>(xVal, yVal);
  if (seriesRenderer._seriesType.contains('range') ||
      seriesRenderer._seriesType.contains('hilo') ||
      seriesRenderer._seriesType == 'candle') {
    final dynamic highValue = series.highValueMapper;
    final dynamic lowValue = series.lowValueMapper;
    point.high = highValue(pointIndex);
    point.low = lowValue(pointIndex);
  }
  if (series is _FinancialSeriesBase) {
    if (seriesRenderer._seriesType == 'hiloopenclose' ||
        seriesRenderer._seriesType == 'candle') {
      final dynamic openValue = series.openValueMapper;
      final dynamic closeValue = series.closeValueMapper;
      point.open = openValue(pointIndex);
      point.close = closeValue(pointIndex);
    }
  }
  return point;
}

TextStyle _getTextStyle(
    {TextStyle textStyle,
    Color fontColor,
    double fontSize,
    FontStyle fontStyle,
    String fontFamily,
    FontWeight fontWeight,
    Paint background,
    bool takeFontColorValue}) {
  if (textStyle != null) {
    return TextStyle(
      color: textStyle.color != null &&
              (takeFontColorValue == null ? true : !takeFontColorValue)
          ? textStyle.color
          : fontColor,
      fontWeight: textStyle.fontWeight ?? fontWeight,
      fontSize: textStyle.fontSize ?? fontSize,
      fontStyle: textStyle.fontStyle ?? fontStyle,
      fontFamily: textStyle.fontFamily ?? fontFamily,
      inherit: textStyle.inherit,
      backgroundColor: textStyle.backgroundColor,
      letterSpacing: textStyle.letterSpacing,
      wordSpacing: textStyle.wordSpacing,
      textBaseline: textStyle.textBaseline,
      height: textStyle.height,
      locale: textStyle.locale,
      foreground: textStyle.foreground,
      background: textStyle.background,
      shadows: textStyle.shadows,
      fontFeatures: textStyle.fontFeatures,
      decoration: textStyle.decoration,
      decorationColor: textStyle.decorationColor,
      decorationStyle: textStyle.decorationStyle,
      decorationThickness: textStyle.decorationThickness,
      debugLabel: textStyle.debugLabel,
      fontFamilyFallback: textStyle.fontFamilyFallback,
    );
  } else {
    return TextStyle(
      color: fontColor,
      fontWeight: fontWeight,
      fontSize: fontSize,
      fontStyle: fontStyle,
      fontFamily: fontFamily,
    );
  }
}

Widget _getElements(
    dynamic chart, Widget chartWidget, BoxConstraints constraints) {
  final LegendPosition legendPosition = chart.legend.legendPosition;
  double legendHeight, legendWidth, chartHeight, chartWidth;
  Widget element;
  if (chart._chartLegend.needRenderLegend && chart.legend.isResponsive) {
    chartHeight = constraints.maxHeight - chart._chartLegend.legendSize.height;
    chartWidth = constraints.maxWidth - chart._chartLegend.legendSize.width;
    chart._chartLegend.needRenderLegend =
        (legendPosition == LegendPosition.bottom ||
                legendPosition == LegendPosition.top)
            ? (chartHeight > chart._chartLegend.legendSize.height)
            : (chartWidth > chart._chartLegend.legendSize.width);
  }
  if (!chart._chartLegend.needRenderLegend) {
    element = Container(
        child: chartWidget,
        width: constraints.maxWidth,
        height: constraints.maxHeight);
  } else {
    legendHeight = chart._chartLegend.legendSize.height;
    legendWidth = chart._chartLegend.legendSize.width;
    chartHeight = chart._chartLegend.chartSize.height - legendHeight;
    chartWidth = chart._chartLegend.chartSize.width - legendWidth;
    final Widget legendBorderWidget =
        CustomPaint(painter: _ChartLegendStylePainter(chart: chart));
    final Widget legendWidget = Container(
        height: legendHeight,
        width: legendWidth,
        decoration: BoxDecoration(color: chart.legend.backgroundColor),
        child: _LegendContainer(chart: chart));
    switch (legendPosition) {
      case LegendPosition.bottom:
      case LegendPosition.top:
        element = _getBottomAndTopLegend(
            chart,
            chartWidget,
            constraints,
            legendWidget,
            legendBorderWidget,
            legendHeight,
            legendWidth,
            chartHeight);
        break;
      case LegendPosition.right:
      case LegendPosition.left:
        element = _getLeftAndRightLegend(
            chart,
            chartWidget,
            constraints,
            legendWidget,
            legendBorderWidget,
            legendHeight,
            legendWidth,
            chartWidth);
        break;
      default:
        break;
    }
  }
  return element;
}

Widget _getBottomAndTopLegend(
    dynamic chart,
    Widget chartWidget,
    BoxConstraints constraints,
    Widget legendWidget,
    Widget legendBorderWidget,
    double legendHeight,
    double legendWidth,
    double chartHeight) {
  Widget element;
  const double legendPadding = 5;
  const double padding = 10;
  final bool needPadding = chart is SfCircularChart ||
      chart is SfPyramidChart ||
      chart is SfFunnelChart;
  final LegendPosition legendPosition = chart.legend.legendPosition;
  final double legendLeft = (chart._chartLegend.chartSize.width < legendWidth)
      ? 0
      : ((chart.legend.alignment == ChartAlignment.near)
          ? 0
          : (chart.legend.alignment == ChartAlignment.center)
              ? chart._chartLegend.chartSize.width / 2 -
                  chart._chartLegend.legendSize.width / 2
              : chart._chartLegend.chartSize.width -
                  chart._chartLegend.legendSize.width);
  final EdgeInsets margin = (legendPosition == LegendPosition.top)
      ? EdgeInsets.fromLTRB(
          legendLeft + (needPadding ? padding : 0), legendPadding, 0, 0)
      : EdgeInsets.fromLTRB(legendLeft, chartHeight + legendPadding, 0, 0);
  legendWidget = Container(
    child: Stack(children: <Widget>[
      Container(
          margin: margin,
          height: legendHeight,
          width: legendWidth,
          child: legendBorderWidget),
      Container(
          margin: margin,
          height: legendHeight,
          width: legendWidth,
          child: legendWidget)
    ]),
  );
  if (legendPosition == LegendPosition.top) {
    element = Container(
        height: constraints.maxHeight,
        width: constraints.maxWidth,
        child: Stack(
          children: <Widget>[
            legendWidget,
            Container(
              margin: EdgeInsets.fromLTRB(
                  needPadding ? padding : 0, legendHeight + padding, 0, 0),
              height: chartHeight,
              width: chart._chartLegend.chartSize.width,
              child: chartWidget,
            )
          ],
        ));
  } else {
    element = Container(
        margin: EdgeInsets.fromLTRB(
            needPadding ? padding : 0, needPadding ? padding : 0, 0, 0),
        height: constraints.maxHeight,
        width: constraints.maxWidth,
        child: Stack(
          children: <Widget>[
            Container(
              height: chartHeight,
              width: chart._chartLegend.chartSize.width,
              child: chartWidget,
            ),
            legendWidget
          ],
        ));
  }
  return element;
}

Widget _getLeftAndRightLegend(
    dynamic chart,
    Widget chartWidget,
    BoxConstraints constraints,
    Widget legendWidget,
    Widget legendBorderWidget,
    double legendHeight,
    double legendWidth,
    double chartWidth) {
  Widget element;
  const double legendPadding = 5;
  const double padding = 10;
  final bool needPadding = chart is SfCircularChart ||
      chart is SfPyramidChart ||
      chart is SfFunnelChart;
  final LegendPosition legendPosition = chart.legend.legendPosition;
  final double legendTop = (chart._chartLegend.chartSize.height < legendHeight)
      ? 0
      : ((chart.legend.alignment == ChartAlignment.near)
          ? 0
          : (chart.legend.alignment == ChartAlignment.center)
              ? chart._chartLegend.chartSize.height / 2 -
                  chart._chartLegend.legendSize.height / 2
              : chart._chartLegend.chartSize.height -
                  chart._chartLegend.legendSize.height);
  final EdgeInsets margin = (legendPosition == LegendPosition.left)
      ? EdgeInsets.fromLTRB(legendPadding / 2, legendTop, 0, 0)
      : EdgeInsets.fromLTRB(chartWidth + legendPadding, legendTop, 0, 0);
  legendWidget = Container(
    child: Stack(children: <Widget>[
      Container(
        margin: margin,
        height: legendHeight,
        width: legendWidth,
        child: legendBorderWidget,
      ),
      Container(
        margin: margin,
        height: legendHeight,
        width: legendWidth,
        child: legendWidget,
      )
    ]),
  );
  if (legendPosition == LegendPosition.left) {
    element = Container(
        height: constraints.maxHeight,
        width: constraints.maxWidth,
        child: Stack(
          children: <Widget>[
            legendWidget,
            Container(
              margin: EdgeInsets.fromLTRB(
                  legendWidth + (needPadding ? padding : 0),
                  needPadding ? chart.margin.top : 0,
                  0,
                  0),
              height: chart._chartLegend.chartSize.height,
              width: chartWidth,
              child: chartWidget,
            )
          ],
        ));
  } else {
    element = Container(
        height: constraints.maxHeight,
        width: constraints.maxWidth,
        child: Stack(
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(top: needPadding ? chart.margin.top : 0),
              height: chart._chartLegend.chartSize.height,
              width: chartWidth,
              child: chartWidget,
            ),
            legendWidget
          ],
        ));
  }
  return element;
}

class _MeasureWidgetSize extends StatelessWidget {
  const _MeasureWidgetSize(
      {this.chart,
      this.currentWidget,
      this.opacityValue,
      this.currentKey,
      this.seriesIndex,
      this.pointIndex,
      this.type});
  final dynamic chart;
  final Widget currentWidget;
  final double opacityValue;
  final Key currentKey;
  final int seriesIndex;
  final int pointIndex;
  final String type;
  @override
  Widget build(BuildContext context) {
    final List<_MeasureWidgetContext> templates =
        chart._chartState.legendWidgetContext;
    templates.add(_MeasureWidgetContext(
        widget: currentWidget,
        key: currentKey,
        context: context,
        seriesIndex: seriesIndex,
        pointIndex: pointIndex));
    return Container(
        key: currentKey,
        child: Opacity(opacity: opacityValue, child: currentWidget));
  }
}

bool _legendToggleTemplateState(
    _MeasureWidgetContext currentItem, dynamic chart, String checkType) {
  bool needSelect = false;
  final List<_MeasureWidgetContext> legendToggles =
      chart._chartState.legendToggleTemplateStates;
  if (legendToggles.isNotEmpty) {
    for (int i = 0; i < legendToggles.length; i++) {
      final _MeasureWidgetContext item = legendToggles[i];
      if (currentItem.seriesIndex == item.seriesIndex &&
          currentItem.pointIndex == item.pointIndex) {
        if (checkType != 'isSelect') {
          needSelect = true;
          legendToggles.removeAt(i);
        }
        break;
      }
    }
  }
  if (!needSelect) {
    needSelect = false;
    if (checkType != 'isSelect') {
      legendToggles.add(currentItem);
    }
  }
  return needSelect;
}

void _legendToggleState(_LegendRenderContext currentItem, dynamic chart) {
  bool needSelect = false;
  final List<_LegendRenderContext> legendToggles =
      chart._chartState.legendToggleStates;
  if (legendToggles.isNotEmpty) {
    for (int i = 0; i < legendToggles.length; i++) {
      final _LegendRenderContext item = legendToggles[i];
      if (currentItem.seriesIndex == item.seriesIndex) {
        needSelect = true;
        legendToggles.removeAt(i);
        break;
      }
    }
  }
  if (!needSelect) {
    needSelect = false;
    legendToggles.add(currentItem);
  }
}

void _cartesianLegendToggleState(
    _LegendRenderContext currentItem, dynamic chart) {
  bool needSelect = false;
  final List<_LegendRenderContext> legendToggles =
      chart._chartState.legendToggleStates;
  if (currentItem.trendline == null ||
      chart._chartSeries.visibleSeriesRenderers[currentItem.seriesIndex]
          ._visible) {
    if (legendToggles.isNotEmpty) {
      for (int i = 0; i < legendToggles.length; i++) {
        final _LegendRenderContext item = legendToggles[i];
        if (currentItem.trendline != null &&
            currentItem.text == item.text &&
            (currentItem.seriesIndex == item.seriesIndex &&
                currentItem.trendlineIndex == item.trendlineIndex)) {
          needSelect = true;
          // chart._chartState.isTrendlineToggled = false;
          legendToggles.removeAt(i);
          break;
        } else if (currentItem.trendline == null &&
            currentItem.seriesIndex == item.seriesIndex &&
            currentItem.text == item.text) {
          needSelect = true;
          // chart._chartState.isTrendlineToggled = true;
          legendToggles.removeAt(i);
          break;
        }
      }
    }
    if (!needSelect) {
      if (!(!currentItem.seriesRenderer._visible &&
          !chart._chartState.isTrendlineToggled)) {
        needSelect = false;
        final CartesianSeriesRenderer seriesRenderer =
            chart._chartSeries.visibleSeriesRenderers[currentItem.seriesIndex];
        if (currentItem.trendlineIndex != null) {
          seriesRenderer._minimumX = 1 / 0;
          seriesRenderer._minimumY = 1 / 0;
          seriesRenderer._maximumX = -1 / 0;
          seriesRenderer._maximumY = -1 / 0;
        }
        chart._chartSeries.visibleSeriesRenderers[currentItem.seriesIndex] =
            seriesRenderer;
        legendToggles.add(currentItem);
      }
    }
  }
}

bool _isCollide(Rect rect, List<Rect> regions, [Rect pathRect]) {
  bool isCollide = false;
  if (pathRect != null &&
      (pathRect.left < rect.left &&
          pathRect.width > rect.width &&
          pathRect.top < rect.top &&
          pathRect.height > rect.height)) {
    isCollide = false;
  } else if (pathRect != null) {
    isCollide = true;
  }
  for (int i = 0; i < regions.length; i++) {
    final Rect regionRect = regions[i];
    if ((rect.left < regionRect.left + regionRect.width &&
            rect.left + rect.width > regionRect.left) &&
        (rect.top < regionRect.top + regionRect.height &&
            rect.top + rect.height > regionRect.top)) {
      isCollide = true;
      break;
    }
  }
  return isCollide;
}

num _getValueByPercentage(num value1, num value2) {
  num value;
  value = value1.isNegative
      ? (num.tryParse('-' +
          (num.tryParse(value1.toString().replaceAll(RegExp('-'), '')) % value2)
              .toString()))
      : (value1 % value2);
  return value;
}

// void _animateComplete(List<AnimationController> controllerList, dynamic chart) {
//   bool statusCompleted;
//   if (controllerList.isNotEmpty) {
//     for (AnimationController item in controllerList) {
//       item.addStatusListener((AnimationStatus status) {
//         if (status == AnimationStatus.completed) {
//           for (int i = 0; i < controllerList.length; i++) {
//             if (controllerList[i].status != AnimationStatus.completed) {
//               statusCompleted = false;
//               break;
//             } else {
//               statusCompleted = true;
//             }
//           }
//         }
//         if (statusCompleted) {
//           chart._chartState.animateCompleted = true;
//           if (chart._chartState.renderDataLabel != null) {
//             chart._chartState.renderDataLabel.state.render();
//           }
//         }
//       });
//     }
//   } else {
//     chart._chartState.animateCompleted =
//         chart is SfCartesianChart ? true : chart._chartState.animateCompleted;
//   }
// }

Widget _renderChartTitle(dynamic widget) {
  Widget titleWidget;
  if (widget.title.text != null && widget.title.text.isNotEmpty) {
    final Color color = widget.title.textStyle.color ??
        widget._chartState._chartTheme.titleTextColor;
    final double fontSize = widget.title.textStyle.fontSize;
    final String fontFamily = widget.title.textStyle.fontFamily;
    final FontStyle fontStyle = widget.title.textStyle.fontStyle;
    final FontWeight fontWeight = widget.title.textStyle.fontWeight;
    titleWidget = Container(
      margin: EdgeInsets.fromLTRB(widget.margin.left, widget.margin.top,
          widget.margin.right, widget.margin.bottom),
      child: Container(
          padding: const EdgeInsets.fromLTRB(0, 5, 0, 0),
          decoration: BoxDecoration(
              color: widget.title.backgroundColor ??
                  widget._chartState._chartTheme.titleBackgroundColor,
              border: Border.all(
                  color: widget.title.borderColor ??
                      widget._chartState._chartTheme.titleTextColor,
                  width: widget.title.borderWidth)),
          child: Text(widget.title.text,
              style: TextStyle(
                  color: color,
                  fontSize: fontSize,
                  fontFamily: fontFamily,
                  fontStyle: fontStyle,
                  fontWeight: fontWeight),
              textScaleFactor: 1.2,
              overflow: TextOverflow.clip,
              textAlign: TextAlign.center)),
      alignment: (widget.title.alignment == ChartAlignment.near)
          ? Alignment.topLeft
          : (widget.title.alignment == ChartAlignment.far)
              ? Alignment.topRight
              : (widget.title.alignment == ChartAlignment.center)
                  ? Alignment.topCenter
                  : Alignment.topCenter,
    );
  } else {
    titleWidget = Container();
  }
  return titleWidget;
}

/// To get the legend template widgets
List<Widget> _bindLegendTemplateWidgets(dynamic widget) {
  Widget legendWidget;
  final List<Widget> templates = <Widget>[];
  widget._chartState._chartWidgets = <Widget>[];
  if (widget.legend.isVisible && widget.legend.legendItemBuilder != null) {
    for (int i = 0;
        i < widget._chartSeries.visibleSeriesRenderers.length;
        i++) {
      final dynamic seriesRenderer =
          widget._chartSeries.visibleSeriesRenderers[i];
      for (int j = 0; j < seriesRenderer._renderPoints.length; j++) {
        legendWidget = widget.legend.legendItemBuilder(
            seriesRenderer._renderPoints[j].x,
            seriesRenderer,
            seriesRenderer._renderPoints[j],
            j);
        templates.add(_MeasureWidgetSize(
            chart: widget,
            type: 'Legend',
            seriesIndex: i,
            pointIndex: j,
            currentKey: GlobalKey(),
            currentWidget: legendWidget,
            opacityValue: 0.0));
      }
    }
  }
  return templates;
}

bool _validIndex(int _pointIndex, int _seriesIndex, SfCartesianChart chart) {
  return _seriesIndex != null &&
      _pointIndex != null &&
      _seriesIndex >= 0 &&
      _seriesIndex < chart.series.length &&
      _pointIndex >= 0 &&
      _pointIndex < chart.series[_seriesIndex].dataSource.length;
}
