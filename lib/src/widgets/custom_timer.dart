import 'dart:async';

import 'package:flutter/material.dart';

import '../custom_timer_controller.dart';
import '../custom_timer_remaining_time.dart';

/// State for CustomTimer.
enum CustomTimerState { reset, paused, counting, finished }

/// Actions for CustomTimer.
enum CustomTimerAction { go_to_start, go_to_end, auto_start }

class CustomTimer extends StatefulWidget {
  CustomTimer(
      {Key key,
      @required this.from,
      @required this.to,
      this.controller,
      this.interval = const Duration(seconds: 1),
      this.onStart,
      this.onFinish,
      this.onPaused,
      this.onReset,
      this.onBuildAction = CustomTimerAction.go_to_start,
      this.onFinishAction = CustomTimerAction.go_to_end,
      this.onResetAction = CustomTimerAction.go_to_start,
      this.onChangeState,
      this.onChangeStateAnimation =
          const AnimatedSwitcher(duration: Duration()),
      this.builder,
      this.finishedBuilder,
      this.pausedBuilder,
      this.resetBuilder})
      : assert(from != null, "Timer start time cannot be null."),
        assert(to != null, "Timer end time cannot be null."),
        assert((from.inSeconds - to.inSeconds).abs() >= 1,
            "There must be at least one second difference between the start time and the end time of the timer."),
        assert(interval.inMilliseconds >= 10,
            "The interval must be at least 10 milliseconds."),
        super(key: key);

  /// The start of the timer.
  final Duration from;

  /// The end of the timer.
  final Duration to;

  /// Controls the state of the timer. Ensure you dispose of it when done.
  ///
  /// If null, this widget will create its own [CustomTimerController] and dispose it when the widget is disposed.
  final CustomTimerController controller;

  /// The time interval to update the widget.
  ///
  /// The default interval is `Duration(seconds: 1)`.
  final Duration interval;

  /// The callback function that runs when the timer start.
  final VoidCallback onStart;

  /// The callback function that runs when the timer finish.
  final VoidCallback onFinish;

  /// The callback function that runs when the timer is paused.
  final VoidCallback onPaused;

  /// The callback function that runs when the timer is reset.
  final VoidCallback onReset;

  /// Execute an action when the widget is built for the first time.
  ///
  /// `CustomTimerAction.go_to_start` shows the start time of the timer. `CustomTimerAction.go_to_end` shows the end time of the timer. `CustomTimerAction.auto_start` automatically starts the timer.
  ///
  /// The default action is `CustomTimerAction.go_to_start`.
  final CustomTimerAction onBuildAction;

  /// Execute an action when the timer finish.
  ///
  /// `CustomTimerAction.go_to_start` shows the start time of the timer. `CustomTimerAction.go_to_end` keeps the timer at the end of time. `CustomTimerAction.auto_start` automatically starts the timer.
  ///
  /// The default action is `CustomTimerAction.go_to_end`.
  final CustomTimerAction onFinishAction;

  /// Executes an action when the timer is reset from the controller.
  ///
  /// `CustomTimerAction.go_to_start` keeps the timer at the start of time `CustomTimerAction.go_to_end` shows the end time of the timer. `CustomTimerAction.auto_start` automatically starts the timer.
  ///
  /// The default action is `CustomTimerAction.go_to_start`.
  final CustomTimerAction onResetAction;

  /// The callback function that runs when the timer state changes.
  ///
  /// Returns a CustomTimerState with the current state of the timer that allows you to create functions or conditions if you want.
  final Function(CustomTimerState state) onChangeState;

  /// Sets an animation when the timer state change.
  ///
  /// It is only executed when the general state of the timer changes (`CustomTimerState.reset`, `CustomTimerState.counting` `CustomTimerState.paused` or `CustomTimerState.finished`).
  ///
  /// It is not necessary to set a child, because it will be automatically replaced by the widgets you define in the corresponding custom builders (`builder`, `finishedBuilder`, `pausedBuilder` or `resetBuilder`).
  ///
  /// By default it has no animation.
  final AnimatedSwitcher onChangeStateAnimation;

  /// Function that runs when the timer is updated.
  ///
  /// Returns a `CustomTimerRemainingTime` to get the remaining `days`, `hours`, `minutes`, `seconds` and `milliseconds`. So you can build the widget the way you want.
  ///
  /// If you want to show the remaining time with two digits only when necessary, you can use `hoursWithoutFill`, `minutesWithoutFill` or `secondsWithoutFill`.
  final Widget Function(CustomTimerRemainingTime remaining) builder;

  /// Function that runs when the timer finished.
  ///
  /// Returns a `CustomTimerRemainingTime` to get the `days`, `hours`, `minutes`, `seconds` and `milliseconds` if desired. So you can build the widget the way you want.
  ///
  /// If you want to show the remaining time with two digits only when necessary, you can use `hoursWithoutFill`, `minutesWithoutFill` or `secondsWithoutFill`.
  ///
  /// If you set a widget in this builder, when the timer finish, it will automatically replace the widget in `builder`.
  final Widget Function(CustomTimerRemainingTime remaining) finishedBuilder;

  /// Function that is executed when the timer is paused.
  ///
  /// Returns a `CustomTimerRemainingTime` to get the remaining `days`, `hours`, `minutes`, `seconds` and `milliseconds` if desired. So you can build the widget the way you want.
  ///
  /// If you want to show the remaining time with two digits only when necessary, you can use `hoursWithoutFill`, `minutesWithoutFill` or `secondsWithoutFill`.
  ///
  /// If you set a widget in this builder, when the timer is paused, it will automatically replace the widget in `builder`.
  final Widget Function(CustomTimerRemainingTime remaining) pausedBuilder;

