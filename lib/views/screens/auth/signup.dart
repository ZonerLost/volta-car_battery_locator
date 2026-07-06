// ignore_for_file: prefer_const_constructors

import 'package:bounce/bounce.dart';
import 'package:fire_fighter/constants/app_colors.dart';
import 'package:fire_fighter/constants/extensions.dart';
import 'package:fire_fighter/controller/signup_controller.dart';
import 'package:fire_fighter/generated/assets.dart';
import 'package:fire_fighter/views/screens/auth/auth_widgets.dart';
import 'package:fire_fighter/views/screens/auth/login.dart';
import 'package:fire_fighter/views/screens/auth/waiver_detail.dart';
import 'package:fire_fighter/views/widget/common_image_view_widget.dart';
import 'package:fire_fighter/views/widget/custom_animated_column.dart';
import 'package:fire_fighter/views/widget/custom_checkbox_widget.dart';
import 'package:fire_fighter/views/widget/my_button_new.dart';
import 'package:fire_fighter/views/widget/my_textfeild.dart';
import 'package:fire_fighter/views/screens/profile/privacy.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final FocusNode _focusNodeEmail = FocusNode();
  final FocusNode _focusNodeFullName = FocusNode();
  final FocusNode _focusNodePassword = FocusNode();
  final FocusNode _focusNodeConfirmPassword = FocusNode();

  final SignUpController c = Get.put(SignUpController());

  @override
  void dispose() {
    _focusNodeEmail.dispose();
    _focusNodeFullName.dispose();
    _focusNodePassword.dispose();
    _focusNodeConfirmPassword.dispose();
    super.dispose();
  }

  void _unfocusFields() {
    _focusNodeEmail.unfocus();
    _focusNodeFullName.unfocus();
    _focusNodePassword.unfocus();
    _focusNodeConfirmPassword.unfocus();
  }

  @override
  Widget build(BuildContext context) {
    final compact = context.screenHeight < 720;
    final horizontalPadding = context.rs(compact ? 22 : 28, min: 20);

    return GestureDetector(
      onTap: _unfocusFields,
      child: Scaffold(
        body: AnimatedListView(
          padding: EdgeInsets.zero,
          children: [
            AuthHero(
              imagePath: Assets.imagesAuthVoltResponderBackground,
              title: "Create Account",
              subtitle: "Set up Volt and locate the right battery spot fast.",
              showBack: true,
            ),
            Container(
              color: kbackground,
              padding: EdgeInsets.fromLTRB(
                horizontalPadding,
                context.rs(compact ? 16 : 22, min: 14),
                horizontalPadding,
                context.rs(18, min: 14),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AuthFieldLabel(text: "Full Name *"),
                  Obx(
                    () => MyTextField(
                      controller: c.fullNameC,
                      hint: "Enter your full name",
                      hintsize: 14,
                      hintColor: kFontText5,
                      hintWeight: FontWeight.w600,
                      marginBottom: compact ? 8 : 10,
                      errorText: c.fullNameError.value,
                      onChanged: (_) => c.fullNameError.value = "",
                      prefix: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: CommonImageView(
                          imagePath: Assets.imagesPerson,
                          height: 24,
                        ),
                      ),
                      borderColor: kBorderColor3,
                      focusNode: _focusNodeFullName,
                    ),
                  ),
                  AuthFieldLabel(text: "Email Address *"),
                  Obx(
                    () => MyTextField(
                      controller: c.emailC,
                      hint: "name@example.com",
                      hintsize: 14,
                      hintColor: kFontText5,
                      hintWeight: FontWeight.w600,
                      keyboardType: TextInputType.emailAddress,
                      marginBottom: compact ? 8 : 10,
                      errorText: c.emailError.value,
                      onChanged: (_) => c.emailError.value = "",
                      prefix: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: CommonImageView(
                          imagePath: Assets.imagesEmail,
                          height: 24,
                        ),
                      ),
                      borderColor: kBorderColor3,
                      focusNode: _focusNodeEmail,
                    ),
                  ),
                  AuthFieldLabel(
                    text: "Password *",
                    iconPath: Assets.imagesPasswordIcon,
                  ),
                  Obx(
                    () => MyTextField(
                      controller: c.passwordC,
                      hint: "Create a password",
                      hintsize: 14,
                      hintWeight: FontWeight.w600,
                      hintColor: kFontText5,
                      marginBottom: compact ? 8 : 10,
                      focusNode: _focusNodePassword,
                      obscureText: c.obscurePass.value,
                      errorText: c.passwordError.value,
                      onChanged: (_) {
                        c.passwordError.value = "";
                        c.validatePasswordMatchLive();
                      },
                      prefix: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: CommonImageView(
                          imagePath: Assets.imagesLock,
                          height: 24,
                        ),
                      ),
                      suffix: Bounce(
                        onTap: () {
                          c.obscurePass.value = !c.obscurePass.value;
                        },
                        child: CommonImageView(
                          imagePath: Assets.imagesEye,
                          height: 24,
                        ),
                      ),
                    ),
                  ),
                  AuthFieldLabel(text: "Confirm Password *"),
                  Obx(
                    () => MyTextField(
                      controller: c.confirmPasswordC,
                      hint: "Re-enter your password",
                      hintsize: 14,
                      hintWeight: FontWeight.w600,
                      hintColor: kFontText5,
                      marginBottom: 0,
                      focusNode: _focusNodeConfirmPassword,
                      obscureText: c.obscureConfirm.value,
                      errorText: c.confirmPasswordError.value,
                      onChanged: (_) => c.validatePasswordMatchLive(),
                      prefix: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: CommonImageView(
                          imagePath: Assets.imagesLock,
                          height: 24,
                        ),
                      ),
                      suffix: Bounce(
                        onTap: () {
                          c.obscureConfirm.value = !c.obscureConfirm.value;
                        },
                        child: CommonImageView(
                          imagePath: Assets.imagesEye,
                          height: 24,
                        ),
                      ),
                    ),
                  ),
                  context.rs(compact ? 10 : 12).vSpace,
                  Obx(
                    () => CustomCheckbox(
                      text:
                          "I agree to Volt's Terms & Conditions and Privacy Policy.",
                      value: c.agreed.value,
                      onChanged: (bool value) {
                        c.agreed.value = value;
                        c.termsError.value = "";
                      },
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: TextButton(
                      onPressed:
                          () => Get.to(() => const PrivacyPolicyScreen()),
                      child: const Text("Read Privacy Policy & Terms"),
                    ),
                  ),
                  Obx(
                    () =>
                        c.termsError.value.isEmpty
                            ? const SizedBox.shrink()
                            : Padding(
                              padding: const EdgeInsets.only(top: 6),
                              child: Text(
                                c.termsError.value,
                                style: TextStyle(
                                  color: kPrimaryColor,
                                  fontSize: context.rs(11, min: 10),
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                  ),
                  context.rs(compact ? 18 : 24).vSpace,
                  Obx(
                    () => MyButton(
                      onTap:
                          c.isLoading.value
                              ? () {}
                              : () async {
                                final ok = await c.signUp();
                                if (ok) {
                                  Get.offAll(() => WavierDetailScreen());
                                }
                              },
                      radius: 12,
                      buttonText:
                          c.isLoading.value
                              ? "Please wait..."
                              : "Create Account",
                      hasgrad: true,
                    ),
                  ),
                  context.rs(compact ? 16 : 22).vSpace,
                  AuthFooterLink(
                    text: "Already have an account?",
                    actionText: "Log In",
                    onTap: () {
                      Get.to(() => LoginScreen());
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
