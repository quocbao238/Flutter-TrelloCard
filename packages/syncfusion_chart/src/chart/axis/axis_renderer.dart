part of charts;

abstract class _CustomizeAxisElements {
  Color getAxisLineColor(ChartAxis axis);

  Color getAxisMajorTickColor(ChartAxis axis, int majorTickIndex);

  Color getAxisMinorTickColor(ChartAxis axis, int majorTickIndex, int minorTickIndex);

  Color getAxisMajorGridColor(ChartAxis axis, int majorGridIndex);

  Color getAxisMinorGridColor(ChartAxis axis, int majorGridIndex, int minorGridIndex);

  double getAxisLineWidth(ChartAxis axis);

  double getAxisMajorTickWidth(ChartAxis axis, int majorTickIndex);

  double getAxisMinorTickWidth(ChartAxis axis, int majorTickIndex, int minorTickIndex);

  double getAxisMajorGridWidth(ChartAxis axis, int majorGridIndex);

  double getAxisMinorGridWidth(ChartAxis axis, int majorGridIndex, int minorGridIndex);

  String getAxisLabel(ChartAxis axis, String text, int labelIndex);

  TextStyle getAxisLabelStyle(ChartAxis axis, String text, int labelIndex);

  int getAxisLabelAngle(ChartAxis axis, String text, int labelIndex);

  void drawHorizontalAxesLine(Canvas canvas, ChartAxis axis, SfCartesianChart chart);

  void drawVerticalAxesLine(Canvas canvas, ChartAxis axis, SfCartesianChart chart);

  void drawHorizontalAxesTickLines(Canvas canvas, ChartAxis axis, SfCartesianChart chart);

  void drawVerticalAxesTickLines(Canvas canvas, ChartAxis axis, SfCartesianChart chart);

  void drawHorizontalAxesMajorGridLines(
      Canvas canvas, Offset point, ChartAxis axis, MajorGridLines grids, int index, SfCartesianChart chart);

  void drawVerticalAxesMajorGridLines(
      Canvas canvas, Offset point, ChartAxis axis, MajorGridLines grids, int index, SfCartesianChart chart);

  void drawHorizontalAxesMinorLines(
      Canvas canvas, ChartAxis axis, num tempInterval, Rect rect, num nextValue, int index, SfCartesianChart chart);

  void drawVerticalAxesMinorTickLines(
      Canvas canvas, ChartAxis axis, num tempInterval, Rect rect, int index, SfCartesianChart chart);

  void drawHorizontalAxesLabels(Canvas canvas, ChartAxis axis, SfCartesianChart chart);

  void drawVerticalAxesLabels(Canvas canvas, ChartAxis axis, SfCartesianChart chart);

  void drawHorizontalAxesTitle(Canvas canvas, ChartAxis axis, SfCartesianChart chart);

  void drawVerticalAxesTitle(Canvas canvas, ChartAxis axis, SfCartesianChart chart);
}

class _ChartAxisRenderer with _CustomizeAxisElements {
  _ChartAxisRenderer();

  Offset _xAxisStart, _xAxisEnd;

  @override
  Color getAxisLineColor(ChartAxis axis) => axis.axisLine.color;

  @override
  double getAxisLineWidth(ChartAxis axis) => axis.axisLine.width;

  @override
  Color getAxisMajorTickColor(ChartAxis axis, int majorTickIndex) => axis.majorTickLines.color;

  @override
  double getAxisMajorTickWidth(ChartAxis axis, int majorTickIndex) => axis.majorTickLines.width;

  @override
  Color getAxisMinorTickColor(ChartAxis axis, int majorTickIndex, int minorTickIndex) => axis.minorTickLines.color;

  @override
  double getAxisMinorTickWidth(ChartAxis axis, int majorTickIndex, int minorTickIndex) => axis.minorTickLines.width;

  @override
  Color getAxisMajorGridColor(ChartAxis axis, int majorGridIndex) => axis.majorGridLines.color;

  @override
  double getAxisMajorGridWidth(ChartAxis axis, int majorGridIndex) => axis.majorGridLines.width;

  @override
  Color getAxisMinorGridColor(ChartAxis axis, int majorGridIndex, int minorGridIndex) => axis.minorGridLines.color;

  @override
  double getAxisMinorGridWidth(ChartAxis axis, int majorGridIndex, int minorGridIndex) => axis.minorGridLines.width;

  @override
  String getAxisLabel(ChartAxis axis, String text, int labelIndex) => text;

  @override
  TextStyle getAxisLabelStyle(ChartAxis axis, String text, int labelIndex) => axis.labelStyle;

  /// It returns the axis label angle
  @override
  int getAxisLabelAngle(ChartAxis axis, String text, int labelIndex) =>
      (axis.labelIntersectAction == AxisLabelIntersectAction.rotate45 && axis._isCollide)
          ? -45
          : (axis.labelIntersectAction == AxisLabelIntersectAction.rotate90 && axis._isCollide)
              ? -90
              : axis._labelRotation;

  /// To draw the horizontal axis line
  @override
  void drawHorizontalAxesLine(Canvas canvas, ChartAxis axis, SfCartesianChart chart) {
    final Rect rect = Rect.fromLTWH(axis._bounds.left - axis.plotOffset, axis._bounds.top,
        axis._bounds.width + 2 * axis.plotOffset, axis._bounds.height);

    final _CustomPaintStyle paintStyle = _CustomPaintStyle(axis._axisRenderer.getAxisLineWidth(axis),
        axis._axisRenderer.getAxisLineColor(axis) ?? chart._chartState._chartTheme.axisLineColor, PaintingStyle.stroke);
    _drawDashedPath(canvas, paintStyle, Offset(rect.left, rect.top), Offset(rect.left + rect.width, rect.top),
        axis.axisLine.dashArray);
    _xAxisStart = Offset(rect.left, rect.top);
    _xAxisEnd = Offset(rect.left + rect.width, rect.top);
  }

