part of charts;

/// Returns the  TooltipArgs.
typedef ChartTooltipCallback = void Function(TooltipArgs tooltipArgs);

/// Returns the ActualRangeChangedArgs.
typedef ChartActualRangeChangedCallback = void Function(ActualRangeChangedArgs rangeChangedArgs);

/// Returns the AxisLabelRenderArgs.
typedef ChartAxisLabelRenderCallback = void Function(AxisLabelRenderArgs axisLabelRenderArgs);

/// Returns the DataLabelRenderArgs.
typedef ChartDataLabelRenderCallback = void Function(DataLabelRenderArgs dataLabelArgs);

/// Returns the LegendRenderArgs.
typedef ChartLegendRenderCallback = void Function(LegendRenderArgs legendRenderArgs);

/// Returns the Trendline args
typedef ChartTrendlineRenderCallback = void Function(TrendlineRenderArgs trendlineRenderArgs);

///Returns the TrackballArgs.
typedef ChartTrackballCallback = void Function(TrackballArgs trackballArgs);

/// Returns the CrosshairRenderArgs
typedef ChartCrosshairCallback = void Function(CrosshairRenderArgs crosshairArgs);

/// Returns the ZoomPanArgs.
typedef ChartZoomingCallback = void Function(ZoomPanArgs zoomingArgs);

/// Returns the  PointTapArgs.
typedef ChartPointTapCallback = void Function(PointTapArgs pointTapArgs);

/// Returns the  AxisLabelTapArgs.
typedef ChartAxisLabelTapCallback = void Function(AxisLabelTapArgs axisLabelTapArgs);

/// Returns the  LegendTapArgs.
typedef ChartLegendTapCallback = void Function(LegendTapArgs legendTapArgs);

/// Returns the SelectionArgs.
typedef ChartSelectionCallback = void Function(SelectionArgs selectionArgs);

/// Returns the offset.
typedef ChartTouchInteractionCallback = void Function(ChartTouchInteractionArgs tapArgs);

/// Returns the IndicatorRenderArgs.
typedef ChartIndicatorRenderCallback = void Function(IndicatorRenderArgs indicatorRenderArgs);

///Returns the MarkerRenderArgs.
typedef ChartMarkerRenderCallback = void Function(MarkerRenderArgs markerArgs);

