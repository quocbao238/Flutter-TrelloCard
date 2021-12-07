part of charts;

// ignore: must_be_immutable
class _CircularDataLabelRenderer extends StatefulWidget {
  // ignore: prefer_const_constructors_in_immutables
  _CircularDataLabelRenderer({this.circularChart, this.show});

  final SfCircularChart circularChart;

  bool show;

  _CircularDataLabelRendererState state;

  @override
  State<StatefulWidget> createState() {
    return _CircularDataLabelRendererState();
  }
}

class _CircularDataLabelRendererState extends State<_CircularDataLabelRenderer>
    with SingleTickerProviderStateMixin {
  List<AnimationController> animationControllersList;

  /// Animation controller for series
  AnimationController animationController;

  /// Repaint notifier for crosshair container
  ValueNotifier<int> dataLabelRepaintNotifier;

  @override
  void initState() {
    dataLabelRepaintNotifier = ValueNotifier<int>(0);
    animationController = AnimationController(vsync: this)
      ..addListener(repaintDataLabelElements);
    super.initState();
  }

  @override
  void dispose() {
    if (animationController != null) {
      animationController.removeListener(repaintDataLabelElements);
      animationController.dispose();
      animationController = null;
    }
    super.dispose();
  }

  void repaintDataLabelElements() {
    dataLabelRepaintNotifier.value++;
  }

  void render() {
    setState(() {
      widget.show = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    widget.state = this;
    animationController.duration = Duration(
        milliseconds: widget.circularChart._chartState.initialRender ? 500 : 0);
    final Animation<double> dataLabelAnimation =
        Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
      parent: animationController,
      curve: const Interval(0.1, 0.8, curve: Curves.decelerate),
    ));
    animationController.forward(from: 0.0);
    return !widget.show
        ? Container()
        : Container(
            child: CustomPaint(
                painter: _CircularDataLabelPainter(
                    circularChart: widget.circularChart,
                    animation: dataLabelAnimation,
                    state: this,
                    notifier: dataLabelRepaintNotifier,
                    animationController: animationController)));
  }
}

class _CircularDataLabelPainter extends CustomPainter {
  _CircularDataLabelPainter(
      {this.circularChart,
      this.state,
      this.animationController,
      this.animation,
      ValueNotifier<num> notifier})
      : super(repaint: notifier);

  final SfCircularChart circularChart;

  final _CircularDataLabelRendererState state;

  final AnimationController animationController;

  final Animation<double> animation;

  @override
  void paint(Canvas canvas, Size size) {
    final List<CircularSeriesRenderer> visibleSeriesRenderers =
        circularChart._chartSeries.visibleSeriesRenderers;
    for (int seriesIndex = 0;
        seriesIndex < visibleSeriesRenderers.length;
        seriesIndex++) {
      final CircularSeriesRenderer seriesRenderer =
          visibleSeriesRenderers[seriesIndex];
      if (seriesRenderer._series.dataLabelSettings != null &&
          seriesRenderer._series.dataLabelSettings.isVisible) {
        _renderDataLabel(
            seriesRenderer, canvas, circularChart, seriesIndex, animation);
      }
    }
  }

  @override
  bool shouldRepaint(_CircularDataLabelPainter oldDelegate) => true;
}

