part of charts;

/// Creates the segments for HiloOpenClose series.
///
/// Generates the HiloOpenClose series points and has the [calculateSegmentPoints] method overrided to customize
/// the HiloOpenClose segment point calculation.
///
/// Gets the path and color from the [series].
class HiloOpenCloseSegment extends ChartSegment {
  num x,

      ///Low value.
      low,

      ///High value.
      high,

      ///Position of X.
      xPos,

      ///Postion of low.
      lowPos,

      ///Position of high.
      highPos,

      ///Center value of Y.
      centerY,

      ///High value of Y.
      highY,

      ///Center value of X.
      centerX,

      ///low value of X.
      lowX,

      ///High value of X.
      highX,

      ///Open value of X.
      openX,

      ///Open value of X.
      openY,

      ///Close value of Y.
      closeX,

      /// Close value of Y.
      closeY,

      /// High value of center.
      centerHigh,

      /// Low value of center.
      centerLow,

      /// Low value of Y.
      lowY,

      /// Start position.
      startPos,

      ///End position.
      endPos,

      ///Open value.
      open,

      ///Close value.
      close;

  ///Render path.
  Path path;

  Color _pointColorMapper;
  bool _isBull = false;
  CartesianChartPoint<dynamic> _currentPoint;
  _ChartLocation _centerLowPoint, _centerHighPoint, _lowPoint, _highPoint;
  bool _showSameValue, _isTransposed;
  HiloOpenCloseSegment _currentSegment, _oldSegment;
  HiloOpenCloseSeries<dynamic, dynamic> _hiloOpenCloseSeries;

  /// Gets the color of the series.
  @override
  Paint getFillPaint() {
    final Paint fillPaint = Paint();
    if (_color != null) {
      fillPaint.color = _pointColorMapper ?? _color.withOpacity(series.opacity);
    }
    fillPaint.strokeWidth = _strokeWidth;
    fillPaint.style = PaintingStyle.fill;
    _defaultFillColor = fillPaint;
    return fillPaint;
  }

  /// Gets the border color of the series.
  @override
  Paint getStrokePaint() {
    final Paint strokePaint = Paint();
    if (_strokeColor != null) {
      strokePaint.color = _currentPoint.isEmpty != null && _currentPoint.isEmpty
          ? series.emptyPointSettings.color
          : _pointColorMapper ?? _strokeColor;
      strokePaint.color =
          (series.opacity < 1 && strokePaint.color != Colors.transparent)
              ? strokePaint.color.withOpacity(series.opacity)
              : strokePaint.color;
    }
    strokePaint.strokeWidth = _strokeWidth;
    strokePaint.style = PaintingStyle.stroke;
    strokePaint.strokeCap = StrokeCap.round;
    _defaultStrokeColor = strokePaint;
    return strokePaint;
  }

  /// Calculates the rendering bounds of a segment.
  @override
  void calculateSegmentPoints() {
    _hiloOpenCloseSeries = series;
    _isTransposed = seriesRenderer._chart._requireInvertedAxis;
    _isBull = _currentPoint.open < _currentPoint.close;
    _lowPoint = _currentPoint.lowPoint;
    _highPoint = _currentPoint.highPoint;
    _centerLowPoint = _currentPoint.centerLowPoint;
    _centerHighPoint = _currentPoint.centerHighPoint;
    x = lowX = _lowPoint.x;
    low = _lowPoint.y;
    high = _highPoint.y;
    highX = _highPoint.x;
    centerHigh = _centerHighPoint.x;
    highY = _centerHighPoint.y;
    centerLow = _centerLowPoint.x;
    lowY = _centerLowPoint.y;
    openX = _currentPoint.openPoint.x;
    openY = _currentPoint.openPoint.y;
    closeX = _currentPoint.closePoint.x;
    closeY = _currentPoint.closePoint.y;

    _showSameValue = _hiloOpenCloseSeries.showIndicationForSameValues &&
        (!_isTransposed
            ? _centerHighPoint.y == _centerLowPoint.y
            : _centerHighPoint.x == _centerLowPoint.x);

    if (_showSameValue) {
      if (_isTransposed) {
        x = _lowPoint.x = _lowPoint.x - 2;
        _highPoint.x = _highPoint.x + 2;
        centerHigh = _centerHighPoint.x = _centerHighPoint.x + 2;
        centerLow = _centerLowPoint.x = _centerLowPoint.x - 2;
      } else {
        low = _lowPoint.y = _lowPoint.y - 2;
        high = _highPoint.y = _highPoint.y + 2;
        highY = _centerHighPoint.y = _centerHighPoint.y + 2;
        lowY = _centerLowPoint.y = _centerLowPoint.y - 2;
      }
    }
  }