///Renders the cartesian type charts.
///
///Cartesian charts are generally charts with horizontal and vertical axes.[SfCartesianChart] provides options to cusomize
/// chart types using the [series] property.
///
///```dart
///Widget build(BuildContext context) {
///  return Center(
///    child:SfCartesianChart(
///      title: ChartTitle(text: 'Flutter Chart'),
///     legend: Legend(isVisible: true),
///     series: getDefaultData(),
///     tooltipBehavior: TooltipBehavior(enable: true),
///    )
/// );
///}
///static List<LineSeries<SalesData, num>> getDefaultData() {
///    final dynamic chartData = <SalesData>[
///      SalesData(DateTime(2005, 0, 1), 'India', 1.5, 21, 28, 680, 760),
///      SalesData(DateTime(2006, 0, 1), 'China', 2.2, 24, 44, 550, 880),
///      SalesData(DateTime(2007, 0, 1), 'USA', 3.32, 36, 48, 440, 788),
///      SalesData(DateTime(2008, 0, 1), 'Japan', 4.56, 38, 50, 350, 560),
///      SalesData(DateTime(2009, 0, 1), 'Russia', 5.87, 54, 66, 444, 566),
///      SalesData(DateTime(2010, 0, 1), 'France', 6.8, 57, 78, 780, 650),
///     SalesData(DateTime(2011, 0, 1), 'Germany', 8.5, 70, 84, 450, 800)
///    ];
///   return <LineSeries<SalesData, num>>[
///      LineSeries<SalesData, num>(
///          enableToolTip: isTooltipVisible,
///          dataSource: chartData,
///          xValueMapper: (SalesData sales, _) => sales.numeric,
///          yValueMapper: (SalesData sales, _) => sales.sales1,
///          width: lineWidth ?? 2,
///          enableAnimation: false,
///         markerSettings: MarkerSettings(
///              isVisible: isMarkerVisible,
///              height: markerWidth ?? 4,
///              width: markerHeight ?? 4,
///              shape: DataMarkerType.Circle,
///              borderWidth: 3,
///              borderColor: Colors.red),
///          dataLabelSettings: DataLabelSettings(
///              visible: isDataLabelVisible, position: ChartDataLabelAlignment.Auto)),
///      LineSeries<SalesData, num>(
///          enableToolTip: isTooltipVisible,
///          dataSource: chartData,
///          enableAnimation: false,
///          width: lineWidth ?? 2,
///          xValueMapper: (SalesData sales, _) => sales.numeric,
///          yValueMapper: (SalesData sales, _) => sales.sales2,
///          markerSettings: MarkerSettings(
///              isVisible: isMarkerVisible,
///              height: markerWidth ?? 4,
///              width: markerHeight ?? 4,
///              shape: DataMarkerType.Circle,
///              borderWidth: 3,
///              borderColor: Colors.black),
///          dataLabelSettings: DataLabelSettings(
///              isVisible: isDataLabelVisible, position: ChartDataLabelAlignment.Auto))
///    ];
///  }
///  ```
///
// ignore: must_be_immutable
class SfCartesianChart extends StatefulWidget {
  SfCartesianChart(
      {Key key,
      this.backgroundColor,
      this.enableSideBySideSeriesPlacement = true,
      this.borderColor = Colors.transparent,
      this.borderWidth = 0,
      this.plotAreaBackgroundColor,
      this.plotAreaBorderColor,
      this.plotAreaBorderWidth = 0.7,
      this.plotAreaBackgroundImage,
      this.onTooltipRender,
      this.onActualRangeChanged,
      this.onAxisLabelRender,
      this.onDataLabelRender,
      this.onLegendItemRender,
      this.onTrackballPositionChanging,
      this.onCrosshairPositionChanging,
      this.onZooming,
      this.onZoomStart,
      this.onZoomEnd,
      this.onZoomReset,
      this.onPointTapped,
      this.onAxisLabelTapped,
      this.onTrendlineRender,
      this.onLegendTapped,
      this.onSelectionChanged,
      this.onChartTouchInteractionUp,
      this.onChartTouchInteractionDown,
      this.onChartTouchInteractionMove,
      this.onIndicatorRender,
      this.onMarkerRender,
      this.isTransposed = false,
      this.enableAxisAnimation = false,
      this.annotations,
      this.palette = const <Color>[
        Color.fromRGBO(75, 135, 185, 1),
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
      ChartAxis primaryXAxis,
      ChartAxis primaryYAxis,
      EdgeInsets margin,
      TooltipBehavior tooltipBehavior,
      ZoomPanBehavior zoomPanBehavior,
      Legend legend,
      SelectionType selectionType,
      ActivationMode selectionGesture,
      bool enableMultiSelection,
      CrosshairBehavior crosshairBehavior,
      TrackballBehavior trackballBehavior,
      dynamic series,
      ChartTitle title,
      List<ChartAxis> axes,
      List<TechnicalIndicators<dynamic, dynamic>> indicators})
      : primaryXAxis = primaryXAxis ?? NumericAxis(),
        primaryYAxis = primaryYAxis ?? NumericAxis(),
        title = title ?? ChartTitle(),
        axes = axes ?? <ChartAxis>[],
        series = series ?? <ChartSeries<dynamic, dynamic>>[],
        margin = margin ?? const EdgeInsets.all(10),
        zoomPanBehavior = zoomPanBehavior ?? ZoomPanBehavior(),
        tooltipBehavior = tooltipBehavior ?? TooltipBehavior(),
        crosshairBehavior = crosshairBehavior ?? CrosshairBehavior(),
        trackballBehavior = trackballBehavior ?? TrackballBehavior(),
        legend = legend ?? Legend(),
        selectionType = selectionType ?? SelectionType.point,
        selectionGesture = selectionGesture ?? ActivationMode.singleTap,
        enableMultiSelection = enableMultiSelection ?? false,
        indicators = indicators ?? <TechnicalIndicators<dynamic, dynamic>>[],
        super(key: key) {
    _chartAxis = _ChartAxis();
    _chartSeries = _ChartSeries();
    _chartLegend = _ChartLegend();
    _containerArea = _ContainerArea();
  }

  ///Customizes the chart title
  ///
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///            title: ChartTitle(
  ///                    text: 'Area with animation',
  ///                    alignment: ChartAlignment.center,
  ///                    backgroundColor: Colors.white,
  ///                    borderColor: Colors.transparent,
  ///                    borderWidth: 0)
  ///        ));
  ///}
  ///```
  final ChartTitle title;

  ///Customizes the legend in the chart.
  ///
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///            legend: Legend(isVisible: true),
  ///        ));
  ///}
  ///```
  final Legend legend;

  ///Background color of the chart.
  ///
  ///Defaults to `Colors.transparent`.
  ///
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///            backgroundColor: Colors.blue
  ///        ));
  ///}
  ///```
  final Color backgroundColor;

  ///Color of the chart border.
  ///
  ///Defaults to `Colors.transparent`.
  ///
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///            borderColor: Colors.red
  ///        ));
  ///}
  ///```
  final Color borderColor;

  ///Width of the chart border.
  ///
  ///Defaults to `0`.
  ///
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///            borderColor: Colors.red,
  ///            borderWidth: 2
  ///        ));
  ///}
  ///```
  final double borderWidth;

  ///Background color of the plot area.
  ///
  ///Defaults to `Colors.transparent`.
  ///
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///            plotAreaBackgroundColor: Colors.red,
  ///        ));
  ///}
  ///```
  final Color plotAreaBackgroundColor;

  ///Border color of the plot area.
  ///
  ///Defaults to `Colors.grey`.
  ///
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///            plotAreaBorderColor: Colors.red,
  ///        ));
  ///}
  ///```
  final Color plotAreaBorderColor;

  ///Border width of the plot area.
  ///
  ///Defaults to `0`.
  ///
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///            plotAreaBorderColor: Colors.red,
  ///            plotAreaBorderWidth: 2
  ///        ));
  ///}
  ///```
  final double plotAreaBorderWidth;

  ///Customizes the primary x-axis in chart.
  ///
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///            primaryXAxis: DateTimeAxis(interval: 1)
  ///        ));
  ///}
  ///```
  final ChartAxis primaryXAxis;

  ///Customizes the primary y-axis in chart.
  ///
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///            primaryYAxis: NumericAxis(isinversed: false)
  ///        ));
  ///}
  ///```
  final ChartAxis primaryYAxis;

  ///Margin for chart.
  ///
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///            margin: const EdgeInsets.all(2),
  ///            borderColor: Colors.blue
  ///        ));
  ///}
  ///```
  final EdgeInsets margin;

  ///Customizes the additional axes in the chart.
  ///
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///             axes: <ChartAxis>[
  ///                NumericAxis(
  ///                             majorGridLines: MajorGridLines(
  ///                                     color: Colors.transparent)
  ///                             )]
  ///        ));
  ///}
  ///```
  final List<ChartAxis> axes;

  ///Enables or disables the placing of series side by side.
  ///
  ///Defaults to `true`.
  ///
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///           enableSideBySideSeriesPlacement: false
  ///        ));
  ///}
  ///```
  final bool enableSideBySideSeriesPlacement;

  /// Occurs while tooltip is rendered. You can customize the position and header.
  /// Here, you can get the text, header, point index, series, x and y-positions.
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///            tooltipBehavior: TooltipBehavior(enable: true)
  ///            onTooltipRender: (TooltipArgs args) => tool(args)
  ///        ));
  ///}
  ///dynamic tool(TooltipArgs args) {
  ///   args.locationX = 30;
  ///}
  ///```
  final ChartTooltipCallback onTooltipRender;

  /// Occurs when the visible range of an axis is changed, i.e. value changes for minimum,
  ///  maximum, and interval. Here, you can get the actual and visible range of an axis.
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///            onActualRangeChanged: (ActualRangeChangedArgs args) => range(args)
  ///        ));
  ///}
  ///dynamic range(ActualRangeChangedArgs args) {
  ///   print(args.visibleMin);
  ///}
  ///```
  final ChartActualRangeChangedCallback onActualRangeChanged;

  /// Occurs while rendering the axis labels. Text and text styles such as color, font size,
  /// and font weight can be customized.
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///            onAxisLabelRender: (AxisLabelRenderArgs args) => axis(args),
  ///        ));
  ///}
  ///dynamic axis(AxisLabelRenderArgs args) {
  ///   args.text = 'axis Label';
  ///}
  ///```
  final ChartAxisLabelRenderCallback onAxisLabelRender;

  /// Occurs when tapping the axis label. Here, you can get the appropriate axis that is
  /// tapped and the axis label text.
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///            onDataLabelRender: (DataLabelRenderArgs args) => dataLabel(args),
  ///        ));
  ///}
  ///dynamic dataLabel(DataLabelRenderArgs args) {
  ///   args.text = 'data Label';
  ///}
  ///```
  final ChartDataLabelRenderCallback onDataLabelRender;

  /// Occurs when the legend item is rendered. Here, you can get the legend’s text,
  /// shape, series index, and point index of circular series.
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///            legend: Legend(isVisible: true),
  ///            onLegendItemRender: (LegendRenderArgs args) => legend(args)
  ///        ));
  ///}
  ///dynamic legend(LegendRenderArgs args) {
  ///   args.seriesIndex = 2;
  ///}
  ///```
  final ChartLegendRenderCallback onLegendItemRender;

  /// Occurs when the trendline is rendered. Here, you can get the legend’s text,
  /// shape, series index, and point index of circular series.
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///            onTrendlineRender: (TrendlineRenderArgs args) => trendline(args)
  ///        ));
  ///}
  ///dynamic trendline(TrendlineRenderArgs args) {
  ///   args.seriesIndex = 2;
  ///}
  ///```
  final ChartTrendlineRenderCallback onTrendlineRender;

  /// Occurs while the trackball position is changed. Here, you can customize the text of
  /// the trackball.
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///            trackballBehavior: TrackballBehavior(enable: true),
  ///            onTrackballPositionChanging: (TrackballArgs args) => trackball(args)
  ///        ));
  ///}
  ///dynamic trackball(TrackballArgs args) {
  ///    args.chartPointInfo = ChartPointInfo();
  ///}
  ///```
  final ChartTrackballCallback onTrackballPositionChanging;

  /// Occurs when tapping the axis label. Here, you can get the appropriate axis that is
  /// tapped and the axis label text.
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///            crosshairBehavior: CrosshairBehavior(enable: true),
  ///            onCrosshairPositionChanging: (CrosshairRenderArgs args) => crosshair(args)
  ///        ));
  ///}
  ///dynamic crosshair(CrosshairRenderArgs args) {
  ///    args.text = 'crosshair';
  ///}
  ///```
  final ChartCrosshairCallback onCrosshairPositionChanging;

  /// Occurs when zooming action begins. You can customize the zoom factor and zoom
  /// position of an axis. Here, you can get the axis, current zoom factor, current
  /// zoom position, previous zoom factor, and previous zoom position.
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///            zoomPanBehavior: ZoomPanBehavior(enableSelectionZooming: true),
  ///            onZoomStart: (ZoomPanArgs args) => zoom(args),
  ///        ));
  ///}
  ///dynamic zoom(ZoomPanArgs args) {
  ///    args.currentZoomFactor = 0.2;
  ///}
  ///```
  final ChartZoomingCallback onZoomStart;

  /// Occurs when the zooming action is completed. Here, you can get the axis, current
  /// zoom factor, current zoom position, previous zoom factor, and previous zoom position.
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///            zoomPanBehavior: ZoomPanBehavior(enableSelectionZooming: true),
  ///            onZoomEnd: (ZoomPanArgs args) => zoom(args),
  ///        ));
  ///}
  ///dynamic zoom(ZoomPanArgs args) {
  ///    print(args.currentZoomPosition);
  ///}
  ///```
  final ChartZoomingCallback onZoomEnd;

  /// Occurs when zoomed state is reset. Here, you can get the axis, current zoom factor,
  /// current zoom position, previous zoom factor, and previous zoom position.
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///            zoomPanBehavior: ZoomPanBehavior(enableSelectionZooming: true),
  ///            onZoomReset: (ZoomPanArgs args) => zoom(args),
  ///        ));
  ///}
  ///dynamic zoom(ZoomPanArgs args) {
  ///    print(args.currentZoomPosition);
  ///}
  ///```
  final ChartZoomingCallback onZoomReset;

  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///            zoomPanBehavior: ZoomPanBehavior(enableSelectionZooming: true),
  ///            onZooming: (ZoomPanArgs args) => zoom(args),
  ///        ));
  ///}
  ///dynamic zoom(ZoomPanArgs args) {
  ///    print(args.currentZoomPosition);
  ///}
  ///```
  final ChartZoomingCallback onZooming;

  /// Occurs when tapping the series point. Here, you can get the series, series index
  /// and point index.
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///            onPointTapped: (PointTapArgs args) => point(args),
  ///        ));
  ///}
  ///dynamic point(PointTapArgs args) {
  ///   print(args.seriesIndex);
  ///}
  ///```

  final ChartPointTapCallback onPointTapped;

  /// Occurs when tapping the axis label. Here, you can get the appropriate axis that is
  /// tapped and the axis label text.
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///            onAxisLabelTapped: (AxisLabelTapArgs args) => axis(args),
  ///        ));
  ///}
  ///dynamic axis(AxisLabelTapArgs args) {
  ///   print(args.text);
  ///}
  ///```
  final ChartAxisLabelTapCallback onAxisLabelTapped;

  /// Occurs when the legend item is rendered. Here, you can get the legend’s text,
  /// shape, series index, and point index of circular series.
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///            onLegendTapped: (LegendTapArgs args) => legend(args),
  ///        ));
  ///}
  ///dynamic legend(LegendTapArgs args) {
  ///   print(args.pointIndex);
  ///}
  ///```
  final ChartLegendTapCallback onLegendTapped;

  /// Occurs while selection changes. Here, you can get the series, selected color,
  /// unselected color, selected border color, unselected border color, selected border
  ///  width, unselected border width, series index, and point index.
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///            onSelectionChanged: (SelectionArgs args) => print(args.selectedColor),
  ///        ));
  ///}
  final ChartSelectionCallback onSelectionChanged;

  /// Occurs when tapped on the chart area.
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///            onChartTouchInteractionUp: (ChartTouchInteractionArgs args){
  ///               print(args.position.dx.toString());
  ///               print(args.position.dy.toString());
  ///             }
  ///        ));
  ///}
  ///```
  final ChartTouchInteractionCallback onChartTouchInteractionUp;

  /// Occurs when touched on the chart area.
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///            onChartTouchInteractionDown: (ChartTouchInteractionArgs args){
  ///               print(args.position.dx.toString());
  ///               print(args.position.dy.toString());
  ///             }
  ///        ));
  ///}
  ///```
  final ChartTouchInteractionCallback onChartTouchInteractionDown;

  /// Occurs when touched and moved on the chart area.
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///            onChartTouchInteractionMove: (ChartTouchInteractionArgs args){
  ///               print(args.position.dx.toString());
  ///               print(args.position.dy.toString());
  ///             }
  ///        ));
  ///}
  ///```
  final ChartTouchInteractionCallback onChartTouchInteractionMove;

  /// Occurs when the indicator is rendered. Here, you can get the indicatorname,,
  /// seriesname, indicator index, and width of indicators.
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///             onIndicatorRender: (IndicatorRenderArgs args)
  ///           {
  ///            if(args.index==1)
  ///            {
  ///           args.indicatorname="changed1";
  ///           args.signalLineColor=Colors.green;
  ///           args.signalLineWidth=10.0;
  ///           }
  ///          },
  ///        ));
  ///}
  ///```
  final ChartIndicatorRenderCallback onIndicatorRender;

  /// Occurs when the marker is rendered. Here, you can get the marker pointIndex
  /// shape, height and width of data markers.
  ///```dart
  /// Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///               onMarkerRender: (MarkerRenderArgs markerargs)
  ///            {
  ///              if(markerargs.pointIndex==2)
  ///              {
  ///              markerargs.markerHeight=20.0;
  ///              markerargs.markerWidth=20.0;
  ///              markerargs.shape=DataMarkerType.triangle;
  ///              }
  ///            },
  ///        ));
  ///}
  ///```
  ///
  final ChartMarkerRenderCallback onMarkerRender;

  ///Customizes the tooltip in chart.
  ///
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///            tooltipBehavior: TooltipBehavior(enable: true)
  ///        ));
  ///}
  ///```
  final TooltipBehavior tooltipBehavior;

  ///Customizes the crosshair in chart.
  ///
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///            crosshairBehavior: CrosshairBehavior(enable: true),
  ///        ));
  ///}
  ///```
  final CrosshairBehavior crosshairBehavior;

  ///Customizes the trackball in chart.
  ///
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///            trackballBehavior: TrackballBehavior(enable: true),
  ///        ));
  ///}
  ///```
  final TrackballBehavior trackballBehavior;

  ///Customizes the zooming and panning settings.
  ///
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///            zoomPanBehavior: ZoomPanBehavior( enablePanning: true),
  ///        ));
  ///}
  ///```
  final ZoomPanBehavior zoomPanBehavior;

  ///Mode of selecting the data points or series.
  ///
  ///Defaults to `SelectionType.point`.
  ///
  ///Also refer [SelectionType]
  ///
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///            selectionType: SelectionType.series,
  ///        ));
  ///}
  ///```
  final SelectionType selectionType;

  ///Customizes the annotations. Annotations are used to mark the specific area of interest
  /// in the plot area with texts, shapes, or images.
  ///
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///            annotations: <CartesianChartAnnotation>[
  ///                CartesianChartAnnotation(
  ///                    child: Container(
  ///                    child: const Text('Empty data')),
  ///                    coordinateUnit: CoordinateUnit.point,
  ///                    region: AnnotationRegion.chartArea,
  ///                    x: 3.5,
  ///                    y: 60
  ///                 ),
  ///             ],
  ///        ));
  ///}
  ///```
  final List<CartesianChartAnnotation> annotations;

  ///Enables or disables the multiple data points or series selection.
  ///
  ///Defaults to `false`.
  ///
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///            enableMultiSelection: true,
  ///            series: <BarSeries<SalesData, num>>[
  ///                BarSeries<SalesData, num>(
  ///                  selectionSettings: SelectionSettings(
  ///                    selectedColor: Colors.red,
  ///                    unselectedColor: Colors.grey
  ///                  ),
  ///                ),
  ///              ],
  ///        ));
  ///}
  ///```
  final bool enableMultiSelection;

  ///Gesture for activating the selection. Selection can be activated in tap,
  ///double tap, and long press.
  ///
  ///Defaults to `ActivationMode.tap`.
  ///
  ///Also refer [ActivationMode]
  ///
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///            selectionGesture: ActivationMode.doubleTap,
  ///            series: <BarSeries<SalesData, num>>[
  ///                BarSeries<SalesData, num>(
  ///                  selectionSettings: SelectionSettings(
  ///                    selectedColor: Colors.red,
  ///                    unselectedColor: Colors.grey
  ///                  ),
  ///                ),
  ///              ],
  ///        ));
  ///}
  ///```
  final ActivationMode selectionGesture;

  ///Background image for chart.
  ///
  ///Defaults to `null`.
  ///
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///            plotAreaBackgroundImage: const AssetImage('images/bike.png'),
  ///        ));
  ///}
  ///```
  final ImageProvider plotAreaBackgroundImage;

  ///Data points or series can be selected while performing interaction on the chart.
  ///It can also be selected at the initial rendering using this property.
  ///
  ///Defaults to `[]`.
  ///
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///           series: <BarSeries<SalesData, num>>[
  ///                BarSeries<SalesData, num>(
  ///                 initialSelectedDataIndexes: <int>[2, 0],
  ///                  selectionSettings: SelectionSettings(
  ///                    selectedColor: Colors.red,
  ///                    unselectedColor: Colors.grey
  ///                  ),
  ///                ),
  ///              ],
  ///        ));
  ///}
  ///```

  ///By setting this, the orientation of x-axis is set to vertical and orientation of
  ///y-axis is set to horizontal.
  ///
  ///Defaults to `false`.
  ///
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///            isTransposed: true,
  ///        ));
  ///}
  ///```
  final bool isTransposed;

  ///Axis elements animation on visible range change.
  ///
  ///Axis elements like grid lines, tick lines and labels will be animated when the axis range is changed dynamically.
  /// Axis visible range will be changed while zooming, panning or while updating the data points.
  ///
  ///The elements will be animated on setting `true` to this property and this is applicable for all primary and secondary axis in the chart.
  ///
  ///Defaults to `false`
  ///
  ///See also [ChartSeries.animationDuration] for changing the series animation duration.
  ///
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///            enableAxisAnimation: true,
  ///        ));
  ///}
  ///```
  final bool enableAxisAnimation;

  ///Customizes the series in chart.
  ///
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///           series: <ChartSeries<SalesData, num>>[
  ///                AreaSeries<SalesData, num>(
  ///                    dataSource: chartData,
  ///                ),
  ///              ],
  ///        ));
  ///}
  ///```
  final List<ChartSeries<dynamic, dynamic>> series;

  ///Color palette for chart series. If the series color is not specified, then the series
  ///will be rendered with appropriate palette color. Ten colors are available by default.
  ///
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///            palette: <Color>[Colors.red, Colors.green]
  ///        ));
  ///}
  ///```
  final List<Color> palette;

  ///Technical indicators for charts.
  final List<TechnicalIndicators<dynamic, dynamic>> indicators;

  /// Setting series animation duration factor
  final double _seriesDurationFactor = 0.85;

  /// Setting trendline animation duration factor
  final double _trendlineDurationFactor = 0.85;

  /// Holds the information of chart state class
  _SfCartesianChartState _chartState;

  /// Whether to check chart axis is inverted or not
  //ignore: prefer_final_fields
  bool _requireInvertedAxis = false;

  /// Holds the information of AxisBase class
  _ChartAxis _chartAxis;

  /// Holds the information of SeriesBase class
  _ChartSeries _chartSeries;

  /// Holds the information of LegendBase class
  _ChartLegend _chartLegend;

  /// Holds the information of _ContainerArea class
  /// ignore: unused_field
  _ContainerArea _containerArea;

  //ignore: prefer_final_fields
  List<_ChartPointInfo> _chartPointInfo = <_ChartPointInfo>[];

  @override
  State<StatefulWidget> createState() => _SfCartesianChartState();
}

class _SfCartesianChartState extends State<SfCartesianChart> with SingleTickerProviderStateMixin {
  /// Animation controller for series
  AnimationController animationController;

  /// Holds the animation controller list for all series
  List<AnimationController> controllerList;

  /// Repaint notifier for zoom container
  ValueNotifier<int> zoomRepaintNotifier;

  /// Repaint notifier for series container
  ValueNotifier<int> seriesRepaintNotifier;

  /// Repaint notifier for trendline container
  ValueNotifier<int> trendlineRepaintNotifier;

  /// Repaint notifier for trackball container
  ValueNotifier<int> trackballRepaintNotifier;

  /// Repaint notifier for crosshair container
  ValueNotifier<int> crosshairRepaintNotifier;

  /// Repaint notifier for indicator
  ValueNotifier<int> indicatorRepaintNotifier;

  /// To measure legend size and position
  List<_MeasureWidgetContext> legendWidgetContext;

  /// Chart Template info
  List<_ChartTemplateInfo> templates;
  List<ChartAxis> zoomedAxisStates;

  List<ChartAxis> oldAxes;

