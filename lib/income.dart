import 'dart:math';

import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'auth_provider.dart';

class IncomePage extends StatefulWidget {
  @override
  _IncomePageState createState() => _IncomePageState();
}

class _IncomePageState extends State<IncomePage> {
  bool _listenerEnded;

  Widget totalHistory;

  @override
  void initState() {
    _listenerEnded = false;
    super.initState();
  }

  void _addToTotalHistoryWidgets(int workedMin, int workedSec) {
    setState(() {
      totalHistory = Text('Total worked time:\n $workedMin Min $workedSec Sec',
          style: Theme.of(context).textTheme.display4.copyWith(
              color: Colors.black, fontSize: 30, fontFamily: "Bebas Neue"));

    });

  }

  void stopListener(var listener){
      if(_listenerEnded){
        listener.cancel();
      }
  }

  void buildTotalHistory(String uid) {
    int workedMin = 0;
    int workedSec = 0;
    final savedTimeReference = FirebaseDatabase.instance.reference().child(uid);

    var listener = savedTimeReference.onValue.listen((Event event) {
      var value = event.snapshot.value;
      var uids = value.keys; //key of each registered set
      for (var uuid in uids) {
        var labels = value[uuid].keys; //(description, title)
        for (var label in labels) {   //"description" and then "title"
          if (label == "title") {
            var val = value[uuid][label]; //the value of "title" label
            var min = val.substring(2, 4);
            var sec = val.substring(5, 7);

            print('uuid: $uuid, minutes: $min, seconds: $sec');

            workedMin += int.parse(min);
            workedSec += int.parse(sec);
          }
        }
      }
      if (workedSec >= 60) {
        int fac = pow(10, 2); // fac=100
        var addMin = ((workedSec / 60)*fac).round()/fac;
        workedMin += addMin.toInt();
        workedSec =
            int.tryParse(addMin.toString().split('.')[1].substring(0, 1));
      }
      print('total min: $workedMin, total sec: $workedSec');
      _addToTotalHistoryWidgets(workedMin, workedSec);
      setState(() {
        _listenerEnded = true;
      });

    });

    stopListener(listener);

  }

  @override
  Widget build(BuildContext context) {

    String uid = AuthProvider.of(context).auth.currentUserId;

    buildTotalHistory(uid);
    bool notNull(Object o) => o != null;
    return new Scaffold(
        resizeToAvoidBottomPadding: false,
        body: Container(
          padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 64),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                totalHistory
              ].where(notNull).toList(),
          ),
        ),
    );
  }
}
