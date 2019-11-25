import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'dart:convert';
import 'package:shimmer/shimmer.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:fluttertoast/fluttertoast.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _plantingName = '';
  int _plantingId = 0;
  int _plantingTime = 0;
  int _remainingDays = 0;
  int _currentHumidity = 0;
  int _currentTemperature = 0;
  bool _currentlyBacklit = null;
  int _hoursBacklit = 0;
  int _sproutedSeedlings = 0;
  var _activePlanting = false;
  var _isLoading = false;
  var _loadPage = false;
  var _image;

  Future<void> _getCurrentInfo() async {
    _isLoading = true;
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final authTokens =
        json.decode(prefs.get('authTokens')) as Map<String, Object>;
    final accessToken = authTokens['accessToken'];

    try {
      Response response =
          await get('http://192.168.0.8:5002/api/current-info', headers: {
        'Authorization': 'Bearer $accessToken',
      });

      final data = json.decode(response.body);

      setState(() {
        _plantingId = data['data']['planting_id'];
        _currentHumidity = data['data']['current_humidity'];
        _currentTemperature = data['data']['current_temperature'];
        _currentlyBacklit = data['data']['currently_backlit'];
        _remainingDays = data['data']['cycle_remaining_days'];
        _hoursBacklit = data['data']['hours_backlit'];
        _plantingName = data['data']['planting_name'];
        _plantingTime = data['data']['planting_time'];
        _activePlanting = data['data']['active_planting'];
        _sproutedSeedlings = data['data']['sprouted_seedlings'];
        _isLoading = false;
      });
    } catch (e) {
      _isLoading = false;
      print(e);
    }
  }

  Future<void> _getCurrentImage() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final authTokens =
        json.decode(prefs.get('authTokens')) as Map<String, Object>;
    final accessToken = authTokens['accessToken'];

    Response response = await get('http://192.168.0.8:5002/api/get-image',
        headers: {'Authorization': 'Bearer $accessToken'});
    final data = response.bodyBytes;

    setState(() {
      _image = data;
      _isLoading = false;
    });
  }

  Future<void> startIrrigation() async {
    var payload = {'plantingId': this._plantingId};

    try {
      final response = await post(
        'http://192.168.0.8:5002/api/app/start_irrigation',
        body: json.encode(payload),
        headers: {"Content-Type": "application/json"},
      );

      await endIrrigation();
    } catch (error) {
      throw error;
    }
  }

  Future<void> startIllumination() async {
    var payload = {'plantingId': this._plantingId};

    try {
      final response = await post(
        'http://192.168.0.8:5002/api/app/switch_illumination',
        body: json.encode(payload),
        headers: {"Content-Type": "application/json"},
      );

      await _getCurrentInfo();
    } catch (error) {
      throw error;
    }
  }

  Future<void> endIrrigation() async {
    var payload = {'plantingId': this._plantingId};

    try {
      final response = await post(
        'http://192.168.0.8:5002/api/app/end_irrigation',
        body: json.encode(payload),
        headers: {"Content-Type": "application/json"},
      );
    } catch (error) {
      throw error;
    }
  }

  @override
  void initState() {
    _isLoading = true;
    super.initState();
    _getCurrentInfo();
    _getCurrentImage();
    _loadPage = true;
  }

  @override
  Widget build(BuildContext context) {
    double defaultScreenWidth = 400.0;
    double defaultScreenHeight = 810.0;
    ScreenUtil.instance = ScreenUtil(
      width: defaultScreenWidth,
      height: defaultScreenHeight,
      allowFontScaling: true,
    )..init(context);

    if (!_isLoading && _loadPage) {
      if (_activePlanting) {
        return Scaffold(
          floatingActionButton: Stack(
            children: <Widget>[
              Padding(
                padding:
                    EdgeInsets.only(left: ScreenUtil.instance.setWidth(31.0)),
                child: Align(
                  alignment: Alignment.bottomLeft,
                  child: FloatingActionButton.extended(
                      heroTag: 'iluminar',
                      onPressed: () {
                        Fluttertoast.showToast(
                            msg: _currentlyBacklit
                                ? "A SVG desligará a iluminação!"
                                : "A SVG acionará a iluminação!",
                            toastLength: Toast.LENGTH_LONG,
                            gravity: ToastGravity.BOTTOM,
                            timeInSecForIos: 1,
                            backgroundColor: Color.fromRGBO(78, 78, 78, 1),
                            textColor: Colors.white,
                            fontSize: 18.0);
                        startIllumination();
                      },
                      label: Text('Iluminar',
                          style: TextStyle(
                              fontSize: ScreenUtil.instance.setSp(16.0))),
                      icon: Icon(
                        Icons.brightness_high,
                        size: ScreenUtil.instance.setSp(30.0),
                      ),
                      backgroundColor: _currentlyBacklit
                          ? Colors.orangeAccent
                          : Colors.grey),
                ),
              ),
              Align(
                alignment: Alignment.bottomRight,
                child: FloatingActionButton.extended(
                  heroTag: 'irrigar',
                  onPressed: () {
                    startIrrigation();
                    Fluttertoast.showToast(
                        msg: "A SVG iniciará a irrigação em breve!",
                        toastLength: Toast.LENGTH_LONG,
                        gravity: ToastGravity.BOTTOM,
                        timeInSecForIos: 1,
                        backgroundColor: Color.fromRGBO(78, 78, 78, 1),
                        textColor: Colors.white,
                        fontSize: 18.0);
                  },
                  label: Text('Irrigar',
                      style:
                          TextStyle(fontSize: ScreenUtil.instance.setSp(16.0))),
                  icon: Icon(
                    Icons.opacity,
                    size: ScreenUtil.instance.setSp(30.0),
                  ),
                  backgroundColor: Colors.blueAccent,
                ),
              ),
            ],
          ),
          body: Stack(
            children: <Widget>[
              ClipRRect(
                borderRadius: new BorderRadius.only(
                    bottomLeft: const Radius.circular(50.0)),
                child: Container(
                  width: double.infinity,
                  height: ScreenUtil.instance.setHeight(215.0),
                  margin: EdgeInsets.all(0),
                  color: Color.fromRGBO(144, 201, 82, 1),
                  child: Column(
                    children: <Widget>[
                      Container(
                        width: double.infinity,
                        margin: EdgeInsets.only(
                            left: ScreenUtil.instance.setWidth(30),
                            right: ScreenUtil.instance.setWidth(30.0),
                            top: ScreenUtil.instance.setHeight(40.0)),
                        child: _isLoading
                            ? Shimmer.fromColors(
                                baseColor: Colors.grey[500],
                                highlightColor: Colors.white,
                                child: Container(
                                  width: double.infinity,
                                  height: ScreenUtil.instance.setHeight(30.0),
                                  color: Colors.white70,
                                ),
                              )
                            : Text(
                                _plantingTime.toString() + " dias de estufa",
                                style: TextStyle(
                                    fontSize: ScreenUtil.instance.setSp(38.0),
                                    color: Colors.white,
                                    fontWeight: FontWeight.w500),
                                textAlign: TextAlign.left,
                              ),
                      ),
                      Container(
                        width: double.infinity,
                        margin: EdgeInsets.only(
                            left: ScreenUtil.instance.setWidth(30),
                            right: ScreenUtil.instance.setWidth(30.0),
                            top: ScreenUtil.instance.setHeight(22.0)),
                        child: _isLoading
                            ? Shimmer.fromColors(
                                baseColor: Colors.grey[500],
                                highlightColor: Colors.white,
                                child: Container(
                                  width: double.infinity,
                                  height: ScreenUtil.instance.setHeight(25.0),
                                  color: Colors.white70,
                                ),
                              )
                            : Text(
                                _sproutedSeedlings.toString() +
                                    "% das mudas germinaram",
                                style: TextStyle(
                                    fontSize: ScreenUtil.instance.setSp(19.0),
                                    color: Colors.white,
                                    fontWeight: FontWeight.w500),
                                textAlign: TextAlign.left,
                              ),
                      ),
                      Container(
                        width: double.infinity,
                        margin: EdgeInsets.only(
                            left: ScreenUtil.instance.setWidth(30),
                            right: ScreenUtil.instance.setWidth(30.0),
                            top: ScreenUtil.instance.setHeight(10.0)),
                        child: _isLoading
                            ? Shimmer.fromColors(
                                baseColor: Colors.grey[500],
                                highlightColor: Colors.white,
                                child: Container(
                                  width: double.infinity,
                                  height: ScreenUtil.instance.setHeight(25.0),
                                  color: Colors.white70,
                                ),
                              )
                            : Text(
                                _remainingDays <= 0
                                    ? "Hora de colher suas mudas!"
                                    : _remainingDays.toString() +
                                        " dias até a colheita",
                                style: TextStyle(
                                    fontSize: ScreenUtil.instance.setSp(19.0),
                                    color: Colors.white,
                                    fontWeight: FontWeight.w500),
                                textAlign: TextAlign.left,
                              ),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                margin:
                    EdgeInsets.only(top: ScreenUtil.instance.setHeight(220.0)),
                child: GridView.count(
                  primary: false,
                  padding: EdgeInsets.all(ScreenUtil.instance.setWidth(20.0)),
                  mainAxisSpacing: ScreenUtil.instance.setWidth(15.0),
                  crossAxisCount: 1,
                  childAspectRatio: 2.65,
                  children: <Widget>[
                    Container(
                      padding:
                          EdgeInsets.all(ScreenUtil.instance.setHeight(10.0)),
                      decoration: new BoxDecoration(
                          color: Color(0xffF1F2F2),
                          borderRadius:
                              new BorderRadius.all(const Radius.circular(20.0)),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black38,
                              blurRadius: 4.5,
                              offset: Offset(5.0, 5.0),
                            )
                          ]),
                      child: Row(
                        children: <Widget>[
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Flexible(
                                child: Icon(Icons.insert_chart,
                                    color: Color(0xffFF4242), size: 90.0),
                              ),
                            ],
                          ),
                          Column(
                            children: <Widget>[
                              Container(
                                margin: EdgeInsets.only(
                                    top: ScreenUtil.instance.setHeight(15.0)),
                                width: ScreenUtil.instance.setWidth(220.0),
                                child: Text(
                                  'Temperatura',
                                  style: TextStyle(
                                      fontSize: ScreenUtil.instance.setSp(23.0),
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xff575757)),
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(
                                    top: ScreenUtil.instance.setHeight(16.0)),
                                width: ScreenUtil.instance.setWidth(100.0),
                                child: _isLoading
                                    ? Shimmer.fromColors(
                                        baseColor: Colors.grey[500],
                                        highlightColor: Colors.white,
                                        child: Container(
                                          width: double.infinity / 2,
                                          height: ScreenUtil.instance
                                              .setHeight(25.0),
                                          color: Colors.white70,
                                        ),
                                      )
                                    : Text(
                                        '$_currentTemperature\ºc',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            fontSize:
                                                ScreenUtil.instance.setSp(35.0),
                                            fontWeight: FontWeight.bold,
                                            color: Color(0xff575757)),
                                      ),
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        print('configurar iluminação');
                        Navigator.of(context).pushNamed('/illumination-config');
                      },
                      child: Container(
                          padding: EdgeInsets.all(
                              ScreenUtil.instance.setHeight(10.0)),
                          decoration: new BoxDecoration(
                              color: Color(0xffF1F2F2),
                              borderRadius: new BorderRadius.all(
                                  const Radius.circular(15.0)),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black38,
                                  blurRadius: 4.5,
                                  offset: Offset(5.0, 5.0),
                                )
                              ]),
                          child: Row(children: <Widget>[
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Flexible(
                                  child: Icon(Icons.wb_sunny,
                                      color: Color(0xffFFC107), size: 90.0),
                                ),
                              ],
                            ),
                            Column(
                              children: <Widget>[
                                Container(
                                  margin: EdgeInsets.only(
                                      top: ScreenUtil.instance.setHeight(15.0)),
                                  width: ScreenUtil.instance.setWidth(220.0),
                                  child: Text(
                                    'Tempo de iluminação',
                                    style: TextStyle(
                                        fontSize:
                                            ScreenUtil.instance.setSp(21.5),
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xff575757)),
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.only(
                                      top: ScreenUtil.instance.setHeight(16.0)),
                                  width: ScreenUtil.instance.setWidth(100.0),
                                  child: _isLoading
                                      ? Shimmer.fromColors(
                                          baseColor: Colors.grey[500],
                                          highlightColor: Colors.white,
                                          child: Container(
                                            width: double.infinity / 2,
                                            height: ScreenUtil.instance
                                                .setHeight(25.0),
                                            color: Colors.white70,
                                          ),
                                        )
                                      : Text(
                                          '$_hoursBacklit' + 'h',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              fontSize: ScreenUtil.instance
                                                  .setSp(35.0),
                                              fontWeight: FontWeight.bold,
                                              color: Color(0xff575757)),
                                        ),
                                )
                              ],
                            )
                          ])),
                    ),
                    GestureDetector(
                      onTap: () {
                        print('configurar irrigacao');
                        Navigator.of(context).pushNamed('/irrigation-config');
                      },
                      child: Container(
                        padding:
                            EdgeInsets.all(ScreenUtil.instance.setHeight(10.0)),
                        decoration: new BoxDecoration(
                            color: Color(0xffF1F2F2),
                            borderRadius: new BorderRadius.all(
                                const Radius.circular(15.0)),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black38,
                                blurRadius: 4.5,
                                offset: Offset(5.0, 5.0),
                              )
                            ]),
                        child: Row(
                          children: <Widget>[
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Flexible(
                                  child: Icon(Icons.wb_cloudy,
                                      color: Color(0xff3499C1), size: 80.0),
                                ),
                              ],
                            ),
                            Column(
                              children: <Widget>[
                                Container(
                                  margin: EdgeInsets.only(
                                      top: ScreenUtil.instance.setHeight(15.0),
                                      left: ScreenUtil.instance.setWidth(12.0)),
                                  width: ScreenUtil.instance.setWidth(220.0),
                                  child: Text(
                                    'Umidade',
                                    style: TextStyle(
                                        fontSize:
                                            ScreenUtil.instance.setSp(23.0),
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xff575757)),
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.only(
                                      top: ScreenUtil.instance.setHeight(16.0)),
                                  width: ScreenUtil.instance.setWidth(100.0),
                                  child: _isLoading
                                      ? Shimmer.fromColors(
                                          baseColor: Colors.grey[500],
                                          highlightColor: Colors.white,
                                          child: Container(
                                            width: double.infinity / 2,
                                            height: ScreenUtil.instance
                                                .setHeight(25.0),
                                            color: Colors.white70,
                                          ),
                                        )
                                      : Text(
                                          '$_currentHumidity' + '%',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              fontSize: ScreenUtil.instance
                                                  .setSp(35.0),
                                              fontWeight: FontWeight.bold,
                                              color: Color(0xff575757)),
                                        ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                right: MediaQuery.of(context).size.width / 30.0,
                top: ScreenUtil.instance.setHeight(142),
                child: GestureDetector(
                  child: Container(
                    width: 135.0,
                    height: 135.0,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(70.0)),
                        color: Color.fromRGBO(144, 201, 82, 1),
                        image: _image != null
                            ? DecorationImage(
                                image: MemoryImage(_image), fit: BoxFit.cover)
                            : null),
                  ),
                  onTap: () {
                    Navigator.of(context).pushNamed('/plantings');
                  },
                ),
              ),
            ],
          ),
        );
      } else {
        return Scaffold(
            body: new Column(
          children: <Widget>[
            ClipRRect(
              borderRadius: new BorderRadius.only(
                  bottomLeft: const Radius.circular(70.0)),
              child: Container(
                width: double.infinity,
                height: ScreenUtil.instance.setHeight(300.0),
                margin: EdgeInsets.all(0),
                color: Color.fromRGBO(144, 201, 82, 1),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.only(
                          top: ScreenUtil.instance.setHeight(55.0)),
                      child: Icon(Icons.new_releases,
                          color: Colors.white, size: 70.0),
                    ),
                    Container(
                      margin: EdgeInsets.only(
                          top: ScreenUtil.instance.setHeight(50.0)),
                      child: Text(
                        "Nenhum plantio ativo",
                        style: TextStyle(
                            fontSize: ScreenUtil.instance.setSp(35),
                            color: Colors.white,
                            fontWeight: FontWeight.w500),
                        textAlign: TextAlign.left,
                      ),
                    )
                  ],
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(
                  top: ScreenUtil.instance.setHeight(120.0),
                  left: ScreenUtil.instance.setWidth(10.0),
                  right: ScreenUtil.instance.setWidth(10.0)),
              child: Text(
                'Inicie um plantio, e o app exibirá os dados de monitoramento!',
                style: TextStyle(
                    fontSize: ScreenUtil.instance.setSp(28.0),
                    fontWeight: FontWeight.bold,
                    color: Color(0xff575757),
                    letterSpacing: 1.5,
                    height: 1.5),
                textAlign: TextAlign.center,
              ),
            )
          ],
        ));
      }
    } else {
      return Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
  }
}
