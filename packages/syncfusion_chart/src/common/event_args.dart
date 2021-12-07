//Event Arguments
part of charts;

///Holds the arguments for the event onTooltipRender.
///
/// Event is triggered when the tooltip is rendered, which allows you to customize tooltip arguments.
class TooltipArgs {
  ///Tooltip text
  String text;

  /// Header text of tooltip
  String header;

  /// x location
  double locationX;

  /// y location
  double locationY;

  /// Index of current series
  dynamic seriesIndex;

  /// List of datapoints in the series
  List<dynamic> dataPoints;

  /// Index of the current point
  num pointIndex;
}

/// Holds the onActualRangeChanged event arguments.
///
/// ActualRangeChangedArgs is the type argument for onActualRangeChanged event. whenever the actual ranges is changed,onActualRangeChanged event is
/// triggered and provides options to set the actual minimum and maximum, visible minimum and maximum values.
///
/// It has the public properties of axis name, axis type, actual minimum, and maximum, visible minimum and maximum and axis orientation.
class ActualRangeChangedArgs {
  /// Specify the name of the axis.
  String axisName;

  /// Specify the axis type .
  ChartAxis axis;

  /// Specify the minimum actual range to an axis.
  dynamic actualMin;

  /// Specify the maximum actual range to an axis.
  dynamic actualMax;

  /// Specify the actual interval of an axis.
  dynamic actualInterval;

  /// Minimum visible range of the axis.
  dynamic visibleMin;

  /// Maximum visible range of the axis.
  dynamic visibleMax;

  /// Interval for the visible range of the axis.
  dynamic visibleInterval;

  /// Specifies the axis orientation.
  AxisOrientation orientation;
}

/// Holds the onAxisLabelRender event arguments.
///
/// AxisLabelRenderArgs is the type argument for onAxisLabelRender event. whenever the Axis gets rednered,onAxisLabelRender event is
/// triggered  and provides options to set the axis label text, axis name, label text style, orientation, and axis type.
///
///It has the public properties of axis label text, axis name, axis type, label text style, and orientation.

class AxisLabelRenderArgs {
  /// Text value of the axis label.
  String text;

  /// Value of the axis label.
  num value;

  /// Specifies the axis name.
  String axisName;

  /// Specifies the axis orientation.
  AxisOrientation orientation;

  /// Chart axis type and its property.
  ChartAxis axis;

  /// Text style of the axis label.
  TextStyle textStyle = const TextStyle(
      fontFamily: 'Roboto',
      fontStyle: FontStyle.normal,
      fontWeight: FontWeight.normal,
      fontSize: 12);
}

/// Holds the onDataLabelRender event arguments.
///
/// DataLabelRenderArgs is the type of Argument to the onDataLabelRender event, whenever the datalabel gets rendered, onDataLabelRender event is
/// triggered it provides options to customize the data label text, data label text style, series, data point, and current point index value.
///
/// It has the public properties of data label text, series, data points and Point index.
///
class DataLabelRenderArgs {
  /// Text value of the data label.
  String text;

  /// Style property of the data label text.
  TextStyle textStyle = const TextStyle(
      fontFamily: 'Roboto',
      fontStyle: FontStyle.normal,
      fontWeight: FontWeight.normal,
      fontSize: 12);

  /// Current series.
  dynamic seriesRenderer;

  /// Data points of the series.
  dynamic dataPoints;

  ///Current point index .
  num pointIndex;

  /// Color of datalabels
  Color color;
}

/// Holds the onLegendItemRender event arguments.
///
/// Triggers when the legend item is rendering.It can be customize the [text], [legendIconType],
/// [seriesIndex], [pointIndex] and [color].
///
/// _Note:_ [pointIndex] and [color] only applicable for [SfCircularChart].
class LegendRenderArgs {
  ///Legend text.
  String text;

  ///Specifies the shape of  legend.
  LegendIconType legendIconType;

  ///Current series index.
  int seriesIndex;

  ///Current point index.
  int pointIndex;

  ///Color of legend
  Color color;
}

///Holds the arguments for the event onTrendlineRender.
///
/// Event is triggered when the trend line is rendered, trendline arguments such as [opacity], [color] and
/// [dashArray] can be customized.
class TrendlineRenderArgs {
  /// Intercept value
  double intercept;

  ///Index of trendline
  int trendlineIndex;

  ///Index of series
  int seriesIndex;

  /// Name of the trendline
  String trendlineName;

  /// Name of the series
  String seriesName;

  ///Event color
  Color color;

  ///Opacity value
  double opacity;

  /// TrendlineRenderArgs dashArray
  List<double> dashArray;

  /// Data points of the Trendline.
  List<CartesianChartPoint<dynamic>> data;
}

///Holds arguments for TrackballPositionChanging event.
///
///The event is triggered when the trackball is rendered and the trackball arguments can be customized.
///Provides options to customise the label text.
class TrackballArgs {
  /// Chart point info
  _ChartPointInfo chartPointInfo = _ChartPointInfo();
}

/// Holds the onCrosshairPositionChanging event arguments.
///
/// CrosshairRenderArgs is the type of Argument to the onCrosshairPositionChanging event, whenever the crosshair position is changed,
/// onCrosshairPositionChanging event is triggered, provids options to customize the text, Line color, axis name, and orientation and value.
///
/// It has the public properties of text, Line color, axis name, and orientation and value.
///
class CrosshairRenderArgs {
  /// Specifies the type of chart axis and its property.
  ChartAxis axis;