  /// To draw the vertical axis line
  @override
  void drawVerticalAxesLine(Canvas canvas, ChartAxis axis, SfCartesianChart chart) {
    final Rect rect = Rect.fromLTWH(axis._bounds.left, axis._bounds.top - axis.plotOffset, axis._bounds.width,
        axis._bounds.height + 2 * axis.plotOffset);
    final _CustomPaintStyle paintStyle = _CustomPaintStyle(axis._axisRenderer.getAxisLineWidth(axis),
        axis._axisRenderer.getAxisLineColor(axis) ?? chart._chartState._chartTheme.axisLineColor, PaintingStyle.stroke);
    _drawDashedPath(canvas, paintStyle, Offset(rect.left, rect.top), Offset(rect.left, rect.top + rect.height),
        axis.axisLine.dashArray);
  }

  /// To draw the horizontal axes tick lines
  @override
  void drawHorizontalAxesTickLines(Canvas canvas, ChartAxis axis, SfCartesianChart chart,
      [String renderType, double animationFactor, ChartAxis oldAxis, bool needAnimate]) {
    final Rect axisBounds = axis._bounds;
    final List<AxisLabel> visibleLabels = axis._visibleLabels;
    num tempInterval, pointX, pointY, length = visibleLabels.length;
    if (length > 0) {
      final MajorTickLines ticks = axis.majorTickLines;
      const num padding = 1;
      final bool isBetweenTicks = axis is CategoryAxis && axis.labelPlacement == LabelPlacement.betweenTicks;
      final num tickBetweenLabel = isBetweenTicks ? 0.5 : 0;
      length += isBetweenTicks ? 1 : 0;
      for (int i = 0; i < length; i++) {
        tempInterval = isBetweenTicks
            ? i < length - 1
                ? visibleLabels[i].value - tickBetweenLabel
                : (visibleLabels[i - 1].value + axis._visibleRange.interval) - tickBetweenLabel
            : visibleLabels[i].value;
        pointX = ((_valueToCoefficient(tempInterval, axis) * axisBounds.width) + axisBounds.left).roundToDouble();
        pointY = axisBounds.top - padding + axis.axisLine.width / 2;

        if (needAnimate) {
          final double oldLocation = _getPrevLocation(axis, oldAxis, tempInterval);
          pointX = oldLocation != null ? (oldLocation - (oldLocation - pointX) * animationFactor) : pointX;
        }
        if (axisBounds.left.roundToDouble() <= pointX && axisBounds.right.roundToDouble() >= pointX) {
          if (axis.majorGridLines.width > 0 &&
              renderType == 'outside' &&
              (axis.plotOffset > 0 ||
                  (i != 0 && i != length - 1) ||
                  (axisBounds.left <= pointX && axisBounds.right >= pointX && !chart._requireInvertedAxis))) {
            axis._axisRenderer
                .drawHorizontalAxesMajorGridLines(canvas, Offset(pointX, pointY), axis, axis.majorGridLines, i, chart);
          }
          if (axis.minorGridLines.width > 0 || axis.minorTickLines.width > 0) {
            num nextValue = isBetweenTicks
                ? (tempInterval + axis._visibleRange.interval)
                : i == length - 1 ? axis._visibleRange.maximum : visibleLabels[i + 1]?.value;
            if (nextValue != null) {
              nextValue = ((_valueToCoefficient(nextValue, axis) * axisBounds.width) + axisBounds.left).roundToDouble();
              axis._axisRenderer
                  .drawHorizontalAxesMinorLines(canvas, axis, pointX, axisBounds, nextValue, i, chart, renderType);
            }
          }
        }
        if (axis.majorTickLines.width > 0 &&
            (axisBounds.left <= pointX && axisBounds.right.roundToDouble() >= pointX) &&
            renderType == axis.tickPosition.toString().split('.')[1]) {
          _drawDashedPath(
              canvas,
              _CustomPaintStyle(
                  axis._axisRenderer.getAxisMajorTickWidth(axis, i),
                  axis._axisRenderer.getAxisMajorTickColor(axis, i) ?? chart._chartState._chartTheme.majorTickLineColor,
                  PaintingStyle.stroke),
              Offset(pointX, pointY),
              Offset(
                  pointX,
                  !axis.opposedPosition
                      ? (axis._isInsideTickPosition ? pointY - ticks.size : pointY + ticks.size)
                      : (axis._isInsideTickPosition ? pointY + ticks.size : pointY - ticks.size)));
        }
      }
    }
  }

  /// To draw the major grid lines of horizontal axes
  @override
  void drawHorizontalAxesMajorGridLines(
      Canvas canvas, Offset point, ChartAxis axis, MajorGridLines grids, int index, SfCartesianChart chart) {
    final _CustomPaintStyle paintStyle = _CustomPaintStyle(
        axis._axisRenderer.getAxisMajorGridWidth(axis, index),
        axis._axisRenderer.getAxisMajorGridColor(axis, index) ?? chart._chartState._chartTheme.majorGridLineColor,
        PaintingStyle.stroke);
    _drawDashedPath(canvas, paintStyle, Offset(point.dx, chart._chartAxis._axisClipRect.top),
        Offset(point.dx, chart._chartAxis._axisClipRect.top + chart._chartAxis._axisClipRect.height), grids.dashArray);
  }

