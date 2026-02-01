import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EditProfileController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  final fullNameC = TextEditingController();
  final emailC = TextEditingController();
  final newPasswordC = TextEditingController();

  final isLoading = false.obs;
  final isSaving = false.obs;
  final obscurePassword = true.obs;

  String _originalEmail = "";

  @override
  void onInit() {
    super.onInit();
    loadUserData();
  }

  @override
  void onClose() {
    fullNameC.dispose();
    emailC.dispose();
    newPasswordC.dispose();
    super.onClose();
  }

  // ================= LOAD USER =================

  Future<void> loadUserData() async {
    try {
      isLoading.value = true;

      final user = _auth.currentUser;
      if (user == null) return;

      _originalEmail = user.email ?? "";
      emailC.text = _originalEmail;

      final doc = await _db.collection("users").doc(user.uid).get();
      final data = doc.data();

      if (data != null) {
        fullNameC.text = (data["fullName"] ?? data["name"] ?? "").toString();
      }
    } catch (e) {
      Get.snackbar("Error", e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  // ================= SAVE PROFILE =================

  Future<void> saveProfile() async {
    final user = _auth.currentUser;
    if (user == null) {
      Get.snackbar("Error", "User not logged in.");
      return;
    }

    final name = fullNameC.text.trim();
    final email = emailC.text.trim();

    if (name.isEmpty) {
      Get.snackbar("Error", "Full name is required.");
      return;
    }
    if (email.isEmpty) {
      Get.snackbar("Error", "Email is required.");
      return;
    }

    try {
      isSaving.value = true;

      // ✅ If email changed, in Firebase Auth v6 you use verifyBeforeUpdateEmail
      // This sends a verification email and updates after verification.
      if (email != _originalEmail && email.isNotEmpty) {
        await user.verifyBeforeUpdateEmail(email);
        // NOTE: email changes after user verifies the email from inbox.
        // We'll still store requested email in Firestore for now.
      }

      // ✅ Update Firestore profile
      await _db.collection("users").doc(user.uid).set({
        "fullName": name,
        "email": email,
        "updatedAt": FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));

      Get.snackbar("Success",
          email != _originalEmail
              ? "Profile saved. Please verify email from inbox to update login email."
              : "Profile updated successfully.");

      Get.back(result: true);
    } catch (e) {
      Get.snackbar("Error", e.toString());
    } finally {
      isSaving.value = false;
    }
  }

  // ================= PASSWORD =================

  Future<void> changePassword() async {
    final user = _auth.currentUser;
    if (user == null) {
      Get.snackbar("Error", "User not logged in.");
      return;
    }

    final pass = newPasswordC.text.trim();

    if (pass.length < 6) {
      Get.snackbar("Error", "Password must be at least 6 characters.");
      return;
    }

    try {
      isSaving.value = true;
      await user.updatePassword(pass);

      newPasswordC.clear();
      Get.snackbar("Success", "Password updated successfully.");
    } catch (e) {
      // Usually requires re-login
      Get.snackbar("Error", "Re-login required to change password.");
    } finally {
      isSaving.value = false;
    }
  }

  void togglePasswordVisibility() {
    obscurePassword.value = !obscurePassword.value;
  }
}
