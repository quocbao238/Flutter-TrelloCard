part of charts;

/// This class has the property of BollingerBand Indicator.
///
/// This indicator also having [upperLineColor], [lowerLineColor] property for defining the brushes for the indicator lines.
/// Also, we can specify standard deviation values for the BollingerBand indicator using [standardDeviation] property.
///
/// Provides options for series visible, axis name, series name, animation duration, legend visibility,
/// band color to customize the appearance.
///
class BollingerBandIndicator<T, D> extends TechnicalIndicators<T, D> {
  BollingerBandIndicator(
      {bool isVisible,
      String xAxisName,
      String yAxisName,
      String seriesName,
      List<double> dashArray,
      double animationDuration,
      List<T> dataSource,
      ChartValueMapper<T, D> xValueMapper,
      ChartValueMapper<T, num> closeValueMapper,
      String name,
      bool isVisibleInLegend,
      LegendIconType legendIconType,
      String legendItemText,
      Color signalLineColor,
      double signalLineWidth,
      int period,
      int standardDeviation,
      Color upperLineColor,
      double upperLineWidth,
      Color lowerLineColor,
      double lowerLineWidth,
      Color bandColor})
      : standardDeviation = standardDeviation ?? 2,
        upperLineColor = upperLineColor ?? Colors.red,
        upperLineWidth = upperLineWidth ?? 2,
        lowerLineColor = lowerLineColor ?? Colors.green,
        lowerLineWidth = lowerLineWidth ?? 2,
        bandColor = bandColor ?? Colors.grey.withOpacity(0.25),
        super(
            isVisible: isVisible,
            xAxisName: xAxisName,
            yAxisName: yAxisName,
            seriesName: seriesName,
            dashArray: dashArray,
            animationDuration: animationDuration,
            dataSource: dataSource,
            xValueMapper: xValueMapper,
            closeValueMapper: closeValueMapper,
            name: name,
            isVisibleInLegend: isVisibleInLegend,
            legendIconType: legendIconType,
            legendItemText: legendItemText,
            signalLineColor: signalLineColor,
            signalLineWidth: signalLineWidth,
            period: period);

  /// Standard Deviation value of the bollinger bands
  ///
  /// Defaluts to `2`
  ///
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///            indicators: <TechnicalIndicators<dynamic, dynamic>>[
  ///            BollingerBandIndicator<dynamic, dynamic>(
  ///                standardDeviation: 3,)},
  ///        ));
  ///}
  ///```
  ///
  final int standardDeviation;

  /// UpperLine Color of the bollinger bands.
  ///
  /// Defaluts to `Colors.red`
  ///
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///            indicators: <TechnicalIndicators<dynamic, dynamic>>[
  ///            BollingerBandIndicator<dynamic, dynamic>(
  ///                upperLineColor: Colors.red,)},
  ///        ));
  ///}
  ///```
  ///
  final Color upperLineColor;

  /// UpperLine width value of the bollinger bands.
  ///
  /// Defaluts to `2`
  ///
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///            indicators: <TechnicalIndicators<dynamic, dynamic>>[
  ///            BollingerBandIndicator<dynamic, dynamic>(
  ///                upperLineWidth: 2,)},
  ///        ));
  ///}
  ///```
  ///
  final double upperLineWidth;

  /// LowerLine Color value of the bollinger bands
  ///
  /// Defaluts to `Colors.green`
  ///
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///            indicators: <TechnicalIndicators<dynamic, dynamic>>[
  ///            BollingerBandIndicator<dynamic, dynamic>(
  ///                lowerLineColor: Colors.green,)},
  ///        ));
  ///}
  ///```
  ///
  final Color lowerLineColor;

  /// LowerLine Width value of the bollinger bands
  ///
  /// Defaluts to `2`
  ///
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///            indicators: <TechnicalIndicators<dynamic, dynamic>>[
  ///            BollingerBandIndicator<dynamic, dynamic>(
  ///                lowerLineWidth: 2,)},
  ///        ));
  ///}
  ///```
  ///
  final double lowerLineWidth;

  /// Band Color  of the Bollinger Band
  ///
  /// Defaluts to `Colors.grey.withOpacity(0.25)`
  ///
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///            indicators: <TechnicalIndicators<dynamic, dynamic>>[
  ///            BollingerBandIndicator<dynamic, dynamic>(
  ///                bandColor: Colors.transparent,)},
  ///        ));
  ///}
  ///```
  ///
  final Color bandColor;

  // ignore:unused_element
  void _initSeriesCollection(BollingerBandIndicator<dynamic, dynamic> indicator,
      SfCartesianChart chart) {
    indicator._targetSeriesRenderers = <CartesianSeriesRenderer>[];
    if (indicator.bandColor != Colors.transparent &&
        indicator.bandColor != null) {
      _setSeriesProperties(
          indicator, 'rangearea', indicator.bandColor, 0, chart);
    }
    _setSeriesProperties(indicator, 'BollingerBand', indicator.signalLineColor,
        indicator.signalLineWidth, chart);
    _setSeriesProperties(indicator, 'UpperLine', indicator.upperLineColor,
        indicator.upperLineWidth, chart);
    _setSeriesProperties(indicator, 'LowerLine', indicator.lowerLineColor,
        indicator.lowerLineWidth, chart);
  }

