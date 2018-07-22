import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:timer/primaryComponents/timer.dart' as timerWidget;
import 'package:timer/primaryComponents/stopwatch.dart' as stopwatchWidget;

import 'package:timer/secondaryComponents/duration.dart';
import 'package:timer/secondaryComponents/durationDisplay.dart';
import 'package:timer/secondaryComponents/durationPicker.dart';

void main() {
  //Force App In Portrait Mode
  /*
  SystemChrome.setPreferredOrientations(
    [
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ],
  );
  */

  //Run our App
  runApp(
    new MaterialApp(
      title: "Timer and Stopwatch",
      theme: ThemeData.dark(),
      home: new MainApp(),
    ),
  );
}

//-------------------------MAIN-------------------------

class MainApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    void _openTimer() {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) {
            return TimerExample();
          },
        ),
      );
    }

    void _openStopwatch() {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) {
            return StopwatchExample();
          },
        ),
      );
    }

    return new Scaffold(
      body: new Container(
        alignment: Alignment.center,
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            new RaisedButton(
              padding: EdgeInsets.all(8.0),
              onPressed: _openTimer,
              child: new Text(
                "Timer",
                style: new TextStyle(
                  fontSize: 48.0,
                ),
              ),
            ),
            new RaisedButton(
              padding: EdgeInsets.all(8.0),
              onPressed: _openStopwatch,
              child: new Text(
                "Stopwatch",
                style: new TextStyle(
                  fontSize: 48.0,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

//-------------------------TIMER EXAMPLE-------------------------

class TimerExample extends StatelessWidget {
  final timerWidget.Timer timer = new timerWidget.Timer();

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        title: Text('Timer'),
      ),
      body: new Stack(
        children: <Widget>[
          timer,
          TimerUI(
            timer: timer,
          ),
        ],
      ),
    );
  }
}

class TimerUI extends StatefulWidget {
  final timerWidget.Timer timer;

  TimerUI({
    @required this.timer,
  });

  @override
  _TimerUIState createState() => _TimerUIState();
}

class _TimerUIState extends State<TimerUI> {
  final GlobalKey<ScaffoldState> _timerKey = new GlobalKey<ScaffoldState>();

  DurationPicker picker;

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      key: _timerKey,
      body: new Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          new Row(
            children: <Widget>[
              new Expanded(
                child: Container(
                  child: new Text(""),
                ),
              ),
              new RaisedButton(
                onPressed: () {
                  setState(() {
                    if (widget.timer.functions.isRunning())
                      widget.timer.functions.stop();
                    else
                      widget.timer.functions.start();
                  });
                },
                child: new Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    (widget.timer.functions.isRunning())
                        ? Icon(Icons.stop)
                        : Icon(Icons.play_arrow),
                    (widget.timer.functions.isRunning())
                        ? Text("Stop")
                        : Text("Start"),
                  ],
                ),
              ),
              new Container(
                width: 16.0,
                child: new Text(""),
              ),
              new RaisedButton(
                onPressed: () => widget.timer.functions.reset(),
                child: new Text("Reset"),
              ),
              new Expanded(
                child: Container(
                  child: new Text(""),
                ),
              ),
            ],
          ),
          new FlatButton(
            onPressed: () {
              showModalBottomSheet<void>(
                context: context,
                builder: (BuildContext context) {
                  picker = new DurationPicker(
                    initialDuration: widget.timer.functions.getOriginalTime(),
                    onConfirm: () {
                      widget.timer.functions.set(picker.getDuration());
                      Navigator.pop(context);
                    },
                    onCancel: () => Navigator.pop(context),
                  );
                  return picker;
                },
              );
            },
            child: new Container(
              padding: EdgeInsets.only(top: 8.0, bottom: 8.0),
              child: new DurationDisplay(
                value: widget.timer.functions.getTimeLeft,
              ),
            ),
          ),
          new Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              new FlatButton(
                onPressed: () => showInSnackBar(
                  _timerKey,
                  "Original Time",
                  getStringFromDuration(
                      widget.timer.functions.getOriginalTime()),
                ),
                child: new Text("Original Time"),
              ),
              new Text("="),
              new FlatButton(
                onPressed: () => showInSnackBar(
                  _timerKey,
                  "Time Passed",
                  getStringFromDuration(
                      widget.timer.functions.getTimePassed()),
                ),
                child: new Text("Time Passed"),
              ),
              new Text("+"),
              new FlatButton(
                onPressed: () => showInSnackBar(
                  _timerKey,
                  "Time Left",
                  getStringFromDuration(
                      widget.timer.functions.getTimeLeft()),
                ),
                child: new Text("Time Left"),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

//-------------------------STOPWATCH EXAMPLE-------------------------

class StopwatchExample extends StatelessWidget {
  final stopwatchWidget.Stopwatch stopwatch = new stopwatchWidget.Stopwatch();

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: new Stack(
        children: <Widget>[
          stopwatch,
          StopwatchUI(
            stopwatch: stopwatch,
          ),
        ],
      ),
    );
  }
}

