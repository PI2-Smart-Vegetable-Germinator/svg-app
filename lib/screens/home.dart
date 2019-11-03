import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'dart:convert';
import 'package:shimmer/shimmer.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _plantingName = '';
  int _plantingTime = 0;
  int _remainingDays = 0;
  int _currentHumidity = 0;
  int _currentTemperature = 0;
  int _hoursBacklit = 0;
  var _isLoading = false;
  var _image;

  Future<void> _getCurrentInfo() async {
    try {
      Response response = await get('http://10.0.2.2:5002/api/current-info/');
      final data = json.decode(response.body);

      setState(() {
        _currentHumidity = data['data']['current_humidity'];
        _currentTemperature = data['data']['current_temperature'];
        _remainingDays = data['data']['cycle_remaining_days'];
        _hoursBacklit = data['data']['hours_backlit'];
        _plantingName = data['data']['planting_name'];
        _plantingTime = data['data']['planting_time'];
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

    Response response = await get('http://10.0.2.2:5002/api/get-image',
    headers: { 'Authorization': 'Bearer $accessToken' });
    final data = response.bodyBytes;
    setState(() {
      _image = data;
    });
  }

  @override
  void initState() {
    _isLoading = true;
    super.initState();
    _getCurrentInfo();
    _getCurrentImage();
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

    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          // Add your onPressed code here!
        },
        label: Text('Irrigar',
            style: TextStyle(fontSize: ScreenUtil.instance.setSp(16.0))),
        icon: Icon(
          Icons.spa,
          size: 30.0,
        ),
        backgroundColor: Color(0xff89C34B),
      ),
      body: Stack(
        children: <Widget>[
          ClipRRect(
            borderRadius:
                new BorderRadius.only(bottomLeft: const Radius.circular(50.0)),
            child: Container(
              width: double.infinity,
              height: ScreenUtil.instance.setHeight(215.0),
              margin: EdgeInsets.all(0),
              color: Color.fromRGBO(144, 201, 82, 1),
              child: Column(
                children: <Widget>[
                  Center(
                      child: GestureDetector(
                          child: Container(
                              height: ScreenUtil.instance.setHeight(60),
                              width: MediaQuery.of(context).size.width,
                              child: Icon(
                                Icons.keyboard_arrow_down,
                                size: MediaQuery.of(context).size.width / 5.5,
                                color: Colors.white,
                              )),
                          onTap: () {
                            print('puta vida !!!');
                          })),
                  Container(
                    width: double.infinity,
                    margin: EdgeInsets.only(
                        left: ScreenUtil.instance.setWidth(30),
                        right: ScreenUtil.instance.setWidth(30.0),
                        top: ScreenUtil.instance.setHeight(5.0)),
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
                                fontSize: ScreenUtil.instance.setSp(35.0),
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
                        top: ScreenUtil.instance.setHeight(13.0)),
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
                            "100% das mudas germinaram",
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
                            _remainingDays.toString() + " dias até a colheita",
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
            margin: EdgeInsets.only(top: ScreenUtil.instance.setHeight(220.0)),
            child: GridView.count(
              primary: false,
              padding: EdgeInsets.all(ScreenUtil.instance.setWidth(20.0)),
              mainAxisSpacing: ScreenUtil.instance.setWidth(15.0),
              crossAxisCount: 1,
              childAspectRatio: 2.65,
              children: <Widget>[
                Container(
                  padding: EdgeInsets.all(ScreenUtil.instance.setHeight(10.0)),
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
                                      height:
                                          ScreenUtil.instance.setHeight(25.0),
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
                Container(
                    padding:
                        EdgeInsets.all(ScreenUtil.instance.setHeight(10.0)),
                    decoration: new BoxDecoration(
                        color: Color(0xffF1F2F2),
                        borderRadius:
                            new BorderRadius.all(const Radius.circular(15.0)),
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
                                  fontSize: ScreenUtil.instance.setSp(21.5),
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
                                      height:
                                          ScreenUtil.instance.setHeight(25.0),
                                      color: Colors.white70,
                                    ),
                                  )
                                : Text(
                                    '$_hoursBacklit' + 'h',
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
                    ])),
                Container(
                  padding: EdgeInsets.all(ScreenUtil.instance.setHeight(10.0)),
                  decoration: new BoxDecoration(
                      color: Color(0xffF1F2F2),
                      borderRadius:
                          new BorderRadius.all(const Radius.circular(15.0)),
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
                                      height:
                                          ScreenUtil.instance.setHeight(25.0),
                                      color: Colors.white70,
                                    ),
                                  )
                                : Text(
                                    '$_currentHumidity' + '%',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontSize:
                                            ScreenUtil.instance.setSp(35.0),
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xff575757)),
                                  ),
                          ),
                        ],
                      ),
                    ],
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
                  image: _image != null ? DecorationImage(
                    image: MemoryImage(_image),
                    fit: BoxFit.cover
                  ) : null
                ),
              ),
              onTap: () {
                Navigator.of(context).pushNamed('/plantings');
              },
            ),
          ),
        ],
      ),
    );
  }
}