  /// Specifies the crosshair text.
  String text;

  /// Specifies the color of the cross-hair.
  Color lineColor;

  /// Visible range value.
  dynamic value;

  /// Name of the axis.
  String axisName;

  /// Specifies the axis orientation.
  AxisOrientation orientation;
}

/// Holds the chart TouchUp event arguments.
///
/// ChartTouchInteractionArgs is used to store the touch point coordinates when the Touch event is triggered.
/// Detects the points or areas in the chart as the offset values of x and y.
///
class ChartTouchInteractionArgs {
  /// Position of the Touch interaction.
  Offset position;
}

/// Holds the zooming event arguments.
///
/// In this ZoomPanArg events will trigger onZooming, onZoomStart, onZoomEnd and onZoomReset.
/// It contains [axis], [currentZoomPosition], [currentZoomFactor], [previousZoomPosition]
/// and [previousZoomFactor] arguments.
///
/// _Note:_ This is only for [SfCartesianChart].
class ZoomPanArgs {
  ///Chart Axis types and property
  ChartAxis axis;

  /// Position of current zooom.
  double currentZoomPosition;

  /// Zoom factor for currrent position.
  double currentZoomFactor;

  /// Previous zooom position.
  double previousZoomPosition;

  /// Previous zoom factor.
  double previousZoomFactor;
}

/// Holds the onPointTapped event arguments.
///
/// The PointTapArgs is the argument type of onPointTapped event, whenever the [onPointTapped] is triggered it sets the series index,
/// current point index, and respective data point.
///
/// It has the public properties of the series index, point index, and data points.
///
class PointTapArgs {
  /// Series index value.
  int seriesIndex;

  /// Current point index.
  int pointIndex;

  /// Stores the list of data points.
  List<dynamic> dataPoints;
}

/// Holds the onAxisLabelTapped event arguments.
///
/// This is the argument type of onAxisLabelTapped event. Whenever the Axis lebel is tapped, onAxisLabelTapped event is
/// triggered and provides options to set the axis type, label text, and axis name.
///
/// It provides options for axis type, axis label text, and axis name.
class AxisLabelTapArgs {
  /// Specifies the type of chart axis and its property.
  ChartAxis axis;

  /// Text of the axis label at the tap position.
  String text;

  /// The value holds the properties of the visible label.
  num value;

  /// Specifies the axis name.
  String axisName;
}

/// Holds the onLegendTapped event arguments.
///
/// When the legend is tapped, the legendtapArgs event is triggered.
/// It contains [series], [seriesIndex], [pointIndex] that can be customized.
class LegendTapArgs {
  ///Specifies the current series.
  dynamic series;

  ///Specifies the current series index.
  int seriesIndex;

  ///Specifies the current point index.
  int pointIndex;
}

/// Holds the onSelectionChanged event arguments.
///
/// The selection arguments can be changed when the selection event is performed.
///
/// The selection arguments such as color, width can be customized.
class SelectionArgs {
  SelectionArgs(this.seriesRenderer, this.seriesIndex, this.pointIndex,
      this.overallDataPointIndex);

  ///Selected series
  final dynamic seriesRenderer;

  ///color of the selected series or data points
  Color selectedColor;

  ///color of unselected series or data points
  Color unselectedColor;

  ///border color of the selected series or data points
  Color selectedBorderColor;

  ///width of the selected series or data points
  double selectedBorderWidth;

  ///border color of the unselected series or data points
  Color unselectedBorderColor;

  /// width of the unselected series or data points
  double unselectedBorderWidth;

  /// series index of current series
  final int seriesIndex;

  /// point index of the points in the series
  final int pointIndex;

  /// data point index of points in the series
  final int overallDataPointIndex;
}

/// Holds the onIndicatorRender event arguments.
///
///Triggers when indicator is rendering. You can customize the
///[indicatorname], [signalLineColor], [signalLineWidth], linedashArray and so on.
///
/// _Note:_ This is only applicable for [SfCartesianChart].
class IndicatorRenderArgs {
  ///Specifies which incicator type to use.
  TechnicalIndicators<dynamic, dynamic> indicator;

  ///Used to change the indicator name.
  String indicatorname;

  /// current index
  int index;

  ///Used to change the color of the signal line.
  Color signalLineColor;

  ///Used to change the width of the signal line.
  double signalLineWidth;

  ///Used to change the dash array size.
  List<double> lineDashArray;

  ///Specifies the series name.
  String seriesName;

  ///Specifies the current datapoints.
  List<dynamic> dataPoints;
}

/// Holds the onMarkerRender event arguments.
///
/// MarkerRenderArgs is the argument type of onMarkerRender event. Whenever the onMarkerRender is triggered the point index,
/// series index shape of the marker, marker width, and height can be customized.
///
/// Has the public properties of point index, series index, shape, marker width, and height.
///
class MarkerRenderArgs {
  /// Point index of the marker.
  int pointIndex;

  /// Series index of the marker.
  int seriesIndex;

  /// Stores the Shape  of the marker.
  DataMarkerType shape;

  /// Stores the width of the marker.
  double markerWidth;

  /// Stores the height of the marker.
  double markerHeight;

  /// Stores the color of the marker.
  Color color;

  /// Stores the border color of the marker.
  Color borderColor;

  /// border width of marker
  double borderWidth;
}
