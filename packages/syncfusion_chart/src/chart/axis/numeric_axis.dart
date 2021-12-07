part of charts;

/// This class has the properties of the numeric axis.
///
/// Numeric axis uses a numerical scale and displays numbers as labels. By default, [NumericAxis] is set to both
/// horizontal axis and vertical axis.
///
/// Provides the options of [name], axis line, label rotation, label format, alignment and label position are
/// used to customize the appearance.
///
class NumericAxis extends ChartAxis {
  NumericAxis({
    String name,
    bool isVisible,
    bool anchorRangeToVisiblePoints,
    AxisTitle title,
    AxisLine axisLine,
    ChartRangePadding rangePadding,
    AxisLabelIntersectAction labelIntersectAction,
    int labelRotation,
    this.labelFormat,
    this.numberFormat,
    LabelAlignment labelAlignment,
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
    InteractiveTooltip interactiveTooltip,
    this.minimum,
    this.maximum,
    double interval,
    this.visibleMinimum,
    this.visibleMaximum,
    dynamic crossesAt,
    String associatedAxisName,
    bool placeLabelsNearAxisLine,
    List<PlotBand> plotBands,
    int decimalPlaces,
    int desiredIntervals,
    RangeController rangeController,
  })  : decimalPlaces = decimalPlaces ?? 3,
        super(
          name: name,
          isVisible: isVisible,
          anchorRangeToVisiblePoints: anchorRangeToVisiblePoints,
          isInversed: isInversed,
          opposedPosition: opposedPosition,
          rangePadding: rangePadding,
          labelRotation: labelRotation,
          labelIntersectAction: labelIntersectAction,
          labelPosition: labelPosition,
          tickPosition: tickPosition,
          minorTicksPerInterval: minorTicksPerInterval,
          maximumLabels: maximumLabels,
          labelStyle: labelStyle,
          title: title,
          labelAlignment: labelAlignment,
          axisLine: axisLine,
          edgeLabelPlacement: edgeLabelPlacement,
          majorTickLines: majorTickLines,
          minorTickLines: minorTickLines,
          majorGridLines: majorGridLines,
          minorGridLines: minorGridLines,
          plotOffset: plotOffset,
          zoomFactor: zoomFactor,
          zoomPosition: zoomPosition,
          interactiveTooltip: interactiveTooltip,
          interval: interval,
          crossesAt: crossesAt,
          associatedAxisName: associatedAxisName,
          placeLabelsNearAxisLine: placeLabelsNearAxisLine,
          plotBands: plotBands,
          desiredIntervals: desiredIntervals,
          rangeController: rangeController,
        );

  SfCartesianChart _chart;

  ///Formats the numeric axis labels.
  ///
  ///The labels can be customized by adding desired text as prefix or suffix.
  ///
  ///Defaults to `null`
  ///
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///           primaryXAxis: NumericAxis(labelFormat: '{value}M'),
  ///        ));
  ///}
  ///```
  final String labelFormat;

  ///Formats the numeric axis labels with globalized label formats.
  ///
  ///Defaults to `null`
  ///
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///           primaryXAxis: NumericAxis(numberFormat: NumberFormat.currencyCompact()),
  ///        ));
  ///}
  ///```
  final NumberFormat numberFormat;

  ///The minimum value of the axis.
  ///
  /// The axis will start from this value.
  ///
  ///Defaults to `null`
  ///
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///           primaryXAxis: NumericAxis(minimum: 0),
  ///        ));
  ///}
  ///```
  final double minimum;

  ///The maximum value of the axis.
  ///
  ///The axis will end at this value.
  ///
  ///Defaults to `null`
  ///
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///           primaryXAxis: NumericAxis(maximum: 200),
  ///        ));
  ///}
  ///```
  final double maximum;

  ///The minimum visible value of the axis.
  ///
  ///The axis will be rendered from this value initially.
  ///
  ///Defaults to `null`
  ///
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///           primaryXAxis: NumericAxis(visibleMinimum: 0),
  ///        ));
  ///}
  ///```
  final double visibleMinimum;

  ///The maximum visible value of the axis.
  ///
  /// The axis will be rendered till this value initially.
  ///
  ///Defaults to `null`
  ///
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///           primaryXAxis: NumericAxis(visibleMaximum: 200),
  ///        ));
  ///}
  ///```
  final double visibleMaximum;