  /// To draw the minor grid lines of horizontal axes
  @override
  void drawHorizontalAxesMinorLines(
      Canvas canvas, ChartAxis axis, num tempInterval, Rect rect, num nextValue, int index, SfCartesianChart chart,
      [String renderType]) {
    num position = tempInterval;
    final MinorTickLines ticks = axis.minorTickLines;
    final num interval = (tempInterval - nextValue).abs() / (axis.minorTicksPerInterval + 1);
    for (dynamic i = 0; i < axis.minorTicksPerInterval; i++) {
      position = axis.isInversed ? (position - interval) : (position + interval);
      final num pointY = rect.top;
      if (axis.minorGridLines.width > 0 &&
          renderType == 'outside' &&
          (axis._bounds.left <= position && axis._bounds.right >= position)) {
        _drawDashedPath(
            canvas,
            _CustomPaintStyle(
                axis._axisRenderer.getAxisMinorGridWidth(axis, index, i),
                axis._axisRenderer.getAxisMinorGridColor(axis, index, i) ??
                    chart._chartState._chartTheme.minorGridLineColor,
                PaintingStyle.stroke),
            Offset(position, chart._chartAxis._axisClipRect.top),
            Offset(position, chart._chartAxis._axisClipRect.top + chart._chartAxis._axisClipRect.height),
            axis.minorGridLines.dashArray);
      }

      if (axis.minorTickLines.width > 0 &&
          axis._bounds.left <= position &&
          axis._bounds.right >= position &&
          renderType == axis.tickPosition.toString().split('.')[1]) {
        _drawDashedPath(
            canvas,
            _CustomPaintStyle(
                axis._axisRenderer.getAxisMinorTickWidth(axis, index, i),
                axis._axisRenderer.getAxisMinorTickColor(axis, index, i) ??
                    chart._chartState._chartTheme.minorTickLineColor,
                PaintingStyle.stroke),
            Offset(position, pointY),
            Offset(
                position,
                !axis.opposedPosition
                    ? (axis._isInsideTickPosition ? pointY - ticks.size : pointY + ticks.size)
                    : (axis._isInsideTickPosition ? pointY + ticks.size : pointY - ticks.size)),
            axis.minorGridLines.dashArray);
      }
    }
  }

  /// To draw tick lines of vertical axes
  @override
  void drawVerticalAxesTickLines(Canvas canvas, ChartAxis axis, SfCartesianChart chart,
      [String renderType, double animationFactor, ChartAxis oldAxis, bool needAnimate]) {
    final Rect axisBounds = axis._bounds;
    final List<AxisLabel> visibleLabels = axis._visibleLabels;
    num tempInterval, pointX, pointY, length = visibleLabels.length;
    const num padding = 1;
    final bool isBetweenTicks = axis is CategoryAxis && axis.labelPlacement == LabelPlacement.betweenTicks;
    final num tickBetweenLabel = isBetweenTicks ? 0.5 : 0;
    length += isBetweenTicks ? 1 : 0;
    for (int i = 0; i < length; i++) {
      tempInterval = isBetweenTicks
          ? i < length - 1
              ? visibleLabels[i].value - tickBetweenLabel
              : (visibleLabels[i - 1].value + axis._visibleRange.interval) - tickBetweenLabel
          : visibleLabels[i].value;
      pointY = (_valueToCoefficient(tempInterval, axis) * axisBounds.height) + axisBounds.top;
      pointY = (axisBounds.top + axisBounds.height) - (pointY - axisBounds.top).abs();
      pointX = axisBounds.left + padding - axis.axisLine.width / 2;

      if (needAnimate) {
        final double oldLocation = _getPrevLocation(axis, oldAxis, tempInterval);
        pointY = oldLocation != null ? (oldLocation - (oldLocation - pointY) * animationFactor) : pointY;
      }
      if (pointY >= axisBounds.top && pointY <= axisBounds.bottom) {
        if (axis.majorGridLines.width > 0 &&
            renderType == 'outside' &&
            (axis.plotOffset > 0 ||
                ((i == 0 || i == length - 1) && chart.plotAreaBorderWidth == 0) ||
                (((i == 0 && !axis.opposedPosition) || (i == length - 1 && axis.opposedPosition)) &&
                    axis.axisLine.width == 0) ||
                (axisBounds.top < pointY - axis.majorGridLines.width &&
                    axisBounds.bottom > pointY + axis.majorGridLines.width))) {
          axis._axisRenderer
              .drawVerticalAxesMajorGridLines(canvas, Offset(pointX, pointY), axis, axis.majorGridLines, i, chart);
        }
        if (axis.minorGridLines.width > 0 || axis.minorTickLines.width > 0) {
          axis._axisRenderer
              .drawVerticalAxesMinorTickLines(canvas, axis, tempInterval, axisBounds, i, chart, renderType);
        }
        if (axis.majorTickLines.width > 0 && renderType == axis.tickPosition.toString().split('.')[1]) {
          _drawDashedPath(
              canvas,
              _CustomPaintStyle(
                  axis._axisRenderer.getAxisMajorTickWidth(axis, i),
                  axis._axisRenderer.getAxisMajorTickColor(axis, i) ?? chart._chartState._chartTheme.majorTickLineColor,
                  PaintingStyle.stroke),
              Offset(pointX, pointY),
              Offset(
                  !axis.opposedPosition
                      ? (axis._isInsideTickPosition
                          ? pointX + axis.majorTickLines.size
                          : pointX - axis.majorTickLines.size)
                      : (axis._isInsideTickPosition
                          ? pointX - axis.majorTickLines.size
                          : pointX + axis.majorTickLines.size),
                  pointY));
        }
      }
    }
  }

  /// To draw the major grid lines of vertical axes
  @override
  void drawVerticalAxesMajorGridLines(
      Canvas canvas, Offset point, ChartAxis axis, MajorGridLines grids, int index, SfCartesianChart chart) {
    final _CustomPaintStyle paintStyle = _CustomPaintStyle(
        axis._axisRenderer.getAxisMajorGridWidth(axis, index),
        axis._axisRenderer.getAxisMajorGridColor(axis, index) ?? chart._chartState._chartTheme.majorGridLineColor,
        PaintingStyle.stroke);
    if (chart.primaryXAxis._axisRenderer._xAxisStart != Offset(chart._chartAxis._axisClipRect.left, point.dy) &&
        chart.primaryXAxis._axisRenderer._xAxisEnd !=
            Offset(chart._chartAxis._axisClipRect.left + chart._chartAxis._axisClipRect.width, point.dy))
      _drawDashedPath(
          canvas,
          paintStyle,
          Offset(chart._chartAxis._axisClipRect.left, point.dy),
          Offset(chart._chartAxis._axisClipRect.left + chart._chartAxis._axisClipRect.width, point.dy),
          grids.dashArray);
  }

