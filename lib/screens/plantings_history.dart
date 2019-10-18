import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart';
import 'dart:convert';
import 'package:shimmer/shimmer.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/planting_history.dart';

class PlantingsHistory extends StatefulWidget {
  static const routeName = '/plantings';

  @override
  _PlantingsHistoryState createState() => _PlantingsHistoryState();
}

class _PlantingsHistoryState extends State<PlantingsHistory> {
  var _isInit = true;
  var _isLoading = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });
      Provider.of<PlantingHistory>(context).fetchAndSetPlantings().then((_) {
        setState(() {
          _isLoading = false;
        });
      });
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final plantings = Provider.of<PlantingHistory>(context);

    return Scaffold(
        body: Stack(
      children: <Widget>[
        ClipRRect(
          borderRadius:
              new BorderRadius.only(bottomLeft: const Radius.circular(50.0)),
          child: Container(
            width: double.infinity,
            height: MediaQuery.of(context).size.height / 7,
            margin: EdgeInsets.all(0),
            color: Color.fromRGBO(144, 201, 82, 1),
            child: Container(
              margin: EdgeInsets.all(30),
              child: Text(
                "Minhas plantas",
                style: TextStyle(
                    fontSize: 40,
                    color: Colors.white,
                    fontWeight: FontWeight.w500),
                textAlign: TextAlign.left,
              ),
            ),
          ),
        ),
      ],
    ));
  }
}
