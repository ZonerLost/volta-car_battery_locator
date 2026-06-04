import 'package:bounce/bounce.dart';
import 'package:fire_fighter/constants/app_colors.dart';
import 'package:fire_fighter/constants/extensions.dart';
import 'package:fire_fighter/views/widget/common_image_view_widget.dart';
import 'package:fire_fighter/views/widget/my_text_widget.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

import '../../../generated/assets.dart';

class ReportBackButton extends StatelessWidget {
  const ReportBackButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Bounce(
      onTap: () => Get.back(),
      child: Container(
        height: context.rs(42, min: 38, max: 46),
        width: context.rs(42, min: 38, max: 46),
        decoration: BoxDecoration(
          color: kWhite,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: kBorderColor),
          boxShadow: [
            BoxShadow(
              color: kFontText.withOpacity(0.08),
              blurRadius: 16,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Center(
          child: CommonImageView(
            imagePath: Assets.imagesBackArrowAppbar,
            height: context.rs(23, min: 21, max: 25),
          ),
        ),
      ),
    );
  }
}

class ReportHeaderCard extends StatelessWidget {
  const ReportHeaderCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
  });

  final String title;
  final String subtitle;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(context.rs(20, min: 18, max: 24)),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [kPrimaryColor, kPrimaryColor2],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(context.rs(24, min: 20, max: 28)),
        boxShadow: [
          BoxShadow(
            color: kPrimaryColor.withOpacity(0.2),
            blurRadius: 24,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                MyText(
                  text: title,
                  size: 24,
                  color: kWhite,
                  weight: FontWeight.w800,
                ),
                MyText(
                  text: subtitle,
                  size: 14,
                  paddingTop: 6,
                  maxLines: 2,
                  textOverflow: TextOverflow.ellipsis,
                  color: kWhite.withOpacity(0.88),
                  weight: FontWeight.w600,
                ),
              ],
            ),
          ),
          Gap(context.rs(12, min: 10, max: 14)),
          Container(
            height: context.rs(58, min: 52, max: 66),
            width: context.rs(58, min: 52, max: 66),
            decoration: BoxDecoration(
              color: kWhite.withOpacity(0.16),
              borderRadius: BorderRadius.circular(18),
            ),
            child: Icon(icon, color: kWhite, size: context.rs(30)),
          ),
        ],
      ),
    );
  }
}

class ReportFormCard extends StatelessWidget {
  const ReportFormCard({super.key, required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(context.rs(16, min: 14, max: 20)),
      decoration: BoxDecoration(
        color: kWhite,
        borderRadius: BorderRadius.circular(context.rs(20, min: 16, max: 24)),
        border: Border.all(color: kBorderColor),
        boxShadow: [
          BoxShadow(
            color: kFontText.withOpacity(0.07),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: children,
      ),
    );
  }
}

class ReportFieldIcon extends StatelessWidget {
  const ReportFieldIcon(this.icon, {super.key});

  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(context.rs(10, min: 8, max: 11)),
      child: Icon(icon, color: kFontText6, size: context.rs(20, min: 18)),
    );
  }
}

Widget reportLabel(String label, {bool isRequired = false}) {
  return Row(
    children: [
      MyText(
        text: label,
        size: 15,
        paddingBottom: 10,
        color: kFontText,
        weight: FontWeight.w800,
      ),
      if (isRequired)
        MyText(
          text: "*",
          size: 15,
          paddingBottom: 10,
          color: kPrimaryColor,
          weight: FontWeight.w800,
        ),
    ],
  );
}