  /// To draw the minor grid lines of vertical axes
  @override
  void drawVerticalAxesMinorTickLines(
      Canvas canvas, ChartAxis axis, num tempInterval, Rect rect, int index, SfCartesianChart chart,
      [String renderType]) {
    num value = tempInterval, position = 0;
    final _VisibleRange range = axis._visibleRange;
    final bool rendering =
        axis.minorTicksPerInterval > 0 && (axis.minorGridLines.width > 0 || axis.minorTickLines.width > 0);
    if (rendering) {
      for (int i = 0; i < axis.minorTicksPerInterval; i++) {
        value += range.interval / (axis.minorTicksPerInterval + 1);
        if ((value < range.maximum) && (value > range.minimum)) {
          position = _valueToCoefficient(value, axis) * rect.height;
          position = (position + rect.top).floor().toDouble();
          if (axis.minorGridLines.width > 0 &&
              renderType == 'outside' &&
              rect.top <= position &&
              rect.bottom >= position) {
            _drawDashedPath(
                canvas,
                _CustomPaintStyle(
                    axis._axisRenderer.getAxisMinorGridWidth(axis, index, i),
                    axis._axisRenderer.getAxisMinorGridColor(axis, index, i) ??
                        chart._chartState._chartTheme.minorGridLineColor,
                    PaintingStyle.stroke),
                Offset(chart._chartAxis._axisClipRect.left, position),
                Offset(chart._chartAxis._axisClipRect.left + chart._chartAxis._axisClipRect.width, position),
                axis.minorGridLines.dashArray);
          }
          if (axis.minorTickLines.width > 0 && renderType == axis.tickPosition.toString().split('.')[1]) {
            _drawDashedPath(
                canvas,
                _CustomPaintStyle(
                    axis._axisRenderer.getAxisMinorTickWidth(axis, index, i),
                    axis._axisRenderer.getAxisMinorTickColor(axis, index, i) ??
                        chart._chartState._chartTheme.minorTickLineColor,
                    PaintingStyle.stroke),
                Offset(rect.left, position),
                Offset(
                    !axis.opposedPosition
                        ? (axis._isInsideTickPosition
                            ? rect.left + axis.minorTickLines.size
                            : rect.left - axis.minorTickLines.size)
                        : (axis._isInsideTickPosition
                            ? rect.left - axis.minorTickLines.size
                            : rect.left + axis.minorTickLines.size),
                    position));
          }
        }
      }
    }
  }

  /// To draw the axis labels of horizontal axes
  @override
  void drawHorizontalAxesLabels(Canvas canvas, ChartAxis axis, SfCartesianChart chart,
      [String renderType, double animationFactor, ChartAxis oldAxis, bool needAnimate]) {
    if (renderType == axis.labelPosition.toString().split('.')[1]) {
      final Rect axisBounds = axis._bounds;
      int angle;
      TextStyle textStyle;
      final List<AxisLabel> visibleLabels = axis._visibleLabels;
      num tempInterval, pointX, pointY, previousLabelEnd;
      for (int i = 0; i < visibleLabels.length; i++) {
        final AxisLabel label = visibleLabels[i];
        final String labelText =
        // (axis is CategoryAxis && axis.customLabelBuilder != null)
        //     ? axis.customLabelBuilder(axis._axisRenderer.getAxisLabel(axis, label.text, i))
        //     :
    axis._axisRenderer.getAxisLabel(axis, label.text, i);

        textStyle = label.labelStyle;
        textStyle = _getTextStyle(
            textStyle: textStyle, fontColor: textStyle.color ?? chart._chartState._chartTheme.axisLabelColor);
        tempInterval = label.value;
        angle = axis._axisRenderer.getAxisLabelAngle(axis, labelText, i);

        /// For negative angle calculations
        if (angle.isNegative) {
          angle = angle + 360;
        }
        axis._labelRotation = angle;
        final Size textSize = _measureText(labelText, textStyle);
        final Size rotatedTextSize = _measureText(labelText, textStyle, angle);
        pointX = ((_valueToCoefficient(tempInterval, axis) * axisBounds.width) + axisBounds.left).roundToDouble();
        pointY = _getPointY(axis, label, axisBounds);
        pointY -= angle == 0 ? textSize.height / 2 : 0;
        pointY += rotatedTextSize.height / 2;
        pointX -= angle == 0 ? textSize.width / 2 : 0;

        ///  Edge label placement - shift for x-Axis
        pointX = _getShiftedPosition(axis, axisBounds, pointX, pointY, textSize, i);
        if (axis.labelAlignment == LabelAlignment.end) {
          pointX = pointX + textSize.height / 2;
        } else if (axis.labelAlignment == LabelAlignment.start) {
          pointX = pointX - textSize.height / 2;
        }
        if (axis.edgeLabelPlacement == EdgeLabelPlacement.hide) {
          if (axis.labelAlignment == LabelAlignment.center) {
            if (i == 0 || (i == axis._visibleLabels.length - 1)) {
              axis._visibleLabels[i]._needRender = false;
              continue;
            }
          } else if ((axis.labelAlignment == LabelAlignment.end) &&
              (i == axis._visibleLabels.length - 1 || (i == 0 && axis.isInversed))) {
            axis._visibleLabels[i]._needRender = false;
            continue;
          } else if ((axis.labelAlignment == LabelAlignment.start) &&
              (i == 0 || (i == axis._visibleLabels.length - 1 && axis.isInversed))) {
            axis._visibleLabels[i]._needRender = false;
            continue;
          }
        }

        if (axis.labelIntersectAction == AxisLabelIntersectAction.hide &&
            axis.labelRotation % 180 == 0 &&
            i != 0 &&
            axis._visibleLabels[i - 1]._needRender &&
            (!axis.isInversed ? pointX <= previousLabelEnd : (pointX + textSize.width) >= previousLabelEnd)) {
          continue;
        }

        previousLabelEnd = axis.isInversed ? pointX : pointX + textSize.width;

        if (needAnimate) {
          final double oldLocation = _getPrevLocation(axis, oldAxis, tempInterval, textSize, angle);
          pointX = oldLocation != null ? (oldLocation - (oldLocation - pointX) * animationFactor) : pointX;
        }
        final Offset point = Offset(pointX, pointY);
        if (axisBounds.left - textSize.width <= pointX && axisBounds.right + textSize.width >= pointX)
          _drawText(canvas, labelText, point, textStyle, angle);
        if (label._labelCollection != null &&
            label._labelCollection.isNotEmpty &&
            axis.labelIntersectAction == AxisLabelIntersectAction.wrap) {
          for (int j = 1; j < label._labelCollection.length; j++) {
            final String wrapTxt = label._labelCollection[j];
            _drawText(canvas, wrapTxt,
                Offset(pointX, pointY + (j * _measureText(wrapTxt, axis.labelStyle, angle).height)), textStyle, angle);
          }
        }
      }
    }
  }

