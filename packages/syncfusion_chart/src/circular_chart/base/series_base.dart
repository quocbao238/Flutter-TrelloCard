part of charts;

class _CircularSeries {
  _CircularSeries();

  SfCircularChart chart;

  CircularSeries<dynamic, dynamic> currentSeries;

  num size;

  num sumOfGroup;

  _Region explodedRegion;

  _Region selectRegion;

  List<CircularSeriesRenderer> visibleSeriesRenderers =
      <CircularSeriesRenderer>[];

  void _findVisibleSeries() {
    CircularSeries<dynamic, dynamic> series;
    for (CircularSeriesRenderer seriesRenderer
        in chart._chartSeries.visibleSeriesRenderers) {
      _setSeriesType(seriesRenderer);
      series = seriesRenderer._series = chart.series[0];
      seriesRenderer._dataPoints = <ChartPoint<dynamic>>[];
      if (series.dataSource != null) {
        for (int pointIndex = 0;
            pointIndex < series.dataSource.length;
            pointIndex++) {
          final ChartPoint<dynamic> currentPoint =
              _getCircularPoint(seriesRenderer, pointIndex);
          if (currentPoint.x != null) {
            seriesRenderer._dataPoints.add(currentPoint);
          }
        }
      }
      if (series.sortingOrder != SortingOrder.none &&
          series.sortFieldValueMapper != null) {
        _sortDataSource(seriesRenderer);
      }
      visibleSeriesRenderers
        ..clear()
        ..add(seriesRenderer);
      break;
    }
  }

  void _calculateCircularEmptyPoints(CircularSeriesRenderer seriesRenderer) {
    final List<ChartPoint<dynamic>> points = seriesRenderer._dataPoints;
    for (int i = 0; i < points.length; i++) {
      if (points[i].y == null)
        seriesRenderer._series
            .calculateEmptyPointValue(i, points[i], seriesRenderer);
    }
  }

  void _processDataPoints(CircularSeriesRenderer seriesRenderer) {
    currentSeries = seriesRenderer._series;
    _calculateCircularEmptyPoints(seriesRenderer);
    _findGroupPoints();
  }

  /// Sort the dataSource
  void _sortDataSource(CircularSeriesRenderer seriesRenderer) {
    seriesRenderer._dataPoints.sort(
        // ignore: missing_return
        (ChartPoint<dynamic> firstPoint, ChartPoint<dynamic> secondPoint) {
      if (seriesRenderer._series.sortingOrder == SortingOrder.ascending) {
        return (firstPoint.sortValue == null)
            ? -1
            : (secondPoint.sortValue == null
                ? 1
                : (firstPoint.sortValue is String
                    ? firstPoint.sortValue
                        .toLowerCase()
                        .compareTo(secondPoint.sortValue.toLowerCase())
                    : firstPoint.sortValue.compareTo(secondPoint.sortValue)));
      } else if (seriesRenderer._series.sortingOrder ==
          SortingOrder.descending) {
        return (firstPoint.sortValue == null)
            ? 1
            : (secondPoint.sortValue == null
                ? -1
                : (firstPoint.sortValue is String
                    ? secondPoint.sortValue
                        .toLowerCase()
                        .compareTo(firstPoint.sortValue.toLowerCase())
                    : secondPoint.sortValue.compareTo(firstPoint.sortValue)));
      }
    });
  }

  void _findGroupPoints() {
    final List<CircularSeriesRenderer> seriesRenderers =
        chart._chartSeries.visibleSeriesRenderers;
    final CircularSeriesRenderer seriesRenderer = seriesRenderers[0];
    final num groupValue = currentSeries.groupTo;
    final CircularChartGroupMode mode = currentSeries.groupMode;
    bool isYText;
    final dynamic textMapping = currentSeries.dataLabelMapper;
    ChartPoint<dynamic> point;
    sumOfGroup = 0;
    seriesRenderer._renderPoints = <ChartPoint<dynamic>>[];
    for (int i = 0; i < seriesRenderer._dataPoints.length; i++) {
      point = seriesRenderer._dataPoints[i];
      point.text = point.text == null
          ? textMapping != null
              ? textMapping(i) ?? point.y.toString()
              : point.y.toString()
          : point.text;
      isYText = point.text == point.y.toString() ? true : false;

      if (point.isVisible) {
        if (mode == CircularChartGroupMode.point &&
            groupValue != null &&
            i >= groupValue) {
          sumOfGroup += point.y.abs();
        } else if (mode == CircularChartGroupMode.value &&
            groupValue != null &&
            point.y <= groupValue) {
          sumOfGroup += point.y.abs();
        } else {
          seriesRenderer._renderPoints.add(point);
        }
      }
    }

    if (sumOfGroup > 0) {
      seriesRenderer._renderPoints
          .add(ChartPoint<dynamic>('Others', sumOfGroup));
      seriesRenderer
              ._renderPoints[seriesRenderer._renderPoints.length - 1].text =
          isYText == true ? 'Others : ' + sumOfGroup.toString() : 'Others';
    }
    _setPointStyle(seriesRenderer);
  }

