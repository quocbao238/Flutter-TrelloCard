part of charts;

class _PyramidSeries {
  _PyramidSeries();

  SfPyramidChart chart;

  PyramidSeries<dynamic, dynamic> currentSeries;

  List<PyramidSeriesRenderer> visibleSeriesRenderers =
      <PyramidSeriesRenderer>[];
  SelectionArgs _selectionArgs;

  void _findVisibleSeries() {
    chart._chartSeries.visibleSeriesRenderers[0]._dataPoints =
        <PointInfo<dynamic>>[];

    //Considered the first series, since in triangular series one series will be considered for rendering
    final PyramidSeriesRenderer seriesRenderer =
        chart._chartSeries.visibleSeriesRenderers[0];
    currentSeries = seriesRenderer._series;
    //Setting seriestype
    seriesRenderer._seriesType = 'pyramid';
    final dynamic xValue = currentSeries.xValueMapper;
    final dynamic yValue = currentSeries.yValueMapper;
    for (int pointIndex = 0;
        pointIndex < currentSeries.dataSource.length;
        pointIndex++) {
      if (xValue(pointIndex) != null) {
        seriesRenderer._dataPoints
            .add(PointInfo<dynamic>(xValue(pointIndex), yValue(pointIndex)));
      }
    }
    visibleSeriesRenderers
      ..clear()
      ..add(seriesRenderer);
  }

  void _calculatePyramidEmptyPoints(PyramidSeriesRenderer seriesRenderer) {
    for (int i = 0; i < seriesRenderer._dataPoints.length; i++) {
      if (seriesRenderer._dataPoints[i].y == null)
        seriesRenderer._series.calculateEmptyPointValue(
            i, seriesRenderer._dataPoints[i], seriesRenderer);
    }
  }

  void _processDataPoints() {
    for (PyramidSeriesRenderer seriesRenderer in visibleSeriesRenderers) {
      currentSeries = seriesRenderer._series;
      _calculatePyramidEmptyPoints(seriesRenderer);
      _calculateVisiblePoints(seriesRenderer);
      _setPointStyle(seriesRenderer);
      _findSumOfPoints(seriesRenderer);
    }
  }

  void _calculateVisiblePoints(PyramidSeriesRenderer seriesRenderer) {
    final List<PointInfo<dynamic>> points = seriesRenderer._dataPoints;
    seriesRenderer._renderPoints = <PointInfo<dynamic>>[];
    for (int i = 0; i < points.length; i++) {
      if (points[i].isVisible) {
        seriesRenderer._renderPoints.add(points[i]);
      }
    }
  }

  void _setPointStyle(PyramidSeriesRenderer seriesRenderer) {
    currentSeries = seriesRenderer._series;
    final List<Color> palette = chart.palette;
    final dynamic pointColor = currentSeries.pointColorMapper;
    final EmptyPointSettings empty = currentSeries.emptyPointSettings;
    final dynamic textMapping = currentSeries.textFieldMapper;
    final List<PointInfo<dynamic>> points = seriesRenderer._renderPoints;
    for (int i = 0; i < points.length; i++) {
      PointInfo<dynamic> currentPoint;
      currentPoint = points[i];
      currentPoint.fill = currentPoint.isEmpty && empty.color != null
          ? empty.color
          : pointColor(i) ?? palette[i % palette.length];
      currentPoint.color = currentPoint.fill;
      currentPoint.borderColor =
          currentPoint.isEmpty && empty.borderColor != null
              ? empty.borderColor
              : currentSeries.borderColor;
      currentPoint.borderWidth =
          currentPoint.isEmpty && empty.borderWidth != null
              ? empty.borderWidth
              : currentSeries.borderWidth;
      currentPoint.borderColor = currentPoint.borderWidth == 0
          ? Colors.transparent
          : currentPoint.borderColor;

      currentPoint.text = currentPoint.text == null
          ? textMapping != null
              ? textMapping(i) ?? currentPoint.y.toString()
              : currentPoint.y.toString()
          : currentPoint.text;

      if (chart.legend.legendItemBuilder != null) {
        final List<_MeasureWidgetContext> legendToggles =
            chart._chartState.legendToggleTemplateStates;
        if (legendToggles.isNotEmpty) {
          for (int j = 0; j < legendToggles.length; j++) {
            final _MeasureWidgetContext item = legendToggles[j];
            if (i == item.pointIndex) {
              currentPoint.isVisible = false;
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
              currentPoint.isVisible = false;
              break;
            }
          }
        }
      }
    }
  }

