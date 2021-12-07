part of charts;

/// Calculating data label position and updating the label region for current data point
void _calculateDataLabelPosition(CartesianSeriesRenderer seriesRenderer,
    CartesianChartPoint<dynamic> point, int index, SfCartesianChart chart,
    [Size templateSize, Offset templateLocation]) {
  final dynamic series = seriesRenderer._series;
  final DataLabelSettings dataLabel = series.dataLabelSettings;
  Size textSize, textSize2, textSize3, textSize4;
  num value1, value2;
  final Rect rect = _calculatePlotOffset(
      chart._chartAxis._axisClipRect,
      Offset(
          seriesRenderer._xAxis.plotOffset, seriesRenderer._yAxis.plotOffset));
  value1 =
      (point.open != null && point.close != null && point.close < point.open)
          ? point.close
          : point.open;
  value2 =
      (point.open != null && point.close != null && point.close > point.open)
          ? point.close
          : point.open;
  final bool transposed = chart._requireInvertedAxis;
  final bool inversed = seriesRenderer._yAxis.isInversed;
  final Rect clipRect = _calculatePlotOffset(
      chart._chartAxis._axisClipRect,
      Offset(
          seriesRenderer._xAxis.plotOffset, seriesRenderer._yAxis.plotOffset));
  final bool isRangeSeries = seriesRenderer._seriesType.contains('range') ||
      seriesRenderer._seriesType.contains('hilo') ||
      seriesRenderer._seriesType.contains('candle');
  // ignore: prefer_final_fields
  String label = point.dataLabelMapper ??
      point.label ??
      _getLabelText(
          isRangeSeries
              ? (!inversed ? point.high : point.low)
              : ((dataLabel.showCumulativeValues &&
                      point.cumulativeValue != null)
                  ? point.cumulativeValue
                  : point.yValue),
          seriesRenderer,
          chart);
  if (isRangeSeries)
    point.label2 = point.dataLabelMapper ??
        _getLabelText(
            !inversed ? point.low : point.high, seriesRenderer, chart);
  DataLabelRenderArgs dataLabelArgs;
  TextStyle dataLabelStyle = dataLabel._textStyle;
  DataLabelSettings labelSettings;
  labelSettings = DataLabelSettings(color: dataLabel.color);
  //ignore: prefer_conditional_assignment
  if (dataLabel._originalStyle == null) {
    dataLabel._originalStyle = dataLabel.textStyle;
  }
  dataLabelStyle = dataLabel._originalStyle;
  labelSettings._color = dataLabel.color;
  if (chart.onDataLabelRender != null) {
    dataLabelArgs = DataLabelRenderArgs();
    dataLabelArgs.text = label;
    dataLabelArgs.textStyle = dataLabelStyle;
    dataLabelArgs.seriesRenderer = seriesRenderer;
    dataLabelArgs.dataPoints = seriesRenderer._dataPoints;
    dataLabelArgs.pointIndex = index;
    dataLabelArgs.color = labelSettings._color;
    chart.onDataLabelRender(dataLabelArgs);
    label = point.label = dataLabelArgs.text;
    dataLabelStyle = dataLabelArgs.textStyle;
    index = dataLabelArgs.pointIndex;
    labelSettings._color = dataLabelArgs.color;
  }
  dataLabel._textStyle = dataLabelStyle;
  series.dataLabelSettings._color = labelSettings._color;
  labelSettings._color = null;
  if (point != null &&
      point.isVisible &&
      point.isGap != true &&
      (point.y != 0 || dataLabel.showZeroValue)) {
    final num markerPointX = dataLabel.builder == null
        ? seriesRenderer._seriesType.contains('hilo') ||
                seriesRenderer._seriesType == 'candle'
            ? seriesRenderer._chart._requireInvertedAxis
                ? point.region.centerRight.dx
                : point.region.topCenter.dx
            : point.markerPoint.x
        : templateLocation.dx;
    final num markerPointY = dataLabel.builder == null
        ? seriesRenderer._seriesType.contains('hilo') ||
                seriesRenderer._seriesType == 'candle'
            ? seriesRenderer._chart._requireInvertedAxis
                ? point.region.centerRight.dy
                : point.region.topCenter.dy
            : point.markerPoint.y
        : templateLocation.dy;
    final _ChartLocation markerPoint2 = _calculatePoint(
        point.xValue,
        seriesRenderer._yAxis.isInversed ? value2 : value1,
        seriesRenderer._xAxis,
        seriesRenderer._yAxis,
        chart._requireInvertedAxis,
        series,
        rect);
    final _ChartLocation markerPoint3 = _calculatePoint(
        point.xValue,
        seriesRenderer._yAxis.isInversed ? value1 : value2,
        seriesRenderer._xAxis,
        seriesRenderer._yAxis,
        chart._requireInvertedAxis,
        series,
        rect);
    final TextStyle font = (dataLabel._textStyle == null)
        ? const TextStyle(
            fontFamily: 'Roboto',
            fontStyle: FontStyle.normal,
            fontWeight: FontWeight.normal,
            fontSize: 12)
        : dataLabelStyle;
    point.label = label;
    if (label.isNotEmpty) {
      _ChartLocation chartLocation,
          chartLocation2,
          chartLocation3,
          chartLocation4;
      textSize =
          dataLabel.builder == null ? _measureText(label, font) : templateSize;
      chartLocation = _ChartLocation(markerPointX, markerPointY);
      if (isRangeSeries) {
        textSize2 = dataLabel.builder == null
            ? _measureText(point.label2, font)
            : templateSize;
        chartLocation2 = _ChartLocation(
            dataLabel.builder == null
                ? seriesRenderer._seriesType.contains('hilo') ||
                        seriesRenderer._seriesType == 'candle'
                    ? seriesRenderer._chart._requireInvertedAxis
                        ? point.region.centerLeft.dx
                        : point.region.bottomCenter.dx
                    : point.markerPoint2.x
                : templateLocation.dx,
            dataLabel.builder == null
                ? seriesRenderer._seriesType.contains('hilo') ||
                        seriesRenderer._seriesType == 'candle'
                    ? seriesRenderer._chart._requireInvertedAxis
                        ? point.region.centerLeft.dy
                        : point.region.bottomCenter.dy
                    : point.markerPoint2.y
                : templateLocation.dy);
      }
      final List<_ChartLocation> alignedLabelLocations =
          _getAlignedLabelLocations(chart, seriesRenderer, point, dataLabel,
              chartLocation, chartLocation2, textSize);
      chartLocation = alignedLabelLocations[0];
      chartLocation2 = alignedLabelLocations[1];
      if (!seriesRenderer._seriesType.contains('column') &&
          !seriesRenderer._seriesType.contains('bar') &&
          !seriesRenderer._seriesType.contains('rangearea') &&
          !seriesRenderer._seriesType.contains('hilo') &&
          !seriesRenderer._seriesType.contains('candle')) {
        chartLocation.y = _calculatePathPosition(
            chartLocation.y,
            dataLabel.labelAlignment,
            textSize,
            dataLabel.borderWidth,
            seriesRenderer,
            index,
            transposed,
            chartLocation,
            chart,
            point,
            Size(
                series.markerSettings.isVisible
                    ? series.markerSettings.width / 2
                    : 0,
                series.markerSettings.isVisible
                    ? series.markerSettings.height / 2
                    : 0));
      } else {
        final List<_ChartLocation> _locations = _getLabelLocations(
            index,
            chart,
            seriesRenderer,
            point,
            dataLabel,
            chartLocation,
            chartLocation2,
            textSize,
            textSize2);
        chartLocation = _locations[0];
        chartLocation2 = _locations[1];
      }
      if (seriesRenderer._seriesType == 'hiloopenclose' ||
          seriesRenderer._seriesType.contains('candle')) {
        point.label3 = point.dataLabelMapper ??
            _getLabelText(
                point.open > point.close
                    ? !inversed ? point.close : point.open
                    : !inversed ? point.open : point.close,
                seriesRenderer,
                chart);
        point.label4 = point.dataLabelMapper ??
            _getLabelText(
                point.open > point.close
                    ? !inversed ? point.open : point.close
                    : !inversed ? point.close : point.open,
                seriesRenderer,
                chart);
        textSize3 = dataLabel.builder == null
            ? _measureText(point.label3, font)
            : templateSize;
        if (seriesRenderer._seriesType.contains('hilo')) {
          if (point.open > point.close)
            chartLocation3 = _ChartLocation(
                point.centerClosePoint.x + textSize3.width, point.closePoint.y);
          else
            chartLocation3 = _ChartLocation(
                point.centerOpenPoint.x - textSize3.width, point.openPoint.y);
        } else if (seriesRenderer._seriesType == 'candle' &&
            seriesRenderer._chart._requireInvertedAxis) {
          if (point.open > point.close) {
            chartLocation3 =
                _ChartLocation(point.closePoint.x, markerPoint2.y + 1);
          } else
            chartLocation3 =
                _ChartLocation(point.openPoint.x, markerPoint2.y + 1);
        } else {
          chartLocation3 =
              _ChartLocation(point.region.topCenter.dx, markerPoint2.y);
        }
        textSize4 = dataLabel.builder == null
            ? _measureText(point.label4, font)
            : templateSize;
        if (seriesRenderer._seriesType.contains('hilo')) {
          if (point.open > point.close)
            chartLocation4 = _ChartLocation(
                point.centerOpenPoint.x - textSize4.width, point.openPoint.y);
          else
            chartLocation4 = _ChartLocation(
                point.centerClosePoint.x + textSize4.width, point.closePoint.y);
        } else if (seriesRenderer._seriesType == 'candle' &&
            seriesRenderer._chart._requireInvertedAxis) {
          if (point.open > point.close) {
            chartLocation4 =
                _ChartLocation(point.openPoint.x, markerPoint3.y + 1);
          } else
            chartLocation4 =
                _ChartLocation(point.closePoint.x, markerPoint3.y + 1);
        } else {
          chartLocation4 =
              _ChartLocation(point.region.bottomCenter.dx, markerPoint3.y);
        }
        final List<_ChartLocation> alignedLabelLocations2 =
            _getAlignedLabelLocations(chart, seriesRenderer, point, dataLabel,
                chartLocation3, chartLocation4, textSize3);
        chartLocation3 = alignedLabelLocations2[0];
        chartLocation4 = alignedLabelLocations2[1];
        final List<_ChartLocation> _locations = _getLabelLocations(
            index,
            chart,
            seriesRenderer,
            point,
            dataLabel,
            chartLocation3,
            chartLocation4,
            textSize3,
            textSize4);
        chartLocation3 = _locations[0];
        chartLocation4 = _locations[1];
      }
      _calculateDataLabelRegion(
          point,
          dataLabel,
          chart,
          chartLocation,
          chartLocation2,
          isRangeSeries,
          clipRect,
          textSize,
          textSize2,
          chartLocation3,
          chartLocation4,
          textSize3,
          textSize4,
          seriesRenderer,
          index);
    }
  }
}

