# Custom Timer ⌛

A highly customizable timer builder, with controller, animation, intervals, callbacks, custom actions, and more!

<br>

<img width="320px" alt="Example image" src="https://raw.githubusercontent.com/federicodesia/custom_timer/master/images/example.gif"/>

<br>

## 📌 Simple Usage

```dart
@override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: Text("CustomTimer example"),
        ),
        body: Center(
          child: CustomTimer(
            from: Duration(hours: 12),
            to: Duration(hours: 0),
            onBuildAction: CustomTimerAction.auto_start,
            builder: (CustomTimerRemainingTime remaining) {
              return Text(
                "${remaining.hours}:${remaining.minutes}:${remaining.seconds}",
                style: TextStyle(fontSize: 30.0),
              );
            },
          ),
        ),
      ),
    );
  }
```

<br>

## 📌 Custom Usage
Options that allow for more control:

|  Properties  | Type | Description |
|--------------|-----------|-------------|
| `from` | Duration | The start of the timer.|
| `to`| Duration | The end of the timer.|
| `interval`| Duration | The time interval to update the widget.<br>The default interval is `Duration(seconds: 1)`.|
| `controller`| [CustomTimerController](##Using-the-CustomTimerController) | Controls the state of the timer.|
| `onBuildAction`| [CustomTimerAction](###CustomTimerAction-actions) | Execute an action when the widget is built for the first time.<br>The default action is `CustomTimerAction.go_to_start`.|
| `onFinishAction`| [CustomTimerAction](###CustomTimerAction-actions) | Execute an action when the timer finish.<br>The default action is `CustomTimerAction.go_to_end`.|
| `onResetAction`| [CustomTimerAction](###CustomTimerAction-actions) | Executes an action when the timer is reset.<br>The default action is `CustomTimerAction.go_to_start`.|
| `builder`| Widget Function([CustomTimerRemainingTime](###CustomTimerRemainingTime-properties)) | Function that builds a custom widget and allows to obtain the remaining time of the timer.|
| `finishedBuilder`| Widget Function([CustomTimerRemainingTime](###CustomTimerRemainingTime-properties)) | Function that builds a custom widget and allows to get the remaining time only when the timer  has finished.<br>If you use it, it will replace `builder`.|
| `pausedBuilder`| Widget Function([CustomTimerRemainingTime](###CustomTimerRemainingTime-properties)) | Function that builds a custom widget and allows to get the remaining time only when the timer is paused.<br>If you use it, it will replace `builder`.|
| `resetBuilder`| Widget Function([CustomTimerRemainingTime](###CustomTimerRemainingTime-properties)) | Function that builds a custom widget and allows to get the remaining time only when the timer is reset.<br>If you use it, it will replace `builder`.|
| `onStart`| VoidCallback | Callback function that runs when the timer start.|
| `onFinish`| VoidCallback | Callback function that runs when the timer finish.|
| `onPaused`| VoidCallback | Callback function that runs when the timer is paused.|
| `onReset`| VoidCallback | Callback function that runs when the timer is reset.|
| `onChangeState`| Function([CustomTimerState](###CustomTimerState-states)) | Callback function that runs when the timer state changes. Returns a `CustomTimerState` that allows you to get the state and create custom functions or conditions.|
| `onChangeStateAnimation`| AnimatedSwitcher | Animation that runs when the state of the timer changes. It is not necessary to define a child because it will be replaced by the current builder.|

<br>

### CustomTimerAction actions:

|  Actions  | Description |
|--------------|-----------|
| `CustomTimerAction.go_to_start` | Shows the start of the timer. |
| `CustomTimerAction.go_to_end` | Shows the end of the timer. |
| `CustomTimerAction.auto_start` | Automatically starts the timer. |

<br>

### CustomTimerRemainingTime properties:

|  Properties  | Description |
|--------------|-----------|
| `days` | A string with the remaining days. |
| `hours` | A string with the remaining hours. |
| `hoursWithoutFill` | A String with the remaining hours and only with two digits when necessary. |
| `minutes` | A string with the minutes remaining. |
| `minutesWithoutFill` | A String with the remaining minutes and only with two digits when necessary. |
| `seconds` | A string with the seconds remaining. |
| `secondsWithoutFill` | A String with the remaining seconds and only with two digits when necessary. |
| `milliseconds` | A string with the remaining milliseconds. |
| `duration` | A default Duration with remaining time.<br>Lets you create more specific functions or conditions, but remember that it can return more than 59 minutes and seconds and more than 1000 milliseconds. |

<br>

### CustomTimerState states:

|  States  |
|--------------|
| `CustomTimerState.reset` |
| `CustomTimerState.counting` |
| `CustomTimerState.paused` |
| `CustomTimerState.finished` |

<br>

You can access the timer state from the `onChangeState` callback function or using a `CustomTimerController`.
<br>
For example:

```dart
CustomTimerState state = _controller.state;
```

<br>

## 📌 Using the `CustomTimerController`

```dart
  final CustomTimerController _controller = new CustomTimerController();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: Text("CustomTimer example"),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            CustomTimer(
              controller: _controller,
              from: Duration(hours: 12),
              to: Duration(hours: 0),
              builder: (CustomTimerRemainingTime remaining) {
                return Text(
                  "${remaining.hours}:${remaining.minutes}:${remaining.seconds}",
                  style: TextStyle(fontSize: 30.0),
                );
              },
            ),
            SizedBox(height: 16.0,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                FlatButton(
                  child: Text("Start"),
                  onPressed: () => _controller.start(),
                  color: Colors.green,
                ),
                FlatButton(
                  child: Text("Pause"),
                  onPressed: () => _controller.pause(),
                  color: Colors.blue,
                ),
                FlatButton(
                  child: Text("Reset"),
                  onPressed: () => _controller.reset(),
                  color: Colors.red
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
```

<br>

### CustomTimerController properties:

|  Properties  | Permissions | Description |
|--------------|-----------|-----------|
| `state` | Read | Returns the current state of the timer.|

<br>

### CustomTimerController methods:

|  Methods  | Description |
|--------------|-----------|
| `start()` | Start or resume the timer. |
| `pause()` | Pause the timer. |
| `reset()` | Reset the timer.<br>If you want to restart the timer, you can call the controller `start()` method or set the `onResetAction` property to CustomTimerAction.auto_start.|

<br>

## ⚙️ Installation

Add this to your package's pubspec.yaml file:
```yaml
dependencies:
  custom_timer: ^0.0.6
```

Install it:
```yaml
$ flutter pub get
```

Import the package in your project:
```
import 'package:custom_timer/custom_timer.dart';
```
