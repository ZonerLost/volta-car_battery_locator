// lib/views/screens/auth/forgot_password.dart
// ignore_for_file: prefer_const_constructors

import 'package:bounce/bounce.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fire_fighter/constants/app_colors.dart';
import 'package:fire_fighter/constants/extensions.dart';
import 'package:fire_fighter/generated/assets.dart';
import 'package:fire_fighter/views/screens/auth/login.dart';
import 'package:fire_fighter/views/widget/common_image_view_widget.dart';
import 'package:fire_fighter/views/widget/custom_animated_column.dart';
import 'package:fire_fighter/views/widget/my_button_new.dart';
import 'package:fire_fighter/views/widget/my_text_widget.dart';
import 'package:fire_fighter/views/widget/my_textfeild.dart';

import '../../../controller/forgot_password_controller.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final FocusNode _focusNodeEmail = FocusNode();

  // ✅ controller (no UI change)
  final ForgotPasswordController c = Get.put(ForgotPasswordController());

  @override
  void dispose() {
    _focusNodeEmail.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final compact = context.screenHeight < 720;
    final horizontalPadding = context.rs(compact ? 22 : 28, min: 20);
    final heroHeight = context.hp(compact ? 18 : 22).clamp(118, 180).toDouble();

    return GestureDetector(
      onTap: () {
        if (_focusNodeEmail.hasFocus) {
          _focusNodeEmail.unfocus();
        }
      },
      child: Scaffold(
        body: AnimatedListView(
          padding: EdgeInsets.zero,
          children: [
            Stack(
              children: [
                CommonImageView(
                  imagePath: Assets.imagesForgotpasswordPhoto,
                  width: context.screenWidth,
                  height: heroHeight,
                  fit: BoxFit.cover,
                ),
                Positioned(
                  top: context.rs(34, min: 28),
                  left: context.rs(22, min: 18),
                  child: Bounce(
                    onTap: () {
                      Get.back();
                    },
                    child: CommonImageView(
                      imagePath: Assets.imagesBackArrowWhite,
                      height: context.rs(32, min: 28),
                    ),
                  ),
                ),
              ],
            ),
            Container(
              color: kbackground,
              padding: EdgeInsets.fromLTRB(
                horizontalPadding,
                context.rs(compact ? 18 : 24, min: 16),
                horizontalPadding,
                context.rs(18, min: 14),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      MyText(
                        text: "Forgot Your Password?",
                        size: compact ? 22 : 24,
                        color: kFontText,
                        weight: FontWeight.w700,
                      ),
                    ],
                  ),
                  MyText(
                    text:
                        "Enter your email, and we'll send a link to reset your password.",
                    size: compact ? 16 : 18,
                    paddingBottom: compact ? 18 : 24,
                    color: kFontText7,
                    weight: FontWeight.w600,
                  ),

                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      MyText(
                        text: "Email",
                        size: 16,
                        paddingBottom: 8,
                        color: kFontText,
                        weight: FontWeight.w700,
                      ),
                      MyTextField(
                        controller:
                            c.emailC, // ✅ attach controller (no UI change)
                        hint: "e.g. Jandoe@gmail.com",
                        hintsize: 14,
                        hintColor: kFontText5,
                        hintWeight: FontWeight.w600,
                        marginBottom: compact ? 18 : 24,
                        prefix: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: CommonImageView(
                            imagePath: Assets.imagesPerson,
                            height: 24,
                          ),
                        ),
                        borderColor: kBorderColor3,
                        focusNode: _focusNodeEmail,
                      ),
                    ],
                  ),

                  // ✅ Send reset email using Firebase
                  Obx(
                    () => MyButton(
                      onTap:
                          c.isLoading.value
                              ? () {}
                              : () async {
                                await c.sendResetLink();
                                // ✅ No navigation. User will reset via email link.
                              },
                      radius: 12,
                      buttonText:
                          c.isLoading.value
                              ? "Please wait..."
                              : "Send Reset Link",
                      hasgrad: true,
                    ),
                  ),

                  context.rs(compact ? 12 : 16).vSpace,
                  Row(
                    children: [
                      Expanded(child: Divider(color: kFontText, thickness: 1)),
                      context.rs(10).hSpace,
                      MyText(
                        text: "OR",
                        size: 16,
                        color: kFontText,
                        weight: FontWeight.w500,
                      ),
                      context.rs(10).hSpace,
                      Expanded(child: Divider(color: kFontText, thickness: 1)),
                    ],
                  ),
                  context.rs(compact ? 12 : 16).vSpace,
                  MyButton(
                    onTap: () {
                      Get.off(() => LoginScreen());
                    },
                    radius: 12,
                    backgroundColor: kWhite,
                    outlineColor: kBorderColor3,
                    fontColor: kFontText,
                    buttonText: "Back to Log In",
                    hasgrad: true,
                  ),
                  context.rs(compact ? 16 : 22).vSpace,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      MyText(
                        text: "Remembered your credentials? ",
                        size: 16,
                        color: kFontText7,
                        weight: FontWeight.w500,
                      ),
                      Bounce(
                        onTap: () {
                          Get.to(() => LoginScreen());
                        },
                        child: MyText(
                          text: "Login now",
                          size: 16,
                          color: kSecondaryColor,
                          weight: FontWeight.w600,
                        ),
                      ),
                    ],
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
