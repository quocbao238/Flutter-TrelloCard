part of charts;

///Logarithmic axis uses logarithmic scale and displays numbers as axis labels.
///
///provides options to customize the range of log axis, use the [minimum], [maximum], and [interval] properties.
/// By default, the range will be calculated automatically based on the provided data.
///
/// _Note:_ This is only applicable for [SfCartesianChart].
class LogarithmicAxis extends ChartAxis {
  LogarithmicAxis(
      {String name,
      bool isVisible,
      bool anchorRangeToVisiblePoints,
      AxisTitle title,
      AxisLine axisLine,
      AxisLabelIntersectAction labelIntersectAction,
      int labelRotation,
      ChartDataLabelPosition labelPosition,
      TickPosition tickPosition,
      bool isInversed,
      bool opposedPosition,
      int minorTicksPerInterval,
      int maximumLabels,
      MajorTickLines majorTickLines,
      MinorTickLines minorTickLines,
      MajorGridLines majorGridLines,
      MinorGridLines minorGridLines,
      EdgeLabelPlacement edgeLabelPlacement,
      TextStyle labelStyle,
      double plotOffset,
      double zoomFactor,
      double zoomPosition,
      bool enableAutoIntervalOnZooming,
      InteractiveTooltip interactiveTooltip,
      this.minimum,
      this.maximum,
      double interval,
      double logBase,
      this.labelFormat,
      this.numberFormat,
      this.visibleMinimum,
      this.visibleMaximum,
      LabelAlignment labelAlignment,
      dynamic crossesAt,
      String associatedAxisName,
      bool placeLabelsNearAxisLine,
      List<PlotBand> plotBands,
      int desiredIntervals,
      RangeController rangeController})
      : logBase = logBase ?? 10,
        super(
            name: name,
            isVisible: isVisible,
            anchorRangeToVisiblePoints: anchorRangeToVisiblePoints,
            isInversed: isInversed,
            opposedPosition: opposedPosition,
            labelRotation: labelRotation,
            labelIntersectAction: labelIntersectAction,
            labelPosition: labelPosition,
            tickPosition: tickPosition,
            minorTicksPerInterval: minorTicksPerInterval,
            maximumLabels: maximumLabels,
            labelStyle: labelStyle,
            title: title,
            axisLine: axisLine,
            edgeLabelPlacement: edgeLabelPlacement,
            labelAlignment: labelAlignment,
            majorTickLines: majorTickLines,
            minorTickLines: minorTickLines,
            majorGridLines: majorGridLines,
            minorGridLines: minorGridLines,
            plotOffset: plotOffset,
            zoomFactor: zoomFactor,
            zoomPosition: zoomPosition,
            enableAutoIntervalOnZooming: enableAutoIntervalOnZooming,
            interactiveTooltip: interactiveTooltip,
            interval: interval,
            crossesAt: crossesAt,
            associatedAxisName: associatedAxisName,
            placeLabelsNearAxisLine: placeLabelsNearAxisLine,
            plotBands: plotBands,
            desiredIntervals: desiredIntervals,
            rangeController: rangeController);

  ///Formats the numeric axis labels.
  ///
  /// The labels can be customized by adding desired text as prefix or suffix.
  ///
  ///Defaults to `null`.
  ///
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///           primaryXAxis: LogaithmicAxis(labelFormat: '{value}M'),
  ///        ));
  ///}
  ///```
  final String labelFormat;

  ///Formats the logarithmic axis labels with globalized label formats.
  ///
  ///Provides the ability to format a number in a locale-specific way.
  ///
  ///Defaults to `null`.
  ///
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///           primaryXAxis: LogarithmicAxis(numberFormat: NumberFormat.currencyCompact()),
  ///        ));
  ///}
  ///```
  final NumberFormat numberFormat;

  ///The minimum value of the axis.
  ///
  ///The axis will start from this value.
  ///
  ///Defaults to `null`.
  ///
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///           primaryYAxis: LogarithmicAxis(minimum: 0),
  ///        ));
  ///}
  ///```
  final double minimum;

  ///The maximum value of the axis.
  ///The axis will end at this value.
  ///
  ///Defaults to `null`.
  ///
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///           primaryYAxis: LogarithmicAxis(maximum: 10),
  ///        ));
  ///}
  ///```
  final double maximum;

  ///The base value for logarithmic axis.
  ///The axislabel will render this base value.i.e 10,100,1000 and so on.
  ///
  ///Defaults to `10`.
  ///
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///           primaryYAxis: LogarithmicAxis(logBase: 10),
  ///        ));
  ///}
  ///```
  final double logBase;

