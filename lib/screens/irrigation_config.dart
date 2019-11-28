import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'dart:convert';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:shared_preferences/shared_preferences.dart';
import './loading.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';

class IrrigationConfig extends StatefulWidget {
  static const routeName = '/irrigation-config';

  @override
  _IrrigationConfigState createState() => _IrrigationConfigState();
}

class _IrrigationConfigState extends State<IrrigationConfig> {
  bool irrigationStatus = false;
  var _isLoading = false;

  Future<void> _getSmartIrrigationStatus() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final authTokens =
        json.decode(prefs.get('authTokens')) as Map<String, Object>;
    final accessToken = authTokens['accessToken'];

    try {
      Response response = await get(
        'http://192.168.0.8:5002/api/app/get_smart_irrigation_status',
        headers: {'Authorization': 'Bearer $accessToken'},
      );

      final data = json.decode(response.body);

      setState(() {
        irrigationStatus = data['smart_irrigation_status'];
        _isLoading = false;
      });
    } catch (error) {
      throw error;
    }
  }

  Future<void> _setSmartIrrigation() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final authTokens =
        json.decode(prefs.get('authTokens')) as Map<String, Object>;
    final accessToken = authTokens['accessToken'];

    try {
      await post(
        'http://192.168.0.8:5002/api/app/switch_smart_irrigation',
        headers: {'Authorization': 'Bearer $accessToken'},
      );

      await _getSmartIrrigationStatus();
    } catch (error) {
      throw error;
    }
  }

  @override
  void initState() {
    _isLoading = true;
    super.initState();
    _getSmartIrrigationStatus();
  }

  @override
  Widget build(BuildContext context) {
    double defaultScreenWidth = 420.0;
    double defaultScreenHeight = 830.0;
    ScreenUtil.instance = ScreenUtil(
      width: defaultScreenWidth,
      height: defaultScreenHeight,
      allowFontScaling: true,
    )..init(context);

    return Scaffold(
        body: Stack(
      children: <Widget>[
        ClipRRect(
          borderRadius:
              new BorderRadius.only(bottomRight: const Radius.circular(150.0)),
          child: Container(
            width: double.infinity,
            margin: EdgeInsets.all(0),
            color: Color.fromRGBO(144, 201, 82, 1),
            child: Column(
              children: <Widget>[
                Container(
                  alignment: Alignment(ScreenUtil.instance.setWidth(-0.8),
                      ScreenUtil.instance.setHeight(0)),
                  margin: EdgeInsets.only(
                      top: ScreenUtil.instance.setHeight(40.0),
                      left: ScreenUtil.instance.setWidth(0)),
                  child: Text(
                    "Irrigação",
                    style: TextStyle(
                        fontSize: ScreenUtil.instance.setSp(45),
                        color: Colors.white,
                        fontWeight: FontWeight.w500),
                    textAlign: TextAlign.left,
                  ),
                ),
                Container(
                  width: ScreenUtil.instance.setWidth(350),
                  height: ScreenUtil.instance.setHeight(75),
                  alignment: Alignment(ScreenUtil.instance.setWidth(-0.5),
                      ScreenUtil.instance.setHeight(0)),
                  color: Color.fromRGBO(166, 166, 166, 1),
                  margin:
                      EdgeInsets.only(top: ScreenUtil.instance.setHeight(50.0)),
                  child: Row(
                    children: <Widget>[
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          _isLoading
                              ? Container(
                                  margin: EdgeInsets.only(
                                      left: ScreenUtil.instance.setWidth(10.0),
                                      right: ScreenUtil.instance.setWidth(5.0)),
                                  child: CircularProgressIndicator(
                                    backgroundColor:
                                        Color.fromRGBO(144, 201, 82, 1),
                                    valueColor:
                                        new AlwaysStoppedAnimation<Color>(
                                            Colors.white),
                                  ),
                                )
                              : Container(
                                  margin: EdgeInsets.only(
                                      left: ScreenUtil.instance.setWidth(3.0)),
                                  width: ScreenUtil.instance.setWidth(60.0),
                                  child: Checkbox(
                                    activeColor:
                                        Color.fromRGBO(144, 201, 82, 1),
                                    checkColor: Colors.white,
                                    value: irrigationStatus,
                                    onChanged: (bool value) {
                                      _setSmartIrrigation();
                                    },
                                  )),
                        ],
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          Container(
                            margin: EdgeInsets.only(
                                left: ScreenUtil.instance.setWidth(05.0)),
                            width: ScreenUtil.instance.setWidth(250.0),
                            child: Text(
                              'Irrigação sob demanda',
                              style: TextStyle(
                                  fontSize: ScreenUtil.instance.setSp(26.0),
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Row(
                  children: <Widget>[
                    Container(
                      alignment: Alignment(ScreenUtil.instance.setWidth(-0.5),
                          ScreenUtil.instance.setHeight(0)),
                      color: Colors.white,
                      margin: EdgeInsets.only(
                          top: ScreenUtil.instance.setHeight(0.0),
                          left: ScreenUtil.instance.setWidth(35.0)),
                      padding: EdgeInsets.all(ScreenUtil.instance.setWidth(30)),
                      width: ScreenUtil.instance.setWidth(350),
                      height: ScreenUtil.instance.setHeight(200),
                      child: Text(
                        'Irrigar sempre que a umidade estiver baixa.\n\nVocê será notificado sempre que as mudas forem irrigadas.',
                        style: TextStyle(
                            fontSize: ScreenUtil.instance.setSp(23.0),
                            fontWeight: FontWeight.w400,
                            color: Color(0xff575757)),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
        // new Expanded(
        //   child: _isLoading ? LoadingScreen() : PlantingsGrid(),
        // ),
      ],
    ));
  }
}
