import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'auth_provider.dart';

class HistoryDetails extends StatefulWidget {
  @override
  _HistoryDetailsState createState() => _HistoryDetailsState();
}

class _HistoryDetailsState extends State<HistoryDetails> {
  final savedTimeReference = FirebaseDatabase.instance.reference();

  @override
  Widget build(BuildContext context) {
    String uid = AuthProvider.of(context).auth.currentUserId;

    savedTimeReference.child(uid).once().then((DataSnapshot snapshot) {
      var uuids = snapshot.value.keys;
      for (var uuid in uuids) {
        var usrNames = snapshot.value[uuid].values;
        print('uuid: $uuid, usrName: $usrNames');
      }
    });

    List<Widget> buildTitle() {
      return [
        Text('History Details',
            style: Theme.of(context)
                .textTheme
                .display4
                .copyWith(color: Colors.black, fontSize: 30, fontFamily: "Bebas Neue")),
      ];
    }

    List<Widget> buildFlexible(){
      return[
        Flexible(
          child: FirebaseAnimatedList(
            query: savedTimeReference.child(uid),
            itemBuilder: (BuildContext context, DataSnapshot snapshot,
                Animation<double> animation, int index) {

              var uuids = snapshot.value.values; //(description, title)

              return new SizeTransition(
                sizeFactor: animation,
                child: ListTile(
                  title: Text('${index + 1}'),
                  subtitle: Text('$uuids',
                      style: TextStyle(fontSize: 18.0)),
                ),
              );
            },
          ),
        )
      ];
    }

    return Scaffold(
      resizeToAvoidBottomPadding: false,
      body: Container(
        padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 64),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: buildTitle() + buildFlexible(),
          ),
      ),
    );
  }
}
