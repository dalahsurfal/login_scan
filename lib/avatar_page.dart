import 'dart:typed_data';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AvatarPage extends StatefulWidget {
  AvatarPage({this.url, this.size});

  final String url;
  final double size;

  @override
  State<StatefulWidget> createState() => _AvatarPageState();
}

class _AvatarPageState extends State<AvatarPage> {
  Future<Uint8List> fetchAvatar() async {
    http.Response response = await http.get(widget.url);
    return response.bodyBytes;
  }

  Widget loadingWidget() {
    return FutureBuilder<Uint8List>(
      future: fetchAvatar(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Image.memory(snapshot.data);
        } else if (snapshot.hasError) {
          print('${snapshot.error}');
          return Center(
            child: Text('Error'),
          );
        } else {
          return Container(
            padding: EdgeInsets.all((widget.size - 50.0) / 2.0),
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: widget.size,
        height: widget.size,
        decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: Colors.deepPurple, width: 3.0),
            gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.transparent, Colors.deepPurple])),
        child: ClipOval(
          child: loadingWidget(),
        ),
      ),
    );
  }
}
