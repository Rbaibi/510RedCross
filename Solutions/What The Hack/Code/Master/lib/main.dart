import 'package:flutter/material.dart';
import 'package:fiveten/pages/homescreen.dart';
import 'package:fiveten/pages/MapPage.dart';

void main() {
  runApp(MaterialApp(
      title: 'LifeLine',
      home: MyApp(),
      routes: <String, WidgetBuilder>{
        MapPage.route: (BuildContext context) => MapPage()
      }));
}

class MyApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return HomeScreen();
  }
}
