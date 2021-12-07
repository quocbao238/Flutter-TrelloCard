part of charts;

/// Returns the LegendRenderArgs.
typedef PyramidLegendRenderCallback = void Function(
    LegendRenderArgs legendRenderArganimateCompleteds);

/// Returns the TooltipArgs.
typedef PyramidTooltipCallback = void Function(TooltipArgs tooltipArgs);

/// Returns the DataLabelRenderArgs.
typedef PyramidDataLabelRenderCallback = void Function(
    DataLabelRenderArgs dataLabelArgs);

/// Returns the SelectionArgs.
typedef PyramidSelectionCallback = void Function(SelectionArgs selectionArgs);

///Returns tha PointTapArgs.
typedef PyramidPointTapCallback = void Function(PointTapArgs pointTapArgs);

/// Returns the Offset
typedef PyramidTouchInteractionCallback = void Function(
    ChartTouchInteractionArgs tapArgs);

///Renders the pyramid chart
///
///To render a pyramid chart, create an instance of PyramidSeries, and add it to the series property of SfPyramidChart
///
///Properties such as opacity, [borderWidth], [borderColor], pointColorMapper
///are used to customize the appearance of a pyramid segment.
//ignore:must_be_immutable
class SfPyramidChart extends StatefulWidget {
  SfPyramidChart({
    Key key,
    this.backgroundColor,
    this.backgroundImage,
    this.borderColor = Colors.transparent,
    this.borderWidth = 0.0,
    this.onLegendItemRender,
    this.onTooltipRender,
    this.onDataLabelRender,
    this.onPointTapped,
    this.onLegendTapped,
    this.onSelectionChanged,
    this.onChartTouchInteractionUp,
    this.onChartTouchInteractionDown,
    this.onChartTouchInteractionMove,
    ChartTitle title,
    PyramidSeries<dynamic, dynamic> series,
    EdgeInsets margin,
    Legend legend,
    this.palette = const <Color>[
      Color.fromRGBO(53, 92, 125, 1),
      Color.fromRGBO(192, 108, 132, 1),
      Color.fromRGBO(246, 114, 128, 1),
      Color.fromRGBO(248, 177, 149, 1),
      Color.fromRGBO(116, 180, 155, 1),
      Color.fromRGBO(0, 168, 181, 1),
      Color.fromRGBO(73, 76, 162, 1),
      Color.fromRGBO(255, 205, 96, 1),
      Color.fromRGBO(255, 240, 219, 1),
      Color.fromRGBO(238, 238, 238, 1)
    ],
    TooltipBehavior tooltipBehavior,
    SmartLabelMode smartLabelMode,
    ActivationMode selectionGesture,
    bool enableMultiSelection,
  })  : title = title ?? ChartTitle(),
        series = series ?? series,
        margin = margin ?? const EdgeInsets.fromLTRB(10, 10, 10, 10),
        legend = legend ?? Legend(),
        tooltipBehavior = tooltipBehavior ?? TooltipBehavior(),
        smartLabelMode = smartLabelMode ?? SmartLabelMode.hide,
        selectionGesture = selectionGesture ?? ActivationMode.singleTap,
        enableMultiSelection = enableMultiSelection ?? false,
        super(key: key) {
    _chartSeries = _PyramidSeries();
    _chartLegend = _ChartLegend();
    _chartPlotArea = _PyramidPlotArea();
  }

