import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:fire_fighter/utils/app_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class GeneralFeedbackController extends GetxController {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  final emailC = TextEditingController();
  final categoryC = TextEditingController();
  final messageC = TextEditingController();

  final ImagePicker _picker = ImagePicker();

  final isSubmitting = false.obs;
  final error = "".obs;

  // Attachment
  final selectedFileName = "".obs;
  File? selectedFile;

  /// ✅ SAME PATH
  /// modules -> feedbackReports -> reports
  CollectionReference<Map<String, dynamic>> get reportsRef =>
      _db.collection("modules").doc("feedbackReports").collection("reports");

  /// ✅ Counter doc
  /// modules -> feedbackReports -> meta -> counters
  DocumentReference<Map<String, dynamic>> get _counterRef => _db
      .collection("modules")
      .doc("feedbackReports")
      .collection("meta")
      .doc("counters");

  @override
  void onInit() {
    super.onInit();
    final u = _auth.currentUser;
    if (u?.email != null && u!.email!.trim().isNotEmpty) {
      emailC.text = u.email!.trim();
    }
  }

  @override
  void onClose() {
    emailC.dispose();
    categoryC.dispose();
    messageC.dispose();
    super.onClose();
  }

  // =====================================================
  // ✅ PICK IMAGE (PNG/JPG)  -> this fixes your UI error
  // =====================================================
  Future<void> pickProofImage() async {
    try {
      final XFile? x = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 85,
      );
      if (x == null) return;

      selectedFile = File(x.path);
      selectedFileName.value = x.name; // proof.png etc
    } catch (e) {
      AppSnackBar.show("Error", "Unable to pick image: $e");
    }
  }

  void clearAttachment() {
    selectedFile = null;
    selectedFileName.value = "";
  }

  // ================= VALIDATION =================
  bool _validate() {
    error.value = "";

    if (emailC.text.trim().isEmpty) {
      error.value = "Please enter Email.";
      return false;
    }

    if (categoryC.text.trim().isEmpty) {
      error.value = "Please enter Category.";
      return false;
    }

    if (messageC.text.trim().isEmpty) {
      error.value = "Please enter Message.";
      return false;
    }

    return true;
  }

  // ================= REPORT ID =================
  Future<String> _nextReportIdTx() async {
    return _db.runTransaction((tx) async {
      final snap = await tx.get(_counterRef);

      int current = 1100;
      if (snap.exists && snap.data() != null) {
        final v = snap.data()!["reportSeq"];
        if (v is int) current = v;
        if (v is num) current = v.toInt();
      }

      final next = current + 1;
      tx.set(_counterRef, {"reportSeq": next}, SetOptions(merge: true));

      return "RPT-$next";
    });
  }

  // ================= UPLOAD FILE =================
  Future<String?> _uploadFile(String reportId) async {
    if (selectedFile == null) return null;

    final fileName =
        selectedFileName.value.trim().isEmpty
            ? "proof.jpg"
            : selectedFileName.value.trim();

    final ref = _storage.ref().child("feedbackReports/$reportId/$fileName");

    await ref.putFile(selectedFile!);

    return await ref.getDownloadURL();
  }

  // ================= SUBMIT =================
  Future<void> submit() async {
    if (!_validate()) {
      if (error.value.isNotEmpty) {
        AppSnackBar.show("Validation", error.value);
      }
      return;
    }

    try {
      isSubmitting.value = true;

      final uid = _auth.currentUser?.uid ?? "";
      final email = emailC.text.trim();
      final category = categoryC.text.trim();
      final message = messageC.text.trim();

      final reportId = await _nextReportIdTx();

      // Upload file if exists
      String? fileUrl;
      if (selectedFile != null) {
        fileUrl = await _uploadFile(reportId);
      }

      final data = <String, dynamic>{
        "id": reportId,
        "type": "General Feedback",
        "category": category,
        "status": "pending",
        "createdAt": FieldValue.serverTimestamp(),
        "updatedAt": FieldValue.serverTimestamp(),
        "createdByUid": uid.isEmpty ? null : uid,
        "submittedBy": email,
        "email": email,
        "message": message,
        "attachmentName":
            selectedFileName.value.trim().isEmpty
                ? null
                : selectedFileName.value.trim(),
        "attachmentUrl": fileUrl,
        "reviewedAt": null,
        "reviewedByUid": null,
      };

      await reportsRef.doc(reportId).set(data, SetOptions(merge: true));

      Get.back(result: true);
      AppSnackBar.show("Success", "Feedback submitted successfully.");
    } catch (e) {
      AppSnackBar.show("Error", e.toString());
    } finally {
      isSubmitting.value = false;
    }
  }
}
