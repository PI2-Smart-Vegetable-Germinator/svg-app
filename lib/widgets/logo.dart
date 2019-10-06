import 'package:flutter/material.dart';

class LogoWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Color.fromRGBO(66, 76, 89, 1),
        borderRadius: BorderRadius.all(
          Radius.circular(10.0),
        ),
      ),
      width: 120,
      padding: EdgeInsets.all(15),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
            ),
            padding: EdgeInsets.all(25),
            child: Image.asset(
              'assets/logo.png',
              fit: BoxFit.fill,
            ),
          ),
          Text(
            "SVG",
            style: TextStyle(
              color: Colors.white,
              fontSize: 30.0,
              fontWeight: FontWeight.bold,
            ),
          )
        ],
      ),
    );
  }
}
