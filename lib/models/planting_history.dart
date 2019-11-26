import 'package:flutter/material.dart';

class PlantingHistory with ChangeNotifier {
  final int id;
  final DateTime cycleEndingDate;
  final DateTime plantingDate;
  final bool cycleFinished;
  final String name;
  final int seedlingId;
  final String pictureUrl;

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
      cycleEndingDate: json['cycle_ending_date'] == null
          ? null
          : DateTime.parse(json['cycle_ending_date']),
      cycleFinished:
          json['cycle_finished'] == null ? false : json['cycle_finished'],
      id: json['id'],
      name: json['name'],
      pictureUrl: json['picture_url'] == null ? '' : json['picture_url'],
      plantingDate: DateTime.parse(json['planting_date']),
      seedlingId: json['seedling_id'],
    );
  }
}
