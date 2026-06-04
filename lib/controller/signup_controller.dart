import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fire_fighter/utils/app_snackbar.dart';
import '../data/auth_repo.dart';

class SignUpController extends GetxController {
  SignUpController({AuthRepo? repo}) : _repo = repo ?? AuthRepo();

  final AuthRepo _repo;

  // form controllers
  final fullNameC = TextEditingController();
  final emailC = TextEditingController();
  final passwordC = TextEditingController();
  final confirmPasswordC = TextEditingController();

  // ui state
  final isLoading = false.obs;
  final agreed = false.obs;
  final obscurePass = true.obs;
  final obscureConfirm = true.obs;
  final fullNameError = "".obs;
  final emailError = "".obs;
  final passwordError = "".obs;
  final confirmPasswordError = "".obs;
  final termsError = "".obs;

  @override
  void onClose() {
    fullNameC.dispose();
    emailC.dispose();
    passwordC.dispose();
    confirmPasswordC.dispose();
    super.onClose();
  }

  String? validate() {
    fullNameError.value = "";
    emailError.value = "";
    passwordError.value = "";
    confirmPasswordError.value = "";
    termsError.value = "";

    final fullName = fullNameC.text.trim();
    final email = emailC.text.trim();
    final pass = passwordC.text;
    final confirm = confirmPasswordC.text;

    var firstError = "";

    if (fullName.isEmpty) {
      fullNameError.value = "Full name is required.";
      firstError = fullNameError.value;
    }
    if (email.isEmpty) {
      emailError.value = "Email is required.";
      firstError = firstError.isEmpty ? emailError.value : firstError;
    } else if (!GetUtils.isEmail(email)) {
      emailError.value = "Enter a valid email address.";
      firstError = firstError.isEmpty ? emailError.value : firstError;
    }
    if (pass.isEmpty) {
      passwordError.value = "Password is required.";
      firstError = firstError.isEmpty ? passwordError.value : firstError;
    } else if (pass.length < 6) {
      passwordError.value = "Password must be at least 6 characters.";
      firstError = firstError.isEmpty ? passwordError.value : firstError;
    }
    if (confirm.isEmpty) {
      confirmPasswordError.value = "Confirm your password.";
      firstError = firstError.isEmpty ? confirmPasswordError.value : firstError;
    } else if (pass != confirm) {
      confirmPasswordError.value = "Passwords do not match.";
      firstError = firstError.isEmpty ? confirmPasswordError.value : firstError;
    }
    if (!agreed.value) {
      termsError.value = "Please accept Terms & Privacy Policy.";
      firstError = firstError.isEmpty ? termsError.value : firstError;
    }

    return firstError.isEmpty ? null : firstError;
  }

  void validatePasswordMatchLive() {
    if (confirmPasswordC.text.isEmpty) {
      confirmPasswordError.value = "";
      return;
    }

    confirmPasswordError.value =
        passwordC.text == confirmPasswordC.text
            ? ""
            : "Passwords do not match.";
  }

  Future<bool> signUp() async {
    final err = validate();
    if (err != null) {
      return false;
    }

    isLoading.value = true;
    try {
      await _repo.signUp(
        fullName: fullNameC.text.trim(),
        email: emailC.text.trim(),
        password: passwordC.text,
      );
      return true;
    } catch (e) {
      AppSnackBar.show("Sign Up Failed", _friendlyError(e));
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  String _friendlyError(Object e) {
    final raw = e.toString().replaceFirst("Exception: ", "").trim();
    if (raw.toLowerCase().contains("email-already-in-use")) {
      return "An account already exists with this email.";
    }
    return raw.isEmpty ? "Signup failed. Please try again." : raw;
  }
}
