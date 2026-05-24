import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fire_fighter/constants/extensions.dart';
import 'package:fire_fighter/views/screens/auth/login.dart';
import 'package:fire_fighter/views/widget/common_image_view_widget.dart';
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
    final short = context.screenHeight < 700;
    final titleSize = context.rs(short ? 46 : 58, min: 38, max: 68);
    final subtitleSize = context.rs(short ? 21 : 25, min: 18, max: 30);
    final taglineSize = context.rs(short ? 20 : 24, min: 16, max: 28);

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        fit: StackFit.expand,
        children: [
          CommonImageView(
            imagePath: Assets.imagesSplashVoltBackground,
            width: context.screenWidth,
            height: context.screenHeight,
            fit: BoxFit.cover,
          ),
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black.withOpacity(0.35),
                  Colors.black.withOpacity(0.10),
                  Colors.black.withOpacity(0.55),
                ],
                stops: const [0.0, 0.48, 1.0],
              ),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: context.rs(24, min: 18),
                vertical: context.rs(short ? 22 : 34, min: 18),
              ),
              child: Column(
                children: [
                  SizedBox(height: context.hp(short ? 2 : 4)),
                  _SplashText(
                    text: "VOLT",
                    fontSize: titleSize,
                    letterSpacing: context.rs(7, min: 4, max: 9),
                  ),
                  SizedBox(height: context.rs(short ? 6 : 10, min: 4)),
                  _SplashText(
                    text: "Car Battery Locator",
                    fontSize: subtitleSize,
                    letterSpacing: context.rs(1.8, min: 1, max: 2.5),
                  ),
                  const Spacer(flex: 2),
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      Transform.translate(
                        offset: Offset(
                          context.rs(5, min: 3),
                          context.rs(5, min: 3),
                        ),
                        child: ColorFiltered(
                          colorFilter: const ColorFilter.mode(
                            Color(0xFFE51F2B),
                            BlendMode.srcIn,
                          ),
                          child: CommonImageView(
                            imagePath: Assets.imagesLogoNew,
                            width: context.wp(short ? 70 : 76),
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                      ColorFiltered(
                        colorFilter: const ColorFilter.mode(
                          Colors.white,
                          BlendMode.srcIn,
                        ),
                        child: CommonImageView(
                          imagePath: Assets.imagesLogoNew,
                          width: context.wp(short ? 70 : 76),
                          fit: BoxFit.contain,
                        ),
                      ),
                    ],
                  ),
                  const Spacer(flex: 3),
                  _SplashText(
                    text: "FIND YOUR CAR",
                    fontSize: taglineSize,
                    letterSpacing: context.rs(3, min: 1.5, max: 4),
                  ),
                  SizedBox(height: context.rs(8, min: 5)),
                  _SplashText(
                    text: "BATTERY LOCATION",
                    fontSize: taglineSize,
                    letterSpacing: context.rs(3, min: 1.5, max: 4),
                  ),
                  SizedBox(height: context.rs(8, min: 5)),
                  _SplashText(
                    text: "QUICKLY AND EASILY",
                    fontSize: taglineSize,
                    letterSpacing: context.rs(3, min: 1.5, max: 4),
                  ),
                  SizedBox(height: context.hp(short ? 5 : 7)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SplashText extends StatelessWidget {
  const _SplashText({
    required this.text,
    required this.fontSize,
    required this.letterSpacing,
  });

  final String text;
  final double fontSize;
  final double letterSpacing;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Transform.translate(
          offset: Offset(context.rs(2, min: 1), context.rs(3, min: 2)),
          child: Text(
            text,
            textAlign: TextAlign.center,
            maxLines: 2,
            style: TextStyle(
              color: const Color(0xFFC91424),
              fontSize: fontSize,
              fontWeight: FontWeight.w900,
              height: 1.08,
              letterSpacing: letterSpacing,
              fontFamily: 'Inter',
            ),
          ),
        ),
        Text(
          text,
          textAlign: TextAlign.center,
          maxLines: 2,
          style: TextStyle(
            color: Colors.white,
            fontSize: fontSize,
            fontWeight: FontWeight.w900,
            height: 1.08,
            letterSpacing: letterSpacing,
            fontFamily: 'Inter',
            shadows: const [
              Shadow(
                color: Colors.black87,
                blurRadius: 5,
                offset: Offset(0, 2),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
