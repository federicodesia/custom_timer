import 'package:flutter/material.dart';
import 'package:custom_timer/custom_timer.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with SingleTickerProviderStateMixin {
  late CustomTimerController _controller = CustomTimerController(
    vsync: this,
    begin: Duration(seconds: 1),
    end: Duration(seconds: 12),
    initialState: CustomTimerState.reset,
    interval: CustomTimerInterval.milliseconds
  );

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

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
                builder: (state, remaining) {
                  // Build the widget you want!
                  return Column(
                    children: [
                      Text("${state.name}", style: TextStyle(fontSize: 24.0)),
                      Text(
                          "${remaining.hours}:${remaining.minutes}:${remaining.seconds}.${remaining.milliseconds}",
                          style: TextStyle(fontSize: 24.0))
                    ],
                  );
                }),
            SizedBox(height: 24.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                RoundedButton(
                  text: "Start",
                  color: Colors.green,
                  onPressed: () => _controller.start(),
                ),
                RoundedButton(
                  text: "Pause",
                  color: Colors.blue,
                  onPressed: () => _controller.pause(),
                ),
                RoundedButton(
                  text: "Reset",
                  color: Colors.red,
                  onPressed: () => _controller.reset(),
                )
              ],
            ),
            SizedBox(height: 12.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                RoundedButton(
                  text: "Begin 5s",
                  color: Colors.purple,
                  onPressed: () => _controller.begin = Duration(seconds: 5),
                ),
                RoundedButton(
                  text: "End 5s",
                  color: Colors.purple,
                  onPressed: () => _controller.end = Duration(seconds: 5),
                ),
              ],
            ),
            SizedBox(height: 12.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                RoundedButton(
                  text: "Jump to 5s",
                  color: Colors.indigo,
                  onPressed: () => _controller.jumpTo(Duration(seconds: 5)),
                ),
                RoundedButton(
                  text: "Finish",
                  color: Colors.orange,
                  onPressed: () => _controller.finish(),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}

class RoundedButton extends StatelessWidget {
  final String text;
  final Color color;
  final void Function()? onPressed;

  RoundedButton({required this.text, required this.color, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      child: Text(text, style: TextStyle(color: Colors.white)),
      style: TextButton.styleFrom(
        backgroundColor: color,
        padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 24.0),
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      ),
      onPressed: onPressed,
    );
  }
}
