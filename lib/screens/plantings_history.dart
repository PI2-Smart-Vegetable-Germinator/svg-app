import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart';
import 'dart:convert';
import 'package:shimmer/shimmer.dart';

class PlantingsHistory extends StatefulWidget {
  static const routeName = '/plantings';

  @override
  _PlantingsHistoryState createState() => _PlantingsHistoryState();
}

class _PlantingsHistoryState extends State<PlantingsHistory> {
  // String _plantingName = '';
  // int _plantingTime = 0;
  // int _remainingDays = 0;
  // int _currentHumidity = 0;
  // int _currentTemperature = 0;
  // int _hoursBacklit = 0;
  // var _isLoading = false;

  // Future<void> _getHistoryData() async {
  //   print('loading: ' + _isLoading.toString());
  //   try {
  //     Response response =
  //         await get('http://192.168.0.108:5002/api/current-info/');
  //     final data = json.decode(response.body);

  //     setState(() {
  //       // _currentHumidity = data['data']['current_humidity'];
  //       // _currentTemperature = data['data']['current_temperature'];
  //       // _remainingDays = data['data']['cycle_remaining_days'];
  //       // _hoursBacklit = data['data']['hours_backlit'];
  //       // _plantingName = data['data']['planting_name'];
  //       // _plantingTime = data['data']['planting_time'];
  //       _isLoading = false;
  //     });
  //     print('loading: ' + _isLoading.toString());
  //   } catch (e) {
  //     _isLoading = false;
  //     print('loading: ' + _isLoading.toString());
  //     print(e);
  //   }
  // }

  @override
  void initState() {
    // _isLoading = true;
    super.initState();
    // _getHistoryData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      children: <Widget>[
        ClipRRect(
          borderRadius:
              new BorderRadius.only(bottomLeft: const Radius.circular(50.0)),
          child: Container(
            width: double.infinity,
            height: MediaQuery.of(context).size.height / 4,
            margin: EdgeInsets.all(0),
            color: Color.fromRGBO(144, 201, 82, 1),
          ),
        ),
      ],
    ));
  }
}
