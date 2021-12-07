part of charts;

/// Renders the xy series.
///
/// Cartesian charts uses two axis namely x and y, to render.
abstract class XyDataSeries<T, D> extends CartesianSeries<T, D> {
  XyDataSeries(
      {ValueKey<String> key,
      ChartSeriesRendererFactory<T, D> onCreateRenderer,
      SeriesRendererCreatedCallback onRendererCreated,
      ChartValueMapper<T, D> xValueMapper,
      ChartValueMapper<T, num> yValueMapper,
      ChartValueMapper<T, String> dataLabelMapper,
      String name,
      @required List<T> dataSource,
      String xAxisName,
      String yAxisName,
      ChartValueMapper<T, Color> pointColorMapper,
      String legendItemText,
      ChartValueMapper<T, dynamic> sortFieldValueMapper,
      LinearGradient gradient,
      LinearGradient borderGradient,
      ChartValueMapper<T, num> sizeValueMapper,
      ChartValueMapper<T, num> highValueMapper,
      ChartValueMapper<T, num> lowValueMapper,
      List<Trendline> trendlines,
      double width,
      MarkerSettings markerSettings,
      bool isVisible,
      bool enableTooltip,
      EmptyPointSettings emptyPointSettings,
      DataLabelSettings dataLabelSettings,
      double animationDuration,
      List<double> dashArray,
      Color borderColor,
      double borderWidth,
      SelectionSettings selectionSettings,
      bool isVisibleInLegend,
      LegendIconType legendIconType,
      double opacity,
      Color color,
      List<int> initialSelectedDataIndexes,
      SortingOrder sortingOrder})
      : super(
            key: key,
            onRendererCreated: onRendererCreated,
            onCreateRenderer: onCreateRenderer,
            isVisible: isVisible,
            legendItemText: legendItemText,
            xAxisName: xAxisName,
            dashArray: dashArray,
            isVisibleInLegend: isVisibleInLegend,
            borderColor: borderColor,
            trendlines: trendlines,
            borderWidth: borderWidth,
            yAxisName: yAxisName,
            color: color,
            name: name,
            width: width,
            xValueMapper: (int index) => xValueMapper(dataSource[index], index),
            yValueMapper: (int index) => yValueMapper(dataSource[index], index),
            sortFieldValueMapper: sortFieldValueMapper != null
                ? (int index) => sortFieldValueMapper(dataSource[index], index)
                : null,
            pointColorMapper: pointColorMapper != null
                ? (int index) => pointColorMapper(dataSource[index], index)
                : null,
            dataLabelMapper: dataLabelMapper != null
                ? (int index) => dataLabelMapper(dataSource[index], index)
                : null,
            sizeValueMapper: sizeValueMapper != null
                ? (int index) => sizeValueMapper(dataSource[index], index)
                : null,
            highValueMapper: highValueMapper != null
                ? (int index) => highValueMapper(dataSource[index], index)
                : null,
            lowValueMapper: lowValueMapper != null
                ? (int index) => lowValueMapper(dataSource[index], index)
                : null,
            dataSource: dataSource,
            emptyPointSettings: emptyPointSettings,
            dataLabelSettings: dataLabelSettings,
            enableTooltip: enableTooltip,
            animationDuration: animationDuration,
            selectionSettings: selectionSettings,
            legendIconType: legendIconType,
            sortingOrder: sortingOrder,
            opacity: opacity,
            gradient: gradient,
            borderGradient: borderGradient,
            markerSettings: markerSettings,
            initialSelectedDataIndexes: initialSelectedDataIndexes);
}

/// Returns the widget.
typedef ChartDataLabelTemplateBuilder<T> = Widget Function(
    T data, CartesianChartPoint<dynamic> point, int pointIndex,
    {int seriesIndex, CartesianSeries<dynamic, dynamic> series});

