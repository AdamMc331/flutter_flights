import 'package:flutter/material.dart';
import 'package:flutter_flights/air_asia_bar.dart';
import 'package:flutter_flights/rounded_button.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Flight Search',
      theme: new ThemeData(
        primarySwatch: Colors.red,
      ),
      home: new MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: new Stack(
        children: <Widget>[
          AirAsiaBar(height: 210.0),
          Positioned.fill(
            child: new Padding(
              padding: EdgeInsets.only(
                  top: MediaQuery.of(context).padding.top + 40),
              child: new Column(
                children: <Widget>[
                  _buildButtonsRow(),
                  Container(), //TODO: Implement a card
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildButtonsRow() {
    return Padding(
        padding: const EdgeInsets.all(8.0),
        child: new Row(
          children: <Widget>[
            new RoundedButton(text: "ONE WAY"),
            new RoundedButton(text: "ROUND"),
            new RoundedButton(text: "MULTICITY", isSelected: true),
          ],
        ));
  }
}
