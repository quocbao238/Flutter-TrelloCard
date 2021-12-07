part of charts;

class _SelectionRenderer {
  _SelectionRenderer();
  int pointIndex;
  int seriesIndex;
  int cartesianSeriesIndex;
  int cartesianPointIndex;
  bool isSelection;
  ChartSegment selectedSegment, currentSegment;
  final List<ChartSegment> defaultselectedSegments = <ChartSegment>[];
  final List<ChartSegment> defaultunselectedSegments = <ChartSegment>[];
  // List<ChartPoint<dynamic>> selectedDataPoints = <ChartPoint<dynamic>>[];
  // List<ChartPoint<dynamic>> unselectedDataPoints = <ChartPoint<dynamic>>[];
  // List<_Region> selectedRegions = <_Region>[];
  // List<_Region> unselectedRegions = <_Region>[];
  // ChartPoint<dynamic> currentDataPoint;
  bool isSelected = false;
  dynamic chart;
  dynamic seriesRenderer;
  dynamic fillColor, fillOpacity, strokeColor, strokeOpacity, strokeWidth;
  // _Region currentRegion, selectedRegion;
  // ChartPoint<dynamic> selectedDataPoint;
  SelectionArgs selectionArgs;
  List<ChartSegment> selectedSegments;
  List<ChartSegment> unselectedSegments;
  SelectionType selectionType;

  void selectionIndex(int _pointIndex, int _seriesIndex,
      [SelectionType _selectionType, bool multiSelect]) {
    final List<CartesianSeriesRenderer> seriesRenderList =
        chart._chartSeries.visibleSeriesRenderers;
    final CartesianSeriesRenderer seriesRender = seriesRenderList[_seriesIndex];
    final String seriesType = seriesRenderer._seriesType;
    final dynamic selectionSettings = seriesRender._series.selectionSettings;
    final dynamic selectionRenderer = selectionSettings._selectionRenderer;
    if (_validIndex(_pointIndex, _seriesIndex, chart)) {
      seriesRender._series.selectionSettings._selectionRenderer.selectionType =
          _selectionType;
      bool select = false;
      if (seriesType == 'line' ||
          seriesType == 'spline' ||
          seriesType == 'stepline' ||
          seriesType == 'stackedline' ||
          seriesType == 'stackedline100') {
        if (selectionSettings.enable) {
          selectionRenderer.cartesianPointIndex = _pointIndex;
          selectionRenderer.cartesianSeriesIndex = _seriesIndex;
          select = selectionRenderer.isCartesianSelection(
              chart, seriesRender, _pointIndex, _seriesIndex);
        }
      } else {
        chart._chartState.renderDatalabelRegions = <Rect>[];
        if (seriesType.contains('area') || seriesType == 'fastline') {
          selectionRenderer.seriesIndex = _seriesIndex;
        } else {
          selectionRenderer.seriesIndex = _seriesIndex;
          selectionRenderer.pointIndex = _pointIndex;
        }
        select = selectionRenderer.isCartesianSelection(
            chart, seriesRender, pointIndex, seriesIndex);
      }

      if (select)
        ValueNotifier<int>(chart._chartState.seriesRepaintNotifier.values++);
      selectionType = null;
    }
  }

  /// selection for selected dataPoint index
  void selectedDataPointIndex(
      CartesianSeriesRenderer seriesRenderer, List<int> selectedData) {
    for (int data = 0; data < selectedData.length; data++) {
      final int selectedItem = selectedData[data];
      if (chart.onSelectionChanged != null) {
        // chart.onSelectionChanged(getSelectionEventArgs(
        //     series, selectedItem.seriesIndex, selectedItem.pointIndex));
      }
      for (int j = 0; j < seriesRenderer._segments.length; j++) {
        currentSegment = seriesRenderer._segments[j];
        currentSegment.currentSegmentIndex == selectedItem
            ? selectedSegments.add(seriesRenderer._segments[j])
            : unselectedSegments.add(seriesRenderer._segments[j]);
      }
    }
    _selectedSegmentsColors(selectedSegments);
    _unselectedSegmentsColors(unselectedSegments);
  }

/*  void _selectedDataPointColors(
      List<ChartPoint<dynamic>> selectedDataPoints, dynamic selectionSettings) {
    for (int i = 0; i < selectedDataPoints.length; i++) {
      final Paint fillPaint = getFillColor(true, null, selectedDataPoints[i]);
      final Paint strokePaint =
          getStrokeColor(true, null, selectedDataPoints[i]);
      selectedDataPoints[i].fill =
          selectionSettings.getCircularSelectedItemFill(
              fillPaint.color,
              selectedRegions[i].seriesIndex,
              selectedRegions[i].pointIndex,
              selectedRegions);
      selectedDataPoints[i].strokeColor =
          selectionSettings.getCircularSelectedItemBorder(
              strokePaint.color,
              selectedRegions[i].seriesIndex,
              selectedRegions[i].pointIndex,
              selectedRegions);
      selectedDataPoints[i].strokeWidth = strokePaint.strokeWidth;
    }
  }

  void _unselectedDataPointColors(
      List<ChartPoint<dynamic>> unselectedDataPoints,
      dynamic selectionSettings) {
    for (int i = 0; i < unselectedDataPoints.length; i++) {
      final Paint fillPaint =
          getFillColor(false, null, unselectedDataPoints[i]);
      final Paint strokePaint =
          getStrokeColor(false, null, unselectedDataPoints[i]);
      unselectedDataPoints[i].fill =
          selectionSettings.getCircularUnSelectedItemFill(
              fillPaint.color,
              unselectedRegions[i].seriesIndex,
              unselectedRegions[i].pointIndex,
              unselectedRegions);
      unselectedDataPoints[i].strokeColor =
          selectionSettings.getCircularUnSelectedItemBorder(
              strokePaint.color,
              unselectedRegions[i].seriesIndex,
              unselectedRegions[i].pointIndex,
              unselectedRegions);
      unselectedDataPoints[i].strokeWidth = strokePaint.strokeWidth;
    }
  }
*/
  ///Paint method for default fill color settings
  Paint getDefaultFillColor(
      [List<dynamic> points, int point, ChartSegment segment]) {
    final String seriesType = seriesRenderer._seriesType;
    final Paint selectedFillPaint = Paint();
    if (seriesRenderer._series is CartesianSeries) {
      seriesRenderer._seriesType == 'line' ||
              seriesType == 'spline' ||
              seriesType == 'stepline' ||
              seriesType == 'fastline' ||
              seriesType == 'stackedline' ||
              seriesType == 'stackedline100' ||
              seriesType.contains('hilo')
          ? selectedFillPaint.color = segment._defaultStrokeColor.color
          : selectedFillPaint.color = segment._defaultFillColor.color;
      if (segment._defaultFillColor.shader != null) {
        selectedFillPaint.shader = segment._defaultFillColor.shader;
      }
    }

    if (seriesRenderer._seriesType == 'candle') {
      if (segment is CandleSegment && segment._isSolid) {
        selectedFillPaint.style = PaintingStyle.fill;
        selectedFillPaint.strokeWidth = seriesRenderer._series.borderWidth;
      } else {
        selectedFillPaint.style = PaintingStyle.stroke;
        selectedFillPaint.strokeWidth = seriesRenderer._series.borderWidth;
      }
    } else {
      selectedFillPaint.style = PaintingStyle.fill;
    }
    return selectedFillPaint;
  }

  /* else {
      selectedFillPaint.color = points[point].color.withOpacity(series.opacity);
      points[point].isSelected = false;
    }*/

  ///Paint method for default stroke color settings
  Paint getDefaultStrokeColor(
      [List<dynamic> points, int point, ChartSegment segment]) {
    final Paint selectedStrokePaint = Paint();
    if (seriesRenderer._series is CartesianSeries) {
      selectedStrokePaint.color = segment._defaultStrokeColor.color;
      selectedStrokePaint.strokeWidth = segment._defaultStrokeColor.strokeWidth;
    }
    /* else {
      if (series.borderColor != null)
        selectedStrokePaint.color = series.borderColor;
      if (series.borderWidth != null)
        selectedStrokePaint.strokeWidth = series.borderWidth;
    }*/
    selectedStrokePaint.style = PaintingStyle.stroke;
    return selectedStrokePaint;
  }

