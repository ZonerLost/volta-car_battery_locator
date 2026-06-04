import 'package:bounce/bounce.dart';
import 'package:fire_fighter/constants/app_colors.dart';
import 'package:fire_fighter/constants/extensions.dart';
import 'package:fire_fighter/views/screens/report_module/general_feedback.dart';
import 'package:fire_fighter/views/screens/report_module/missing_car.dart';
import 'package:fire_fighter/views/screens/report_module/wrong_location.dart';
import 'package:fire_fighter/views/widget/my_text_widget.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

class ReportIssueScreen extends StatelessWidget {
  const ReportIssueScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final reports = [
      _ReportOption(
        title: "Wrong Location",
        subtitle: "Battery marker is showing in the wrong place.",
        icon: Icons.location_off_rounded,
        color: kPrimaryColor,
        onTap: () => Get.to(() => const WrongLocationScreen()),
      ),
      _ReportOption(
        title: "Missing Car",
        subtitle: "Your vehicle is not available in the locator.",
        icon: Icons.directions_car_filled_rounded,
        color: kPrimaryColor,
        onTap: () => Get.to(() => const MissingCarScreen()),
      ),
      _ReportOption(
        title: "General Feedback",
        subtitle: "Share another issue, suggestion, or app feedback.",
        icon: Icons.chat_bubble_rounded,
        color: kPrimaryColor,
        onTap: () => Get.to(() => const GeneralFeedbackScreen()),
      ),
    ];

    return Scaffold(
      backgroundColor: kbackground,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.fromLTRB(
            context.rs(22, min: 18, max: 28),
            context.rs(18, min: 14, max: 24),
            context.rs(22, min: 18, max: 28),
            context.rs(20, min: 16, max: 26),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(context.rs(20, min: 18, max: 26)),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [kPrimaryColor, kPrimaryColor2],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(
                    context.rs(26, min: 22, max: 30),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: kPrimaryColor.withOpacity(0.22),
                      blurRadius: 28,
                      offset: const Offset(0, 14),
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
                            text: "Report an Issue",
                            size: 26,
                            color: kWhite,
                            weight: FontWeight.w800,
                          ),
                          MyText(
                            text: "Choose what went wrong so we can fix it.",
                            size: 15,
                            paddingTop: 8,
                            color: kWhite.withOpacity(0.88),
                            weight: FontWeight.w600,
                          ),
                        ],
                      ),
                    ),
                    Gap(context.rs(12, min: 10, max: 16)),
                    Container(
                      height: context.rs(68, min: 60, max: 78),
                      width: context.rs(68, min: 60, max: 78),
                      decoration: BoxDecoration(
                        color: kWhite.withOpacity(0.16),
                        borderRadius: BorderRadius.circular(22),
                        border: Border.all(color: kWhite.withOpacity(0.22)),
                      ),
                      child: Icon(
                        Icons.report_problem_rounded,
                        color: kWhite,
                        size: context.rs(34, min: 30, max: 38),
                      ),
                    ),
                  ],
                ),
              ),
              Gap(context.rs(22, min: 18, max: 28)),
              MyText(
                text: "Report Type",
                size: 19,
                color: kFontText,
                weight: FontWeight.w800,
              ),
              MyText(
                text: "Select the closest option below.",
                size: 14,
                paddingTop: 4,
                paddingBottom: 14,
                color: kFontText6,
                weight: FontWeight.w600,
              ),
              Expanded(
                child: ListView.separated(
                  physics: const BouncingScrollPhysics(),
                  itemCount: reports.length,
                  separatorBuilder:
                      (_, __) => Gap(context.rs(12, min: 10, max: 14)),
                  itemBuilder: (context, index) => reports[index],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ReportOption extends StatelessWidget {
  const _ReportOption({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Bounce(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(context.rs(16, min: 14, max: 18)),
        decoration: BoxDecoration(
          color: kWhite,
          borderRadius: BorderRadius.circular(context.rs(18, min: 16, max: 22)),
          border: Border.all(color: kBorderColor),
          boxShadow: [
            BoxShadow(
              color: kFontText.withOpacity(0.07),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              height: context.rs(50, min: 46, max: 56),
              width: context.rs(50, min: 46, max: 56),
              decoration: BoxDecoration(
                color: color.withOpacity(0.12),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(
                icon,
                color: color,
                size: context.rs(26, min: 24, max: 30),
              ),
            ),
            Gap(context.rs(14, min: 12, max: 16)),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  MyText(
                    text: title,
                    size: 17,
                    color: kFontText,
                    weight: FontWeight.w800,
                  ),
                  MyText(
                    text: subtitle,
                    size: 13,
                    paddingTop: 3,
                    maxLines: 2,
                    textOverflow: TextOverflow.ellipsis,
                    color: kFontText6,
                    weight: FontWeight.w600,
                  ),
                ],
              ),
            ),
            Gap(context.rs(10, min: 8, max: 12)),
            Container(
              height: context.rs(32, min: 30, max: 34),
              width: context.rs(32, min: 30, max: 34),
              decoration: BoxDecoration(
                color: kGreyContainerGreyColor2,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: kBorderColor),
              ),
              child: Icon(
                Icons.arrow_forward_ios_rounded,
                color: kFontText6,
                size: context.rs(14, min: 12, max: 15),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
