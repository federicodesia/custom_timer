import 'package:flutter/material.dart';

/// State for CustomTimer.
enum CustomTimerState { reset, paused, counting, finished }

class CustomTimerController extends ChangeNotifier {
  
  /// Controller for CustomTimer.
  CustomTimerController({
    this.initialState = CustomTimerState.reset
  });

  /// Defines the initial state of the timer. By default it is `CustomTimerState.reset`
  final CustomTimerState initialState;

  late CustomTimerState _state = initialState;

  /// Current state of the timer.
  CustomTimerState get state => _state;

  /// Timer pause function.
  void pause(){
    if(!_disposed){
      _state = CustomTimerState.paused;
      notifyListeners();
    }
  }

  /// Timer start function.
  void start({bool disableNotifyListeners = false}){
    if(!_disposed){
      _state = CustomTimerState.counting;
      if(!disableNotifyListeners) notifyListeners();
    }
  }

  /// Timer reset function.
  void reset(){
    if(!_disposed){
      _state = CustomTimerState.reset;
      notifyListeners();
    }
  }

  /// Timer finish function.
  void finish(){
    if(!_disposed){
      _state = CustomTimerState.finished;
      notifyListeners();
    }
  }

  bool _disposed = false;

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }
}