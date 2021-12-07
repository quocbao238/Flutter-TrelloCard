part of charts;

/// Creates the segments for bubble series.
///
/// Generates the candle series points and has the [calculateSegmentPoints] override method
/// used to customize the candle series segment point calculation.
///
/// Gets the path and fill color from the [series] to render the candle segment.
///
class CandleSegment extends ChartSegment {
  /// X position.
  num x;

  /// Low value.
  num low;

  /// High value.
  num high;

  /// X position value.
  num xPos;

  /// Low position value.
  num lowPos;

  /// High position value.
  num highPos;

  /// Center Y value.
  num centerY;

  ///High value of Y.
  num highY;

  /// Open value of X.
  num openX;

  /// Open value of Y.
  num openY;

  /// Close value of X.
  num closeX;

  /// Close value of Y.
  num closeY;

  /// Center high value.
  num centerHigh;

  /// Center low value.
  num centerLow;

  /// Y value of low value.
  num lowY;

  /// Start position value.
  num startPos;

  /// End position value.
  num endPos;

  /// Open value.
  num open;

  /// Close value.
  num close;

  //Renders path.
  Path path, linePath;

  Color _pointColorMapper;
  bool _isBull = false;
  CartesianChartPoint<dynamic> _currentPoint;
  //ignore: prefer_final_fields
  bool _isSolid = false, _isTransposed;
  bool _showSameValue;
  _ChartLocation _lowPoint, _highPoint, _centerLowPoint, _centerHighPoint;

  num _centersY, _topRectY, _topLineY, _bottomRectY, _bottomLineY;

  CandleSeries<dynamic, dynamic> _candleSeries;

  /// Gets the color of the series.
  @override
  Paint getFillPaint() {
    fillPaint = Paint()
      ..color = _currentPoint.isEmpty != null && _currentPoint.isEmpty
          ? series.emptyPointSettings.color
          : (_currentPoint.pointColorMapper ?? _color);
    fillPaint.color =
        (series.opacity < 1 && fillPaint.color != Colors.transparent)
            ? fillPaint.color.withOpacity(series.opacity)
            : fillPaint.color;
    fillPaint.strokeWidth = _strokeWidth;
    fillPaint.style = _isSolid ? PaintingStyle.fill : PaintingStyle.stroke;
    _defaultFillColor = fillPaint;
    return fillPaint;
  }

