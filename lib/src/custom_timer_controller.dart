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
  late Duration _begin;
  Duration get begin => _begin;
  set begin(Duration duration) {
    final prev = remaining.value.duration;
    _begin = duration;
    _init();
    jumpTo(prev);
  }

  /// The end of the timer.
  late Duration _end;
  Duration get end => _end;
  set end(Duration duration) {
    final prev = remaining.value.duration;
    _end = duration;
    _init();
    jumpTo(prev);
  }

  /// Defines the initial state of the timer. By default it is `CustomTimerState.reset`.
  final CustomTimerState initialState;

  /// The update interval of the timer. By default it is `CustomTimerUpdateInterval.milliseconds`.
  CustomTimerInterval interval;

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
    required Duration begin,
    required Duration end,
    this.initialState = CustomTimerState.reset,
    this.interval = CustomTimerInterval.milliseconds,
  }) {
    _begin = begin;
    _end = end;
    _animationController = AnimationController(vsync: vsync);
    _init();

    if (initialState == CustomTimerState.finished)
      finish();
    else if (initialState == CustomTimerState.counting) start();

    _animation.addListener(_listener);
    _animation.addStatusListener(_statusListener);
  }

  void _init() {
    _animationController.duration =
        Duration(milliseconds: (begin - end).inMilliseconds.abs());

    final curvedAnimation =
        CurvedAnimation(parent: _animationController, curve: Curves.linear);

    _animation = IntTween(begin: begin.inMilliseconds, end: end.inMilliseconds)
        .animate(curvedAnimation);
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
    _animationController.reset();
    _state.value = CustomTimerState.reset;
    notifyListeners();
  }

  /// Timer start function.
  void start() {
    if (state.value == CustomTimerState.finished) _animationController.reset();
    _animationController.forward();

    _state.value = CustomTimerState.counting;
    notifyListeners();
  }

  void _pause() {
    _animationController.stop();
    _state.value = CustomTimerState.paused;
    notifyListeners();
  }

  /// Timer pause function.
  void pause() {
    if (state.value != CustomTimerState.counting) return;
    _pause();
  }

  /// Timer finish function.
  void finish() {
    _animationController.stop();
    _animationController.value = 1.0;
    _state.value = CustomTimerState.finished;
    notifyListeners();
  }

  /// Function to move the current time.
  void jumpTo(Duration duration) {
    final isCountUp = begin < end;

    final a = isCountUp ? begin.inMilliseconds : end.inMilliseconds;
    final b = isCountUp ? end.inMilliseconds : begin.inMilliseconds;

    final value = (duration.inMilliseconds - a) / (b - a);
    final next = isCountUp ? value : 1.0 - value;

    if (next <= 0.0 && state.value != CustomTimerState.counting) return reset();
    if (next >= 1.0) return finish();

    _animationController.value = next;
    if (state.value == CustomTimerState.counting)
      start();
    else
      _pause();
  }

  /// Function to increase the remaining time.
  void add(Duration duration) {
    jumpTo(_remaining.value.duration + duration);
  }

  /// Function to decrease the remaining time.
  void subtract(Duration duration) {
    jumpTo(_remaining.value.duration - duration);
  }

  @override
  void dispose() {
    _animation.removeListener(_listener);
    _animation.removeStatusListener(_statusListener);
    _animationController.dispose();
    super.dispose();
  }
}