  /// Function that is executed when the timer is reset.
  ///
  /// Returns a `CustomTimerRemainingTime` to get the `days`, `hours`, `minutes`, `seconds` and `milliseconds` if desired. So you can build the widget the way you want.
  ///
  /// If you want to show the remaining time with two digits only when necessary, you can use `hoursWithoutFill`, `minutesWithoutFill` or `secondsWithoutFill`.
  ///
  /// If you set a widget in this builder, when the timer is paused, it will automatically replace the widget in `builder`.
  final Widget Function(CustomTimerRemainingTime remaining) resetBuilder;

  @override
  _CustomTimerState createState() => _CustomTimerState();
}

class _CustomTimerState extends State<CustomTimer> {
  Widget _returnWidget;
  Timer _timer;
  Duration _duration;
  CustomTimerController _controller;

  @override
  void initState() {
    widget.controller != null ? _controller = widget.controller : _controller = new CustomTimerController();

    // Set the functions and state of the timer controller.
    _controller.onSetStart(() => _startTimer());
    _controller.onSetPause(_onTimerPaused);
    _controller.onSetReset(_onTimerReset);
    _controller.state = CustomTimerState.reset;

    _action(widget.onBuildAction);

    super.initState();
  }

  @override
  void dispose() {
    if (_timer?.isActive == true) _timer?.cancel();

    super.dispose();
  }

  void _action(CustomTimerAction action) {
    _timer?.cancel();
    if (action == CustomTimerAction.auto_start)
      _startTimer();
    else if (action == CustomTimerAction.go_to_start)
      setState(() => _duration = widget.from);
    else
      setState(() => _duration = widget.to);
  }

  void _startTimer() {
    if (_controller.state != CustomTimerState.counting) {
      // If the timer was paused when the function was called, start the timer from the same time.
      // Otherwise, set the timer at the start time.
      if (_controller.state != CustomTimerState.paused)
        setState(() => _duration = widget.from);

      _controller.state = CustomTimerState.counting;
      if (widget.onStart != null) widget.onStart();
      _onChangeState();

      setState(() => _returnWidget = null);

      // Start counting depending on the direction of the timer.
      if (widget.from > widget.to)
        _startCountdown();
      else
        _startCountup();
    } else
      print("[CustomTimer] The timer is already counting.");
  }

  void _startCountup() {
    _timer = Timer.periodic(widget.interval, (Timer timer) {
      if (_duration.inMilliseconds == widget.to.inMilliseconds) {
        // Countup finished.
        _onTimerFinished();
      } else
        setState(() => _duration += widget.interval);
    });
  }

  void _startCountdown() {
    _timer = Timer.periodic(widget.interval, (Timer timer) {
      if (_duration.inMilliseconds == widget.to.inMilliseconds) {
        // Countdown finished.
        _onTimerFinished();
      } else
        setState(() => _duration -= widget.interval);
    });
  }

  void _onTimerFinished() {
    _timer.cancel();
    _controller.state = CustomTimerState.finished;

    if (widget.onFinish != null) widget.onFinish();
    _onChangeState();

    _action(widget.onFinishAction);

    // Return the widget if the finishedBuilder is being used
    if (_controller.state == CustomTimerState.finished &&
        widget.finishedBuilder != null) {
      setState(() => _returnWidget = widget
          .finishedBuilder(CustomTimerRemainingTime(duration: _duration)));
    }
  }

  void _onTimerPaused() {
    if (_controller.state != CustomTimerState.paused) {
      _controller.state = CustomTimerState.paused;
      _timer?.cancel();

      if (widget.onPaused != null) widget.onPaused();
      _onChangeState();

      // Return the widget if the pausedBuilder is being used.
      if (widget.pausedBuilder != null) {
        setState(() => _returnWidget = widget
            .pausedBuilder(CustomTimerRemainingTime(duration: _duration)));
      }
    } else
      print("[CustomTimer] The timer is already paused.");
  }

  void _onTimerReset() {
    if (_controller.state != CustomTimerState.reset) {
      _controller.state = CustomTimerState.reset;

      if (widget.onReset != null) widget.onReset();
      _onChangeState();

      _action(widget.onResetAction);

      // Return the widget if the resetBuilder is being used.
      if (_controller.state == CustomTimerState.reset &&
          widget.resetBuilder != null) {
        setState(() => _returnWidget =
            widget.resetBuilder(CustomTimerRemainingTime(duration: _duration)));
      }
    } else
      print("[CustomTimer] The timer is already reset.");
  }

  void _onChangeState() {
    if (widget.onChangeState != null)
      widget.onChangeState(_controller.state);
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: widget.onChangeStateAnimation.duration,
      reverseDuration: widget.onChangeStateAnimation.reverseDuration,
      switchInCurve: widget.onChangeStateAnimation.switchInCurve,
      switchOutCurve: widget.onChangeStateAnimation.switchOutCurve,
      transitionBuilder: widget.onChangeStateAnimation.transitionBuilder,
      layoutBuilder: widget.onChangeStateAnimation.layoutBuilder,
      child: _returnWidget == null
          ? widget.builder(CustomTimerRemainingTime(duration: _duration))
          : _returnWidget,
    );
  }
}
