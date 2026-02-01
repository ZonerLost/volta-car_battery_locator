class HomeCar {
  final String id;
  final String make;
  final String model;
  final String makeLower;
  final String modelLower;

  final String yearLabel;
  final int yearStart;
  final int yearEnd;

  final int batteryCount;
  final String location;

  final bool isActive;

  HomeCar({
    required this.id,
    required this.make,
    required this.model,
    required this.makeLower,
    required this.modelLower,
    required this.yearLabel,
    required this.yearStart,
    required this.yearEnd,
    required this.batteryCount,
    required this.location,
    required this.isActive,
  });

  factory HomeCar.fromDoc(String id, Map<String, dynamic> data) {
    return HomeCar(
      id: id,
      make: (data["make"] ?? "").toString(),
      model: (data["model"] ?? "").toString(),
      makeLower: (data["makeLower"] ?? data["makeKey"] ?? "").toString(),
      modelLower: (data["modelLower"] ?? data["modelKey"] ?? "").toString(),
      yearLabel: (data["yearLabel"] ?? "").toString(),
      yearStart: (data["yearStart"] ?? data["yearFrom"] ?? 0) is int
          ? (data["yearStart"] ?? data["yearFrom"] ?? 0)
          : int.tryParse("${data["yearStart"] ?? data["yearFrom"] ?? 0}") ?? 0,
      yearEnd: (data["yearEnd"] ?? data["yearTo"] ?? 0) is int
          ? (data["yearEnd"] ?? data["yearTo"] ?? 0)
          : int.tryParse("${data["yearEnd"] ?? data["yearTo"] ?? 0}") ?? 0,
      batteryCount: (data["batteryCount"] ?? 0) is int
          ? data["batteryCount"]
          : int.tryParse("${data["batteryCount"] ?? 0}") ?? 0,
      location: (data["location"] ?? "").toString(),
      isActive: (data["isActive"] ?? true) == true,
    );
  }
}