  void _findSumOfPoints(PyramidSeriesRenderer seriesRenderer) {
    seriesRenderer._sumOfPoints = 0;
    for (PointInfo<dynamic> point in seriesRenderer._renderPoints) {
      if (point.isVisible) {
        seriesRenderer._sumOfPoints += point.y.abs();
      }
    }
  }

  void _initializeSeriesProperties(PyramidSeriesRenderer seriesRenderer) {
    final PyramidSeries<dynamic, dynamic> series = seriesRenderer._series;
    final Rect chartAreaRect = chart._chartState.chartAreaRect;
    final bool reverse = seriesRenderer._seriesType == 'pyramid' ? true : false;
    seriesRenderer._triangleSize = Size(
        _percentToValue(series.width, chartAreaRect.width).toDouble(),
        _percentToValue(series.height, chartAreaRect.height).toDouble());
    seriesRenderer._explodeDistance =
        _percentToValue(series.explodeOffset, chartAreaRect.width);
    if (series.pyramidMode == PyramidMode.linear) {
      _initializeSizeRatio(seriesRenderer, reverse);
    } else {
      _initializeSurfaceSizeRatio(seriesRenderer);
    }
  }

  void _initializeSurfaceSizeRatio(PyramidSeriesRenderer seriesRenderer) {
    final num count = seriesRenderer._renderPoints.length;
    final num sumOfValues = seriesRenderer._sumOfPoints;
    List<num> y;
    List<num> height;
    y = <num>[];
    height = <num>[];
    final num gapRatio = min(max(seriesRenderer._series.gapRatio, 0), 1);
    final num gapHeight = gapRatio / (count - 1);
    final num preSum = _getSurfaceHeight(0, sumOfValues);
    num currY = 0;
    PointInfo<dynamic> point;
    for (num i = 0; i < count; i++) {
      point = seriesRenderer._renderPoints[i];
      if (point.isVisible) {
        y.add(currY);
        height.add(_getSurfaceHeight(currY, point.y.abs()));
        currY += height[i] + gapHeight * preSum;
      }
    }
    final num coef = 1 / (currY - gapHeight * preSum);
    for (num i = 0; i < count; i++) {
      point = seriesRenderer._renderPoints[i];
      if (point.isVisible) {
        point.yRatio = coef * y[i];
        point.heightRatio = coef * height[i];
      }
    }
  }

  num _getSurfaceHeight(num y, num surface) =>
      _solveQuadraticEquation(1, 2 * y, -surface);

  num _solveQuadraticEquation(num a, num b, num c) {
    num root1;
    num root2;
    final num d = b * b - 4 * a * c;
    if (d >= 0) {
      final num sd = sqrt(d);
      root1 = (-b - sd) / (2 * a);
      root2 = (-b + sd) / (2 * a);
      return max(root1, root2);
    }
    return 0;
  }

  void _initializeSizeRatio(PyramidSeriesRenderer seriesRenderer,
      [bool reverse]) {
    final List<PointInfo<dynamic>> points = seriesRenderer._renderPoints;
    double y;
    final double gapRatio = min(max(seriesRenderer._series.gapRatio, 0), 1);
    final double coEff =
        1 / (seriesRenderer._sumOfPoints * (1 + gapRatio / (1 - gapRatio)));
    final double spacing = gapRatio / (points.length - 1);
    y = 0;
    num index;
    num height;
    for (num i = points.length - 1; i >= 0; i--) {
      index = reverse ? points.length - 1 - i : i;
      if (points[index].isVisible) {
        height = coEff * points[index].y;
        points[index].yRatio = y;
        points[index].heightRatio = height;
        y += height + spacing;
      }
    }
  }

  void _pointExplode(num pointIndex) {
    bool existExplodedRegion = false;
    final PyramidSeriesRenderer seriesRenderer =
        chart._chartSeries.visibleSeriesRenderers[0];
    final _SfPyramidChartState chartState = chart._chartState;
    final PointInfo<dynamic> point = seriesRenderer._renderPoints[pointIndex];
    if (seriesRenderer._series.explode) {
      if (chartState.explodedPoints.isNotEmpty) {
        existExplodedRegion = true;
        final int previousIndex = chartState.explodedPoints[0];
        seriesRenderer._renderPoints[previousIndex].explodeDistance = 0;
        point.explodeDistance =
            previousIndex == pointIndex ? 0 : seriesRenderer._explodeDistance;
        chartState.explodedPoints[0] = pointIndex;
        if (previousIndex == pointIndex) {
          chartState.explodedPoints = <int>[];
        }
        chartState.seriesRepaintNotifier.value++;
      }
      if (!existExplodedRegion) {
        point.explodeDistance = seriesRenderer._explodeDistance;
        chartState.explodedPoints.add(pointIndex);
        chartState.seriesRepaintNotifier.value++;
      }
      _calculatePathRegion(pointIndex, seriesRenderer);
    }
  }

