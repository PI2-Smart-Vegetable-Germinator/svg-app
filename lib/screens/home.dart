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

  void getLastPlantingStatus() async {
    Response response = await get('http://localhost:5002/api/planting-time/');
    final extractedData = json.decode(response.body);

    print(response.body);

    setState(() {
      plantingId = extractedData['data']['planting_id'];
      plantingName = extractedData['data']['planting_name'];
      plantingTime = extractedData['data']['planting_time'];
    });
  }

  @override
  void initState() {
    super.initState();
    getLastPlantingStatus();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ClipRRect(
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
    );
  }
}
