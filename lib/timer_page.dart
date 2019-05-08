import 'package:flutter/material.dart';
import 'dart:async';
import 'package:firebase_database/firebase_database.dart';
import 'package:login_scan/auth_provider.dart';

class ElapsedTime {
  final int hundreds;
  final int seconds;
  final int minutes;
  final int hours;

  ElapsedTime({this.hundreds, this.seconds, this.minutes, this.hours});
}

class Dependencies {
  final List<ValueChanged<ElapsedTime>> timerListeners =
      <ValueChanged<ElapsedTime>>[];

  final TextStyle textStyle =
      const TextStyle(fontSize: 90.0, fontFamily: "Bebas Neue");

  final Stopwatch stopwatch = new Stopwatch();
  final int timerMillisecondsRefreshRate = 30;
  final List<String> savedTimeList = List<String>();
  var today = DateTime.now().toString().substring(0, 10);

  final savedTimeReference = FirebaseDatabase.instance.reference();
}

class TimerPage extends StatefulWidget {
  TimerPage({Key key}) : super(key: key);

  TimerPageState createState() => new TimerPageState();
}

class TimerPageState extends State<TimerPage> {
  final Dependencies dependencies = new Dependencies();
//  final WorkedHours workedHours = new WorkedHours('', '', '');

  void leftButtonPressed() {
    setState(() {
      if (dependencies.stopwatch.isRunning) {
        print("${dependencies.stopwatch.elapsed}");

        dependencies.savedTimeList
            .insert(0, "${dependencies.stopwatch.elapsed}");

        dependencies.stopwatch.stop();

        dependencies.savedTimeReference.child('${AuthProvider.of(context).auth.currentUserId}').push().set({
          'title': "${dependencies.stopwatch.elapsed}",
          'description': dependencies.today
        });
      } else {
        dependencies.stopwatch.reset();
      }
    });
  }

//  void findCurrentUid(){
//    final BaseAuth auth = AuthProvider.of(context).auth.currentUserId;
////   StreamBuilder<String>(
////      stream: auth.onAuthStateChanged,
////      builder: (BuildContext context, AsyncSnapshot<String> snapshot){
////        if(snapshot.connectionState == ConnectionState.active){
////          final bool isLoggedIn = snapshot.hasData;
//////          final String CurrentUid = snapshot.data;
////          return isLoggedIn ? HomePage() : LoginPage();
////        }
////        return _buildWaitingScreen();
////      },
////    );
//  }

  void rightButtonPressed() {
    setState(() {
      if (dependencies.stopwatch.isRunning) {
        dependencies.stopwatch.stop();
      } else {
        dependencies.stopwatch.start();
      }
    });
  }

  Widget buildFloatingButton(String text, VoidCallback callback) {
    TextStyle roundTextStyle =
        const TextStyle(fontSize: 16.0, color: Colors.white);
    return new FloatingActionButton(
        child: new Text(text, style: roundTextStyle), onPressed: callback);
  }

  @override
  Widget build(BuildContext context) {
    return new Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        new Expanded(
          child: new TimerText(dependencies: dependencies),
        ),
        new Expanded(
          flex: 0,
          child: new Padding(
            padding: const EdgeInsets.symmetric(vertical: 10.0),
            child: new Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                buildFloatingButton(
                    dependencies.stopwatch.isRunning ? "lap" : "reset",
                    leftButtonPressed),
                buildFloatingButton(
                    dependencies.stopwatch.isRunning ? "stop" : "start",
                    rightButtonPressed),
              ],
            ),
          ),
        ),
        new Expanded(
          child: ListView.builder(
              itemCount: dependencies.savedTimeList.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Container(
                    alignment: Alignment.center,
                    child: Text(
                      createListItemText(dependencies.savedTimeList.length,
                          index, dependencies.savedTimeList.elementAt(index)),
                      style: TextStyle(fontSize: 24.0),
                    ),
                  ),
                );
              }),
        ),
      ],
    );
  }

  String createListItemText(int listSize, int index, String time) {
    index = listSize - index;
    return 'Time ${dependencies.today} - ${time.substring(0, 7)}';
  }
}

class TimerText extends StatefulWidget {
  TimerText({this.dependencies});

  final Dependencies dependencies;

  TimerTextState createState() =>
      new TimerTextState(dependencies: dependencies);
}

class TimerTextState extends State<TimerText> {
  TimerTextState({this.dependencies});

  final Dependencies dependencies;
  Timer timer;
  int milliseconds;

  @override
  void initState() {
    timer = new Timer.periodic(
        new Duration(milliseconds: dependencies.timerMillisecondsRefreshRate),
        callback);
    super.initState();
  }

  @override
  void dispose() {
    timer?.cancel();
    timer = null;
    super.dispose();
  }

  void callback(Timer timer) {
    if (milliseconds != dependencies.stopwatch.elapsedMilliseconds) {
      milliseconds = dependencies.stopwatch.elapsedMilliseconds;
      final int hundreds = (milliseconds / 10).truncate();
      final int seconds = (hundreds / 100).truncate();
      final int minutes = (seconds / 60).truncate();
      final int hours = (minutes / 60).truncate();
      final ElapsedTime elapsedTime = new ElapsedTime(
        hundreds: hundreds,
        seconds: seconds,
        minutes: minutes,
        hours: hours,
      );
      for (final listener in dependencies.timerListeners) {
        listener(elapsedTime);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return new Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        new RepaintBoundary(
          child: new SizedBox(
            height: 72.0,
            child: new MinutesSecondsHours(dependencies: dependencies),
          ),
        ),
//        new RepaintBoundary(
//          child: new SizedBox(
//            height: 72.0,
//            child: new Hundreds(dependencies: dependencies),
//          ),
//        ),
      ],
    );
  }
}

class MinutesSecondsHours extends StatefulWidget {
  MinutesSecondsHours({this.dependencies});

  final Dependencies dependencies;

  MinutesSecondsHoursState createState() =>
      new MinutesSecondsHoursState(dependencies: dependencies);
}

class MinutesSecondsHoursState extends State<MinutesSecondsHours> {
  MinutesSecondsHoursState({this.dependencies});

  final Dependencies dependencies;

  int minutes = 0;
  int seconds = 0;
  int hours = 0;

  @override
  void initState() {
    dependencies.timerListeners.add(onTick);
    super.initState();
  }

  void onTick(ElapsedTime elapsed) {
    if (elapsed.minutes != minutes ||
        elapsed.seconds != seconds ||
        elapsed.hours != hours) {
      setState(() {
        minutes = elapsed.minutes;
        seconds = elapsed.seconds;
        hours = elapsed.hours;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    String minutesStr = (minutes % 60).toString().padLeft(2, '0');
    String secondsStr = (seconds % 60).toString().padLeft(2, '0');
    String hoursStr = (hours % 60).toString().padLeft(2, '0');
    return new Text('$hoursStr:$minutesStr:$secondsStr',
        style: dependencies.textStyle);
  }
}
