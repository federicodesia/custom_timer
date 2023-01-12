import 'package:custom_timer/custom_timer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class CustomTimer extends StatefulWidget {
  /// Creates a customizable timer.
  const CustomTimer({
    Key? key,
    required this.controller,
    required this.builder,
  }) : super(key: key);

  /// Controls the state of the timer.
  /// Allows you to execute the `start()`, `pause()`, `reset()` and `finish()` functions. It also allows you to get or subscribe to the current `state` and `remaining` time.
  /// Remember to dispose when you are no longer using it.
  final CustomTimerController controller;

  /// Returns a `CustomTimerState` to get the current state of the timer, which can be `reset`, `counting`, `paused`, or `finished`.
  /// It also returns a `CustomTimerRemainingTime` to get the remaining `days`, `hours`, `minutes`, `seconds` and `milliseconds`.
  final Widget Function(CustomTimerState, CustomTimerRemainingTime) builder;

  @override
  _CustomTimerState createState() => _CustomTimerState();
}

class _CustomTimerState extends State<CustomTimer> {
  late CustomTimerController _controller = widget.controller;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return widget.builder(
            _controller.state.value, _controller.remaining.value);
      },
    );
  }
}