  ///The minimum visible value of the axis.
  ///
  ///The axis will be rendered from this value initially.
  ///
  ///Defaults to `null`.
  ///
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///           primaryXAxis: LogarithmicAxis(visibleMinimum: 0),
  ///        ));
  ///}
  ///```
  final double visibleMinimum;

  ///The minimum visible value of the axis.
  ///
  /// The axis will be rendered from this value initially.
  ///
  ///Defaults to `null`.
  ///
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///           primaryXAxis: LogarithmicAxis(visibleMaximum: 200),
  ///        ));
  ///}
  ///```
  final double visibleMaximum;

  Size _axisSize;

  /// Find the series min and max values of an series
  void _findAxisMinMax(CartesianSeriesRenderer seriesRenderer,
      CartesianChartPoint<dynamic> point, int pointIndex, int dataLength,
      [bool _isXVisibleRange, bool _isYVisibleRange]) {
    final String seriesType = seriesRenderer._seriesType;
    point.xValue = point.x;
    point.yValue = point.y;
    seriesRenderer._minimumX ??= point.xValue;
    seriesRenderer._maximumX ??= point.xValue;
    if (!seriesType.contains('range') &&
        (!seriesType.contains('hilo')) &&
        (!seriesType.contains('candle'))) {
      seriesRenderer._minimumY ??= point.yValue;
      seriesRenderer._maximumY ??= point.yValue;
    }
    _lowMin ??= point.low;
    _lowMax ??= point.low;
    _highMin ??= point.high;
    _highMax ??= point.high;
    if (point.xValue != null) {
      seriesRenderer._minimumX =
          math.min(seriesRenderer._minimumX, point.xValue);
      seriesRenderer._maximumX =
          math.max(seriesRenderer._maximumX, point.xValue);
    }
    if (point.yValue != null &&
        (!seriesType.contains('range') &&
            !seriesType.contains('hilo') &&
            !seriesType.contains('candle'))) {
      seriesRenderer._minimumY =
          math.min(seriesRenderer._minimumY, point.yValue);
      seriesRenderer._maximumY =
          math.max(seriesRenderer._maximumY, point.yValue);
    }
    if (point.high != null) {
      _highMin = math.min(_highMin, point.high);
      _highMax = math.max(_highMax, point.high);
    }
    if (point.low != null) {
      _lowMin = math.min(_lowMin, point.low);
      _lowMax = math.max(_lowMax, point.low);
    }
    if (pointIndex >= dataLength - 1) {
      if (seriesType.contains('range') ||
          seriesType.contains('hilo') ||
          seriesType.contains('candle')) {
        _lowMin ??= 0;
        _lowMax ??= 5;
        _highMin ??= 0;
        _highMax ??= 5;
        seriesRenderer._minimumY = math.min(_lowMin, _highMin);
        seriesRenderer._maximumY = math.max(_lowMax, _highMax);
      }
      seriesRenderer._minimumX ??= 0;
      seriesRenderer._minimumY ??= 0;
      seriesRenderer._maximumX ??= 5;
      seriesRenderer._maximumY ??= 5;
    }
  }

  void _controlListener() {
    if (rangeController != null && !_chart._chartState.rangeChangedByChart) {
      _updateRangeControllerValues(this);
      _chart._chartState.redrawByRangeChange();
    }
  }

  /// Calculate the range and interval
  void _calculateRangeAndInterval(SfCartesianChart chartWidget, [String type]) {
    _chart = chartWidget;
    if (rangeController != null) {
      _chart._chartState.rangeChangeBySlider = true;
      rangeController.addListener(_controlListener);
    }
    final Rect containerRect = _chart._chartState.containerRect;
    final Rect rect = Rect.fromLTWH(containerRect.left, containerRect.top,
        containerRect.width, containerRect.height);
    _axisSize = Size(rect.width, rect.height);
    calculateRange(this);
    _calculateActualRange();
    calculateVisibleRange(_axisSize);

    /// Setting range as visible zoomRange
    if ((visibleMinimum != null || visibleMaximum != null) &&
        (visibleMinimum != visibleMaximum) &&
        _chart._chartState.zoomedAxisStates != null &&
        _chart._chartState.zoomedAxisStates.isEmpty) {
      _visibleRange.minimum = visibleMinimum != null
          ? (math.log(visibleMinimum) / (math.log(10))).round()
          : _visibleRange.minimum;
      _visibleRange.maximum = visibleMaximum != null
          ? (math.log(visibleMaximum) / (math.log(10))).round()
          : _visibleRange.maximum;
      _visibleRange.delta = _visibleRange.maximum - _visibleRange.minimum;
      _zoomFactor = _visibleRange.delta / (_actualRange.delta);
      _zoomPosition =
          (_visibleRange.minimum - _actualRange.minimum) / _actualRange.delta;
    }
    if (type == null && type != 'AxisCross') {
      generateVisibleLabels();
    }
  }