  /// Paint method with selected fill color values
  Paint getFillColor(bool isSelection, [ChartSegment segment, dynamic point]) {
    final dynamic selectionSettings = seriesRenderer._series.selectionSettings;
    final dynamic series = seriesRenderer._series;
    final dynamic chartEventSelection = chart.onSelectionChanged;
    if (isSelection) {
      if (series is CartesianSeries) {
        fillColor = chartEventSelection != null &&
                selectionArgs != null &&
                selectionArgs.selectedColor != null
            ? selectionArgs.selectedColor
            : selectionSettings.selectedColor == null
                ? segment._defaultFillColor.color
                : selectionSettings.selectedColor;
      }
      /* else {
        fillColor = chartEventSelection != null &&
                selectionArgs != null &&
                selectionArgs.selectedColor != null
            ? selectionArgs.selectedColor
            : series.selectionSettings.selectedColor == null
                ? point.color
                : series.selectionSettings.selectedColor;
      }*/
      fillOpacity = chartEventSelection != null &&
              selectionArgs != null &&
              selectionArgs.selectedColor != null
          ? selectionArgs.selectedColor.opacity
          : selectionSettings.selectedOpacity == null
              ? series.opacity
              : selectionSettings.selectedOpacity;
    } else {
      if (series is CartesianSeries) {
        fillColor = chartEventSelection != null &&
                selectionArgs != null &&
                selectionArgs.unselectedColor != null
            ? selectionArgs.unselectedColor
            : selectionSettings.unselectedColor == null
                ? segment._defaultFillColor.color
                : selectionSettings.unselectedColor;
      }
      /* else {
        fillColor = chartEventSelection != null &&
                selectionArgs != null &&
                selectionArgs.unselectedColor != null
            ? selectionArgs.unselectedColor
            : series.selectionSettings.unselectedColor == null
                ? point.color
                : series.selectionSettings.unselectedColor;
      }*/
      fillOpacity = chartEventSelection != null &&
              selectionArgs != null &&
              selectionArgs.unselectedColor != null
          ? selectionArgs.unselectedColor.opacity
          : selectionSettings.unselectedOpacity == null
              ? series.opacity
              : selectionSettings.unselectedOpacity;
    }
    final Paint selectedFillPaint = Paint();
    selectedFillPaint.color = fillColor.withOpacity(fillOpacity);
    if (seriesRenderer._seriesType == 'candle') {
      if (segment is CandleSegment && segment._isSolid) {
        selectedFillPaint.style = PaintingStyle.fill;
        selectedFillPaint.strokeWidth = series.borderWidth;
      } else {
        selectedFillPaint.style = PaintingStyle.stroke;
        selectedFillPaint.strokeWidth = series.borderWidth;
      }
    } else {
      selectedFillPaint.style = PaintingStyle.fill;
    }
    return selectedFillPaint;
  }

  /// Paint method with selected stroke color values
  Paint getStrokeColor(bool isSelection,
      [ChartSegment segment, dynamic point]) {
    final dynamic series = seriesRenderer._series;
    final String seriesType = seriesRenderer._seriesType;
    final dynamic selectionSettings = series.selectionSettings;
    final dynamic chartEventSelection = chart.onSelectionChanged;
    if (isSelection) {
      if (series is CartesianSeries) {
        seriesType == 'line' ||
                seriesType == 'spline' ||
                seriesType == 'stepline' ||
                seriesType == 'fastline' ||
                seriesType == 'stackedline' ||
                seriesType == 'stackedline100' ||
                seriesType.contains('hilo') ||
                seriesType == 'candle'
            ? strokeColor = chartEventSelection != null
                ? selectionArgs.selectedColor
                : selectionSettings.selectedColor == null
                    ? segment._defaultFillColor.color
                    : selectionSettings.selectedColor
            : strokeColor = chartEventSelection != null &&
                    selectionArgs != null &&
                    selectionArgs.selectedBorderColor != null
                ? selectionArgs.selectedBorderColor
                : selectionSettings.selectedBorderColor == null
                    ? series.borderColor
                    : selectionSettings.selectedBorderColor;
      }
      /* else {
        strokeColor = chartEventSelection != null &&
                selectionArgs != null &&
                selectionArgs.selectedBorderColor != null
            ? selectionArgs.selectedBorderColor
            : series.selectionSettings.selectedBorderColor == null
                ? series.borderColor
                : series.selectionSettings.selectedBorderColor;
      }*/

      strokeOpacity = chartEventSelection != null &&
              selectionArgs != null &&
              selectionArgs.selectedBorderColor != null
          ? selectionArgs.selectedBorderColor.opacity
          : selectionSettings.selectedOpacity == null
              ? series.opacity
              : selectionSettings.selectedOpacity;

      strokeWidth = chartEventSelection != null &&
              selectionArgs != null &&
              selectionArgs.selectedBorderWidth != null
          ? selectionArgs.selectedBorderWidth
          : selectionSettings.selectedBorderWidth == null
              ? series.borderWidth
              : selectionSettings.selectedBorderWidth;
    } else {
      if (series is CartesianSeries) {
        segment is LineSegment ||
                segment is SplineSegment ||
                segment is StepLineSegment ||
                segment is FastLineSegment ||
                segment is StackedLineSegment ||
                segment is HiloSegment ||
                segment is HiloOpenCloseSegment ||
                segment is CandleSegment
            ? strokeColor = chartEventSelection != null && selectionArgs != null
                ? selectionArgs.unselectedColor
                : selectionSettings.unselectedColor == null
                    ? segment._defaultFillColor.color
                    : selectionSettings.unselectedColor
            : strokeColor = chartEventSelection != null &&
                    selectionArgs != null &&
                    selectionArgs.unselectedBorderColor != null
                ? selectionArgs.unselectedBorderColor
                : selectionSettings.unselectedBorderColor == null
                    ? series.borderColor
                    : selectionSettings.unselectedBorderColor;
      }
      /* else {
        strokeColor = chartEventSelection != null &&
                selectionArgs != null &&
                selectionArgs.unselectedBorderColor != null
            ? selectionArgs.unselectedBorderColor
            : series.selectionSettings.unselectedBorderColor == null
                ? series.borderColor
                : series.selectionSettings.unselectedBorderColor;
      }*/
      strokeOpacity = chartEventSelection != null &&
              selectionArgs != null &&
              selectionArgs.unselectedColor != null
          ? selectionArgs.unselectedColor.opacity
          : selectionSettings.unselectedOpacity == null
              ? series.opacity
              : selectionSettings.unselectedOpacity;
      strokeWidth = chartEventSelection != null &&
              selectionArgs != null &&
              selectionArgs.unselectedBorderWidth != null
          ? selectionArgs.unselectedBorderWidth
          : selectionSettings.unselectedBorderWidth == null
              ? series.borderWidth
              : selectionSettings.unselectedBorderWidth;
    }
    final Paint selectedStrokePaint = Paint();
    selectedStrokePaint.color = strokeColor;
    selectedStrokePaint.strokeWidth = strokeWidth;
    selectedStrokePaint.color.withOpacity(series.opacity);
    selectedStrokePaint.style = PaintingStyle.stroke;
    return selectedStrokePaint;
  }

