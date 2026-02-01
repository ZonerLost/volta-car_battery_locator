// ignore_for_file: prefer_const_constructors

import 'package:bounce/bounce.dart';
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

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final FocusNode _focusNodePassword = FocusNode();
  final FocusNode _focusNodeConfrimPassword = FocusNode();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (_focusNodePassword.hasFocus || _focusNodeConfrimPassword.hasFocus) {
          _focusNodePassword.unfocus();
          _focusNodeConfrimPassword.unfocus();
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
                        text: "Reset Your Password",
                        size: 24,
                        color: kFontText,
                        weight: FontWeight.w700,
                      ),
                    ],
                  ),
                  MyText(
                    text: "Use a new, strong password to secure your account.",
                    size: 20,
                    paddingBottom: 32,
                    color: kFontText7,
                    weight: FontWeight.w600,
                  ),

                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        spacing: 6,
                        children: [
                          MyText(
                            text: "New Password",
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
                      MyTextField(
                        hint: "Enter your new password",
                        hintsize: 14,
                        hintWeight: FontWeight.w600,
                        hintColor: kFontText5,
                        marginBottom: 12,
                        focusNode: _focusNodePassword,
                        prefix: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: CommonImageView(
                            imagePath: Assets.imagesLock,
                            height: 24,
                          ),
                        ),
                        suffix: Bounce(
                          onTap: () {},
                          child: CommonImageView(
                            imagePath: Assets.imagesEye, // Change icon
                            height: 24,
                          ),
                        ),
                      ),

                      Row(
                        spacing: 6,
                        children: [
                          MyText(
                            text: "Confrim Password",
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
                      MyTextField(
                        hint: "Confrim your new password",
                        hintsize: 14,
                        hintWeight: FontWeight.w600,
                        hintColor: kFontText5,
                        marginBottom: 60,
                        focusNode: _focusNodePassword,
                        prefix: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: CommonImageView(
                            imagePath: Assets.imagesLock,
                            height: 24,
                          ),
                        ),
                        suffix: Bounce(
                          onTap: () {},
                          child: CommonImageView(
                            imagePath: Assets.imagesEye, // Change icon
                            height: 24,
                          ),
                        ),
                      ),
                    ],
                  ),
                  MyButton(
                    onTap: () {
                      Get.offAll(() => LoginScreen());
                    },
                    radius: 12,
                    buttonText: "Reset",
                    hasgrad: true,
                  ),
                  Gap(20),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
