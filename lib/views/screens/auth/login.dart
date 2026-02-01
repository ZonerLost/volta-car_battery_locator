// ignore_for_file: prefer_const_constructors

import 'package:fire_fighter/controller/login_controller.dart';
import 'package:fire_fighter/views/screens/auth/forgot_password.dart';
import 'package:fire_fighter/views/screens/bottom_nav/BottomBarNav.dart';
import 'package:bounce/bounce.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:fire_fighter/constants/app_colors.dart';
import 'package:fire_fighter/generated/assets.dart';
import 'package:fire_fighter/views/screens/auth/signup.dart';
import 'package:fire_fighter/views/widget/common_image_view_widget.dart';
import 'package:fire_fighter/views/widget/custom_animated_column.dart';
import 'package:fire_fighter/views/widget/my_button_new.dart';
import 'package:fire_fighter/views/widget/my_text_widget.dart';
import 'package:fire_fighter/views/widget/my_textfeild.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final FocusNode _focusNodeEmail = FocusNode();
  final FocusNode _focusNodePassword = FocusNode();

  // ✅ controller
  final LoginController c = Get.put(LoginController());

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (_focusNodeEmail.hasFocus || _focusNodePassword.hasFocus) {
          _focusNodeEmail.unfocus();
          _focusNodePassword.unfocus();
        }
      },
      child: Scaffold(
        body: AnimatedListView(
          padding: EdgeInsets.all(0),
          children: [
            CommonImageView(
              imagePath: Assets.imagesLoginPhoto,
              width: Get.width,
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
                        text: "Welcome Back",
                        size: 24,
                        color: kFontText,
                        weight: FontWeight.w700,
                      ),
                    ],
                  ),
                  MyText(
                    text: "Log in to continue saving time in the field.",
                    size: 20,
                    paddingBottom: 32,
                    color: kFontText7,
                    weight: FontWeight.w600,
                  ),

                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      MyText(
                        text: "Email",
                        size: 16,
                        paddingBottom: 12,
                        color: kFontText,
                        weight: FontWeight.w700,
                      ),
                      MyTextField(
                        controller: c.emailC,
                        hint: "Enter your email ",
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

                      // ✅ password toggle (no UI change)
                      Obx(() => MyTextField(
                        controller: c.passwordC,
                        hint: "Enter your password",
                        hintsize: 14,
                        hintWeight: FontWeight.w600,
                        hintColor: kFontText5,
                        marginBottom: 12,
                        focusNode: _focusNodePassword,
                        isObSecure: c.obscurePass.value, // ✅ your widget uses isObSecure
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
                    ],
                  ),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    spacing: 6,
                    children: [
                      MyText(
                        onTap: () {
                          Get.to(() => ForgotPasswordScreen());
                        },
                        text: "Forgot Password?",
                        size: 16,
                        paddingBottom: 60,
                        color: kSecondaryColor,
                        weight: FontWeight.w600,
                      ),
                    ],
                  ),

                  // ✅ Login button now authenticates
                  Obx(() => MyButton(
                    onTap: c.isLoading.value
                        ? () {}
                        : () async {
                      final ok = await c.login();
                      if (ok) {
                        Get.offAll(() => BottomNavBar());
                      }
                    },
                    radius: 12,
                    buttonText: c.isLoading.value ? "Please wait..." : "Login",
                    hasgrad: true,
                  )),

                  Gap(20),
                  Row(
                    children: [
                      Expanded(child: Divider(color: kFontText, thickness: 1)),
                      Gap(10),
                      MyText(
                        text: "OR",
                        size: 16,
                        color: kFontText,
                        weight: FontWeight.w500,
                      ),
                      Gap(10),
                      Expanded(child: Divider(color: kFontText, thickness: 1)),
                    ],
                  ),
                  Gap(20),

                  // Guest: allow if you want (but Firestore rules will block reads if you require auth)
                  MyButton(
                    onTap: () {
                      Get.offAll(() => BottomNavBar());
                    },
                    radius: 12,
                    backgroundColor: kWhite,
                    outlineColor: kBorderColor3,
                    fontColor: kFontText,
                    buttonText: "Continue as Guest",
                    hasgrad: true,
                  ),

                  Gap(28),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      MyText(
                        text: "Don't have an account?",
                        size: 16,
                        color: kFontText7,
                        weight: FontWeight.w500,
                      ),
                      Gap(6),
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
