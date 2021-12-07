part of charts;

class _ChartLegend {
  _ChartLegend();
  dynamic chart;
  Legend legend;
  List<_LegendRenderContext> legendCollections;
  int rowCount;
  int columnCount;
  Size legendSize = const Size(0, 0);
  Size chartSize = const Size(0, 0);
  bool needRenderLegend = false;
  ValueNotifier<int> legendRepaintNotifier;
  bool isNeedScrollable;

  void _calculateLegendBounds(Size size) {
    legend = chart.legend;
    if (legend.isVisible) {
      if (chart is SfCartesianChart) {
        chart._chartState.isFullyLoaded ??= true;
      }
      legendCollections = <_LegendRenderContext>[];
      _calculateSeriesLegends();
      if (chart is SfCartesianChart) {
        chart._chartState.isFullyLoaded = false;
      }
      if (legendCollections.isNotEmpty ||
          chart._chartState.legendWidgetContext.isNotEmpty) {
        num legendHeight = 0,
            legendWidth = 0,
            titleHeight = 0,
            textHeight = 0,
            textWidth = 0,
            maxTextHeight = 0,
            maxTextWidth = 0,
            maxLegendWidth = 0,
            maxLegendHeight = 0,
            currentWidth = 0,
            currentHeight = 0,
            maxRenderWidth,
            maxRenderHeight;
        Size titleSize;
        const num titleSpace = 10;
        final num padding = legend.itemPadding;
        chart._chartLegend.isNeedScrollable = false;
        final bool isBottomOrTop =
            legend.legendPosition == LegendPosition.bottom ||
                legend.legendPosition == LegendPosition.top;
        legend._orientation = (legend.orientation == LegendItemOrientation.auto)
            ? (isBottomOrTop
                ? LegendItemOrientation.horizontal
                : LegendItemOrientation.vertical)
            : legend.orientation;

        maxRenderHeight = legend.height != null
            ? _percentageToValue(legend.height, size.height)
            : isBottomOrTop
                ? _percentageToValue('30%', size.height)
                : size.height;

        maxRenderWidth = legend.width != null
            ? _percentageToValue(legend.width, size.width)
            : isBottomOrTop
                ? size.width
                : _percentageToValue('30%', size.width);

        if (legend.title.text != null && legend.title.text.isNotEmpty) {
          titleSize = _measureText(
              legend.title.text,
              legend.title.textStyle ??
                  TextStyle(
                      color: chart._chartState._chartTheme.legendTitleColor));
          titleHeight = titleSize.height + titleSpace;
        }

        final bool isTemplate = legend.legendItemBuilder != null;
        final int length = isTemplate
            ? chart._chartState.legendWidgetContext.length
            : legendCollections.length;
        _MeasureWidgetContext legendContext;
        _LegendRenderContext legendRenderContext;
        String legendText;
        Size textSize;
        for (int i = 0; i < length; i++) {
          if (isTemplate) {
            legendContext = chart._chartState.legendWidgetContext[i];
            currentWidth = legendContext.size.width + padding;
            currentHeight = legendContext.size.height + padding;
          } else {
            legendRenderContext = legendCollections[i];
            legendText = legendRenderContext.text;
            textSize = _measureText(legendText,
                legend.textStyle ?? const TextStyle(color: Colors.black));
            legendRenderContext.textSize = textSize;
            textHeight = textSize.height;
            textWidth = textSize.width;
            maxTextHeight = max(textHeight, maxTextHeight);
            maxTextWidth = max(textWidth, maxTextWidth);
            currentWidth =
                padding + legend.iconWidth + legend.padding + textWidth;
            currentHeight = padding + max(maxTextHeight, legend.iconHeight);
            legendRenderContext.size = Size(currentWidth, currentHeight);
          }
          if (i == 0) {
            maxRenderWidth = legend.width == null && !isBottomOrTop
                ? max(maxRenderWidth, currentWidth)
                : maxRenderWidth;
            maxRenderHeight = (titleHeight -
                    (legend.height == null && isBottomOrTop
                        ? max(maxRenderHeight, currentHeight)
                        : maxRenderHeight))
                .abs();
          }
          needRenderLegend = true;
          bool needRender = false;
          if (legend._orientation == LegendItemOrientation.horizontal) {
            if (legend.overflowMode == LegendItemOverflowMode.wrap) {
              if ((legendWidth + currentWidth) > maxRenderWidth) {
                legendWidth = currentWidth;
                if (legendHeight + currentHeight > maxRenderHeight) {
                  chart._chartLegend.isNeedScrollable = true;
                } else {
                  legendHeight = legendHeight + currentHeight;
                }
                maxTextHeight = textHeight;
              } else {
                legendWidth += currentWidth;
                legendHeight = max(legendHeight, currentHeight);
              }
            } else if (legend.overflowMode == LegendItemOverflowMode.scroll ||
                legend.overflowMode == LegendItemOverflowMode.none) {
              if (maxLegendWidth + currentWidth <= maxRenderWidth) {
                legendWidth += currentWidth;
                legendHeight = max(legendHeight, currentHeight);
                needRender = true;
              } else {
                needRender = false;
              }
            }
          } else {
            if (legend.overflowMode == LegendItemOverflowMode.wrap) {
              if ((legendHeight + currentHeight) > maxRenderHeight) {
                legendHeight = currentHeight;
                if (legendWidth + currentWidth > maxRenderWidth) {
                  chart._chartLegend.isNeedScrollable = true;
                } else {
                  legendWidth = legendWidth + currentWidth;
                }
              } else {
                legendHeight += currentHeight;
                legendWidth = max(legendWidth, currentWidth);
              }
            } else if (legend.overflowMode == LegendItemOverflowMode.scroll ||
                legend.overflowMode == LegendItemOverflowMode.none) {
              if (maxLegendHeight + currentHeight <= maxRenderHeight) {
                legendHeight += currentHeight;
                legendWidth = max(legendWidth, currentWidth);
                needRender = true;
              } else {
                needRender = false;
              }
            }
          }
          if (isTemplate) {
            legendContext.isRender = needRender;
          } else {
            legendRenderContext.isRender = needRender;
          }
          maxLegendWidth = max(maxLegendWidth, legendWidth);
          maxLegendHeight = max(maxLegendHeight, legendHeight);
        }
        legendSize = Size(
            maxLegendWidth + padding, maxLegendHeight + titleHeight.toDouble());
      }
    }
  }

