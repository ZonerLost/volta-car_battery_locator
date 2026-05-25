import 'package:bounce/bounce.dart';
import 'package:fire_fighter/constants/app_colors.dart';
import 'package:fire_fighter/constants/extensions.dart';
import 'package:fire_fighter/generated/assets.dart';
import 'package:fire_fighter/views/widget/common_image_view_widget.dart';
import 'package:fire_fighter/views/widget/my_text_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AuthHero extends StatelessWidget {
  const AuthHero({
    super.key,
    required this.imagePath,
    required this.title,
    required this.subtitle,
    this.showBack = false,
  });

  final String imagePath;
  final String title;
  final String subtitle;
  final bool showBack;

  @override
  Widget build(BuildContext context) {
    final compact = context.screenHeight < 720;
    final topSafe = MediaQuery.paddingOf(context).top;
    final contentHeight = context.hp(compact ? 25 : 29).clamp(168, 240).toDouble();
    final height = contentHeight + topSafe;

    return SizedBox(
      height: height,
      width: double.infinity,
      child: Stack(
        fit: StackFit.expand,
        children: [
          CommonImageView(
            imagePath: imagePath,
            width: context.screenWidth,
            height: height,
            fit: BoxFit.cover,
          ),
          DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black.withOpacity(0.36),
                  Colors.black.withOpacity(0.46),
                  Colors.black.withOpacity(0.74),
                ],
              ),
            ),
          ),
          if (showBack)
            Positioned(
              top: topSafe + context.rs(10, min: 8),
              left: context.rs(20, min: 16),
              child: Bounce(
                onTap: Get.back,
                child: CommonImageView(
                  imagePath: Assets.imagesBackArrowWhite,
                  height: context.rs(32, min: 28),
                ),
              ),
            ),
          Positioned(
            left: context.rs(24, min: 20),
            right: context.rs(24, min: 20),
            bottom: context.rs(22, min: 18),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Container(
                  width: context.rs(58, min: 50, max: 66),
                  height: context.rs(58, min: 50, max: 66),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.white.withOpacity(0.22)),
                  ),
                  padding: EdgeInsets.all(context.rs(9, min: 7)),
                  child: ColorFiltered(
                    colorFilter: const ColorFilter.mode(
                      Colors.white,
                      BlendMode.srcIn,
                    ),
                    child: CommonImageView(
                      imagePath: Assets.imagesLogoNew,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
                context.rs(14, min: 10).hSpace,
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      MyText(
                        text: title,
                        size: compact ? 24 : 28,
                        lineHeight: 1.1,
                        color: kWhite,
                        weight: FontWeight.w800,
                      ),
                      MyText(
                        text: subtitle,
                        size: compact ? 13 : 14,
                        lineHeight: 1.3,
                        paddingTop: 5,
                        color: kFontText4,
                        weight: FontWeight.w600,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class AuthFieldLabel extends StatelessWidget {
  const AuthFieldLabel({
    super.key,
    required this.text,
    this.iconPath,
  });

  final String text;
  final String? iconPath;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: context.rs(8, min: 6)),
      child: Row(
        children: [
          MyText(
            text: text,
            size: 15,
            color: kFontText,
            weight: FontWeight.w700,
          ),
          if (iconPath != null) ...[
            context.rs(6).hSpace,
            CommonImageView(imagePath: iconPath, height: context.rs(15)),
          ],
        ],
      ),
    );
  }
}

class AuthDivider extends StatelessWidget {
  const AuthDivider({super.key, this.text = "OR"});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Expanded(child: Divider(color: kBorderColor, thickness: 1)),
        context.rs(12).hSpace,
        MyText(
          text: text,
          size: 13,
          color: kFontText6,
          weight: FontWeight.w700,
        ),
        context.rs(12).hSpace,
        const Expanded(child: Divider(color: kBorderColor, thickness: 1)),
      ],
    );
  }
}

class AuthFooterLink extends StatelessWidget {
  const AuthFooterLink({
    super.key,
    required this.text,
    required this.actionText,
    required this.onTap,
  });

  final String text;
  final String actionText;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Flexible(
          child: MyText(
            text: text,
            size: 15,
            color: kFontText7,
            weight: FontWeight.w500,
            textAlign: TextAlign.center,
          ),
        ),
        context.rs(6).hSpace,
        Bounce(
          onTap: onTap,
          child: MyText(
            text: actionText,
            size: 15,
            color: kSecondaryColor,
            weight: FontWeight.w800,
          ),
        ),
      ],
    );
  }
}