///Calculating the label location based on alignment value
List<_ChartLocation> _getAlignedLabelLocations(
    SfCartesianChart chart,
    CartesianSeriesRenderer seriesRenderer,
    CartesianChartPoint<dynamic> point,
    DataLabelSettings dataLabel,
    _ChartLocation chartLocation,
    _ChartLocation chartLocation2,
    Size textSize) {
  final XyDataSeries<dynamic, dynamic> series = seriesRenderer._series;
  final bool transposed = chart._requireInvertedAxis;
  final bool isRangeSeries = seriesRenderer._seriesType.contains('range') ||
      seriesRenderer._seriesType.contains('hilo') ||
      seriesRenderer._seriesType.contains('candle');
  final double alignmentValue = textSize.height +
      (series.markerSettings.isVisible
          ? ((series.markerSettings.borderWidth * 2) +
              series.markerSettings.height)
          : 0);
  if ((seriesRenderer._seriesType.contains('bar') && !chart.isTransposed) ||
      (seriesRenderer._seriesType.contains('column') && chart.isTransposed) ||
      seriesRenderer._seriesType.contains('hilo') ||
      seriesRenderer._seriesType.contains('candle')) {
    chartLocation.x = (dataLabel.labelAlignment == ChartDataLabelAlignment.auto)
        ? chartLocation.x
        : _calculateAlignment(
            alignmentValue,
            chartLocation.x,
            dataLabel.alignment,
            (isRangeSeries ? point.high : point.yValue) < 0,
            transposed);
    if (isRangeSeries) {
      chartLocation2.x =
          (dataLabel.labelAlignment == ChartDataLabelAlignment.auto)
              ? chartLocation2.x
              : _calculateAlignment(
                  alignmentValue,
                  chartLocation2.x,
                  dataLabel.alignment,
                  (isRangeSeries ? point.low : point.yValue) < 0,
                  transposed);
    }
  } else {
    chartLocation.y = (dataLabel.labelAlignment == ChartDataLabelAlignment.auto)
        ? chartLocation.y
        : _calculateAlignment(
            alignmentValue,
            chartLocation.y,
            dataLabel.alignment,
            (isRangeSeries ? point.high : point.yValue) < 0,
            transposed);
    if (isRangeSeries) {
      chartLocation2.y =
          (dataLabel.labelAlignment == ChartDataLabelAlignment.auto)
              ? chartLocation2.y
              : _calculateAlignment(
                  alignmentValue,
                  chartLocation2.y,
                  dataLabel.alignment,
                  (isRangeSeries ? point.low : point.yValue) < 0,
                  transposed);
    }
  }
  return <_ChartLocation>[chartLocation, chartLocation2];
}

