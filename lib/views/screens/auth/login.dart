// ignore_for_file: prefer_const_constructors

import 'package:fire_fighter/controller/login_controller.dart';
import 'package:fire_fighter/views/screens/auth/auth_widgets.dart';
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
  void dispose() {
    _focusNodeEmail.dispose();
    _focusNodePassword.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final compact = context.screenHeight < 720;
    final horizontalPadding = context.rs(compact ? 22 : 28, min: 20);

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
            AuthHero(
              imagePath: Assets.imagesAuthVoltResponderBackground,
              title: "Welcome Back",
              subtitle: "Sign in to find car battery locations faster.",
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
                  AuthFieldLabel(text: "Email Address"),
                  MyTextField(
                    controller: c.emailC,
                    hint: "name@example.com",
                    hintsize: 14,
                    hintColor: kFontText5,
                    hintWeight: FontWeight.w600,
                    marginBottom: compact ? 8 : 10,
                    keyboardType: TextInputType.emailAddress,
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

                  AuthFieldLabel(
                    text: "Password",
                    iconPath: Assets.imagesPasswordIcon,
                  ),
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

                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Bounce(
                        onTap: () {
                          Get.to(() => ForgotPasswordScreen());
                        },
                        child: Padding(
                          padding: EdgeInsets.only(
                            bottom: context.rs(compact ? 16 : 22),
                          ),
                          child: const Text(
                            "Forgot Password?",
                            style: TextStyle(
                              color: kSecondaryColor,
                              fontSize: 15,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

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
                          c.isLoading.value ? "Please wait..." : "Log In",
                      hasgrad: true,
                    ),
                  ),

                  context.rs(compact ? 12 : 16).vSpace,
                  const AuthDivider(),
                  context.rs(compact ? 12 : 16).vSpace,

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
                      hasicon: true,
                      choiceIcon: Assets.imagesGoogle,
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

                  AuthFooterLink(
                    text: "Don't have an account?",
                    actionText: "Sign Up",
                    onTap: () {
                      Get.to(() => SignUpScreen());
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
