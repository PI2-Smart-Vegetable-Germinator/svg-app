import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'dart:convert';
import 'package:shimmer/shimmer.dart';

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

  Future<void> _getCurrentInfo() async {
    print('loading: ' + _isLoading.toString());
    try {
      Response response =
          await get('http://192.168.0.9:5002/api/current-info/');
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
      print('loading: ' + _isLoading.toString());
    } catch (e) {
      _isLoading = false;
      print('loading: ' + _isLoading.toString());
      print(e);
    }
  }

  @override
  void initState() {
    _isLoading = true;
    super.initState();
    _getCurrentInfo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            // Add your onPressed code here!
          },
          label: Text('Irrigar', style: TextStyle(fontSize: 16.0)),
          icon: Icon(
            Icons.spa,
            size: 30.0,
          ),
          backgroundColor: Color(0xff89C34B),
        ),
        body: Stack(
          children: <Widget>[
            ClipRRect(
              borderRadius: new BorderRadius.only(
                  bottomLeft: const Radius.circular(50.0)),
              child: Container(
                width: double.infinity,
                height: MediaQuery.of(context).size.height / 4,
                margin: EdgeInsets.all(0),
                color: Color.fromRGBO(144, 201, 82, 1),
                child: Column(
                  children: <Widget>[
                    Center(
                      child: GestureDetector(
                        child: Container(
                        height: MediaQuery.of(context).size.height / 14.0,
                        width: MediaQuery.of(context).size.width,
                        child: Icon(
                            Icons.keyboard_arrow_down,
                            size: 60.0,
                            color: Colors.white,
                          )
                        ),
                        onTap: () {
                          print('puta vida !!!');
                        }
                      )
                    ),
                    Container(
                      width: double.infinity,
                      margin: const EdgeInsets.only(
                          left: 30, right: 30.0, top: 5.0),
                      child: _isLoading
                          ? Shimmer.fromColors(
                              baseColor: Colors.grey[500],
                              highlightColor: Colors.white,
                              child: Container(
                                width: double.infinity,
                                height: 35.0,
                                color: Colors.white70,
                              ),
                            )
                          : Text(
                              _plantingTime.toString() + " dias de estufa",
                              style: TextStyle(
                                  fontSize: 35,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500),
                              textAlign: TextAlign.left,
                            ),
                    ),
                    Container(
                      width: double.infinity,
                      margin: const EdgeInsets.only(
                          left: 30, right: 30.0, top: 10.0),
                      child: _isLoading
                          ? Shimmer.fromColors(
                              baseColor: Colors.grey[500],
                              highlightColor: Colors.white,
                              child: Container(
                                width: double.infinity,
                                height: 25.0,
                                color: Colors.white70,
                              ),
                            )
                          : Text(
                              "100% das mudas germinaram",
                              style: TextStyle(
                                  fontSize: 19,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500),
                              textAlign: TextAlign.left,
                            ),
                    ),
                    Container(
                      width: double.infinity,
                      margin: const EdgeInsets.only(
                          left: 30, right: 30.0, top: 5.0),
                      child: _isLoading
                          ? Shimmer.fromColors(
                              baseColor: Colors.grey[500],
                              highlightColor: Colors.white,
                              child: Container(
                                width: double.infinity,
                                height: 25.0,
                                color: Colors.white70,
                              ),
                            )
                          : Text(
                              _remainingDays.toString() +
                                  " dias até a colheita",
                              style: TextStyle(
                                  fontSize: 19,
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
              margin: EdgeInsets.only(
                top: MediaQuery.of(context).size.height / 4
              ),
              child: GridView.count(
              primary: false,
              padding: const EdgeInsets.all(20),
              crossAxisSpacing: 10.0,
              mainAxisSpacing: 15.0,
              crossAxisCount: 1,
              childAspectRatio: 2.6,
              children: <Widget>[
                Container(
                  padding: const EdgeInsets.all(10.0),
                  decoration: new BoxDecoration(
                      color: Color(0xffF1F2F2),
                      borderRadius:
                          new BorderRadius.all(const Radius.circular(15.0)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black38,
                          blurRadius: 2.0,
                          offset: Offset(6.0, 6.0),
                        )
                      ]),
                  child: Row(
                    children: <Widget>[
                      Icon(Icons.insert_chart,
                          color: Color(0xffFF4242), size: 120.0),
                      Column(
                        children: <Widget>[
                          Container(
                            margin: EdgeInsets.only(top: 12.0),
                            width: 200.0,
                            height: 30.0,
                            child: Text(
                              'Temperatura',
                              style: TextStyle(
                                  fontSize: 23.0,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xff575757)),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(top: 25.0),
                            width: 100.0,
                            child: _isLoading
                                ? Shimmer.fromColors(
                                    baseColor: Colors.grey[500],
                                    highlightColor: Colors.white,
                                    child: Container(
                                      width: double.infinity / 2,
                                      height: 25.0,
                                      color: Colors.white70,
                                    ),
                                  )
                                : Text(
                                    '$_currentTemperature\ºc',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontSize: 40.0,
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
                    padding: const EdgeInsets.all(10.0),
                    decoration: new BoxDecoration(
                        color: Color(0xffF1F2F2),
                        borderRadius:
                            new BorderRadius.all(const Radius.circular(15.0)),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black38,
                            blurRadius: 2.0,
                            offset: Offset(6.0, 6.0),
                          )
                        ]),
                    child: Row(children: <Widget>[
                      Icon(
                        Icons.wb_sunny,
                        color: Color(0xffFFC107),
                        size: 120.0,
                      ),
                      Column(
                        children: <Widget>[
                          Container(
                            margin: EdgeInsets.only(top: 12.0),
                            width: 200.0,
                            height: 30.0,
                            child: Text(
                              'Tempo de exposição à luz',
                              style: TextStyle(
                                  fontSize: 17.0,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xff575757)),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(top: 25.0),
                            width: 100.0,
                            child: _isLoading
                                ? Shimmer.fromColors(
                                    baseColor: Colors.grey[500],
                                    highlightColor: Colors.white,
                                    child: Container(
                                      width: double.infinity,
                                      height: 25.0,
                                      color: Colors.white70,
                                    ),
                                  )
                                : Text(
                                    '$_hoursBacklit\h',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontSize: 40.0,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xff575757)),
                                  ),
                          )
                        ],
                      )
                    ])),
                Container(
                    padding: const EdgeInsets.all(10.0),
                    decoration: new BoxDecoration(
                        color: Color(0xffF1F2F2),
                        borderRadius:
                            new BorderRadius.all(const Radius.circular(15.0)),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black38,
                            blurRadius: 2.0,
                            offset: Offset(6.0, 6.0),
                          )
                        ]),
                    child: Row(children: <Widget>[
                      Icon(
                        Icons.wb_cloudy,
                        color: Color(0xff3499C1),
                        size: 120.0,
                      ),
                      Column(
                        children: <Widget>[
                          Container(
                            margin: EdgeInsets.only(top: 12.0),
                            width: 200.0,
                            height: 30.0,
                            child: Text(
                              'Umidade',
                              style: TextStyle(
                                  fontSize: 23.0,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xff575757)),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(top: 25.0),
                            width: 100.0,
                            child: _isLoading
                                ? Shimmer.fromColors(
                                    baseColor: Colors.grey[500],
                                    highlightColor: Colors.white,
                                    child: Container(
                                      width: double.infinity,
                                      height: 25.0,
                                      color: Colors.white70,
                                    ),
                                  )
                                : Text(
                                    '$_currentHumidity\%',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontSize: 40.0,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xff575757)),
                                  ),
                          )
                        ],
                      )
                    ]))
              ],
            )),
            Positioned(
              right: MediaQuery.of(context).size.width / 30.0,
              top: MediaQuery.of(context).size.height / 6.1,
              child: GestureDetector(
                child: CircleAvatar(
                  radius: MediaQuery.of(context).size.width / 6.5,
                  backgroundColor: Color.fromRGBO(144, 201, 82, 1),
                  backgroundImage: NetworkImage('https://planetahuerto-6f4f.kxcdn.com/estaticos/imagenes/articulo_revista/154/154_620x465.jpg'),
                ),
                onTap: () {
                  print('oh o pau quebrando !!!');
                },
              )
            ),
          ],
        ));
  }
}