  /// change color and removing unselected segments from list
/*  void _changeColorAndPopUnselectedDataPoints(
      List<ChartPoint<dynamic>> unselectedDataPoints,
      List<_Region> unselectedRegions) {
    int k = unselectedDataPoints.length - 1;
    while (unselectedDataPoints.isNotEmpty) {
      series =
          chart._chartSeries.visibleSeriesRenderers[unselectedRegions[k].seriesIndex];
      final ChartPoint<dynamic> currentDataPoint =
          seriesRenderer._renderPoints[unselectedRegions[k].pointIndex];
      final Paint fillPaint = getDefaultFillColor(
          seriesRenderer._renderPoints, unselectedRegions[k].pointIndex);
      currentDataPoint.fill =
          fillPaint.color.withOpacity(fillPaint.color.opacity);
      final Paint strokePaint = getDefaultStrokeColor(
          seriesRenderer._renderPoints, unselectedRegions[k].pointIndex);
      currentDataPoint.strokeColor =
          strokePaint.color.withOpacity(strokePaint.color.opacity);
      currentDataPoint.strokeWidth = strokePaint.strokeWidth;
      unselectedDataPoints.remove(unselectedDataPoints[k]);
      unselectedRegions.remove(unselectedRegions[k]);
      k--;
    }
  }

  /// change color and remove selected segments from list
  bool _changeColorAndPopSelectedDataPoints(
      List<ChartPoint<dynamic>> selectedDataPoints,
      List<_Region> selectedRegions,
      bool isSamePointSelect) {
    int j = selectedDataPoints.length - 1;
    while (selectedDataPoints.isNotEmpty) {
      series = chart._chartSeries.visibleSeriesRenderers[selectedRegions[j].seriesIndex];
      final ChartPoint<dynamic> currentDataPoint =
          seriesRenderer._renderPoints[selectedRegions[j].pointIndex];
      final Paint fillPaint = getDefaultFillColor(
          seriesRenderer._renderPoints, selectedRegions[j].pointIndex);
      currentDataPoint.fill =
          fillPaint.color.withOpacity(fillPaint.color.opacity);
      final Paint strokePaint = getDefaultStrokeColor(
          seriesRenderer._renderPoints, selectedRegions[j].pointIndex);
      currentDataPoint.strokeColor =
          strokePaint.color.withOpacity(strokePaint.color.opacity);
      currentDataPoint.strokeWidth = strokePaint.strokeWidth;
      if (selectedRegions[j].pointIndex == pointIndex &&
          selectedRegions[j].seriesIndex == seriesIndex)
        isSamePointSelect = true;
      selectedDataPoints.remove(selectedDataPoints[j]);
      selectedRegions.remove(selectedRegions[j]);
      j--;
    }
    return isSamePointSelect;
  }
*/
  /// Give selected color for selected segments
  void _selectedSegmentsColors(List<ChartSegment> selectedSegments) {
    for (int i = 0; i < selectedSegments.length; i++) {
      seriesRenderer = chart._chartSeries
          .visibleSeriesRenderers[selectedSegments[i]._seriesIndex];
      if (!seriesRenderer._seriesType.contains('area') &&
          seriesRenderer._seriesType != 'fastline') {
        final ChartSegment currentSegment =
            seriesRenderer._segments[selectedSegments[i].currentSegmentIndex];
        final Paint fillPaint = getFillColor(true, currentSegment);
        currentSegment.fillPaint = seriesRenderer._series.selectionSettings
            .getSelectedItemFill(fillPaint, selectedSegments[i]._seriesIndex,
                selectedSegments[i].currentSegmentIndex, selectedSegments);
        final Paint strokePaint = getStrokeColor(true, currentSegment);
        currentSegment.strokePaint = seriesRenderer._series.selectionSettings
            .getSelectedItemBorder(
                strokePaint,
                selectedSegments[i]._seriesIndex,
                selectedSegments[i].currentSegmentIndex,
                selectedSegments);
      } else {
        final ChartSegment currentSegment = seriesRenderer._segments[0];
        final Paint fillPaint = getFillColor(true, currentSegment);
        currentSegment.fillPaint = seriesRenderer._series.selectionSettings
            .getSelectedItemFill(fillPaint, selectedSegments[i]._seriesIndex,
                selectedSegments[i].currentSegmentIndex, selectedSegments);
        final Paint strokePaint = getStrokeColor(true, currentSegment);
        currentSegment.strokePaint = seriesRenderer._series.selectionSettings
            .getSelectedItemBorder(
                strokePaint,
                selectedSegments[i]._seriesIndex,
                selectedSegments[i].currentSegmentIndex,
                selectedSegments);
      }
    }
  }

  /// Give unselected color for unselected segments
  void _unselectedSegmentsColors(List<ChartSegment> unselectedSegments) {
    for (int i = 0; i < unselectedSegments.length; i++) {
      seriesRenderer = chart._chartSeries
          .visibleSeriesRenderers[unselectedSegments[i]._seriesIndex];
      if (!seriesRenderer._seriesType.contains('area') &&
          seriesRenderer._seriesType != 'fastline') {
        final ChartSegment currentSegment =
            seriesRenderer._segments[unselectedSegments[i].currentSegmentIndex];
        final Paint fillPaint = getFillColor(false, currentSegment);
        currentSegment.fillPaint = seriesRenderer._series.selectionSettings
            .getUnselectedItemFill(
                fillPaint,
                unselectedSegments[i]._seriesIndex,
                unselectedSegments[i].currentSegmentIndex,
                unselectedSegments);
        final Paint strokePaint = getStrokeColor(false, currentSegment);
        currentSegment.strokePaint = seriesRenderer._series.selectionSettings
            .getUnselectedItemBorder(
                strokePaint,
                unselectedSegments[i]._seriesIndex,
                unselectedSegments[i].currentSegmentIndex,
                unselectedSegments);
      } else {
        final ChartSegment currentSegment = seriesRenderer._segments[0];
        final Paint fillPaint = getFillColor(false, currentSegment);
        currentSegment.fillPaint = seriesRenderer._series.selectionSettings
            .getUnselectedItemFill(
                fillPaint,
                unselectedSegments[i]._seriesIndex,
                unselectedSegments[i].currentSegmentIndex,
                unselectedSegments);
        final Paint strokePaint = getStrokeColor(false, currentSegment);
        currentSegment.strokePaint = seriesRenderer._series.selectionSettings
            .getUnselectedItemBorder(
                strokePaint,
                unselectedSegments[i]._seriesIndex,
                unselectedSegments[i].currentSegmentIndex,
                unselectedSegments);
      }
    }
  }

  /// change color and removing unselected segments from list
  void changeColorAndPopUnselectedSegments(
      List<ChartSegment> unselectedSegments) {
    int k = unselectedSegments.length - 1;
    while (unselectedSegments.isNotEmpty) {
      seriesRenderer = chart._chartSeries
          .visibleSeriesRenderers[unselectedSegments[k]._seriesIndex];
      if (!seriesRenderer._seriesType.contains('area') &&
          seriesRenderer._seriesType != 'fastline') {
        final ChartSegment currentSegment =
            seriesRenderer._segments[unselectedSegments[k].currentSegmentIndex];
        final Paint fillPaint = getDefaultFillColor(null, null, currentSegment);
        currentSegment.fillPaint = fillPaint;
        final Paint strokePaint =
            getDefaultStrokeColor(null, null, currentSegment);
        currentSegment.strokePaint = strokePaint;
        unselectedSegments.remove(unselectedSegments[k]);
        k--;
      } else {
        final ChartSegment currentSegment = seriesRenderer._segments[0];
        final Paint fillPaint = getDefaultFillColor(null, null, currentSegment);
        currentSegment.fillPaint = fillPaint;
        final Paint strokePaint =
            getDefaultStrokeColor(null, null, currentSegment);
        currentSegment.strokePaint = strokePaint;
        unselectedSegments.remove(unselectedSegments[0]);
        k--;
      }
    }
  }

  /// change color and remove selected segments from list
  bool changeColorAndPopSelectedSegments(
      List<ChartSegment> selectedSegments, bool isSamePointSelect) {
    int j = selectedSegments.length - 1;
    while (selectedSegments.isNotEmpty) {
      seriesRenderer = chart._chartSeries
          .visibleSeriesRenderers[selectedSegments[j]._seriesIndex];
      if (!seriesRenderer._seriesType.contains('area') &&
          seriesRenderer._seriesType != 'fastline') {
        final ChartSegment currentSegment =
            seriesRenderer._segments[selectedSegments[j].currentSegmentIndex];
        final Paint fillPaint = getDefaultFillColor(null, null, currentSegment);
        currentSegment.fillPaint = fillPaint;
        final Paint strokePaint =
            getDefaultStrokeColor(null, null, currentSegment);
        currentSegment.strokePaint = strokePaint;
        if (seriesRenderer._seriesType == 'line' ||
            seriesRenderer._seriesType == 'spline' ||
            seriesRenderer._seriesType == 'stepline' ||
            seriesRenderer._seriesType == 'stackedline' ||
            seriesRenderer._seriesType == 'stackedline100' ||
            seriesRenderer._seriesType.contains('hilo') ||
            seriesRenderer._seriesType == 'candle') {
          if (selectedSegments[j].currentSegmentIndex == cartesianPointIndex &&
              selectedSegments[j]._seriesIndex == cartesianSeriesIndex)
            isSamePointSelect = true;
        } else {
          if (selectedSegments[j].currentSegmentIndex == pointIndex &&
              selectedSegments[j]._seriesIndex == seriesIndex)
            isSamePointSelect = true;
        }
        selectedSegments.remove(selectedSegments[j]);
        j--;
      } else {
        final ChartSegment currentSegment = seriesRenderer._segments[0];
        final Paint fillPaint = getDefaultFillColor(null, null, currentSegment);
        currentSegment.fillPaint = fillPaint;
        final Paint strokePaint =
            getDefaultStrokeColor(null, null, currentSegment);
        currentSegment.strokePaint = strokePaint;
        if (selectedSegments[0]._seriesIndex == seriesIndex)
          isSamePointSelect = true;
        selectedSegments.remove(selectedSegments[0]);
        j--;
      }
    }
    return isSamePointSelect;
  }