void _renderDataLabel(CircularSeriesRenderer seriesRenderer, Canvas canvas,
    SfCircularChart chart, int seriesIndex, Animation<double> animation) {
  ChartPoint<dynamic> point;
  final DataLabelSettings dataLabel = seriesRenderer._series.dataLabelSettings;
  final num angle = dataLabel.angle;
  Offset labelLocation;
  const int labelPadding = 2;
  String label;
  final double animateOpacity = animation != null ? animation.value : 1;
  DataLabelRenderArgs dataLabelArgs;
  TextStyle dataLabelStyle;
  final List<Rect> renderDataLabelRegions = <Rect>[];
  for (int pointIndex = 0;
      pointIndex < seriesRenderer._renderPoints.length;
      pointIndex++) {
    point = seriesRenderer._renderPoints[pointIndex];
    if (point.isVisible && (point.y != 0 || dataLabel.showZeroValue)) {
      label = point.text;
      label = seriesRenderer._series._renderer.getLabelContent(
          seriesRenderer, point, pointIndex, seriesIndex, label);
      dataLabelStyle = dataLabel.textStyle;
      seriesRenderer._series.dataLabelSettings._color =
          seriesRenderer._series.dataLabelSettings.color;
      if (chart.onDataLabelRender != null) {
        dataLabelArgs = DataLabelRenderArgs();
        dataLabelArgs.text = label;
        dataLabelArgs.textStyle = dataLabelStyle;
        dataLabelArgs.seriesRenderer = seriesRenderer;
        dataLabelArgs.dataPoints = seriesRenderer._renderPoints;
        dataLabelArgs.pointIndex = pointIndex;
        dataLabelArgs.color = seriesRenderer._series.dataLabelSettings._color;
        chart.onDataLabelRender(dataLabelArgs);
        label = dataLabelArgs.text;
        dataLabelStyle = dataLabelArgs.textStyle;
        seriesRenderer._series.dataLabelSettings._color = dataLabelArgs.color;
      }
      dataLabelStyle = chart.onDataLabelRender == null
          ? seriesRenderer._series._renderer.getDataLabelStyle(seriesRenderer,
              point, pointIndex, seriesIndex, dataLabelStyle, chart)
          : dataLabelStyle;
      final Size textSize = _measureText(label, dataLabelStyle);

      /// condition check for labels after event.
      if (label != '') {
        if (seriesRenderer._seriesType == 'radialbar') {
          labelLocation = _degreeToPoint(point.startAngle,
              (point.innerRadius + point.outerRadius) / 2, point.center);
          labelLocation = Offset(
              (labelLocation.dx - textSize.width - 5) +
                  (angle == 0 ? 0 : textSize.width / 2),
              (labelLocation.dy - textSize.height / 2) +
                  (angle == 0 ? 0 : textSize.height / 2));
          point.labelRect = Rect.fromLTWH(
              labelLocation.dx - labelPadding,
              labelLocation.dy - labelPadding,
              textSize.width + (2 * labelPadding),
              textSize.height + (2 * labelPadding));
          _drawLabel(
              point.labelRect,
              labelLocation,
              label,
              null,
              canvas,
              seriesRenderer,
              point,
              pointIndex,
              seriesIndex,
              chart,
              dataLabelStyle,
              renderDataLabelRegions,
              animateOpacity);
        } else {
          _setLabelPosition(
              dataLabel,
              point,
              textSize,
              chart,
              canvas,
              renderDataLabelRegions,
              pointIndex,
              label,
              seriesRenderer,
              animateOpacity,
              dataLabelStyle,
              seriesIndex);
        }
      }
    }
  }
}