  /// Contains chart container size
  Rect containerRect;

  /// Holds the information of chart theme arguments
  SfChartThemeData _chartTheme;
  bool zoomProgress;
  List<_ZoomAxisRange> zoomAxes;
  bool initialRender;
  List<_LegendRenderContext> legendToggleStates;
  List<ChartSegment> selectedSegments;
  List<ChartSegment> unselectedSegments;
  List<_MeasureWidgetContext> legendToggleTemplateStates;
  List<Rect> renderDatalabelRegions;
  Orientation deviceOrientation;
  List<Rect> dataLabelTemplateRegions;
  List<Rect> annotationRegions;
  bool animateCompleted;
  bool widgetNeedUpdate;
  _DataLabelRenderer renderDataLabel;
  _CartesianAxisRenderer renderAxis;
  List<CartesianSeriesRenderer> oldSeriesRenderers;
  List<ValueKey<String>> _oldSeriesKeys;
  bool _isLegendToggled;
  List<ChartSegment> segments;
  List<bool> _oldSeriesVisible;
  bool zoomedState;
  Animation<double> chartElementAnimation;
  List<PointerEvent> _touchStartPositions;
  List<PointerEvent> _touchMovePositions;
  bool _enableDoubleTap;
  Orientation _oldDeviceOrientation;
  bool _legendToggling;
  dart_ui.Image _backgroundImage;
  dart_ui.Image _legendIconImage;
  bool isTrendlineToggled = false;
  List<_PainterKey> painterKeys;
  bool triggerLoaded;
  bool rangeChangeBySlider = false;
  bool rangeChangedByChart = false;
  bool isRangeSelectionSlider = false;
  bool isFullyLoaded;
  bool _isSeriesLoaded;
  bool isNeedUpdate;
  bool trackballWithoutTouch = true;
  bool crosshairWithoutTouch = true;
  List<CartesianSeriesRenderer> seriesRenderers;

  //ignore: prefer_final_fields
  bool _needsAnimation = false;

  void _initializeDefaultValues() {
    seriesRenderers = <CartesianSeriesRenderer>[];
    controllerList = <AnimationController>[];
    zoomRepaintNotifier = ValueNotifier<int>(0);
    seriesRepaintNotifier = ValueNotifier<int>(0);
    trendlineRepaintNotifier = ValueNotifier<int>(0);
    trackballRepaintNotifier = ValueNotifier<int>(0);
    crosshairRepaintNotifier = ValueNotifier<int>(0);
    indicatorRepaintNotifier = ValueNotifier<int>(0);
    legendWidgetContext = <_MeasureWidgetContext>[];
    templates = <_ChartTemplateInfo>[];
    zoomedAxisStates = <ChartAxis>[];
    zoomAxes = <_ZoomAxisRange>[];
    containerRect = const Rect.fromLTRB(0, 0, 0, 0);
    zoomProgress = false;
    initialRender = true;
    legendToggleStates = <_LegendRenderContext>[];
    selectedSegments = <ChartSegment>[];
    unselectedSegments = <ChartSegment>[];
    legendToggleTemplateStates = <_MeasureWidgetContext>[];
    renderDatalabelRegions = <Rect>[];
    dataLabelTemplateRegions = <Rect>[];
    annotationRegions = <Rect>[];
    animateCompleted = false;
    widgetNeedUpdate = false;
    oldSeriesRenderers = <CartesianSeriesRenderer>[];
    _oldSeriesKeys = <ValueKey<String>>[];
    _isLegendToggled = false;
    _oldSeriesVisible = <bool>[];
    _touchStartPositions = <PointerEvent>[];
    _touchMovePositions = <PointerEvent>[];
    _enableDoubleTap = false;
    _legendToggling = false;
    painterKeys = <_PainterKey>[];
    isNeedUpdate = true;
    animationController = AnimationController(vsync: this)..addListener(repaintChartElements);
    widget._chartState = this;
  }

  @override
  void initState() {
    _initializeDefaultValues();
    // Create the series renderer while initial rendering //
    createAndUpdateSeriesRenderer();
    super.initState();
  }

  @override
  void didChangeDependencies() {
    _chartTheme = SfChartTheme.of(context);
    super.didChangeDependencies();
  }

  @override
  void didUpdateWidget(SfCartesianChart oldWidget) {
    //Update and maintain the series state, when we update the series in the series collection //
    createAndUpdateSeriesRenderer(oldWidget);
    _needsRepaintChart(widget, oldWidget);

    _isLegendToggled = false;
    if (widget._chartState != null &&
        widget._chartState.legendWidgetContext != null &&
        widget._chartState.legendWidgetContext.isNotEmpty) {
      widget._chartState.legendWidgetContext.clear();
    }
    if (isNeedUpdate) {
      initialRender = false;
      widgetNeedUpdate = true;
      oldSeriesRenderers = oldWidget._chartSeries.visibleSeriesRenderers;
      _getKeys(oldSeriesRenderers);
      oldAxes = oldWidget._chartAxis._axisCollections;
    }
    super.didUpdateWidget(oldWidget);
  }

  ///Storing old series key values
  void _getKeys(List<CartesianSeriesRenderer> oldSeriesRenderers) {
    _oldSeriesKeys = <ValueKey<String>>[];
    for (int i = 0; i < oldSeriesRenderers.length; i++) {
      _oldSeriesKeys.add(oldSeriesRenderers[i]._series.key);
    }
  }

  // In this method, create and update the series renderer for each series //
  void createAndUpdateSeriesRenderer([SfCartesianChart oldWidget]) {
    List<CartesianSeriesRenderer> oldWidgetSeriesRenderers, oldWidgetOldSeriesRenderers;
    if (widget.series != null && widget.series.isNotEmpty) {
      if (oldWidget != null) {
        oldWidgetSeriesRenderers = <CartesianSeriesRenderer>[]..addAll(seriesRenderers);
        oldWidgetOldSeriesRenderers = <CartesianSeriesRenderer>[]..addAll(oldSeriesRenderers);

        oldSeriesRenderers = <CartesianSeriesRenderer>[];
        oldSeriesRenderers.addAll(oldWidgetSeriesRenderers);
      }
      seriesRenderers = <CartesianSeriesRenderer>[];
      final int seriesLength = widget.series.length;
      widget._chartState = this;
      dynamic series;
      int index, oldSeriesIndex;
      for (int i = 0; i < seriesLength; i++) {
        series = widget.series[i];
        index = null;
        oldSeriesIndex = null;
        if (oldWidget != null) {
          if (oldWidgetOldSeriesRenderers.isNotEmpty) {
            // Check the current series is already exist in oldwidget //
            index =
                i < oldWidgetOldSeriesRenderers.length && _isSameSeries(oldWidgetOldSeriesRenderers[i]._series, series)
                    ? i
                    : getExistingSeriesIndex(series, oldWidgetOldSeriesRenderers);
          }
          if (oldWidgetSeriesRenderers.isNotEmpty) {
            oldSeriesIndex =
                i < oldWidgetSeriesRenderers.length && _isSameSeries(oldWidgetSeriesRenderers[i]._series, series)
                    ? i
                    : getExistingSeriesIndex(series, oldWidgetSeriesRenderers);
          }
        }
        // Create and update the series list here
        CartesianSeriesRenderer seriesRenderer;

        if (index != null && index < oldWidgetOldSeriesRenderers.length && oldWidgetOldSeriesRenderers[index] != null) {
          seriesRenderer = oldWidgetOldSeriesRenderers[index];
        } else {
          seriesRenderer = series.createRenderer(series);
          if (seriesRenderer._controller == null && series.onRendererCreated != null) {
            seriesRenderer._controller = ChartSeriesController(seriesRenderer);
            series.onRendererCreated(seriesRenderer._controller);
          }
        }

        seriesRenderer._series = series;
        seriesRenderer._chart = widget;
        if (oldWidgetSeriesRenderers != null &&
            oldSeriesIndex != null &&
            oldWidgetSeriesRenderers.length > oldSeriesIndex) {
          seriesRenderer._oldSeries = oldWidgetSeriesRenderers[oldSeriesIndex]._series;
          seriesRenderer._oldDataPoints = <CartesianChartPoint<dynamic>>[]
            //ignore: prefer_spread_collections
            ..addAll(oldWidgetSeriesRenderers[oldSeriesIndex]._dataPoints);
        }

        seriesRenderers.add(seriesRenderer);
        widget._chartSeries.visibleSeriesRenderers.add(seriesRenderer);
      }
    } else {
      seriesRenderers.clear();
      widget._chartSeries.visibleSeriesRenderers.clear();
      widget._chartState = this;
    }
  }

  /// Check current series index is exist in another index
  int getExistingSeriesIndex(
      CartesianSeries<dynamic, dynamic> currentSeries, List<CartesianSeriesRenderer> oldSeriesRenderers) {
    if (currentSeries.key != null) {
      for (int index = 0; index < oldSeriesRenderers.length; index++) {
        final CartesianSeries<dynamic, dynamic> series = oldSeriesRenderers[index]._series;
        if (_isSameSeries(series, currentSeries)) {
          return index;
        }
      }
    }
    return null;
  }

  /// Refresh method for axis
  void _refresh() {
    if (widget._chartState.legendWidgetContext.isNotEmpty) {
      for (int i = 0; i < widget._chartState.legendWidgetContext.length; i++) {
        final _MeasureWidgetContext templateContext = widget._chartState.legendWidgetContext[i];
        final RenderBox renderBox = templateContext.context.findRenderObject();
        templateContext.size = renderBox.size;
      }
      setState(() {});
    }
  }

  /// Redraw method for chart axis
  void _redraw() {
    widget._chartState.oldAxes = widget._chartAxis._axisCollections;
    widget._chartState.initialRender = false;
    if (widget.tooltipBehavior?._painter?.timer != null) {
      widget.tooltipBehavior._painter.timer.cancel();
    }
    if (widget.trackballBehavior?._trackballPainter?.timer != null) {
      widget.trackballBehavior._trackballPainter.timer.cancel();
    }
    if (widget._chartState._isLegendToggled) {
      widget._chartState.segments = <ChartSegment>[];
      widget._chartState._oldSeriesVisible = List<bool>(widget._chartSeries.visibleSeriesRenderers.length);
      for (int i = 0; i < widget._chartSeries.visibleSeriesRenderers.length; i++) {
        final CartesianSeriesRenderer seriesRenderer = widget._chartSeries.visibleSeriesRenderers[i];
        if (seriesRenderer is ColumnSeriesRenderer || seriesRenderer is BarSeriesRenderer) {
          for (int j = 0; j < seriesRenderer._segments.length; j++) {
            widget._chartState.segments.add(seriesRenderer._segments[j]);
          }
        }
      }
    }
    if (widget._chartState.zoomedAxisStates != null && widget._chartState.zoomedAxisStates.isNotEmpty) {
      zoomedState = false;
      for (ChartAxis axis in zoomedAxisStates) {
        zoomedState = axis._zoomFactor != 1;
        if (zoomedState) {
          break;
        }
      }
    }
    widgetNeedUpdate = false;

    if (mounted) {
      setState(() {});
    }
  }

