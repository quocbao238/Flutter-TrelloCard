part of charts;

/// Customizes the markers.
///
/// Markers are used to provide information about the exact point location. You can add a shape to adorn each data point.
/// Markers can be enabled by using the [isVisible] property of [MarkerSettings].
///
/// Provides the options of [color], border width, border color and [shape] of the marker to customize the appearance.
///
class MarkerSettings {
  MarkerSettings(
      {this.isVisible = false,
      this.height = 8,
      this.width = 8,
      this.color,
      this.shape = DataMarkerType.circle,
      this.borderWidth = 2,
      this.borderColor,
      this.image})
      : _color = color,
        _borderColor = borderColor,
        _borderWidth = borderWidth;

  ///Toggles the visibility of the marker.
  ///
  ///Defaults to `false`
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///            selectionGesture: ActivationMode.doubleTap,
  ///            series: <SplineSeries<SalesData, num>>[
  ///                SplineSeries<SalesData, num>(
  ///                  markerSettings: MarkerSettings(isVisible: true),
  ///                ),
  ///              ],
  ///        ));
  ///}
  ///```
  final bool isVisible;

  ///Height of the marker shape.
  ///
  ///Defaults to `4`
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///            selectionGesture: ActivationMode.doubleTap,
  ///            series: <SplineSeries<SalesData, num>>[
  ///                SplineSeries<SalesData, num>(
  ///                  markerSettings: MarkerSettings(
  ///                         isVisible: true, height: 10),
  ///                ),
  ///              ],
  ///        ));
  ///}
  ///```
  final double height;

  ///Width of the marker shape.
  ///
  ///Defaults to `4`
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///            selectionGesture: ActivationMode.doubleTap,
  ///            series: <SplineSeries<SalesData, num>>[
  ///                SplineSeries<SalesData, num>(
  ///                  markerSettings: MarkerSettings(
  ///                         isVisible: true, width: 10),
  ///                ),
  ///              ],
  ///        ));
  ///}
  ///```
  final double width;

  ///Color of the marker shape.
  ///
  ///Defaults to `null`
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///            selectionGesture: ActivationMode.doubleTap,
  ///            series: <SplineSeries<SalesData, num>>[
  ///                SplineSeries<SalesData, num>(
  ///                  markerSettings: MarkerSettings(
  ///                         isVisible: true, color: Colors.red),
  ///                ),
  ///              ],
  ///        ));
  ///}
  ///```
  final Color color;

  ///Shape of the marker.
  ///
  ///Defaults to `DataMarkerType.circle`.
  ///
  ///Also refer [DataMarkerType]
  ///
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///            selectionGesture: ActivationMode.doubleTap,
  ///            series: <SplineSeries<SalesData, num>>[
  ///                SplineSeries<SalesData, num>(
  ///                  markerSettings: MarkerSettings(
  ///                         isVisible: true, shape: DataMarkerType.diamond),
  ///                ),
  ///              ],
  ///        ));
  ///}
  ///```
  final DataMarkerType shape;

  ///Border color of the marker.
  ///
  ///Defaults to `null`
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///            selectionGesture: ActivationMode.doubleTap,
  ///            series: <SplineSeries<SalesData, num>>[
  ///                SplineSeries<SalesData, num>(
  ///                  markerSettings: MarkerSettings(
  ///                          isVisible: true,
  ///                          borderColor: Colors.red, borderWidth: 3),
  ///                ),
  ///              ],
  ///        ));
  ///}
  ///```
  final Color borderColor;

  ///Border width of the marker.
  ///
  ///Defaults to `2`
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///            selectionGesture: ActivationMode.doubleTap,
  ///            series: <SplineSeries<SalesData, num>>[
  ///                SplineSeries<SalesData, num>(
  ///                  markerSettings: MarkerSettings(
  ///                         isVisible: true,
  ///                         borderWidth: 2, borderColor: Colors.pink),
  ///                ),
  ///              ],
  ///        ));
  ///}
  ///```
  final double borderWidth;

  ///Image to be used as marker.
  ///
  ///Defaults to `null`
  ///```dart
  ///Widget build(BuildContext context) {
  ///    return Container(
  ///        child: SfCartesianChart(
  ///            selectionGesture: ActivationMode.doubleTap,
  ///            series: <SplineSeries<SalesData, num>>[
  ///                SplineSeries<SalesData, num>(
  ///                  markerSettings: MarkerSettings(
  ///                         isVisible: true, image: const AssetImage('images/bike.png'),
  ///                         shape: DataMarkerType.image),
  ///                ),
  ///              ],
  ///        ));
  ///}
  ///```
  final ImageProvider image;

  // ignore: prefer_final_fields
  Color _color;

  Color _borderColor;

  double _borderWidth;

  dart_ui.Image _image;

