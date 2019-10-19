import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/planting_history.dart';

class Plantings with ChangeNotifier {
  List<PlantingHistory> _items = [];

  List<PlantingHistory> get items {
    return [..._items];
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

      // print(extractedData);

      final plantingsData = extractedData
          .map<PlantingHistory>((json) => PlantingHistory.fromJson(json))
          .toList();

      _items = plantingsData;

      notifyListeners();
    } catch (error) {
      throw (error);
    }
  }
}