  void redrawByRangeChange() {
    if (mounted) {
      setState(() {});
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
    trendlineRepaintNotifier.value++;
  }

  void setPainterKey(int index, String name, bool renderComplete) {
    int value = 0;
    for (int i = 0; i < painterKeys.length; i++) {
      final _PainterKey painterKey = painterKeys[i];
      if (painterKey.isRenderCompleted) {
        value++;
      } else if (painterKey.index == index && painterKey.name == name && !painterKey.isRenderCompleted) {
        painterKey.isRenderCompleted = renderComplete;
        value++;
      }
      if (value >= painterKeys.length && !triggerLoaded) {
        triggerLoaded = true;
        // Future<void>.delayed(const Duration(milliseconds: 0), () {
        //   //Chart fully loaded here.
        // });
        if (widget._chartState.renderDataLabel == null) widget._chartState.initialRender = false;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    _oldDeviceOrientation = _oldDeviceOrientation == null ? MediaQuery.of(context).orientation : deviceOrientation;
    deviceOrientation = MediaQuery.of(context).orientation;
    widget._chartState = this;
    widget._chartState.triggerLoaded = false;
    _isSeriesLoaded = _isSeriesLoaded ?? true;
    _findVisibleSeries(context);
    _isSeriesLoaded = false;
    return _ChartContainer(
        child: Container(
      decoration: BoxDecoration(
          color: widget.backgroundColor ?? _chartTheme.backgroundColor,
          border: Border.all(color: widget.borderColor, width: widget.borderWidth)),
      child: Container(
          margin: EdgeInsets.fromLTRB(widget.margin.left, widget.margin.top, widget.margin.right, widget.margin.bottom),
          child: Column(
            children: <Widget>[_renderTitle(), _renderChartElements(context)],
          )),
    ));
  }

  Widget _renderTitle() {
    Widget titleWidget;
    if (widget.title.text != null && widget.title.text.isNotEmpty) {
      final Paint titleBackground = Paint()
        ..color = widget.title.borderColor
        ..style = PaintingStyle.stroke
        ..strokeWidth = widget.title.borderWidth;
      final TextStyle titleStyle = _getTextStyle(
          textStyle: widget.title.textStyle,
          background: titleBackground,
          fontColor: widget.title.textStyle.color ?? widget._chartState._chartTheme.titleTextColor);
      final TextStyle textStyle = TextStyle(
          color: titleStyle.color,
          fontSize: titleStyle.fontSize,
          fontFamily: titleStyle.fontFamily,
          fontStyle: titleStyle.fontStyle,
          fontWeight: titleStyle.fontWeight);
      titleWidget = Container(
        child: Container(
          child: Text(widget.title.text,
              overflow: TextOverflow.clip, textAlign: TextAlign.center, textScaleFactor: 1.2, style: textStyle),
          decoration: BoxDecoration(
              color: widget.title.backgroundColor ?? widget._chartState._chartTheme.titleBackgroundColor,
              border: Border.all(
                  color: widget.title.borderWidth == 0
                      ? Colors.transparent
                      : widget.title.borderColor ?? widget._chartState._chartTheme.titleTextColor,
                  width: widget.title.borderWidth)),
        ),
        alignment: (widget.title.alignment == ChartAlignment.near)
            ? Alignment.topLeft
            : (widget.title.alignment == ChartAlignment.far)
                ? Alignment.topRight
                : (widget.title.alignment == ChartAlignment.center) ? Alignment.topCenter : Alignment.topCenter,
      );
    } else {
      titleWidget = Container();
    }
    return titleWidget;
  }

  /// To arrange the chart area and legend area based on the legend position
  Widget _renderChartElements(BuildContext context) {
    if (widget.plotAreaBackgroundImage != null || widget.legend.image != null) _calculateImage(widget);
    widget._chartState.deviceOrientation = MediaQuery.of(context).orientation;
    return Expanded(
      child: LayoutBuilder(builder: (BuildContext context, BoxConstraints constraints) {
        Widget element;
        final List<Widget> legendTemplates = _bindCartesianLegendTemplateWidgets();
        if (legendTemplates.isNotEmpty && legendWidgetContext.isEmpty) {
          element = Container(child: Stack(children: legendTemplates));
          SchedulerBinding.instance.addPostFrameCallback((_) => _refresh());
        } else {
          _initialize(constraints);
          widget._chartLegend._calculateLegendBounds(widget._chartLegend.chartSize);
          element = _getElements(widget, _ContainerArea(chart: widget), constraints);
        }
        return element;
      }),
    );
  }

  /// To return the template widget
  List<Widget> _bindCartesianLegendTemplateWidgets() {
    Widget legendWidget;
    final List<Widget> templates = <Widget>[];
    if (widget.legend.isVisible && widget.legend.legendItemBuilder != null) {
      for (int i = 0; i < widget._chartState.seriesRenderers.length; i++) {
        final CartesianSeriesRenderer seriesRenderer = widget._chartState.seriesRenderers[i];
        if (seriesRenderer._series.isVisibleInLegend) {
          legendWidget = widget.legend.legendItemBuilder(seriesRenderer._seriesName, seriesRenderer._series, null, i);
          templates.add(_MeasureWidgetSize(
              chart: widget,
              seriesIndex: i,
              pointIndex: null,
              type: 'Legend',
              currentKey: GlobalKey(),
              currentWidget: legendWidget,
              opacityValue: 0.0));
        }
      }
    }
    return templates;
  }

  void _initialize(BoxConstraints constraints) {
    widget._chartLegend.chart = widget;
    widget._chartSeries.chart = widget;
    widget._chartAxis._chartWidget = widget;
    final double width = constraints.maxWidth;
    final double height = constraints.maxHeight;
    widget.legend.legendPosition = (widget.legend.position == LegendPosition.auto)
        ? (height > width ? LegendPosition.bottom : LegendPosition.right)
        : widget.legend.position;
    final LegendPosition position = widget.legend.legendPosition;
    final double widthPadding = position == LegendPosition.left || position == LegendPosition.right ? 5 : 0;
    final double heightPadding = position == LegendPosition.top || position == LegendPosition.bottom ? 5 : 0;
    widget._chartLegend.chartSize = Size(width - widthPadding, height - heightPadding);
  }

  /// To find the visible series
  void _findVisibleSeries(BuildContext context) {
    bool _legendCheck = false;
    widget._chartSeries.visibleSeriesRenderers = <CartesianSeriesRenderer>[];
    final List<CartesianSeriesRenderer> visibleSeriesRenderers = widget._chartSeries.visibleSeriesRenderers;
    for (int i = 0; i < seriesRenderers.length; i++) {
      seriesRenderers[i]._seriesName = seriesRenderers[i]._series.name ?? 'Series $i';
      final CartesianSeries<dynamic, dynamic> cartesianSeries = seriesRenderers[i]._series;
      final List<CartesianSeriesRenderer> oldSeriesRenderers = widget._chartState.oldSeriesRenderers;
      if (cartesianSeries.trendlines != null) {
        final List<int> trendlineTypes = <int>[0, 0, 0, 0, 0, 0];
        for (Trendline trendline in cartesianSeries.trendlines)
          trendline._name ??= (trendline.type == TrendlineType.movingAverage
                  ? 'Moving average'
                  : trendline.type.toString().substring(14)) +
              (' ' + (trendlineTypes[trendline.type.index]++).toString());
        for (Trendline trendline in cartesianSeries.trendlines) {
          trendline._name = trendline._name[0].toUpperCase() + trendline._name.substring(1);
          if (trendlineTypes[trendline.type.index] == 1 && trendline._name[trendline._name.length - 1] == '0')
            trendline._name = trendline._name.substring(0, trendline._name.length - 2);
        }
      }
      if (widget._chartState.initialRender ||
          (widget._chartState.widgetNeedUpdate &&
              !widget._chartState._legendToggling &&
              (widget._chartState._oldDeviceOrientation == MediaQuery.of(context).orientation))) {
        seriesRenderers[i]._visible = oldSeriesRenderers.isNotEmpty &&
                oldSeriesRenderers.length > i &&
                oldSeriesRenderers[i]._series.isVisible == seriesRenderers[i]._series.isVisible
            ? oldSeriesRenderers[i]._visible
            : widget._chartState.initialRender
                ? seriesRenderers[i]._series.isVisible
                : seriesRenderers[i]._visible ?? seriesRenderers[i]._series.isVisible;
        if (oldSeriesRenderers.isNotEmpty &&
            oldSeriesRenderers.length > i &&
            oldSeriesRenderers[i]._series.isVisible == seriesRenderers[i]._series.isVisible &&
            _isSeriesLoaded) {
          _legendCheck = true;
        }
      } else {
        _legendCheck = true;
      }
      if (i == 0 ||
          (!seriesRenderers[0]._series.toString().contains('Bar') &&
              !seriesRenderers[i]._series.toString().contains('Bar')) ||
          (seriesRenderers[0]._series.toString().contains('Bar') &&
              (seriesRenderers[i]._series.toString().contains('Bar')))) {
        visibleSeriesRenderers.add(seriesRenderers[i]);
        if (!widget._chartState.initialRender &&
            widget._chartState._oldSeriesVisible.isNotEmpty &&
            i < visibleSeriesRenderers.length) {
          if (i < visibleSeriesRenderers.length && i < widget._chartState._oldSeriesVisible.length) {
            widget._chartState._oldSeriesVisible[i] = visibleSeriesRenderers[i]._visible;
          }
        }
        if (_legendCheck) {
          final int index = visibleSeriesRenderers.length - 1;
          final String legendItemText = visibleSeriesRenderers[index]._series.legendItemText;
          final String seriesName = visibleSeriesRenderers[index]._series.name;
          widget._chartSeries.visibleSeriesRenderers[visibleSeriesRenderers.length - 1]._visible =
              _checkWithLegendToggleState(
                  visibleSeriesRenderers.length - 1,
                  visibleSeriesRenderers[visibleSeriesRenderers.length - 1]._series,
                  legendItemText != null ? legendItemText : seriesName ?? 'Series $index');
        }
        final CartesianSeriesRenderer cSeriesRenderer =
            widget._chartSeries.visibleSeriesRenderers[visibleSeriesRenderers.length - 1] is CartesianSeriesRenderer
                ? widget._chartSeries.visibleSeriesRenderers[visibleSeriesRenderers.length - 1]
                : null;
        if (cSeriesRenderer?._series != null && cSeriesRenderer._series.trendlines != null) {
          for (int j = 0; j < cSeriesRenderer._series.trendlines.length; j++) {
            final Trendline trendline = cSeriesRenderer._series.trendlines[j];
            trendline._visible = _checkWithTrendlineLegendToggleState(
                    visibleSeriesRenderers.length - 1, cSeriesRenderer._series, j, trendline, trendline._name) &&
                cSeriesRenderer._visible;
          }
          isTrendlineToggled = false;
        }
      }
      _legendCheck = false;
    }
    widget._chartSeries.visibleSeriesRenderers = visibleSeriesRenderers;

    /// setting indicators visibility
    if (widget.indicators.isNotEmpty) {
      for (int i = 0; i < widget.indicators.length; i++) {
        if (widget._chartState.initialRender) {
          widget.indicators[i]._visible = widget.indicators[i].isVisible;
        } else {
          widget.indicators[i]._visible = _checkIndicatorLegendToggleState(
              visibleSeriesRenderers.length + i, widget.indicators[i]._visible ?? widget.indicators[i].isVisible);
        }
      }
    }
  }

  /// To check the legend toggle state
  bool _checkIndicatorLegendToggleState(int seriesIndex, bool seriesVisible) {
    bool seriesRender;
    if (widget.legend.legendItemBuilder != null) {
      final List<_MeasureWidgetContext> legendToggles = widget._chartState.legendToggleTemplateStates;
      if (legendToggles.isNotEmpty) {
        for (int j = 0; j < legendToggles.length; j++) {
          final _MeasureWidgetContext item = legendToggles[j];
          if (seriesIndex == item.seriesIndex) {
            seriesRender = false;
            break;
          }
        }
      }
    } else {
      if (widget._chartState.legendToggleStates.isNotEmpty) {
        for (int j = 0; j < widget._chartState.legendToggleStates.length; j++) {
          final _LegendRenderContext legendRenderContext = widget._chartState.legendToggleStates[j];
          if (seriesIndex == legendRenderContext.seriesIndex) {
            seriesRender = false;
            break;
          }
        }
      }
    }
    return seriesRender ?? true;
  }

  /// Check whether trendline enable with legend toggled state
  bool _checkWithTrendlineLegendToggleState(
      int seriesIndex, CartesianSeries<dynamic, dynamic> series, int trendlineIndex, Trendline trendline, String text) {
    bool seriesRender;
    if (widget._chartState.legendToggleStates.isNotEmpty) {
      for (int j = 0; j < widget._chartState.legendToggleStates.length; j++) {
        final _LegendRenderContext legendRenderContext = widget._chartState.legendToggleStates[j];
        if ((legendRenderContext.text == text &&
                legendRenderContext.seriesIndex == seriesIndex &&
                legendRenderContext.trendlineIndex == trendlineIndex) ||
            isTrendlineToggled) {
          seriesRender = false;
          break;
        }
      }
    }
    return seriesRender ?? true;
  }

  bool _checkWithLegendToggleState(int seriesIndex, ChartSeries<dynamic, dynamic> series, String text) {
    bool seriesRender;
    if (widget.legend.legendItemBuilder != null) {
      final List<_MeasureWidgetContext> legendToggles = widget._chartState.legendToggleTemplateStates;
      if (legendToggles.isNotEmpty) {
        for (int j = 0; j < legendToggles.length; j++) {
          final _MeasureWidgetContext item = legendToggles[j];
          if (seriesIndex == item.seriesIndex) {
            seriesRender = false;
            break;
          }
        }
      }
    } else {
      if (widget._chartState.legendToggleStates.isNotEmpty) {
        for (int j = 0; j < widget._chartState.legendToggleStates.length; j++) {
          final _LegendRenderContext legendRenderContext = widget._chartState.legendToggleStates[j];
          if (seriesIndex == legendRenderContext.seriesIndex && legendRenderContext.text == text) {
            if (series is CartesianSeries) {
              final CartesianSeries<dynamic, dynamic> cSeries = series;
              if (cSeries.trendlines != null) {
                isTrendlineToggled = true;
              }
            }
            seriesRender = false;
            break;
          }
        }
      }
    }
    return seriesRender ?? true;
  }
}

// ignore: must_be_immutable
class _ContainerArea extends StatelessWidget {
  // ignore: prefer_const_constructors_in_immutables
  _ContainerArea({this.chart});

  SfCartesianChart chart;
  List<Widget> _chartWidgets;
  RenderBox renderBox;
  Offset _touchPosition;
  Offset _tapDownDetails;
  Offset _mousePointerDetails;
  CartesianSeries<dynamic, dynamic> _series;
  XyDataSeriesRenderer _seriesRenderer;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (BuildContext context, BoxConstraints constraints) {
      return Container(
          decoration: const BoxDecoration(color: Colors.transparent),

          /// To get the mouse region of the chart
          child: MouseRegion(
              child: _initializeChart(constraints, context),
              onHover: (PointerEvent event) => _performMouseHover(event),
              onExit: (PointerEvent event) => _performMouseExit(event)));
    });
  }

  Offset _zoomStartPosition;

  Widget _initializeChart(BoxConstraints constraints, BuildContext context) {
    _calculateSize(constraints);
    _calculateBounds();
    return Container(
        decoration: const BoxDecoration(color: Colors.transparent), child: _renderWidgets(constraints, context));
  }

  /// To get the size of a container
  void _calculateSize(BoxConstraints constraints) {
    final double width = constraints.maxWidth;
    final double height = constraints.maxHeight;
    chart._chartState.containerRect = Rect.fromLTWH(0, 0, width, height);
  }

  /// Calculate container bounds
  void _calculateBounds() {
    chart._chartSeries.chart = chart;
    chart._chartAxis._chartWidget = chart;
    chart._chartSeries?._processData();
    chart._chartAxis?._measureAxesBounds();
    chart._chartState.rangeChangeBySlider = false;
    chart._chartState.rangeChangedByChart = false;
  }

  /// To calculate the trendline region
  void _calculateTrendlineRegion(SfCartesianChart chart, XyDataSeriesRenderer seriesRenderer) {
    if (seriesRenderer._series.trendlines != null) {
      for (Trendline trendline in seriesRenderer._series.trendlines) {
        if (trendline._isNeedRender) trendline.calculateTrendlinePoints(seriesRenderer, chart);
      }
    }
  }

  Widget _renderWidgets(BoxConstraints constraints, BuildContext context) {
    _chartWidgets = <Widget>[];
    chart._chartState.renderDatalabelRegions = <Rect>[];
    chart.zoomPanBehavior._setChart(chart);
    _bindAxisWidgets('outside');
    _bindPlotBandWidgets(true);
    _bindSeriesWidgets();
    _bindPlotBandWidgets(false);
    _bindDataLabelWidgets();
    _bindTrendlineWidget();
    _bindAxisWidgets('inside');
    _renderTemplates();
    _bindInteractionWidgets(constraints, context);
    renderBox = context.findRenderObject();
    chart._containerArea = this;
    return Container(child: Stack(children: _chartWidgets));
  }

  void _bindPlotBandWidgets(bool shouldRenderAboveSeries) => _chartWidgets
      .add(CustomPaint(painter: _PlotBandPainter(chart: chart, shouldRenderAboveSeries: shouldRenderAboveSeries)));

  void _bindTrendlineWidget() {
    Animation<double> trendlineAnimation;
    for (int i = 0; i < chart._chartSeries.visibleSeriesRenderers.length; i++) {
      final CartesianSeriesRenderer seriesRenderer = chart._chartSeries.visibleSeriesRenderers[i];
      final XyDataSeries<dynamic, dynamic> _series = seriesRenderer._series;
      if (seriesRenderer != null && seriesRenderer._visible && _series.trendlines != null) {
        for (int j = 0; j < _series.trendlines.length; j++) {
          if (_series.trendlines[j].animationDuration > 0 &&
              chart._chartState != null &&
              chart._chartState.initialRender) {
            chart._chartState.animationController.duration =
                Duration(milliseconds: _series.trendlines[j].animationDuration.toInt());
            trendlineAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
              parent: chart._chartState.animationController,
              curve: const Interval(0.1, 0.8, curve: Curves.decelerate),
            ));
            chart._chartState.animationController.forward(from: 0.0);
          }
        }
      }
      _chartWidgets.add(
        CustomPaint(
            painter: _TrendlinePainter(
                chart: chart,
                trendlineAnimation: trendlineAnimation,
                notifier: chart._chartState.trendlineRepaintNotifier)),
      );
    }
  }

