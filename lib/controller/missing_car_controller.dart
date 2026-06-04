import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fire_fighter/utils/app_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MissingCarController extends GetxController {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // ================== FORM CONTROLLERS ==================
  final makeC = TextEditingController();
  final modelC = TextEditingController();
  final yearC = TextEditingController();
  final messageC = TextEditingController();

  final isSubmitting = false.obs;
  final error = "".obs;

  /// ✅ SAME PATH: modules -> feedbackReports -> reports
  CollectionReference<Map<String, dynamic>> get reportsRef =>
      _db.collection("modules").doc("feedbackReports").collection("reports");

  /// ✅ counter doc inside feedbackReports
  DocumentReference<Map<String, dynamic>> get _counterRef => _db
      .collection("modules")
      .doc("feedbackReports")
      .collection("meta")
      .doc("counters");

  @override
  void onClose() {
    makeC.dispose();
    modelC.dispose();
    yearC.dispose();
    messageC.dispose();
    super.onClose();
  }

  bool _validate() {
    error.value = "";

    if (makeC.text.trim().isEmpty) {
      error.value = "Please enter Make.";
      return false;
    }
    if (modelC.text.trim().isEmpty) {
      error.value = "Please enter Model.";
      return false;
    }
    if (yearC.text.trim().isEmpty) {
      error.value = "Please enter Year.";
      return false;
    }

    final year = int.tryParse(yearC.text.trim());
    if (year == null || year < 1900 || year > 2100) {
      error.value = "Please enter a valid Year (e.g. 2015).";
      return false;
    }

    return true;
  }

  Future<String> _nextReportIdTx() async {
    return _db.runTransaction((tx) async {
      final snap = await tx.get(_counterRef);

      int current = 1100;
      if (snap.exists && snap.data() != null) {
        final d = snap.data()!;
        final v = d["reportSeq"];
        if (v is int) current = v;
        if (v is num) current = v.toInt();
      }

      final next = current + 1;
      tx.set(_counterRef, {"reportSeq": next}, SetOptions(merge: true));
      return "RPT-$next";
    });
  }

  Future<void> submit() async {
    if (!_validate()) return;

    try {
      isSubmitting.value = true;

      final uid = _auth.currentUser?.uid ?? "";
      final email = _auth.currentUser?.email ?? "";

      final make = makeC.text.trim();
      final model = modelC.text.trim();
      final year = int.parse(yearC.text.trim());
      final msg = messageC.text.trim();

      final id = await _nextReportIdTx();

      final data = <String, dynamic>{
        "id": id,
        "type": "Missing Car",
        "category": null,
        "status": "pending",
        "createdAt": FieldValue.serverTimestamp(),
        "updatedAt": FieldValue.serverTimestamp(),

        "createdByUid": uid.isEmpty ? null : uid,
        "submittedBy": email.isEmpty ? null : email,

        "make": make,
        "model": model,
        "year": year,
        "car": "$make $model $year",

        "message": msg.isEmpty ? null : msg,

        // admin fields
        "reviewedAt": null,
        "reviewedByUid": null,
      };

      await reportsRef.doc(id).set(data, SetOptions(merge: true));

      error.value = "";
      Get.back(result: true);
      AppSnackBar.show(
        "Report Submitted",
        "Thanks! Your request has been sent.",
      );
    } catch (e) {
      error.value = e.toString();
      AppSnackBar.show("Error", error.value);
    } finally {
      isSubmitting.value = false;
    }
  }
}
