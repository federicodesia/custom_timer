import 'package:flutter/material.dart';

import 'utils/utils.dart';

/// Remaining time for CustomTimer.
///
/// It allows to obtain the `days`, `hours`, `minutes`, `seconds` and `milliseconds`. So you can build the widget however you want.
///
/// If you want to show the remaining time with two digits only when necessary, you can use `hoursWithoutFill`, `minutesWithoutFill` or `secondsWithoutFill`.
class CustomTimerRemainingTime {
  CustomTimerRemainingTime({@required this.duration});

  /// Default duration with remaining time.
  ///
  /// If you do use it, remember that functions can return you numbers higher than 59.
  final Duration duration;

  /// Get the remaining days.
  String get days => duration.inDays.toString();

  /// Get the remaining hours with two digits.
  String get hours => fill(duration.inHours.remainder(24));

  /// Get the remaining minutes with two digits.
  String get minutes => fill(duration.inMinutes.remainder(60));

  /// Get the remaining seconds with two digits.
  String get seconds => fill(duration.inSeconds.remainder(60));

  /// Get the remaining milliseconds with two digits.
  String get milliseconds =>
      fill(duration.inMilliseconds.remainder(1000)).substring(0, 2);

  /// Get the remaining hours with two digits only when necessary.
  String get hoursWithoutFill => duration.inHours.remainder(24).toString();

  /// Get the remaining minutes with two digits only when necessary.
  String get minutesWithoutFill => duration.inMinutes.remainder(60).toString();

  /// Get the remaining seconds with two digits only when necessary.
  String get secondsWithoutFill => duration.inSeconds.remainder(60).toString();
}