  /// To draw the axis labels of vertical axes
  @override
  void drawVerticalAxesLabels(Canvas canvas, ChartAxis axis, SfCartesianChart chart,
      [String renderType, double animationFactor, ChartAxis oldAxis, bool needAnimate]) {
    if (axis.labelPosition.toString().split('.')[1] == renderType) {
      final Rect axisBounds = axis._bounds;
      final List<AxisLabel> visibleLabels = axis._visibleLabels;
      TextStyle textStyle;
      num tempInterval, pointX, pointY, previousEnd;
      for (dynamic i = 0; i < visibleLabels.length; i++) {
        final String labelText =
        // (axis is CategoryAxis && axis.customLabelBuilder != null)
        //     ? axis.customLabelBuilder(axis._axisRenderer.getAxisLabel(axis, visibleLabels[i].text, i))
        //     :
        axis._axisRenderer.getAxisLabel(axis, visibleLabels[i].text, i);
        final int angle = axis._axisRenderer.getAxisLabelAngle(axis, labelText, i);
        textStyle = visibleLabels[i].labelStyle;
        textStyle = _getTextStyle(
            textStyle: textStyle, fontColor: textStyle.color ?? chart._chartState._chartTheme.axisLabelColor);
        tempInterval = visibleLabels[i].value;
        final Size textSize = _measureText(labelText, textStyle, 0);
        pointY = (_valueToCoefficient(tempInterval, axis) * axisBounds.height) + axisBounds.top;
        pointY = ((axisBounds.top + axisBounds.height) - ((axisBounds.top - pointY).abs())) - textSize.height / 2;
        pointX = _getPointX(axis, textSize, axisBounds);
        final _ChartLocation location = _getRotatedTextLocation(pointX, pointY, labelText, textStyle, angle, axis);
        if (axis.labelAlignment == LabelAlignment.center) {
          pointX = location.x;
          pointY = location.y;
        } else if (axis.labelAlignment == LabelAlignment.end) {
          pointX = location.x;
          pointY = location.y - textSize.height / 2;
        } else if (axis.labelAlignment == LabelAlignment.start) {
          pointX = location.x;
          pointY = location.y + textSize.height / 2;
        }
        if (axis.labelIntersectAction == AxisLabelIntersectAction.hide &&
            i != 0 &&
            (!axis.isInversed
                ? pointY + (textSize.height / 2) > previousEnd
                : pointY - (textSize.height / 2) < previousEnd)) {
          continue;
        }
        previousEnd = !axis.isInversed ? pointY - textSize.height / 2 : pointY + textSize.height / 2;

        ///  Edge label placement for y-Axis
        if (axis.edgeLabelPlacement == EdgeLabelPlacement.shift) {
          if (axis.labelAlignment == LabelAlignment.center) {
            if (i == 0 && axisBounds.bottom <= pointY + textSize.height / 2) {
              pointY = axisBounds.top + axisBounds.height - textSize.height;
            } else if (i == axis._visibleLabels.length - 1 && axisBounds.top >= pointY + textSize.height / 2) {
              pointY = axisBounds.top;
            }
          } else if (axis.labelAlignment == LabelAlignment.start) {
            if (i == 0 && axisBounds.bottom <= pointY + textSize.height / 2) {
              pointY = axisBounds.top + axisBounds.height - textSize.height;
            }
          } else if (axis.labelAlignment == LabelAlignment.end) {
            if (i == axis._visibleLabels.length - 1 && axisBounds.top >= pointY + textSize.height / 2) {
              pointY = axisBounds.top + textSize.height / 2;
            }
          }
        } else if (axis.edgeLabelPlacement == EdgeLabelPlacement.hide) {
          if (axis.labelAlignment == LabelAlignment.center) {
            if (i == 0 || i == axis._visibleLabels.length - 1) {
              continue;
            }
          } else if ((axis.labelAlignment == LabelAlignment.end) &&
              (i == axis._visibleLabels.length - 1 || (i == 0 && axis.isInversed))) {
            continue;
          } else if ((axis.labelAlignment == LabelAlignment.start) &&
              (i == 0 || (i == axis._visibleLabels.length - 1 && axis.isInversed))) {
            continue;
          }
        }
        axis._visibleLabels[i]._labelRegion = Rect.fromLTWH(pointX, pointY, textSize.width, textSize.height);

        if (needAnimate) {
          final double oldLocation = _getPrevLocation(axis, oldAxis, tempInterval, textSize);
          pointY = oldLocation != null ? (oldLocation - (oldLocation - pointY) * animationFactor) : pointY;
        }

        final Offset point = Offset(pointX, pointY);
        if (axisBounds.top - textSize.height <= pointY && axisBounds.bottom + textSize.height >= pointY)
          _drawText(canvas, labelText, point, textStyle, axis._labelRotation);
      }
    }
  }

