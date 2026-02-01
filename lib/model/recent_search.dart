import 'package:cloud_firestore/cloud_firestore.dart';

class RecentSearch {
  final String carId;
  final String make;
  final String model;
  final String yearLabel;
  final String location;
  final String thumbnailUrl;
  final Timestamp? lastSearchedAt;

  RecentSearch({
    required this.carId,
    required this.make,
    required this.model,
    required this.yearLabel,
    required this.location,
    required this.thumbnailUrl,
    required this.lastSearchedAt,
  });

  factory RecentSearch.fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    final d = doc.data() ?? {};
    return RecentSearch(
      carId: (d["carId"] ?? doc.id).toString(),
      make: (d["make"] ?? "").toString(),
      model: (d["model"] ?? "").toString(),
      yearLabel: (d["yearLabel"] ?? "").toString(),
      location: (d["location"] ?? "").toString(),
      thumbnailUrl: (d["thumbnailUrl"] ?? "").toString(),
      lastSearchedAt: d["lastSearchedAt"] as Timestamp?,
    );
  }
}
