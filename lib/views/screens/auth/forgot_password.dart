// ignore_for_file: prefer_const_constructors

import 'package:fire_fighter/constants/app_colors.dart';
import 'package:fire_fighter/constants/extensions.dart';
import 'package:fire_fighter/controller/forgot_password_controller.dart';
import 'package:fire_fighter/generated/assets.dart';
import 'package:fire_fighter/views/screens/auth/auth_widgets.dart';
import 'package:fire_fighter/views/screens/auth/login.dart';
import 'package:fire_fighter/views/widget/common_image_view_widget.dart';
import 'package:fire_fighter/views/widget/custom_animated_column.dart';
import 'package:fire_fighter/views/widget/my_button_new.dart';
import 'package:fire_fighter/views/widget/my_text_widget.dart';
import 'package:fire_fighter/views/widget/my_textfeild.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final FocusNode _focusNodeEmail = FocusNode();
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

    return GestureDetector(
      onTap: _focusNodeEmail.unfocus,
      child: Scaffold(
        body: AnimatedListView(
          padding: EdgeInsets.zero,
          children: [
            AuthHero(
              imagePath: Assets.imagesAuthVoltResponderBackground,
              title: "Reset Password",
              subtitle: "We'll send a secure reset link to your email.",
              showBack: true,
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
                    text:
                        "Enter the email linked to your Volt account. Check inbox and spam after sending.",
                    size: compact ? 14 : 15,
                    lineHeight: 1.35,
                    paddingBottom: compact ? 18 : 24,
                    color: kFontText7,
                    weight: FontWeight.w600,
                  ),
                  AuthFieldLabel(text: "Email Address"),
                  MyTextField(
                    controller: c.emailC,
                    hint: "name@example.com",
                    hintsize: 14,
                    hintColor: kFontText5,
                    hintWeight: FontWeight.w600,
                    keyboardType: TextInputType.emailAddress,
                    marginBottom: compact ? 18 : 24,
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
                  Obx(
                    () => MyButton(
                      onTap:
                          c.isLoading.value
                              ? () {}
                              : () async {
                                await c.sendResetLink();
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
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