///calculating the label loaction based on dataLabel position value
///(for range and rect series only)
List<_ChartLocation> _getLabelLocations(
    int index,
    SfCartesianChart chart,
    CartesianSeriesRenderer seriesRenderer,
    CartesianChartPoint<dynamic> point,
    DataLabelSettings dataLabel,
    _ChartLocation chartLocation,
    _ChartLocation chartLocation2,
    Size textSize,
    Size textSize2) {
  final bool transposed = chart._requireInvertedAxis;
  final EdgeInsets margin = dataLabel.margin;
  final bool isRangeSeries = seriesRenderer._seriesType.contains('range') ||
      seriesRenderer._seriesType.contains('hilo') ||
      seriesRenderer._seriesType.contains('candle');
  final bool inversed = seriesRenderer._yAxis.isInversed;
  final num value = isRangeSeries ? point.high : point.yValue;
  final bool minus = (value < 0 && !inversed) || (!(value < 0) && inversed);
  if (!chart._requireInvertedAxis) {
    chartLocation.y = _calculateRectPosition(
        chartLocation.y,
        point.region,
        minus,
        isRangeSeries
            ? ((dataLabel.labelAlignment == ChartDataLabelAlignment.outer ||
                    dataLabel.labelAlignment == ChartDataLabelAlignment.top)
                ? dataLabel.labelAlignment
                : ChartDataLabelAlignment.auto)
            : dataLabel.labelAlignment,
        seriesRenderer,
        textSize,
        dataLabel.borderWidth,
        index,
        chartLocation,
        chart,
        transposed,
        margin);
  } else {
    chartLocation.x = _calculateRectPosition(
        chartLocation.x,
        point.region,
        minus,
        seriesRenderer._seriesType.contains('hilo') ||
                seriesRenderer._seriesType.contains('candle')
            ? ChartDataLabelAlignment.auto
            : isRangeSeries
                ? ((dataLabel.labelAlignment == ChartDataLabelAlignment.outer ||
                        dataLabel.labelAlignment == ChartDataLabelAlignment.top)
                    ? dataLabel.labelAlignment
                    : ChartDataLabelAlignment.auto)
                : dataLabel.labelAlignment,
        seriesRenderer,
        textSize,
        dataLabel.borderWidth,
        index,
        chartLocation,
        chart,
        transposed,
        margin);
  }
  chartLocation2 = isRangeSeries
      ? _getSecondLabelLocation(index, chart, seriesRenderer, point, dataLabel,
          chartLocation, chartLocation2, textSize)
      : chartLocation2;
  return <_ChartLocation>[chartLocation, chartLocation2];
}

///Finding range series second label location
_ChartLocation _getSecondLabelLocation(
    int index,
    SfCartesianChart chart,
    CartesianSeriesRenderer seriesRenderer,
    CartesianChartPoint<dynamic> point,
    DataLabelSettings dataLabel,
    _ChartLocation chartLocation,
    _ChartLocation chartLocation2,
    Size textSize) {
  final bool inversed = seriesRenderer._yAxis.isInversed;
  final bool transposed = chart._requireInvertedAxis;
  final EdgeInsets margin = dataLabel.margin;
  final bool minus =
      (point.low < 0 && !inversed) || (!(point.low < 0) && inversed);
  if (!chart._requireInvertedAxis) {
    chartLocation2.y = _calculateRectPosition(
        chartLocation2.y,
        point.region,
        minus,
        dataLabel.labelAlignment == ChartDataLabelAlignment.top
            ? ChartDataLabelAlignment.auto
            : ChartDataLabelAlignment.top,
        seriesRenderer,
        textSize,
        dataLabel.borderWidth,
        index,
        chartLocation,
        chart,
        transposed,
        margin);
  } else {
    chartLocation2.x = _calculateRectPosition(
        chartLocation2.x,
        point.region,
        minus,
        dataLabel.labelAlignment == ChartDataLabelAlignment.top
            ? ChartDataLabelAlignment.auto
            : ChartDataLabelAlignment.top,
        seriesRenderer,
        textSize,
        dataLabel.borderWidth,
        index,
        chartLocation,
        chart,
        transposed,
        margin);
  }
  return chartLocation2;
}