  ChartSegment getTappedSegment() {
    for (int i = 0; i < chart._chartSeries.visibleSeriesRenderers.length; i++) {
      final CartesianSeriesRenderer seriesRenderer =
          chart._chartSeries.visibleSeriesRenderers[i];
      for (int k = 0; k < seriesRenderer._segments.length; k++) {
        if (!seriesRenderer._seriesType.contains('area') &&
            seriesRenderer._seriesType != 'fastline') {
          currentSegment = seriesRenderer._segments[k];
          if (seriesRenderer._seriesType == 'line' ||
              seriesRenderer._seriesType == 'spline' ||
              seriesRenderer._seriesType == 'stepline' ||
              seriesRenderer._seriesType == 'stackedline' ||
              seriesRenderer._seriesType == 'stackedline100' ||
              seriesRenderer._seriesType.contains('hilo') ||
              seriesRenderer._seriesType == 'candle') {
            if (currentSegment.currentSegmentIndex == cartesianPointIndex &&
                currentSegment._seriesIndex == cartesianSeriesIndex) {
              selectedSegment = seriesRenderer._segments[k];
            }
          } else {
            if (currentSegment.currentSegmentIndex == pointIndex &&
                currentSegment._seriesIndex == seriesIndex) {
              selectedSegment = seriesRenderer._segments[k];
            }
          }
        } else {
          currentSegment = seriesRenderer._segments[0];
          if (currentSegment._seriesIndex == seriesIndex) {
            selectedSegment = seriesRenderer._segments[0];
            break;
          }
        }
      }
    }
    return selectedSegment;
  }

  bool checkPosition() {
    outerLoop:
    for (int i = 0; i < chart._chartSeries.visibleSeriesRenderers.length; i++) {
      final CartesianSeriesRenderer seriesRenderer =
          chart._chartSeries.visibleSeriesRenderers[i];
      for (int k = 0; k < seriesRenderer._segments.length; k++) {
        currentSegment = seriesRenderer._segments[k];
        if (currentSegment.currentSegmentIndex == pointIndex &&
            currentSegment._seriesIndex == seriesIndex) {
          isSelected = true;
          break outerLoop;
        } else
          isSelected = false;
      }
    }
    return isSelected;
  }