void _setLabelPosition(
    DataLabelSettings dataLabel,
    ChartPoint<dynamic> point,
    Size textSize,
    SfCircularChart chart,
    Canvas canvas,
    List<Rect> renderDataLabelRegions,
    int pointIndex,
    String label,
    dynamic seriesRenderer,
    double animateOpacity,
    TextStyle dataLabelStyle,
    int seriesIndex) {
  final num angle = dataLabel.angle;
  Offset labelLocation;
  final bool smartLabel = seriesRenderer._series.enableSmartLabels;
  const int labelPadding = 2;
  if (dataLabel.labelPosition == ChartDataLabelPosition.inside) {
    labelLocation = _degreeToPoint(point.midAngle,
        (point.innerRadius + point.outerRadius) / 2, point.center);
    labelLocation = Offset(
        labelLocation.dx -
            (textSize.width / 2) +
            (angle == 0 ? 0 : textSize.width / 2),
        labelLocation.dy -
            (textSize.height / 2) +
            (angle == 0 ? 0 : textSize.height / 2));
    point.labelRect = Rect.fromLTWH(
        labelLocation.dx - labelPadding,
        labelLocation.dy - labelPadding,
        textSize.width + (2 * labelPadding),
        textSize.height + (2 * labelPadding));
    final bool isDataLabelCollide =
        _isCollide(point.labelRect, renderDataLabelRegions);
    if (smartLabel && isDataLabelCollide) {
      point.saturationRegionOutside = true;
      point.renderPosition = ChartDataLabelPosition.outside;
      dataLabelStyle = TextStyle(
          color: (dataLabelStyle.color ?? dataLabel.textStyle.color) ??
              _getSaturationColor(_findthemecolor(chart, point, dataLabel)),
          fontSize: dataLabelStyle.fontSize ?? dataLabel.textStyle.fontSize,
          fontFamily:
              dataLabelStyle.fontFamily ?? dataLabel.textStyle.fontFamily,
          fontStyle: dataLabelStyle.fontStyle ?? dataLabel.textStyle.fontStyle,
          fontWeight:
              dataLabelStyle.fontWeight ?? dataLabel.textStyle.fontWeight,
          inherit: dataLabelStyle.inherit ?? dataLabel.textStyle.inherit,
          backgroundColor: dataLabelStyle.backgroundColor ??
              dataLabel.textStyle.backgroundColor,
          letterSpacing:
              dataLabelStyle.letterSpacing ?? dataLabel.textStyle.letterSpacing,
          wordSpacing:
              dataLabelStyle.wordSpacing ?? dataLabel.textStyle.wordSpacing,
          textBaseline:
              dataLabelStyle.textBaseline ?? dataLabel.textStyle.textBaseline,
          height: dataLabelStyle.height ?? dataLabel.textStyle.height,
          locale: dataLabelStyle.locale ?? dataLabel.textStyle.locale,
          foreground:
              dataLabelStyle.foreground ?? dataLabel.textStyle.foreground,
          background:
              dataLabelStyle.background ?? dataLabel.textStyle.background,
          shadows: dataLabelStyle.shadows ?? dataLabel.textStyle.shadows,
          fontFeatures:
              dataLabelStyle.fontFeatures ?? dataLabel.textStyle.fontFeatures,
          decoration:
              dataLabelStyle.decoration ?? dataLabel.textStyle.decoration,
          decorationColor: dataLabelStyle.decorationColor ??
              dataLabel.textStyle.decorationColor,
          decorationStyle: dataLabelStyle.decorationStyle ??
              dataLabel.textStyle.decorationStyle,
          decorationThickness: dataLabelStyle.decorationThickness ??
              dataLabel.textStyle.decorationThickness,
          debugLabel:
              dataLabelStyle.debugLabel ?? dataLabel.textStyle.debugLabel,
          fontFamilyFallback: dataLabelStyle.fontFamilyFallback ??
              dataLabel.textStyle.fontFamilyFallback);
      _renderOutsideDataLabel(
          canvas,
          label,
          point,
          textSize,
          pointIndex,
          seriesRenderer,
          smartLabel,
          seriesIndex,
          chart,
          dataLabelStyle,
          renderDataLabelRegions,
          animateOpacity);
    } else {
      point.renderPosition = ChartDataLabelPosition.inside;
      dataLabelStyle = TextStyle(
          color: (chart.onDataLabelRender != null &&
                  dataLabel.textStyle.color != null)
              ? _getSaturationColor(dataLabel._color ?? point.fill)
              : ((dataLabelStyle.color ?? dataLabel.textStyle.color) ??
                  _getSaturationColor(dataLabel._color ?? point.fill)),
          fontSize: dataLabelStyle.fontSize ?? dataLabel.textStyle.fontSize,
          fontFamily:
              dataLabelStyle.fontFamily ?? dataLabel.textStyle.fontFamily,
          fontStyle: dataLabelStyle.fontStyle ?? dataLabel.textStyle.fontStyle,
          fontWeight:
              dataLabelStyle.fontWeight ?? dataLabel.textStyle.fontWeight,
          inherit: dataLabelStyle.inherit ?? dataLabel.textStyle.inherit,
          backgroundColor: dataLabelStyle.backgroundColor ??
              dataLabel.textStyle.backgroundColor,
          letterSpacing:
              dataLabelStyle.letterSpacing ?? dataLabel.textStyle.letterSpacing,
          wordSpacing:
              dataLabelStyle.wordSpacing ?? dataLabel.textStyle.wordSpacing,
          textBaseline:
              dataLabelStyle.textBaseline ?? dataLabel.textStyle.textBaseline,
          height: dataLabelStyle.height ?? dataLabel.textStyle.height,
          locale: dataLabelStyle.locale ?? dataLabel.textStyle.locale,
          foreground:
              dataLabelStyle.foreground ?? dataLabel.textStyle.foreground,
          background:
              dataLabelStyle.background ?? dataLabel.textStyle.background,
          shadows: dataLabelStyle.shadows ?? dataLabel.textStyle.shadows,
          fontFeatures:
              dataLabelStyle.fontFeatures ?? dataLabel.textStyle.fontFeatures,
          decoration:
              dataLabelStyle.decoration ?? dataLabel.textStyle.decoration,
          decorationColor: dataLabelStyle.decorationColor ??
              dataLabel.textStyle.decorationColor,
          decorationStyle: dataLabelStyle.decorationStyle ??
              dataLabel.textStyle.decorationStyle,
          decorationThickness: dataLabelStyle.decorationThickness ??
              dataLabel.textStyle.decorationThickness,
          debugLabel:
              dataLabelStyle.debugLabel ?? dataLabel.textStyle.debugLabel,
          fontFamilyFallback: dataLabelStyle.fontFamilyFallback ??
              dataLabel.textStyle.fontFamilyFallback);
      if (isDataLabelCollide
          ? (dataLabel.labelIntersectAction == LabelIntersectAction.hide)
              ? false
              : true
          : true) {
        _drawLabel(
            point.labelRect,
            labelLocation,
            label,
            null,
            canvas,
            seriesRenderer,
            point,
            pointIndex,
            seriesIndex,
            chart,
            dataLabelStyle,
            renderDataLabelRegions,
            animateOpacity);
      }
    }
  } else {
    point.renderPosition = ChartDataLabelPosition.outside;
    dataLabelStyle = TextStyle(
        color: (dataLabelStyle.color ?? dataLabel.textStyle.color) ??
            _getSaturationColor(_findthemecolor(chart, point, dataLabel)),
        fontSize: dataLabelStyle.fontSize ?? dataLabel.textStyle.fontSize,
        fontFamily: dataLabelStyle.fontFamily ?? dataLabel.textStyle.fontFamily,
        fontStyle: dataLabelStyle.fontStyle ?? dataLabel.textStyle.fontStyle,
        fontWeight: dataLabelStyle.fontWeight ?? dataLabel.textStyle.fontWeight,
        inherit: dataLabelStyle.inherit ?? dataLabel.textStyle.inherit,
        backgroundColor: dataLabelStyle.backgroundColor ??
            dataLabel.textStyle.backgroundColor,
        letterSpacing:
            dataLabelStyle.letterSpacing ?? dataLabel.textStyle.letterSpacing,
        wordSpacing:
            dataLabelStyle.wordSpacing ?? dataLabel.textStyle.wordSpacing,
        textBaseline:
            dataLabelStyle.textBaseline ?? dataLabel.textStyle.textBaseline,
        height: dataLabelStyle.height ?? dataLabel.textStyle.height,
        locale: dataLabelStyle.locale ?? dataLabel.textStyle.locale,
        foreground: dataLabelStyle.foreground ?? dataLabel.textStyle.foreground,
        background: dataLabelStyle.background ?? dataLabel.textStyle.background,
        shadows: dataLabelStyle.shadows ?? dataLabel.textStyle.shadows,
        fontFeatures:
            dataLabelStyle.fontFeatures ?? dataLabel.textStyle.fontFeatures,
        decoration: dataLabelStyle.decoration ?? dataLabel.textStyle.decoration,
        decorationColor: dataLabelStyle.decorationColor ??
            dataLabel.textStyle.decorationColor,
        decorationStyle: dataLabelStyle.decorationStyle ??
            dataLabel.textStyle.decorationStyle,
        decorationThickness: dataLabelStyle.decorationThickness ??
            dataLabel.textStyle.decorationThickness,
        debugLabel: dataLabelStyle.debugLabel ?? dataLabel.textStyle.debugLabel,
        fontFamilyFallback: dataLabelStyle.fontFamilyFallback ??
            dataLabel.textStyle.fontFamilyFallback);
    _renderOutsideDataLabel(
        canvas,
        label,
        point,
        textSize,
        pointIndex,
        seriesRenderer,
        smartLabel,
        seriesIndex,
        chart,
        dataLabelStyle,
        renderDataLabelRegions,
        animateOpacity);
  }
}

