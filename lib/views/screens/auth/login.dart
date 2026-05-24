// ignore_for_file: prefer_const_constructors

import 'package:fire_fighter/controller/login_controller.dart';
import 'package:fire_fighter/views/screens/auth/forgot_password.dart';
import 'package:fire_fighter/views/screens/bottom_nav/BottomBarNav.dart';
import 'package:bounce/bounce.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fire_fighter/constants/app_colors.dart';
import 'package:fire_fighter/constants/extensions.dart';
import 'package:fire_fighter/generated/assets.dart';
import 'package:fire_fighter/views/screens/auth/signup.dart';
import 'package:fire_fighter/views/widget/common_image_view_widget.dart';
import 'package:fire_fighter/views/widget/custom_animated_column.dart';
import 'package:fire_fighter/views/widget/my_button_new.dart';
import 'package:fire_fighter/views/widget/my_text_widget.dart';
import 'package:fire_fighter/views/widget/my_textfeild.dart';

import '../../../controller/SessionController.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final FocusNode _focusNodeEmail = FocusNode();
  final FocusNode _focusNodePassword = FocusNode();

  final session = Get.put(SessionController());
  final LoginController c = Get.put(LoginController());

  @override
  Widget build(BuildContext context) {
    final compact = context.screenHeight < 720;
    final horizontalPadding = context.rs(compact ? 22 : 28, min: 20);
    final heroHeight = context.hp(compact ? 18 : 22).clamp(118, 180).toDouble();

    return GestureDetector(
      onTap: () {
        if (_focusNodeEmail.hasFocus || _focusNodePassword.hasFocus) {
          _focusNodeEmail.unfocus();
          _focusNodePassword.unfocus();
        }
      },
      child: Scaffold(
        body: AnimatedListView(
          padding: EdgeInsets.zero,
          children: [
            CommonImageView(
              imagePath: Assets.imagesLoginPhoto,
              width: context.screenWidth,
              height: heroHeight,
              fit: BoxFit.cover,
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
                children: [
                  MyText(
                    text: "Welcome Back",
                    size: compact ? 22 : 24,
                    color: kFontText,
                    weight: FontWeight.w700,
                  ),

                  MyText(
                    text: "Log in to continue saving time in the field.",
                    size: compact ? 16 : 18,
                    paddingBottom: compact ? 18 : 24,
                    color: kFontText7,
                    weight: FontWeight.w600,
                  ),

                  /// ================= EMAIL =================
                  MyText(
                    text: "Email",
                    size: 16,
                    paddingBottom: 8,
                    color: kFontText,
                    weight: FontWeight.w700,
                  ),

                  MyTextField(
                    controller: c.emailC,
                    hint: "Enter your email",
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
                    focusNode: _focusNodeEmail,
                  ),

                  /// ================= PASSWORD =================
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

                  Obx(
                    () => MyTextField(
                      controller: c.passwordC,
                      hint: "Enter your password",
                      hintsize: 14,
                      hintWeight: FontWeight.w600,
                      hintColor: kFontText5,
                      marginBottom: compact ? 6 : 8,
                      focusNode: _focusNodePassword,
                      isObSecure: c.obscurePass.value,
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

                  /// ================= FORGOT PASSWORD =================
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      MyText(
                        onTap: () {
                          Get.to(() => ForgotPasswordScreen());
                        },
                        text: "Forgot Password?",
                        size: 16,
                        paddingBottom: compact ? 16 : 22,
                        color: kSecondaryColor,
                        weight: FontWeight.w600,
                      ),
                    ],
                  ),

                  /// ================= LOGIN BUTTON =================
                  Obx(
                    () => MyButton(
                      onTap:
                          c.isLoading.value
                              ? () {}
                              : () async {
                                final ok = await c.login();
                                if (ok) {
                                  Get.offAll(() => BottomNavBar());
                                }
                              },
                      radius: 12,
                      buttonText:
                          c.isLoading.value ? "Please wait..." : "Login",
                      hasgrad: true,
                    ),
                  ),

                  context.rs(compact ? 12 : 16).vSpace,

                  /// ================= OR =================
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

                  /// ================= GOOGLE SIGN IN =================
                  Obx(
                    () => MyButton(
                      onTap: () async {
                        if (c.isLoading.value) return;

                        final ok = await c.googleLogin();
                        if (ok) {
                          Get.offAll(() => BottomNavBar());
                        }
                      },
                      radius: 12,
                      backgroundColor: kWhite,
                      outlineColor: kBorderColor3,
                      fontColor: kFontText,
                      buttonText:
                          c.isLoading.value
                              ? "Please wait..."
                              : "Continue with Google",
                      hasgrad: true,
                    ),
                  ),

                  if (GetPlatform.isIOS) context.rs(10).vSpace,

                  /// ================= APPLE SIGN IN =================
                  if (GetPlatform.isIOS)
                    Obx(
                      () => MyButton(
                        onTap: () async {
                          if (c.isLoading.value) return;

                          final ok = await c.appleLogin();
                          if (ok) {
                            Get.offAll(() => BottomNavBar());
                          }
                        },
                        radius: 12,
                        backgroundColor: kWhite,
                        outlineColor: kBorderColor3,
                        fontColor: kFontText,
                        buttonText:
                            c.isLoading.value
                                ? "Please wait..."
                                : "Continue with Apple",
                        hasgrad: true,
                      ),
                    ),

                  context.rs(compact ? 16 : 22).vSpace,

                  /// ================= SIGN UP =================
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      MyText(
                        text: "Don't have an account?",
                        size: 16,
                        color: kFontText7,
                        weight: FontWeight.w500,
                      ),
                      context.rs(6).hSpace,
                      Bounce(
                        onTap: () {
                          Get.to(() => SignUpScreen());
                        },
                        child: MyText(
                          text: "Sign Up",
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
