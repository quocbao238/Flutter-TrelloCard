part of charts;

class _StackedLineChartPainter extends CustomPainter {
  _StackedLineChartPainter(
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
  final StackedLineSeriesRenderer seriesRenderer;
  final _PainterKey painterKey;

  /// Painter method for stacked line series
  @override
  void paint(Canvas canvas, Size size) {
    _stackedLinePainter(canvas, seriesRenderer, seriesAnimation, chart,
        chartElementAnimation, painterKey);
  }

  @override
  bool shouldRepaint(_StackedLineChartPainter oldDelegate) => isRepaint;
}