  /// To ensure selection for cartesian chart type
  bool isCartesianSelection(SfCartesianChart chartAssign,
      CartesianSeriesRenderer seriesAssign, int pointIndex, int seriesIndex) {
    chart = chartAssign;
    seriesRenderer = seriesAssign;

    if (chart.onSelectionChanged != null) {
      chart.onSelectionChanged(getSelectionEventArgs(
          seriesRenderer._series, seriesIndex, pointIndex, seriesRenderer));
    }

    /// For point mode
    if ((selectionType ?? chart.selectionType) == SelectionType.point) {
      bool isSamePointSelect = false;

      /// UnSelecting the last selected segment
      if (selectedSegments.length == 1)
        changeColorAndPopUnselectedSegments(unselectedSegments);

      /// Executes when multiSelection is enabled
      bool multiSelect = false;
      if (chart.enableMultiSelection) {
        if (selectedSegments.isNotEmpty) {
          for (int i = chart._chartSeries.visibleSeriesRenderers.length - 1;
              i >= 0;
              i--) {
            final CartesianSeriesRenderer seriesRenderer =
                chart._chartSeries.visibleSeriesRenderers[i];

            /// To identify the tapped segment
            for (int k = 0; k < seriesRenderer._segments.length; k++) {
              currentSegment = seriesRenderer._segments[k];
              if (currentSegment.currentSegmentIndex == pointIndex &&
                  currentSegment._seriesIndex == seriesIndex) {
                selectedSegment = seriesRenderer._segments[k];
                break;
              }
            }
          }

          /// To identify that tapped segment in any one of the selected segment
          if (selectedSegment != null) {
            for (int k = 0; k < selectedSegments.length; k++) {
              if (selectedSegment._currentPoint ==
                  selectedSegments[k]._currentPoint) {
                multiSelect = true;
                break;
              }
            }
          }

          /// Executes when tapped again in one of the selected segments
          if (multiSelect) {
            for (int j = selectedSegments.length - 1; j >= 0; j--) {
              seriesRenderer = chart._chartSeries
                  .visibleSeriesRenderers[selectedSegments[j]._seriesIndex];
              final ChartSegment currentSegment = seriesRenderer
                  ._segments[selectedSegments[j].currentSegmentIndex];

              /// Applying default settings when last selected segment becomes unselected
              if ((selectedSegment._currentPoint ==
                      selectedSegments[j]._currentPoint) &&
                  (selectedSegments.length == 1)) {
                final Paint fillPaint =
                    getDefaultFillColor(null, null, currentSegment);
                final Paint strokePaint =
                    getDefaultStrokeColor(null, null, currentSegment);
                currentSegment.fillPaint = fillPaint;
                currentSegment.strokePaint = strokePaint;

                if (selectedSegments[j].currentSegmentIndex == pointIndex &&
                    selectedSegments[j]._seriesIndex == seriesIndex)
                  isSamePointSelect = true;
                selectedSegments.remove(selectedSegments[j]);
              }

              /// Applying unselected color for unselected segments in multiSelect option
              else if (selectedSegment._currentPoint ==
                  selectedSegments[j]._currentPoint) {
                final Paint fillPaint = getFillColor(false, currentSegment);
                currentSegment.fillPaint = fillPaint;
                final Paint strokePaint = getStrokeColor(false, currentSegment);
                currentSegment.strokePaint = strokePaint;

                if (selectedSegments[j].currentSegmentIndex == pointIndex &&
                    selectedSegments[j]._seriesIndex == seriesIndex)
                  isSamePointSelect = true;
                unselectedSegments.add(selectedSegments[j]);
                selectedSegments.remove(selectedSegments[j]);
              }
            }
          }
        }
      } else
        isSamePointSelect = changeColorAndPopSelectedSegments(
            selectedSegments, isSamePointSelect);

      /// To check that the selection setting is enable or not
      if (seriesRenderer._series.selectionSettings.enable) {
        if (!isSamePointSelect) {
          seriesRenderer._seriesType == 'column' ||
                  seriesRenderer._seriesType == 'bar' ||
                  seriesRenderer._seriesType == 'scatter' ||
                  seriesRenderer._seriesType == 'bubble' ||
                  seriesRenderer._seriesType.contains('stackedcolumn') ||
                  seriesRenderer._seriesType.contains('stackedbar') ||
                  seriesRenderer._seriesType == 'rangecolumn'
              ? isSelected = checkPosition()
              : isSelected = true;
          for (int i = chart._chartSeries.visibleSeriesRenderers.length - 1;
              i >= 0;
              i--) {
            final CartesianSeriesRenderer seriesRenderer =
                chart._chartSeries.visibleSeriesRenderers[i];
            if (isSelected) {
              for (int j = 0; j < seriesRenderer._segments.length; j++) {
                currentSegment = seriesRenderer._segments[j];
                if (currentSegment.currentSegmentIndex == null ||
                    pointIndex == null) {
                  break;
                }
                currentSegment.currentSegmentIndex == pointIndex &&
                        currentSegment._seriesIndex == seriesIndex
                    ? selectedSegments.add(seriesRenderer._segments[j])
                    : unselectedSegments.add(seriesRenderer._segments[j]);
              }

              /// Giving color to unselected segments
              _unselectedSegmentsColors(unselectedSegments);

              /// Giving Color to selected segments
              _selectedSegmentsColors(selectedSegments);
            }
          }
        }
      }
    }

    ///For Series Mode
    else if ((selectionType ?? chart.selectionType) == SelectionType.series) {
      bool isSamePointSelect = false;

      for (int i = 0;
          i < chart._chartSeries.visibleSeriesRenderers.length;
          i++) {
        final CartesianSeriesRenderer seriesRenderer =
            chart._chartSeries.visibleSeriesRenderers[i];
        for (int k = 0; k < seriesRenderer._segments.length; k++) {
          currentSegment = seriesRenderer._segments[k];
          final ChartSegment compareSegment = seriesRenderer._segments[k];
          if (currentSegment.segmentRect != compareSegment.segmentRect)
            isSelected = false;
        }
      }

      /// Executes only when final selected segment became unselected
      if (selectedSegments.length == seriesRenderer._segments.length)
        changeColorAndPopUnselectedSegments(unselectedSegments);

      /// Executes when multiSelect option is enabled
      bool multiSelect = false;
      if (chart.enableMultiSelection) {
        if (selectedSegments.isNotEmpty) {
          selectedSegment = getTappedSegment();

          /// To identify that tapped again in any one of the selected segments
          if (selectedSegment != null) {
            for (int k = 0; k < selectedSegments.length; k++) {
              if (seriesIndex == selectedSegments[k]._seriesIndex) {
                multiSelect = true;
                break;
              }
            }
          }

          /// Executes when tapped again in one of the selected segments
          if (multiSelect) {
            ChartSegment currentSegment;
            for (int j = selectedSegments.length - 1; j >= 0; j--) {
              seriesRenderer = chart._chartSeries
                  .visibleSeriesRenderers[selectedSegments[j]._seriesIndex];

              if (!seriesRenderer._seriesType.contains('area') &&
                  seriesRenderer._seriesType != 'fastline')
                currentSegment = seriesRenderer
                    ._segments[selectedSegments[j].currentSegmentIndex];
              else
                currentSegment = seriesRenderer._segments[0];

              /// Applying series fill when all last selected segment becomes unselected
              if (!seriesRenderer._seriesType.contains('area') &&
                  seriesRenderer._seriesType != 'fastline') {
                if ((selectedSegment._seriesIndex ==
                        selectedSegments[j]._seriesIndex) &&
                    (selectedSegments.length <=
                        seriesRenderer._segments.length)) {
                  final Paint fillPaint =
                      getDefaultFillColor(null, null, currentSegment);
                  final Paint strokePaint =
                      getDefaultStrokeColor(null, null, currentSegment);
                  currentSegment.fillPaint = fillPaint;
                  currentSegment.strokePaint = strokePaint;
                  if (selectedSegments[j].currentSegmentIndex == pointIndex &&
                      selectedSegments[j]._seriesIndex == seriesIndex)
                    isSamePointSelect = true;
                  selectedSegments.remove(selectedSegments[j]);
                }

                /// Applying unselected color for unselected segments in multiSelect option
                else if (selectedSegment._seriesIndex ==
                    selectedSegments[j]._seriesIndex) {
                  final Paint fillPaint = getFillColor(false, currentSegment);
                  final Paint strokePaint =
                      getStrokeColor(false, currentSegment);
                  currentSegment.fillPaint = fillPaint;
                  currentSegment.strokePaint = strokePaint;
                  if (selectedSegments[j].currentSegmentIndex == pointIndex &&
                      selectedSegments[j]._seriesIndex == seriesIndex)
                    isSamePointSelect = true;
                  unselectedSegments.add(selectedSegments[j]);
                  selectedSegments.remove(selectedSegments[j]);
                }
              } else {
                if ((selectedSegment._seriesIndex ==
                        selectedSegments[j]._seriesIndex) &&
                    (selectedSegments.length <=
                        seriesRenderer._segments.length)) {
                  final Paint fillPaint =
                      getDefaultFillColor(null, null, currentSegment);
                  final Paint strokePaint =
                      getDefaultStrokeColor(null, null, currentSegment);
                  currentSegment.fillPaint = fillPaint;
                  currentSegment.strokePaint = strokePaint;
                  if (selectedSegments[j]._seriesIndex == seriesIndex)
                    isSamePointSelect = true;
                  selectedSegments.remove(selectedSegments[j]);
                }

                /// Applying unselected color for unselected segments in multiSelect option
                else if (selectedSegment._seriesIndex ==
                    selectedSegments[j]._seriesIndex) {
                  final Paint fillPaint = getFillColor(false, currentSegment);
                  final Paint strokePaint =
                      getStrokeColor(false, currentSegment);
                  currentSegment.fillPaint = fillPaint;
                  currentSegment.strokePaint = strokePaint;
                  if (selectedSegments[j]._seriesIndex == seriesIndex)
                    isSamePointSelect = true;
                  unselectedSegments.add(selectedSegments[j]);
                  selectedSegments.remove(selectedSegments[j]);
                }
              }
            }
          }
        }
      }

      ///Executes when multiSelect is not enable
      else
        isSamePointSelect = changeColorAndPopSelectedSegments(
            selectedSegments, isSamePointSelect);

      /// To identify the Tapped segment
      if (seriesRenderer._series.selectionSettings.enable) {
        if (!isSamePointSelect) {
          seriesRenderer._seriesType == 'column' ||
                  seriesRenderer._seriesType == 'bar' ||
                  seriesRenderer._seriesType == 'scatter' ||
                  seriesRenderer._seriesType == 'bubble' ||
                  seriesRenderer._seriesType.contains('stackedcolumn') ||
                  seriesRenderer._seriesType.contains('stackedbar') ||
                  seriesRenderer._seriesType == 'rangecolumn'
              ? isSelected = checkPosition()
              : isSelected = true;
          selectedSegment = getTappedSegment();
          if (isSelected) {
            /// To Push the Selected and Unselected segment
            for (int i = 0;
                i < chart._chartSeries.visibleSeriesRenderers.length;
                i++) {
              final CartesianSeriesRenderer seriesRenderer =
                  chart._chartSeries.visibleSeriesRenderers[i];
              if (!seriesRenderer._seriesType.contains('area') &&
                  seriesRenderer._seriesType != 'fastline') {
                if (seriesIndex != null) {
                  for (int k = 0; k < seriesRenderer._segments.length; k++) {
                    currentSegment = seriesRenderer._segments[k];
                    currentSegment._seriesIndex == seriesIndex
                        ? selectedSegments.add(seriesRenderer._segments[k])
                        : unselectedSegments.add(seriesRenderer._segments[k]);
                  }
                }
              } else {
                currentSegment = seriesRenderer._segments[0];
                currentSegment._seriesIndex == seriesIndex
                    ? selectedSegments.add(seriesRenderer._segments[0])
                    : unselectedSegments.add(seriesRenderer._segments[0]);
              }

              /// Give Color to the Unselected segment
              _unselectedSegmentsColors(unselectedSegments);

              /// Give Color to the Selected segment
              _selectedSegmentsColors(selectedSegments);
            }
          }
        }
      }
    }

    /// For Cluster Mode
    else if ((selectionType ?? chart.selectionType) == SelectionType.cluster) {
      bool isSamePointSelect = false;

      /// Executes only when last selected segment became unselected
      if (selectedSegments.length ==
          chart._chartSeries.visibleSeriesRenderers.length)
        changeColorAndPopUnselectedSegments(unselectedSegments);

      /// Executes when multiSelect option is enabled
      bool multiSelect = false;
      if (chart.enableMultiSelection) {
        if (selectedSegments.isNotEmpty) {
          selectedSegment = getTappedSegment();

          /// To identify that tapped again in any one of the selected segment
          if (selectedSegment != null) {
            for (int k = 0; k < selectedSegments.length; k++) {
              if (selectedSegment.currentSegmentIndex ==
                  selectedSegments[k].currentSegmentIndex) {
                multiSelect = true;
                break;
              }
            }
          }

          /// Executes when tapped again in one of the selected segment
          if (multiSelect) {
            for (int j = selectedSegments.length - 1; j >= 0; j--) {
              seriesRenderer = chart._chartSeries
                  .visibleSeriesRenderers[selectedSegments[j]._seriesIndex];
              final ChartSegment currentSegment = seriesRenderer
                  ._segments[selectedSegments[j].currentSegmentIndex];

              /// Applying default settings when last selected segment becomes unselected
              if ((selectedSegment.currentSegmentIndex ==
                      selectedSegments[j].currentSegmentIndex) &&
                  (selectedSegments.length <=
                      chart._chartSeries.visibleSeriesRenderers.length)) {
                final Paint fillPaint =
                    getDefaultFillColor(null, null, currentSegment);
                final Paint strokePaint =
                    getDefaultStrokeColor(null, null, currentSegment);
                currentSegment.fillPaint = fillPaint;
                currentSegment.strokePaint = strokePaint;

                if (selectedSegments[j].currentSegmentIndex == pointIndex &&
                    selectedSegments[j]._seriesIndex == seriesIndex)
                  isSamePointSelect = true;

                selectedSegments.remove(selectedSegments[j]);
              }

              /// Applying unselected color for unselected segment in multiSelect option
              else if (selectedSegment.currentSegmentIndex ==
                  selectedSegments[j].currentSegmentIndex) {
                final Paint fillPaint = getFillColor(false, currentSegment);
                final Paint strokePaint = getStrokeColor(false, currentSegment);
                currentSegment.fillPaint = fillPaint;
                currentSegment.strokePaint = strokePaint;

                if (selectedSegments[j].currentSegmentIndex == pointIndex &&
                    selectedSegments[j]._seriesIndex == seriesIndex)
                  isSamePointSelect = true;

                unselectedSegments.add(selectedSegments[j]);
                selectedSegments.remove(selectedSegments[j]);
              }
            }
          }
        }
      }

      ///Executes when multiSelect is not enable
      else
        isSamePointSelect = changeColorAndPopSelectedSegments(
            selectedSegments, isSamePointSelect);

      /// To identify the Tapped segment
      if (seriesRenderer._series.selectionSettings.enable) {
        if (!isSamePointSelect) {
          final bool isSegmentSeries = seriesRenderer._seriesType == 'column' ||
              seriesRenderer._seriesType == 'bar' ||
              seriesRenderer._seriesType == 'scatter' ||
              seriesRenderer._seriesType == 'bubble' ||
              seriesRenderer._seriesType.contains('stackedcolumn') ||
              seriesRenderer._seriesType.contains('stackedbar') ||
              seriesRenderer._seriesType == 'rangecolumn';
          selectedSegment = getTappedSegment();
          isSegmentSeries ? isSelected = checkPosition() : isSelected = true;
          if (isSelected) {
            /// To Push the Selected and Unselected segments
            for (int i = 0;
                i < chart._chartSeries.visibleSeriesRenderers.length;
                i++) {
              final CartesianSeriesRenderer seriesRenderer =
                  chart._chartSeries.visibleSeriesRenderers[i];
              if (seriesRenderer._series.selectionSettings.enable) {
                if (currentSegment.currentSegmentIndex == null ||
                    pointIndex == null) {
                  break;
                }
                for (int k = 0; k < seriesRenderer._segments.length; k++) {
                  currentSegment = seriesRenderer._segments[k];

                  if (isSegmentSeries) {
                    currentSegment._currentPoint.xValue ==
                            selectedSegment._currentPoint.xValue
                        ? selectedSegments.add(seriesRenderer._segments[k])
                        : unselectedSegments.add(seriesRenderer._segments[k]);
                  } else {
                    currentSegment.currentSegmentIndex ==
                            selectedSegment.currentSegmentIndex
                        ? selectedSegments.add(seriesRenderer._segments[k])
                        : unselectedSegments.add(seriesRenderer._segments[k]);
                  }
                }
              }
            }

            /// Giving color to unselected segments
            _unselectedSegmentsColors(unselectedSegments);

            /// Giving Color to selected segments
            _selectedSegmentsColors(selectedSegments);
          }
        }
      }
    }
    return isSelected;
  }

// To get point index and series index
  void getPointAndSeriesIndex(SfCartesianChart chart, Offset position,
      CartesianSeriesRenderer seriesRenderer) {
    ChartSegment currentSegment, selectedSegment;
    for (int k = 0; k < seriesRenderer._segments.length; k++) {
      currentSegment = seriesRenderer._segments[k];
      if (currentSegment.segmentRect.contains(position)) {
        selectedSegment = seriesRenderer._segments[k];
      }
    }
    if (selectedSegment == null) {
      seriesRenderer._series.selectionSettings._selectionRenderer.pointIndex =
          null;
      seriesRenderer._series.selectionSettings._selectionRenderer.seriesIndex =
          null;
    } else {
      seriesRenderer._series.selectionSettings._selectionRenderer.pointIndex =
          selectedSegment.currentSegmentIndex;
      seriesRenderer._series.selectionSettings._selectionRenderer.seriesIndex =
          selectedSegment._seriesIndex;
    }
  }

// To check that touch point is lies in segment
  bool isLineIntersect(
      CartesianChartPoint<dynamic> segmentStartPoint,
      CartesianChartPoint<dynamic> segmentEndPoint,
      CartesianChartPoint<dynamic> touchStartPoint,
      CartesianChartPoint<dynamic> touchEndPoint) {
    final int topPos =
        getPointDirection(segmentStartPoint, segmentEndPoint, touchStartPoint);
    final int botPos =
        getPointDirection(segmentStartPoint, segmentEndPoint, touchEndPoint);
    final int leftPos =
        getPointDirection(touchStartPoint, touchEndPoint, segmentStartPoint);
    final int rightPos =
        getPointDirection(touchStartPoint, touchEndPoint, segmentEndPoint);

    return topPos != botPos && leftPos != rightPos;
  }

