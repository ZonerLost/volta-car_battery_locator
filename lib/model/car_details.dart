import 'package:cloud_firestore/cloud_firestore.dart';

class CarDetails {
  final String id;

  final String make;
  final String model;
  final String yearLabel;

  final String location;
  final String diagramUrl;
  final String thumbnailUrl;

  CarDetails({
    required this.id,
    required this.make,
    required this.model,
    required this.yearLabel,
    required this.location,
    required this.diagramUrl,
    required this.thumbnailUrl,
  });

  factory CarDetails.fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    final d = doc.data() ?? {};

    return CarDetails(
      id: doc.id,
      make: (d["make"] ?? "").toString(),
      model: (d["model"] ?? "").toString(),
      yearLabel: (d["yearLabel"] ?? "").toString(),

      // ✅ This is the exact field you showed in screenshot:
      location: (d["location"] ?? "").toString(),

      // ✅ exact field:
      diagramUrl: (d["diagramUrl"] ?? "").toString(),

      // ✅ you have thumbnailUrl in doc; fallback to imageUrl
      thumbnailUrl: (d["thumbnailUrl"] ?? d["imageUrl"] ?? "").toString(),
    );
  }
}