  /// To bind the widget for data label
  void _bindDataLabelWidgets() {
    chart._chartState.renderDataLabel =
        _DataLabelRenderer(cartesianChart: chart, show: chart._chartState.animateCompleted);
    _chartWidgets.add(chart._chartState.renderDataLabel);
  }

  /// To render a template
  void _renderTemplates() {
    chart._chartState.annotationRegions = <Rect>[];
    chart._chartState.templates = <_ChartTemplateInfo>[];
    _renderDataLabelTemplates();
    if (chart.annotations != null && chart.annotations.isNotEmpty) {
      for (int i = 0; i < chart.annotations.length; i++) {
        final CartesianChartAnnotation annotation = chart.annotations[i];
        final _ChartLocation location = _getAnnotationLocation(annotation, chart);
        final _ChartTemplateInfo chartTemplateInfo = _ChartTemplateInfo(
            key: GlobalKey(),
            animationDuration: 200,
            widget: annotation.widget,
            templateType: 'Annotation',
            needMeasure: true,
            pointIndex: i,
            verticalAlignment: annotation.verticalAlignment,
            horizontalAlignment: annotation.horizontalAlignment,
            clipRect: annotation.region == AnnotationRegion.chart
                ? chart._chartState.containerRect
                : chart._chartAxis._axisClipRect,
            location: Offset(location.x.toDouble(), location.y.toDouble()));
        chart._chartState.templates.add(chartTemplateInfo);
      }
    }

    if (chart._chartState.templates.isNotEmpty) {
      final int templateLength = chart._chartState.templates.length;
      for (int i = 0; i < chart._chartState.templates.length; i++) {
        final _ChartTemplateInfo templateInfo = chart._chartState.templates[i];
        _chartWidgets.add(
            _RenderTemplate(template: templateInfo, templateIndex: i, templateLength: templateLength, chart: chart));
      }
    }
  }

  /// To render data label template
  void _renderDataLabelTemplates() {
    Widget labelWidget;
    CartesianChartPoint<dynamic> point;
    chart._chartState.dataLabelTemplateRegions = <Rect>[];
    for (int i = 0; i < chart._chartSeries.visibleSeriesRenderers.length; i++) {
      final CartesianSeriesRenderer seriesRenderer = chart._chartSeries.visibleSeriesRenderers[i];
      final XyDataSeries<dynamic, dynamic> series = seriesRenderer._series;
      if (series.dataLabelSettings.isVisible && seriesRenderer._visible) {
        for (int j = 0; j < seriesRenderer._dataPoints.length; j++) {
          point = seriesRenderer._dataPoints[j];
          if (point.isVisible && !point.isGap) {
            labelWidget = (series.dataLabelSettings.builder != null)
                ? series.dataLabelSettings.builder(
                    series.dataSource[point.overallDataPointIndex], point, series, point.overallDataPointIndex, i)
                : null;
            if (labelWidget != null) {
              final _ChartLocation location = _calculatePoint(
                  point.xValue,
                  seriesRenderer._seriesType.contains('range') ? point.high : point.yValue,
                  seriesRenderer._xAxis,
                  seriesRenderer._yAxis,
                  chart._requireInvertedAxis,
                  series,
                  chart._chartAxis._axisClipRect);
              final _ChartTemplateInfo templateInfo = _ChartTemplateInfo(
                  key: GlobalKey(),
                  templateType: 'DataLabel',
                  pointIndex: j,
                  seriesIndex: i,
                  needMeasure: true,
                  clipRect: chart._chartAxis._axisClipRect,
                  animationDuration: (series.animationDuration + 1000.0).floor(),
                  widget: labelWidget,
                  location: Offset(location.x, location.y));
              chart._chartState.templates.add(templateInfo);
              if (seriesRenderer._seriesType.contains('range')) {
                final _ChartLocation rangeLocation = _calculatePoint(point.xValue, point.low, seriesRenderer._xAxis,
                    seriesRenderer._yAxis, chart._requireInvertedAxis, series, chart._chartAxis._axisClipRect);
                final _ChartTemplateInfo templateInfo2 = _ChartTemplateInfo(
                    key: GlobalKey(),
                    templateType: 'DataLabel',
                    pointIndex: j,
                    seriesIndex: i,
                    needMeasure: true,
                    clipRect: chart._chartAxis._axisClipRect,
                    animationDuration: (series.animationDuration + 1000.0).floor(),
                    widget: labelWidget,
                    location: Offset(rangeLocation.x, rangeLocation.y));
                chart._chartState.templates.add(templateInfo2);
              }
            }
          }
        }
      }
    }
  }

