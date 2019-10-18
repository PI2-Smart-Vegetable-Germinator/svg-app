import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'dart:convert';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int plantingId;
  String plantingName;
  int plantingTime;
  int _currentHumidity = 0;
  int _currentTemperature = 0;
  int _hoursBacklit = 0;

  Future<void> getLastPlantingStatus() async {
    Response response = await get('http://192.168.0.7:5002/api/planting-time/');
    final extractedData = json.decode(response.body);

    setState(() {
      plantingId = extractedData['data']['planting_id'];
      plantingName = extractedData['data']['planting_name'];
      plantingTime = extractedData['data']['planting_time'];
    });
  }

  Future<void> _getCurrentInfo() async {
    try {
      Response response = await get('http://192.168.0.7:5002/api/current-info');
      final data = json.decode(response.body);

      setState(() {
        _currentHumidity = data['data']['current_humidity'];
        _currentTemperature = data['data']['current_temperature'];
        _hoursBacklit = data['data']['hours_backlit'];
      });
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    super.initState();
    getLastPlantingStatus();
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
      body: Column(
        children: <Widget>[
          ClipRRect(
            borderRadius:
                new BorderRadius.only(bottomLeft: const Radius.circular(50.0)),
            child: Container(
              width: double.infinity,
              height: MediaQuery.of(context).size.height / 4,
              margin: EdgeInsets.all(0),
              color: Color.fromRGBO(144, 201, 82, 1),
              child: Container(
                margin: EdgeInsets.all(30),
                child: Text(
                  plantingTime.toString() + " dias de estufa",
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
                            width: 200.0,
                            child: Text(
                              '$_currentTemperature\º C',
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
                            width: 200.0,
                            child: Text(
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
                  child: Row(
                    children: <Widget>[
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
                            width: 200.0,
                            child: Text(
                              '$_currentHumidity\%',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 40.0,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xff575757)),
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
