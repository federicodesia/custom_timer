import 'package:flutter/material.dart';

import 'widgets/custom_timer.dart';

/// Controller for CustomTimer.
class CustomTimerController {
  /// The callback function that executes when the `start` method is called.
  VoidCallback _onStart;

  /// The callback function that executes when the `pause` method is called.
  VoidCallback _onPause;

  /// The callback function that executes when the `reset` method is called.
  VoidCallback _onReset;

  CustomTimerState _state;

  /// The current state of the timer.
  ///
  /// This allows you to create custom functions or conditions. For example:
  ///
  /// ``` dart
  ///   if(_controller.state == CustomTimerState.finished)...
  /// ```
  CustomTimerState get state {
    return _state;
  }

  set state(value) {
    this._state = value;
  }

  /// Constructor.
  CustomTimerController();

  /// Start the timer.
  start() {
    if (this._onStart != null) this._onStart();
  }

  onSetStart(VoidCallback onStart) => this._onStart = onStart;

  /// Set timer in pause.
  pause() {
    if (this._onPause != null) this._onPause();
  }

  onSetPause(VoidCallback onPause) => this._onPause = onPause;

  /// Reset the timer.
  reset() {
    if (this._onReset != null) this._onReset();
  }

  onSetReset(VoidCallback onReset) => this._onReset = onReset;
}