/// This class has the properties of CartesianChartPoint.
///
/// Chart point is a class that is used to store the current x and y values from the datasource.
/// Contains x and y coordinates which are converted from the x and y values.
///
class CartesianChartPoint<D> {
  CartesianChartPoint(
      [this.x,
      this.y,
      this.dataLabelMapper,
      this.pointColorMapper,
      this.bubbleSize,
      this.high,
      this.low,
      this.open,
      this.close,
      this.volume,
      this.sortValue]) {
    x = x;
    y = y;
    sortValue = sortValue;
    markerPoint = markerPoint;
    isEmpty = isEmpty;
    isGap = isGap;
    isVisible = isVisible;
    bubbleSize = bubbleSize;
    pointColorMapper = pointColorMapper;
    dataLabelMapper = dataLabelMapper;
    high = high;
    low = low;
    open = open;
    close = close;
    markerPoint2 = markerPoint2;
    volume = volume;
  }

  /// X value of the point.
  D x;

  /// Y value of the point
  D y;

  /// Stores the xValues of the point
  D xValue;

  /// Stores the yValues of the Point
  D yValue;

  /// Sort value of the point.
  D sortValue;

  /// High value of the point.
  D high;

  /// Low value of the point.
  D low;

  /// Open value of the point.
  D open;

  /// Close value of the point
  D close;

  /// Volume value of the point
  num volume;

  /// Marker point location.
  _ChartLocation markerPoint;

  /// second Marker point location.
  _ChartLocation markerPoint2;

  /// Size of the bubble.
  num bubbleSize;

  /// To set empty value
  bool isEmpty;

  /// To set gap value
  bool isGap = false;

  /// To set the drop value
  bool isDrop = false;

  /// Set the visibility of the series.
  bool isVisible = true;

  /// Used to map the color value from data point.
  Color pointColorMapper;

  /// Map the datalabel value from data point.
  String dataLabelMapper;

  /// Store the region.
  Rect region;

  /// Stores the chart location.
  _ChartLocation openPoint,
      closePoint,
      centerOpenPoint,
      centerClosePoint,
      lowPoint,
      highPoint,
      centerLowPoint,
      centerHighPoint,
      currentPoint,
      _nextPoint,
      _midPoint,
      startControl,
      endControl;

  /// control points for spline series.
  List<_ControlPoints> controlPoint;

  /// Store the visible range.
  _VisibleRange sideBySideInfo;

  /// Store the List of region.
  List<Rect> regions;

  /// store the cumulative value.
  double cumulativeValue;

  /// Stores the tracker rect region
  Rect trackerRectRegion;

  /// Stores the forth data label text
  String label;

  /// Stores the forth data label text
  String label2;

  /// Stores the forth data label text
  String label3;

  /// Stores the forth data label text
  String label4;

  /// Stores the forth data label Rect
  RRect labelFillRect;

  /// Stores the forth data label Rect
  RRect labelFillRect2;

  /// Stores the forth data label Rect
  RRect labelFillRect3;

  /// Stores the forth data label Rect
  RRect labelFillRect4;

  /// Stores the data label location
  _ChartLocation labelLocation;

  /// Stores the second data label location
  _ChartLocation labelLocation2;

  /// Stores the third data label location
  _ChartLocation labelLocation3;

  /// Stores the forth data label location
  _ChartLocation labelLocation4;

  /// Data label region saturation.
  bool dataLabelSaturationRegionInside = false;

  /// Stores the data label region
  Rect dataLabelRegion;

  /// Stores the second data label region
  Rect dataLabelRegion2;

  /// Stores the third data label region
  Rect dataLabelRegion3;

  /// Stores the forth data label region
  Rect dataLabelRegion4;

  /// Stores the data point index
  int index;

  /// Stores the data index
  int overallDataPointIndex;

  /// Store the region data of the data point.
  List<String> regionData;
}

class _ChartLocation {
  _ChartLocation(this.x, this.y);
  num x;
  num y;
}

/// To calculate dash array path for series
Path _dashPath(
  Path source, {
  @required _CircularIntervalList<double> dashArray,
}) {
  if (source == null) {
    return null;
  }
  const double intialValue = 0.0;
  final Path path = Path();
  for (final PathMetric measurePath in source.computeMetrics()) {
    double distance = intialValue;
    bool draw = true;
    while (distance < measurePath.length) {
      final double length = dashArray.next;
      if (draw) {
        path.addPath(
            measurePath.extractPath(distance, distance + length), Offset.zero);
      }
      distance += length;
      draw = !draw;
    }
  }
  return path;
}