  /// To get the segment points direction
  static int getPointDirection(
      CartesianChartPoint<dynamic> point1,
      CartesianChartPoint<dynamic> point2,
      CartesianChartPoint<dynamic> point3) {
    final int value = (((point2.y - point1.y) * (point3.x - point2.x)) -
            ((point2.x - point1.x) * (point3.y - point2.y)))
        .toInt();

    if (value == 0) {
      return 0;
    }

    return (value > 0) ? 1 : 2;
  }

  /// To identify that series contains a given point
  bool _isSeriesContainsPoint(dynamic seriesRenderer, Offset position) {
    dynamic dataPointIndex;
    ChartSegment startSegment;
    ChartSegment endSegment;
    final List<dynamic> nearestDataPoints = _getNearestChartPoints(
        position.dx,
        position.dy,
        seriesRenderer._xAxis,
        seriesRenderer._yAxis,
        seriesRenderer);
    if (nearestDataPoints == null) {
      return false;
    }
    for (dynamic dataPoint in nearestDataPoints) {
      dataPointIndex = seriesRenderer._dataPoints.indexOf(dataPoint);
    }

    if (dataPointIndex != null && seriesRenderer._segments.isNotEmpty) {
      if (seriesRenderer._seriesType.contains('hilo') ||
          seriesRenderer._seriesType == 'candle') {
        startSegment = seriesRenderer._segments[dataPointIndex];
        //  endSegment = series.segments[dataPointIndex];
      } else {
        if (dataPointIndex == 0)
          startSegment = seriesRenderer._segments[dataPointIndex];
        else if (dataPointIndex == seriesRenderer._dataPoints.length - 1)
          startSegment = seriesRenderer._segments[dataPointIndex - 1];
        else {
          startSegment = seriesRenderer._segments[dataPointIndex - 1];
          endSegment = seriesRenderer._segments[dataPointIndex];
        }
      }
      startSegment != null
          ? cartesianSeriesIndex = startSegment._seriesIndex
          : cartesianSeriesIndex = endSegment._seriesIndex;

      startSegment != null
          ? cartesianPointIndex = startSegment.currentSegmentIndex
          : cartesianPointIndex = endSegment.currentSegmentIndex;

      if (startSegment != null) {
        if (_isSegmentIntersect(startSegment, position.dx, position.dy)) {
          return true;
        }
      }

      if (endSegment != null)
        return _isSegmentIntersect(endSegment, position.dx, position.dy);
    }
    return false;
  }