  /// Gets the border color of the series.
  @override
  Paint getStrokePaint() {
    final Paint strokePaint = Paint();
    if (_strokeColor != null) {
      strokePaint.color = _pointColorMapper ?? _strokeColor;
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
    _candleSeries = series;
    _isBull = _currentPoint.open < _currentPoint.close;
    x = high = low = double.nan;
    _isTransposed = seriesRenderer._chart._requireInvertedAxis;
    _lowPoint = _currentPoint.lowPoint;
    _highPoint = _currentPoint.highPoint;
    _centerLowPoint = _currentPoint.centerLowPoint;
    _centerHighPoint = _currentPoint.centerHighPoint;
    x = _lowPoint.x;
    low = _lowPoint.y;
    high = _highPoint.y;
    centerHigh = _centerHighPoint.x;
    highY = _centerHighPoint.y;
    centerLow = _centerLowPoint.x;
    lowY = _centerLowPoint.y;
    openX = _currentPoint.openPoint.x;
    openY = _currentPoint.openPoint.y;
    closeX = _currentPoint.closePoint.x;
    closeY = _currentPoint.closePoint.y;

    _showSameValue = _candleSeries.showIndicationForSameValues &&
        (!seriesRenderer._chart._requireInvertedAxis
            ? _centerHighPoint.y == _centerLowPoint.y
            : _centerHighPoint.x == _centerLowPoint.x);

    x = _lowPoint.x =
        (_showSameValue && _isTransposed) ? _lowPoint.x - 2 : _lowPoint.x;
    _highPoint.x =
        (_showSameValue && _isTransposed) ? _highPoint.x + 2 : _highPoint.x;
    low = _lowPoint.y =
        (_showSameValue && !_isTransposed) ? _lowPoint.y - 2 : _lowPoint.y;
    high = _highPoint.y =
        (_showSameValue && !_isTransposed) ? _highPoint.y + 2 : _highPoint.y;
    centerHigh = _centerHighPoint.x = (_showSameValue && _isTransposed)
        ? _centerHighPoint.x + 2
        : _centerHighPoint.x;
    highY = _centerHighPoint.y = (_showSameValue && !_isTransposed)
        ? _centerHighPoint.y + 2
        : _centerHighPoint.y;
    centerLow = _centerLowPoint.x = (_showSameValue && _isTransposed)
        ? _centerLowPoint.x - 2
        : _centerLowPoint.x;
    lowY = _centerLowPoint.y = (_showSameValue && !_isTransposed)
        ? _centerLowPoint.y - 2
        : _centerLowPoint.y;
  }

  void drawRectPath() {
    path.moveTo(!_isTransposed ? openX : _topRectY,
        !_isTransposed ? _topRectY : closeY);
    path.lineTo(!_isTransposed ? closeX : _topRectY,
        !_isTransposed ? _topRectY : openY);
    path.lineTo(!_isTransposed ? closeX : _bottomRectY,
        !_isTransposed ? _bottomRectY : openY);
    path.lineTo(!_isTransposed ? openX : _bottomRectY,
        !_isTransposed ? _bottomRectY : closeY);
    path.lineTo(!_isTransposed ? openX : _topRectY,
        !_isTransposed ? _topRectY : closeY);
    path.close();
  }

  void drawLine(Canvas canvas) {
    canvas.drawLine(Offset(centerHigh, _topRectY),
        Offset(centerHigh, _topLineY), fillPaint);
    canvas.drawLine(Offset(centerHigh, _bottomRectY),
        Offset(centerHigh, _bottomLineY), fillPaint);
  }

  void drawFillLine(Canvas canvas) {
    final bool isOpen = _currentPoint.open > _currentPoint.close;
    canvas.drawLine(
        Offset(_topRectY, highY),
        Offset(
            _topRectY +
                ((isOpen ? (openX - centerHigh) : (closeX - centerHigh)).abs() *
                    animationFactor),
            highY),
        fillPaint);
    canvas.drawLine(
        Offset(_bottomRectY, highY),
        Offset(
            _bottomRectY -
                ((isOpen ? (closeX - centerLow) : (openX - centerLow)).abs() *
                    animationFactor),
            highY),
        fillPaint);
  }

  /// Draws segment in series bounds.
  @override
  void onPaint(Canvas canvas) {
    if (series.selectionSettings.enable) {
      series.selectionSettings._selectionRenderer._checkWithSelectionState(
          seriesRenderer._segments[currentSegmentIndex], seriesRenderer._chart);
    }
    if (fillPaint != null &&
        !(seriesRenderer._chart._chartState.widgetNeedUpdate &&
            !seriesRenderer._chart._chartState._isLegendToggled)) {
      path = Path();
      linePath = Path();
      if (!_isTransposed && _currentPoint.open > _currentPoint.close) {
        final num temp = closeY;
        closeY = openY;
        openY = temp;
      }

      if (seriesRenderer._chart._chartState._isLegendToggled) {
        animationFactor = 1;
      }
      _centersY = closeY + ((closeY - openY).abs() / 2);
      _topRectY = _centersY - ((_centersY - closeY).abs() * animationFactor);
      _topLineY = _topRectY - ((_topRectY - highY).abs() * animationFactor);
      _bottomRectY = _centersY + ((_centersY - openY).abs() * animationFactor);
      _bottomLineY =
          _bottomRectY + ((_bottomRectY - lowY).abs() * animationFactor);

      _bottomLineY = lowY < openY
          ? _bottomRectY - ((openY - lowY).abs() * animationFactor)
          : _bottomLineY;

      _topLineY = highY > closeY
          ? _topRectY + ((closeY - highY).abs() * animationFactor)
          : _topLineY;

      if (_isTransposed) {
        if (_currentPoint.open > _currentPoint.close) {
          _centersY = closeX + ((openX - closeX).abs() / 2);
          _topRectY = _centersY + ((_centersY - openX).abs() * animationFactor);
          _bottomRectY =
              _centersY - ((_centersY - closeX).abs() * animationFactor);
        } else {
          _centersY = openX + (closeX - openX).abs() / 2;
          _topRectY =
              _centersY + ((_centersY - closeX).abs() * animationFactor);
          _bottomRectY =
              _centersY - ((_centersY - openX).abs() * animationFactor);
        }
        if (_showSameValue) {
          canvas.drawLine(Offset(_centerHighPoint.x, _centerHighPoint.y),
              Offset(_centerLowPoint.x, _centerHighPoint.y), fillPaint);
        } else {
          path.moveTo(_topRectY, highY);
          centerHigh < closeX
              ? path.lineTo(
                  _topRectY - ((closeX - centerHigh).abs() * animationFactor),
                  highY)
              : path.lineTo(
                  _topRectY + ((closeX - centerHigh).abs() * animationFactor),
                  highY);
          path.moveTo(_bottomRectY, highY);
          centerLow > openX
              ? path.lineTo(
                  _bottomRectY + ((openX - centerLow).abs() * animationFactor),
                  highY)
              : path.lineTo(
                  _bottomRectY - ((openX - centerLow).abs() * animationFactor),
                  highY);
          linePath = path;
        }
        openX == closeX
            ? canvas.drawLine(
                Offset(openX, openY), Offset(closeX, closeY), fillPaint)
            : drawRectPath();
      } else {
        if (_currentPoint.open > _currentPoint.close) {
          final num temp = closeY;
          closeY = openY;
          openY = temp;
        }
        _showSameValue
            ? canvas.drawLine(Offset(_centerHighPoint.x, _highPoint.y),
                Offset(_centerHighPoint.x, _lowPoint.y), fillPaint)
            : drawLine(canvas);

        openY == closeY
            ? canvas.drawLine(
                Offset(openX, openY), Offset(closeX, closeY), fillPaint)
            : drawRectPath();
      }

      if (series.dashArray[0] != 0 &&
          series.dashArray[1] != 0 &&
          fillPaint.style != PaintingStyle.fill &&
          series.animationDuration <= 0) {
        _drawDashedLine(canvas, series.dashArray, fillPaint, path);
      } else {
        canvas.drawPath(path, fillPaint);
        if (fillPaint.style == PaintingStyle.fill) {
          if (_isTransposed) {
            if (_currentPoint.open > _currentPoint.close) {
              _showSameValue
                  ? canvas.drawLine(
                      Offset(_centerHighPoint.x, _centerHighPoint.y),
                      Offset(_centerLowPoint.x, _centerHighPoint.y),
                      fillPaint)
                  : drawFillLine(canvas);
            } else {
              _showSameValue
                  ? canvas.drawLine(
                      Offset(_centerHighPoint.x, _centerHighPoint.y),
                      Offset(_centerLowPoint.x, _centerHighPoint.y),
                      fillPaint)
                  : drawFillLine(canvas);
            }
          } else {
            _showSameValue
                ? canvas.drawLine(Offset(_centerHighPoint.x, _highPoint.y),
                    Offset(_centerHighPoint.x, _lowPoint.y), fillPaint)
                : drawLine(canvas);
          }
        }
      }
    } else if (!seriesRenderer._chart._chartState._isLegendToggled) {
      final CandleSegment currentSegment =
          seriesRenderer._segments[currentSegmentIndex];
      final CandleSegment oldSegment = (currentSegment._oldSeriesRenderer !=
                  null &&
              currentSegment._oldSeriesRenderer._segments.isNotEmpty &&
              currentSegment._oldSeriesRenderer._segments[0] is CandleSegment &&
              currentSegment._oldSeriesRenderer._segments.length - 1 >=
                  currentSegmentIndex)
          ? currentSegment._oldSeriesRenderer._segments[currentSegmentIndex]
          : null;
      _animateCandleSeries(
          _showSameValue,
          high,
          _isTransposed,
          _currentPoint.open,
          _currentPoint.close,
          lowY,
          highY,
          oldSegment?.lowY,
          oldSegment?.highY,
          openX,
          openY,
          closeX,
          closeY,
          centerLow,
          centerHigh,
          oldSegment?.openX,
          oldSegment?.openY,
          oldSegment?.closeX,
          oldSegment?.closeY,
          oldSegment?.centerLow,
          oldSegment?.centerHigh,
          animationFactor,
          fillPaint,
          canvas,
          seriesRenderer);
    }
  }
}
