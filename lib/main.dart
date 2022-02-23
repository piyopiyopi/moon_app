import 'package:flutter/material.dart';
import 'package:new_gradient_app_bar/new_gradient_app_bar.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "MoonApp",
      theme: ThemeData.light(),
      home: Scaffold(
        appBar: NewGradientAppBar(
          gradient: LinearGradient(
            colors: [Colors.lightBlue.shade200, Colors.deepPurple.shade200],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        body: Container(
          text: "aaaaaaaaaa",
        ),
      ),
    );
  }
}