  void _calculateLegends(
      SfCartesianChart chart, int index, CartesianSeriesRenderer seriesRenderer,
      [Trendline trendline, int trendlineIndex]) {
    LegendRenderArgs legendEventArgs;
    bool isTrendlineadded = false;
    final dynamic series = seriesRenderer._series;
    if (trendline != null) {
      isTrendlineadded = true;
    }
    seriesRenderer._seriesName = seriesRenderer._seriesName ?? 'series $index';
    if (series.isVisibleInLegend &&
        (seriesRenderer._seriesName != null || series.legendItemText != null)) {
      if (chart.onLegendItemRender != null) {
        legendEventArgs = LegendRenderArgs();
        legendEventArgs.text = series.legendItemText ??
            (isTrendlineadded ? trendline._name : seriesRenderer._seriesName);
        legendEventArgs.legendIconType =
            isTrendlineadded ? trendline.legendIconType : series.legendIconType;
        legendEventArgs.seriesIndex = index;
        legendEventArgs.color =
            isTrendlineadded ? trendline.color : series.color;
        chart.onLegendItemRender(legendEventArgs);
      }
      final _LegendRenderContext _legendRenderContext = _LegendRenderContext(
          seriesRenderer: seriesRenderer,
          trendline: trendline,
          seriesIndex: index,
          trendlineIndex: isTrendlineadded ? trendlineIndex : null,
          isSelect: chart._chartState.isTrendlineToggled
              ? (isTrendlineadded ? !trendline._visible : true)
              : !series.isVisible,
          text: legendEventArgs?.text ??
              series.legendItemText ??
              (isTrendlineadded ? trendline._name : seriesRenderer._seriesName),
          iconColor: legendEventArgs?.color ??
              (isTrendlineadded ? trendline.color : series.color),
          iconType: legendEventArgs?.legendIconType ??
              (isTrendlineadded
                  ? trendline.legendIconType
                  : series.legendIconType));
      legendCollections.add(_legendRenderContext);
      if (!seriesRenderer._visible &&
          series.isVisibleInLegend &&
          chart._chartState.isFullyLoaded) {
        _legendRenderContext.isSelect = true;
        chart._chartState.legendToggleStates.add(_legendRenderContext);
      }
    }
  }

