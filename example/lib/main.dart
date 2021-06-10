import 'package:flutter/material.dart';
import 'package:custom_timer/custom_timer.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

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
              interval: Duration(seconds: 1),
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
                MaterialButton(
                  child: Text("Start", style: TextStyle(color: Colors.white)),
                  onPressed: () => _controller.start(),
                  color: Colors.green,
                ),
                MaterialButton(
                  child: Text("Pause", style: TextStyle(color: Colors.white)),
                  onPressed: () => _controller.pause(),
                  color: Colors.blue,
                ),
                MaterialButton(
                  child: Text("Reset", style: TextStyle(color: Colors.white)),
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
}