  /// To bind a series of widgets for all series
  void _bindSeriesWidgets() {
    Animation<double> seriesAnimation;
    chart._chartState.painterKeys = <_PainterKey>[];
    for (int i = 0; i < chart._chartSeries.visibleSeriesRenderers.length; i++) {
      _seriesRenderer = chart._chartSeries.visibleSeriesRenderers[i];
      _series = _seriesRenderer._series;
      final String _seriesType = _seriesRenderer._seriesType;
      if (_seriesRenderer != null && _seriesRenderer._visible) {
        _calculateTrendlineRegion(chart, _seriesRenderer);
        final SelectionSettings selectionSettings = _series.selectionSettings;
        if (selectionSettings != null) {
          selectionSettings._selectionRenderer ??= _SelectionRenderer();
          selectionSettings._selectionRenderer.chart = chart;
          selectionSettings._selectionRenderer.seriesRenderer = _seriesRenderer;
          _series = _seriesRenderer._series;
          if (selectionSettings.selectionController != null) {
            selectionSettings.selectRange();
          }
          selectionSettings._selectionRenderer.selectedSegments = chart._chartState.selectedSegments;
          selectionSettings._selectionRenderer.unselectedSegments = chart._chartState.unselectedSegments;
          if (chart._chartState.isRangeSelectionSlider == false &&
              _series.selectionSettings.enable &&
              _series.initialSelectedDataIndexes.isNotEmpty) {
            for (int j = 0; j < _seriesRenderer._series.initialSelectedDataIndexes.length; j++) {
              final ChartSegment segment = ColumnSegment();
              segment.currentSegmentIndex = _seriesRenderer._series.initialSelectedDataIndexes[j];
              segment._seriesIndex = i;
              if (_seriesRenderer._series.initialSelectedDataIndexes.contains(segment.currentSegmentIndex))
                selectionSettings._selectionRenderer.selectedSegments.add(segment);
            }
          }
        }
        chart._chartState.animateCompleted = false;
        if (chart._chartState.animationController != null &&
            _series.animationDuration > 0 &&
            (chart._chartState._oldDeviceOrientation == null ||
                chart._chartState._oldDeviceOrientation == chart._chartState.deviceOrientation) &&
            (chart._chartState.initialRender ||
                ((_seriesType == 'column' || _seriesType == 'bar') && chart._chartState._legendToggling) ||
                (!chart._chartState._legendToggling &&
                    chart._chartState._needsAnimation &&
                    chart._chartState.widgetNeedUpdate))) {
          chart._chartState.animationController.duration = Duration(milliseconds: _series.animationDuration.toInt());
          seriesAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
            parent: chart._chartState.animationController,
            curve: const Interval(0.1, 0.8, curve: Curves.decelerate),
          ));

          chart._chartState.chartElementAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
            parent: chart._chartState.animationController,
            curve: const Interval(0.85, 1.0, curve: Curves.decelerate),
          ));
          chart._chartState.animationController.addStatusListener((AnimationStatus status) {
            if (status == AnimationStatus.completed) {
              chart._chartState.animateCompleted = true;
              if (chart._chartState.renderDataLabel != null) {
                chart._chartState.renderDataLabel.state.render();
              }
            }
          });
          chart._chartState.animationController.forward(from: 0.0);
        } else {
          chart._chartState.animateCompleted = true;
        }
      }
      _chartWidgets.add(Container(
          child: RepaintBoundary(
              child: CustomPaint(
        painter: _getSeriesPainter(i, chart._chartState.animationController, seriesAnimation,
            chart._chartState.chartElementAnimation, _seriesRenderer),
      ))));
    }
    _chartWidgets.add(Container(
        color: Colors.red,
        child: RepaintBoundary(
            child: CustomPaint(
                painter: _ZoomRectPainter(
                    isRepaint: true, chart: chart, notifier: chart._chartState.zoomRepaintNotifier)))));
    chart._chartState._legendToggling = false;
  }

  /// Bind the axis widgets
  void _bindAxisWidgets(String renderType) {
    if (chart._chartAxis._axisCollections != null &&
        chart._chartAxis._axisCollections.isNotEmpty &&
        chart._chartAxis._axisCollections.length > 1) {
      chart._chartState.renderAxis = _CartesianAxisRenderer(chart: chart, renderType: renderType);
      _chartWidgets.add(chart._chartState.renderAxis);
    }
  }

  CartesianSeriesRenderer _findSeries(Offset position) {
    CartesianSeriesRenderer seriesRenderer;
    outerLoop:
    for (int i = chart._chartSeries.visibleSeriesRenderers.length - 1; i >= 0; i--) {
      seriesRenderer = chart._chartSeries.visibleSeriesRenderers[i];
      final String _seriesType = seriesRenderer._seriesType;
      if (_seriesType == 'column' ||
          _seriesType == 'bar' ||
          _seriesType == 'scatter' ||
          _seriesType == 'bubble' ||
          _seriesType == 'fastline' ||
          _seriesType.contains('area') ||
          _seriesType.contains('stackedcolumn') ||
          _seriesType.contains('stackedbar') ||
          _seriesType.contains('range')) {
        for (int j = 0; j < seriesRenderer._dataPoints.length; j++) {
          if (seriesRenderer._dataPoints[j].region != null && seriesRenderer._dataPoints[j].region.contains(position)) {
            seriesRenderer._isOuterRegion = false;
            break outerLoop;
          } else {
            seriesRenderer._isOuterRegion = true;
          }
        }
      } else {
        bool isSelect = false;
        seriesRenderer = chart._chartSeries.visibleSeriesRenderers[i];
        for (int k = chart._chartSeries.visibleSeriesRenderers.length - 1; k >= 0; k--) {
          isSelect = seriesRenderer._series.selectionSettings.enable && seriesRenderer._visible
              ? seriesRenderer._series.selectionSettings._selectionRenderer
                  ._isSeriesContainsPoint(chart._chartSeries.visibleSeriesRenderers[i], position)
              : false;
          if (isSelect) {
            return chart._chartSeries.visibleSeriesRenderers[i];
          }
        }
      }
    }
    return seriesRenderer;
  }

  /// To perform the pointer down event
  void _performPointerDown(PointerDownEvent event) {
    chart.tooltipBehavior._isHovering = false;
    _tapDownDetails = event.position;
    if (chart.zoomPanBehavior.enablePinching == true) {
      ZoomPanArgs zoomStartArgs;
      if (chart._chartState._touchStartPositions.length < 2) {
        chart._chartState._touchStartPositions.add(event);
      }
      if (chart._chartState._touchStartPositions.length == 2) {
        for (int axisIndex = 0; axisIndex < chart._chartAxis._axisCollections.length; axisIndex++) {
          final dynamic axis = chart._chartAxis._axisCollections[axisIndex];
          if (chart.onZoomStart != null) {
            zoomStartArgs = _zoomEvent(chart, axis, zoomStartArgs, chart.onZoomStart);
            axis._zoomFactor = zoomStartArgs.currentZoomFactor;
            axis._zoomPosition = zoomStartArgs.currentZoomPosition;
          }
          chart.zoomPanBehavior.onPinchStart(
              axis,
              chart._chartState._touchStartPositions[0].position.dx,
              chart._chartState._touchStartPositions[0].position.dy,
              chart._chartState._touchStartPositions[1].position.dx,
              chart._chartState._touchStartPositions[1].position.dy,
              axis._zoomFactor);
        }
      }
    }
    final Offset position = renderBox.globalToLocal(event.position);
    _touchPosition = position;
    if (chart._chartSeries.visibleSeriesRenderers != null &&
        chart._chartSeries.visibleSeriesRenderers.isNotEmpty &&
        chart.selectionGesture == ActivationMode.singleTap &&
        chart.zoomPanBehavior._isPinching != true) {
      final CartesianSeriesRenderer selectionSeriesRenderer = _findSeries(position);
      if (!selectionSeriesRenderer._isOuterRegion &&
          selectionSeriesRenderer._series.selectionSettings._selectionRenderer != null) {
        selectionSeriesRenderer._series.selectionSettings._selectionRenderer.seriesRenderer = selectionSeriesRenderer;
        selectionSeriesRenderer._series.selectionSettings.onTouchDown(position.dx, position.dy);
      }
    }
    if (chart.trackballBehavior != null &&
        chart.trackballBehavior.enable &&
        chart.trackballBehavior.activationMode == ActivationMode.singleTap) {
      chart.trackballBehavior.onTouchDown(position.dx, position.dy);
    }
    if (chart.crosshairBehavior != null &&
        chart.crosshairBehavior.enable &&
        chart.crosshairBehavior.activationMode == ActivationMode.singleTap) {
      chart.crosshairBehavior.onTouchDown(position.dx, position.dy);
    }
  }

  /// To perform the pointer move event
  void _performPointerMove(PointerMoveEvent event) {
    chart.tooltipBehavior._isHovering = false;
    if (chart.zoomPanBehavior.enablePinching == true && chart._chartState._touchStartPositions.length == 2) {
      chart.zoomPanBehavior._isPinching = true;
      final int pointerID = event.pointer;
      bool addPointer = true;
      for (int i = 0; i < chart._chartState._touchMovePositions.length; i++) {
        if (chart._chartState._touchMovePositions[i].pointer == pointerID) {
          addPointer = false;
        }
      }
      if (chart._chartState._touchMovePositions.length < 2 && addPointer) {
        chart._chartState._touchMovePositions.add(event);
      }

      if (chart._chartState._touchMovePositions.length == 2 && chart._chartState._touchStartPositions.length == 2) {
        if (chart._chartState._touchMovePositions[0].pointer == event.pointer) {
          chart._chartState._touchMovePositions[0] = event;
        }
        if (chart._chartState._touchMovePositions[1].pointer == event.pointer) {
          chart._chartState._touchMovePositions[1] = event;
        }

        chart.zoomPanBehavior
            ._performPinchZooming(chart._chartState._touchStartPositions, chart._chartState._touchMovePositions);
      }
    }
  }

  /// To perform the pointer up event
  void _performPointerUp(PointerUpEvent event) {
    if (chart._chartState._touchStartPositions.length == 2 &&
        chart._chartState._touchMovePositions.length == 2 &&
        chart.zoomPanBehavior._isPinching) {
      _calculatePinchZoomingArgs();
    }
    chart._chartState._touchStartPositions = <PointerEvent>[];
    chart._chartState._touchMovePositions = <PointerEvent>[];
    chart.zoomPanBehavior._isPinching = false;
    chart.zoomPanBehavior._delayRedraw = false;
    chart.tooltipBehavior._isHovering = false;
    final Offset position = renderBox.globalToLocal(event.position);
    if ((chart.trackballBehavior != null &&
            chart.trackballBehavior.enable &&
            !chart.trackballBehavior.shouldAlwaysShow &&
            chart.trackballBehavior.activationMode != ActivationMode.doubleTap &&
            chart.zoomPanBehavior._isPinching != true) ||
        (chart.zoomPanBehavior != null &&
            ((chart.zoomPanBehavior.enableDoubleTapZooming ||
                    chart.zoomPanBehavior.enablePanning ||
                    chart.zoomPanBehavior.enablePinching ||
                    chart.zoomPanBehavior.enableSelectionZooming) &&
                !chart.trackballBehavior.shouldAlwaysShow))) {
      ChartTouchInteractionArgs touchUpArgs;
      chart.trackballBehavior.onTouchUp(position.dx, position.dy);
      chart.trackballBehavior._isLongPressActivated = false;
      if (chart.onChartTouchInteractionUp != null) {
        touchUpArgs = ChartTouchInteractionArgs();
        touchUpArgs.position = position;
        chart.onChartTouchInteractionUp(touchUpArgs);
      }
    }
    if ((chart.crosshairBehavior != null &&
            chart.crosshairBehavior.enable &&
            !chart.crosshairBehavior.shouldAlwaysShow &&
            chart.crosshairBehavior.activationMode != ActivationMode.doubleTap &&
            chart.zoomPanBehavior._isPinching != true) ||
        (chart.zoomPanBehavior != null &&
            ((chart.zoomPanBehavior.enableDoubleTapZooming ||
                    chart.zoomPanBehavior.enablePanning ||
                    chart.zoomPanBehavior.enablePinching ||
                    chart.zoomPanBehavior.enableSelectionZooming) &&
                !chart.crosshairBehavior.shouldAlwaysShow))) {
      ChartTouchInteractionArgs touchUpArgs;
      chart.crosshairBehavior.onTouchUp(position.dx, position.dy);
      chart.crosshairBehavior._isLongPressActivated = true;
      if (chart.onChartTouchInteractionUp != null) {
        touchUpArgs = ChartTouchInteractionArgs();
        touchUpArgs.position = position;
        chart.onChartTouchInteractionUp(touchUpArgs);
      }
    }
    if (chart.tooltipBehavior.enable && chart.tooltipBehavior.activationMode == ActivationMode.singleTap) {
      chart.tooltipBehavior._isInteraction = true;
      if (chart.tooltipBehavior.builder != null) {
        chart.tooltipBehavior._showTemplateTooltip(position);
      } else {
        chart.tooltipBehavior.onTouchUp(position.dx, position.dy);
      }
    }
  }

  /// To perform the pointer signal event
  void _performPointerSignal(PointerScrollEvent event) {
    _mousePointerDetails = event.position;
    if (_mousePointerDetails != null) {
      final Offset position = renderBox.globalToLocal(event.position);
      if (chart.zoomPanBehavior.enableMouseWheelZooming && chart._chartAxis._axisClipRect.contains(position)) {
        chart.zoomPanBehavior._performMouseWheelZooming(event, position.dx, position.dy);
      }
    }
  }

  /// To calculate the arguments of pinch zooming event
  void _calculatePinchZoomingArgs() {
    ZoomPanArgs zoomEndArgs, zoomResetArgs;
    bool resetFlag = false;
    int axisIndex;
    for (axisIndex = 0; axisIndex < chart._chartAxis._axisCollections.length; axisIndex++) {
      final ChartAxis axis = chart._chartAxis._axisCollections[axisIndex];
      if (chart.onZoomEnd != null) {
        zoomEndArgs = _zoomEvent(chart, axis, zoomEndArgs, chart.onZoomEnd);
        axis._zoomFactor = zoomEndArgs.currentZoomFactor;
        axis._zoomPosition = zoomEndArgs.currentZoomPosition;
      }
      if (axis._zoomFactor.toInt() == 1 && axis._zoomPosition.toInt() == 0 && chart.onZoomReset != null) {
        resetFlag = true;
      }
      chart._chartState.zoomAxes = <_ZoomAxisRange>[];
      chart.zoomPanBehavior.onPinchEnd(
          axis,
          chart._chartState._touchMovePositions[0].position.dx,
          chart._chartState._touchMovePositions[0].position.dy,
          chart._chartState._touchMovePositions[1].position.dx,
          chart._chartState._touchMovePositions[1].position.dy,
          axis._zoomFactor);
    }
    if (resetFlag) {
      for (int index = 0; index < chart._chartAxis._axisCollections.length; index++) {
        final dynamic axis = chart._chartAxis._axisCollections[index];
        _zoomEvent(chart, axis, zoomResetArgs, chart.onZoomReset);
      }
    }
  }

  /// To perform long press move update
  void _performLongPressMoveUpdate(LongPressMoveUpdateDetails details) {
    final Offset position = renderBox.globalToLocal(details.globalPosition);
    if (chart.zoomPanBehavior._isPinching != true) {
      if (chart.zoomPanBehavior.enableSelectionZooming && position != null && _zoomStartPosition != null) {
        chart.zoomPanBehavior._canPerformSelection = true;
        chart.zoomPanBehavior
            .onDrawSelectionZoomRect(position.dx, position.dy, _zoomStartPosition.dx, _zoomStartPosition.dy);
      }
    }
    if (chart.trackballBehavior != null &&
        chart.trackballBehavior.enable &&
        chart._chartState != null &&
        chart.trackballBehavior.activationMode != ActivationMode.doubleTap &&
        position != null) {
      if (chart.trackballBehavior.activationMode == ActivationMode.singleTap) {
        chart.trackballBehavior.onTouchMove(position.dx, position.dy);
      } else if (chart.trackballBehavior.activationMode == ActivationMode.longPress &&
          chart.trackballBehavior._isLongPressActivated) {
        chart.trackballBehavior.onTouchMove(position.dx, position.dy);
      }
    }
    if (chart.crosshairBehavior != null &&
        chart.crosshairBehavior.enable &&
        chart.crosshairBehavior.activationMode != ActivationMode.doubleTap &&
        position != null) {
      if (chart.crosshairBehavior.activationMode == ActivationMode.singleTap) {
        chart.crosshairBehavior.onTouchMove(position.dx, position.dy);
      } else if ((chart.crosshairBehavior != null &&
              chart.crosshairBehavior.activationMode == ActivationMode.longPress &&
              chart.crosshairBehavior._isLongPressActivated) &&
          !chart.zoomPanBehavior.enableSelectionZooming) {
        chart.crosshairBehavior.onTouchMove(position.dx, position.dy);
      }
    }
  }

  /// Method to perform long press end
  void _performLongPressEnd() {
    if (chart.zoomPanBehavior._isPinching != true) {
      chart.zoomPanBehavior._canPerformSelection = false;
      if (chart.zoomPanBehavior.enableSelectionZooming && chart.zoomPanBehavior._zoomingRect.width != 0) {
        chart.zoomPanBehavior._doSelectionZooming(chart.zoomPanBehavior._zoomingRect);
        if (chart.zoomPanBehavior._canPerformSelection != true) {
          chart.zoomPanBehavior._zoomingRect = const Rect.fromLTRB(0, 0, 0, 0);
        }
      }
    }
  }

  /// Method to perform pan down
  void _performPanDown(DragDownDetails details) {
    if (chart.zoomPanBehavior._isPinching != true) {
      _zoomStartPosition = renderBox.globalToLocal(details.globalPosition);
      if (chart.zoomPanBehavior.enablePanning == true) {
        chart.zoomPanBehavior._isPanning = true;
        chart.zoomPanBehavior._previousMovedPosition = null;
      }
    }
  }

  /// Method to perform long press on chart
  void _performLongPress() {
    Offset position;
    if (_tapDownDetails != null) {
      position = renderBox.globalToLocal(_tapDownDetails);
      if (chart.tooltipBehavior.enable && chart.tooltipBehavior.activationMode == ActivationMode.longPress) {
        chart.tooltipBehavior._isInteraction = true;
        if (chart.tooltipBehavior.builder != null) {
          chart.tooltipBehavior._showTemplateTooltip(position);
        } else {
          chart.tooltipBehavior.onLongPress(position.dx, position.dy);
        }
      }
    }
    if (chart._chartSeries.visibleSeriesRenderers != null && chart.selectionGesture == ActivationMode.longPress) {
      final CartesianSeriesRenderer selectionSeriesRenderer = _findSeries(position);
      selectionSeriesRenderer._series.selectionSettings._selectionRenderer.seriesRenderer = selectionSeriesRenderer;
      selectionSeriesRenderer._series.selectionSettings.onLongPress(position.dx, position.dy);
    }

    if ((chart.trackballBehavior != null &&
            chart.trackballBehavior.enable == true &&
            chart.trackballBehavior.activationMode == ActivationMode.longPress) &&
        chart.zoomPanBehavior._isPinching != true) {
      chart.trackballBehavior._isLongPressActivated = true;
      chart.trackballBehavior.onTouchDown(position.dx, position.dy);
    }
    if ((chart.crosshairBehavior != null &&
            chart.crosshairBehavior.enable == true &&
            chart.crosshairBehavior.activationMode == ActivationMode.longPress) &&
        !chart.zoomPanBehavior.enableSelectionZooming &&
        chart.zoomPanBehavior._isPinching != true &&
        position != null) {
      chart.crosshairBehavior._isLongPressActivated = true;
      chart.crosshairBehavior.onTouchDown(position.dx, position.dy);
    }
  }

  /// Method for double tap
  void _performDoubleTap() {
    if (_tapDownDetails != null) {
      final Offset position = renderBox.globalToLocal(_tapDownDetails);
      if (chart.trackballBehavior != null &&
          chart.trackballBehavior.enable &&
          chart.trackballBehavior.activationMode == ActivationMode.doubleTap) {
        chart.trackballBehavior.onDoubleTap(position.dx, position.dy);
        chart._chartState._enableDoubleTap = true;
        chart.trackballBehavior.onTouchUp(position.dx, position.dy);
        chart._chartState._enableDoubleTap = false;
      }
      if (chart.crosshairBehavior != null &&
          chart.crosshairBehavior.enable &&
          chart.crosshairBehavior.activationMode == ActivationMode.doubleTap) {
        chart.crosshairBehavior.onDoubleTap(position.dx, position.dy);
        chart._chartState._enableDoubleTap = true;
        chart.crosshairBehavior.onTouchUp(position.dx, position.dy);
        chart._chartState._enableDoubleTap = false;
      }
      if (chart.tooltipBehavior.enable && chart.tooltipBehavior.activationMode == ActivationMode.doubleTap) {
        chart.tooltipBehavior._isInteraction = true;
        if (chart.tooltipBehavior.builder != null) {
          chart.tooltipBehavior._showTemplateTooltip(position);
        } else {
          chart.tooltipBehavior.onDoubleTap(position.dx, position.dy);
        }
      }
      if (chart._chartSeries.visibleSeriesRenderers != null && chart.selectionGesture == ActivationMode.doubleTap) {
        final CartesianSeriesRenderer selectionSeriesRenderer = _findSeries(position);
        selectionSeriesRenderer._series.selectionSettings._selectionRenderer.seriesRenderer = selectionSeriesRenderer;
        selectionSeriesRenderer._series.selectionSettings.onDoubleTap(position.dx, position.dy);
      }
    }

    if (chart.zoomPanBehavior.enableDoubleTapZooming == true) {
      final Offset doubleTapPosition = _touchPosition;
      final Offset position = doubleTapPosition;
      if (position != null)
        chart.zoomPanBehavior.onDoubleTap(position.dx, position.dy, chart.zoomPanBehavior._zoomFactor);
    }
  }

  /// Update the details for pan
  void _performPanUpdate(DragUpdateDetails details) {
    Offset position;
    if (chart.zoomPanBehavior._isPinching != true) {
      position = renderBox.globalToLocal(details.globalPosition);
      if (chart.zoomPanBehavior._isPanning == true &&
          chart.zoomPanBehavior.enablePanning &&
          chart.zoomPanBehavior._previousMovedPosition != null) {
        chart.zoomPanBehavior.onPan(position.dx, position.dy);
      }
      chart.zoomPanBehavior._previousMovedPosition = position;
    }
    final bool panInProgress =
        chart.zoomPanBehavior.enablePanning && chart.zoomPanBehavior._previousMovedPosition != null;
    if (chart.trackballBehavior != null &&
        chart.trackballBehavior.enable &&
        position != null &&
        !panInProgress &&
        chart.trackballBehavior.activationMode != ActivationMode.doubleTap) {
      if (chart.trackballBehavior.activationMode == ActivationMode.singleTap) {
        chart.trackballBehavior.onTouchMove(position.dx, position.dy);
      } else if (chart.trackballBehavior != null &&
          chart.trackballBehavior.activationMode == ActivationMode.longPress &&
          chart.trackballBehavior._isLongPressActivated == true) {
        chart.trackballBehavior.onTouchMove(position.dx, position.dy);
      }
    }
    if (chart.crosshairBehavior != null &&
        chart.crosshairBehavior.enable &&
        chart.crosshairBehavior.activationMode != ActivationMode.doubleTap &&
        position != null &&
        !panInProgress) {
      if (chart.crosshairBehavior.activationMode == ActivationMode.singleTap) {
        chart.crosshairBehavior.onTouchMove(position.dx, position.dy);
      } else if (chart.crosshairBehavior != null &&
          chart.crosshairBehavior.activationMode == ActivationMode.longPress &&
          chart.crosshairBehavior._isLongPressActivated) {
        chart.crosshairBehavior.onTouchMove(position.dx, position.dy);
      }
    }
  }

  /// Method for the pan end event
  void _performPanEnd(DragEndDetails details) {
    if (chart.zoomPanBehavior._isPinching != true) {
      chart.zoomPanBehavior._isPanning = false;
      chart.zoomPanBehavior._previousMovedPosition = null;
    }
    if (chart.trackballBehavior.enable &&
        !chart.trackballBehavior.shouldAlwaysShow &&
        chart.trackballBehavior.activationMode != ActivationMode.doubleTap &&
        _touchPosition != null) {
      chart.trackballBehavior.onTouchUp(_touchPosition.dx, _touchPosition.dy);
      chart.trackballBehavior._isLongPressActivated = false;
    }
    if (chart.crosshairBehavior.enable &&
        !chart.crosshairBehavior.shouldAlwaysShow &&
        chart.crosshairBehavior.activationMode != ActivationMode.doubleTap) {
      chart.crosshairBehavior.onTouchUp(_touchPosition?.dx, _touchPosition?.dy);
    }
  }

  /// To perform mouse hover event
  void _performMouseHover(PointerEvent event) {
    chart.tooltipBehavior._isHovering = true;
    chart.tooltipBehavior._isInteraction = true;
    final Offset position = renderBox.globalToLocal(event.position);
    if (chart.tooltipBehavior.enable) {
      if (chart.tooltipBehavior.builder != null) {
        chart.tooltipBehavior._showTemplateTooltip(position);
      } else {
        chart.tooltipBehavior.onEnter(position.dx, position.dy);
      }
    }
    if (chart.trackballBehavior.enable) {
      chart.trackballBehavior.onEnter(position.dx, position.dy);
    }
    if (chart.crosshairBehavior.enable) {
      chart.crosshairBehavior.onEnter(position.dx, position.dy);
    }
  }

  /// To perform the mouse exit event
  void _performMouseExit(PointerEvent event) {
    chart.tooltipBehavior._isHovering = false;
    final Offset position = renderBox.globalToLocal(event.position);
    if (chart.tooltipBehavior.enable) {
      chart.tooltipBehavior.onExit(position.dx, position.dy);
    }
    if (chart.crosshairBehavior.enable) {
      chart.crosshairBehavior.onExit(position.dx, position.dy);
    }
    if (chart.trackballBehavior.enable) {
      chart.trackballBehavior.onExit(position.dx, position.dy);
    }
  }

  /// To bind the interaction widgets
  void _bindInteractionWidgets(BoxConstraints constraints, BuildContext context) {
    final RenderBox renderBox = context.findRenderObject();
    _TrackballPainter trackballPainter;
    _CrosshairPainter crosshairPainter;
    final _ZoomRectPainter zoomRectPainter = _ZoomRectPainter(chart: chart);
    chart.zoomPanBehavior._painter = zoomRectPainter;

    if (chart.trackballBehavior != null && chart.trackballBehavior.enable) {
      trackballPainter = _TrackballPainter(chart: chart, valueNotifier: chart._chartState.trackballRepaintNotifier);
      chart.trackballBehavior._trackballPainter = trackballPainter;
      _chartWidgets.add(Container(
          height: constraints.maxHeight,
          width: constraints.maxWidth,
          decoration: const BoxDecoration(color: Colors.transparent),
          child: CustomPaint(painter: trackballPainter)));
    }
    if (chart.crosshairBehavior != null && chart.crosshairBehavior.enable) {
      crosshairPainter = _CrosshairPainter(chart: chart, valueNotifier: chart._chartState.crosshairRepaintNotifier);
      chart.crosshairBehavior._crosshairPainter = crosshairPainter;
      _chartWidgets.add(Container(
          height: constraints.maxHeight,
          width: constraints.maxWidth,
          decoration: const BoxDecoration(color: Colors.transparent),
          child: CustomPaint(painter: crosshairPainter)));
    }
    _chartWidgets.add(_getListener(renderBox, constraints));
    if (chart.tooltipBehavior.enable) {
      chart.tooltipBehavior._chart = chart;
      if (chart.tooltipBehavior.builder != null) {
        chart.tooltipBehavior._tooltipTemplate = _TooltipTemplate(
            show: false, clipRect: chart._chartAxis._axisClipRect, duration: chart.tooltipBehavior.duration);
        _chartWidgets.add(chart.tooltipBehavior._tooltipTemplate);
      } else {
        chart.tooltipBehavior._chartTooltip = _ChartTooltipRenderer(
            chartWidget: chart, customValueStringFunction: chart.tooltipBehavior.customValueStringBuilder,
            customHeaderStringBuilder: chart.tooltipBehavior.customHeaderStringBuilder
        );
        _chartWidgets.add(chart.tooltipBehavior._chartTooltip);
      }
    }
  }

  /// Listener method for all events
  Widget _getListener(RenderBox renderBox, BoxConstraints constraints) {
    return Listener(
        onPointerDown: (PointerDownEvent event) {
          _performPointerDown(event);
          ChartTouchInteractionArgs touchArgs;
          if (chart.onChartTouchInteractionDown != null) {
            touchArgs = ChartTouchInteractionArgs();
            touchArgs.position = renderBox.globalToLocal(event.position);
            chart.onChartTouchInteractionDown(touchArgs);
          }
        },
        onPointerMove: (PointerMoveEvent event) {
          _performPointerMove(event);
          ChartTouchInteractionArgs touchArgs;
          if (chart.onChartTouchInteractionMove != null) {
            touchArgs = ChartTouchInteractionArgs();
            touchArgs.position = renderBox.globalToLocal(event.position);
            chart.onChartTouchInteractionMove(touchArgs);
          }
        },
        onPointerUp: (PointerUpEvent event) {
          _performPointerUp(event);
          ChartTouchInteractionArgs touchArgs;
          if (chart.onChartTouchInteractionUp != null) {
            touchArgs = ChartTouchInteractionArgs();
            touchArgs.position = renderBox.globalToLocal(event.position);
            chart.onChartTouchInteractionUp(touchArgs);
          }
        },
        onPointerSignal: (PointerSignalEvent event) {
          if (event is PointerScrollEvent) {
            _performPointerSignal(event);
          }
        },
        child: GestureDetector(
            onTapDown: (TapDownDetails details) {
              final Offset position = renderBox.globalToLocal(details.globalPosition);
              _touchPosition = position;
            },
            onTapUp: (TapUpDetails details) {
              final Offset position = renderBox.globalToLocal(details.globalPosition);
              if (chart.onPointTapped != null) {
                _calculatePointSeriesIndex(chart, position);
              }
              if (chart.onAxisLabelTapped != null) {
                _triggerAxisLabelEvent(position);
              }
            },
            onDoubleTap: () {
              _performDoubleTap();
            },
            onLongPressMoveUpdate: (LongPressMoveUpdateDetails details) {
              _performLongPressMoveUpdate(details);
            },
            onLongPress: () {
              _performLongPress();
            },
            onLongPressEnd: (LongPressEndDetails details) {
              _performLongPressEnd();
            },
            onPanUpdate: (DragUpdateDetails details) {
              _performPanUpdate(details);
            },
            onPanEnd: (DragEndDetails details) {
              _performPanEnd(details);
            },
            onPanDown: (DragDownDetails details) {
              _performPanDown(details);
            },
            child: Container(
                height: constraints.maxHeight,
                width: constraints.maxWidth,
                decoration: const BoxDecoration(color: Colors.transparent))));
  }

  /// Find point index for selection
  void _calculatePointSeriesIndex(SfCartesianChart chart, Offset position) {
    for (int i = 0; i < chart._chartSeries.visibleSeriesRenderers.length; i++) {
      final CartesianSeriesRenderer seriesRenderer = chart._chartSeries.visibleSeriesRenderers[i];
      final String _seriesType = seriesRenderer._seriesType;
      num pointIndex;
      int count = 0;
      final double padding = (_seriesType == 'bubble') ||
              (_seriesType == 'scatter') ||
              (_seriesType == 'bar') ||
              (_seriesType == 'column' ||
                  _seriesType == 'rangecolumn' ||
                  _seriesType.contains('stackedcolumn') ||
                  _seriesType.contains('stackedbar'))
          ? 0
          : 15;

      /// regional padding to detect smooth touch
      seriesRenderer._regionalData.forEach((dynamic regionRect, dynamic values) {
        final Rect region = regionRect[0];
        final double left = region.left - padding;
        final double right = region.right + padding;
        final double top = region.top - padding;
        final double bottom = region.bottom + padding;
        final Rect paddedRegion = Rect.fromLTRB(left, top, right, bottom);
        if (paddedRegion.contains(position)) {
          pointIndex = count;
        }
        count++;
      });

      if (pointIndex != null) {
        PointTapArgs pointTapArgs;
        pointTapArgs = PointTapArgs();
        pointTapArgs.pointIndex = pointIndex;
        pointTapArgs.seriesIndex = i;
        pointTapArgs.dataPoints = seriesRenderer._dataPoints;
        chart.onPointTapped(pointTapArgs);
      }
    }
  }

  /// Triggering onAxisLabelTapped event
  void _triggerAxisLabelEvent(Offset position) {
    for (int i = 0; i < chart._chartAxis._axisCollections.length; i++) {
      final List<AxisLabel> labels = chart._chartAxis._axisCollections[i]._visibleLabels;
      for (int k = 0; k < labels.length; k++) {
        if (chart._chartAxis._axisCollections[i].isVisible && labels[k]._labelRegion.contains(position)) {
          AxisLabelTapArgs labelArgs;
          labelArgs = AxisLabelTapArgs();
          labelArgs.text = labels[k].text;
          labelArgs.axis = chart._chartAxis._axisCollections[i];
          labelArgs.axisName = chart._chartAxis._axisCollections[i]._name;
          labelArgs.value = labels[k].value;
          chart.onAxisLabelTapped(labelArgs);
        }
      }
    }
  }

  /// Getter method of the series painter
  CustomPainter _getSeriesPainter(int value, AnimationController controller, Animation<double> seriesAnimation,
      Animation<double> chartElementAnimation, CartesianSeriesRenderer seriesRenderer) {
    CustomPainter customPainter;
    seriesRenderer._repaintNotifier = chart._chartState.seriesRepaintNotifier;
    final _PainterKey painterKey = _PainterKey(index: value, name: 'series $value', isRenderCompleted: false);
    chart._chartState.painterKeys.add(painterKey);
    switch (seriesRenderer._seriesType) {
      case 'line':
        customPainter = _LineChartPainter(
            chart: chart,
            seriesRenderer: seriesRenderer,
            isRepaint: chart._chartState.zoomedState != null
                ? chart._chartState.zoomedAxisStates.isNotEmpty
                : (chart._chartState._legendToggling ? true : seriesRenderer._needsRepaint),
            painterKey: painterKey,
            animationController: controller,
            seriesAnimation: seriesAnimation,
            chartElementAnimation: chartElementAnimation,
            notifier: chart._chartState.seriesRepaintNotifier);
        break;
      case 'spline':
        customPainter = _SplineChartPainter(
            chart: chart,
            seriesRenderer: seriesRenderer,
            painterKey: painterKey,
            isRepaint: chart._chartState.zoomedState != null
                ? chart._chartState.zoomedAxisStates.isNotEmpty
                : (chart._chartState._legendToggling ? true : seriesRenderer._needsRepaint),
            animationController: controller,
            seriesAnimation: seriesAnimation,
            chartElementAnimation: chartElementAnimation,
            notifier: chart._chartState.seriesRepaintNotifier);
        break;
      case 'column':
        customPainter = _ColumnChartPainter(
            chart: chart,
            seriesRenderer: seriesRenderer,
            isRepaint: chart._chartState.zoomedState != null ? chart._chartState.zoomedAxisStates.isNotEmpty : true,
            painterKey: painterKey,
            animationController: controller,
            seriesAnimation: seriesAnimation,
            chartElementAnimation: chartElementAnimation,
            notifier: chart._chartState.seriesRepaintNotifier);
        break;
      case 'scatter':
        customPainter = _ScatterChartPainter(
            chart: chart,
            seriesRenderer: seriesRenderer,
            isRepaint: chart._chartState.zoomedState != null
                ? chart._chartState.zoomedAxisStates.isNotEmpty
                : (chart._chartState._legendToggling ? true : seriesRenderer._needsRepaint),
            painterKey: painterKey,
            animationController: controller,
            seriesAnimation: seriesAnimation,
            chartElementAnimation: chartElementAnimation,
            notifier: chart._chartState.seriesRepaintNotifier);
        break;
      case 'stepline':
        customPainter = _StepLineChartPainter(
            chart: chart,
            seriesRenderer: seriesRenderer,
            painterKey: painterKey,
            isRepaint: chart._chartState.zoomedState != null
                ? chart._chartState.zoomedAxisStates.isNotEmpty
                : (chart._chartState._legendToggling ? true : seriesRenderer._needsRepaint),
            animationController: controller,
            seriesAnimation: seriesAnimation,
            chartElementAnimation: chartElementAnimation,
            notifier: chart._chartState.seriesRepaintNotifier);
        break;
      case 'area':
        customPainter = _AreaChartPainter(
            chart: chart,
            seriesRenderer: seriesRenderer,
            isRepaint: chart._chartState.zoomedState != null
                ? chart._chartState.zoomedAxisStates.isNotEmpty
                : (chart._chartState._legendToggling ? true : seriesRenderer._needsRepaint),
            painterKey: painterKey,
            animationController: controller,
            seriesAnimation: seriesAnimation,
            chartElementAnimation: chartElementAnimation,
            notifier: chart._chartState.seriesRepaintNotifier);
        break;
      case 'bubble':
        customPainter = _BubbleChartPainter(
            chart: chart,
            seriesRenderer: seriesRenderer,
            isRepaint: chart._chartState.zoomedState != null
                ? chart._chartState.zoomedAxisStates.isNotEmpty
                : (chart._chartState._legendToggling ? true : seriesRenderer._needsRepaint),
            painterKey: painterKey,
            animationController: controller,
            seriesAnimation: seriesAnimation,
            chartElementAnimation: chartElementAnimation,
            notifier: chart._chartState.seriesRepaintNotifier);
        break;
      case 'bar':
        customPainter = _BarChartPainter(
            chart: chart,
            seriesRenderer: seriesRenderer,
            isRepaint: chart._chartState.zoomedState != null ? chart._chartState.zoomedAxisStates.isNotEmpty : true,
            painterKey: painterKey,
            animationController: controller,
            seriesAnimation: seriesAnimation,
            chartElementAnimation: chartElementAnimation,
            notifier: chart._chartState.seriesRepaintNotifier);
        break;
      case 'fastline':
        customPainter = _FastLineChartPainter(
            chart: chart,
            seriesRenderer: seriesRenderer,
            isRepaint: chart._chartState.zoomedState != null
                ? chart._chartState.zoomedAxisStates.isNotEmpty
                : (chart._chartState._legendToggling ? true : seriesRenderer._needsRepaint),
            painterKey: painterKey,
            animationController: controller,
            seriesAnimation: seriesAnimation,
            chartElementAnimation: chartElementAnimation,
            notifier: chart._chartState.seriesRepaintNotifier);
        break;
      case 'rangecolumn':
        customPainter = _RangeColumnChartPainter(
            chart: chart,
            seriesRenderer: seriesRenderer,
            painterKey: painterKey,
            isRepaint: chart._chartState.zoomedState != null
                ? chart._chartState.zoomedAxisStates.isNotEmpty
                : (chart._chartState._legendToggling ? true : seriesRenderer._needsRepaint),
            animationController: controller,
            seriesAnimation: seriesAnimation,
            chartElementAnimation: chartElementAnimation,
            notifier: chart._chartState.seriesRepaintNotifier);
        break;
      case 'rangearea':
        customPainter = _RangeAreaChartPainter(
            chart: chart,
            seriesRenderer: seriesRenderer,
            painterKey: painterKey,
            isRepaint: chart._chartState.zoomedState != null
                ? chart._chartState.zoomedAxisStates.isNotEmpty
                : (chart._chartState._legendToggling ? true : seriesRenderer._needsRepaint),
            animationController: controller,
            seriesAnimation: seriesAnimation,
            chartElementAnimation: chartElementAnimation,
            notifier: chart._chartState.seriesRepaintNotifier);
        break;
      case 'steparea':
        customPainter = _StepAreaChartPainter(
            chart: chart,
            seriesRenderer: seriesRenderer,
            painterKey: painterKey,
            isRepaint: chart._chartState.zoomedState != null
                ? chart._chartState.zoomedAxisStates.isNotEmpty
                : (chart._chartState._legendToggling ? true : seriesRenderer._needsRepaint),
            animationController: controller,
            seriesAnimation: seriesAnimation,
            chartElementAnimation: chartElementAnimation,
            notifier: chart._chartState.seriesRepaintNotifier);
        break;
      case 'splinearea':
        customPainter = _SplineAreaChartPainter(
            chart: chart,
            seriesRenderer: seriesRenderer,
            painterKey: painterKey,
            isRepaint: chart._chartState.zoomedState != null
                ? chart._chartState.zoomedAxisStates.isNotEmpty
                : (chart._chartState._legendToggling ? true : seriesRenderer._needsRepaint),
            animationController: controller,
            seriesAnimation: seriesAnimation,
            chartElementAnimation: chartElementAnimation,
            notifier: chart._chartState.seriesRepaintNotifier);
        break;
      case 'splinerangearea':
        customPainter = _SplineRangeAreaChartPainter(
            chart: chart,
            seriesRenderer: seriesRenderer,
            painterKey: painterKey,
            isRepaint: chart._chartState.zoomedState != null
                ? chart._chartState.zoomedAxisStates.isNotEmpty
                : (chart._chartState._legendToggling ? true : seriesRenderer._needsRepaint),
            animationController: controller,
            seriesAnimation: seriesAnimation,
            chartElementAnimation: chartElementAnimation,
            notifier: chart._chartState.seriesRepaintNotifier);
        break;
      case 'stackedarea':
        customPainter = _StackedAreaChartPainter(
            chart: chart,
            seriesRenderer: seriesRenderer,
            painterKey: painterKey,
            isRepaint: chart._chartState.zoomedState != null
                ? chart._chartState.zoomedAxisStates.isNotEmpty
                : (chart._chartState._legendToggling ? true : seriesRenderer._needsRepaint),
            animationController: controller,
            seriesAnimation: seriesAnimation,
            chartElementAnimation: chartElementAnimation,
            notifier: chart._chartState.seriesRepaintNotifier);
        break;
      case 'stackedbar':
        customPainter = _StackedBarChartPainter(
            chart: chart,
            seriesRenderer: seriesRenderer,
            painterKey: painterKey,
            isRepaint: chart._chartState.zoomedState != null
                ? chart._chartState.zoomedAxisStates.isNotEmpty
                : (chart._chartState._legendToggling ? true : seriesRenderer._needsRepaint),
            animationController: controller,
            seriesAnimation: seriesAnimation,
            chartElementAnimation: chartElementAnimation,
            notifier: chart._chartState.seriesRepaintNotifier);
        break;
      case 'stackedcolumn':
        customPainter = _StackedColummnChartPainter(
            chart: chart,
            seriesRenderer: seriesRenderer,
            painterKey: painterKey,
            isRepaint: chart._chartState.zoomedState != null
                ? chart._chartState.zoomedAxisStates.isNotEmpty
                : (chart._chartState._legendToggling ? true : seriesRenderer._needsRepaint),
            animationController: controller,
            seriesAnimation: seriesAnimation,
            chartElementAnimation: chartElementAnimation,
            notifier: chart._chartState.seriesRepaintNotifier);
        break;
      case 'stackedline':
        customPainter = _StackedLineChartPainter(
            chart: chart,
            seriesRenderer: seriesRenderer,
            painterKey: painterKey,
            isRepaint: chart._chartState.zoomedState != null
                ? chart._chartState.zoomedAxisStates.isNotEmpty
                : (chart._chartState._legendToggling ? true : seriesRenderer._needsRepaint),
            animationController: controller,
            seriesAnimation: seriesAnimation,
            chartElementAnimation: chartElementAnimation,
            notifier: chart._chartState.seriesRepaintNotifier);
        break;
      case 'stackedarea100':
        customPainter = _StackedArea100ChartPainter(
            chart: chart,
            seriesRenderer: seriesRenderer,
            painterKey: painterKey,
            isRepaint: chart._chartState.zoomedState != null
                ? chart._chartState.zoomedAxisStates.isNotEmpty
                : (chart._chartState._legendToggling ? true : seriesRenderer._needsRepaint),
            animationController: controller,
            seriesAnimation: seriesAnimation,
            chartElementAnimation: chartElementAnimation,
            notifier: chart._chartState.seriesRepaintNotifier);
        break;
      case 'stackedbar100':
        customPainter = _StackedBar100ChartPainter(
            chart: chart,
            seriesRenderer: seriesRenderer,
            painterKey: painterKey,
            isRepaint: chart._chartState.zoomedState != null
                ? chart._chartState.zoomedAxisStates.isNotEmpty
                : (chart._chartState._legendToggling ? true : seriesRenderer._needsRepaint),
            animationController: controller,
            seriesAnimation: seriesAnimation,
            chartElementAnimation: chartElementAnimation,
            notifier: chart._chartState.seriesRepaintNotifier);
        break;
      case 'stackedcolumn100':
        customPainter = _StackedColumn100ChartPainter(
            chart: chart,
            seriesRenderer: seriesRenderer,
            painterKey: painterKey,
            isRepaint: chart._chartState.zoomedState != null
                ? chart._chartState.zoomedAxisStates.isNotEmpty
                : (chart._chartState._legendToggling ? true : seriesRenderer._needsRepaint),
            animationController: controller,
            seriesAnimation: seriesAnimation,
            chartElementAnimation: chartElementAnimation,
            notifier: chart._chartState.seriesRepaintNotifier);
        break;
      case 'stackedline100':
        customPainter = _StackedLine100ChartPainter(
            chart: chart,
            seriesRenderer: seriesRenderer,
            painterKey: painterKey,
            isRepaint: chart._chartState.zoomedState != null
                ? chart._chartState.zoomedAxisStates.isNotEmpty
                : (chart._chartState._legendToggling ? true : seriesRenderer._needsRepaint),
            animationController: controller,
            seriesAnimation: seriesAnimation,
            chartElementAnimation: chartElementAnimation,
            notifier: chart._chartState.seriesRepaintNotifier);
        break;
      case 'hilo':
        customPainter = _HiloPainter(
            chart: chart,
            seriesRenderer: seriesRenderer,
            painterKey: painterKey,
            isRepaint: chart._chartState.zoomedState != null
                ? chart._chartState.zoomedAxisStates.isNotEmpty
                : (chart._chartState._legendToggling ? true : seriesRenderer._needsRepaint),
            animationController: controller,
            seriesAnimation: seriesAnimation,
            chartElementAnimation: chartElementAnimation,
            notifier: chart._chartState.seriesRepaintNotifier);
        break;

      case 'hiloopenclose':
        customPainter = _HiloOpenClosePainter(
            chart: chart,
            seriesRenderer: seriesRenderer,
            painterKey: painterKey,
            isRepaint: chart._chartState.zoomedState != null
                ? chart._chartState.zoomedAxisStates.isNotEmpty
                : (chart._chartState._legendToggling ? true : seriesRenderer._needsRepaint),
            animationController: controller,
            seriesAnimation: seriesAnimation,
            chartElementAnimation: chartElementAnimation,
            notifier: chart._chartState.seriesRepaintNotifier);
        break;
      case 'candle':
        customPainter = _CandlePainter(
            chart: chart,
            seriesRenderer: seriesRenderer,
            painterKey: painterKey,
            isRepaint: chart._chartState.zoomedState != null
                ? chart._chartState.zoomedAxisStates.isNotEmpty
                : (chart._chartState._legendToggling ? true : seriesRenderer._needsRepaint),
            animationController: controller,
            seriesAnimation: seriesAnimation,
            chartElementAnimation: chartElementAnimation,
            notifier: chart._chartState.seriesRepaintNotifier);
        break;
      case 'histogram':
        customPainter = _HistogramChartPainter(
            chart: chart,
            seriesRenderer: seriesRenderer,
            painterKey: painterKey,
            isRepaint: chart._chartState.zoomedState != null
                ? chart._chartState.zoomedAxisStates.isNotEmpty
                : (chart._chartState._legendToggling ? true : seriesRenderer._needsRepaint),
            animationController: controller,
            seriesAnimation: seriesAnimation,
            chartElementAnimation: chartElementAnimation,
            notifier: chart._chartState.seriesRepaintNotifier);
        break;

      default:
        break;
    }
    return customPainter;
  }
}
