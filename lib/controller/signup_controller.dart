import 'package:flutter/material.dart';
import 'package:get/get.dart';
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

  @override
  void onClose() {
    fullNameC.dispose();
    emailC.dispose();
    passwordC.dispose();
    confirmPasswordC.dispose();
    super.onClose();
  }

  String? validate() {
    final fullName = fullNameC.text.trim();
    final email = emailC.text.trim();
    final pass = passwordC.text;
    final confirm = confirmPasswordC.text;

    if (fullName.isEmpty) return "Please enter full name";
    if (email.isEmpty) return "Please enter email";
    if (!GetUtils.isEmail(email)) return "Please enter a valid email";
    if (pass.isEmpty) return "Please enter password";
    if (pass.length < 6) return "Password must be at least 6 characters";
    if (confirm.isEmpty) return "Please confirm password";
    if (pass != confirm) return "Passwords do not match";
    if (!agreed.value) return "Please accept Terms & Privacy Policy";
    return null;
  }

  Future<bool> signUp() async {
    final err = validate();
    if (err != null) {
      Get.snackbar("Sign Up", err);
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
      Get.snackbar("Sign Up Failed", e.toString());
      return false;
    } finally {
      isLoading.value = false;
    }
  }
}
