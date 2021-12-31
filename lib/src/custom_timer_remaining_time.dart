import 'utils/utils.dart';

/// Remaining time for CustomTimer.
class CustomTimerRemainingTime {
  CustomTimerRemainingTime({required this.duration});

  /// Default duration with remaining time.
  ///
  /// If you do use it, remember that functions can return you numbers higher than 59.
  Duration duration = Duration();

  /// Get the remaining days.
  String get days => duration.inDays.toString();

  /// Get the remaining hours always with two digits.
  String get hours => fill(duration.inHours.remainder(24));

  /// Get the remaining minutes always with two digits.
  String get minutes => fill(duration.inMinutes.remainder(60));

  /// Get the remaining seconds always with two digits.
  String get seconds => fill(duration.inSeconds.remainder(60));

  /// Get the remaining milliseconds always with three digits.
  String get milliseconds =>
      fill(duration.inMilliseconds.remainder(1000), count: 3);

  /// Get the remaining hours without completing  with leading zeros.
  String get hoursWithoutFill => duration.inHours.remainder(24).toString();

  /// Get the remaining minutes without completing  with leading zeros.
  String get minutesWithoutFill => duration.inMinutes.remainder(60).toString();

  /// Get the remaining seconds without completing  with leading zeros.
  String get secondsWithoutFill => duration.inSeconds.remainder(60).toString();

  /// Get the remaining milliseconds without completing  with leading zeros.
  String get millisecondsWithoutFill =>
      duration.inMilliseconds.remainder(1000).toString();
}
