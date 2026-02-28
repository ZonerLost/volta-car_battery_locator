import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../data/auth_repo.dart';

class LoginController extends GetxController {
  LoginController({AuthRepo? repo}) : _repo = repo ?? AuthRepo();
  final AuthRepo _repo;

  // UI controllers
  final emailC = TextEditingController();
  final passwordC = TextEditingController();

  // UI state
  final isLoading = false.obs;
  final obscurePass = true.obs; // your UI uses this

  @override
  void onClose() {
    emailC.dispose();
    passwordC.dispose();
    super.onClose();
  }

  String? validate() {
    final email = emailC.text.trim();
    final pass = passwordC.text;

    if (email.isEmpty) return "Please enter email";
    if (!GetUtils.isEmail(email)) return "Please enter a valid email";
    if (pass.isEmpty) return "Please enter password";
    if (pass.length < 6) return "Password must be at least 6 characters";
    return null;
  }

  Future<bool> login() async {
    final err = validate();
    if (err != null) {
      Get.snackbar("Login", err);
      return false;
    }

    try {
      isLoading.value = true;

      await _repo.login(
        email: emailC.text.trim(),
        password: passwordC.text,
      );

      return true;
    } catch (e) {
      Get.snackbar("Login Failed", e.toString());
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> sendResetEmail() async {
    final email = emailC.text.trim();
    if (email.isEmpty) {
      Get.snackbar("Forgot Password", "Please enter your email first.");
      return;
    }
    if (!GetUtils.isEmail(email)) {
      Get.snackbar("Forgot Password", "Please enter a valid email.");
      return;
    }

    try {
      isLoading.value = true;
      await _repo.forgotPassword(email);
      Get.snackbar("Success", "Password reset email sent.");
    } catch (e) {
      Get.snackbar("Reset Failed", e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> guestLogin() async {
    try {
      isLoading.value = true;
      await _repo.signInAnonymously();
      return true;
    } catch (e) {
      Get.snackbar("Guest Login Failed", e.toString());
      return false;
    } finally {
      isLoading.value = false;
    }
  }
  Future<bool> googleLogin() async {
    try {
      isLoading.value = true;
      await _repo.signInWithGoogle();
      return true;
    } catch (e) {
      Get.snackbar("Google Sign-In Failed", e.toString());
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> appleLogin() async {
    try {
      isLoading.value = true;
      await _repo.signInWithApple();
      return true;
    } catch (e) {
      Get.snackbar("Apple Sign-In Failed", e.toString());
      return false;
    } finally {
      isLoading.value = false;
    }
  }
}
