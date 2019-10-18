import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class PlantingHistory with ChangeNotifier {
  final int id;
  final String cycleEndingDate;
  final String plantingDate;
  final bool cycleFinished;
  final String name;
  final int seedlingId;
  final String pictureUrl;

  List<PlantingHistory> _items = [];

  PlantingHistory({
    this.cycleEndingDate,
    this.cycleFinished,
    this.id,
    this.name,
    this.pictureUrl,
    this.plantingDate,
    this.seedlingId,
  });

  factory PlantingHistory.fromJson(Map<String, dynamic> json) {
    return new PlantingHistory(
      cycleEndingDate: json['cycle_ending_date'] == null ? null : json["cycle_ending_date"],
      cycleFinished: json['cycle_finished'],
      id: json['id'],
      name: json['name'],
      pictureUrl: json['picture_url'],
      plantingDate: json['planting_date'],
      seedlingId: json['seedling_id'],
    );
  }

  Future<void> fetchAndSetPlantings() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final authTokens =
        json.decode(prefs.get('authTokens')) as Map<String, Object>;
    final accessToken = authTokens['accessToken'];

    try {
      Response response = await get(
          'http://192.168.0.108:5002/api/plantings-history/',
          headers: {
            'Authorization': 'Bearer $accessToken',
          });

      var data = json.decode(response.body) as Map<String, dynamic>;
      var extractedData = data['data']['plantings_history'];

      print(extractedData);

      final plantingsData = extractedData.map<PlantingHistory>((json) => PlantingHistory.fromJson(json)).toList();

      _items = plantingsData;
      notifyListeners();

    } catch (error) {
      throw (error);
    }
  }
}