  /// To get the previous location of an axis
  double _getPrevLocation(ChartAxis axis, ChartAxis oldAxis, dynamic value, [Size textSize, num angle]) {
    double location;
    final Rect bounds = axis._bounds;
    textSize ??= const Size(0, 0);
    if (oldAxis._visibleRange.minimum > value) {
      location = axis._orientation == AxisOrientation.vertical
          ? (axis.isInversed
              ? ((bounds.top + bounds.height) -
                  ((bounds.top - (bounds.top - (_valueToCoefficient(value, oldAxis) * bounds.height)).roundToDouble())
                      .abs()))
              : (bounds.bottom - (_valueToCoefficient(value, oldAxis) * bounds.height)).roundToDouble())
          : (axis.isInversed
              ? ((_valueToCoefficient(value, axis) * bounds.width) + bounds.right).roundToDouble()
              : ((_valueToCoefficient(value, oldAxis) * bounds.width) - bounds.left).roundToDouble());
    } else if (oldAxis._visibleRange.maximum < value) {
      location = axis._orientation == AxisOrientation.vertical
          ? (axis.isInversed
              ? (bounds.bottom - (_valueToCoefficient(value, oldAxis) * bounds.height)).roundToDouble()
              : ((bounds.top + bounds.height) -
                  ((bounds.top - (bounds.top - (_valueToCoefficient(value, oldAxis) * bounds.height)).roundToDouble())
                      .abs())))
          : (axis.isInversed
              ? ((_valueToCoefficient(value, oldAxis) * bounds.width) - bounds.left).roundToDouble()
              : ((_valueToCoefficient(value, axis) * bounds.width) + bounds.right).roundToDouble());
    } else {
      if (axis._orientation == AxisOrientation.vertical) {
        location = (_valueToCoefficient(value, oldAxis) * oldAxis._bounds.height) + oldAxis._bounds.top;
        location = ((oldAxis._bounds.top + oldAxis._bounds.height) - ((oldAxis._bounds.top - location).abs())) -
            textSize.height / 2;
      } else {
        location =
            ((_valueToCoefficient(value, oldAxis) * oldAxis._bounds.width) + oldAxis._bounds.left).roundToDouble();
        if (angle != null) {
          location -= angle == 0 ? textSize.width / 2 : 0;
        }
      }
    }
    return location;
  }

  /// Return the x point
  double _getPointX(ChartAxis axis, Size textSize, Rect axisBounds) {
    num pointX;
    const num innerPadding = 5;
    if (axis.labelPosition == ChartDataLabelPosition.inside) {
      pointX = (!axis.opposedPosition)
          ? (axisBounds.left + innerPadding + (axis._isInsideTickPosition ? axis.majorTickLines.size : 0))
          : (axisBounds.left -
              axis._maximumLabelSize.width -
              innerPadding -
              (axis._isInsideTickPosition ? axis.majorTickLines.size : 0));
    } else {
      pointX = (!axis.opposedPosition)
          ? axis._labelOffset != null
              ? axis._labelOffset - textSize.width
              : (axisBounds.left -
                  (axis._isInsideTickPosition ? 0 : axis.majorTickLines.size) -
                  textSize.width -
                  innerPadding)
          : (axis._labelOffset != null
              ? axis._labelOffset
              : (axisBounds.left + (axis._isInsideTickPosition ? 0 : axis.majorTickLines.size) + innerPadding));
    }
    return pointX;
  }

  /// Return the y point
  double _getPointY(ChartAxis axis, AxisLabel label, Rect axisBounds) {
    double pointY;
    const num innerPadding = 3;
    if (axis.labelPosition == ChartDataLabelPosition.inside) {
      pointY = !axis.opposedPosition
          ? axisBounds.top -
              innerPadding -
              (label._index > 1 ? axis._maximumLabelSize.height / 2 : axis._maximumLabelSize.height) -
              (axis._isInsideTickPosition ? axis.majorTickLines.size : 0)
          : axisBounds.top +
              (axis._isInsideTickPosition ? axis.majorTickLines.size : 0) +
              (label._index > 1 ? axis._maximumLabelSize.height / 2 : 0);
    } else {
      pointY = !axis.opposedPosition
          ? axis._labelOffset != null
              ? axis._labelOffset
              : (axisBounds.top +
                  ((axis._isInsideTickPosition ? 0 : axis.majorTickLines.size) + innerPadding) +
                  (label._index > 1 ? axis._maximumLabelSize.height / 2 : 0))
          : axis._labelOffset != null
              ? axis._labelOffset - axis._maximumLabelSize.height
              : (axisBounds.top -
                  (((axis._isInsideTickPosition ? 0 : axis.majorTickLines.size) + innerPadding) -
                      (label._index > 1 ? axis._maximumLabelSize.height / 2 : 0)) -
                  axis._maximumLabelSize.height);
    }
    return pointY;
  }