/// A circular array for dash offsets and lengths.
class _CircularIntervalList<T> {
  _CircularIntervalList(this._values);
  final List<T> _values;
  int _index = 0;
  T get next {
    if (_index >= _values.length) {
      _index = 0;
    }
    return _values[_index++];
  }
}

/// Creates series renderer for Xy data series
abstract class XyDataSeriesRenderer extends CartesianSeriesRenderer {
  /// To calculate empty point value for the specific mode
  @override
  void calculateEmptyPointValue(
      int pointIndex, CartesianChartPoint<dynamic> currentPoint,
      [CartesianSeriesRenderer seriesRenderer]) {
    final int pointLength = seriesRenderer._dataPoints.length - 1;
    final String _seriesType = seriesRenderer._seriesType;
    final CartesianChartPoint<dynamic> prevPoint = seriesRenderer._dataPoints[
        seriesRenderer._dataPoints.length >= 2 ? pointLength - 1 : pointLength];
    if (_seriesType.contains('range') ||
            _seriesType.contains('hilo') ||
            _seriesType == 'candle'
        ? _seriesType == 'hiloopenclose' || _seriesType == 'candle'
            ? (currentPoint.low == null ||
                currentPoint.high == null ||
                currentPoint.open == null ||
                currentPoint.close == null)
            : (currentPoint.low == null || currentPoint.high == null)
        : currentPoint.y == null) {
      switch (seriesRenderer._series.emptyPointSettings.mode) {
        case EmptyPointMode.zero:
          currentPoint.isEmpty = true;
          if (_seriesType.contains('range') ||
              _seriesType.contains('hilo') ||
              _seriesType.contains('candle')) {
            currentPoint.high = 0;
            currentPoint.low = 0;
            if (_seriesType == 'hiloopenclose' || _seriesType == 'candle') {
              currentPoint.open = 0;
              currentPoint.close = 0;
            }
          } else
            currentPoint.y = 0;
          break;

        case EmptyPointMode.average:
          if (seriesRenderer is XyDataSeriesRenderer) {
            _calculateAverageModeValue(
                pointIndex, pointLength, currentPoint, prevPoint);
          }
          currentPoint.isEmpty = true;
          break;

        case EmptyPointMode.gap:
          if (_seriesType == 'scatter' ||
              _seriesType == 'column' ||
              _seriesType == 'bar' ||
              _seriesType == 'bubble' ||
              _seriesType == 'splinearea' ||
              _seriesType == 'rangecolumn' ||
              _seriesType.contains('hilo') ||
              _seriesType.contains('candle') ||
              _seriesType == 'rangearea' ||
              _seriesType.contains('stacked')) {
            currentPoint.y = pointIndex != 0 &&
                    (!_seriesType.contains('stackedcolumn') &&
                        !_seriesType.contains('stackedbar'))
                ? prevPoint.y
                : 0;
            currentPoint.open = 0;
            currentPoint.close = 0;
            currentPoint.isVisible = false;
          } else if (_seriesType.contains('line') ||
              _seriesType == 'area' ||
              _seriesType == 'steparea') {
            if (_seriesType == 'splinerangearea') {
              currentPoint.low = currentPoint.low == null
                  ? pointIndex != 0 ? prevPoint.low ?? 0 : 0
                  : currentPoint.low;
              currentPoint.high = currentPoint.high == null
                  ? pointIndex != 0 ? prevPoint.high ?? 0 : 0
                  : currentPoint.high;
            } else {
              currentPoint.y = pointIndex != 0 ? prevPoint.y : 0;
            }
          }
          currentPoint.isGap = true;
          break;
        case EmptyPointMode.drop:
          if (_seriesType == 'splinerangearea') {
            currentPoint.low = currentPoint.low == null
                ? pointIndex != 0 ? prevPoint.low ?? 0 : 0
                : currentPoint.low;
            currentPoint.high = currentPoint.high == null
                ? pointIndex != 0 ? prevPoint.high ?? 0 : 0
                : currentPoint.high;
          }
          currentPoint.y = pointIndex != 0 &&
                  (_seriesType != 'area' &&
                      _seriesType != 'splinearea' &&
                      _seriesType != 'splinerangearea' &&
                      _seriesType != 'steparea' &&
                      !_seriesType.contains('stackedcolumn') &&
                      !_seriesType.contains('stackedbar'))
              ? prevPoint.y
              : 0;
          currentPoint.isDrop = true;
          currentPoint.isVisible = false;
          break;
        default:
          currentPoint.y = 0;
          break;
      }
    }
  }