  void _setPointStyle(CircularSeriesRenderer seriesRenderer) {
    final EmptyPointSettings empty = currentSeries.emptyPointSettings;
    final List<Color> palette = chart.palette;
    int i = 0;
    for (ChartPoint<dynamic> point in seriesRenderer._renderPoints) {
      point.fill = point.isEmpty && empty.color != null
          ? empty.color
          : point.pointColor ?? palette[i % palette.length];
      point.color = point.fill;
      point.strokeColor = point.isEmpty && empty.borderColor != null
          ? empty.borderColor
          : currentSeries.borderColor;
      point.strokeWidth = point.isEmpty && empty.borderWidth != null
          ? empty.borderWidth
          : currentSeries.borderWidth;
      point.strokeColor =
          point.strokeWidth == 0 ? Colors.transparent : point.strokeColor;

      if (chart.legend.legendItemBuilder != null) {
        final List<_MeasureWidgetContext> legendToggles =
            chart._chartState.legendToggleTemplateStates;
        if (legendToggles.isNotEmpty) {
          for (int j = 0; j < legendToggles.length; j++) {
            final _MeasureWidgetContext item = legendToggles[j];
            if (i == item.pointIndex) {
              point.isVisible = false;
              break;
            }
          }
        }
      } else {
        if (chart._chartState.legendToggleStates.isNotEmpty) {
          for (int j = 0;
              j < chart._chartState.legendToggleStates.length;
              j++) {
            final _LegendRenderContext legendRenderContext =
                chart._chartState.legendToggleStates[j];
            if (i == legendRenderContext.seriesIndex) {
              point.isVisible = false;
              break;
            }
          }
        }
      }
      i++;
    }
  }

  void _calculateAngleAndCenterPositions(
      CircularSeriesRenderer seriesRenderer) {
    currentSeries = seriesRenderer._series;
    _findSumOfPoints(seriesRenderer);
    _calculateAngle(seriesRenderer);
    _calculateRadius(seriesRenderer);
    _calculateOrigin(seriesRenderer);
    _calculateStartAndEndAngle(seriesRenderer);
    _calculateCenterPosition(seriesRenderer);
  }

  void _calculateCenterPosition(CircularSeriesRenderer seriesRenderer) {
    if (chart._needToMoveFromCenter &&
        currentSeries.pointRadiusMapper == null &&
        (seriesRenderer._seriesType == 'pie' ||
            seriesRenderer._seriesType == 'doughnut')) {
      final Rect areaRect = chart._chartState.chartAreaRect;
      bool needExecute = true;
      double radius = seriesRenderer._currentRadius;
      while (needExecute) {
        radius += 1;
        final Rect circularRect = _getArcPath(
                0.0,
                radius,
                seriesRenderer._center,
                seriesRenderer._start,
                seriesRenderer._end,
                seriesRenderer._totalAngle,
                chart,
                true)
            .getBounds();
        if (circularRect.width > areaRect.width) {
          needExecute = false;
          seriesRenderer._rect = circularRect;
          break;
        }
        if (circularRect.height > areaRect.height) {
          needExecute = false;
          seriesRenderer._rect = circularRect;
          break;
        }
      }
      seriesRenderer._rect = _getArcPath(
              0.0,
              seriesRenderer._currentRadius,
              seriesRenderer._center,
              seriesRenderer._start,
              seriesRenderer._end,
              seriesRenderer._totalAngle,
              chart,
              true)
          .getBounds();
      for (ChartPoint<dynamic> point in seriesRenderer._renderPoints) {
        point.outerRadius = seriesRenderer._currentRadius;
      }
    }
  }

