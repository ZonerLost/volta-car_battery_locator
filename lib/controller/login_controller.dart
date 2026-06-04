import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fire_fighter/utils/app_snackbar.dart';
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
      AppSnackBar.show("Login", err);
      return false;
    }

    try {
      isLoading.value = true;

      await _repo.login(email: emailC.text.trim(), password: passwordC.text);

      return true;
    } catch (e) {
      AppSnackBar.show("Login Failed", _cleanError(e));
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> sendResetEmail() async {
    final email = emailC.text.trim();
    if (email.isEmpty) {
      AppSnackBar.show("Forgot Password", "Please enter your email first.");
      return;
    }
    if (!GetUtils.isEmail(email)) {
      AppSnackBar.show("Forgot Password", "Please enter a valid email.");
      return;
    }

    try {
      isLoading.value = true;
      await _repo.forgotPassword(email);
      AppSnackBar.show(
        "Email Sent",
        "Volt sent a password reset link to $email. Please check your inbox or spam folder.",
      );
    } catch (e) {
      AppSnackBar.show("Reset Failed", _cleanError(e));
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
      AppSnackBar.show("Guest Login Failed", _cleanError(e));
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
      AppSnackBar.show("Google Sign-In Failed", _cleanError(e));
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
      AppSnackBar.show("Apple Sign-In Failed", _cleanError(e));
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  String _cleanError(Object e) {
    final msg = e.toString().replaceFirst("Exception: ", "").trim();
    return msg.isEmpty ? "Something went wrong. Please try again." : msg;
  }
}