  void _calculateSeriesLegends() {
    LegendRenderArgs legendEventArgs;
    if (chart.legend.legendItemBuilder == null) {
      if (chart is SfCartesianChart) {
        for (int i = 0;
            i < chart._chartSeries.visibleSeriesRenderers.length;
            i++) {
          final dynamic seriesRenderer =
              chart._chartSeries.visibleSeriesRenderers[i];
          _calculateLegends(chart, i, seriesRenderer);
          if (seriesRenderer is CartesianSeriesRenderer) {
            final CartesianSeriesRenderer xYSeriesRenderer = seriesRenderer;
            if (xYSeriesRenderer?._series != null &&
                xYSeriesRenderer._series.trendlines != null) {
              for (int j = 0;
                  j < xYSeriesRenderer._series.trendlines.length;
                  j++) {
                final Trendline trendline =
                    xYSeriesRenderer._series.trendlines[j];
                if (trendline.isVisibleInLegend)
                  chart._chartLegend._calculateLegends(
                      chart, i, xYSeriesRenderer, trendline, j);
              }
            }
          }
        }
        if (chart.indicators.isNotEmpty) {
          _calculateIndicatorLegends();
        }
      } else if (chart._chartSeries.visibleSeriesRenderers.isNotEmpty) {
        final dynamic seriesRenderer =
            chart._chartSeries.visibleSeriesRenderers[0];
        for (int j = 0; j < seriesRenderer._renderPoints.length; j++) {
          final dynamic chartPoint = seriesRenderer._renderPoints[j];
          if (chart.onLegendItemRender != null) {
            legendEventArgs = LegendRenderArgs();
            legendEventArgs.text = chartPoint.x;
            legendEventArgs.legendIconType =
                seriesRenderer._series.legendIconType;
            legendEventArgs.seriesIndex = 0;
            legendEventArgs.pointIndex = j;
            legendEventArgs.color = chartPoint.fill;
            chart.onLegendItemRender(legendEventArgs);
          }

          legendCollections.add(_LegendRenderContext(
              seriesRenderer: seriesRenderer,
              seriesIndex: j,
              isSelect: false,
              point: chartPoint,
              text: legendEventArgs?.text ?? chartPoint.x,
              iconColor: legendEventArgs?.color ?? chartPoint.fill,
              iconType: legendEventArgs?.legendIconType ??
                  seriesRenderer._series.legendIconType));
        }
      }
    }
  }

  void _calculateIndicatorLegends() {
    LegendRenderArgs legendEventArgs;
    final List<String> textCollection = <String>[];
    for (int i = 0; i < chart.indicators.length; i++) {
      final dynamic indicator = chart.indicators[i];
      chart._chartSeries?._setIndicatorType(indicator);
      textCollection.add(indicator._indicatorType);
    }
    //ignore: prefer_collection_literals
    final Map<String, int> _map = Map<String, int>();
    //ignore: avoid_function_literals_in_foreach_calls
    textCollection.forEach((dynamic str) =>
        _map[str] = !_map.containsKey(str) ? (1) : (_map[str] + 1));

    final List<String> indicatorTextCollection = <String>[];
    for (int i = 0; i < chart.indicators.length; i++) {
      final dynamic indicator = chart.indicators[i];
      final int count =
          indicatorTextCollection.contains(indicator._indicatorType)
              ? chart._chartSeries?._getIndicatorId(
                  indicatorTextCollection, indicator._indicatorType)
              : 0;
      indicatorTextCollection.add(indicator._indicatorType);
      indicator._name = indicator.name ??
          (indicator._indicatorType +
              (_map[indicator._indicatorType] == 1
                  ? ''
                  : ' ' + count.toString()));
      if (indicator.isVisible && indicator.isVisibleInLegend) {
        if (chart.onLegendItemRender != null) {
          legendEventArgs = LegendRenderArgs();
          legendEventArgs.text = indicator.legendItemText ?? indicator._name;
          legendEventArgs.legendIconType = indicator.legendIconType;
          legendEventArgs.seriesIndex = i;
          legendEventArgs.color = indicator.signalLineColor;
          chart.onLegendItemRender(legendEventArgs);
        }
        final _LegendRenderContext _legendRenderContext = _LegendRenderContext(
            seriesRenderer: indicator,
            seriesIndex: chart._chartSeries.visibleSeriesRenderers.length + i,
            isSelect: !indicator.isVisible,
            text: legendEventArgs?.text ??
                indicator.legendItemText ??
                indicator._name,
            iconColor: legendEventArgs?.color ?? indicator.signalLineColor,
            iconType:
                legendEventArgs?.legendIconType ?? indicator.legendIconType);
        legendCollections.add(_legendRenderContext);
        if (!indicator.isVisible &&
            indicator.isVisibleInLegend &&
            chart._chartState.initialRender) {
          _legendRenderContext.isSelect = true;
          chart._chartState.legendToggleStates.add(_legendRenderContext);
        }
      }
    }
  }
}

class _LegendContainer extends StatelessWidget {
  const _LegendContainer({this.chart});

  final dynamic chart;