  /// To get shifted position for both axes
  double _getShiftedPosition(ChartAxis axis, Rect axisBounds, double pointX, double pointY, Size textSize, int i) {
    if (axis.edgeLabelPlacement == EdgeLabelPlacement.shift) {
      if (axis.labelAlignment == LabelAlignment.center) {
        if (i == 0 &&
            ((pointX < axisBounds.left && !axis.isInversed) ||
                (pointX + textSize.width > axisBounds.right && axis.isInversed))) {
          pointX = axis.isInversed ? axisBounds.left + axisBounds.width - textSize.width : axisBounds.left;
        }

        if (i == axis._visibleLabels.length - 1 &&
            ((((pointX + textSize.width) > axisBounds.right) && !axis.isInversed) ||
                (pointX < axisBounds.left && axis.isInversed))) {
          pointX = axis.isInversed ? axisBounds.left : axisBounds.left + axisBounds.width - textSize.width;
        }
      } else if ((axis.labelAlignment == LabelAlignment.end) &&
          (i == axis._visibleLabels.length - 1 &&
              ((((pointX + textSize.width) > axisBounds.right) && !axis.isInversed) ||
                  (pointX < axisBounds.left && axis.isInversed)))) {
        pointX = axis.isInversed
            ? axisBounds.left
            : axisBounds.left + axisBounds.width - textSize.width - textSize.height / 2;
      } else if ((axis.labelAlignment == LabelAlignment.start) &&
          (i == 0 &&
              ((pointX < axisBounds.left && !axis.isInversed) ||
                  (pointX + textSize.width > axisBounds.right && axis.isInversed)))) {
        pointX = axis.isInversed
            ? axisBounds.left + axisBounds.width - textSize.width
            : axisBounds.left + textSize.height / 2;
      }
    }
    axis._visibleLabels[i]._labelRegion = Rect.fromLTWH(pointX, pointY, textSize.width, textSize.height);
    return pointX;
  }

  /// To draw the axis title of horizontal axes
  @override
  void drawHorizontalAxesTitle(Canvas canvas, ChartAxis axis, SfCartesianChart chart) {
    final Rect axisBounds = axis._bounds;
    Offset point;
    final String title = axis.title.text ?? '';
    const int labelRotation = 0, innerPadding = 8;
    TextStyle style = axis.title.textStyle;
    style = _getTextStyle(textStyle: style, fontColor: style.color ?? chart._chartState._chartTheme.axisTitleColor);
    final Size textSize = _measureText(title, style);
    num top;
    if (axis.labelPosition == ChartDataLabelPosition.inside) {
      top = !axis.opposedPosition
          ? axisBounds.top +
              (axis._isInsideTickPosition ? 0 : axis.majorTickLines.size) +
              (!kIsWeb ? innerPadding : innerPadding + textSize.height)
          : axisBounds.top -
              (axis._isInsideTickPosition ? 0 : axis.majorTickLines.size) -
              innerPadding -
              textSize.height;
    } else {
      top = !axis.opposedPosition
          ? axisBounds.top +
              (axis._isInsideTickPosition ? 0 : axis.majorTickLines.size) +
              innerPadding +
              axis._maximumLabelSize.height
          : axisBounds.top -
              (axis._isInsideTickPosition ? 0 : axis.majorTickLines.size) -
              innerPadding -
              axis._maximumLabelSize.height -
              textSize.height;
    }
    axis.title.alignment == ChartAlignment.near
        ? point = Offset(chart._chartAxis._axisClipRect.left, top)
        : axis.title.alignment == ChartAlignment.far
            ? point = Offset(chart._chartAxis._axisClipRect.right - textSize.width, top)
            : point = Offset(axisBounds.left + ((axisBounds.width / 2) - (textSize.width / 2)), top);
    if (axis._seriesRenderers.isNotEmpty || axis._name == 'primaryXAxis')
      _drawText(canvas, title, point, style, labelRotation);
  }

  /// To draw the axis title of vertical axes
  @override
  void drawVerticalAxesTitle(Canvas canvas, ChartAxis axis, SfCartesianChart chart) {
    final Rect axisBounds = axis._bounds;
    Offset point;
    final String title = axis.title.text ?? '';
    final int labelRotation = axis.opposedPosition ? 90 : 270;
    const int innerPadding = 10;
    TextStyle style = axis.title.textStyle;
    style = _getTextStyle(textStyle: style, fontColor: style.color ?? chart._chartState._chartTheme.axisTitleColor);
    final Size textSize = _measureText(title, style);
    num left;
    if (axis.labelPosition == ChartDataLabelPosition.inside) {
      left = (!axis.opposedPosition)
          ? axisBounds.left -
              (axis._isInsideTickPosition ? 0 : axis.majorTickLines.size) -
              innerPadding -
              textSize.height
          : axisBounds.left + (axis._isInsideTickPosition ? 0 : axis.majorTickLines.size) + innerPadding * 2;
    } else {
      left = (!axis.opposedPosition)
          ? (axisBounds.left -
              (axis._isInsideTickPosition ? 0 : axis.majorTickLines.size) -
              innerPadding -
              axis._maximumLabelSize.width -
              textSize.height / 2)
          : axisBounds.left +
              (axis._isInsideTickPosition ? 0 : axis.majorTickLines.size) +
              innerPadding +
              axis._maximumLabelSize.width +
              textSize.height / 2;
    }
    axis.title.alignment == ChartAlignment.near
        ? point = Offset(left, chart._chartAxis._axisClipRect.bottom - textSize.width / 2)
        : axis.title.alignment == ChartAlignment.far
            ? point = Offset(left, chart._chartAxis._axisClipRect.top + textSize.width / 2)
            : point = Offset(left, axisBounds.top + (axisBounds.height / 2));
    if (axis._seriesRenderers.isNotEmpty || axis._name == 'primaryYAxis')
      _drawText(canvas, title, point, style, labelRotation);
  }
}

// ignore: must_be_immutable
class _CartesianAxisRenderer extends StatefulWidget {
  // ignore: prefer_const_constructors_in_immutables
  _CartesianAxisRenderer({this.chart, this.renderType});

  final SfCartesianChart chart;

  String renderType;

  _CartesianAxisRendererState state;

  @override
  State<StatefulWidget> createState() => _CartesianAxisRendererState();
}

class _CartesianAxisRendererState extends State<_CartesianAxisRenderer> with SingleTickerProviderStateMixin {
  List<AnimationController> animationControllersList;

  /// Animation controller for axis
  AnimationController animationController;

  /// Repaint notifier for axis
  ValueNotifier<int> axisRepaintNotifier;

  @override
  void initState() {
    axisRepaintNotifier = ValueNotifier<int>(0);
    animationController = AnimationController(vsync: this)..addListener(_repaintAxisElements);
    super.initState();
  }

