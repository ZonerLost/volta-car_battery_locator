import 'package:cloud_firestore/cloud_firestore.dart';

class BatteryMarker {
  final double xPct;
  final double yPct;

  BatteryMarker({required this.xPct, required this.yPct});

  factory BatteryMarker.fromMap(Map<String, dynamic>? map) {
    return BatteryMarker(
      xPct: (map?['xPct'] ?? 0).toDouble(),
      yPct: (map?['yPct'] ?? 0).toDouble(),
    );
  }
}

class CarDetails {
  final String id;
  final String make;
  final String model;
  final int yearFrom;
  final int yearTo;
  final String location;
  final String description;
  final int batteryCount;
  final String diagramUrl;
  final String thumbnailUrl;
  final String templateId;
  final String markerStatus;
  final BatteryMarker? marker;

  CarDetails({
    required this.id,
    required this.make,
    required this.model,
    required this.yearFrom,
    required this.yearTo,
    required this.location,
    required this.description,
    required this.batteryCount,
    required this.diagramUrl,
    required this.thumbnailUrl,
    required this.templateId,
    required this.markerStatus,
    required this.marker,
  });

  String get yearLabel {
    if (yearFrom == 0 && yearTo == 0) return "";
    if (yearFrom == yearTo) return "$yearFrom";
    return "$yearFrom-$yearTo";
  }

  factory CarDetails.fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data() ?? {};

    return CarDetails(
      id: doc.id,
      make: (data['make'] ?? '').toString(),
      model: (data['model'] ?? '').toString(),
      yearFrom: _parseInt(data['yearFrom']),
      yearTo: _parseInt(data['yearTo']),
      location: (data['location'] ?? '').toString(),
      description: (data['description'] ?? '').toString(),
      batteryCount: _parseInt(data['batteryCount']),
      diagramUrl: (data['diagramUrl'] ?? '').toString(),
      thumbnailUrl: (data['thumbnailUrl'] ?? '').toString(),
      templateId: (data['templateId'] ?? '').toString(),
      markerStatus: (data['markerStatus'] ?? '').toString(),
      marker:
          data['marker'] != null
              ? BatteryMarker.fromMap(Map<String, dynamic>.from(data['marker']))
              : null,
    );
  }

  static int _parseInt(dynamic value) {
    if (value is int) return value;
    if (value is double) return value.toInt();
    return int.tryParse(value?.toString() ?? '') ?? 0;
  }
}
