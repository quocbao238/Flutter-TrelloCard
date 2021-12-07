part of charts;

///Renders Triangular Moving Average (TMA) indicator.
///
///The Triangular Moving Average (TMA) is a technical indicator similar to other moving averages.
///The TMA shows the average (or average) price of an asset over a specified number of data points over a period of time.
///
///The technical indicator is rendered on the basis of the [valueField] property.
class TmaIndicator<T, D> extends TechnicalIndicators<T, D> {
  TmaIndicator(
      {bool isVisible,
      String xAxisName,
      String yAxisName,
      String seriesName,
      List<double> dashArray,
      double animationDuration,
      List<T> dataSource,
      ChartValueMapper<T, D> xValueMapper,
      ChartValueMapper<T, num> highValueMapper,
      ChartValueMapper<T, num> lowValueMapper,
      ChartValueMapper<T, num> openValueMapper,
      ChartValueMapper<T, num> closeValueMapper,
      String name,
      bool isVisibleInLegend,
      LegendIconType legendIconType,
      String legendItemText,
      Color signalLineColor,
      double signalLineWidth,
      int period,
      String valueField})
      : valueField = (valueField ?? 'close').toLowerCase(),
        super(
            isVisible: isVisible,
            xAxisName: xAxisName,
            yAxisName: yAxisName,
            seriesName: seriesName,
            dashArray: dashArray,
            animationDuration: animationDuration,
            dataSource: dataSource,
            xValueMapper: xValueMapper,
            highValueMapper: highValueMapper,
            lowValueMapper: lowValueMapper,
            openValueMapper: openValueMapper,
            closeValueMapper: closeValueMapper,
            name: name,
            isVisibleInLegend: isVisibleInLegend,
            legendIconType: legendIconType,
            legendItemText: legendItemText,
            signalLineColor: signalLineColor,
            signalLineWidth: signalLineWidth,
            period: period);

  ///ValueField value for tma indicator.
  ///
  /// Value field determines the field for rendering the indicators.
  ///
  ///Defaults to `close`.
  ///
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///            indicators: <TechnicalIndicators<dynamic, dynamic>>[
  ///            TmaIndicator<dynamic, dynamic>(
  ///                valueField : 'high',
  ///              ),
  ///        ));
  ///}
  ///```
  final String valueField;

  // ignore:unused_element
  void _initSeriesCollection(
      TechnicalIndicators<dynamic, dynamic> indicator, SfCartesianChart chart) {
    indicator._targetSeriesRenderers = <CartesianSeriesRenderer>[];
    indicator._setSeriesProperties(indicator, 'TMA', indicator.signalLineColor,
        indicator.signalLineWidth, chart);
  }

  // ignore:unused_element
  void _initDataSource(TechnicalIndicators<dynamic, dynamic> indicator) {
    final List<CartesianChartPoint<dynamic>> validData = indicator._dataPoints;
    if (validData.isNotEmpty && validData.length > indicator.period) {
      _calculateTMAPoints(indicator, validData);
    }
  }

  /// To calculate the values of the TMA indicator
  void _calculateTMAPoints(TmaIndicator<dynamic, dynamic> indicator,
      List<CartesianChartPoint<dynamic>> validData) {
    final num period = indicator.period;
    final List<CartesianChartPoint<dynamic>> points =
        <CartesianChartPoint<dynamic>>[];
    final List<dynamic> xValues = <dynamic>[];
    CartesianChartPoint<dynamic> _point;
    if (validData.isNotEmpty &&
        validData.length >= indicator.period &&
        period > 0) {
      final CartesianSeriesRenderer signalSeriesRenderer =
          indicator._targetSeriesRenderers[0];
      //prepare data
      if (validData.isNotEmpty && validData.length >= period) {
        num sum = 0;
        num index = 0;
        List<num> smaValues = <num>[];
        num length = validData.length;

        while (length >= period) {
          sum = 0;
          index = validData.length - length;
          for (num j = index; j < index + period; j++) {
            sum += _getFieldValue(validData, j, valueField);
          }
          sum = sum / period;
          smaValues.add(sum);
          length--;
        }
        //initial values
        for (num k = 0; k < period - 1; k++) {
          sum = 0;
          for (num j = 0; j < k + 1; j++) {
            sum += _getFieldValue(validData, j, valueField);
          }
          sum = sum / (k + 1);
          smaValues = _splice(smaValues, k, 0, sum);
        }

        index = indicator.period;
        while (index <= smaValues.length) {
          sum = 0;
          for (num j = index - indicator.period; j < index; j++) {
            sum = sum + smaValues[j];
          }
          sum = sum / indicator.period;
          _point = _getDataPoint(validData[index - 1].x, sum,
              validData[index - 1], signalSeriesRenderer, points.length);
          points.add(_point);
          xValues.add(_point.x);
          index++;
        }
      }
    }
    indicator._renderPoints = points;
    _setSeriesRange(points, indicator, xValues);
  }

  List<num> _splice<num>(List<num> list, int index,
      [num howMany, num elements]) {
    if (elements != null) {
      list.insertAll(index, <num>[elements]);
    }
    return list;
  }
}