  @override
  void dispose() {
    if (animationController != null) {
      animationController.removeListener(_repaintAxisElements);
      animationController.dispose();
      animationController = null;
    }
    super.dispose();
  }

  void _repaintAxisElements() {
    axisRepaintNotifier.value++;
  }

  @override
  Widget build(BuildContext context) {
    widget.state = this;
    animationController.duration = const Duration(milliseconds: 1000);
    final Animation<double> axisAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
      parent: animationController,
      curve: const Interval(0.1, 0.9, curve: Curves.decelerate),
    ));
    animationController.forward(from: 0.0);
    return Container(
        child: CustomPaint(
            painter: _CartesianAxesPainter(
                chart: widget.chart,
                axisAnimation: axisAnimation,
                renderType: widget.renderType,
                isRepaint: widget.chart._chartAxis._needsRepaint,
                notifier: axisRepaintNotifier)));
  }
}

class _CartesianAxesPainter extends CustomPainter {
  _CartesianAxesPainter({this.chart, this.isRepaint, ValueNotifier<num> notifier, this.renderType, this.axisAnimation})
      : super(repaint: notifier);
  SfCartesianChart chart;
  final bool isRepaint;
  final String renderType;
  final Animation<double> axisAnimation;

  @override
  void paint(Canvas canvas, Size size) {
    _onDraw(canvas);
  }

  /// Draw method for axes
  void _onDraw(Canvas canvas) {
    if (renderType == 'outside') {
      _drawPlotAreaBorder(canvas);
      if (chart.plotAreaBackgroundImage != null && chart._chartState._backgroundImage != null) {
        paintImage(
            canvas: canvas,
            rect: chart._chartAxis._axisClipRect,
            image: chart._chartState._backgroundImage,
            fit: BoxFit.fill);
      }
    }
    _drawAxes(canvas);
  }

  /// To draw a plot area border of a container
  void _drawPlotAreaBorder(Canvas canvas) {
    final Rect axisClipRect = chart._chartAxis._axisClipRect;
    final Paint paint = Paint();
    paint.color = chart.plotAreaBorderColor ?? chart._chartState._chartTheme.plotAreaBorderColor;
    paint.style = PaintingStyle.stroke;
    paint.strokeWidth = chart.plotAreaBorderWidth;
    chart.plotAreaBorderWidth == 0 ? paint.color = Colors.transparent : paint.color = paint.color;
    canvas.drawRect(axisClipRect, paint);

    canvas.drawRect(
        axisClipRect,
        Paint()
          ..color = chart.plotAreaBackgroundColor ?? chart._chartState._chartTheme.plotAreaBackgroundColor
          ..style = PaintingStyle.fill);
  }

  /// To draw horizontal axes
  void _drawHorizontalAxes(Canvas canvas, ChartAxis axis, double animationFactor, ChartAxis oldAxis, bool needAnimate) {
    if (axis.isVisible) {
      if (axis.axisLine.width > 0 && renderType == 'outside') {
        axis._axisRenderer.drawHorizontalAxesLine(canvas, axis, chart);
      }
      if (axis.majorTickLines.width > 0 || axis.majorGridLines.width > 0) {
        axis._axisRenderer
            .drawHorizontalAxesTickLines(canvas, axis, chart, renderType, animationFactor, oldAxis, needAnimate);
      }
      axis._axisRenderer
          .drawHorizontalAxesLabels(canvas, axis, chart, renderType, animationFactor, oldAxis, needAnimate);
      if (renderType == 'outside') {
        axis._axisRenderer.drawHorizontalAxesTitle(canvas, axis, chart);
      }
    }
  }

  /// To draw vertical axes
  void _drawVerticalAxes(Canvas canvas, ChartAxis axis, double animationFactor, ChartAxis oldAxis, bool needAnimate) {
    if (axis.isVisible) {
      if (axis.axisLine.width > 0 && renderType == 'outside') {
        axis._axisRenderer.drawVerticalAxesLine(canvas, axis, chart);
      }
      if (axis._visibleLabels.isNotEmpty && (axis.majorTickLines.width > 0 || axis.majorGridLines.width > 0)) {
        axis._axisRenderer
            .drawVerticalAxesTickLines(canvas, axis, chart, renderType, animationFactor, oldAxis, needAnimate);
      }
      axis._axisRenderer.drawVerticalAxesLabels(canvas, axis, chart, renderType, animationFactor, oldAxis, needAnimate);
      if (renderType == 'outside') {
        axis._axisRenderer.drawVerticalAxesTitle(canvas, axis, chart);
      }
    }
  }

  /// To draw chart axes
  void _drawAxes(Canvas canvas) {
    final double animationFactor = axisAnimation != null ? axisAnimation.value : 1;
    for (int axisIndex = 0; axisIndex < chart._chartAxis._axisCollections.length; axisIndex++) {
      final ChartAxis axis = chart._chartAxis._axisCollections[axisIndex];
      axis._isInsideTickPosition = (axis.tickPosition == TickPosition.inside) ? true : false;
      ChartAxis oldAxis;
      bool needAnimate = false;
      if (chart._chartState.oldAxes != null && axis._visibleRange != null) {
        oldAxis = _getOldAxis(axis, chart._chartState.oldAxes);
        if (oldAxis != null && oldAxis._visibleRange != null) {
          needAnimate = chart.enableAxisAnimation &&
              (oldAxis._visibleRange.minimum != axis._visibleRange.minimum ||
                  oldAxis._visibleRange.maximum != axis._visibleRange.maximum);
        }
      }
      axis._orientation == AxisOrientation.horizontal
          ? _drawHorizontalAxes(canvas, axis, animationFactor, oldAxis, needAnimate)
          : _drawVerticalAxes(canvas, axis, animationFactor, oldAxis, needAnimate);
    }
  }

  @override
  bool shouldRepaint(_CartesianAxesPainter oldDelegate) => isRepaint;
}