  void _calculateStartAndEndAngle(CircularSeriesRenderer seriesRenderer) {
    int pointIndex = 0;
    num pointEndAngle;
    num pointStartAngle = seriesRenderer._start;
    final num innerRadius = seriesRenderer._currentInnerRadius;
    for (ChartPoint<dynamic> point in seriesRenderer._renderPoints) {
      if (point.isVisible) {
        point.innerRadius =
            (seriesRenderer._seriesType == 'doughnut') ? innerRadius : 0.0;
        point.degree = (point.y.abs() /
                (seriesRenderer._sumOfPoints != 0
                    ? seriesRenderer._sumOfPoints
                    : 1)) *
            seriesRenderer._totalAngle;
        pointEndAngle = pointStartAngle + point.degree;
        point.startAngle = pointStartAngle;
        point.endAngle = pointEndAngle;
        point.midAngle = (pointStartAngle + pointEndAngle) / 2;
        point.outerRadius = _calculatePointRadius(
            point.radius, point, seriesRenderer._currentRadius);
        point.center = _needExplode(pointIndex, currentSeries)
            ? _findExplodeCenter(
                point.midAngle, seriesRenderer, point.outerRadius)
            : seriesRenderer._center;
        if (currentSeries.dataLabelSettings != null) {
          _findDataLabelPosition(point);
        }
        pointStartAngle = pointEndAngle;
      }
      pointIndex++;
    }
  }

  bool _needExplode(int pointIndex, CircularSeries<dynamic, dynamic> series) {
    bool isNeedExplode = false;
    final _SfCircularChartState chartState = chart._chartState;
    if (series.explode) {
      if (chartState.initialRender) {
        if (pointIndex == series.explodeIndex || series.explodeAll) {
          chartState.explodedPoints.add(pointIndex);
          isNeedExplode = true;
        }
      } else if (chartState.widgetNeedUpdate || chartState._isLegendToggled) {
        isNeedExplode = chartState.explodedPoints.contains(pointIndex);
      }
    }
    return isNeedExplode;
  }

  void _findSumOfPoints(CircularSeriesRenderer seriesRenderer) {
    seriesRenderer._sumOfPoints = 0;
    for (ChartPoint<dynamic> point in seriesRenderer._renderPoints) {
      if (point.isVisible) {
        seriesRenderer._sumOfPoints += point.y.abs();
      }
    }
  }

  void _calculateAngle(CircularSeriesRenderer seriesRenderer) {
    seriesRenderer._start = currentSeries.startAngle < 0
        ? currentSeries.startAngle < -360
            ? (currentSeries.startAngle % 360) + 360
            : currentSeries.startAngle + 360
        : currentSeries.startAngle;
    seriesRenderer._end = currentSeries.endAngle < 0
        ? currentSeries.endAngle < -360
            ? (currentSeries.endAngle % 360) + 360
            : currentSeries.endAngle + 360
        : currentSeries.endAngle;
    seriesRenderer._start = seriesRenderer._start > 360
        ? seriesRenderer._start % 360
        : seriesRenderer._start;
    seriesRenderer._end = seriesRenderer._end > 360
        ? seriesRenderer._end % 360
        : seriesRenderer._end;
    seriesRenderer._start -= 90;
    seriesRenderer._end -= 90;
    seriesRenderer._end = seriesRenderer._start == seriesRenderer._end
        ? seriesRenderer._start + 360
        : seriesRenderer._end;
    seriesRenderer._totalAngle = seriesRenderer._start > seriesRenderer._end
        ? (seriesRenderer._start - 360).abs() + seriesRenderer._end
        : (seriesRenderer._start - seriesRenderer._end).abs();
  }

  void _calculateRadius(CircularSeriesRenderer seriesRenderer) {
    final _SfCircularChartState chartState = chart._chartState;
    final Rect chartAreaRect = chartState.chartAreaRect;
    size = min(chartAreaRect.width, chartAreaRect.height);
    seriesRenderer._currentRadius =
        _percentToValue(currentSeries.radius, size / 2).toDouble();
    seriesRenderer._currentInnerRadius = _percentToValue(
        currentSeries.innerRadius, seriesRenderer._currentRadius);
  }

  void _calculateOrigin(CircularSeriesRenderer seriesRenderer) {
    final _SfCircularChartState chartState = chart._chartState;
    final Rect chartAreaRect = chartState.chartAreaRect;
    final Rect chartContainerRect = chartState.chartContainerRect;
    seriesRenderer._center = Offset(
        _percentToValue(chart.centerX, chartAreaRect.width).toDouble(),
        _percentToValue(chart.centerY, chartAreaRect.height).toDouble());
    seriesRenderer._center = Offset(
        seriesRenderer._center.dx +
            (chartContainerRect.width - chartAreaRect.width).abs() / 2,
        seriesRenderer._center.dy +
            (chartContainerRect.height - chartAreaRect.height).abs() / 2);
    chartState.centerLocation = seriesRenderer._center;
  }