  void _calculatePathRegion(
      num pointIndex, PyramidSeriesRenderer seriesRenderer) {
    final dynamic currentPoint = seriesRenderer._renderPoints[pointIndex];
    currentPoint.pathRegion = <Offset>[];
    final _SfPyramidChartState chartState = chart._chartState;
    final Size area = seriesRenderer._triangleSize;
    final Rect rect = chartState.chartContainerRect;
    final num seriesTop = rect.top + (rect.height - area.height) / 2;
    const num offset = 0;
    final num extraSpace = (currentPoint.explodeDistance != null
            ? currentPoint.explodeDistance
            : _isNeedExplode(pointIndex, currentSeries, chart)
                ? seriesRenderer._explodeDistance
                : 0) +
        (rect.width - seriesRenderer._triangleSize.width) / 2;
    final num emptySpaceAtLeft = extraSpace + rect.left;
    num top = currentPoint.yRatio;
    num bottom = currentPoint.yRatio + currentPoint.heightRatio;
    final num topRadius = 0.5 * (1 - currentPoint.yRatio);
    final num bottomRadius = 0.5 * (1 - bottom);
    top += seriesTop / area.height;
    bottom += seriesTop / area.height;
    num line1X, line1Y, line2X, line2Y, line3X, line3Y, line4X, line4Y;
    line1X = emptySpaceAtLeft + offset + topRadius * area.width;
    line1Y = top * area.height;
    line2X = emptySpaceAtLeft + offset + (1 - topRadius) * area.width;
    line2Y = top * area.height;
    line3X = emptySpaceAtLeft + offset + (1 - bottomRadius) * area.width;
    line3Y = bottom * area.height;
    line4X = emptySpaceAtLeft + offset + bottomRadius * area.width;
    line4Y = bottom * area.height;
    currentPoint.pathRegion.add(Offset(line1X, line1Y));
    currentPoint.pathRegion.add(Offset(line2X, line2Y));
    currentPoint.pathRegion.add(Offset(line3X, line3Y));
    currentPoint.pathRegion.add(Offset(line4X, line4Y));
    _calculatePathSegment(seriesRenderer._seriesType, currentPoint);
  }

  void _calculatePyramidSegments(
      Canvas canvas, num pointIndex, PyramidSeriesRenderer seriesRenderer) {
    _calculatePathRegion(pointIndex, seriesRenderer);
    final dynamic currentPoint = seriesRenderer._renderPoints[pointIndex];
    final Path path = Path();
    path.moveTo(currentPoint.pathRegion[0].dx, currentPoint.pathRegion[0].dy);
    path.lineTo(currentPoint.pathRegion[1].dx, currentPoint.pathRegion[0].dy);
    path.lineTo(currentPoint.pathRegion[1].dx, currentPoint.pathRegion[1].dy);
    path.lineTo(currentPoint.pathRegion[2].dx, currentPoint.pathRegion[2].dy);
    path.lineTo(currentPoint.pathRegion[3].dx, currentPoint.pathRegion[3].dy);
    path.close();
    if (pointIndex == seriesRenderer._renderPoints.length - 1) {
      seriesRenderer._maximumDataLabelRegion = path.getBounds();
    }
    _segmentPaint(canvas, path, pointIndex, seriesRenderer);
  }

  void _segmentPaint(Canvas canvas, Path path, num pointIndex,
      PyramidSeriesRenderer seriesRenderer) {
    final dynamic point = seriesRenderer._renderPoints[pointIndex];
    final _StyleOptions style =
        _getPointStyle(pointIndex, seriesRenderer, chart, point);

    final Color fillColor =
        style != null && style.fill != null ? style.fill : point.fill;

    final Color strokeColor = style != null && style.strokeColor != null
        ? style.strokeColor
        : point.borderColor;

    final double strokeWidth = style != null && style.strokeWidth != null
        ? style.strokeWidth
        : point.borderWidth;

    final double opacity = style != null && style.opacity != null
        ? style.opacity
        : currentSeries.opacity;

    _drawPath(
        canvas,
        _StyleOptions(
            fillColor,
            chart._chartState.animateCompleted ? strokeWidth : 0,
            strokeColor,
            opacity),
        path);
  }

