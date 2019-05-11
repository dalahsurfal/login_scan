import 'package:flutter/material.dart';
import 'auth.dart';
import 'timer_page.dart';
import 'package:login_scan/auth.dart';
import 'package:flutter/rendering.dart';
import 'auth_provider.dart';
import 'package:firebase_database/firebase_database.dart';
import 'historyDetails.dart';
import 'income.dart';

//import 'avatar_page.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final savedTimeReference = FirebaseDatabase.instance.reference();

  Future<void> _signOut(BuildContext context) async {
    try {
      final BaseAuth auth = AuthProvider.of(context).auth;
      await auth.signOut();
    } catch (e) {
      print(e);
    }
  }

  int currentTab = 0;
  TimerPage timerPage;
  HistoryDetails historyDetails;
  IncomePage incomePage;
  List<Widget> pages;
  Widget currentPage;

  @override
  void initState(){
    timerPage = TimerPage();
    historyDetails = HistoryDetails();
    incomePage = IncomePage();
    pages = [timerPage, historyDetails, incomePage];
    currentPage = timerPage;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
    String uid = AuthProvider.of(context).auth.currentUserId;
//    var url = 'https://robohash.org/$uid?set=set4';
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        centerTitle: true,
        title: Text('Welcome'),
        actions: <Widget>[
          FlatButton(
            child: Text(
              'Logout',
              style: TextStyle(fontSize: 17.0, color: Colors.white),
            ),
            onPressed: () => _signOut(context),
          )
        ],
      ),
      body: currentPage,
      bottomNavigationBar: BottomNavigationBar(
          currentIndex: currentTab,
          onTap: (int index) {
            setState(() {
              currentTab = index;
              currentPage = pages[index];
            });
          },
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              title: Text('Home'),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.list),
              title: Text('Details'),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.monetization_on),
              title: Text('Income'),
            )
          ]),
    );
  }
}
