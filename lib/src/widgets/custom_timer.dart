import 'package:custom_timer/custom_timer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class CustomTimer extends StatefulWidget {

  /// Creates a customizable timer.
  const CustomTimer({
    Key? key,
    this.controller,
    required this.begin,
    required this.end,
    this.animationBuilder,
    required this.builder,
    this.stateBuilder,
    this.onChangeState,
  }) : super(key: key);

  /// Controls the state of the timer.
  /// It allows obtaining the current `state` and executing the functions `start()`, `pause()` and `reset()`.
  /// Remember to dispose when you are no longer using it.
  ///
  /// If null, this widget will create its own [CustomTimerController] and dispose it when the widget is disposed.
  final CustomTimerController? controller;

  /// The start of the timer.
  final Duration begin;

  /// The end of the timer.
  final Duration end;

  /// Constructor that allows to create animations in the change of state of the counter.
  /// Returns a `widget` that must be used as the `child` of the animation you define. It is only activated when using `stateBuilder`.
  /// 
  /// Example using AnimatedSwitcher:
  /// ```dart
  /// animationBuilder: (child) {
  ///   return AnimatedSwitcher(
  ///     duration: Duration(milliseconds: 250),
  ///     child: child,
  ///   );
  /// }
  /// ```
  final Widget Function(Widget)? animationBuilder;

  /// Returns a `CustomTimerRemainingTime` to get the remaining `days`, `hours`, `minutes`, `seconds` and `milliseconds`. So you can build the widget the way you want.
  /// 
  /// Avoid state comparisons in this constructor. Instead, you can use `stateBuilder`.
  final Widget Function(CustomTimerRemainingTime) builder;

  /// Build the widget you want when the current state is different from CustomTimerState.counting.
  /// 
  /// Returns a `CustomTimerRemainingTime` to get the remaining `days`, `hours`, `minutes`, `seconds` and `milliseconds`.
  /// Returns a `CustomTimerState` to get the current state of the timer, which can be `reset`, `paused` or `finished`.
  /// 
  /// If no widget is returned, `builder` is displayed.
  final Widget? Function(CustomTimerRemainingTime, CustomTimerState)? stateBuilder;

  /// Callback function that is executed when the timer status changes.
  /// Returns a `CustomTimerState` to get the current state of the timer, which can be `counting`, `reset`, `paused` or `finished`.
  final void Function(CustomTimerState)? onChangeState;

  @override
  _CustomTimerState createState() => _CustomTimerState();
}

class _CustomTimerState extends State<CustomTimer> with TickerProviderStateMixin {
  late CustomTimerController _controller;
  late AnimationController _animationController;
  late Animation<int> _animation;

  late bool stateBuilder;

  @override
  void initState() {
    _controller = widget.controller ?? CustomTimerController();
    _controller.addListener(updateAnimationController);

    final Duration _begin = widget.begin;
    final Duration _end = widget.end;
    final Duration _animationDuration;

    if(_begin > _end) _animationDuration = _begin - _end;
    else _animationDuration = _end - _begin;

    _animationController = AnimationController(
      duration: _animationDuration,
      vsync: this
    );

    final CurvedAnimation curvedAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.linear
    );

    _animation = IntTween(
      begin: widget.begin.inMilliseconds,
      end: widget.end.inMilliseconds
    ).animate(curvedAnimation);

    updateAnimationController();
    _animationController.addStatusListener(updateController);

    super.initState();
  }

  void updateAnimationController(){
    CustomTimerState state = _controller.state;

    if(state == CustomTimerState.counting){
      _animationController.forward();
      setState(() => stateBuilder = false);
    }
    else{
      setState(() => stateBuilder = widget.stateBuilder != null);

      if(state == CustomTimerState.paused) _animationController.stop();
      else if(state == CustomTimerState.reset) _animationController.reset();
      else if(state == CustomTimerState.finished){
        _animationController.stop();
        _animationController.value = 1.0;
      }
    }

    if(widget.onChangeState != null) widget.onChangeState!(state);
  }

  void updateController(AnimationStatus status){

    if(status == AnimationStatus.forward) _controller.start(disableNotifyListeners: true);
    else if(status == AnimationStatus.completed) _controller.finish();
  }

  @override
  void dispose() {
    _controller.removeListener(updateAnimationController);
    _controller.dispose();

    _animationController.removeStatusListener(updateController);
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    final Widget remainingBuilder = _CustomTimerAnimatedBuilder(
      animation: _animation,
      builder: widget.builder,
    );

    final Widget child = Container(
      key: Key(_controller.state.toString()),
        child: stateBuilder ? widget.stateBuilder!(
          CustomTimerRemainingTime(
            duration: Duration(milliseconds: _animation.value)
          ),
          _controller.state
        ) ?? remainingBuilder
      : remainingBuilder,
    );

    if(widget.animationBuilder != null && widget.stateBuilder != null) return widget.animationBuilder!(child);
    return child;
  }
}

class _CustomTimerAnimatedBuilder extends AnimatedWidget {

  const _CustomTimerAnimatedBuilder({
    Key? key,
    required this.animation,
    required this.builder
  }) : super(key: key, listenable: animation);

  final Animation<int> animation;
  final Widget Function(CustomTimerRemainingTime) builder;

  @override
  Widget build(BuildContext context) => builder(
    CustomTimerRemainingTime(
      duration: Duration(milliseconds: animation.value)
    )
  );
}