  /// To render a series of elements for all series
  void renderSeriesElements(SfCartesianChart chart, Canvas canvas,
      Animation<double> animationController) {
    _markerShapes = <Path>[];
    _markerShapes2 = <Path>[];
    for (int pointIndex = 0; pointIndex < _dataPoints.length; pointIndex++) {
      final CartesianChartPoint<dynamic> point = _dataPoints[pointIndex];
      if (_series.markerSettings.isVisible || this is ScatterSeriesRenderer) {
        _series.markerSettings?.renderMarker(
            this, point, animationController, canvas, pointIndex);
      }
    }
  }

  /// To store the series properties
  void storeSeriesProperties(SfCartesianChart chart, int index) {
    _chart = chart;
    _isRectSeries = _seriesType.contains('column') ||
        _seriesType.contains('bar') ||
        _seriesType == 'histogram';
    _regionalData = <dynamic, dynamic>{};
    _segmentPath = Path();
    _segments = <ChartSegment>[];
    _seriesColor = _series.color ?? chart.palette[index % chart.palette.length];

    // calculates the tooltip region for trenlines in this series
    final List<Trendline> trendlines = _series.trendlines;
    if (trendlines != null &&
        chart.tooltipBehavior != null &&
        chart.tooltipBehavior.enable) {
      for (int j = 0; j < trendlines.length; j++) {
        if (trendlines[j]._isNeedRender) {
          if (trendlines[j]._pointsData != null) {
            for (int k = 0; k < trendlines[j]._pointsData.length; k++) {
              final CartesianChartPoint<dynamic> trendlinePoint =
                  trendlines[j]._pointsData[k];
              _calculateTooltipRegion(
                  trendlinePoint, index, this, chart, trendlines[j], j);
            }
          }
        }
      }
    }
  }

  /// To find the region data of a series
  void calculateRegionData(
      SfCartesianChart chart,
      CartesianSeriesRenderer seriesRenderer,
      int seriesIndex,
      CartesianChartPoint<dynamic> point,
      int pointIndex,
      [_VisibleRange sideBySideInfo,
      CartesianChartPoint<dynamic> _nextPoint,
      num midX,
      num midY]) {
    _chart = chart;
    final ChartAxis xAxis = _xAxis;
    final ChartAxis yAxis = _yAxis;
    final Rect rect = _calculatePlotOffset(chart._chartAxis._axisClipRect,
        Offset(xAxis.plotOffset, yAxis.plotOffset));
    _isRectSeries = _seriesType == 'column' ||
        _seriesType == 'bar' ||
        _seriesType.contains('stackedcolumn') ||
        _seriesType.contains('stackedbar') ||
        _seriesType == 'rangecolumn' ||
        _seriesType == 'histogram';
    CartesianChartPoint<dynamic> point;
    final num markerHeight = _series.markerSettings.height,
        markerWidth = _series.markerSettings.width;
    final bool isPointSeries =
        _seriesType == 'scatter' || _seriesType == 'bubble';
    final bool isFastLine = _seriesType == 'fastline';
    if ((!isFastLine ||
            (isFastLine &&
                (_series.markerSettings.isVisible ||
                    _series.dataLabelSettings.isVisible ||
                    _series.enableTooltip))) &&
        _visible) {
      point = _dataPoints[pointIndex];
      if (point.region == null ||
          _seriesType.contains('stackedcolumn') ||
          _seriesType.contains('stackedbar')) {
        if (_isRectSeries) {
          _calculateRectSeriesRegion(point, pointIndex, this, chart);
        } else if (isPointSeries) {
          _calculatePointSeriesRegion(point, pointIndex, this, chart, rect);
        } else {
          _calculatePathSeriesRegion(
              point,
              pointIndex,
              this,
              chart,
              rect,
              markerHeight,
              markerWidth,
              sideBySideInfo,
              _nextPoint,
              midX,
              midY);
        }
      }
      if (chart.tooltipBehavior != null && chart.tooltipBehavior.enable) {
        _calculateTooltipRegion(point, seriesIndex, this, chart);
      }
    }
  }