  ///Customizes the chart title
  ///
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfPyramidChart(
  ///            title: ChartTitle(text: 'Pyramid Chart')
  ///        ));
  ///}
  ///```
  final ChartTitle title;

  ///Background color of the chart
  ///
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfPyramidChart(
  ///            backgroundColor: Colors.blue
  ///        ));
  ///}
  ///```
  final Color backgroundColor;

  ///Background color of the chart
  ///
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfPyramidChart(
  ///            backgroundColor: Colors.blue
  ///        ));
  ///}
  ///```
  final Color borderColor;

  ///Border width of the chart
  ///
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfPyramidChart(
  ///            backgroundColor: Colors.blue
  ///        ));
  ///}
  ///```
  final double borderWidth;

  ///Customizes the chart series.
  ///
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfPyramidChart(
  ///            series: PyramidSeries<_PyramidData, String>(
  ///                          dataSource: data,
  ///                          xValueMapper: (_PyramidData data, _) => data.xData,
  ///                          yValueMapper: (_PyramidData data, _) => data.yData)
  ///        ));
  ///}
  ///```
  final PyramidSeries<dynamic, dynamic> series;

  ///Margin for chart
  ///
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfPyramidChart(
  ///            margin: const EdgeInsets.all(2),
  ///        ));
  ///}
  ///```
  final EdgeInsets margin;

  ///Customizes the legend in the chart
  ///
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfPyramidChart(
  ///            legend: Legend(isVisible: true)
  ///        ));
  ///}
  ///```
  final Legend legend;

  ///Color palette for the data points in the chart series.
  ///
  ///If the series color is not specified, then the series will be rendered with appropriate palette color.
  ///Ten colors are available by default.
  ///
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfPyramidChart(
  ///            palette: <Color>[Colors.red, Colors.green]
  ///        ));
  ///}
  ///```
  final List<Color> palette;

  ///Customizes the tooltip in chart
  ///
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfPyramidChart(
  ///            tooltipBehavior: TooltipBehavior(enable: true)
  ///        ));
  ///}
  ///```
  final TooltipBehavior tooltipBehavior;

  /// Occurs while legend is rendered.
  ///
  /// Here, you can get the legend's text, shape, series index, and point index case of circular series.
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfPyramidChart(
  ///            legend: Legend(isVisible: true),
  ///            onLegendItemRender: (LegendRendererArgs args) => legend(args),
  ///        ));
  ///}
  ///dynamic legend(LegendRendererArgs args) {
  ///   args.legendIconType = LegendIconType.diamond;
  ///}
  ///```
  final PyramidLegendRenderCallback onLegendItemRender;

  /// Occurs when the tooltip is rendered.
  ///
  /// Here,you can get the tooltip arguments and customize the arguments.
  final PyramidTooltipCallback onTooltipRender;

  /// Occurs when the datalabel is rendered,Here datalabel arguments can be customized.
  final PyramidDataLabelRenderCallback onDataLabelRender;

  /// Occurs when the legend is tapped,the arguments can be used to customize the legend arguments
  final ChartLegendTapCallback onLegendTapped;

  ///smart labelmode to avoid the overlapping of labels.
  final SmartLabelMode smartLabelMode;

  ///Data points or series can be selected while performing interaction on the chart.
  ///
  ///It can also be selected at the initial rendering using this property.
  ///
  ///Defaults to `[]`.
  ///
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfPyramidChart(
  ///           series: PyramidSeries<ChartData, String>(
  ///                  initialSelectedDataIndexes: <int>[1,0],
  ///                  selectionSettings: SelectionSettings(
  ///                    selectedColor: Colors.red,
  ///                    unselectedColor: Colors.grey
  ///                  ),
  ///                ),
  ///        ));
  ///}
  ///```

  ///Gesture for activating the selection.
  ///
  /// Selection can be activated in tap, double tap, and long press.
  ///
  ///Defaults to `ActivationMode.tap`.
  ///
  ///Also refer [ActivationMode]
  ///
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfPyramidChart(
  ///           selectionGesture: ActivationMode.singleTap,
  ///           series: PyramidSeries<ChartData, String>(
  ///                  selectionSettings: SelectionSettings(
  ///                    selectedColor: Colors.red,
  ///                    unselectedColor: Colors.grey
  ///                  ),
  ///                ),
  ///        ));
  ///}
  ///```
  final ActivationMode selectionGesture;

  ///Enables or disables the multiple data points selection.
  ///
  ///Defaults to `false`.
  ///
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfPyramidChart(
  ///           enableMultiSelection: true,
  ///           series: PyramidSeries<ChartData, String>(
  ///                  selectionSettings: SelectionSettings(
  ///                    selectedColor: Colors.red,
  ///                    unselectedColor: Colors.grey
  ///                  ),
  ///                ),
  ///        ));
  ///}
  ///```
  final bool enableMultiSelection;

  ///Background image for chart.
  ///
  ///Defaults to `null`.
  ///
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfPyramidChart(
  ///            backgroundImage: const AssetImage('image.png'),
  ///        ));
  ///}
  ///```
  final ImageProvider backgroundImage;

  /// Occurs while selection changes. Here, you can get the series, selected color,
  /// unselected color, selected border color, unselected border color, selected
  /// border width, unselected border width, series index, and point index.
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfPyramidChart(
  ///            onSelectionChanged: (SelectionArgs args) => select(args),
  ///        ));
  ///}
  ///dynamic select(SelectionArgs args) {
  ///   print(args.selectedBorderColor);
  ///}
  ///```
  final PyramidSelectionCallback onSelectionChanged;

  /// Occurs when tapping a series point. Here, you can get the series, series index
  /// and point index.
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfPyramidChart(
  ///            onPointTapped: (PointTapArgs args) => point(args),
  ///        ));
  ///}
  ///dynamic point(PointTapArgs args) {
  ///   print(args.pointIndex);
  ///}
  ///```
  final PyramidPointTapCallback onPointTapped;

  /// Occurs when tapped on the chart area.
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfPyramidChart(
  ///            onChartTouchInteractionUp: (ChartTouchInteractionArgs args){
  ///               print(args.position.dx.toString());
  ///               print(args.position.dy.toString());
  ///             }
  ///        ));
  ///}
  ///```
  final PyramidTouchInteractionCallback onChartTouchInteractionUp;

  /// Occurs when touched and moved on the chart area.
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfPyramidChart(
  ///            onChartTouchInteractionMove: (ChartTouchInteractionArgs args){
  ///               print(args.position.dx.toString());
  ///               print(args.position.dy.toString());
  ///             }
  ///        ));
  ///}
  ///```
  final PyramidTouchInteractionCallback onChartTouchInteractionMove;

  /// Occurs when touched on the chart area.
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfPyramidChart(
  ///            onChartTouchInteractionDown: (ChartTouchInteractionArgs args){
  ///               print(args.position.dx.toString());
  ///               print(args.position.dy.toString());
  ///             }
  ///        ));
  ///}
  ///```
  final PyramidTouchInteractionCallback onChartTouchInteractionDown;

  //Internal variables
  String _seriesType;
  List<PointInfo<dynamic>> _dataPoints;
  List<PointInfo<dynamic>> _renderPoints;
  _PyramidSeries _chartSeries;
  _SfPyramidChartState _chartState;
  _ChartLegend _chartLegend;
  //ignore: unused_field
  _PyramidPlotArea _chartPlotArea;
  @override
  State<StatefulWidget> createState() => _SfPyramidChartState();
}

class _SfPyramidChartState extends State<SfPyramidChart>
    with TickerProviderStateMixin {
  List<AnimationController> controllerList;
  AnimationController animationController; // Animation controller for series
  AnimationController
      annotationController; // Animation controller for Annotations
  ValueNotifier<int> seriesRepaintNotifier;
  List<_MeasureWidgetContext>
      legendWidgetContext; // To measure legend size and position
  List<_ChartTemplateInfo> templates; // Chart Template info
  List<Widget> _chartWidgets;
  PyramidSeriesRenderer seriesRenderer;

  /// Holds the information of chart theme arguments
  SfChartThemeData _chartTheme;
  Rect chartContainerRect;
  Rect chartAreaRect;
  _ChartTemplate _chartTemplate;
  _ChartInteraction currentActive;
  bool initialRender;
  List<_LegendRenderContext> legendToggleStates;
  List<_MeasureWidgetContext> legendToggleTemplateStates;
  bool _isLegendToggled;
  Offset _tapPosition;
  bool animateCompleted;
  Animation<double> chartElementAnimation;
  _PyramidDataLabelRenderer renderDataLabel;
  bool widgetNeedUpdate;
  List<int> explodedPoints;
  List<Rect> dataLabelTemplateRegions;
  List<int> selectionData;
  int _tooltipPointIndex;
  Orientation oldDeviceOrientation;
  Orientation deviceOrientation;
  Size _prevSize;
  bool _didSizeChange = false;

  @override
  void initState() {
    _initializeDefaultValues();
    //Update and maintain the series state, when we update the series in the series collection //
    createAndUpdateSeriesRenderer();
    super.initState();
  }

  void _initializeDefaultValues() {
    initialRender = true;
    controllerList = <AnimationController>[];
    annotationController = AnimationController(vsync: this);
    seriesRepaintNotifier = ValueNotifier<int>(0);
    legendToggleStates = <_LegendRenderContext>[];
    legendToggleTemplateStates = <_MeasureWidgetContext>[];
    explodedPoints = <int>[];
    animateCompleted = true;
    _isLegendToggled = false;
    widgetNeedUpdate = false;
    legendWidgetContext = <_MeasureWidgetContext>[];
    dataLabelTemplateRegions = <Rect>[];
    selectionData = <int>[];
    animationController = AnimationController(vsync: this)
      ..addListener(repaintChartElements);
  }

  @override
  void didChangeDependencies() {
    _chartTheme = SfChartTheme.of(context);
    super.didChangeDependencies();
  }

  @override
  void didUpdateWidget(SfPyramidChart oldWidget) {
    //Update and maintain the series state, when we update the series in the series collection //
    createAndUpdateSeriesRenderer(oldWidget);

    super.didUpdateWidget(oldWidget);
    _isLegendToggled = false;
    widgetNeedUpdate = true;
  }

  // In this method, create and update the series renderer for each series //
  void createAndUpdateSeriesRenderer([SfPyramidChart oldWidget]) {
    if (widget.series != null) {
      final PyramidSeriesRenderer oldSeriesRenderer = seriesRenderer;
      dynamic series;
      series = widget.series;

      // Create and update the series list here
      PyramidSeriesRenderer seriesRenderers;

      if (oldSeriesRenderer != null &&
          _isSameSeries(oldWidget.series, series)) {
        seriesRenderers = oldSeriesRenderer;
      } else {
        seriesRenderers = series.createRenderer(series);
        if (seriesRenderers._controller == null &&
            series.onRendererCreated != null) {
          seriesRenderers._controller =
              PyramidSeriesController(seriesRenderers);
          series.onRendererCreated(seriesRenderers._controller);
        }
      }

      seriesRenderers._series = series;
      seriesRenderers._pyramidChart = widget;
      widget._chartSeries.visibleSeriesRenderers
        ..clear()
        ..add(seriesRenderers);
    }
  }

  @override
  void dispose() {
    if (animationController != null) {
      animationController.removeListener(repaintChartElements);
      animationController.dispose();
      animationController = null;
    }
    super.dispose();
  }

  void repaintChartElements() {
    seriesRepaintNotifier.value++;
  }

  @override
  Widget build(BuildContext context) {
    _prevSize = _prevSize == null ? MediaQuery.of(context).size : _prevSize;
    _didSizeChange = _prevSize != MediaQuery.of(context).size;
    _prevSize = MediaQuery.of(context).size;
    oldDeviceOrientation = oldDeviceOrientation == null
        ? MediaQuery.of(context).orientation
        : deviceOrientation;
    deviceOrientation = MediaQuery.of(context).orientation;
    widget._chartState = this;
    return Container(
        child: GestureDetector(
            child: Container(
                decoration: BoxDecoration(
                    color: widget.backgroundColor,
                    image: widget.backgroundImage != null
                        ? DecorationImage(
                            image: widget.backgroundImage, fit: BoxFit.fill)
                        : null,
                    border: Border.all(
                        color: widget.borderColor, width: widget.borderWidth)),
                child: Column(
                  children: <Widget>[
                    _renderChartTitle(widget),
                    _renderChartElements()
                  ],
                ))));
  }

  Widget _renderChartElements() {
    return Expanded(child: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
      Widget element;
      if (widget.series?.dataSource != null) {
        _initialize(constraints);
        widget._chartSeries._findVisibleSeries();
        widget._chartSeries._processDataPoints();
        final List<Widget> legendTemplates = _bindLegendTemplateWidgets(widget);
        if (legendTemplates.isNotEmpty && legendWidgetContext.isEmpty) {
          element = Container(child: Stack(children: legendTemplates));
          SchedulerBinding.instance.addPostFrameCallback((_) => _refresh());
        } else {
          widget._chartLegend
              ._calculateLegendBounds(widget._chartLegend.chartSize);
          element = _getElements(
              widget, _PyramidPlotArea(chart: widget), constraints);
        }
      } else {
        element = Container();
      }
      return element;
    }));
  }

  void _refresh() {
    final List<_MeasureWidgetContext> legendWidgetContexts =
        widget._chartState.legendWidgetContext;
    if (legendWidgetContexts.isNotEmpty) {
      for (int i = 0; i < legendWidgetContexts.length; i++) {
        final _MeasureWidgetContext templateContext = legendWidgetContexts[i];
        final RenderBox renderBox = templateContext.context.findRenderObject();
        templateContext.size = renderBox.size;
      }
      setState(() {});
    }
  }

  // ignore:unused_element
  void _redraw() {
    widget._chartState.initialRender = false;
    setState(() {});
  }

  void _initialize(BoxConstraints constraints) {
    widget._chartLegend.chart = widget;
    widget._chartSeries.chart = widget;
    widget._chartState._chartWidgets = <Widget>[];
    final dynamic width = constraints.maxWidth;
    final dynamic height = constraints.maxHeight;
    final EdgeInsets margin = widget.margin;
    final Legend legend = widget.legend;
    if (legend.position == LegendPosition.auto) {
      legend.legendPosition =
          height > width ? LegendPosition.bottom : LegendPosition.right;
    } else {
      legend.legendPosition = legend.position;
    }
    widget._chartLegend.chartSize = Size(width - margin.left - margin.right,
        height - margin.top - margin.bottom);
  }
}

// ignore: must_be_immutable
class _PyramidPlotArea extends StatelessWidget {
  // ignore: prefer_const_constructors_in_immutables
  _PyramidPlotArea({this.chart});
  final SfPyramidChart chart;
  PyramidSeriesRenderer seriesRenderer;
  RenderBox renderBox;
  _Region pointRegion;
  TapDownDetails tapDownDetails;
  Offset doubleTapPosition;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
      return Container(
          child: MouseRegion(
              onHover: (PointerEvent event) => _onHover(event),
              onExit: (PointerEvent event) {
                chart.tooltipBehavior._isHovering = false;
              },
              child: Stack(children: <Widget>[
                _initializeChart(constraints, context),
                Listener(
                  onPointerUp: (PointerUpEvent event) => _onTapUp(event),
                  onPointerDown: (PointerDownEvent event) => _onTapDown(event),
                  onPointerMove: (PointerMoveEvent event) =>
                      _performPointerMove(event),
                  child: GestureDetector(
                      onLongPress: _onLongPress,
                      onDoubleTap: _onDoubleTap,
                      child: Container(
                        height: constraints.maxHeight,
                        width: constraints.maxWidth,
                        decoration:
                            const BoxDecoration(color: Colors.transparent),
                      )),
                ),
              ])));
      // Listener(
      //     onPointerUp: (PointerUpEvent event) =>
      //         _onTapUp(event),
      //     onPointerDown: (PointerDownEvent event) =>
      //         _onTapDown(event),
      //     child: GestureDetector(
      //         onLongPress: _onLongPress,
      //         onDoubleTap: _onDoubleTap,
      //         child: Container(
      //             decoration: const BoxDecoration(color: Colors.transparent),
      //             child: _initializeChart(constraints, context))));
    });
  }

  Widget _initializeChart(BoxConstraints constraints, BuildContext context) {
    _calculateSize(constraints);
    return GestureDetector(
        child: Container(
            decoration: const BoxDecoration(color: Colors.transparent),
            child: _renderWidgets(constraints, context)));
  }

  void _calculateSize(BoxConstraints constraints) {
    final dynamic width = constraints.maxWidth;
    final dynamic height = constraints.maxHeight;
    chart._chartState.chartContainerRect = Rect.fromLTWH(0, 0, width, height);
    final EdgeInsets margin = chart.margin;
    chart._chartState.chartAreaRect = Rect.fromLTWH(
        margin.left,
        margin.top,
        width - margin.right - margin.left,
        height - margin.top - margin.bottom);
  }

  Widget _renderWidgets(BoxConstraints constraints, BuildContext context) {
    _bindSeriesWidgets();
    _calculatePathRegion();
    _findTemplates(chart);
    _renderTemplates(chart);
    _bindTooltipWidgets(constraints);
    renderBox = context.findRenderObject();
    chart._chartPlotArea = this;
    return Container(child: Stack(children: chart._chartState._chartWidgets));
  }

  void _calculatePathRegion() {
    final List<PyramidSeriesRenderer> visibleSeriesRenderers =
        chart._chartSeries.visibleSeriesRenderers;
    if (visibleSeriesRenderers.isNotEmpty) {
      seriesRenderer = visibleSeriesRenderers[0];
      for (int i = 0; i < seriesRenderer._renderPoints.length; i++) {
        if (seriesRenderer._renderPoints[i].isVisible) {
          chart._chartSeries._calculatePathRegion(i, seriesRenderer);
        }
      }
    }
  }

  void _bindSeriesWidgets() {
    CustomPainter seriesPainter;
    Animation<double> seriesAnimation;
    PyramidSeries<dynamic, dynamic> series;
    final List<PyramidSeriesRenderer> visibleSeriesRenderers =
        chart._chartSeries.visibleSeriesRenderers;
    final _SfPyramidChartState chartState = chart._chartState;
    for (int i = 0; i < visibleSeriesRenderers.length; i++) {
      seriesRenderer = visibleSeriesRenderers[i];
      series = seriesRenderer._series;
      chart._chartSeries._initializeSeriesProperties(seriesRenderer);
      if (series.selectionSettings != null) {
        if (series.initialSelectedDataIndexes.isNotEmpty) {
          for (int index = 0;
              index < series.initialSelectedDataIndexes.length;
              index++) {
            chartState.selectionData
                .add(series.initialSelectedDataIndexes[index]);
          }
        }
      }
      if (series.animationDuration > 0 &&
          !chartState._didSizeChange &&
          (chartState.deviceOrientation == chartState.oldDeviceOrientation) &&
          (chartState.initialRender ||
              chartState.widgetNeedUpdate ||
              chartState._isLegendToggled)) {
        chartState.animationController.duration =
            Duration(milliseconds: series.animationDuration.toInt());
        seriesAnimation =
            Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
          parent: chartState.animationController,
          curve: const Interval(0.1, 0.8, curve: Curves.linear),
        )..addStatusListener((AnimationStatus status) {
                if (status == AnimationStatus.completed) {
                  chartState.animateCompleted = true;
                  if (chartState.renderDataLabel != null) {
                    chartState.renderDataLabel.state.render();
                  }
                  if (chartState._chartTemplate != null &&
                      chartState._chartTemplate.state != null) {
                    chartState._chartTemplate.state.templateRender();
                  }
                }
              }));
        chartState.chartElementAnimation =
            Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
          parent: chart._chartState.animationController,
          curve: const Interval(0.85, 1.0, curve: Curves.decelerate),
        ));
        chartState.animationController.forward(from: 0.0);
      } else {
        chart._chartState.animateCompleted = true;
        if (chartState.renderDataLabel != null) {
          chartState.renderDataLabel.state.render();
        }
      }
      seriesRenderer._repaintNotifier = chartState.seriesRepaintNotifier;
      if (seriesRenderer._seriesType == 'pyramid') {
        seriesPainter = _PyramidChartPainter(
            chart: chart,
            seriesIndex: i,
            isRepaint: seriesRenderer._needsRepaint,
            animationController: chartState.animationController,
            seriesAnimation: seriesAnimation,
            notifier: chartState.seriesRepaintNotifier);
      }
      chartState._chartWidgets
          .add(RepaintBoundary(child: CustomPaint(painter: seriesPainter)));
      chartState.renderDataLabel = _PyramidDataLabelRenderer(
          pyramidChart: chart,
          show: series.animationDuration > 0 &&
                  (chartState.deviceOrientation ==
                      chartState.oldDeviceOrientation) &&
                  !chartState._didSizeChange
              ? false
              : chart._chartState.animateCompleted);
      chartState._chartWidgets.add(chartState.renderDataLabel);
      chart._chartState = chartState;
    }
  }

  void _bindTooltipWidgets(BoxConstraints constraints) {
    final TooltipBehavior tooltip = chart.tooltipBehavior;
    if (tooltip.enable) {
      tooltip._chart = chart;
      if (tooltip.builder != null) {
        tooltip._tooltipTemplate = _TooltipTemplate(
            show: false,
            clipRect: chart._chartState.chartContainerRect,
            duration: tooltip.duration);
        chart._chartState._chartWidgets.add(tooltip._tooltipTemplate);
      } else {
        tooltip._chartTooltip = _ChartTooltipRenderer(chartWidget: chart);
        chart._chartState._chartWidgets.add(tooltip._chartTooltip);
      }
    }
  }

  void _calculatePointSeriesIndex(SfPyramidChart chart,
      PyramidSeriesRenderer seriesRenderer, Offset touchPosition) {
    PointTapArgs pointTapArgs;
    pointTapArgs = PointTapArgs();
    num index;
    for (int i = 0; i < seriesRenderer._renderPoints.length; i++) {
      if (seriesRenderer._renderPoints[i].region.contains(touchPosition)) {
        index = i;
        break;
      }
    }
    if (index != null) {
      pointTapArgs.pointIndex = index;
      pointTapArgs.seriesIndex = 0;
      pointTapArgs.dataPoints = seriesRenderer._dataPoints;
      chart.onPointTapped(pointTapArgs);
    }
  }

  void _onTapDown(PointerDownEvent event) {
    chart.tooltipBehavior._isHovering = false;
    //renderBox = context.findRenderObject();
    chart._chartState.currentActive = null;
    chart._chartState._tapPosition = renderBox.globalToLocal(event.position);
    bool isPoint;
    const num seriesIndex = 0;
    num pointIndex;
    final List<PyramidSeriesRenderer> visibleSeriesRenderers =
        chart._chartSeries.visibleSeriesRenderers;
    final PyramidSeriesRenderer seriesRenderer =
        visibleSeriesRenderers[seriesIndex];
    if (chart.onPointTapped != null && seriesRenderer != null) {
      _calculatePointSeriesIndex(
          chart, seriesRenderer, chart._chartState._tapPosition);
    }
    ChartTouchInteractionArgs touchArgs;
    for (int j = 0; j < seriesRenderer._renderPoints.length; j++) {
      if (seriesRenderer._renderPoints[j].isVisible) {
        isPoint = _isPointInPolygon(seriesRenderer._renderPoints[j].pathRegion,
            chart._chartState._tapPosition);
        if (isPoint) {
          pointIndex = j;
          break;
        }
      }
    }
    doubleTapPosition = chart._chartState._tapPosition;
    if (chart._chartState._tapPosition != null && isPoint) {
      chart._chartState.currentActive = _ChartInteraction(
        seriesIndex,
        pointIndex,
        visibleSeriesRenderers[seriesIndex]._series,
        visibleSeriesRenderers[seriesIndex]._renderPoints[pointIndex],
      );
    } else {
      //hides the tooltip if the point of interaction is outside pyramid region of the chart
      chart.tooltipBehavior?._tooltipTemplate?.show = false;
      chart.tooltipBehavior?._tooltipTemplate?.state?.hideOnTimer();
    }
    if (chart.onChartTouchInteractionDown != null) {
      touchArgs = ChartTouchInteractionArgs();
      touchArgs.position = renderBox.globalToLocal(event.position);
      chart.onChartTouchInteractionDown(touchArgs);
    }
  }

  void _performPointerMove(PointerMoveEvent event) {
    ChartTouchInteractionArgs touchArgs;
    final Offset position = renderBox.globalToLocal(event.position);
    if (chart.onChartTouchInteractionMove != null) {
      touchArgs = ChartTouchInteractionArgs();
      touchArgs.position = position;
      chart.onChartTouchInteractionMove(touchArgs);
    }
  }

  void _onDoubleTap() {
    const num seriesIndex = 0;
    if (doubleTapPosition != null && chart._chartState.currentActive != null) {
      final num pointIndex = chart._chartState.currentActive.pointIndex;
      final List<PyramidSeriesRenderer> visibleSeriesRenderers =
          chart._chartSeries.visibleSeriesRenderers;
      chart._chartState.currentActive = _ChartInteraction(
          seriesIndex,
          pointIndex,
          visibleSeriesRenderers[seriesIndex]._series,
          visibleSeriesRenderers[seriesIndex]._renderPoints[pointIndex]);
      if (chart._chartState.currentActive != null) {
        if (chart._chartState.currentActive.series.explodeGesture ==
            ActivationMode.doubleTap) {
          chart._chartSeries._pointExplode(pointIndex);
        }
      }
      chart._chartSeries
          ._seriesPointSelection(pointIndex, ActivationMode.doubleTap);
      if (chart.tooltipBehavior.enable &&
          chart.tooltipBehavior.activationMode == ActivationMode.doubleTap) {
        if (chart.tooltipBehavior.builder != null) {
          _showPyramidTooltipTemplate();
        } else {
          chart.tooltipBehavior.onDoubleTap(
              doubleTapPosition.dx.toDouble(), doubleTapPosition.dy.toDouble());
        }
      }
    }
  }

  void _onLongPress() {
    const num seriesIndex = 0;
    if (chart._chartState._tapPosition != null &&
        chart._chartState.currentActive != null) {
      final List<PyramidSeriesRenderer> visibleSeriesRenderers =
          chart._chartSeries.visibleSeriesRenderers;
      final num pointIndex = chart._chartState.currentActive.pointIndex;
      chart._chartState.currentActive = _ChartInteraction(
          seriesIndex,
          pointIndex,
          visibleSeriesRenderers[seriesIndex]._series,
          visibleSeriesRenderers[seriesIndex]._renderPoints[pointIndex],
          pointRegion);
      chart._chartSeries
          ._seriesPointSelection(pointIndex, ActivationMode.longPress);
      if (chart._chartState.currentActive != null) {
        if (chart._chartState.currentActive.series.explodeGesture ==
            ActivationMode.longPress) {
          chart._chartSeries._pointExplode(pointIndex);
        }
      }
      if (chart.tooltipBehavior.enable &&
          chart.tooltipBehavior.activationMode == ActivationMode.longPress) {
        if (chart.tooltipBehavior.builder != null) {
          _showPyramidTooltipTemplate();
        } else {
          chart.tooltipBehavior.onLongPress(
              chart._chartState._tapPosition.dx.toDouble(),
              chart._chartState._tapPosition.dy.toDouble());
        }
      }
    }
  }

  void _onTapUp(PointerUpEvent event) {
    chart.tooltipBehavior._isHovering = false;
    final _ChartInteraction currentActive = chart._chartState.currentActive;
    chart._chartState._tapPosition = renderBox.globalToLocal(event.position);
    ChartTouchInteractionArgs touchArgs;
    if (chart._chartState._tapPosition != null &&
        chart._chartState.currentActive != null) {
      if (currentActive.series != null &&
          currentActive.series.explodeGesture == ActivationMode.singleTap) {
        chart._chartSeries._pointExplode(currentActive.pointIndex);
      }

      if (currentActive.series.selectionSettings.enable) {
        chart._chartSeries._seriesPointSelection(
            currentActive.pointIndex, ActivationMode.singleTap);
      }

      if (chart.tooltipBehavior.enable &&
          chart.tooltipBehavior.activationMode == ActivationMode.singleTap &&
          currentActive.series != null) {
        if (chart.tooltipBehavior.builder != null) {
          _showPyramidTooltipTemplate();
        } else {
          // final RenderBox renderBox = context.findRenderObject();
          final Offset position = renderBox.globalToLocal(event.position);
          chart.tooltipBehavior
              .onTouchUp(position.dx.toDouble(), position.dy.toDouble());
        }
      }
    }
    if (chart.onChartTouchInteractionUp != null) {
      touchArgs = ChartTouchInteractionArgs();
      touchArgs.position = renderBox.globalToLocal(event.position);
      chart.onChartTouchInteractionUp(touchArgs);
    }
    chart._chartState._tapPosition = null;
  }

  void _onHover(PointerEvent event) {
    chart._chartState.currentActive = null;
    chart._chartState._tapPosition = renderBox.globalToLocal(event.position);
    bool isPoint;
    const num seriesIndex = 0;
    num pointIndex;
    final PyramidSeriesRenderer seriesRenderer =
        chart._chartSeries.visibleSeriesRenderers[seriesIndex];
    final TooltipBehavior tooltip = chart.tooltipBehavior;
    for (int j = 0; j < seriesRenderer._renderPoints.length; j++) {
      if (seriesRenderer._renderPoints[j].isVisible) {
        isPoint = _isPointInPolygon(seriesRenderer._renderPoints[j].pathRegion,
            chart._chartState._tapPosition);
        if (isPoint) {
          pointIndex = j;
          break;
        }
      }
    }
    if (chart._chartState._tapPosition != null && isPoint) {
      chart._chartState.currentActive = _ChartInteraction(
        seriesIndex,
        pointIndex,
        chart._chartSeries.visibleSeriesRenderers[seriesIndex]._series,
        chart._chartSeries.visibleSeriesRenderers[seriesIndex]
            ._renderPoints[pointIndex],
      );
    } else if (tooltip?.builder != null) {
      tooltip?._tooltipTemplate?.show = false;
      tooltip?._tooltipTemplate?.state?.hideOnTimer();
    }
    if (chart._chartState._tapPosition != null) {
      if (tooltip.enable &&
          chart._chartState.currentActive != null &&
          chart._chartState.currentActive.series != null) {
        tooltip._isHovering = true;
        if (tooltip.builder != null) {
          _showPyramidTooltipTemplate();
        } else {
          final Offset position = renderBox.globalToLocal(event.position);
          tooltip.onEnter(position.dx.toDouble(), position.dy.toDouble());
        }
      } else {
        tooltip?._painter?.prevTooltipValue = null;
        tooltip?._painter?.currentTooltipValue = null;
        tooltip?._painter?.hide();
      }
    }
    chart._chartState._tapPosition = null;
  }

  // this method gets executed for showing tooltip when builder is provided in behavior
  void _showPyramidTooltipTemplate([int pointIndex]) {
    final TooltipBehavior tooltip = chart.tooltipBehavior;
    tooltip._tooltipTemplate?._alwaysShow = tooltip.shouldAlwaysShow;
    if (!tooltip._isHovering) {
      //assingning null for the previous and current tooltip values in case of touch interaction
      tooltip._tooltipTemplate?.state?.prevTooltipValue = null;
      tooltip._tooltipTemplate?.state?.currentTooltipValue = null;
    }
    final PyramidSeries<dynamic, dynamic> chartSeries =
        chart._chartState.currentActive?.series ?? chart.series;
    final PointInfo<dynamic> point = pointIndex == null
        ? chart._chartState.currentActive?.point
        : chart._chartSeries.visibleSeriesRenderers[0]._dataPoints[pointIndex];
    final Offset location = point.symbolLocation;
    if (location != null && (chartSeries.enableTooltip ?? true)) {
      tooltip._tooltipTemplate.rect =
          Rect.fromLTWH(location.dx, location.dy, 0, 0);
      tooltip._tooltipTemplate.template = tooltip.builder(
          chartSeries.dataSource[
              pointIndex ?? chart._chartState.currentActive.pointIndex],
          point,
          chartSeries,
          chart._chartState.currentActive?.seriesIndex ?? 0,
          pointIndex ?? chart._chartState.currentActive?.pointIndex);
      if (tooltip._isHovering) {
        //assingning values for the previous and current tooltip values on mouse hover
        tooltip._tooltipTemplate.state.prevTooltipValue =
            tooltip._tooltipTemplate.state.currentTooltipValue;
        tooltip._tooltipTemplate.state.currentTooltipValue = TooltipValue(
            0, pointIndex ?? chart._chartState.currentActive?.pointIndex);
      }
      tooltip._tooltipTemplate.show = true;
      tooltip._tooltipTemplate?.state?._performTooltip();
    }
  }
}
