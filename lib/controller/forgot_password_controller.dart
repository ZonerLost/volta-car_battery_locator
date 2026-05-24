import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../data/auth_repo.dart';

class ForgotPasswordController extends GetxController {
  ForgotPasswordController({AuthRepo? repo}) : _repo = repo ?? AuthRepo();
  final AuthRepo _repo;

  final emailC = TextEditingController();
  final isLoading = false.obs;

  @override
  void onClose() {
    emailC.dispose();
    super.onClose();
  }

  String? _validateEmail() {
    final email = emailC.text.trim();
    if (email.isEmpty) return "Please enter email";
    if (!GetUtils.isEmail(email)) return "Please enter a valid email";
    return null;
  }

  Future<void> sendResetLink() async {
    final err = _validateEmail();
    if (err != null) {
      Get.snackbar("Forgot Password", err, snackPosition: SnackPosition.BOTTOM);
      return;
    }

    final email = emailC.text.trim();

    try {
      isLoading.value = true;

      await _repo.forgotPassword(email);

      Get.snackbar(
        "Email Sent",
        "Volt sent a password reset link to $email. Please check your inbox or spam folder.",
        snackPosition: SnackPosition.BOTTOM,
        duration: Duration(seconds: 4),
      );
    } on FirebaseAuthException catch (e) {
      // ✅ show clean messages
      final msg = _friendlyFirebaseMsg(e.code, e.message);
      Get.snackbar("Reset Failed", msg, snackPosition: SnackPosition.BOTTOM);
      debugPrint("FORGOT PASSWORD ERROR => code=${e.code}, message=${e.message}");
    } catch (e) {
      Get.snackbar("Reset Failed", e.toString(),
          snackPosition: SnackPosition.BOTTOM);
    } finally {
      isLoading.value = false;
    }
  }

  String _friendlyFirebaseMsg(String code, String? message) {
    switch (code) {
      case "user-not-found":
        return "No account found with this email.";
      case "invalid-email":
        return "Please enter a valid email address.";
      case "too-many-requests":
        return "Too many attempts. Please try again later.";
      case "network-request-failed":
        return "Network issue. Please check your internet.";
      default:
        return message ?? "Something went wrong. Please try again.";
    }
  }
}