  /// To identify the cartesian point index
  int getCartesianPointIndex(Offset position) {
    final List<dynamic> firstNearestDataPoints = <dynamic>[];
    dynamic previousIndex, nextIndex;
    dynamic dataPointIndex,
        previousDataPointIndex,
        nextDataPointIndex,
        nearestDataPointIndex;
    final List<dynamic> nearestDataPoints = _getNearestChartPoints(
        position.dx,
        position.dy,
        seriesRenderer._xAxis,
        seriesRenderer._yAxis,
        seriesRenderer);

    for (dynamic dataPoint in nearestDataPoints) {
      dataPointIndex = seriesRenderer._dataPoints.indexOf(dataPoint);
      previousIndex = seriesRenderer._dataPoints.indexOf(dataPoint) - 1;
      previousIndex < 0
          ? previousDataPointIndex = dataPointIndex
          : previousDataPointIndex = previousIndex;
      nextIndex = seriesRenderer._dataPoints.indexOf(dataPoint) + 1;
      nextIndex > seriesRenderer._dataPoints.length - 1
          ? nextDataPointIndex = dataPointIndex
          : nextDataPointIndex = nextIndex;
    }

    firstNearestDataPoints
        .add(seriesRenderer._dataPoints[previousDataPointIndex]);
    firstNearestDataPoints.add(seriesRenderer._dataPoints[nextDataPointIndex]);
    final List<dynamic> firstNearestPoints = _getNearestChartPoints(
        position.dx,
        position.dy,
        seriesRenderer._xAxis,
        seriesRenderer._yAxis,
        seriesRenderer,
        firstNearestDataPoints);

    for (dynamic dataPoint in firstNearestPoints) {
      if (seriesRenderer._seriesType.contains('hilo') ||
          seriesRenderer._seriesType == 'candle') {
        nearestDataPointIndex = dataPointIndex;
      } else {
        if (dataPointIndex < seriesRenderer._dataPoints.indexOf(dataPoint))
          nearestDataPointIndex = dataPointIndex;
        else if (dataPointIndex ==
            seriesRenderer._dataPoints.indexOf(dataPoint)) {
          seriesRenderer._dataPoints.indexOf(dataPoint) - 1 < 0
              ? nearestDataPointIndex =
                  seriesRenderer._dataPoints.indexOf(dataPoint)
              : nearestDataPointIndex =
                  seriesRenderer._dataPoints.indexOf(dataPoint) - 1;
        } else
          nearestDataPointIndex = seriesRenderer._dataPoints.indexOf(dataPoint);
      }
    }
    seriesRenderer._series.selectionSettings._selectionRenderer
        .cartesianPointIndex = nearestDataPointIndex;
    return nearestDataPointIndex;
  }

  /// To know the segment is intersect with touch point
  bool _isSegmentIntersect(
      ChartSegment segment, double touchX1, double touchY1) {
    dynamic currentSegment, x1, x2, y1, y2;
    if (segment is LineSegment ||
        segment is SplineSegment ||
        segment is StepLineSegment ||
        segment is StackedLineSegment ||
        segment is HiloSegment ||
        segment is HiloOpenCloseSegment ||
        segment is CandleSegment ||
        segment is StackedLine100Segment) {
      currentSegment = segment;
    }
    x1 = currentSegment is HiloSegment ||
            currentSegment is HiloOpenCloseSegment ||
            currentSegment is CandleSegment
        ? currentSegment.x
        : currentSegment.x1;
    if (currentSegment is HiloSegment ||
        currentSegment is HiloOpenCloseSegment ||
        currentSegment is CandleSegment) {
      y1 = currentSegment.low;
      x2 = currentSegment.x;
      y2 = currentSegment.high;
    } else {
      y1 = currentSegment is StackedLineSegment ||
              currentSegment is StackedLine100Segment
          ? currentSegment.currentCummulativeValue
          : currentSegment.y1;
      x2 = currentSegment.x2;
      y2 = currentSegment is StackedLineSegment ||
              currentSegment is StackedLine100Segment
          ? currentSegment.nextCummulativeValue
          : currentSegment.y2;
    }

    final dynamic leftPoint =
        CartesianChartPoint<dynamic>(touchX1 - 20, touchY1 - 20);
    final dynamic rightPoint =
        CartesianChartPoint<dynamic>(touchX1 + 20, touchY1 + 20);
    final dynamic topPoint =
        CartesianChartPoint<dynamic>(touchX1 + 20, touchY1 - 20);
    final dynamic bottomPoint =
        CartesianChartPoint<dynamic>(touchX1 - 20, touchY1 + 20);

    final CartesianChartPoint<dynamic> startSegment =
        CartesianChartPoint<dynamic>(x1, y1);
    final CartesianChartPoint<dynamic> endSegment =
        CartesianChartPoint<dynamic>(x2, y2);

    if (isLineIntersect(startSegment, endSegment, leftPoint, rightPoint) ||
        isLineIntersect(startSegment, endSegment, topPoint, bottomPoint)) {
      return true;
    }

    if (seriesRenderer._seriesType == 'stepline') {
      final dynamic x3 = currentSegment.x3;
      final dynamic y3 = currentSegment.y3;
      final dynamic x2 = currentSegment.x2;
      final dynamic y2 = currentSegment.y2;
      final CartesianChartPoint<dynamic> endSegment =
          CartesianChartPoint<dynamic>(x2, y2);
      final CartesianChartPoint<dynamic> midSegment =
          CartesianChartPoint<dynamic>(x3, y3);
      if (isLineIntersect(endSegment, midSegment, leftPoint, rightPoint) ||
          isLineIntersect(endSegment, midSegment, topPoint, bottomPoint)) {
        return true;
      }
    }
    return false;
  }

  /// To get the index of the selected segment
  void getSeriesIndex(SfCartesianChart chart, Offset position,
      CartesianSeriesRenderer seriesRenderer) {
    Rect currentSegment;
    int seriesIndex;
    CartesianChartPoint<dynamic> point;
    outerLoop:
    for (int i = 0; i < chart._chartSeries.visibleSeriesRenderers.length; i++) {
      final CartesianSeriesRenderer seriesRenderer =
          chart._chartSeries.visibleSeriesRenderers[i];
      for (int j = 0; j < seriesRenderer._dataPoints.length; j++) {
        point = seriesRenderer._dataPoints[j];
        currentSegment = point.region;
        if (currentSegment != null && currentSegment.contains(position)) {
          seriesIndex = i;
          break outerLoop;
        }
      }
    }
    seriesRenderer._series.selectionSettings._selectionRenderer.seriesIndex =
        seriesIndex;
  }

