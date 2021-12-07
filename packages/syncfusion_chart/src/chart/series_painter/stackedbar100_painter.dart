part of charts;

class _StackedBar100ChartPainter extends CustomPainter {
  _StackedBar100ChartPainter({
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
  final StackedBar100SeriesRenderer seriesRenderer;
  final _PainterKey painterKey;
  //ignore: unused_field
  static double animation;

  /// Painter method for stacked bar 100 series
  @override
  void paint(Canvas canvas, Size size) {
    _stackedRectPainter(canvas, seriesRenderer, chart, seriesAnimation,
        chartElementAnimation, painterKey);
  }

  @override
  bool shouldRepaint(_StackedBar100ChartPainter oldDelegate) => isRepaint;
}