class StopwatchUI extends StatefulWidget {
  final stopwatchWidget.Stopwatch stopwatch;

  StopwatchUI({
    @required this.stopwatch,
  });

  @override
  _StopwatchUIState createState() => _StopwatchUIState();
}

class _StopwatchUIState extends State<StopwatchUI> {
  final GlobalKey<ScaffoldState> _stopwatchKey = new GlobalKey<ScaffoldState>();

  DurationPicker picker;

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      key: _stopwatchKey,
      appBar: AppBar(
        title: Text('Stopwatch'),
      ),
      body: new Container(
          alignment: Alignment.center,
          child: new Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              new Row(
                children: <Widget>[
                  new Expanded(
                      child: Container(
                    child: new Text(""),
                  )),
                  new RaisedButton(
                      onPressed: () {
                        setState(() {
                          if (widget.stopwatch.functions.isRunning())
                            widget.stopwatch.functions.stop();
                          else
                            widget.stopwatch.functions.start();
                        });
                      },
                      child: new Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          (widget.stopwatch.functions.isRunning())
                              ? Icon(Icons.stop)
                              : Icon(Icons.play_arrow),
                          (widget.stopwatch.functions.isRunning())
                              ? Text("Stop")
                              : Text("Start"),
                        ],
                      )),
                  new Container(
                    width: 16.0,
                    child: new Text(""),
                  ),
                  new RaisedButton(
                    onPressed: () => widget.stopwatch.functions.reset(),
                    child: new Text("Reset"),
                  ),
                  new Expanded(
                      child: Container(
                    child: new Text(""),
                  )),
                ],
              ),
              new FlatButton(
                onPressed: () {
                  showModalBottomSheet<void>(
                    context: context,
                    builder: (BuildContext context) {
                      picker = new DurationPicker(
                        initialDuration:
                            widget.stopwatch.functions.getMaxTime(),
                        titleText: "Set Max Duration",
                        onConfirm: () {
                          widget.stopwatch.functions
                              .setMaxTime(picker.getDuration());
                          Navigator.pop(context);
                        },
                        onCancel: () => Navigator.pop(context),
                      );
                      return picker;
                    },
                  );
                },
                child: new Container(
                  padding: EdgeInsets.only(top: 8.0, bottom: 8.0),
                  child: new DurationDisplay(
                    value: widget.stopwatch.functions.getTimePassed,
                  ),
                ),
              ),
              new FlatButton(
                onPressed: () => showInSnackBar(
                  _stopwatchKey,
                  "Time Passed",
                  getStringFromDuration(widget.stopwatch.functions.getTimePassed()),
                ),
                child: new Text("Time Passed"),
              ),
            ],
          )),
    );
  }
}

//-------------------------SNACKBAR-------------------------

showInSnackBar(GlobalKey<ScaffoldState> key, String message, String value) {
  key.currentState.showSnackBar(
    new SnackBar(
      content: new RichText(
        text: new TextSpan(
          children: [
            new TextSpan(
              text: message,
            ),
            new TextSpan(
              text: value,
            ),
          ],
        ),
      ),
    ),
  );
}
