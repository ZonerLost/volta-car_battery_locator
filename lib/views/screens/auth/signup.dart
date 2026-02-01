// ignore_for_file: prefer_const_constructors

import 'package:fire_fighter/views/screens/auth/otp.dart';
import 'package:bounce/bounce.dart';
import 'package:fire_fighter/views/screens/auth/waiver_detail.dart';
import 'package:fire_fighter/views/widget/custom_checkbox_widget.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:fire_fighter/constants/app_colors.dart';
import 'package:fire_fighter/generated/assets.dart';
import 'package:fire_fighter/views/screens/auth/login.dart';
import 'package:fire_fighter/views/widget/common_image_view_widget.dart';
import 'package:fire_fighter/views/widget/custom_animated_column.dart';
import 'package:fire_fighter/views/widget/my_button_new.dart';
import 'package:fire_fighter/views/widget/my_text_widget.dart';
import 'package:fire_fighter/views/widget/my_textfeild.dart';

import '../../../controller/signup_controller.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final FocusNode _focusNodeEmail = FocusNode();
  final FocusNode _focusNodeFullName = FocusNode();
  final FocusNode _focusNodePassword = FocusNode();
  final FocusNode _focusNodeConfrimPassword = FocusNode();

  // ✅ controller
  final SignUpController c = Get.put(SignUpController());

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (_focusNodeEmail.hasFocus ||
            _focusNodePassword.hasFocus ||
            _focusNodeConfrimPassword.hasFocus ||
            _focusNodeFullName.hasFocus) {
          _focusNodeEmail.unfocus();
          _focusNodePassword.unfocus();
          _focusNodeConfrimPassword.unfocus();
          _focusNodeFullName.unfocus();
        }
      },
      child: Scaffold(
        body: AnimatedListView(
          padding: EdgeInsets.all(0),
          children: [
            Stack(
              children: [
                CommonImageView(
                  imagePath: Assets.imagesLoginPhoto,
                  width: Get.width,
                ),
                Positioned(
                  top: 40,
                  left: 30,
                  child: Bounce(
                    onTap: () {
                      Get.back();
                    },
                    child: CommonImageView(
                      imagePath: Assets.imagesBackArrowWhite,
                      height: 34,
                    ),
                  ),
                ),
              ],
            ),
            Container(
              color: kbackground,
              padding: const EdgeInsets.all(32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      MyText(
                        text: "Create Your Account",
                        size: 24,
                        color: kFontText,
                        weight: FontWeight.w700,
                      ),
                    ],
                  ),
                  MyText(
                    text: "Join the community keeping data accurate and reliable.",
                    size: 20,
                    paddingBottom: 32,
                    color: kFontText7,
                    weight: FontWeight.w600,
                  ),

                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      MyText(
                        text: "Full Name",
                        size: 16,
                        paddingBottom: 12,
                        color: kFontText,
                        weight: FontWeight.w700,
                      ),
                      MyTextField(
                        controller: c.fullNameC, // ✅
                        hint: "Enter your full name ",
                        hintsize: 14,
                        hintColor: kFontText5,
                        hintWeight: FontWeight.w600,
                        marginBottom: 12,
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

                      MyText(
                        text: "Email Address",
                        size: 16,
                        paddingBottom: 12,
                        color: kFontText,
                        weight: FontWeight.w700,
                      ),
                      MyTextField(
                        controller: c.emailC, // ✅
                        hint: "Enter your email ",
                        hintsize: 14,
                        hintColor: kFontText5,
                        hintWeight: FontWeight.w600,
                        marginBottom: 12,
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

                      Row(
                        spacing: 6,
                        children: [
                          MyText(
                            text: "Password",
                            size: 16,
                            color: kFontText,
                            weight: FontWeight.w700,
                          ),
                          CommonImageView(
                            imagePath: Assets.imagesPasswordIcon,
                            height: 16,
                          ),
                        ],
                      ),
                      Gap(12),

                      // ✅ password with toggle (UI same)
                      Obx(() => MyTextField(
                        controller: c.passwordC, // ✅
                        hint: "Enter your password",
                        hintsize: 14,
                        hintWeight: FontWeight.w600,
                        hintColor: kFontText5,
                        marginBottom: 12,
                        focusNode: _focusNodePassword,
                        obscureText: c.obscurePass.value, // ✅
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
                      )),

                      // ✅ confirm password (same styling)
                      Obx(() => MyTextField(
                        controller: c.confirmPasswordC, // ✅
                        hint: "Confirm your password",
                        hintsize: 14,
                        hintWeight: FontWeight.w600,
                        hintColor: kFontText5,
                        marginBottom: 0,
                        focusNode: _focusNodeConfrimPassword,
                        obscureText: c.obscureConfirm.value, // ✅
                        prefix: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: CommonImageView(
                            imagePath: Assets.imagesLock,
                            height: 24,
                          ),
                        ),
                        suffix: Bounce(
                          onTap: () {
                            c.obscureConfirm.value =
                            !c.obscureConfirm.value;
                          },
                          child: CommonImageView(
                            imagePath: Assets.imagesEye,
                            height: 24,
                          ),
                        ),
                      )),
                    ],
                  ),

                  Gap(12),

                  // ✅ checkbox bind
                  Obx(() => CustomCheckbox(
                    text:
                    "I have read and agree to your Terms &\nConditions & Privacy Policies.",
                    value: c.agreed.value, // ✅ add in widget
                    onChanged: (bool value) {
                      c.agreed.value = value;
                    },
                  )),

                  Gap(60),

                  Obx(() => MyButton(
                    onTap: c.isLoading.value
                        ? () {}
                        : () async {
                      final ok = await c.signUp();
                      if (ok) {
                        Get.offAll(() => WavierDetailScreen());
                      }
                    },
                    radius: 12,
                    buttonText:
                    c.isLoading.value ? "Please wait..." : "Sign Up",
                    hasgrad: true,
                  )),

                  Gap(28),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      MyText(
                        text: "Already have an account?",
                        size: 16,
                        color: kFontText7,
                        weight: FontWeight.w500,
                      ),
                      Gap(6),
                      Bounce(
                        onTap: () {
                          Get.to(() => LoginScreen());
                        },
                        child: MyText(
                          text: "Login",
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