  ///The rounding decimal value of the label.
  ///
  ///Defaults to `3`
  ///
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///           primaryXAxis: NumericAxis(decimalPlaces: 3),
  ///        ));
  ///}
  ///```
  final int decimalPlaces;
  // ignore:unused_field
  final int _axisPadding = 5;
  // ignore:unused_field
  final int _innerPadding = 5;

  Size _axisSize;

  /// Find the series min and max values of an series
  void _findAxisMinMax(CartesianSeriesRenderer seriesRenderer,
      CartesianChartPoint<dynamic> point, int pointIndex, int dataLength,
      [bool _isXVisibleRange, bool _isYVisibleRange]) {
    final String seriesType = seriesRenderer._seriesType;
    final bool _anchorRangeToVisiblePoints =
        seriesRenderer._yAxis.anchorRangeToVisiblePoints;
    point.xValue = point.x;
    point.yValue = point.y;
    if (_isYVisibleRange) {
      seriesRenderer._minimumX ??= point.xValue;
      seriesRenderer._maximumX ??= point.xValue;
    }
    if ((_isXVisibleRange || !_anchorRangeToVisiblePoints) &&
        !seriesType.contains('range') &&
        (!seriesType.contains('hilo')) &&
        (!seriesType.contains('candle'))) {
      seriesRenderer._minimumY ??= point.yValue;
      seriesRenderer._maximumY ??= point.yValue;
    }

    if (_isYVisibleRange && point.xValue != null) {
      seriesRenderer._minimumX =
          math.min(seriesRenderer._minimumX, point.xValue);
      seriesRenderer._maximumX =
          math.max(seriesRenderer._maximumX, point.xValue);
    }
    if (_isXVisibleRange || !_anchorRangeToVisiblePoints) {
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
        _highMin = math.min(_highMin ?? point.high, point.high);
        _highMax = math.max(_highMax ?? point.high, point.high);
      }
      if (point.low != null) {
        _lowMin = math.min(_lowMin ?? point.low, point.low);
        _lowMax = math.max(_lowMax ?? point.low, point.low);
      }
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
    if (_actualRange != null) {
      applyRangePadding(_actualRange, _actualRange.interval);
      if (type == null && type != 'AxisCross') {
        generateVisibleLabels();
      }
    }
  }

  /// Calculate the required values of the actual range for numeric axis
  void _calculateActualRange() {
    _min ??= 0;
    _max ??= 5;
    _actualRange = _VisibleRange(
        _chart._chartState.rangeChangeBySlider && rangeController != null
            ? _rangeMinimum ?? rangeController.start
            : minimum ?? _min,
        _chart._chartState.rangeChangeBySlider && rangeController != null
            ? _rangeMaximum ?? rangeController.end
            : maximum ?? _max);
    if (anchorRangeToVisiblePoints &&
        _needCalculateYrange(minimum, maximum, _chart, _orientation)) {
      _actualRange = _calculateYRangeOnZoomX(_actualRange, this);
    }

    ///Below condition is for checking the min, max value is equal
    if (_actualRange.minimum == _actualRange.maximum) {
      _actualRange.maximum += 1;
    }

    ///Below condition is for checking the axis min value is greater than max value, then swapping min max values
    else if (_actualRange.minimum > _actualRange.maximum) {
      _actualRange.minimum = _actualRange.minimum + _actualRange.maximum;
      _actualRange.maximum = _actualRange.minimum - _actualRange.maximum;
      _actualRange.minimum = _actualRange.minimum - _actualRange.maximum;
    }
    _actualRange.delta = _actualRange.maximum - _actualRange.minimum;

    _actualRange.interval = interval == null
        ? _calculateNumericNiceInterval(this, _actualRange.delta, _axisSize)
        : interval;
  }