///Setting datalabel region
void _calculateDataLabelRegion(
    CartesianChartPoint<dynamic> point,
    DataLabelSettings dataLabel,
    SfCartesianChart chart,
    _ChartLocation chartLocation,
    _ChartLocation chartLocation2,
    bool isRangeSeries,
    Rect clipRect,
    Size textSize,
    Size textSize2,
    _ChartLocation chartLocation3,
    _ChartLocation chartLocation4,
    Size textSize3,
    Size textSize4,
    CartesianSeriesRenderer seriesRenderer,
    int index) {
  Rect rect, rect2, rect3, rect4;
  final EdgeInsets margin = dataLabel.margin;
  rect = _calculateLabelRect(chartLocation, textSize, margin,
      dataLabel._color != null || dataLabel.useSeriesColor);
  // if angle is given label will
  rect = ((index == 0 || index == seriesRenderer._dataPoints.length - 1) &&
          (dataLabel.angle / 90) % 2 == 1 &&
          !chart._requireInvertedAxis)
      ? rect
      : _validateRect(rect, clipRect);
  if (isRangeSeries) {
    rect2 = _calculateLabelRect(chartLocation2, textSize2, margin,
        dataLabel._color != null || dataLabel.useSeriesColor);
    rect2 = _validateRect(rect2, clipRect);
  }
  if (seriesRenderer._seriesType.contains('candle') ||
      seriesRenderer._seriesType.contains('hilo') &&
          (chartLocation3 != null || chartLocation4 != null)) {
    rect3 = _calculateLabelRect(chartLocation3, textSize3, margin,
        dataLabel._color != null || dataLabel.useSeriesColor);
    rect3 = _validateRect(rect3, clipRect);

    rect4 = _calculateLabelRect(chartLocation4, textSize4, margin,
        dataLabel._color != null || dataLabel.useSeriesColor);
    rect4 = _validateRect(rect4, clipRect);
  }
  if (dataLabel._color != null ||
      dataLabel.useSeriesColor ||
      (dataLabel.borderColor != null && dataLabel.borderWidth > 0)) {
    final RRect fillRect =
        _calculatePaddedFillRect(rect, dataLabel.borderRadius, margin);
    point.labelLocation = _ChartLocation(
        fillRect.center.dx - textSize.width / 2,
        fillRect.center.dy - textSize.height / 2);
    point.dataLabelRegion = Rect.fromLTWH(point.labelLocation.x,
        point.labelLocation.y, textSize.width, textSize.height);
    if (margin == const EdgeInsets.all(0)) {
      point.labelFillRect = fillRect;
    } else {
      final Rect rect = fillRect.middleRect;
      if (seriesRenderer._seriesType == 'candle' &&
          chart._requireInvertedAxis &&
          point.close > point.high) {
        point.labelLocation = _ChartLocation(
            rect.left - rect.width - textSize.width,
            rect.top + rect.height / 2 - textSize.height / 2);
      } else if (seriesRenderer._seriesType == 'candle' &&
          !chart._requireInvertedAxis &&
          point.close > point.high) {
        point.labelLocation = _ChartLocation(
            rect.left + rect.width / 2 - textSize.width / 2,
            rect.top + rect.height + textSize.height);
      } else {
        point.labelLocation = _ChartLocation(
            rect.left + rect.width / 2 - textSize.width / 2,
            rect.top + rect.height / 2 - textSize.height / 2);
      }
      point.dataLabelRegion = Rect.fromLTWH(point.labelLocation.x,
          point.labelLocation.y, textSize.width, textSize.height);
      point.labelFillRect = _rectToRrect(rect, dataLabel.borderRadius);
    }
    if (isRangeSeries) {
      final RRect fillRect2 =
          _calculatePaddedFillRect(rect2, dataLabel.borderRadius, margin);
      point.labelLocation2 = _ChartLocation(
          fillRect2.center.dx - textSize2.width / 2,
          fillRect2.center.dy - textSize2.height / 2);
      point.dataLabelRegion2 = Rect.fromLTWH(point.labelLocation2.x,
          point.labelLocation2.y, textSize2.width, textSize2.height);
      if (margin == const EdgeInsets.all(0)) {
        point.labelFillRect2 = fillRect2;
      } else {
        final Rect rect2 = fillRect2.middleRect;
        point.labelLocation2 = _ChartLocation(
            rect2.left + rect2.width / 2 - textSize2.width / 2,
            rect2.top + rect2.height / 2 - textSize2.height / 2);
        point.dataLabelRegion2 = Rect.fromLTWH(point.labelLocation2.x,
            point.labelLocation2.y, textSize2.width, textSize2.height);
        point.labelFillRect2 = _rectToRrect(rect2, dataLabel.borderRadius);
      }
    }
    if (seriesRenderer._seriesType.contains('candle') ||
        seriesRenderer._seriesType.contains('hilo') &&
            (rect3 != null || rect4 != null)) {
      final RRect fillRect3 =
          _calculatePaddedFillRect(rect3, dataLabel.borderRadius, margin);
      point.labelLocation3 = _ChartLocation(
          fillRect3.center.dx - textSize3.width / 2,
          fillRect3.center.dy - textSize3.height / 2);
      point.dataLabelRegion3 = Rect.fromLTWH(point.labelLocation3.x,
          point.labelLocation3.y, textSize3.width, textSize3.height);
      if (margin == const EdgeInsets.all(0)) {
        point.labelFillRect3 = fillRect3;
      } else {
        final Rect rect3 = fillRect3.middleRect;
        point.labelLocation3 = _ChartLocation(
            rect3.left + rect3.width / 2 - textSize3.width / 2,
            rect3.top + rect3.height / 2 - textSize3.height / 2);
        point.dataLabelRegion3 = Rect.fromLTWH(point.labelLocation3.x,
            point.labelLocation3.y, textSize3.width, textSize3.height);
        point.labelFillRect3 = _rectToRrect(rect3, dataLabel.borderRadius);
      }
      final RRect fillRect4 =
          _calculatePaddedFillRect(rect4, dataLabel.borderRadius, margin);
      point.labelLocation4 = _ChartLocation(
          fillRect4.center.dx - textSize4.width / 2,
          fillRect4.center.dy - textSize4.height / 2);
      point.dataLabelRegion4 = Rect.fromLTWH(point.labelLocation4.x,
          point.labelLocation4.y, textSize4.width, textSize4.height);
      if (margin == const EdgeInsets.all(0)) {
        point.labelFillRect4 = fillRect4;
      } else {
        final Rect rect4 = fillRect4.middleRect;
        point.labelLocation4 = _ChartLocation(
            rect4.left + rect4.width / 2 - textSize4.width / 2,
            rect4.top + rect4.height / 2 - textSize4.height / 2);
        point.dataLabelRegion4 = Rect.fromLTWH(point.labelLocation4.x,
            point.labelLocation4.y, textSize4.width, textSize4.height);
        point.labelFillRect4 = _rectToRrect(rect4, dataLabel.borderRadius);
      }
    }
  } else {
    if (seriesRenderer._seriesType == 'candle' &&
        chart._requireInvertedAxis &&
        point.close > point.high) {
      point.labelLocation = _ChartLocation(
          rect.left - rect.width - textSize.width - 2,
          rect.top + rect.height / 2 - textSize.height / 2);
    } else if (seriesRenderer._seriesType == 'candle' &&
        !chart._requireInvertedAxis &&
        point.close > point.high) {
      point.labelLocation = _ChartLocation(
          rect.left + rect.width / 2 - textSize.width / 2,
          rect.top + rect.height + textSize.height / 2);
    } else {
      point.labelLocation = _ChartLocation(
          rect.left + rect.width / 2 - textSize.width / 2,
          rect.top + rect.height / 2 - textSize.height / 2);
    }
    point.dataLabelRegion = Rect.fromLTWH(point.labelLocation.x,
        point.labelLocation.y, textSize.width, textSize.height);
    if (isRangeSeries) {
      if (seriesRenderer._seriesType == 'candle' &&
          chart._requireInvertedAxis &&
          point.close > point.high) {
        point.labelLocation2 = _ChartLocation(
            rect2.left + rect2.width + textSize2.width + 2,
            rect2.top + rect2.height / 2 - textSize2.height / 2);
      } else if (seriesRenderer._seriesType == 'candle' &&
          !chart._requireInvertedAxis &&
          point.close > point.high) {
        point.labelLocation2 = _ChartLocation(
            rect2.left + rect2.width / 2 - textSize2.width / 2,
            rect2.top - rect2.height - textSize2.height);
      } else {
        point.labelLocation2 = _ChartLocation(
            rect2.left + rect2.width / 2 - textSize2.width / 2,
            rect2.top + rect2.height / 2 - textSize2.height / 2);
      }
      point.dataLabelRegion2 = Rect.fromLTWH(point.labelLocation2.x,
          point.labelLocation2.y, textSize2.width, textSize2.height);
    }
    if (seriesRenderer._seriesType.contains('candle') ||
        seriesRenderer._seriesType.contains('hilo') &&
            (rect3 != null || rect4 != null)) {
      point.labelLocation3 = _ChartLocation(
          rect3.left + rect3.width / 2 - textSize3.width / 2,
          rect3.top + rect3.height / 2 - textSize3.height / 2);
      point.dataLabelRegion3 = Rect.fromLTWH(point.labelLocation3.x,
          point.labelLocation3.y, textSize3.width, textSize3.height);
      point.labelLocation4 = _ChartLocation(
          rect4.left + rect4.width / 2 - textSize4.width / 2,
          rect4.top + rect4.height / 2 - textSize4.height / 2);
      point.dataLabelRegion4 = Rect.fromLTWH(point.labelLocation4.x,
          point.labelLocation4.y, textSize4.width, textSize4.height);
    }
  }
}

