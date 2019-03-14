import 'package:flutter/material.dart';
import 'auth.dart';
import 'timer_page.dart';
import 'package:login_scan/auth.dart';
import 'package:flutter/rendering.dart';
import 'auth_provider.dart';

import 'avatar_page.dart';
import 'package:login_scan/screens/catalog.dart';
import 'package:login_scan/models/src/item.dart';
import 'dart:convert';
import 'package:convert/convert.dart';
import 'package:crypto/crypto.dart' as crypto;

class HomePage extends StatelessWidget {
  HomePage({this.auth, this.currentUserId});

  final BaseAuth auth;
  final String currentUserId;


  Future<void> _signOut(BuildContext context) async {
    try {
      final BaseAuth auth = AuthProvider.of(context).auth;
      await auth.signOut();
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
//    FirebaseUser user = await firebaseAuth.currentUser();
//    String currentUid = auth.currentUserId;

//    generates md5 hash from a String, in this case the current user id
//    generateMd5(String data) {
//      var content = new Utf8Encoder().convert(data);
//      var md5 = crypto.md5;
//      var digest = md5.convert(content);
//      return hex.encode(digest.bytes);
//    }
//
//    String hash = generateMd5(currentUid);
//    var url = 'https://www.gravatar.com/avatar/$hash?s=200&d=identicon';
    var url = 'https://robohash.org/$currentUserId?set=set4';
//    var avatar = AvatarPage(url: url, size: 150.0);

//    var balance = Card(
//        child: Column(
//          mainAxisSize: MainAxisSize.min,
//          children: <Widget>[
//            Container(
//              padding: EdgeInsets.only(top: 16.0),
//              child: new Row(
//                crossAxisAlignment: CrossAxisAlignment.start,
//                mainAxisAlignment: MainAxisAlignment.center,
//                children: <Widget>[
//                  new Text(
//                      '\$  ',
//                      style: new TextStyle(
//                        fontSize: 20.0,
//                        fontFamily: 'Roboto',
//                        color: new Color(0xFF26C6DA),
//                      )
//                  ),
//                  new Text(
//                    '3,435.23',
//                    style: new TextStyle(
//                        fontSize: 35.0,
//                        fontFamily: 'Roboto',
//                        color: new Color(0xFF26C6DA)
//                    ),
//                  )
//                ],
//              ),
//            ),
//            Text('general balance')
//          ],
//        ));

//    return AppBar(
//      title: Text('Welcome'),
//      backgroundColor: Colors.deepPurple,
////      floating: true,
//      actions: <Widget>[
//        IconButton(
//            icon: Icon(Icons.shopping_cart),
//            onPressed: () => Navigator.pushNamed(context, '/cart')),
//        FlatButton(
//          child: Text(
//            'Logout',
//            style: TextStyle(fontSize: 17.0, color: Colors.white),
//          ),
//          onPressed: _signedOut,
//        )
//      ],
//    );

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        centerTitle: true,
        title: Text('Welcome'),
        actions: <Widget>[
//          AvatarPage(url: url, size: 150.0),
          IconButton(
            icon: Icon(Icons.shopping_cart),
            onPressed: () => Navigator.pushNamed(context, '/cart'),
          ),
          FlatButton(
            child: Text(
              'Logout',
              style: TextStyle(fontSize: 17.0, color: Colors.white),
            ),
            onPressed: () => _signOut(context),
          )
        ],
      ),
      body: Container(
          child: new TimerPage()
      ),
    );
  }
}
