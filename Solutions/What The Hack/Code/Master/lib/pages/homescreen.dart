import 'package:flutter/material.dart';
import 'package:fiveten/main.dart';
import 'dart:io';
import 'package:fiveten/pages/MapPage.dart';

class HomeScreen extends State<MyApp> {
  static final String route = "/home";
  final description = File('./assets/description.txt').readAsString();
  @override
  Widget build(context) {

    return MaterialApp(
      routes: <String, WidgetBuilder>{
        MapPage.route : (context) => MapPage()
      },
      home: Scaffold(
        resizeToAvoidBottomPadding: true,
        appBar: AppBar(
            title: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('what_the_hack'),
          ],
        )),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Container(
              width: 1080,
              height: 200,
              child: Image.asset('assets/logo.png'),
            ),
            Container(
              width: 1000,
              alignment: Alignment(0, 0),
              child: FutureBuilder(
                  future: DefaultAssetBundle.of(context)
                      .loadString('./assets/description.txt'),
                  builder: (context, snapshot) {
                    return Column(
                      children: <Widget>[
                        Text(snapshot.data ?? 'Description not found',
                      softWrap: true, style: TextStyle(fontSize: 35), textAlign: TextAlign.center,),
                      Image.asset("assets/placeholder.png")],
                    );
                  }),
            ),
            SizedBox(
              height: 100,
              width: 600,
              child: RaisedButton(
                elevation: 40,
                color: Colors.lightGreen,
                onPressed: () {
                  print('Pressed Start');
                  Navigator.of(context).pushNamed('/mappage');
                },
                child: Text("Start Mission", style: TextStyle(fontSize: 30),),
                padding: EdgeInsets.all(20),
              ),
            )
          ],
        ),
      ),
    );
  }
}