/// To find the position of a series to render
double _calculatePathPosition(
    double labelLocation,
    ChartDataLabelAlignment position,
    Size size,
    double borderWidth,
    CartesianSeriesRenderer seriesRenderer,
    int index,
    bool inverted,
    _ChartLocation point,
    SfCartesianChart chart,
    CartesianChartPoint<dynamic> currentPoint,
    Size markerSize) {
  final XyDataSeries<dynamic, dynamic> series = seriesRenderer._series;
  const double padding = 5;
  final bool needFill = series.dataLabelSettings.color != null ||
      series.dataLabelSettings.color != Colors.transparent ||
      series.dataLabelSettings.useSeriesColor;
  final num fillSpace = needFill ? padding : 0;
  if (seriesRenderer._seriesType.contains('area') &&
      !seriesRenderer._seriesType.contains('rangearea') &&
      seriesRenderer._yAxis.isInversed) {
    position = position == ChartDataLabelAlignment.top
        ? ChartDataLabelAlignment.bottom
        : (position == ChartDataLabelAlignment.bottom
            ? ChartDataLabelAlignment.top
            : position);
  }
  position = (chart._chartSeries.visibleSeriesRenderers.length == 1 &&
          (seriesRenderer._seriesType == 'stackedarea100' ||
              seriesRenderer._seriesType == 'stackedline100') &&
          position == ChartDataLabelAlignment.auto)
      ? ChartDataLabelAlignment.bottom
      : position;
  switch (position) {
    case ChartDataLabelAlignment.top:
    case ChartDataLabelAlignment.outer:
      labelLocation = labelLocation -
          markerSize.height -
          borderWidth -
          (size.height / 2) -
          padding -
          fillSpace;
      break;
    case ChartDataLabelAlignment.bottom:
      labelLocation = labelLocation +
          markerSize.height +
          borderWidth +
          (size.height / 2) +
          padding +
          fillSpace;
      break;
    case ChartDataLabelAlignment.auto:
      labelLocation = _calculatePathActualPosition(
          seriesRenderer,
          size,
          index,
          inverted,
          borderWidth,
          point,
          chart,
          currentPoint,
          seriesRenderer._yAxis.isInversed);
      break;
    case ChartDataLabelAlignment.middle:
      break;
  }
  return labelLocation;
}

///Below method is for dataLabel alignment calculation
double _calculateAlignment(double value, double labelLocation,
    ChartAlignment alignment, bool isMinus, bool inverted) {
  switch (alignment) {
    case ChartAlignment.far:
      labelLocation = !inverted
          ? (isMinus ? labelLocation + value : labelLocation - value)
          : (isMinus ? labelLocation - value : labelLocation + value);
      break;
    case ChartAlignment.near:
      labelLocation = !inverted
          ? (isMinus ? labelLocation - value : labelLocation + value)
          : (isMinus ? labelLocation + value : labelLocation - value);
      break;
    case ChartAlignment.center:
      labelLocation = labelLocation;
      break;
  }
  return labelLocation;
}

///Calculate label position for non rect series
double _calculatePathActualPosition(
    CartesianSeriesRenderer seriesRenderer,
    Size size,
    int index,
    bool inverted,
    double borderWidth,
    _ChartLocation point,
    SfCartesianChart chart,
    CartesianChartPoint<dynamic> currentPoint,
    bool inversed) {
  final XyDataSeries<dynamic, dynamic> series = seriesRenderer._series;
  double yLocation;
  bool isBottom, isOverLap = true;
  Rect labelRect;
  int positionIndex;
  final ChartDataLabelAlignment position =
      _getActualPathDataLabelAlignment(seriesRenderer, index, inversed);
  isBottom = position == ChartDataLabelAlignment.bottom;
  final List<String> dataLabelPosition = List<String>(5);
  dataLabelPosition[0] = 'DataLabelPosition.Outer';
  dataLabelPosition[1] = 'DataLabelPosition.Top';
  dataLabelPosition[2] = 'DataLabelPosition.Bottom';
  dataLabelPosition[3] = 'DataLabelPosition.Middle';
  dataLabelPosition[4] = 'DataLabelPosition.Auto';
  positionIndex = dataLabelPosition.indexOf(position.toString()).toInt();
  while (isOverLap && positionIndex < 4) {
    yLocation = _calculatePathPosition(
        point.y.toDouble(),
        position,
        size,
        borderWidth,
        seriesRenderer,
        index,
        inverted,
        point,
        chart,
        currentPoint,
        Size(
            series.markerSettings.width / 2, series.markerSettings.height / 2));
    labelRect = _calculateLabelRect(
        _ChartLocation(point.x, yLocation),
        size,
        series.dataLabelSettings.margin,
        series.dataLabelSettings.color != null ||
            series.dataLabelSettings.useSeriesColor);
    isOverLap = labelRect.top < 0 ||
        ((labelRect.top + labelRect.height) >
            chart._chartAxis._axisClipRect.height) ||
        _isCollide(labelRect, chart._chartState.renderDatalabelRegions);
    positionIndex = isBottom ? positionIndex - 1 : positionIndex + 1;
    isBottom = false;
  }
  return yLocation;
}

/// Finding the label position for non rect series
ChartDataLabelAlignment _getActualPathDataLabelAlignment(
    CartesianSeriesRenderer seriesRenderer, int index, bool inversed) {
  final List<CartesianChartPoint<dynamic>> points = seriesRenderer._dataPoints;
  final num yValue = points[index].yValue;
  final CartesianChartPoint<dynamic> _nextPoint =
      points.length - 1 > index ? points[index + 1] : null;
  final CartesianChartPoint<dynamic> previousPoint =
      index > 0 ? points[index - 1] : null;
  ChartDataLabelAlignment position;
  if (seriesRenderer._seriesType == 'bubble' || index == points.length - 1) {
    position = ChartDataLabelAlignment.top;
  } else {
    if (index == 0) {
      position = (!_nextPoint.isVisible ||
              yValue > _nextPoint.yValue ||
              (yValue < _nextPoint.yValue && inversed))
          ? ChartDataLabelAlignment.top
          : ChartDataLabelAlignment.bottom;
    } else if (index == points.length - 1) {
      position = (!previousPoint.isVisible ||
              yValue > previousPoint.yValue ||
              (yValue < previousPoint.yValue && inversed))
          ? ChartDataLabelAlignment.top
          : ChartDataLabelAlignment.bottom;
    } else {
      if (!_nextPoint.isVisible && !previousPoint.isVisible) {
        position = ChartDataLabelAlignment.top;
      } else if (!_nextPoint.isVisible) {
        position = (_nextPoint.yValue > yValue || previousPoint.yValue > yValue)
            ? ChartDataLabelAlignment.bottom
            : ChartDataLabelAlignment.top;
      } else {
        final num slope = (_nextPoint.yValue - previousPoint.yValue) / 2;
        final num intersectY =
            (slope * index) + (_nextPoint.yValue - (slope * (index + 1)));
        position = !inversed
            ? intersectY < yValue
                ? ChartDataLabelAlignment.top
                : ChartDataLabelAlignment.bottom
            : intersectY < yValue
                ? ChartDataLabelAlignment.bottom
                : ChartDataLabelAlignment.top;
      }
    }
  }
  return position;
}

/// To get the data label position
ChartDataLabelAlignment _getPosition(int position) {
  ChartDataLabelAlignment dataLabelPosition;
  switch (position) {
    case 0:
      dataLabelPosition = ChartDataLabelAlignment.outer;
      break;
    case 1:
      dataLabelPosition = ChartDataLabelAlignment.top;
      break;
    case 2:
      dataLabelPosition = ChartDataLabelAlignment.bottom;
      break;
    case 3:
      dataLabelPosition = ChartDataLabelAlignment.middle;
      break;
    case 4:
      dataLabelPosition = ChartDataLabelAlignment.auto;
      break;
  }
  return dataLabelPosition;
}

