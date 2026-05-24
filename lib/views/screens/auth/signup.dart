// ignore_for_file: prefer_const_constructors

import 'package:bounce/bounce.dart';
import 'package:fire_fighter/views/screens/auth/waiver_detail.dart';
import 'package:fire_fighter/views/widget/custom_checkbox_widget.dart';
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
    final compact = context.screenHeight < 720;
    final horizontalPadding = context.rs(compact ? 22 : 28, min: 20);
    final heroHeight = context.hp(compact ? 14 : 18).clamp(96, 150).toDouble();

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
          padding: EdgeInsets.zero,
          children: [
            Stack(
              children: [
                CommonImageView(
                  imagePath: Assets.imagesLoginPhoto,
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
                context.rs(compact ? 16 : 22, min: 14),
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
                        text: "Create Your Account",
                        size: compact ? 22 : 24,
                        color: kFontText,
                        weight: FontWeight.w700,
                      ),
                    ],
                  ),
                  MyText(
                    text:
                        "Join the community keeping data accurate and reliable.",
                    size: compact ? 16 : 18,
                    paddingBottom: compact ? 14 : 20,
                    color: kFontText7,
                    weight: FontWeight.w600,
                  ),

                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      MyText(
                        text: "Full Name",
                        size: 16,
                        paddingBottom: 8,
                        color: kFontText,
                        weight: FontWeight.w700,
                      ),
                      MyTextField(
                        controller: c.fullNameC, // ✅
                        hint: "Enter your full name ",
                        hintsize: 14,
                        hintColor: kFontText5,
                        hintWeight: FontWeight.w600,
                        marginBottom: compact ? 8 : 10,
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
                        paddingBottom: 8,
                        color: kFontText,
                        weight: FontWeight.w700,
                      ),
                      MyTextField(
                        controller: c.emailC, // ✅
                        hint: "Enter your email ",
                        hintsize: 14,
                        hintColor: kFontText5,
                        hintWeight: FontWeight.w600,
                        marginBottom: compact ? 8 : 10,
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
                      context.rs(compact ? 8 : 10).vSpace,

                      // ✅ password with toggle (UI same)
                      Obx(
                        () => MyTextField(
                          controller: c.passwordC, // ✅
                          hint: "Enter your password",
                          hintsize: 14,
                          hintWeight: FontWeight.w600,
                          hintColor: kFontText5,
                          marginBottom: compact ? 8 : 10,
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
                        ),
                      ),

                      // ✅ confirm password (same styling)
                      Obx(
                        () => MyTextField(
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
                              c.obscureConfirm.value = !c.obscureConfirm.value;
                            },
                            child: CommonImageView(
                              imagePath: Assets.imagesEye,
                              height: 24,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  context.rs(compact ? 8 : 10).vSpace,

                  // ✅ checkbox bind
                  Obx(
                    () => CustomCheckbox(
                      text:
                          "I have read and agree to the Terms & Conditions and Privacy Policy.",
                      value: c.agreed.value, // ✅ add in widget
                      onChanged: (bool value) {
                        c.agreed.value = value;
                      },
                    ),
                  ),

                  context.rs(compact ? 18 : 26).vSpace,

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
                          c.isLoading.value ? "Please wait..." : "Sign Up",
                      hasgrad: true,
                    ),
                  ),

                  context.rs(compact ? 16 : 22).vSpace,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      MyText(
                        text: "Already have an account?",
                        size: 16,
                        color: kFontText7,
                        weight: FontWeight.w500,
                      ),
                      context.rs(6).hSpace,
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
