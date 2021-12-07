part of charts;

// ignore: must_be_immutable
class _TooltipTemplate extends StatefulWidget {
  // ignore: prefer_const_constructors_in_immutables
  _TooltipTemplate(
      {this.rect,
      this.template,
      this.show,
      this.clipRect,
      this.duration = 3000});

  Rect rect;

  Widget template;

  bool show;

  bool _alwaysShow;

  Rect clipRect;

  _TooltipTemplateState state;

  double duration;

  @override
  State<StatefulWidget> createState() {
    return _TooltipTemplateState();
  }
}

class _TooltipTemplateState extends State<_TooltipTemplate>
    with SingleTickerProviderStateMixin {
  BuildContext tooltipContext;

  bool needMeasure;

  Size tooltipSize = const Size(0, 0);

  AnimationController _controller;
  Animation<double> _animation;

  //properties hold the previous and current tooltip values when the interaction is done through mouse hovering
  TooltipValue prevTooltipValue;
  TooltipValue currentTooltipValue;

  Timer tooltipTimer;

  @override
  void initState() {
    widget.state = this;
    _controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 500));
    _animation = Tween<double>(begin: 0.0, end: 1.0)
        .animate(CurvedAnimation(parent: _controller, curve: Curves.bounceOut));
    super.initState();
  }

  void hideOnTimer() {
    if (prevTooltipValue == null && currentTooltipValue == null) {
      hideTooltipTemplate();
    } else {
      if (tooltipTimer != null) {
        tooltipTimer.cancel();
      }
      tooltipTimer = Timer(
          Duration(milliseconds: widget.duration.toInt()), hideTooltipTemplate);
    }
  }

  void hideTooltipTemplate() {
    if (mounted && !(widget._alwaysShow ?? false)) {
      setState(() {
        widget.show = false;
      });
      prevTooltipValue = null;
      currentTooltipValue = null;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    tooltipTimer?.cancel();
    super.dispose();
  }

  @override
  void didUpdateWidget(_TooltipTemplate oldWidget) {
    widget.state = this;
    super.didUpdateWidget(oldWidget);
  }

  void _performTooltip() {
    //for mouse hover the tooltip is redrawn only when the current tooltip value differs from the previous one
    if (widget.show &&
        mounted &&
        ((prevTooltipValue == null && currentTooltipValue == null) ||
            (prevTooltipValue?.seriesIndex !=
                    currentTooltipValue?.seriesIndex ||
                prevTooltipValue?.pointIndex !=
                    currentTooltipValue?.pointIndex))) {
      needMeasure = true;
      tooltipSize = const Size(0, 0);
      setState(() {});
    }
  }

  void _loaded() {
    final RenderBox renderBox = tooltipContext.findRenderObject();
    tooltipSize = renderBox.size;
    needMeasure = false;
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget tooltipWidget;
    if (widget.show) {
      if (needMeasure) {
        tooltipWidget =
            Opacity(opacity: 0.0, child: Container(child: widget.template));
        tooltipContext = context;
        SchedulerBinding.instance.addPostFrameCallback((_) => _loaded());
      } else {
        _controller.forward(from: 0.0);
        final Rect tooltipRect = Rect.fromLTWH(
            widget.rect.left - tooltipSize.width / 2,
            widget.rect.top - tooltipSize.height / 2,
            tooltipSize.width,
            tooltipSize.height);
        final Offset location =
            _getTooltipLocation(tooltipRect, widget.clipRect);
        tooltipWidget = AnimatedBuilder(
            animation: _animation,
            child: Container(
                margin: EdgeInsets.fromLTRB(location.dx, location.dy, 0, 0),
                child: widget.template),
            builder: (BuildContext context, Widget _widget) {
              return Opacity(opacity: _controller.value * 1.0, child: _widget);
            });
      }
    } else {
      tooltipWidget = Container();
    }
    if (tooltipTimer != null) {
      tooltipTimer.cancel();
    }
    if (widget.show &&
        (prevTooltipValue == null && currentTooltipValue == null)) {
      tooltipTimer = Timer(
          Duration(milliseconds: widget.duration.toInt()), hideTooltipTemplate);
    }
    return tooltipWidget;
  }

  /// It returns the offset values of tooltip location
  Offset _getTooltipLocation(Rect tooltipRect, Rect bounds) {
    double left = tooltipRect.left, top = tooltipRect.top;
    if (tooltipRect.left < bounds.left) {
      left = bounds.left;
    }
    if (tooltipRect.top < bounds.top) {
      top = bounds.top;
    }
    if (tooltipRect.left + tooltipRect.width > bounds.left + bounds.width) {
      left = (bounds.left + bounds.width) - tooltipRect.width;
    }
    if (tooltipRect.top + tooltipRect.height > bounds.top + bounds.height) {
      top = (bounds.top + bounds.height) - tooltipRect.height;
    }
    return Offset(left, top);
  }
}
