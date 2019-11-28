import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class StatusDialog {
  static void show(String title, String text, BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(
            children: <Widget>[
              Text(
                title,
              ),
            ],
          ),
          content: Row(
            children: <Widget>[
              Container(
                child: Text(
                  text,
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
          actions: <Widget>[
            Container(
              margin: EdgeInsets.only(
                right: ScreenUtil.instance.setWidth(5.0),
              ),
              child: RaisedButton(
                textColor: Colors.white,
                child: Text('OK'),
                color: Color.fromRGBO(144, 201, 82, 1),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            )
          ],
        );
      },
    );
  }
}
