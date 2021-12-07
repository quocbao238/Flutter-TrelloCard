part of charts;

class _CrosshairPainter extends CustomPainter {
  _CrosshairPainter({this.chart, this.valueNotifier})
      : super(repaint: valueNotifier);
  final SfCartesianChart chart;
  Timer timer;
  ValueNotifier<int> valueNotifier;
  double pointerLength;
  double pointerWidth;
  double nosePointY = 0;
  double nosePointX = 0;
  double totalWidth = 0;
  double x;
  double y;
  double xPos;
  double yPos;
  bool isTop = false;
  double cornerRadius;
  Path backgroundPath = Path();
  bool canResetPath = false;
  bool isLeft = false;
  bool isRight = false;
  bool enable;
  double padding = 0;
  List<String> stringValue = <String>[];
  Rect boundaryRect = const Rect.fromLTWH(0, 0, 0, 0);
  double leftPadding = 0;
  double topPadding = 0;
  bool isHorizontalOrientation = false;
  TextStyle labelStyle;

  @override
  void paint(Canvas canvas, Size size) {
    if (canResetPath != null && !canResetPath) {
      chart.crosshairBehavior.onPaint(canvas);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;

  /// calculate trackball points
  void _generateAllPoints(Offset position) {
    if (_isRectContains(chart._chartAxis._axisClipRect, position)) {
      chart.crosshairBehavior._position = position;
    }
  }

  Paint _getLinePainter(Paint crosshairLinePaint) => crosshairLinePaint;

  /// Draw the path of the cross hair line
  void _drawCrosshairLine(Canvas canvas, Paint paint, int index) {
    if (chart.crosshairBehavior._position != null) {
      final Path dashArrayPath = Path();
      if (chart.crosshairBehavior.lineType == CrosshairLineType.horizontal ||
          chart.crosshairBehavior.lineType == CrosshairLineType.both) {
        dashArrayPath.moveTo(chart._chartAxis._axisClipRect.left,
            chart.crosshairBehavior._position.dy);
        dashArrayPath.lineTo(chart._chartAxis._axisClipRect.right,
            chart.crosshairBehavior._position.dy);
        chart.crosshairBehavior.lineDashArray != null
            ? _drawDashedLine(canvas, chart.crosshairBehavior.lineDashArray,
                paint, dashArrayPath)
            : canvas.drawPath(dashArrayPath, paint);
      }
      if (chart.crosshairBehavior.lineType == CrosshairLineType.vertical ||
          chart.crosshairBehavior.lineType == CrosshairLineType.both) {
        dashArrayPath.moveTo(chart.crosshairBehavior._position.dx,
            chart._chartAxis._axisClipRect.top);
        dashArrayPath.lineTo(chart.crosshairBehavior._position.dx,
            chart._chartAxis._axisClipRect.bottom);
        chart.crosshairBehavior.lineDashArray != null
            ? _drawDashedLine(canvas, chart.crosshairBehavior.lineDashArray,
                paint, dashArrayPath)
            : canvas.drawPath(dashArrayPath, paint);
      }
    }
  }

  void _drawCrosshair(Canvas canvas) {
    final Paint fillPaint = Paint()
      ..color = chart._chartState._chartTheme.crosshairBackgroundColor
      ..strokeCap = StrokeCap.butt
      ..isAntiAlias = false
      ..style = PaintingStyle.fill;

    final Paint strokePaint = Paint()
      ..color = chart._chartState._chartTheme.crosshairBackgroundColor
      ..strokeCap = StrokeCap.butt
      ..isAntiAlias = false
      ..style = PaintingStyle.stroke;
    chart.crosshairBehavior.lineWidth == 0
        ? strokePaint.color = Colors.transparent
        : strokePaint.color = strokePaint.color;

    final Paint crosshairLinePaint = Paint();
    if (chart.crosshairBehavior._position != null) {
      final Offset position = chart.crosshairBehavior._position;

      crosshairLinePaint.color = chart.crosshairBehavior.lineColor ??
          chart._chartState._chartTheme.crosshairLineColor;
      crosshairLinePaint.strokeWidth = chart.crosshairBehavior.lineWidth;
      crosshairLinePaint.style = PaintingStyle.stroke;
      CrosshairRenderArgs crosshairEventArgs;
      if (chart.onCrosshairPositionChanging != null) {
        crosshairEventArgs = CrosshairRenderArgs();
        crosshairEventArgs.lineColor = crosshairLinePaint.color;
        chart.onCrosshairPositionChanging(crosshairEventArgs);
        crosshairLinePaint.color = crosshairEventArgs.lineColor;
      }
      chart.crosshairBehavior._drawLine(canvas,
          chart.crosshairBehavior._linePainter(crosshairLinePaint), null);

      _drawBottomAxesTooltip(canvas, position, strokePaint, fillPaint);
      _drawTopAxesTooltip(canvas, position, strokePaint, fillPaint);
      _drawLeftAxesTooltip(canvas, position, strokePaint, fillPaint);
      _drawRightAxesTooltip(canvas, position, strokePaint, fillPaint);
    }
  }

  /// draw bottom axes tooltip
  void _drawBottomAxesTooltip(
      Canvas canvas, Offset position, Paint strokePaint, Paint fillPaint) {
    ChartAxis axis;
    dynamic value;
    Size labelSize;
    Rect labelRect, validatedRect;
    RRect tooltipRect;
    Color color;
    const double padding = 10;
    CrosshairRenderArgs crosshairEventArgs;
    for (int index = 0;
        index < chart._chartAxis._bottomAxesCount.length;
        index++) {
      axis = chart._chartAxis._bottomAxesCount[index].axis;
      if (_needToAddTooltip(axis)) {
        fillPaint.color = axis.interactiveTooltip.color != null
            ? axis.interactiveTooltip?.color
            : chart._chartState._chartTheme.crosshairBackgroundColor;
        strokePaint.color = axis.interactiveTooltip.borderColor != null
            ? axis.interactiveTooltip?.borderColor
            : chart._chartState._chartTheme.crosshairBackgroundColor;
        strokePaint.strokeWidth = axis.interactiveTooltip.borderWidth;
        value = _getXValue(axis, position);
        if (chart.onCrosshairPositionChanging != null) {
          crosshairEventArgs = CrosshairRenderArgs();
          crosshairEventArgs.axis = axis;
          crosshairEventArgs.orientation = axis._orientation;
          crosshairEventArgs.axisName = axis._name;
          crosshairEventArgs.text = value.toString();
          crosshairEventArgs.lineColor = chart.crosshairBehavior.lineColor ??
              chart._chartState._chartTheme.crosshairLineColor;
          crosshairEventArgs.value = value;
          crosshairEventArgs.lineColor = color;
          chart.onCrosshairPositionChanging(crosshairEventArgs);
          value = crosshairEventArgs.text;
          color = crosshairEventArgs.lineColor;
        }
        labelSize =
            _measureText(value.toString(), axis.interactiveTooltip.textStyle);
        labelRect = Rect.fromLTWH(
            position.dx - (labelSize.width / 2 + padding / 2),
            axis._bounds.top + axis.interactiveTooltip.arrowLength,
            labelSize.width + padding,
            labelSize.height + padding);
        labelRect =
            _validateRectBounds(labelRect, chart._chartState.containerRect);
        validatedRect = _validateRectXPosition(labelRect, chart);
        backgroundPath.reset();
        tooltipRect = _getRoundedCornerRect(
            validatedRect, axis.interactiveTooltip.borderRadius);
        backgroundPath.addRRect(tooltipRect);
        _drawTooltipArrowhead(
            canvas,
            backgroundPath,
            fillPaint,
            strokePaint,
            position.dx,
            tooltipRect.top - axis.interactiveTooltip.arrowLength,
            (tooltipRect.right - tooltipRect.width / 2) +
                axis.interactiveTooltip.arrowWidth,
            tooltipRect.top,
            (tooltipRect.left + tooltipRect.width / 2) -
                axis.interactiveTooltip.arrowWidth,
            tooltipRect.top,
            position.dx,
            tooltipRect.top - axis.interactiveTooltip.arrowLength);
        _drawText(
            canvas,
            value.toString(),
            Offset(
                (tooltipRect.left + tooltipRect.width / 2) -
                    labelSize.width / 2,
                (tooltipRect.top + tooltipRect.height / 2) -
                    labelSize.height / 2),
            TextStyle(
                color: axis.interactiveTooltip.textStyle.color ??
                    chart._chartState._chartTheme.tooltipLabelColor,
                fontSize: axis.interactiveTooltip.textStyle.fontSize,
                fontWeight: axis.interactiveTooltip.textStyle.fontWeight,
                fontFamily: axis.interactiveTooltip.textStyle.fontFamily,
                fontStyle: axis.interactiveTooltip.textStyle.fontStyle,
                inherit: axis.interactiveTooltip.textStyle.inherit,
                backgroundColor:
                    axis.interactiveTooltip.textStyle.backgroundColor,
                letterSpacing: axis.interactiveTooltip.textStyle.letterSpacing,
                wordSpacing: axis.interactiveTooltip.textStyle.wordSpacing,
                textBaseline: axis.interactiveTooltip.textStyle.textBaseline,
                height: axis.interactiveTooltip.textStyle.height,
                locale: axis.interactiveTooltip.textStyle.locale,
                foreground: axis.interactiveTooltip.textStyle.foreground,
                background: axis.interactiveTooltip.textStyle.background,
                shadows: axis.interactiveTooltip.textStyle.shadows,
                fontFeatures: axis.interactiveTooltip.textStyle.fontFeatures,
                decoration: axis.interactiveTooltip.textStyle.decoration,
                decorationColor:
                    axis.interactiveTooltip.textStyle.decorationColor,
                decorationStyle:
                    axis.interactiveTooltip.textStyle.decorationStyle,
                decorationThickness:
                    axis.interactiveTooltip.textStyle.decorationThickness,
                debugLabel: axis.interactiveTooltip.textStyle.debugLabel,
                fontFamilyFallback:
                    axis.interactiveTooltip.textStyle.fontFamilyFallback),
            0);
      }
    }
  }

  /// draw top axes tooltip
  void _drawTopAxesTooltip(
      Canvas canvas, Offset position, Paint strokePaint, Paint fillPaint) {
    ChartAxis axis;
    dynamic value;
    Size labelSize;
    Rect labelRect, validatedRect;
    RRect tooltipRect;
    const double padding = 10;
    Color color;
    CrosshairRenderArgs crosshairEventArgs;
    for (int index = 0;
        index < chart._chartAxis._topAxesCount.length;
        index++) {
      axis = chart._chartAxis._topAxesCount[index].axis;
      if (_needToAddTooltip(axis)) {
        fillPaint.color = axis.interactiveTooltip.color != null
            ? axis.interactiveTooltip?.color
            : chart._chartState._chartTheme.crosshairBackgroundColor;
        strokePaint.color = axis.interactiveTooltip.borderColor != null
            ? axis.interactiveTooltip?.borderColor
            : chart._chartState._chartTheme.crosshairBackgroundColor;
        strokePaint.strokeWidth = axis.interactiveTooltip.borderWidth;
        value = _getXValue(axis, position);
        if (chart.onCrosshairPositionChanging != null) {
          crosshairEventArgs = CrosshairRenderArgs();
          crosshairEventArgs.axis = axis;
          crosshairEventArgs.orientation = axis._orientation;
          crosshairEventArgs.axisName = axis._name;
          crosshairEventArgs.text = value.toString();
          crosshairEventArgs.lineColor = chart.crosshairBehavior.lineColor ??
              chart._chartState._chartTheme.crosshairLineColor;
          crosshairEventArgs.value = value;
          crosshairEventArgs.lineColor = color;
          chart.onCrosshairPositionChanging(crosshairEventArgs);
          value = crosshairEventArgs.text;
          color = crosshairEventArgs.lineColor;
        }
        labelSize =
            _measureText(value.toString(), axis.interactiveTooltip.textStyle);
        labelRect = Rect.fromLTWH(
            position.dx - (labelSize.width / 2 + padding / 2),
            axis._bounds.top -
                (labelSize.height + padding) -
                axis.interactiveTooltip.arrowLength,
            labelSize.width + padding,
            labelSize.height + padding);
        labelRect =
            _validateRectBounds(labelRect, chart._chartState.containerRect);
        validatedRect = _validateRectXPosition(labelRect, chart);
        backgroundPath.reset();
        tooltipRect = _getRoundedCornerRect(
            validatedRect, axis.interactiveTooltip.borderRadius);
        backgroundPath.addRRect(tooltipRect);

        _drawTooltipArrowhead(
            canvas,
            backgroundPath,
            fillPaint,
            strokePaint,
            position.dx,
            tooltipRect.bottom + axis.interactiveTooltip.arrowLength,
            (tooltipRect.right - tooltipRect.width / 2) +
                axis.interactiveTooltip.arrowWidth,
            tooltipRect.bottom,
            (tooltipRect.left + tooltipRect.width / 2) -
                axis.interactiveTooltip.arrowWidth,
            tooltipRect.bottom,
            position.dx,
            tooltipRect.bottom + axis.interactiveTooltip.arrowLength);
        _drawText(
            canvas,
            value.toString(),
            Offset(
                (tooltipRect.left + tooltipRect.width / 2) -
                    labelSize.width / 2,
                (tooltipRect.top + tooltipRect.height / 2) -
                    labelSize.height / 2),
            TextStyle(
                color: axis.interactiveTooltip.textStyle.color ??
                    chart._chartState._chartTheme.tooltipLabelColor,
                fontSize: axis.interactiveTooltip.textStyle.fontSize,
                fontWeight: axis.interactiveTooltip.textStyle.fontWeight,
                fontFamily: axis.interactiveTooltip.textStyle.fontFamily,
                fontStyle: axis.interactiveTooltip.textStyle.fontStyle,
                inherit: axis.interactiveTooltip.textStyle.inherit,
                backgroundColor:
                    axis.interactiveTooltip.textStyle.backgroundColor,
                letterSpacing: axis.interactiveTooltip.textStyle.letterSpacing,
                wordSpacing: axis.interactiveTooltip.textStyle.wordSpacing,
                textBaseline: axis.interactiveTooltip.textStyle.textBaseline,
                height: axis.interactiveTooltip.textStyle.height,
                locale: axis.interactiveTooltip.textStyle.locale,
                foreground: axis.interactiveTooltip.textStyle.foreground,
                background: axis.interactiveTooltip.textStyle.background,
                shadows: axis.interactiveTooltip.textStyle.shadows,
                fontFeatures: axis.interactiveTooltip.textStyle.fontFeatures,
                decoration: axis.interactiveTooltip.textStyle.decoration,
                decorationColor:
                    axis.interactiveTooltip.textStyle.decorationColor,
                decorationStyle:
                    axis.interactiveTooltip.textStyle.decorationStyle,
                decorationThickness:
                    axis.interactiveTooltip.textStyle.decorationThickness,
                debugLabel: axis.interactiveTooltip.textStyle.debugLabel,
                fontFamilyFallback:
                    axis.interactiveTooltip.textStyle.fontFamilyFallback),
            0);
      }
    }
  }

  /// draw left axes tooltip
  void _drawLeftAxesTooltip(
      Canvas canvas, Offset position, Paint strokePaint, Paint fillPaint) {
    ChartAxis axis;
    dynamic value;
    Size labelSize;
    Rect labelRect, validatedRect;
    RRect tooltipRect;
    const double padding = 10;
    Color color;
    CrosshairRenderArgs crosshairEventArgs;
    for (int index = 0;
        index < chart._chartAxis._leftAxesCount.length;
        index++) {
      axis = chart._chartAxis._leftAxesCount[index].axis;
      if (_needToAddTooltip(axis)) {
        fillPaint.color = axis.interactiveTooltip.color != null
            ? axis.interactiveTooltip.color
            : chart._chartState._chartTheme.crosshairBackgroundColor;
        strokePaint.color = axis.interactiveTooltip.borderColor != null
            ? axis.interactiveTooltip?.borderColor
            : chart._chartState._chartTheme.crosshairBackgroundColor;
        strokePaint.strokeWidth = axis.interactiveTooltip.borderWidth;
        value = _getYValue(axis, position);
        if (chart.onCrosshairPositionChanging != null) {
          crosshairEventArgs = CrosshairRenderArgs();
          crosshairEventArgs.axis = axis;
          crosshairEventArgs.orientation = axis._orientation;
          crosshairEventArgs.axisName = axis._name;
          crosshairEventArgs.text = value.toString();
          crosshairEventArgs.lineColor = chart.crosshairBehavior.lineColor ??
              chart._chartState._chartTheme.crosshairLineColor;
          crosshairEventArgs.value = value;
          crosshairEventArgs.lineColor = color;
          chart.onCrosshairPositionChanging(crosshairEventArgs);
          value = crosshairEventArgs.text;
          color = crosshairEventArgs.lineColor;
        }
        labelSize =
            _measureText(value.toString(), axis.interactiveTooltip.textStyle);
        labelRect = Rect.fromLTWH(
            axis._bounds.left -
                (labelSize.width + padding) -
                axis.interactiveTooltip.arrowLength,
            position.dy - (labelSize.height + padding) / 2,
            labelSize.width + padding,
            labelSize.height + padding);
        labelRect =
            _validateRectBounds(labelRect, chart._chartState.containerRect);
        validatedRect = _validateRectYPosition(labelRect, chart);
        backgroundPath.reset();
        tooltipRect = _getRoundedCornerRect(
            validatedRect, axis.interactiveTooltip.borderRadius);

        backgroundPath.addRRect(tooltipRect);
        _drawTooltipArrowhead(
            canvas,
            backgroundPath,
            fillPaint,
            strokePaint,
            tooltipRect.right,
            tooltipRect.top +
                tooltipRect.height / 2 -
                axis.interactiveTooltip.arrowWidth,
            tooltipRect.right,
            tooltipRect.bottom -
                tooltipRect.height / 2 +
                axis.interactiveTooltip.arrowWidth,
            tooltipRect.right + axis.interactiveTooltip.arrowLength,
            position.dy,
            tooltipRect.right + axis.interactiveTooltip.arrowLength,
            position.dy);
        _drawText(
            canvas,
            value.toString(),
            Offset(
                (tooltipRect.left + tooltipRect.width / 2) -
                    labelSize.width / 2,
                (tooltipRect.top + tooltipRect.height / 2) -
                    labelSize.height / 2),
            TextStyle(
                color: axis.interactiveTooltip.textStyle.color ??
                    chart._chartState._chartTheme.tooltipLabelColor,
                fontSize: axis.interactiveTooltip.textStyle.fontSize,
                fontWeight: axis.interactiveTooltip.textStyle.fontWeight,
                fontFamily: axis.interactiveTooltip.textStyle.fontFamily,
                fontStyle: axis.interactiveTooltip.textStyle.fontStyle,
                inherit: axis.interactiveTooltip.textStyle.inherit,
                backgroundColor:
                    axis.interactiveTooltip.textStyle.backgroundColor,
                letterSpacing: axis.interactiveTooltip.textStyle.letterSpacing,
                wordSpacing: axis.interactiveTooltip.textStyle.wordSpacing,
                textBaseline: axis.interactiveTooltip.textStyle.textBaseline,
                height: axis.interactiveTooltip.textStyle.height,
                locale: axis.interactiveTooltip.textStyle.locale,
                foreground: axis.interactiveTooltip.textStyle.foreground,
                background: axis.interactiveTooltip.textStyle.background,
                shadows: axis.interactiveTooltip.textStyle.shadows,
                fontFeatures: axis.interactiveTooltip.textStyle.fontFeatures,
                decoration: axis.interactiveTooltip.textStyle.decoration,
                decorationColor:
                    axis.interactiveTooltip.textStyle.decorationColor,
                decorationStyle:
                    axis.interactiveTooltip.textStyle.decorationStyle,
                decorationThickness:
                    axis.interactiveTooltip.textStyle.decorationThickness,
                debugLabel: axis.interactiveTooltip.textStyle.debugLabel,
                fontFamilyFallback:
                    axis.interactiveTooltip.textStyle.fontFamilyFallback),
            0);
      }
    }
  }

  /// draw right axes tooltip
  void _drawRightAxesTooltip(
      Canvas canvas, Offset position, Paint strokePaint, Paint fillPaint) {
    ChartAxis axis;
    dynamic value;
    Size labelSize;
    Rect labelRect, validatedRect;
    CrosshairRenderArgs crosshairEventArgs;
    RRect tooltipRect;
    Color color;
    const double padding = 10;
    for (int index = 0;
        index < chart._chartAxis._rightAxesCount.length;
        index++) {
      axis = chart._chartAxis._rightAxesCount[index].axis;
      if (_needToAddTooltip(axis)) {
        fillPaint.color = axis.interactiveTooltip.color != null
            ? axis.interactiveTooltip.color
            : chart._chartState._chartTheme.crosshairBackgroundColor;
        strokePaint.color = axis.interactiveTooltip.borderColor != null
            ? axis.interactiveTooltip?.borderColor
            : chart._chartState._chartTheme.crosshairBackgroundColor;
        strokePaint.strokeWidth = axis.interactiveTooltip.borderWidth;
        value = _getYValue(axis, position);
        if (chart.onCrosshairPositionChanging != null) {
          crosshairEventArgs = CrosshairRenderArgs();
          crosshairEventArgs.axis = axis;
          crosshairEventArgs.orientation = axis._orientation;
          crosshairEventArgs.axisName = axis._name;
          crosshairEventArgs.text = value.toString();
          crosshairEventArgs.lineColor = chart.crosshairBehavior.lineColor ??
              chart._chartState._chartTheme.crosshairLineColor;
          crosshairEventArgs.value = value;
          crosshairEventArgs.lineColor = color;
          chart.onCrosshairPositionChanging(crosshairEventArgs);
          value = crosshairEventArgs.text;
          color = crosshairEventArgs.lineColor;
        }
        labelSize =
            _measureText(value.toString(), axis.interactiveTooltip.textStyle);
        labelRect = Rect.fromLTWH(
            axis._bounds.left + axis.interactiveTooltip.arrowLength,
            position.dy - (labelSize.height / 2 + padding / 2),
            labelSize.width + padding,
            labelSize.height + padding);
        labelRect =
            _validateRectBounds(labelRect, chart._chartState.containerRect);
        validatedRect = _validateRectYPosition(labelRect, chart);
        backgroundPath.reset();
        tooltipRect = _getRoundedCornerRect(
            validatedRect, axis.interactiveTooltip.borderRadius);
        backgroundPath.addRRect(tooltipRect);
        _drawTooltipArrowhead(
            canvas,
            backgroundPath,
            fillPaint,
            strokePaint,
            tooltipRect.left,
            tooltipRect.top +
                tooltipRect.height / 2 -
                axis.interactiveTooltip.arrowWidth,
            tooltipRect.left,
            tooltipRect.bottom -
                tooltipRect.height / 2 +
                axis.interactiveTooltip.arrowWidth,
            tooltipRect.left - axis.interactiveTooltip.arrowLength,
            position.dy,
            tooltipRect.left - axis.interactiveTooltip.arrowLength,
            position.dy);
        _drawText(
            canvas,
            value.toString(),
            Offset(
                (tooltipRect.left + tooltipRect.width / 2) -
                    labelSize.width / 2,
                (tooltipRect.top + tooltipRect.height / 2) -
                    labelSize.height / 2),
            TextStyle(
                color: axis.interactiveTooltip.textStyle.color ??
                    chart._chartState._chartTheme.tooltipLabelColor,
                fontSize: axis.interactiveTooltip.textStyle.fontSize,
                fontWeight: axis.interactiveTooltip.textStyle.fontWeight,
                fontFamily: axis.interactiveTooltip.textStyle.fontFamily,
                fontStyle: axis.interactiveTooltip.textStyle.fontStyle,
                inherit: axis.interactiveTooltip.textStyle.inherit,
                backgroundColor:
                    axis.interactiveTooltip.textStyle.backgroundColor,
                letterSpacing: axis.interactiveTooltip.textStyle.letterSpacing,
                wordSpacing: axis.interactiveTooltip.textStyle.wordSpacing,
                textBaseline: axis.interactiveTooltip.textStyle.textBaseline,
                height: axis.interactiveTooltip.textStyle.height,
                locale: axis.interactiveTooltip.textStyle.locale,
                foreground: axis.interactiveTooltip.textStyle.foreground,
                background: axis.interactiveTooltip.textStyle.background,
                shadows: axis.interactiveTooltip.textStyle.shadows,
                fontFeatures: axis.interactiveTooltip.textStyle.fontFeatures,
                decoration: axis.interactiveTooltip.textStyle.decoration,
                decorationColor:
                    axis.interactiveTooltip.textStyle.decorationColor,
                decorationStyle:
                    axis.interactiveTooltip.textStyle.decorationStyle,
                decorationThickness:
                    axis.interactiveTooltip.textStyle.decorationThickness,
                debugLabel: axis.interactiveTooltip.textStyle.debugLabel,
                fontFamilyFallback:
                    axis.interactiveTooltip.textStyle.fontFamilyFallback),
            0);
      }
    }
  }

  /// To find the x value of crosshair
  dynamic _getXValue(ChartAxis axis, Offset position) {
    final dynamic value = _pointToXValue(
        chart,
        axis,
        axis._bounds,
        position.dx - (chart._chartAxis._axisClipRect.left + axis.plotOffset),
        position.dy - (chart._chartAxis._axisClipRect.top + axis.plotOffset));
    return _getInteractiveTooltipLabel(value, axis);
  }

  /// To find the y value of crosshair
  dynamic _getYValue(ChartAxis axis, Offset position) {
    final dynamic value = _pointToYVal(
        chart,
        axis,
        axis._bounds,
        position.dx - (chart._chartAxis._axisClipRect.left + axis.plotOffset),
        position.dy - (chart._chartAxis._axisClipRect.top + axis.plotOffset));
    return _getInteractiveTooltipLabel(value, axis);
  }

  /// To add the tooltip for crosshair
  bool _needToAddTooltip(ChartAxis axis) {
    return axis.interactiveTooltip.enable &&
        ((!(axis is CategoryAxis) && axis._visibleLabels.isNotEmpty) ||
            (axis is CategoryAxis && axis._labels.isNotEmpty));
  }
}
