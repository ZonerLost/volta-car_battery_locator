import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class WrongLocationController extends GetxController {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  final makeC = TextEditingController();
  final modelC = TextEditingController();
  final yearC = TextEditingController();
  final reportedAreaC = TextEditingController();
  final correctAreaC = TextEditingController();
  final messageC = TextEditingController();

  final isSubmitting = false.obs;
  final error = "".obs;

  /// ✅ NEW PATH: modules -> feedbackReports -> reports
  CollectionReference<Map<String, dynamic>> get reportsRef =>
      _db.collection("modules").doc("feedbackReports").collection("reports");

  /// ✅ NEW counter doc inside feedbackReports (recommended)
  DocumentReference<Map<String, dynamic>> get _counterRef =>
      _db.collection("modules").doc("feedbackReports")
          .collection("meta").doc("counters");

  @override
  void onClose() {
    makeC.dispose();
    modelC.dispose();
    yearC.dispose();
    reportedAreaC.dispose();
    correctAreaC.dispose();
    messageC.dispose();
    super.onClose();
  }

  void prefill({
    String? make,
    String? model,
    String? year,
    String? reportedArea,
  }) {
    if ((make ?? "").trim().isNotEmpty) makeC.text = make!.trim();
    if ((model ?? "").trim().isNotEmpty) modelC.text = model!.trim();
    if ((year ?? "").trim().isNotEmpty) yearC.text = year!.trim();
    if ((reportedArea ?? "").trim().isNotEmpty) {
      reportedAreaC.text = reportedArea!.trim();
    }
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

    if (correctAreaC.text.trim().isEmpty) {
      error.value = "Please enter Correct Area.";
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
      final reportedArea = reportedAreaC.text.trim();
      final correctArea = correctAreaC.text.trim();
      final msg = messageC.text.trim();

      final id = await _nextReportIdTx();

      final data = <String, dynamic>{
        "id": id,
        "type": "Incorrect Location",
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
        "reportedArea": reportedArea.isEmpty ? null : reportedArea,
        "correctArea": correctArea,
        "message": msg.isEmpty ? null : msg,
        "reviewedAt": null,
        "reviewedByUid": null,
      };

      await reportsRef.doc(id).set(data, SetOptions(merge: true));

      error.value = "";
      Get.back(result: true);
      Get.snackbar("Report Submitted", "Thanks! Your feedback has been sent.");
    } catch (e) {
      error.value = e.toString();
      Get.snackbar("Error", error.value);
    } finally {
      isSubmitting.value = false;
    }
  }
}