  @override
  Widget build(BuildContext context) {
    final List<_LegendRenderContext> legendCollections =
        chart._chartLegend.legendCollections;
    final List<Widget> legendWidgets = <Widget>[];
    final Legend legend = chart.legend;
    num titleHeight = 0;
    chart._chartLegend.legendRepaintNotifier = ValueNotifier<int>(0);
    if (legend.legendItemBuilder != null) {
      for (int i = 0; i < chart._chartState.legendWidgetContext.length; i++) {
        final _MeasureWidgetContext legendRenderContext =
            chart._chartState.legendWidgetContext[i];
        if (legend.overflowMode == LegendItemOverflowMode.none
            ? legendRenderContext.isRender
            : true) {
          legendWidgets.add(_RenderLegend(
              index: i,
              template: legendRenderContext.widget,
              size: legendRenderContext.size,
              chart: chart));
        }
      }
    } else {
      for (int i = 0; i < legendCollections.length; i++) {
        final _LegendRenderContext legendRenderContext = legendCollections[i];
        if (legend.overflowMode == LegendItemOverflowMode.none
            ? legendRenderContext.isRender
            : true) {
          legendWidgets.add(_RenderLegend(
              index: i, size: legendRenderContext.size, chart: chart));
        }
      }
    }

    final bool needLegendTitle =
        legend.title.text != null && legend.title.text.isNotEmpty;

    if (needLegendTitle) {
      titleHeight = _measureText(
                  legend.title.text,
                  legend.title.textStyle ??
                      TextStyle(
                          color:
                              chart._chartState._chartTheme.legendTitleColor))
              .height +
          10;
    }
    return _getWidget(legendWidgets, needLegendTitle, titleHeight);
  }

  Widget _getWidget(
      List<Widget> legendWidgets, bool needLegendTitle, num titleHeight) {
    Widget widget;
    final Legend legend = chart.legend;
    final double legendHeight = chart._chartLegend.legendSize.height;
    if (chart._chartLegend.isNeedScrollable) {
      widget = Container(
          height: needLegendTitle
              ? (legendHeight - titleHeight).abs()
              : legendHeight,
          child: SingleChildScrollView(
              scrollDirection:
                  legend._orientation == LegendItemOrientation.horizontal
                      ? Axis.vertical
                      : Axis.horizontal,
              child: legend._orientation == LegendItemOrientation.horizontal
                  ? Wrap(direction: Axis.horizontal, children: legendWidgets)
                  : Wrap(direction: Axis.vertical, children: legendWidgets)));
    } else if (legend.overflowMode == LegendItemOverflowMode.scroll) {
      widget = Container(
          height: needLegendTitle
              ? (legendHeight - titleHeight).abs()
              : legendHeight,
          child: SingleChildScrollView(
              scrollDirection:
                  legend._orientation == LegendItemOrientation.horizontal
                      ? Axis.horizontal
                      : Axis.vertical,
              child: legend._orientation == LegendItemOrientation.horizontal
                  ? Row(children: legendWidgets)
                  : Column(children: legendWidgets)));
    } else if (legend.overflowMode == LegendItemOverflowMode.none) {
      widget = Container(
          height: needLegendTitle
              ? (legendHeight - titleHeight).abs()
              : legendHeight,
          child: legend._orientation == LegendItemOrientation.horizontal
              ? Row(children: legendWidgets)
              : Column(children: legendWidgets));
    } else {
      widget = Container(
          height: needLegendTitle
              ? (legendHeight - titleHeight).abs()
              : legendHeight,
          width: chart._chartLegend.legendSize.width,
          child: Wrap(
              direction: legend._orientation == LegendItemOrientation.horizontal
                  ? Axis.horizontal
                  : Axis.vertical,
              children: legendWidgets));
    }
    if (needLegendTitle) {
      final ChartAlignment titleAlign = legend.title.alignment;
      final Color color = chart.legend.title.textStyle.color ??
          chart._chartState._chartTheme.legendTitleColor;
      final double fontSize = chart.legend.title.textStyle.fontSize;
      final String fontFamily = chart.legend.title.textStyle.fontFamily;
      final FontStyle fontStyle = chart.legend.title.textStyle.fontStyle;
      final FontWeight fontWeight = chart.legend.title.textStyle.fontWeight;
      widget = Container(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
            Container(
                height: titleHeight,
                alignment: titleAlign == ChartAlignment.center
                    ? Alignment.center
                    : titleAlign == ChartAlignment.near
                        ? Alignment.centerLeft
                        : Alignment.centerRight,
                child: Container(
                  child: Text(legend.title.text,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          color: color,
                          fontSize: fontSize,
                          fontFamily: fontFamily,
                          fontStyle: fontStyle,
                          fontWeight: fontWeight)),
                )),
            widget
          ]));
    }
    return widget;
  }
}