  void _calculatePathSegment(String seriesType, PointInfo<dynamic> point) {
    final List<Offset> pathRegion = point.pathRegion;
    final num bottom =
        seriesType == 'funnel' ? pathRegion.length - 2 : pathRegion.length - 1;
    final num x = (pathRegion[0].dx + pathRegion[bottom].dx) / 2;
    final num right = (pathRegion[1].dx + pathRegion[bottom - 1].dx) / 2;
    point.region = Rect.fromLTWH(x, pathRegion[0].dy, right - x,
        pathRegion[bottom].dy - pathRegion[0].dy);
    point.symbolLocation = Offset(point.region.left + point.region.width / 2,
        point.region.top + point.region.height / 2);
  }

  void _seriesPointSelection(num pointIndex, ActivationMode mode) {
    bool isPointAlreadySelected = false;
    final dynamic seriesRenderer = chart._chartSeries.visibleSeriesRenderers[0];
    final dynamic series = seriesRenderer._series;
    final _SfPyramidChartState chartState = chart._chartState;
    if (series.selectionSettings.enable && mode == chart.selectionGesture) {
      if (chartState.selectionData.isNotEmpty) {
        for (int i = 0; i < chartState.selectionData.length; i++) {
          final int selectionIndex = chartState.selectionData[i];
          if (!chart.enableMultiSelection) {
            isPointAlreadySelected = chartState.selectionData.length == 1 &&
                pointIndex == selectionIndex;
            chartState.selectionData.removeAt(i);
            chartState.seriesRepaintNotifier.value++;
          } else if (pointIndex == selectionIndex) {
            chartState.selectionData.removeAt(i);
            isPointAlreadySelected = true;
            chartState.seriesRepaintNotifier.value++;
            break;
          }
        }
      }
      if (!isPointAlreadySelected) {
        chartState.selectionData.add(pointIndex);
        chartState.seriesRepaintNotifier.value++;
      }
    }
  }

  _StyleOptions _getPointStyle(
      int currentPointIndex,
      PyramidSeriesRenderer seriesRenderer,
      SfPyramidChart chart,
      PointInfo<dynamic> point) {
    _StyleOptions pointStyle;
    final SelectionSettings selection =
        seriesRenderer._series.selectionSettings;
    const num seriesIndex = 0;
    if (selection.enable) {
      if (chart._chartState.selectionData.isNotEmpty) {
        if (chart.onSelectionChanged != null) {
          chart.onSelectionChanged(_getSelectionEventArgs(
              seriesRenderer, seriesIndex, currentPointIndex));
        }
        for (int i = 0; i < chart._chartState.selectionData.length; i++) {
          final int selectionIndex = chart._chartState.selectionData[i];
          if (currentPointIndex == selectionIndex) {
            pointStyle = _StyleOptions(
                _selectionArgs != null
                    ? _selectionArgs.selectedColor
                    : selection.selectedColor,
                _selectionArgs != null
                    ? _selectionArgs.selectedBorderWidth
                    : selection.selectedBorderWidth,
                _selectionArgs != null
                    ? _selectionArgs.selectedBorderColor
                    : selection.selectedBorderColor,
                selection.selectedOpacity);
            break;
          } else if (i == chart._chartState.selectionData.length - 1) {
            pointStyle = _StyleOptions(
                _selectionArgs != null
                    ? _selectionArgs.unselectedColor
                    : selection.unselectedColor,
                _selectionArgs != null
                    ? _selectionArgs.unselectedBorderWidth
                    : selection.unselectedBorderWidth,
                _selectionArgs != null
                    ? _selectionArgs.unselectedBorderColor
                    : selection.unselectedBorderColor,
                selection.unselectedOpacity);
          }
        }
      }
    }
    return pointStyle;
  }

  SelectionArgs _getSelectionEventArgs(
      dynamic seriesRenderer, num seriesIndex, num pointIndex) {
    if (seriesRenderer != null) {
      final PyramidSeries<dynamic, dynamic> series = seriesRenderer._series;
      _selectionArgs =
          SelectionArgs(seriesRenderer, seriesIndex, pointIndex, pointIndex);
      _selectionArgs.selectedBorderColor =
          series.selectionSettings.selectedBorderColor;
      _selectionArgs.selectedBorderWidth =
          series.selectionSettings.selectedBorderWidth;
      _selectionArgs.selectedColor = series.selectionSettings.selectedColor;
      _selectionArgs.unselectedBorderColor =
          series.selectionSettings.unselectedBorderColor;
      _selectionArgs.unselectedBorderWidth =
          series.selectionSettings.unselectedBorderWidth;
      _selectionArgs.unselectedColor = series.selectionSettings.unselectedColor;
    }
    return _selectionArgs;
  }
}