/// getting label rect
Rect _calculateLabelRect(
    _ChartLocation location, Size textSize, EdgeInsets margin, bool needRect) {
  return needRect
      ? Rect.fromLTWH(
          location.x - (textSize.width / 2) - margin.left,
          location.y - (textSize.height / 2) - margin.top,
          textSize.width + margin.left + margin.right,
          textSize.height + margin.top + margin.bottom)
      : Rect.fromLTWH(location.x - (textSize.width / 2),
          location.y - (textSize.height / 2), textSize.width, textSize.height);
}

/// Below method is for Rendering data label
void _drawDataLabel(
    Canvas canvas,
    CartesianSeriesRenderer seriesRenderer,
    SfCartesianChart chart,
    DataLabelSettings dataLabel,
    CartesianChartPoint<dynamic> point,
    int index,
    Animation<double> dataLabelAnimation) {
  final double opacity =
      dataLabelAnimation != null ? dataLabelAnimation.value : 1;
  TextStyle dataLabelStyle;
  final String label = point.label;
  dataLabelStyle = dataLabel._textStyle;
  if (label != null &&
      point != null &&
      point.isVisible &&
      point.isGap != true &&
      _isLabelWithinRange(seriesRenderer, point)) {
    final TextStyle font = (dataLabelStyle == null)
        ? const TextStyle(
            fontFamily: 'Roboto',
            fontStyle: FontStyle.normal,
            fontWeight: FontWeight.normal,
            fontSize: 12)
        : dataLabelStyle;
    final Color fontColor = font.color != null
        ? font.color
        : _getDataLabelSaturationColor(point, seriesRenderer, chart);
    final Rect labelRect = (point.labelFillRect != null)
        ? Rect.fromLTWH(point.labelFillRect.left, point.labelFillRect.top,
            point.labelFillRect.width, point.labelFillRect.height)
        : Rect.fromLTWH(point.labelLocation.x, point.labelLocation.y,
            point.dataLabelRegion.width, point.dataLabelRegion.height);
    final bool isDatalabelCollide =
        (chart._requireInvertedAxis || (dataLabel.angle / 90) % 2 != 1) &&
            _isCollide(labelRect, chart._chartState.renderDatalabelRegions);
    if (label.isNotEmpty && isDatalabelCollide
        ? dataLabel.labelIntersectAction == null
        : true) {
      final TextStyle _textStyle = TextStyle(
          color: fontColor.withOpacity(opacity),
          fontSize: font.fontSize,
          fontFamily: font.fontFamily,
          fontStyle: font.fontStyle,
          fontWeight: font.fontWeight,
          inherit: font.inherit,
          backgroundColor: font.backgroundColor,
          letterSpacing: font.letterSpacing,
          wordSpacing: font.wordSpacing,
          textBaseline: font.textBaseline,
          height: font.height,
          locale: font.locale,
          foreground: font.foreground,
          background: font.background,
          shadows: font.shadows,
          fontFeatures: font.fontFeatures,
          decoration: font.decoration,
          decorationColor: font.decorationColor,
          decorationStyle: font.decorationStyle,
          decorationThickness: font.decorationThickness,
          debugLabel: font.debugLabel,
          fontFamilyFallback: font.fontFamilyFallback);
      _drawDataLabelPath(canvas, seriesRenderer, index, dataLabel, point,
          _textStyle, opacity, label, chart);
      chart._chartState.renderDatalabelRegions.add(labelRect);
    }
  }
}

