import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../model/app_users.dart';

class HomeController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final isGuest = false.obs;
  CollectionReference<Map<String, dynamic>> get carsRef =>
      _db.collection("modules").doc("carDatabase").collection("cars");

  // USER
  final user = Rxn<AppUser>();
  String get fullName => user.value?.fullName ?? "User";


  // SELECTED
  final selectedMake = "".obs;
  final selectedModel = "".obs;
  final selectedYearLabel = "".obs;
  final selectedCarId = "".obs;

  final isLoading = false.obs;

  // DROPDOWN LISTS
  final makeSuggestions = <String>[].obs;
  final modelSuggestions = <String>[].obs;
  final yearLabelSuggestions = <String>[].obs;

  // CACHE
  final List<QueryDocumentSnapshot<Map<String, dynamic>>> _cache = [];
  DateTime? _cacheAt;

  static const int _cacheLimit = 5000;

  @override
  void onInit() {
    super.onInit();
    _bootstrap();
  }

  Future<void> _bootstrap() async {
    try {
      if (isGuest.value) {
        // Guest: no firestore calls
        await _warmUpCache(force: true); // (optional) agar ye bhi firestore hai to skip
        await loadMakes();               // (optional) same
        return;
      }

      await loadUser();
      await _warmUpCache(force: true);
      await loadMakes();
    } catch (e) {
      // app crash na ho
      debugPrint("BOOTSTRAP ERROR: $e");
    }
  }
  @override
  void onClose() {
    super.onClose();
  }

  Future<void> loadUser() async {
    try {
      if (isGuest.value) return;

      final current = _auth.currentUser;
      if (current == null) return;

      final doc = await _db.collection("users").doc(current.uid).get();
      final data = doc.data();
      if (data == null) {
        user.value = null;
        return;
      }

      user.value = AppUser.fromMap(data);
    } catch (e) {
      debugPrint("LOAD USER ERROR: $e");
      user.value = null;
    }
  }
  bool get _cacheFresh {
    if (_cacheAt == null) return false;
    return DateTime.now().difference(_cacheAt!).inMinutes < 10;
  }

  Future<void> _warmUpCache({bool force = false}) async {
    if (!force && _cacheFresh && _cache.isNotEmpty) return;

    try {
      isLoading.value = true;

      final snap = await carsRef
          .where("status", isEqualTo: "active")
          .limit(_cacheLimit)
          .get();

      _cache
        ..clear()
        ..addAll(snap.docs);

      _cacheAt = DateTime.now();

      // debug
      // ignore: avoid_print
      print("CACHE READY: ${_cache.length}");
    } catch (e) {
      // ignore: avoid_print
      print("WARMUP ERROR: $e");
      _cache.clear();
    } finally {
      isLoading.value = false;
    }
  }

  // ================= LOAD MAKES =================
  Future<void> loadMakes() async {
    await _warmUpCache();

    final Set<String> makes = {};
    for (final doc in _cache) {
      final data = doc.data();
      final make = (data["make"] ?? "").toString().trim();
      if (make.isNotEmpty) makes.add(make);
    }

    final list = makes.toList()..sort();
    makeSuggestions.assignAll(list);
    makeSuggestions.refresh(); // ✅ force rebuild
  }

  // ================= SELECT MAKE =================
  Future<void> selectMake(String make) async {
    selectedMake.value = make;

    // reset downstream
    selectedModel.value = "";
    selectedYearLabel.value = "";
    selectedCarId.value = "";

    modelSuggestions.clear();
    yearLabelSuggestions.clear();
    modelSuggestions.refresh();
    yearLabelSuggestions.refresh();

    await loadModelsForSelectedMake();
  }

  // ================= LOAD MODELS =================
  Future<void> loadModelsForSelectedMake() async {
    if (selectedMake.value.isEmpty) return;

    await _warmUpCache();

    final makeKey = selectedMake.value.toLowerCase();
    final Set<String> models = {};

    for (final doc in _cache) {
      final data = doc.data();
      final mkLower = (data["makeLower"] ?? data["makeKey"] ?? "").toString();
      if (mkLower != makeKey) continue;

      final model = (data["model"] ?? "").toString().trim();
      if (model.isNotEmpty) models.add(model);
    }

    final list = models.toList()..sort();
    modelSuggestions.assignAll(list);
    modelSuggestions.refresh(); // ✅ force rebuild
  }

  // ================= SELECT MODEL =================
  Future<void> selectModel(String model) async {
    selectedModel.value = model;

    selectedYearLabel.value = "";
    selectedCarId.value = "";

    yearLabelSuggestions.clear();
    yearLabelSuggestions.refresh();

    await loadYearLabels();
  }

  // ================= LOAD YEARS =================
  Future<void> loadYearLabels() async {
    if (selectedMake.value.isEmpty || selectedModel.value.isEmpty) return;

    await _warmUpCache();

    final makeKey = selectedMake.value.toLowerCase();
    final modelKey = selectedModel.value.toLowerCase();

    final Set<String> labels = {};

    for (final doc in _cache) {
      final data = doc.data();

      final mkLower = (data["makeLower"] ?? data["makeKey"] ?? "").toString();
      final mdLower = (data["modelLower"] ?? data["modelKey"] ?? "").toString();

      if (mkLower == makeKey && mdLower == modelKey) {
        final yl = (data["yearLabel"] ?? "").toString().trim();
        if (yl.isNotEmpty) labels.add(yl);
      }
    }

    final list = labels.toList()..sort();
    yearLabelSuggestions.assignAll(list);
    yearLabelSuggestions.refresh(); // ✅ force rebuild
  }

  // ================= SELECT YEAR + FETCH CARID =================
  Future<void> selectYearLabelAndFetchCarId(String yearLabel) async {
    if (selectedMake.value.isEmpty || selectedModel.value.isEmpty) return;

    await _warmUpCache();

    selectedYearLabel.value = yearLabel;
    selectedCarId.value = "";

    final makeKey = selectedMake.value.toLowerCase();
    final modelKey = selectedModel.value.toLowerCase();

    for (final doc in _cache) {
      final data = doc.data();

      final mkLower = (data["makeLower"] ?? data["makeKey"] ?? "").toString();
      final mdLower = (data["modelLower"] ?? data["modelKey"] ?? "").toString();
      final yl = (data["yearLabel"] ?? "").toString();

      if (mkLower == makeKey && mdLower == modelKey && yl == yearLabel) {
        selectedCarId.value = doc.id;
        break;
      }
    }
  }


  void setGuestMode() {
    isGuest.value = true;
    user.value = null;
  }


  bool get canLocate =>
      selectedMake.value.isNotEmpty &&
          selectedModel.value.isNotEmpty &&
          selectedYearLabel.value.isNotEmpty &&
          selectedCarId.value.isNotEmpty;
}