  /// Applies range padding to auto, normal, additional, round, and none types.
  @override
  void applyRangePadding(_VisibleRange range, num interval) {
    ActualRangeChangedArgs rangeChangedArgs;
    if (!(minimum != null && maximum != null)) {
      ///Calculating range padding
      _applyRangePadding(this, _chart, range, interval);
    }

    calculateVisibleRange(_axisSize);

    /// Setting range as visible zoomRange
    if ((visibleMinimum != null || visibleMaximum != null) &&
        (visibleMinimum != visibleMaximum) &&
        _chart._chartState.zoomedAxisStates != null &&
        _chart._chartState.zoomedAxisStates.isEmpty) {
      _visibleRange.minimum =
          visibleMinimum != null ? visibleMinimum : _visibleRange.minimum;
      _visibleRange.maximum =
          visibleMaximum != null ? visibleMaximum : _visibleRange.maximum;
      _visibleRange.delta = _visibleRange.maximum - _visibleRange.minimum;
      _visibleRange.interval = _calculateNumericNiceInterval(
          this, _visibleRange.maximum - _visibleRange.minimum, _axisSize);
      _zoomFactor = _visibleRange.delta / range.delta;
      _zoomPosition =
          (_visibleRange.minimum - _actualRange.minimum) / range.delta;
    }
    if (_chart.onActualRangeChanged != null) {
      rangeChangedArgs = ActualRangeChangedArgs();
      rangeChangedArgs.axis = this;
      rangeChangedArgs.axisName = _name;
      rangeChangedArgs.orientation = _orientation;
      rangeChangedArgs.actualMin = range.minimum;
      rangeChangedArgs.actualMax = range.maximum;
      rangeChangedArgs.actualInterval = range.interval;
      rangeChangedArgs.visibleMin = _visibleRange.minimum;
      rangeChangedArgs.visibleMax = _visibleRange.maximum;
      rangeChangedArgs.visibleInterval = _visibleRange.interval;
      _chart.onActualRangeChanged(rangeChangedArgs);
      _visibleRange.minimum = rangeChangedArgs.visibleMin;
      _visibleRange.maximum = rangeChangedArgs.visibleMax;
      _visibleRange.interval = rangeChangedArgs.visibleInterval;
    }
  }

  /// Generates the visible axis labels.
  @override
  void generateVisibleLabels() {
    num tempInterval = _visibleRange.minimum;
    String text;
    final String minimum = tempInterval.toString();
    final num maximumVisibleRange = _visibleRange.maximum;
    num interval = _visibleRange.interval;
    interval = interval.toString().split('.').length >= 2
        ? interval.toString().split('.')[1].length == 1 &&
                interval.toString().split('.')[1] == '0'
            ? interval.floor()
            : interval
        : interval;
    _visibleLabels = <AxisLabel>[];
    for (; tempInterval <= maximumVisibleRange; tempInterval += interval) {
      num minimumVisibleRange = tempInterval;
      if (minimumVisibleRange <= maximumVisibleRange &&
          minimumVisibleRange >= _visibleRange.minimum) {
        final int fractionDigits = (minimum.split('.').length >= 2)
            ? minimum.split('.')[1].toString().length
            : (minimumVisibleRange.toString().split('.').length >= 2)
                ? minimumVisibleRange.toString().split('.')[1].toString().length
                : 0;
        final int _fractionDigitValue =
            fractionDigits > 20 ? 20 : fractionDigits;
        minimumVisibleRange = minimumVisibleRange.toString().contains('e')
            ? minimumVisibleRange
            : num.tryParse(
                minimumVisibleRange.toStringAsFixed(_fractionDigitValue));
        if (minimumVisibleRange.toString().split('.').length > 1) {
          final String str = minimumVisibleRange.toString();
          final List<dynamic> list = str.split('.');
          minimumVisibleRange =
              double.parse(minimumVisibleRange.toStringAsFixed(decimalPlaces));
          if (list != null &&
              list.length > 1 &&
              (list[1] == '0' ||
                  list[1] == '00' ||
                  list[1] == '000' ||
                  list[1] == '0000' ||
                  list[1] == '00000'))
            minimumVisibleRange = minimumVisibleRange.round();
        }
        text = minimumVisibleRange.toString();
        if (numberFormat != null) {
          text = numberFormat.format(minimumVisibleRange);
        }
        if (labelFormat != null && labelFormat != '') {
          text = labelFormat.replaceAll(RegExp('{value}'), text);
        }
        text = _chart.primaryYAxis._isStack100 == true &&
                _name == _chart.primaryYAxis._name
            ? (text + '%')
            : text;
        _triggerLabelRenderEvent(text, tempInterval);
      }
    }

    /// Get the maximum label of width and height in axis.
    _calculateMaximumLabelSize(this, _chart);
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
      _visibleRange.interval =
          enableAutoIntervalOnZooming && _chart._chartState.zoomProgress
              ? calculateInterval(_visibleRange, _axisSize)
              : _visibleRange.interval;
      if (rangeController != null) {
        _chart._chartState.rangeChangedByChart = true;
        _setRangeControllerValues(this);
      }
    }
  }

  /// Finds the interval of an axis.
  @override
  num calculateInterval(_VisibleRange range, Size availableSize) =>
      _calculateNumericNiceInterval(this, _visibleRange.delta, _axisSize);
}