  // ignore:unused_element
  void _initDataSource(BollingerBandIndicator<dynamic, dynamic> indicator) {
    final bool enableBand = indicator.bandColor != Colors.transparent &&
        indicator.bandColor != null;
    final num start = enableBand ? 1 : 0;
    final List<CartesianChartPoint<dynamic>> signalCollection =
        <CartesianChartPoint<dynamic>>[];
    final List<CartesianChartPoint<dynamic>> upperCollection =
        <CartesianChartPoint<dynamic>>[];
    final List<CartesianChartPoint<dynamic>> lowerCollection =
        <CartesianChartPoint<dynamic>>[];
    final List<CartesianChartPoint<dynamic>> bandCollection =
        <CartesianChartPoint<dynamic>>[];
    final CartesianSeriesRenderer upperSeriesRenderer =
        indicator._targetSeriesRenderers[start + 1];
    final CartesianSeriesRenderer lowerSeriesRenderer =
        indicator._targetSeriesRenderers[start + 2];
    final CartesianSeriesRenderer signalSeriesRenderer =
        indicator._targetSeriesRenderers[start];
    final CartesianSeriesRenderer rangeAreaSeriesRenderer =
        enableBand ? indicator._targetSeriesRenderers[0] : null;
    final List<dynamic> xValues = <dynamic>[];

    //prepare data
    final List<CartesianChartPoint<dynamic>> validData = indicator._dataPoints;
    if (validData.isNotEmpty &&
        validData.length >= indicator.period &&
        indicator.period > 0) {
      num sum = 0;
      num deviationSum = 0;
      final num multiplier = indicator.standardDeviation;
      final num limit = validData.length;
      final num length = indicator.period.round();
      final List<num> smaPoints = List<num>(limit);
      final List<num> deviations = List<num>(limit);
      final List<_BollingerData> bollingerPoints = List<_BollingerData>(limit);

      for (int i = 0; i < length; i++) {
        sum += validData[i].close == null ? 0 : validData[i].close;
      }
      num sma = sum / indicator.period;
      for (int i = 0; i < limit; i++) {
        final num y = validData[i].close == null ? 0 : validData[i].close;
        if (i >= length - 1 && i < limit) {
          if (i - indicator.period >= 0) {
            final num diff = y - validData[i - length].close;
            sum = sum + diff;
            sma = sum / (indicator.period);
            smaPoints[i] = sma;
            deviations[i] = math.pow(y - sma, 2);
            deviationSum += deviations[i] - deviations[i - length];
          } else {
            smaPoints[i] = sma;
            deviations[i] = math.pow(y - sma, 2);
            deviationSum += deviations[i];
          }
          final num range = math.sqrt(deviationSum / (indicator.period));
          final num lowerBand = smaPoints[i] - (multiplier * range);
          final num upperBand = smaPoints[i] + (multiplier * range);
          if (i + 1 == length) {
            for (int j = 0; j < length - 1; j++) {
              bollingerPoints[j] = _BollingerData(
                  x: validData[j].xValue,
                  midBand: smaPoints[i],
                  lowBand: lowerBand,
                  upBand: upperBand,
                  visible: true);
            }
          }
          bollingerPoints[i] = _BollingerData(
              x: validData[i].xValue,
              midBand: smaPoints[i],
              lowBand: lowerBand,
              upBand: upperBand,
              visible: true);
        } else {
          if (i < indicator.period - 1) {
            smaPoints[i] = sma;
            deviations[i] = math.pow(y - sma, 2);
            deviationSum += deviations[i];
          }
        }
      }
      int i = -1;
      int j = -1;
      for (int k = 0; k < limit; k++) {
        if (k >= (length - 1)) {
          xValues.add(validData[k].x);
          upperCollection.add(_getDataPoint(
              validData[k].x,
              bollingerPoints[k].upBand,
              validData[k],
              upperSeriesRenderer,
              upperCollection.length));
          lowerCollection.add(_getDataPoint(
              validData[k].x,
              bollingerPoints[k].lowBand,
              validData[k],
              lowerSeriesRenderer,
              lowerCollection.length));
          signalCollection.add(_getDataPoint(
              validData[k].x,
              bollingerPoints[k].midBand,
              validData[k],
              signalSeriesRenderer,
              signalCollection.length));
          if (enableBand) {
            bandCollection.add(_getRangePoint(
                validData[k].x,
                upperCollection[++i].y,
                lowerCollection[++j].y,
                validData[k],
                rangeAreaSeriesRenderer._series,
                bandCollection.length));
          }
        }
      }
    }
    indicator._renderPoints = signalCollection;
    if (enableBand) {
      _setSeriesRange(bandCollection, indicator, xValues,
          indicator._targetSeriesRenderers[0]);
    }
    _setSeriesRange(signalCollection, indicator, xValues,
        indicator._targetSeriesRenderers[start]);
    _setSeriesRange(upperCollection, indicator, xValues,
        indicator._targetSeriesRenderers[start + 1]);
    _setSeriesRange(lowerCollection, indicator, xValues,
        indicator._targetSeriesRenderers[start + 2]);
  }
}

class _BollingerData {
  _BollingerData(
      {this.x, this.midBand, this.lowBand, this.upBand, this.visible});
  num x;
  num midBand;
  num lowBand;
  num upBand;
  bool visible;
}
