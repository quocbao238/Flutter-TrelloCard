part of charts;

class _StackedLine100ChartPainter extends CustomPainter {
  _StackedLine100ChartPainter(
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
  final bool isRepaint;
  final AnimationController animationController;
  final Animation<double> seriesAnimation;
  final Animation<double> chartElementAnimation;
  final StackedLine100SeriesRenderer seriesRenderer;
  final _PainterKey painterKey;

  /// Painter method for stacked line 100 series
  @override
  void paint(Canvas canvas, Size size) {
    _stackedLinePainter(canvas, seriesRenderer, seriesAnimation, chart,
        chartElementAnimation, painterKey);
  }

  @override
  bool shouldRepaint(_StackedLine100ChartPainter oldDelegate) => isRepaint;
}