  /// Draws the path between open and close values.
  void drawHiloOpenClosePath(Canvas canvas) {
    canvas.drawLine(
        Offset(centerHigh, highY), Offset(centerLow, lowY), strokePaint);
    canvas.drawLine(
        Offset(openX, openY),
        Offset(
            _isTransposed ? openX : centerHigh, _isTransposed ? highY : openY),
        strokePaint);
    canvas.drawLine(
        Offset(closeX, closeY),
        Offset(
            _isTransposed ? closeX : centerLow, _isTransposed ? highY : closeY),
        strokePaint);
  }

  Path drawDashedHiloOpenClosePath(Canvas canvas) {
    path.moveTo(centerHigh, highY);
    path.lineTo(centerLow, lowY);
    path.moveTo(openX, openY);
    path.lineTo(
        _isTransposed ? openX : centerHigh, _isTransposed ? highY : openY);
    path.moveTo(
        _isTransposed ? closeX : centerLow, _isTransposed ? highY : closeY);
    path.lineTo(closeX, closeY);
    return path;
  }

  /// Draws segment in series bounds.
  @override
  void onPaint(Canvas canvas) {
    if (series.selectionSettings.enable) {
      series.selectionSettings._selectionRenderer._checkWithSelectionState(
          seriesRenderer._segments[currentSegmentIndex], seriesRenderer._chart);
    }
    if (strokePaint != null) {
      path = Path();
      if (series.animationDuration > 0 &&
          !seriesRenderer._chart._chartState._isLegendToggled) {
        if (!seriesRenderer._chart._chartState.widgetNeedUpdate) {
          if (_isTransposed) {
            centerX = highX + ((lowX - highX) / 2);
            openX = centerX -
                ((centerX - _currentPoint.openPoint.x) * animationFactor);
            closeX = centerX +
                ((_currentPoint.closePoint.x - centerX) * animationFactor);
            highX = centerX + ((centerX - highX).abs() * animationFactor);
            lowX = centerX - ((lowX - centerX).abs() * animationFactor);
            canvas.drawLine(Offset(lowX, _centerLowPoint.y),
                Offset(highX, _centerHighPoint.y), strokePaint);
            canvas.drawLine(
                Offset(openX, openY), Offset(openX, highY), strokePaint);
            canvas.drawLine(
                Offset(closeX, lowY), Offset(closeX, closeY), strokePaint);
          } else {
            centerY = high + ((low - high) / 2);
            openY = centerY -
                ((centerY - _currentPoint.openPoint.y) * animationFactor);
            closeY = centerY +
                ((_currentPoint.closePoint.y - centerY) * animationFactor);
            highY = centerY - ((centerY - high) * animationFactor);
            lowY = centerY + ((low - centerY) * animationFactor);
            canvas.drawLine(Offset(centerHigh, highY), Offset(centerLow, lowY),
                strokePaint);
            canvas.drawLine(
                Offset(openX, openY), Offset(centerHigh, openY), strokePaint);
            canvas.drawLine(
                Offset(centerLow, closeY), Offset(closeX, closeY), strokePaint);
          }
        } else {
          _currentSegment = seriesRenderer._segments[currentSegmentIndex];
          _oldSegment = (_currentSegment._oldSeriesRenderer != null &&
                  _currentSegment._oldSeriesRenderer._segments.isNotEmpty &&
                  _currentSegment._oldSeriesRenderer._segments[0]
                      is HiloOpenCloseSegment &&
                  _currentSegment._oldSeriesRenderer._segments.length - 1 >=
                      currentSegmentIndex)
              ? _currentSegment
                  ._oldSeriesRenderer._segments[currentSegmentIndex]
              : null;
          _animateHiloOpenCloseSeries(
              _isTransposed,
              _isTransposed ? _lowPoint.x : low,
              _isTransposed ? _highPoint.x : high,
              _isTransposed
                  ? (_oldSegment != null ? _oldSegment._lowPoint.x : null)
                  : _oldSegment?.low,
              _isTransposed
                  ? (_oldSegment != null ? _oldSegment._highPoint.x : null)
                  : _oldSegment?.high,
              openX,
              openY,
              closeX,
              closeY,
              _isTransposed ? _centerLowPoint.y : centerLow,
              _isTransposed ? _centerHighPoint.y : centerHigh,
              _oldSegment?.openX,
              _oldSegment?.openY,
              _oldSegment?.closeX,
              _oldSegment?.closeY,
              _isTransposed
                  ? (_oldSegment != null ? _oldSegment._centerLowPoint.y : null)
                  : _oldSegment?.centerLow,
              _isTransposed
                  ? (_oldSegment != null
                      ? _oldSegment._centerHighPoint.y
                      : null)
                  : _oldSegment?.centerHigh,
              animationFactor,
              strokePaint,
              canvas,
              seriesRenderer);
        }
      } else {
        if (series.dashArray[0] != 0 && series.dashArray[1] != 0) {
          _drawDashedLine(canvas, series.dashArray, strokePaint,
              drawDashedHiloOpenClosePath(canvas));
        } else {
          drawHiloOpenClosePath(canvas);
        }
      }
    }
  }
}
