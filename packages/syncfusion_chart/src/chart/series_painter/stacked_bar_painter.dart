part of charts;

class _StackedBarChartPainter extends CustomPainter {
  _StackedBarChartPainter({
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
  final StackedBarSeriesRenderer seriesRenderer;
  final _PainterKey painterKey;
  //ignore: unused_field
  static double animation;

  /// Painter method for stacked bar series
  @override
  void paint(Canvas canvas, Size size) {
    _stackedRectPainter(canvas, seriesRenderer, chart, seriesAnimation,
        chartElementAnimation, painterKey);
  }

  @override
  bool shouldRepaint(_StackedBarChartPainter oldDelegate) => isRepaint;
}