void _renderOutsideDataLabel(
    Canvas canvas,
    String label,
    ChartPoint<dynamic> point,
    Size textSize,
    int pointIndex,
    CircularSeriesRenderer seriesRenderer,
    bool smartLabel,
    int seriesIndex,
    SfCircularChart chart,
    TextStyle textStyle,
    List<Rect> renderDataLabelRegions,
    double animateOpacity) {
  Path connectorPath;
  Rect rect;
  Offset labelLocation;
  final EdgeInsets margin = seriesRenderer._series.dataLabelSettings.margin;
  final ConnectorLineSettings connector =
      seriesRenderer._series.dataLabelSettings.connectorLineSettings;
  connectorPath = Path();
  final num connectorLength = _percentToValue(
      connector.length != null ? connector.length : '10%', point.outerRadius);
  final Offset startPoint =
      _degreeToPoint(point.midAngle, point.outerRadius, point.center);
  final Offset endPoint = _degreeToPoint(
      point.midAngle, point.outerRadius + connectorLength, point.center);
  connectorPath.moveTo(startPoint.dx, startPoint.dy);
  if (connector.type == ConnectorType.line) {
    connectorPath.lineTo(endPoint.dx, endPoint.dy);
  }
  rect = _getDataLabelRect(point.dataLabelPosition, connector.type, margin,
      connectorPath, endPoint, textSize);
  point.labelRect = rect;
  labelLocation = Offset(rect.left + margin.left,
      rect.top + rect.height / 2 - textSize.height / 2);
  final Rect containerRect = chart._chartState.chartAreaRect;
  if (seriesRenderer._series.dataLabelSettings.builder == null) {
    if (seriesRenderer._series.dataLabelSettings.labelIntersectAction ==
        LabelIntersectAction.hide) {
      if (!_isCollide(rect, renderDataLabelRegions) &&
          (rect.left > containerRect.left &&
              rect.left + rect.width <
                  containerRect.left + containerRect.width) &&
          rect.top > containerRect.top &&
          rect.top + rect.height < containerRect.top + containerRect.height) {
        _drawLabel(
            rect,
            labelLocation,
            label,
            connectorPath,
            canvas,
            seriesRenderer,
            point,
            pointIndex,
            seriesIndex,
            chart,
            textStyle,
            renderDataLabelRegions,
            animateOpacity);
      }
    } else {
      _drawLabel(
          rect,
          labelLocation,
          label,
          connectorPath,
          canvas,
          seriesRenderer,
          point,
          pointIndex,
          seriesIndex,
          chart,
          textStyle,
          renderDataLabelRegions,
          animateOpacity);
    }
  } else {
    canvas.drawPath(
        connectorPath,
        Paint()
          ..color = connector.width <= 0
              ? Colors.transparent
              : connector.color ?? point.fill.withOpacity(animateOpacity)
          ..strokeWidth = connector.width
          ..style = PaintingStyle.stroke);
  }
}