  /// To find the region data of chart tooltip
  void calculateTooltipRegion(SfCartesianChart chart, int seriesIndex,
      CartesianChartPoint<dynamic> point, int pointIndex) {
    /// For tooltip implementation
    if (_series.enableTooltip != null &&
        _series.enableTooltip &&
        point != null &&
        !point.isGap &&
        !point.isDrop) {
      final List<String> regionData = <String>[];
      String date;
      final List<dynamic> regionRect = <dynamic>[];
      final dynamic primaryAxis = _xAxis;
      if (primaryAxis is DateTimeAxis) {
        final DateFormat dateFormat =
            primaryAxis.dateFormat ?? primaryAxis._getLabelFormat(_xAxis);
        date = dateFormat
            .format(DateTime.fromMillisecondsSinceEpoch(point.xValue));
      }
      _xAxis is CategoryAxis
          ? regionData.add(point.x.toString())
          : _xAxis is DateTimeAxis
              ? regionData.add(date.toString())
              : regionData.add(_getLabelValue(
                      point.xValue, _xAxis, chart.tooltipBehavior.decimalPlaces)
                  .toString());
      if (_seriesType.contains('range')) {
        regionData.add(_getLabelValue(
                point.high, _yAxis, chart.tooltipBehavior.decimalPlaces)
            .toString());
        regionData.add(_getLabelValue(
                point.low, _yAxis, chart.tooltipBehavior.decimalPlaces)
            .toString());
      } else {
        regionData.add(_getLabelValue(
                point.yValue, _yAxis, chart.tooltipBehavior.decimalPlaces)
            .toString());
      }
      regionData.add(_series.name ?? 'series $seriesIndex');
      regionRect.add(point.region);
      regionRect.add(_isRectSeries
          ? _seriesType == 'column' || _seriesType.contains('stackedcolumn')
              ? point.yValue > 0
                  ? point.region.topCenter
                  : point.region.bottomCenter
              : point.region.topCenter
          : (_seriesType == 'rangearea'
              ? Offset(point.markerPoint.x,
                  (point.markerPoint.y + point.markerPoint2.y) / 2)
              : point.region.center));
      regionRect.add(point.pointColorMapper);
      regionRect.add(point.bubbleSize);
      if (_seriesType.contains('stacked')) {
        regionData.add((point.cumulativeValue).toString());
      }
      _regionalData[regionRect] = regionData;
    }
  }