///Draw the datalabel text and datalabel rect
void _drawDataLabelPath(
    Canvas canvas,
    CartesianSeriesRenderer seriesRenderer,
    int index,
    DataLabelSettings dataLabel,
    CartesianChartPoint<dynamic> point,
    TextStyle _textStyle,
    double opacity,
    String label,
    [SfCartesianChart chart]) {
  final String label2 = point.dataLabelMapper ?? point.label2;
  final String label3 = point.dataLabelMapper ?? point.label3;
  final String label4 = point.dataLabelMapper ?? point.label4;
  final bool isRangeSeries = seriesRenderer._seriesType.contains('range') ||
      seriesRenderer._seriesType.contains('hilo') ||
      seriesRenderer._seriesType.contains('candle');
  double padding = 0.0;
  if (dataLabel.angle != null && dataLabel.angle > 0) {
    final Rect rect = _rotatedTextSize(
        Size(point.dataLabelRegion.width, point.dataLabelRegion.height),
        dataLabel.angle);
    if (chart._chartAxis._axisClipRect.top >
        point.dataLabelRegion.center.dy + rect.top) {
      padding = rect.top;
    } else if (chart._chartAxis._axisClipRect.bottom <
        point.dataLabelRegion.center.dy + rect.bottom) {
      padding = rect.bottom;
    }
  }
  if (dataLabel._color != null ||
      dataLabel.useSeriesColor ||
      (dataLabel.borderColor != null && dataLabel.borderWidth > 0)) {
    final RRect fillRect = point.labelFillRect;
    final Path path = Path();
    path.addRRect(fillRect);
    final RRect fillRect2 = point.labelFillRect2;
    final Path path2 = Path();
    if (isRangeSeries) {
      path2.addRRect(fillRect2);
    }
    final RRect fillRect3 = point.labelFillRect3;
    final Path path3 = Path();
    final RRect fillRect4 = point.labelFillRect4;
    final Path path4 = Path();
    if (seriesRenderer._seriesType.contains('hilo') ||
        seriesRenderer._seriesType.contains('candle')) {
      path3.addRRect(fillRect3);
      path4.addRRect(fillRect4);
    }
    if (dataLabel.borderColor != null && dataLabel.borderWidth > 0) {
      final Paint strokePaint = Paint()
        ..color = dataLabel.borderColor.withOpacity(
            (opacity - (1 - dataLabel.opacity)) < 0
                ? 0
                : opacity - (1 - dataLabel.opacity))
        ..strokeWidth = dataLabel.borderWidth
        ..style = PaintingStyle.stroke;
      dataLabel.borderWidth == 0
          ? strokePaint.color = Colors.transparent
          : strokePaint.color = strokePaint.color;
      canvas.save();
      canvas.translate(point.dataLabelRegion.center.dx,
          point.dataLabelRegion.center.dy - padding);
      if (dataLabel.angle != null && dataLabel.angle > 0) {
        canvas.rotate((dataLabel.angle * math.pi) / 180);
      }
      canvas.translate(
          -point.dataLabelRegion.center.dx, -point.dataLabelRegion.center.dy);
      canvas.drawPath(path, strokePaint);
      canvas.restore();
      if (isRangeSeries) {
        canvas.drawPath(path2, strokePaint);
      }
    }
    if (dataLabel._color != null || dataLabel.useSeriesColor) {
      final Paint paint = Paint()
        ..color = (dataLabel._color ??
                (point.pointColorMapper ?? seriesRenderer._seriesColor))
            .withOpacity((opacity - (1 - dataLabel.opacity)) < 0
                ? 0
                : opacity - (1 - dataLabel.opacity))
        ..style = PaintingStyle.fill;
      canvas.save();
      canvas.translate(point.dataLabelRegion.center.dx,
          point.dataLabelRegion.center.dy - padding);
      if (dataLabel.angle != null && dataLabel.angle > 0) {
        canvas.rotate((dataLabel.angle * math.pi) / 180);
      }
      canvas.translate(
          -point.dataLabelRegion.center.dx, -point.dataLabelRegion.center.dy);
      canvas.drawPath(path, paint);
      canvas.restore();
      if (isRangeSeries) {
        canvas.drawPath(path2, paint);
      }
    }
  }

  seriesRenderer.drawDataLabel(
      index,
      canvas,
      label,
      dataLabel.angle != 0
          ? point.dataLabelRegion.center.dx
          : point.labelLocation.x,
      dataLabel.angle != 0
          ? point.dataLabelRegion.center.dy - padding
          : point.labelLocation.y,
      dataLabel.angle,
      _textStyle);

  if (isRangeSeries) {
    seriesRenderer.drawDataLabel(index, canvas, label2, point.labelLocation2.x,
        point.labelLocation2.y, dataLabel.angle, _textStyle);
    if (_withIn(point.low, seriesRenderer._yAxis._visibleRange))
      seriesRenderer.drawDataLabel(
          index,
          canvas,
          label2,
          point.labelLocation2.x,
          point.labelLocation2.y,
          dataLabel.angle,
          _textStyle);
    if (seriesRenderer._seriesType == 'hiloopenclose' &&
        (label3 != null &&
                label4 != null &&
                (point.labelLocation3.y - point.labelLocation4.y).round() >=
                    8 ||
            (point.labelLocation4.x - point.labelLocation3.x).round() >= 15)) {
      seriesRenderer.drawDataLabel(
          index,
          canvas,
          label3,
          point.labelLocation3.x,
          point.labelLocation3.y,
          dataLabel.angle,
          _textStyle);
      seriesRenderer.drawDataLabel(
          index,
          canvas,
          label4,
          point.labelLocation4.x,
          point.labelLocation3.y,
          dataLabel.angle,
          _textStyle);
    } else if (label3 != null &&
        label4 != null &&
        ((point.labelLocation3.y - point.labelLocation4.y).round() >= 8 ||
            (point.labelLocation4.x - point.labelLocation3.x).round() >= 15)) {
      final Color fontColor =
          _getOpenCloseDataLabelColor(point, seriesRenderer, chart);
      final TextStyle _textStyleOpenClose = TextStyle(
          color: fontColor.withOpacity(opacity),
          fontSize: _textStyle.fontSize,
          fontFamily: _textStyle.fontFamily,
          fontStyle: _textStyle.fontStyle,
          fontWeight: _textStyle.fontWeight,
          inherit: _textStyle.inherit,
          backgroundColor: _textStyle.backgroundColor,
          letterSpacing: _textStyle.letterSpacing,
          wordSpacing: _textStyle.wordSpacing,
          textBaseline: _textStyle.textBaseline,
          height: _textStyle.height,
          locale: _textStyle.locale,
          foreground: _textStyle.foreground,
          background: _textStyle.background,
          shadows: _textStyle.shadows,
          fontFeatures: _textStyle.fontFeatures,
          decoration: _textStyle.decoration,
          decorationColor: _textStyle.decorationColor,
          decorationStyle: _textStyle.decorationStyle,
          decorationThickness: _textStyle.decorationThickness,
          debugLabel: _textStyle.debugLabel,
          fontFamilyFallback: _textStyle.fontFamilyFallback);
      if ((point.labelLocation2.y - point.labelLocation3.y).abs() >= 8 ||
          (point.labelLocation2.x - point.labelLocation3.x).abs() >= 8) {
        seriesRenderer.drawDataLabel(
            index,
            canvas,
            label3,
            point.labelLocation3.x,
            point.labelLocation3.y,
            dataLabel.angle,
            _textStyleOpenClose);
      }
      if ((point.labelLocation.y - point.labelLocation4.y).abs() >= 8 ||
          (point.labelLocation.x - point.labelLocation4.x).abs() >= 8) {
        seriesRenderer.drawDataLabel(
            index,
            canvas,
            label4,
            point.labelLocation4.x,
            point.labelLocation4.y,
            dataLabel.angle,
            _textStyleOpenClose);
      }
    }
  }
}

/// Following method returns the data label text
String _getLabelText(dynamic labelValue, CartesianSeriesRenderer seriesRenderer,
    SfCartesianChart chart) {
  if (labelValue.toString().split('.').length > 1) {
    final String str = labelValue.toString();
    final List<dynamic> list = str.split('.');
    labelValue = double.parse(labelValue.toStringAsFixed(6));
    if (list[1] == '0' ||
        list[1] == '00' ||
        list[1] == '000' ||
        list[1] == '0000' ||
        list[1] == '00000' ||
        list[1] == '000000') {
      labelValue = labelValue.round();
    }
  }
  final dynamic yAxis = seriesRenderer._yAxis;
  if (yAxis is NumericAxis || yAxis is LogarithmicAxis) {
    final dynamic value = yAxis?.numberFormat != null
        ? yAxis.numberFormat.format(labelValue)
        : labelValue;
    return (yAxis.labelFormat != null && yAxis.labelFormat != '')
        ? yAxis.labelFormat.replaceAll(RegExp('{value}'), value.toString())
        : value.toString();
  } else {
    final dynamic value = labelValue;
    return value.toString();
  }
}

/// Calculating rect position for dataLabel
double _calculateRectPosition(
    double labelLocation,
    Rect rect,
    bool isMinus,
    ChartDataLabelAlignment position,
    CartesianSeriesRenderer seriesRenderer,
    Size textSize,
    double borderWidth,
    int index,
    _ChartLocation point,
    SfCartesianChart chart,
    bool inverted,
    EdgeInsets margin) {
  final XyDataSeries<dynamic, dynamic> series = seriesRenderer._series;
  double padding;
  padding = seriesRenderer._seriesType.contains('hilo') ||
          seriesRenderer._seriesType.contains('candle') ||
          seriesRenderer._seriesType.contains('rangecolumn')
      ? 2
      : 5;
  final bool needFill = series.dataLabelSettings.color != null ||
      series.dataLabelSettings.color != Colors.transparent ||
      series.dataLabelSettings.useSeriesColor;
  final double textLength = !inverted ? textSize.height : textSize.width;
  final double extraSpace =
      borderWidth + textLength / 2 + padding + (needFill ? padding : 0);
  if (seriesRenderer._seriesType.contains('stack')) {
    position = position == ChartDataLabelAlignment.outer
        ? ChartDataLabelAlignment.top
        : position;
  }

  /// Locating the data label based on position
  switch (position) {
    case ChartDataLabelAlignment.bottom:
      labelLocation = !inverted
          ? (isMinus
              ? (labelLocation - rect.height + extraSpace)
              : (labelLocation + rect.height - extraSpace))
          : (isMinus
              ? (labelLocation + rect.width - extraSpace)
              : (labelLocation - rect.width + extraSpace));
      break;
    case ChartDataLabelAlignment.middle:
      labelLocation = !inverted
          ? (isMinus
              ? labelLocation - (rect.height / 2)
              : labelLocation + (rect.height / 2))
          : (isMinus
              ? labelLocation + (rect.width / 2)
              : labelLocation - (rect.width / 2));
      break;
    case ChartDataLabelAlignment.auto:
      labelLocation = _calculateRectActualPosition(
          labelLocation,
          rect,
          isMinus,
          seriesRenderer,
          textSize,
          index,
          point,
          inverted,
          borderWidth,
          chart,
          margin);
      break;
    default:
      labelLocation = _calculateTopAndOuterPosition(
          textSize,
          labelLocation,
          rect,
          position,
          seriesRenderer,
          index,
          extraSpace,
          isMinus,
          point,
          inverted,
          borderWidth,
          chart);
      break;
  }
  return labelLocation;
}

