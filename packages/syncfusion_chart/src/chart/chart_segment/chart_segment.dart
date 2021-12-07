part of charts;

/// Creates the segments for chart series.
///
/// It has the public method and properties to customize the segment in the chart series, User can customize
/// the calculation of the segment points by using the method [calculateSegmentPoints]. It has the property to
/// store the old value of the series to support dynamic animation.
///
/// Provides the public properties color, stroke color, fill paint, stroke paint, series and old series to customize and dynamically
/// change each segment in the chart.
///
abstract class ChartSegment {
  ///Gets the color of the series
  Paint getFillPaint();

  ///Gets the border color of the series
  Paint getStrokePaint();

  ///Calculates the rendering bounds of a segment
  void calculateSegmentPoints();

  ///Draws segment in series bounds.
  void onPaint(Canvas canvas);

  ///Color of the segment
  Color _color;

  ///Border color of the segment
  Color _strokeColor;

  ///Border width of the segment
  double _strokeWidth;

  ///Fill paint of the segment
  Paint fillPaint;

  ///Stroke paint of the segment
  Paint strokePaint;

  ///Chart series
  XyDataSeries<dynamic, dynamic> series;

  ///Chart series
  XyDataSeries<dynamic, dynamic> _oldSeries;

  ///Chart series renderer
  CartesianSeriesRenderer seriesRenderer;

  CartesianSeriesRenderer _oldSeriesRenderer;

  ///Animation factor value
  double animationFactor;

  /// Rectangle of the segment
  RRect segmentRect;

  /// Dfault fill color
  Paint _defaultFillColor;

  /// Default stroke color
  Paint _defaultStrokeColor;

  /// current index value.
  int currentSegmentIndex, _seriesIndex;

  /// current point value.
  CartesianChartPoint<dynamic> _currentPoint;

  /// Chart point.
  CartesianChartPoint<dynamic> _point;

  /// Old chart point.
  CartesianChartPoint<dynamic> _oldPoint;

  /// Next point value.
  CartesianChartPoint<dynamic> _nextPoint;

  /// Old series visibility property.
  bool _oldSeriesVisible;

  /// Old  rect region.
  Rect _oldRegion;

  /// Cartesian chart properties
  SfCartesianChart _chart;
}
