# Custom Timer ⌛

A Flutter package to create a customizable timer.

<br>

## 🎉 Features

- Timer controller.
- Auto count up / down timer.
- Custom builders.

<br>

## 📌 Simple Usage

<br>

![example1](https://user-images.githubusercontent.com/44307990/147802076-3206db9d-d5f6-4ce4-a3f9-7e139910d822.gif)

<br>

```dart
final CustomTimerController _controller = CustomTimerController();
```

```dart
CustomTimer(
  controller: _controller,
  begin: Duration(days: 1),
  end: Duration(),
  builder: (time) {
    return Text(
      "${time.hours}:${time.minutes}:${time.seconds}.${time.milliseconds}",
      style: TextStyle(fontSize: 24.0)
    );
  }
)
```

Now you can use the controller methods `start()`, `pause()` and `reset()`. You can also add listeners to state changes or just use the `state` property when you need it.

<br>

## 📌 Using StateBuilder and AnimationBuilder 

<br>

![example2](https://user-images.githubusercontent.com/44307990/147802147-9b20e440-7a10-435f-a389-5310458af24c.gif)

<br>

```dart
CustomTimer(
  controller: _controller,
  begin: Duration(days: 1),
  end: Duration(),
  builder: (time) {
    return Text(
      "${time.hours}:${time.minutes}:${time.seconds}.${time.milliseconds}",
      style: TextStyle(fontSize: 24.0)
    );
  },
  stateBuilder: (time, state) {
    // This builder is shown when the state is different from "couting".
    if(state == CustomTimerState.paused) return Text(
      "The timer is paused",
      style: TextStyle(fontSize: 24.0)
    );

    // If null is returned, "builder" is displayed.
    return null;
  },
  animationBuilder: (child) {
    // You can define your own state change animations.
    // Remember to return the child widget of the builder.
    return AnimatedSwitcher(
      duration: Duration(milliseconds: 250),
      child: child,
    );
  },
  onChangeState: (state){
    // This callback function runs when the timer state changes.
    print("Current state: $state");
  }
)
```

<br>

## 🔧 Installation

Add this to your package's pubspec.yaml file:
```yaml
dependencies:
  custom_timer: ^0.1.2
```

Install it:
```yaml
$ flutter pub get
```

Import the package in your project:
```
import 'package:custom_timer/custom_timer.dart';
```


<br>

## 🙇 Author

<br>

Hi there 👋 This package is in development so if you find a bug or have a suggestion please let me know so we can improve it! 😃 If you want to motivate me to continue, you can give me a cup of coffee ☕ and I will get a lot of energy out of it.

<br>
<a href="https://www.buymeacoffee.com/federicodesia" target="_blank"><img src="https://www.buymeacoffee.com/assets/img/custom_images/purple_img.png" alt="Buy Me A Coffee" style="height: auto !important;width: auto !important;" ></a>