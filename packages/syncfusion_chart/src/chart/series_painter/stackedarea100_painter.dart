part of charts;

class _StackedArea100ChartPainter extends CustomPainter {
  _StackedArea100ChartPainter(
      {this.chart,
      this.seriesRenderer,
      this.isRepaint,
      this.animationController,
      this.seriesAnimation,
      this.chartElementAnimation,
      this.painterKey,
      ValueNotifier<num> notifier})
      : super(repaint: notifier);
  final SfCartesianChart chart;
  final bool isRepaint;
  final Animation<double> seriesAnimation;
  final Animation<double> chartElementAnimation;
  final Animation<double> animationController;
  final StackedArea100SeriesRenderer seriesRenderer;
  final _PainterKey painterKey;

  /// Painter method for stacked area 100 series
  @override
  void paint(Canvas canvas, Size size) {
    _stackedAreaPainter(canvas, seriesRenderer, chart, seriesAnimation,
        chartElementAnimation, painterKey);
  }

  @override
  bool shouldRepaint(_StackedArea100ChartPainter oldDelegate) => isRepaint;
}
