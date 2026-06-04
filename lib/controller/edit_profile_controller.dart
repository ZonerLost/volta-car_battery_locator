import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fire_fighter/utils/app_snackbar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EditProfileController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  final fullNameC = TextEditingController();
  final emailC = TextEditingController();
  final currentPasswordC = TextEditingController();
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
    currentPasswordC.dispose();
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
      }
    } catch (e) {
      AppSnackBar.show("Error", e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> saveProfile() async {
    final user = _auth.currentUser;
    if (user == null) {
      AppSnackBar.show("Error", "User not logged in.");
      return false;
    }

    final name = fullNameC.text.trim();
    final email = _originalEmail;
    final currentPass = currentPasswordC.text.trim();
    final newPass = newPasswordC.text.trim();
    final wantsPasswordChange = currentPass.isNotEmpty || newPass.isNotEmpty;

    if (name.isEmpty) {
      AppSnackBar.show("Error", "Full name is required.");
      return false;
    }
    if (wantsPasswordChange && currentPass.isEmpty) {
      AppSnackBar.show("Error", "Enter your current password first.");
      return false;
    }
    if (wantsPasswordChange && newPass.length < 6) {
      AppSnackBar.show("Error", "Password must be at least 6 characters.");
      return false;
    }

    try {
      isSaving.value = true;

      if (wantsPasswordChange) {
        await _updatePassword(user, currentPass, newPass);
      }

      final data = <String, dynamic>{
        "fullName": name,
        "email": email,
        "updatedAt": FieldValue.serverTimestamp(),
        "pendingEmail": FieldValue.delete(),
        "emailChangeRequestedAt": FieldValue.delete(),
      };

      await _db
          .collection("users")
          .doc(user.uid)
          .set(data, SetOptions(merge: true));

      currentPasswordC.clear();
      newPasswordC.clear();
      AppSnackBar.show(
        "Success",
        wantsPasswordChange
            ? "Profile and password updated successfully."
            : "Profile updated successfully.",
      );

      return true;
    } on FirebaseAuthException catch (e) {
      if (e.code == "requires-recent-login") {
        AppSnackBar.show(
          "Login Required",
          "Please log in again before changing your password.",
        );
      } else if (e.code == "wrong-password" || e.code == "invalid-credential") {
        AppSnackBar.show("Error", "Current password is incorrect.");
      } else {
        AppSnackBar.show("Error", e.message ?? e.code);
      }
      return false;
    } catch (e) {
      AppSnackBar.show("Error", e.toString());
      return false;
    } finally {
      isSaving.value = false;
    }
  }

  Future<void> _updatePassword(
    User user,
    String currentPass,
    String newPass,
  ) async {
    final email = user.email;
    if (email == null || email.trim().isEmpty) {
      throw FirebaseAuthException(
        code: "password-change-unavailable",
        message: "Password change is not available for this account.",
      );
    }

    final credential = EmailAuthProvider.credential(
      email: email,
      password: currentPass,
    );
    await user.reauthenticateWithCredential(credential);
    await user.updatePassword(newPass);
  }

  void togglePasswordVisibility() {
    obscurePassword.value = !obscurePassword.value;
  }
}
