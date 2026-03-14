import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:fire_fighter/constants/app_colors.dart';
import 'package:fire_fighter/views/screens/auth/login.dart';
import 'package:fire_fighter/views/widget/common_image_view_widget.dart';
import 'package:fire_fighter/views/widget/custom_animated_column.dart';
import '../../../../generated/assets.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    Future.delayed(const Duration(seconds: 4), () {
      Get.off(() => const LoginScreen());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kPrimaryColor,
      body: SafeArea(
        child: AnimatedColumn(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Animate(
                    effects: const [
                      FadeEffect(
                        duration: Duration(milliseconds: 900),
                      ),
                      ScaleEffect(
                        duration: Duration(milliseconds: 1000),
                        begin: Offset(0.85, 0.85),
                        end: Offset(1, 1),
                      ),
                      MoveEffect(
                        duration: Duration(milliseconds: 1000),
                        begin: Offset(0, 20),
                        end: Offset(0, 0),
                      ),
                    ],
                    child: CommonImageView(
                      imagePath: Assets.imagesLogoNew,
                      height: 140,
                    ),
                  ),

                  const SizedBox(height: 24),

                  Animate(
                    effects: const [
                      FadeEffect(
                        delay: Duration(milliseconds: 300),
                        duration: Duration(milliseconds: 900),
                      ),
                      MoveEffect(
                        delay: Duration(milliseconds: 300),
                        duration: Duration(milliseconds: 900),
                        begin: Offset(0, 12),
                        end: Offset(0, 0),
                      ),
                    ],
                    child: const Text(
                      'Volt : Car Battery Locator',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 26,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.3,
                      ),
                    ),
                  ),

                  const SizedBox(height: 10),

                  Animate(
                    effects: const [
                      FadeEffect(
                        delay: Duration(milliseconds: 500),
                        duration: Duration(milliseconds: 900),
                      ),
                    ],
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 32),
                      child: Text(
                        'Find your car battery location quickly and easily.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.85),
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          height: 1.4,
                        ),
                      ),
                    ),
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