part of charts;

class _StackedColumn100ChartPainter extends CustomPainter {
  _StackedColumn100ChartPainter({
    this.chart,
    this.seriesRenderer,
    this.isRepaint,
    this.animationController,
    this.seriesAnimation,
    this.chartElementAnimation,
    this.painterKey,
    ValueNotifier<num> notifier,
  }) : super(repaint: notifier);

  final SfCartesianChart chart;
  CartesianChartPoint<dynamic> point;
  final bool isRepaint;
  final AnimationController animationController;
  final Animation<double> seriesAnimation;
  final Animation<double> chartElementAnimation;
  List<_ChartLocation> currentChartLocations = <_ChartLocation>[];
  final StackedColumn100SeriesRenderer seriesRenderer;
  final _PainterKey painterKey;

  /// Painter method for stacked column 100 series
  @override
  void paint(Canvas canvas, Size size) {
    _stackedRectPainter(canvas, seriesRenderer, chart, seriesAnimation,
        chartElementAnimation, painterKey);
  }

  @override
  bool shouldRepaint(_StackedColumn100ChartPainter oldDelegate) => isRepaint;
}