  /// To ensure selection for circular chart type
/*  bool isCircularSelection(
      SfCircularChart circularChart,
      CircularSeries<dynamic, dynamic> circularSeries,
      int pointIndex,
      int seriesIndex) {
    chart = circularChart;
    if (chart.onSelectionChanged != null) {
      chart.onSelectionChanged(
          getSelectionEventArgs(series, seriesIndex, pointIndex));
    }
    bool isSamePointSelect = false;
    chart._chartState.initialRender = false;

    /// UnSelecting the last selected segment
    if (selectedDataPoints.length == 1) {
      _changeColorAndPopUnselectedDataPoints(
          unselectedDataPoints, unselectedRegions);
    }
    bool multiSelect = false;
    if (chart.enableMultiSelection) {
      if (selectedDataPoints.isNotEmpty) {
        for (int i = 0; i < chart._chartSeries.visibleSeriesRenderers.length; i++) {
          final CircularSeries<dynamic, dynamic> series =
              chart._chartSeries.visibleSeriesRenderers[i];

          /// To identify the tapped Region
          for (int k = 0; k < seriesRenderer._pointRegions.length; k++) {
            currentRegion = seriesRenderer._pointRegions[k];
            if (currentRegion.pointIndex == pointIndex &&
                currentRegion.seriesIndex == seriesIndex) {
              selectedRegion = seriesRenderer._pointRegions[k];
              selectedDataPoint =
                  seriesRenderer._renderPoints[selectedRegion.pointIndex];
              break;
            }
          }
        }

        /// To identify that tapped segment in any one of the selected regions
        if (selectedRegion != null) {
          for (int k = 0; k < selectedRegions.length; k++) {
            if (selectedDataPoint == selectedDataPoints[k]) {
              multiSelect = true;
              break;
            }
          }
        }

        /// Executes when tapped again in one of the selected segments
        if (multiSelect) {
          for (int j = selectedDataPoints.length - 1; j >= 0; j--) {
            series = chart
                ._chartSeries.visibleSeriesRenderers[selectedRegions[j].seriesIndex];
            currentRegion = seriesRenderer._pointRegions[selectedRegions[j].pointIndex];
            currentDataPoint =
                seriesRenderer._renderPoints[selectedRegions[j].pointIndex];

            /// Applying default settings when last selected segment becames unselected
            if ((selectedDataPoint == selectedDataPoints[j]) &&
                (selectedDataPoints.length == 1)) {
              final Paint fillPaint = getDefaultFillColor(
                  seriesRenderer._renderPoints, selectedRegions[j].pointIndex);
              final Paint strokePaint = getDefaultStrokeColor(
                  seriesRenderer._renderPoints, selectedRegions[j].pointIndex);
              currentDataPoint.fill = fillPaint.color;
              currentDataPoint.strokeColor = strokePaint.color;

              if (selectedRegions[j].pointIndex == pointIndex &&
                  selectedRegions[j].seriesIndex == seriesIndex)
                isSamePointSelect = true;
              selectedDataPoints.remove(selectedDataPoints[j]);
              selectedRegions.remove(selectedRegions[j]);
            }

            /// Applying unselected color for unselected segments in multiSelect option
            else if (selectedDataPoint == selectedDataPoints[j]) {
              final Paint fillPaint =
                  getFillColor(false, null, currentDataPoint);
              currentDataPoint.fill =
                  fillPaint.color.withOpacity(fillPaint.color.opacity);
              final Paint strokePaint =
                  getStrokeColor(false, null, currentDataPoint);
              currentDataPoint.strokeColor =
                  strokePaint.color.withOpacity(strokePaint.color.opacity);
              currentDataPoint.strokeWidth = strokePaint.strokeWidth;
              if (selectedRegions[j].pointIndex == pointIndex &&
                  selectedRegions[j].seriesIndex == seriesIndex)
                isSamePointSelect = true;
              unselectedDataPoints.add(selectedDataPoints[j]);
              selectedDataPoints[j].isSelected = false;
              selectedDataPoints.remove(selectedDataPoints[j]);
              unselectedRegions.add(selectedRegions[j]);
              selectedRegions.remove(selectedRegions[j]);
            }
          }
        }
      }
    } else
      isSamePointSelect = _changeColorAndPopSelectedDataPoints(
          selectedDataPoints, selectedRegions, isSamePointSelect);

    if (series.selectionSettings.enable) {
      if (!isSamePointSelect) {
        isSelected = true;
        for (int i = 0; i < chart._chartSeries.visibleSeriesRenderers.length; i++) {
          final CircularSeries<dynamic, dynamic> series =
              chart._chartSeries.visibleSeriesRenderers[i];
          if (isSelected) {
            for (int j = 0; j < seriesRenderer._renderPoints.length; j++) {
              currentRegion = seriesRenderer._pointRegions[j];
              if (currentRegion.pointIndex == null || pointIndex == null) {
                break;
              }

              if (currentRegion.pointIndex == pointIndex &&
                  currentRegion.seriesIndex == seriesIndex) {
                selectedDataPoints.add(seriesRenderer._renderPoints[j]);
                selectedRegions.add(seriesRenderer._pointRegions[j]);
                seriesRenderer._renderPoints[j].isSelected = true;
              } else {
                unselectedDataPoints.add(seriesRenderer._renderPoints[j]);
                unselectedRegions.add(seriesRenderer._pointRegions[j]);
                seriesRenderer._renderPoints[j].isSelected = false;
              }
            }

            /// Giving color to unselected segments
            _unselectedDataPointColors(
                unselectedDataPoints, series.selectionSettings);

            /// Giving Color to selected segments
            _selectedDataPointColors(
                selectedDataPoints, series.selectionSettings);
          }
        }
      }
    }
    return isSelected;
  }
*/
  /// To do selection for cartesian type chart.
  void performSelection(Offset position) {
    bool select = false;
    bool isSelect = false;
    int cartesianPointIndex;
    if (seriesRenderer._seriesType == 'line' ||
        seriesRenderer._seriesType == 'spline' ||
        seriesRenderer._seriesType == 'stepline' ||
        seriesRenderer._seriesType == 'stackedline' ||
        seriesRenderer._seriesType.contains('hilo') ||
        seriesRenderer._seriesType == 'candle' ||
        seriesRenderer._seriesType == 'stackedline100') {
      isSelect = seriesRenderer._series.selectionSettings.enable
          ? _isSeriesContainsPoint(seriesRenderer, position)
          : false;
      if (isSelect) {
        cartesianPointIndex = getCartesianPointIndex(position);
        select = seriesRenderer._series.selectionSettings._selectionRenderer
            .isCartesianSelection(chart, seriesRenderer, cartesianPointIndex,
                cartesianSeriesIndex);
      }
    } else {
      chart._chartState.renderDatalabelRegions = <Rect>[];
      if (seriesRenderer._seriesType.contains('area') ||
          seriesRenderer._seriesType == 'fastline')
        getSeriesIndex(chart, position, seriesRenderer);
      else
        getPointAndSeriesIndex(chart, position, seriesRenderer);
      select = seriesRenderer._series.selectionSettings._selectionRenderer
          .isCartesianSelection(chart, seriesRenderer, pointIndex, seriesIndex);
    }

    if (select)
      ValueNotifier<int>(chart._chartState.seriesRepaintNotifier.values++);
  }

  void _checkWithSelectionState(
      ChartSegment currentSegment, SfCartesianChart chart) {
    bool isSelected = false;
    if (selectedSegments.isNotEmpty) {
      for (int i = 0; i < selectedSegments.length; i++) {
        if (selectedSegments[i]._seriesIndex == currentSegment._seriesIndex &&
            selectedSegments[i].currentSegmentIndex ==
                currentSegment.currentSegmentIndex) {
          _selectedSegmentsColors(<ChartSegment>[currentSegment]);
          isSelected = true;
          break;
        }
      }
    }

    if (!isSelected && unselectedSegments.isNotEmpty) {
      for (int i = 0; i < unselectedSegments.length; i++) {
        if (unselectedSegments[i]._seriesIndex == currentSegment._seriesIndex &&
            unselectedSegments[i].currentSegmentIndex ==
                currentSegment.currentSegmentIndex) {
          _unselectedSegmentsColors(<ChartSegment>[currentSegment]);
          isSelected = true;
          break;
        }
      }
    }
  }

  /// To do user interaction selection for circular chart type.
/*  void performCircularSelection(int pointIndex, int seriesIndex) {
    bool select = false;
    series.selectionSettings._selectionRenderer.seriesIndex = seriesIndex;
    series.selectionSettings._selectionRenderer.pointIndex = pointIndex;
    select = series.selectionSettings._selectionRenderer
        .isCircularSelection(chart, series, pointIndex, seriesIndex);
    if (select)
      ValueNotifier<int>(chart._chartState.seriesRepaintNotifier.value++);
  }
*/
  SelectionArgs getSelectionEventArgs(dynamic series, num seriesIndex,
      num pointIndex, CartesianSeriesRenderer seriesRender) {
    if (series != null) {
      selectionArgs = SelectionArgs(seriesRenderer, seriesIndex, pointIndex,
          seriesRender._dataPoints[pointIndex].overallDataPointIndex);
      selectionArgs.selectedBorderColor =
          series.selectionSettings.selectedBorderColor;
      selectionArgs.selectedBorderWidth =
          series.selectionSettings.selectedBorderWidth;
      selectionArgs.selectedColor = series.selectionSettings.selectedColor;
      selectionArgs.unselectedBorderColor =
          series.selectionSettings.unselectedBorderColor;
      selectionArgs.unselectedBorderWidth =
          series.selectionSettings.unselectedBorderWidth;
      selectionArgs.unselectedColor = series.selectionSettings.unselectedColor;
    }
    return selectionArgs;
  }
}