  Offset _findExplodeCenter(
      num midAngle, CircularSeriesRenderer seriesRenderer, num currentRadius) {
    final num explodeCenter =
        _percentToValue(seriesRenderer._series.explodeOffset, currentRadius);
    return _degreeToPoint(midAngle, explodeCenter, seriesRenderer._center);
  }

  num _calculatePointRadius(
      dynamic value, ChartPoint<dynamic> point, num radius) {
    if (value != null) {
      radius = value != null ? _percentToValue(value, size / 2) : radius;
    }
    return radius;
  }

  void _seriesPointSelection(_Region pointRegion, ActivationMode mode) {
    bool isPointAlreadySelected = false;
    final _SfCircularChartState chartState = chart._chartState;
    final CircularSeriesRenderer seriesRenderer =
        chart._chartSeries.visibleSeriesRenderers[pointRegion.seriesIndex];
    if (seriesRenderer._series.selectionSettings.enable &&
        mode == chart.selectionGesture) {
      if (chartState.selectionData.isNotEmpty) {
        for (int i = 0; i < chartState.selectionData.length; i++) {
          final int selectionIndex = chartState.selectionData[i];
          if (!chart.enableMultiSelection) {
            isPointAlreadySelected = chartState.selectionData.length == 1 &&
                pointRegion.pointIndex == selectionIndex;
            chartState.selectionData.removeAt(i);
            chartState.seriesRepaintNotifier.value++;
          } else if (pointRegion.pointIndex == selectionIndex) {
            chartState.selectionData.removeAt(i);
            isPointAlreadySelected = true;
            chartState.seriesRepaintNotifier.value++;
            break;
          }
        }
      }
      if (!isPointAlreadySelected) {
        chartState.selectionData.add(pointRegion.pointIndex);
        chartState.seriesRepaintNotifier.value++;
      }
    }
  }

  void _seriesPointExplosion(_Region pointRegion) {
    bool existExplodedRegion = false;
    final _SfCircularChartState chartState = chart._chartState;
    final CircularSeriesRenderer seriesRenderer =
        chart._chartSeries.visibleSeriesRenderers[pointRegion.seriesIndex];
    final ChartPoint<dynamic> point =
        seriesRenderer._renderPoints[pointRegion.pointIndex];
    if (seriesRenderer._series.explode) {
      if (chartState.explodedPoints.isNotEmpty) {
        if (chartState.explodedPoints.length == 1 &&
            chartState.explodedPoints.contains(pointRegion.pointIndex)) {
          existExplodedRegion = true;
          point.center = seriesRenderer._center;
          final int index =
              chartState.explodedPoints.indexOf(pointRegion.pointIndex);
          chartState.explodedPoints.removeAt(index);
          chartState.seriesRepaintNotifier.value++;
        } else if (seriesRenderer._series.explodeAll &&
            chartState.explodedPoints.length > 1 &&
            chartState.explodedPoints.contains(pointRegion.pointIndex)) {
          for (int i = 0; i < chartState.explodedPoints.length; i++) {
            final int explodeIndex = chartState.explodedPoints[i];
            seriesRenderer._renderPoints[explodeIndex].center =
                seriesRenderer._center;
            chartState.explodedPoints.removeAt(i);
            i--;
          }
          existExplodedRegion = true;
          chartState.seriesRepaintNotifier.value++;
        } else if (chartState.explodedPoints.length == 1) {
          for (int i = 0; i < chartState.explodedPoints.length; i++) {
            final int explodeIndex = chartState.explodedPoints[i];
            seriesRenderer._renderPoints[explodeIndex].center =
                seriesRenderer._center;
            chartState.explodedPoints.removeAt(i);
            chartState.seriesRepaintNotifier.value++;
          }
        }
      }
      if (!existExplodedRegion) {
        point.center = _findExplodeCenter(
            point.midAngle, seriesRenderer, point.outerRadius);
        chartState.explodedPoints.add(pointRegion.pointIndex);
        chartState.seriesRepaintNotifier.value++;
      }
    }
  }

  /// Setting series type
  void _setSeriesType(CircularSeriesRenderer seriesRenderer) {
    if (seriesRenderer is PieSeriesRenderer)
      seriesRenderer._seriesType = 'pie';
    else if (seriesRenderer is DoughnutSeriesRenderer)
      seriesRenderer._seriesType = 'doughnut';
    else if (seriesRenderer is RadialBarSeriesRenderer) {
      seriesRenderer._seriesType = 'radialbar';
    }
  }
}