  /// To paint the marker here
  void renderMarker(
      CartesianSeriesRenderer seriesRenderer,
      CartesianChartPoint<dynamic> point,
      Animation<double> animationController,
      Canvas canvas,
      int markerIndex) {
    Paint strokePaint, fillPaint;
    final XyDataSeries<dynamic, dynamic> series = seriesRenderer._series;
    final Size size =
        Size(series.markerSettings.width, series.markerSettings.height);
    final DataMarkerType markerType = series.markerSettings.shape;
    CartesianChartPoint<dynamic> point;
    final bool hasPointColor = (series.pointColorMapper != null) ? true : false;
    final double opacity = (animationController != null &&
            (seriesRenderer._chart._chartState.initialRender ||
                seriesRenderer._needAnimateSeriesElements))
        ? animationController.value
        : 1;
    point = seriesRenderer._dataPoints[markerIndex];
    _borderColor =
        series.markerSettings.borderColor ?? seriesRenderer._seriesColor;
    series.markerSettings._color = series.markerSettings.color;
    _borderWidth = series.markerSettings.borderWidth;
    seriesRenderer._markerShapes.add(_getMarkerShapes(
        markerType,
        Offset(point.markerPoint.x, point.markerPoint.y),
        size,
        seriesRenderer,
        markerIndex));
    if (seriesRenderer._seriesType.contains('range') ||
        seriesRenderer._seriesType == 'hilo') {
      seriesRenderer._markerShapes2.add(_getMarkerShapes(
          markerType,
          Offset(point.markerPoint2.x, point.markerPoint2.y),
          size,
          seriesRenderer,
          markerIndex));
    }
    strokePaint = Paint()
      ..color = point.isEmpty == true
          ? (series.emptyPointSettings.borderWidth == 0
              ? Colors.transparent
              : series.emptyPointSettings.borderColor.withOpacity(opacity))
          : (series.markerSettings.borderWidth == 0
              ? Colors.transparent
              : ((hasPointColor && point.pointColorMapper != null)
                  ? point.pointColorMapper.withOpacity(opacity)
                  : _borderColor.withOpacity(opacity)))
      ..style = PaintingStyle.stroke
      ..strokeWidth = point.isEmpty == true
          ? series.emptyPointSettings.borderWidth
          : _borderWidth;

    if (series.gradient != null && series.markerSettings.borderColor == null) {
      strokePaint = _getLinearGradientPaint(
          series.gradient,
          _getMarkerShapes(
                  markerType,
                  Offset(point.markerPoint.x, point.markerPoint.y),
                  size,
                  seriesRenderer)
              .getBounds(),
          seriesRenderer._chart._requireInvertedAxis);
      strokePaint.style = PaintingStyle.stroke;
      strokePaint.strokeWidth = point.isEmpty == true
          ? series.emptyPointSettings.borderWidth
          : series.markerSettings.borderWidth;
    }

    fillPaint = Paint()
      ..color = point.isEmpty == true
          ? series.emptyPointSettings.color
          : series.markerSettings._color != Colors.transparent
              ? (series.markerSettings._color ??
                      (seriesRenderer
                                  ._chart._chartState._chartTheme.brightness ==
                              Brightness.light
                          ? Colors.white
                          : Colors.black))
                  .withOpacity(opacity)
              : series.markerSettings._color
      ..style = PaintingStyle.fill;
    final bool isScatter = seriesRenderer._seriesType == 'scatter';
    final Rect axisClipRect = seriesRenderer._chart._chartAxis._axisClipRect;

    /// Render marker points
    if ((series.markerSettings.isVisible || isScatter) &&
        point.isVisible &&
        withInRect(seriesRenderer, point.markerPoint, axisClipRect) &&
        point.markerPoint != null &&
        point.isGap != true &&
        (!isScatter || series.markerSettings.shape == DataMarkerType.image)) {
      seriesRenderer.drawDataMarker(markerIndex, canvas, fillPaint, strokePaint,
          point.markerPoint.x, point.markerPoint.y, seriesRenderer);
      if (series.markerSettings.shape == DataMarkerType.image) {
        _drawImageMarker(
            series, canvas, point.markerPoint.x, point.markerPoint.y);
        if (seriesRenderer._seriesType.contains('range') ||
            seriesRenderer._seriesType == 'hilo')
          _drawImageMarker(
              series, canvas, point.markerPoint2.x, point.markerPoint2.y);
      }
    }
  }

  bool withInRect(CartesianSeriesRenderer seriesRenderer,
      _ChartLocation markerPoint, Rect axisClipRect) {
    bool withInRect = false;
    final num markerPointX = markerPoint.x.roundToDouble();
    final num markerPointY = markerPoint.y.roundToDouble();
    withInRect = markerPointX >= axisClipRect.left.roundToDouble() &&
        markerPointX <= axisClipRect.right.roundToDouble() &&
        markerPointY <= axisClipRect.bottom.roundToDouble() &&
        markerPointY >= axisClipRect.top.roundToDouble();
    return withInRect;
  }

  /// Paint the image marker
  void _drawImageMarker(CartesianSeries<dynamic, dynamic> series, Canvas canvas,
      double pointX, double pointY) {
    if (series.markerSettings._image != null) {
      final double imageWidth = 2 * series.markerSettings.width;
      final double imageHeight = 2 * series.markerSettings.height;
      final Rect positionRect = Rect.fromLTWH(pointX - imageWidth / 2,
          pointY - imageHeight / 2, imageWidth, imageHeight);
      paintImage(
          canvas: canvas,
          rect: positionRect,
          image: series.markerSettings._image,
          fit: BoxFit.fill);
    }
  }
}
