import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:convert';
import 'package:shimmer/shimmer.dart';
import '../widgets/plantings_grid.dart';
import '../providers/plantings.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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
    double defaultScreenWidth = 380.0;
    double defaultScreenHeight = 800.0;
    ScreenUtil.instance = ScreenUtil(
      width: defaultScreenWidth,
      height: defaultScreenHeight,
      allowFontScaling: true,
    )..init(context);

    return Scaffold(
        body: new Column(
      children: <Widget>[
        ClipRRect(
          borderRadius:
              new BorderRadius.only(bottomLeft: const Radius.circular(50.0)),
          child: Container(
            width: double.infinity,
            height: ScreenUtil.instance.setHeight(100.0),
            margin: EdgeInsets.all(0),
            color: Color.fromRGBO(144, 201, 82, 1),
            child: Container(
              margin: EdgeInsets.only(
                              top: ScreenUtil.instance.setHeight(25.0),
                              left: ScreenUtil.instance.setWidth(30.0)),
              child: Text(
                "Minhas plantas",
                style: TextStyle(
                    fontSize: ScreenUtil.instance.setSp(35),
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