void _drawLabel(
    Rect labelRect,
    Offset location,
    String label,
    Path connectorPath,
    Canvas canvas,
    CircularSeriesRenderer seriesRenderer,
    ChartPoint<dynamic> point,
    int pointIndex,
    int seriesIndex,
    SfCircularChart chart,
    TextStyle textStyle,
    List<Rect> renderDataLabelRegions,
    double animateOpacity) {
  Paint rectPaint;
  final DataLabelSettings dataLabel = seriesRenderer._series.dataLabelSettings;
  final ConnectorLineSettings connector = dataLabel.connectorLineSettings;
  if (connectorPath != null) {
    canvas.drawPath(
        connectorPath,
        Paint()
          ..color = connector.width <= 0
              ? Colors.transparent
              : connector.color ?? point.fill.withOpacity(animateOpacity)
          ..strokeWidth = connector.width
          ..style = PaintingStyle.stroke);
  }

  if (dataLabel.builder == null) {
    final double strokeWidth = seriesRenderer._series._renderer
        .getDataLabelStrokeWidth(seriesRenderer, point, pointIndex, seriesIndex,
            dataLabel.borderWidth);
    final Color labelFill = seriesRenderer._series._renderer.getDataLabelColor(
        seriesRenderer,
        point,
        pointIndex,
        seriesIndex,
        dataLabel._color != null
            ? dataLabel._color
            : (dataLabel.useSeriesColor ? point.fill : dataLabel._color));
    final Color strokeColor = seriesRenderer._series._renderer
        .getDataLabelStrokeColor(seriesRenderer, point, pointIndex, seriesIndex,
            dataLabel.borderColor.withOpacity(dataLabel.opacity));
    if (strokeWidth != null && strokeWidth > 0) {
      rectPaint = Paint()
        ..color = strokeColor.withOpacity(
            (animateOpacity - (1 - dataLabel.opacity)) < 0
                ? 0
                : animateOpacity - (1 - dataLabel.opacity))
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth;
      _drawLabelRect(
          rectPaint,
          Rect.fromLTRB(
              labelRect.left, labelRect.top, labelRect.right, labelRect.bottom),
          dataLabel.borderRadius,
          canvas);
    }
    if (labelFill != null) {
      _drawLabelRect(
          Paint()
            ..color = labelFill.withOpacity(
                (animateOpacity - (1 - dataLabel.opacity)) < 0
                    ? 0
                    : animateOpacity - (1 - dataLabel.opacity))
            ..style = PaintingStyle.fill,
          Rect.fromLTRB(
              labelRect.left, labelRect.top, labelRect.right, labelRect.bottom),
          dataLabel.borderRadius,
          canvas);
    }
    _drawText(canvas, label, location, textStyle, dataLabel.angle);
    renderDataLabelRegions.add(labelRect);
  }
}

void _drawLabelRect(
        Paint paint, Rect labelRect, double borderRadius, Canvas canvas) =>
    canvas.drawRRect(
        RRect.fromRectAndRadius(labelRect, Radius.circular(borderRadius)),
        paint);

void _findDataLabelPosition(ChartPoint<dynamic> point) =>
    point.dataLabelPosition = ((point.midAngle >= -90 && point.midAngle < 0) ||
            (point.midAngle >= 0 && point.midAngle < 90) ||
            (point.midAngle >= 270))
        ? Position.right
        : Position.left;

/// Method for setting color to datalabel
Color _findthemecolor(SfCircularChart chart, ChartPoint<dynamic> point,
    DataLabelSettings dataLabel) {
  return dataLabel.color ??
      (dataLabel.useSeriesColor
          ? point.fill
          : (chart.backgroundColor ??
              (chart._chartState._chartTheme.brightness == Brightness.light
                  ? Colors.white
                  : Colors.black)));
}
