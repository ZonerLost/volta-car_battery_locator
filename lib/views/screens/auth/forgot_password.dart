// ignore_for_file: prefer_const_constructors

import 'package:bounce/bounce.dart';
import 'package:fire_fighter/views/screens/auth/reset_password.dart';
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

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final FocusNode _focusNodeEmail = FocusNode();

  final _emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (_focusNodeEmail.hasFocus) {
          _focusNodeEmail.unfocus();
        }
      },
      child: Scaffold(
        body: AnimatedListView(
          padding: EdgeInsets.all(0),
          children: [
            Stack(
              children: [
                CommonImageView(
                  imagePath: Assets.imagesForgotpasswordPhoto,
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
                        text: "Forgot Your Password?",
                        size: 24,
                        color: kFontText,
                        weight: FontWeight.w700,
                      ),
                    ],
                  ),
                  MyText(
                    text:
                        "Enter your email, and we’ll send a link to reset your password.",
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
                        hint: "e.g. Jandoe@gmail.com",
                        hintsize: 14,
                        hintColor: kFontText5,
                        hintWeight: FontWeight.w600,
                        marginBottom: 60,
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

                  MyButton(
                    onTap: () {
                      Get.to(() => ResetPasswordScreen());
                    },
                    radius: 12,
                    buttonText: "Send Reset Link",
                    hasgrad: true,
                  ),
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
                  Gap(28),
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
