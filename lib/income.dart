import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'auth_provider.dart';

class IncomePage extends StatefulWidget {
  @override
  _IncomePageState createState() => _IncomePageState();
}

class _IncomePageState extends State<IncomePage> {
  final savedTimeReference = FirebaseDatabase.instance.reference();

  @override
  Widget build(BuildContext context) {

    String uid = AuthProvider.of(context).auth.currentUserId;

    savedTimeReference.child(uid).onValue.listen((Event event){
      var value = event.snapshot.value;
      var uuids = value.keys; //key of each registered set
      for(var uuid in uuids){
        var labels = value[uuid].keys; //(description, title)
        for(var label in labels){ //"description" and then "title"
          if(label == "title"){
            var val = value[uuid][label]; //the value of "title" label
            print('uuid: $uuid, data: $val');
          }
        }
      }
    });

    return Container();
  }
}
