import 'package:flutter/material.dart';

class AirAsiaBar extends StatelessWidget {
  final double height;

  AirAsiaBar({
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        new Container(
          decoration: new BoxDecoration(
            gradient: new LinearGradient(
              colors: [Colors.red, const Color(0xFFE64C85)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          height: height,
        ),
        new AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0.0,
          centerTitle: true,
          title: new Text(
            "AirAsia",
            style: new TextStyle(
              fontFamily: 'NothingYouCouldDo',
              fontWeight: FontWeight.bold,
            ),
          ),
        )
      ],
    );
  }
}
