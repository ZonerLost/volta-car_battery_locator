import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fire_fighter/utils/app_snackbar.dart';
import 'package:get/get.dart';

import '../model/car_details.dart';
import '../model/recent_search.dart';
import '../views/screens/home/locate_battery.dart';

class RecentSearchesController extends GetxController {
  final _db = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;

  final isLoading = false.obs;
  final searches = <RecentSearch>[].obs;

  StreamSubscription? _sub;

  String? get _uid => _auth.currentUser?.uid;

  /// ✅ modules -> carDatabase -> cars
  CollectionReference<Map<String, dynamic>> get carsRef =>
      _db.collection("modules").doc("carDatabase").collection("cars");

  /// ✅ users/{uid}/recentSearches
  CollectionReference<Map<String, dynamic>> get _recentRef =>
      _db.collection("users").doc(_uid).collection("recentSearches");

  @override
  void onInit() {
    super.onInit();
    listenRecents();
  }

  @override
  void onClose() {
    _sub?.cancel();
    super.onClose();
  }

  void listenRecents() {
    if (_uid == null) return;

    isLoading.value = true;

    _sub?.cancel();
    _sub = _recentRef
        .orderBy("lastSearchedAt", descending: true)
        .limit(20)
        .snapshots()
        .listen(
          (snap) {
            searches.assignAll(
              snap.docs.map((d) => RecentSearch.fromDoc(d)).toList(),
            );
            isLoading.value = false;
          },
          onError: (_) {
            isLoading.value = false;
          },
        );
  }

  /// ✅ SAVE recent from CarDetails (Locate screen se)
  Future<void> addRecentFromDetails(CarDetails car) async {
    if (_uid == null) return;

    await _recentRef.doc(car.id).set({
      "carId": car.id,
      "make": car.make,
      "model": car.model,
      "yearLabel": car.yearLabel,
      "location": car.location,
      "thumbnailUrl": car.thumbnailUrl,
      "lastSearchedAt": FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }

  /// ✅ OPEN recent (fetch latest car data, then open locate)
  Future<void> openRecent(RecentSearch s) async {
    try {
      isLoading.value = true;

      final doc = await carsRef.doc(s.carId).get();
      if (!doc.exists) {
        AppSnackBar.show("Recent Search", "This car record no longer exists.");
        return;
      }

      // ✅ open locate screen using same flow (carId)
      Get.to(() => LocateBatteryScreen(carId: doc.id));
    } catch (_) {
      AppSnackBar.show("Recent Search", "Failed to open this item.");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> deleteRecent(String carId) async {
    if (_uid == null) return;
    await _recentRef.doc(carId).delete();
  }

  Future<void> clearAll() async {
    if (_uid == null) return;

    try {
      isLoading.value = true;

      // UI instantly clear (optional but nice)
      searches.clear();

      final snap = await _recentRef.get();
      if (snap.docs.isEmpty) return;

      final batch = _db.batch();
      for (final d in snap.docs) {
        batch.delete(d.reference);
      }
      await batch.commit();
    } catch (e) {
      AppSnackBar.show("Cache", "Failed to clear recent searches.");
    } finally {
      isLoading.value = false;
    }
  }
}