/// Calculating the label location if position is given as auto
double _calculateRectActualPosition(
    double labelLocation,
    Rect rect,
    bool minus,
    CartesianSeriesRenderer seriesRenderer,
    Size textSize,
    int index,
    _ChartLocation point,
    bool inverted,
    double borderWidth,
    SfCartesianChart chart,
    EdgeInsets margin) {
  double location;
  Rect labelRect;
  bool isOverLap = true;
  int position = 0;
  final XyDataSeries<dynamic, dynamic> series = seriesRenderer._series;
  final int finalPosition =
      seriesRenderer._seriesType.contains('range') ? 2 : 4;
  while (isOverLap && position < finalPosition) {
    location = _calculateRectPosition(
        labelLocation,
        rect,
        minus,
        _getPosition(position),
        seriesRenderer,
        textSize,
        borderWidth,
        index,
        point,
        chart,
        inverted,
        margin);
    if (!inverted) {
      labelRect = _calculateLabelRect(
          _ChartLocation(point.x, location),
          textSize,
          margin,
          series.dataLabelSettings.color != null ||
              series.dataLabelSettings.useSeriesColor);
      isOverLap = labelRect.top < 0 ||
          labelRect.top > chart._chartAxis._axisClipRect.height ||
          ((series.dataLabelSettings.angle / 90) % 2 != 1 &&
              _isCollide(labelRect, chart._chartState.renderDatalabelRegions));
    } else {
      labelRect = _calculateLabelRect(
          _ChartLocation(location, point.y),
          textSize,
          margin,
          series.dataLabelSettings.color != null ||
              series.dataLabelSettings.useSeriesColor);
      isOverLap = labelRect.left < 0 ||
          labelRect.left + labelRect.width >
              chart._chartAxis._axisClipRect.right ||
          (series.dataLabelSettings.angle % 180 != 0 &&
              _isCollide(labelRect, chart._chartState.renderDatalabelRegions));
    }
    seriesRenderer
        ._dataPoints[index].dataLabelSaturationRegionInside = isOverLap ||
            seriesRenderer._dataPoints[index].dataLabelSaturationRegionInside
        ? true
        : false;
    position++;
  }
  return location;
}

///calculation for top and outer position of datalabel for rect series
double _calculateTopAndOuterPosition(
    Size textSize,
    double location,
    Rect rect,
    ChartDataLabelAlignment position,
    CartesianSeriesRenderer seriesRenderer,
    int index,
    double extraSpace,
    bool isMinus,
    _ChartLocation point,
    bool inverted,
    double borderWidth,
    SfCartesianChart chart) {
  final XyDataSeries<dynamic, dynamic> series = seriesRenderer._series;
  final num markerHeight =
      series.markerSettings.isVisible ? series.markerSettings.height / 2 : 0;
  if (((isMinus && !seriesRenderer._seriesType.contains('range')) &&
          position == ChartDataLabelAlignment.top) ||
      ((!isMinus || seriesRenderer._seriesType.contains('range')) &&
          position == ChartDataLabelAlignment.outer)) {
    location = !inverted
        ? location - extraSpace - markerHeight
        : location + extraSpace + markerHeight;
  } else {
    location = !inverted
        ? location + extraSpace + markerHeight
        : location - extraSpace - markerHeight;
  }
  return location;
}

/// Add padding for fill rect (if datalabel fill color is given)
RRect _calculatePaddedFillRect(Rect rect, num radius, EdgeInsets margin) {
  rect = Rect.fromLTRB(rect.left - margin.left, rect.top - margin.top,
      rect.right + margin.right, rect.bottom + margin.bottom);

  return _rectToRrect(rect, radius);
}

/// Converting rect into rounded rect
RRect _rectToRrect(Rect rect, num radius) => RRect.fromRectAndCorners(rect,
    topLeft: Radius.elliptical(radius, radius),
    topRight: Radius.elliptical(radius, radius),
    bottomLeft: Radius.elliptical(radius, radius),
    bottomRight: Radius.elliptical(radius, radius));

/// Checking the condition whether data Label has been exist in the clip rect
Rect _validateRect(Rect rect, Rect clipRect) {
  /// please don't add padding here
  num left, top;
  left = rect.left < clipRect.left ? clipRect.left : rect.left;
  top = double.parse(rect.top.toStringAsFixed(2)) < clipRect.top
      ? clipRect.top
      : rect.top;
  left -= ((double.parse(left.toStringAsFixed(2)) + rect.width) >
          clipRect.right)
      ? (double.parse(left.toStringAsFixed(2)) + rect.width) - clipRect.right
      : 0;
  top -= (double.parse(top.toStringAsFixed(2)) + rect.height) > clipRect.bottom
      ? (double.parse(top.toStringAsFixed(2)) + rect.height) - clipRect.bottom
      : 0;
  left = left < clipRect.left ? clipRect.left : left;
  rect = Rect.fromLTWH(left, top, rect.width, rect.height);
  return rect;
}

/// It returns a boolean value that labels within range or not
bool _isLabelWithinRange(CartesianSeriesRenderer seriesRenderer,
    CartesianChartPoint<dynamic> point) {
  bool withInRange = true;
  if (!(seriesRenderer._yAxis is LogarithmicAxis)) {
    withInRange = _withIn(point.xValue, seriesRenderer._xAxis._visibleRange) &&
        (seriesRenderer._seriesType.contains('range') ||
                seriesRenderer._seriesType == 'hilo'
            ? (_withIn(point.low, seriesRenderer._yAxis._visibleRange) ||
                _withIn(point.high, seriesRenderer._yAxis._visibleRange))
            : seriesRenderer._seriesType == 'hiloopenclose' ||
                    seriesRenderer._seriesType.contains('candle')
                ? (_withIn(point.low, seriesRenderer._yAxis._visibleRange) &&
                    _withIn(point.high, seriesRenderer._yAxis._visibleRange) &&
                    _withIn(point.open, seriesRenderer._yAxis._visibleRange) &&
                    _withIn(point.close, seriesRenderer._yAxis._visibleRange))
                : _withIn(
                    seriesRenderer._seriesType.contains('100')
                        ? point.cumulativeValue
                        : point.yValue,
                    seriesRenderer._yAxis._visibleRange));
  }
  return withInRange;
}
