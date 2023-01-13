import 'package:custom_timer/custom_timer.dart';
import 'package:flutter/material.dart';

/// State for CustomTimer.
enum CustomTimerState { reset, paused, counting, finished }

// Update interval for CustomTimer.
enum CustomTimerInterval { minutes, seconds, milliseconds }

class CustomTimerController extends ChangeNotifier {
  /// The [TickerProvider] for the current context.
  final TickerProvider vsync;

  /// The start of the timer.
  final Duration begin;

  /// The end of the timer.
  final Duration end;

  /// Defines the initial state of the timer. By default it is `CustomTimerState.reset`.
  final CustomTimerState initialState;

  /// The update interval of the timer. By default it is `CustomTimerUpdateInterval.milliseconds`.
  final CustomTimerInterval interval;

  late bool _initialized = false;
  late AnimationController _animationController;
  late Animation<int> _animation;

  late ValueNotifier<CustomTimerState> _state = ValueNotifier(
      initialState != CustomTimerState.paused
          ? initialState
          : CustomTimerState.reset);

  late ValueNotifier<CustomTimerRemainingTime> _remaining = ValueNotifier(
      CustomTimerRemainingTime(
          duration: initialState == CustomTimerState.finished ? end : begin));

  /// Current state of the timer.
  ValueNotifier<CustomTimerState> get state => _state;

  /// Current remaining time.
  ValueNotifier<CustomTimerRemainingTime> get remaining => _remaining;

  /// Controls the state of the timer.
  /// Allows you to execute the `start()`, `pause()`, `reset()` and `finish()` functions. It also allows you to get or subscribe to the current `state` and `remaining` time.
  /// Remember to dispose when you are no longer using it.
  CustomTimerController({
    required this.vsync,
    required this.begin,
    required this.end,
    this.initialState = CustomTimerState.reset,
    this.interval = CustomTimerInterval.milliseconds,
  }) {
    final animationDuration = begin > end ? begin - end : end - begin;

    _animationController =
        AnimationController(duration: animationDuration, vsync: vsync);

    final curvedAnimation =
        CurvedAnimation(parent: _animationController, curve: Curves.linear);

    _animation = IntTween(begin: begin.inMilliseconds, end: end.inMilliseconds)
        .animate(curvedAnimation);

    if (initialState == CustomTimerState.finished)
      finish();
    else if (initialState == CustomTimerState.counting) start();
    _initialized = true;

    _animation.addListener(_listener);
    _animation.addStatusListener(_statusListener);
  }

  void _listener() {
    final duration = Duration(milliseconds: _animation.value);
    final next = CustomTimerRemainingTime(duration: duration);

    bool update = false;
    if (interval == CustomTimerInterval.milliseconds)
      update = true;
    else if (next.seconds != remaining.value.seconds &&
        interval == CustomTimerInterval.seconds)
      update = true;
    else if (next.minutes != remaining.value.minutes &&
        interval == CustomTimerInterval.minutes) update = true;

    if (update) {
      _remaining.value = next;
      notifyListeners();
    }
  }

  void _statusListener(AnimationStatus status) {
    if (status == AnimationStatus.completed) {
      _state.value = CustomTimerState.finished;
      notifyListeners();
    }
  }

  /// Timer reset function.
  void reset() {
    if (state.value == CustomTimerState.reset) return;
    _animationController.reset();
    _state.value = CustomTimerState.reset;
    notifyListeners();
  }

  /// Timer start function.
  void start() {
    if (_initialized && state.value == CustomTimerState.counting) return;
    if (state.value == CustomTimerState.finished) _animationController.reset();
    _animationController.forward();

    _state.value = CustomTimerState.counting;
    notifyListeners();
  }

  /// Timer pause function.
  void pause() {
    if (state.value != CustomTimerState.counting) return;

    _animationController.stop();
    _state.value = CustomTimerState.paused;
    notifyListeners();
  }

  /// Timer finish function.
  void finish() {
    if (_initialized && state.value == CustomTimerState.finished) return;
    _animationController.stop();
    _animationController.value = 1.0;
    _state.value = CustomTimerState.finished;
    notifyListeners();
  }

  /// Function to move the current time.
  void jumpTo(Duration duration) {
    final value = duration.inMilliseconds / (begin - end).inMilliseconds.abs();
    final next = begin > end ? 1.0 - value : value;

    if (next <= 0.0) return reset();
    if (next >= 1.0) return finish();

    _animationController.value = next;
    _state.value = CustomTimerState.paused;
    notifyListeners();
  }

  @override
  void dispose() {
    _animation.removeListener(_listener);
    _animation.removeStatusListener(_statusListener);
    _animationController.dispose();
    super.dispose();
  }
}