  /// To calculate the empty point average mode value
  void _calculateAverageModeValue(
      int pointIndex,
      int pointLength,
      CartesianChartPoint<dynamic> currentPoint,
      CartesianChartPoint<dynamic> prevPoint) {
    final List<dynamic> dataSource = _series.dataSource;
    final CartesianChartPoint<dynamic> _nextPoint = _getPointFromData(
        this,
        pointLength < dataSource.length - 1
            ? dataSource.indexOf(dataSource[pointLength + 1])
            : dataSource.indexOf(dataSource[pointLength]));
    if (_seriesType.contains('range') ||
        _seriesType.contains('hilo') ||
        _seriesType.contains('candle')) {
      final dynamic _cartesianSeries = _series;
      if (_cartesianSeries is _FinancialSeriesBase &&
          _cartesianSeries.showIndicationForSameValues) {
        if (currentPoint.low != null || currentPoint.high != null) {
          currentPoint.low =
              currentPoint.low == null ? currentPoint.high : currentPoint.low;
          currentPoint.high =
              currentPoint.high == null ? currentPoint.low : currentPoint.high;
        } else {
          currentPoint.low = 0;
          currentPoint.high = 0;
          currentPoint.open = 0;
          currentPoint.close = 0;
          currentPoint.isGap = true;
        }
        if (_seriesType == 'hiloopenclose' || _seriesType == 'candle') {
          if (currentPoint.open != null || currentPoint.close != null) {
            currentPoint.open = currentPoint.open == null
                ? currentPoint.close
                : currentPoint.open;
            currentPoint.close = currentPoint.close == null
                ? currentPoint.open
                : currentPoint.close;
          } else {
            currentPoint.low = 0;
            currentPoint.high = 0;
            currentPoint.open = 0;
            currentPoint.close = 0;
            currentPoint.isGap = true;
          }
        }
      } else {
        if (pointIndex == 0) {
          if (currentPoint.low == null) {
            pointIndex == dataSource.length - 1
                ? currentPoint.low = 0
                : currentPoint.low = ((_nextPoint.low) ?? 0) / 2;
          }
          if (currentPoint.high == null) {
            pointIndex == dataSource.length - 1
                ? currentPoint.high = 0
                : currentPoint.high = ((_nextPoint.high) ?? 0) / 2;
          }
          if (_seriesType == 'hiloopenclose' || _seriesType == 'candle') {
            if (currentPoint.open == null) {
              pointIndex == dataSource.length - 1
                  ? currentPoint.open = 0
                  : currentPoint.open = ((_nextPoint.open) ?? 0) / 2;
            }
            if (currentPoint.close == null) {
              pointIndex == dataSource.length - 1
                  ? currentPoint.close = 0
                  : currentPoint.close = ((_nextPoint.close) ?? 0) / 2;
            }
          }
        } else if (pointIndex == dataSource.length - 1) {
          currentPoint.low = currentPoint.low == null
              ? ((prevPoint.low) ?? 0) / 2
              : currentPoint.low;
          currentPoint.high = currentPoint.high == null
              ? ((prevPoint.high) ?? 0) / 2
              : currentPoint.high;

          if (_seriesType == 'hiloopenclose' || _seriesType == 'candle') {
            currentPoint.open = currentPoint.open == null
                ? ((prevPoint.open) ?? 0) / 2
                : currentPoint.open;
            currentPoint.close = currentPoint.close == null
                ? ((prevPoint.close) ?? 0) / 2
                : currentPoint.close;
          }
        } else {
          currentPoint.low = currentPoint.low == null
              ? (((prevPoint.low) ?? 0) + ((_nextPoint.low) ?? 0)) / 2
              : currentPoint.low;
          currentPoint.high = currentPoint.high == null
              ? (((prevPoint.high) ?? 0) + ((_nextPoint.high) ?? 0)) / 2
              : currentPoint.high;

          if (_seriesType == 'hiloopenclose' || _seriesType == 'candle') {
            currentPoint.open = currentPoint.open == null
                ? (((prevPoint.open) ?? 0) + ((_nextPoint.open) ?? 0)) / 2
                : currentPoint.open;
            currentPoint.close = currentPoint.close == null
                ? (((prevPoint.close) ?? 0) + ((_nextPoint.close) ?? 0)) / 2
                : currentPoint.close;
          }
        }
      }
    } else {
      if (pointIndex == 0) {
        ///Check the first point is null
        pointIndex == dataSource.length - 1
            ?

            ///Check the series contains single point with null value
            currentPoint.y = 0
            : currentPoint.y = ((_nextPoint.y) ?? 0) / 2;
      } else if (pointIndex == dataSource.length - 1) {
        ///Check the last point is null
        currentPoint.y = ((prevPoint.y) ?? 0) / 2;
      } else {
        currentPoint.y = (((prevPoint.y) ?? 0) + ((_nextPoint.y) ?? 0)) / 2;
      }
    }
  }
}
