import 'package:fire_fighter/constants/app_colors.dart';
import 'package:fire_fighter/constants/extensions.dart';
import 'package:fire_fighter/views/screens/bottom_nav/BottomBarNav.dart';
import 'package:fire_fighter/views/widget/app_bar.dart';
import 'package:fire_fighter/views/widget/my_button_new.dart';
import 'package:fire_fighter/views/widget/my_text_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class WavierDetailScreen extends StatefulWidget {
  const WavierDetailScreen({super.key});

  @override
  State<WavierDetailScreen> createState() => _WavierDetailScreenState();
}

class _WavierDetailScreenState extends State<WavierDetailScreen> {
  static const _sections = [
    _WaiverSection(
      title: "Assumption of Risk",
      details:
          "I understand that using battery location services may involve travel, roadside stops, third-party shops, and normal vehicle-related risks.",
    ),
    _WaiverSection(
      title: "Release of Liability",
      details:
          "I agree that Volta, its team, partners, and listed providers are not responsible for injury, loss, damage, service quality, pricing, or delays outside the app's control.",
    ),
    _WaiverSection(
      title: "Personal Responsibility",
      details:
          "I will verify provider details, follow safety guidelines, and make my own decisions before buying, replacing, or servicing a vehicle battery.",
    ),
    _WaiverSection(
      title: "Consent to Terms",
      details:
          "By accepting, I confirm that I have read and agree to the Terms & Conditions, Privacy Policy, and this waiver.",
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final compact = context.screenHeight < 720;
    final tight = context.screenHeight < 640;
    final horizontalPadding = context.rs(compact ? 18 : 24, min: 16);
    final sectionGap = context.rs(tight ? 8 : 12, min: 7);

    return Scaffold(
      backgroundColor: kWhite,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.fromLTRB(
            horizontalPadding,
            context.rs(8, min: 6),
            horizontalPadding,
            context.rs(18, min: 14),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              HeaderAppBar(
                title: "",
                onTap: () {
                  Get.back();
                },
                paddingLeft: 0,
                paddingRight: 0,
              ),
              MyText(
                text: "Waiver & Liability Release",
                size: tight ? 18 : 20,
                lineHeight: 1.2,
                paddingTop: tight ? 4 : 8,
                paddingBottom: tight ? 6 : 10,
                weight: FontWeight.w700,
                color: kBlack,
                textAlign: TextAlign.start,
              ),
              MyText(
                text:
                    "Please review and accept these points before continuing.",
                size: tight ? 13 : 14,
                lineHeight: 1.3,
                paddingBottom: sectionGap,
                weight: FontWeight.w500,
                color: kFontText8,
                textAlign: TextAlign.start,
              ),
              for (final section in _sections) ...[
                _WaiverPoint(section: section, tight: tight),
                SizedBox(height: sectionGap),
              ],
              const Spacer(),
              MyButton(
                onTap: () {
                  Get.offAll(() => const BottomNavBar());
                },
                radius: 12,
                buttonText: "Agree & Accept",
                hasgrad: true,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _WaiverPoint extends StatelessWidget {
  const _WaiverPoint({required this.section, required this.tight});

  final _WaiverSection section;
  final bool tight;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: context.rs(tight ? 7 : 8, min: 6),
          height: context.rs(tight ? 7 : 8, min: 6),
          margin: EdgeInsets.only(top: context.rs(tight ? 7 : 8, min: 6)),
          decoration: const BoxDecoration(
            color: kSecondaryColor,
            shape: BoxShape.circle,
          ),
        ),
        SizedBox(width: context.rs(10, min: 8)),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              MyText(
                text: section.title,
                size: tight ? 14 : 15,
                lineHeight: 1.2,
                paddingBottom: tight ? 2 : 4,
                weight: FontWeight.w700,
                color: kBlack,
                textAlign: TextAlign.start,
              ),
              MyText(
                text: section.details,
                size: tight ? 12 : 13,
                lineHeight: 1.28,
                weight: FontWeight.w500,
                color: kFontText,
                textAlign: TextAlign.start,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _WaiverSection {
  const _WaiverSection({required this.title, required this.details});

  final String title;
  final String details;
}
