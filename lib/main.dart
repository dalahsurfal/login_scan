import 'package:flutter/material.dart';
import 'auth.dart';
import 'auth_provider.dart';
import 'root_page.dart';
import 'package:login_scan/screens/cart.dart';
import 'package:login_scan/models/cart.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:login_scan/screens/catalog.dart';

void main() {
  final cart = CartModel();
  runApp(
    ScopedModel<CartModel>(
      model: cart,
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AuthProvider(
      auth: Auth(),
      child:  MaterialApp(
        title: "Login",
        theme: ThemeData(
          primarySwatch: Colors.deepPurple,
          textTheme: TextTheme(
            display4: TextStyle(
              fontFamily: 'Corben',
              fontWeight: FontWeight.w700,
              fontSize: 24,
              color: Colors.white,
            ),
          ),
        ),
        initialRoute: '/',
        routes: {
          '/': (context) => RootPage(),
          '/cart': (context) => MyCart(),
          '/catalog': (context) => MyCatalog(),
        },
      ),
    );
  }
}