  /// Calculate the required values of the actual range for logarithmic axis
  void _calculateActualRange() {
    num logStart, logEnd;
    _min ??= 0;
    _max ??= 5;
    _min = _chart._chartState.rangeChangeBySlider && rangeController != null
        ? _rangeMinimum ?? rangeController.start
        : minimum ?? _min;
    _max = _chart._chartState.rangeChangeBySlider && rangeController != null
        ? _rangeMaximum ?? rangeController.end
        : maximum ?? _max;
    if (anchorRangeToVisiblePoints &&
        _needCalculateYrange(minimum, maximum, _chart, _orientation)) {
      final _VisibleRange _range = _calculateYRangeOnZoomX(_actualRange, this);
      _min = _range.minimum;
      _max = _range.maximum;
    }
    _min = _min < 0 ? 0 : _min;
    logStart = _logBase(_min, logBase);
    logStart = logStart.isFinite ? logStart : _min;
    logEnd = _logBase(_max, logBase);
    logEnd = logEnd.isFinite ? logEnd : _max;
    _min = (logStart / 1).floor();
    _max = (logEnd / 1).ceil();
    if (_min == _max) {
      _max += 1;
    }
    _actualRange = _VisibleRange(_min, _max);
    _actualRange.delta = _actualRange.maximum - _actualRange.minimum;
    _actualRange.interval =
        interval ?? calculateLogNiceInterval(_actualRange.delta);
  }

  /// Calculates the visible range for an axis in chart.
  @override
  void calculateVisibleRange(Size availableSize) {
    _visibleRange = _VisibleRange(_actualRange.minimum, _actualRange.maximum);
    _visibleRange.delta = _actualRange.delta;
    _visibleRange.interval = _actualRange.interval;
    _checkWithZoomState(this, _chart._chartState.zoomedAxisStates);
    if (_zoomFactor < 1 || _zoomPosition > 0) {
      _chart._chartState.zoomProgress = true;
      _calculateZoomRange(this, availableSize);
      _visibleRange.delta = _visibleRange.maximum - _visibleRange.minimum;
      _visibleRange.interval =
          enableAutoIntervalOnZooming && _chart._chartState.zoomProgress
              ? calculateLogNiceInterval(_visibleRange.delta)
              : _visibleRange.interval;
      _visibleRange.interval = _visibleRange.interval.floor() == 0
          ? 1
          : _visibleRange.interval.floor();
      if (rangeController != null) {
        _chart._chartState.rangeChangedByChart = true;
        _setRangeControllerValues(this);
      }
    }
  }

  /// To get the axis interval for logarithmic axis
  num calculateLogNiceInterval(num delta) {
    final dynamic intervalDivisions = <dynamic>[10, 5, 2, 1];
    final num actualDesiredIntervalCount =
        _calculateDesiredIntervalCount(_axisSize, this);
    num niceInterval = delta;
    final num minInterval = math.pow(10, _logBase(niceInterval, 10).floor());
    for (int i = 0; i < intervalDivisions.length; i++) {
      final num interval = intervalDivisions[i];
      final num currentInterval = minInterval * interval;
      if (actualDesiredIntervalCount < (delta / currentInterval)) {
        break;
      }
      niceInterval = currentInterval;
    }
    return niceInterval;
  }

  /// Applies range padding to auto, normal, additional, round, and none types.
  @override
  void applyRangePadding(_VisibleRange range, num interval) {}

  /// Generates the visible axis labels.
  @override
  void generateVisibleLabels() {
    num tempInterval = _visibleRange.minimum;
    String labelText;
    _visibleLabels = <AxisLabel>[];
    for (;
        tempInterval <= _visibleRange.maximum;
        tempInterval += _visibleRange.interval) {
      labelText = pow(logBase, tempInterval).floor().toString();
      if (numberFormat != null) {
        labelText = numberFormat.format(pow(logBase, tempInterval).floor());
      }
      if (labelFormat != null && labelFormat != '') {
        labelText = labelFormat.replaceAll(RegExp('{value}'), labelText);
      }
      _triggerLabelRenderEvent(labelText, tempInterval);
    }

    /// Get the maximum label of width and height in axis.
    _calculateMaximumLabelSize(this, _chart);
  }

  /// Finds the interval of an axis.
  @override
  num calculateInterval(_VisibleRange range, Size availableSize) => null;
}
