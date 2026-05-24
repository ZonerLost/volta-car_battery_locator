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

  Future<void> loadUserData() async {
    try {
      isLoading.value = true;

      final user = _auth.currentUser;
      if (user == null) return;

      _originalEmail = (user.email ?? "").trim();
      emailC.text = _originalEmail;

      final doc = await _db.collection("users").doc(user.uid).get();
      final data = doc.data();

      if (data != null) {
        fullNameC.text = (data["fullName"] ?? data["name"] ?? "").toString();
        final pendingEmail = (data["pendingEmail"] ?? "").toString().trim();
        if (pendingEmail.isNotEmpty) {
          emailC.text = pendingEmail;
        }
      }
    } catch (e) {
      Get.snackbar("Error", e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> saveProfile() async {
    final user = _auth.currentUser;
    if (user == null) {
      Get.snackbar("Error", "User not logged in.");
      return false;
    }

    final name = fullNameC.text.trim();
    final email = emailC.text.trim();

    if (name.isEmpty) {
      Get.snackbar("Error", "Full name is required.");
      return false;
    }
    if (email.isEmpty) {
      Get.snackbar("Error", "Email is required.");
      return false;
    }

    try {
      isSaving.value = true;
      final emailChanged = email != _originalEmail && email.isNotEmpty;

      if (emailChanged) {
        await user.verifyBeforeUpdateEmail(email);
      }

      final data = <String, dynamic>{
        "fullName": name,
        "email": emailChanged ? _originalEmail : email,
        "updatedAt": FieldValue.serverTimestamp(),
      };

      if (emailChanged) {
        data["pendingEmail"] = email;
        data["emailChangeRequestedAt"] = FieldValue.serverTimestamp();
      } else {
        data["pendingEmail"] = FieldValue.delete();
        data["emailChangeRequestedAt"] = FieldValue.delete();
      }

      await _db
          .collection("users")
          .doc(user.uid)
          .set(data, SetOptions(merge: true));

      Get.snackbar(
        "Success",
        emailChanged
            ? "Verification link sent to your new email. Please verify it to complete email change."
            : "Profile updated successfully.",
      );

      return true;
    } on FirebaseAuthException catch (e) {
      if (e.code == "requires-recent-login") {
        Get.snackbar(
          "Login Required",
          "Please log in again before changing your email.",
        );
      } else {
        Get.snackbar("Error", e.message ?? e.code);
      }
      return false;
    } catch (e) {
      Get.snackbar("Error", e.toString());
      return false;
    } finally {
      isSaving.value = false;
    }
  }

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
    } on FirebaseAuthException catch (e) {
      if (e.code == "requires-recent-login") {
        Get.snackbar(
          "Login Required",
          "Please log in again before changing your password.",
        );
      } else {
        Get.snackbar("Error", e.message ?? e.code);
      }
    } catch (_) {
      Get.snackbar("Error", "Re-login required to change password.");
    } finally {
      isSaving.value = false;
    }
  }

  void togglePasswordVisibility() {
    obscurePassword.value = !obscurePassword.value;
  }
}
