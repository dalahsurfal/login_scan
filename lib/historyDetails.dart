import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'auth_provider.dart';

class HistoryDetails extends StatefulWidget{
  @override
  _HistoryDetailsState createState() => _HistoryDetailsState();
}

class _HistoryDetailsState extends State<HistoryDetails> {
  final savedTimeReference = FirebaseDatabase.instance.reference();

  @override
  Widget build(BuildContext context) {

    String uid = AuthProvider.of(context).auth.currentUserId;
    savedTimeReference
        .child(uid)
        .orderByChild('description')
        .once()
        .then((DataSnapshot snapshot) {
      print('Worked periods: ${snapshot.value}');
    });

    return Scaffold(
      resizeToAvoidBottomPadding: false,
      body: Column(
        children: <Widget>[
          Flexible(
            child: FirebaseAnimatedList(
              query: savedTimeReference.child(uid),
              itemBuilder: (BuildContext context, DataSnapshot snapshot,
                  Animation<double> animation, int index) {
                return new SizeTransition(
                  sizeFactor: animation,
                  child: Text('$index : ${snapshot.value.toString()}'),
                );
              },),
          )
        ],
      ),
    );
  }

}