import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:convert';
import 'package:shimmer/shimmer.dart';
import '../widgets/plantings_grid.dart';
import '../providers/plantings.dart';

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
      Provider.of<Plantings>(context).fetchAndSetPlantings().then((_) {
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
    return Scaffold(
        body: new Column(
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
        new Expanded(
          child: PlantingsGrid(),
        ),
      ],
    ));
  }
}
