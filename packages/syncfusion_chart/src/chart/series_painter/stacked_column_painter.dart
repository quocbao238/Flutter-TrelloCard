part of charts;

class _StackedColummnChartPainter extends CustomPainter {
  _StackedColummnChartPainter(
      {this.chart,
      this.seriesRenderer,
      this.isRepaint,
      this.animationController,
      this.seriesAnimation,
      this.chartElementAnimation,
      ValueNotifier<num> notifier,
      this.painterKey})
      : super(repaint: notifier);

  final SfCartesianChart chart;
  CartesianChartPoint<dynamic> point;
  final bool isRepaint;
  final AnimationController animationController;
  final Animation<double> seriesAnimation;
  final Animation<double> chartElementAnimation;
  List<_ChartLocation> currentChartLocations = <_ChartLocation>[];
  final StackedColumnSeriesRenderer seriesRenderer;
  final _PainterKey painterKey;

  /// Painter method for stacked column series
  @override
  void paint(Canvas canvas, Size size) {
    _stackedRectPainter(canvas, seriesRenderer, chart, seriesAnimation,
        chartElementAnimation, painterKey);
  }

  @override
  bool shouldRepaint(_StackedColummnChartPainter oldDelegate) => isRepaint;
}
