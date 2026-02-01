// // ignore_for_file: prefer_const_constructors
// import 'package:bounce/bounce.dart';
// import 'package:fire_fighter/views/screens/report_module/general_feedback.dart';
// import 'package:fire_fighter/views/screens/report_module/missing_car.dart';
// import 'package:fire_fighter/views/screens/report_module/wrong_location.dart';
// import 'package:fire_fighter/views/widget/my_text_widget.dart';
// import 'package:flutter/material.dart';
// import 'package:gap/gap.dart';
// import 'package:fire_fighter/constants/app_colors.dart';
// import 'package:fire_fighter/generated/assets.dart';
// import 'package:fire_fighter/views/widget/common_image_view_widget.dart';
// import 'package:fire_fighter/views/widget/custom_animated_column.dart';
// import 'package:get/get.dart';

// class ReportIssueScreen extends StatefulWidget {
//   const ReportIssueScreen({super.key});

//   @override
//   State<ReportIssueScreen> createState() => _ReportIssueScreenState();
// }

// class _ReportIssueScreenState extends State<ReportIssueScreen> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: AnimatedListView(
//         padding: EdgeInsets.all(24),
//         children: [
//           Gap(50),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.start,
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Bounce(
//                 onTap: () {
//                   Get.back();
//                 },
//                 child: CommonImageView(
//                   imagePath: Assets.imagesBackArrowAppbar,
//                   height: 32,
//                 ),
//               ),
//             ],
//           ),
//           Gap(16),
//           MyText(
//             text: "Report an Issue",
//             size: 24,
//             color: kFontText,
//             weight: FontWeight.w700,
//           ),
//           MyText(
//             text: "Choose the type of report below and share details with us.",
//             size: 20,
//             paddingBottom: 32,
//             color: kFontText7,
//             weight: FontWeight.w600,
//           ),
//           Gap(20),

//           ListView.builder(
//             shrinkWrap: true,
//             padding: EdgeInsets.all(0),
//             physics: NeverScrollableScrollPhysics(),
//             itemCount: 3, // Matches the number of items in the image
//             itemBuilder: (context, index) {
//               final searches = [
//                 {
//                   "model": "Wrong Location",
//                   "location": "Tell us where the battery icon should be.",
//                   "image": Assets.imagesReportCarImage,
//                   "onTap": () {
//                     Get.to(() => WrongLocationScreen());
//                   },
//                 },
//                 {
//                   "model": "Missing Car",
//                   "location": "Not seeing your car? Submit details to add it.",
//                   "image": Assets.imagesReportCarImage,
//                   "onTap": () {
//                     Get.to(() => MissingCarScreen());
//                   },
//                 },
//                 {
//                   "model": "General Feedback",
//                   "location":
//                       "Have another issue or suggestion? Share your feedback with our team.",
//                   "image": Assets.imagesReportCarImage,
//                   "onTap": () {
//                     Get.to(() => GeneralFeedbackScreen());
//                   },
//                 },
//               ];
//               final search = searches[index];

//               return Column(
//                 children: [
//                   Bounce(
//                     onTap: () {
//                       search["onTap"];
//                     },
//                     child: Container(
//                       padding: EdgeInsets.all(8),
//                       margin: EdgeInsets.only(bottom: 12),
//                       decoration: BoxDecoration(
//                         color: kWhite,
//                         borderRadius: BorderRadius.circular(10),
//                         border: Border.all(color: kBorderColor3),
//                       ),
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Row(
//                             children: [
//                               CommonImageView(
//                                 imagePath: search["image"]!, // Assert non-null
//                                 height: 130,
//                               ),
//                             ],
//                           ),
//                           Gap(6),
//                           MyText(
//                             text: search["model"]!,
//                             size: 16,
//                             color: kFontText,
//                             weight: FontWeight.w700,
//                           ),
//                           MyText(
//                             text: "Tell us where the battery icon should be.",
//                             size: 14,
//                             color: kFontText,
//                             weight: FontWeight.w600,
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ],
//               );
//             },
//           ),

//           Gap(20),
//         ],
//       ),
//     );
//   }
// }

// ignore_for_file: prefer_const_constructors

import 'package:bounce/bounce.dart';
import 'package:fire_fighter/views/screens/report_module/general_feedback.dart';
import 'package:fire_fighter/views/screens/report_module/missing_car.dart';
import 'package:fire_fighter/views/screens/report_module/wrong_location.dart';
import 'package:fire_fighter/views/widget/custom_animated_column.dart';
import 'package:fire_fighter/views/widget/my_text_widget.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:fire_fighter/constants/app_colors.dart';
import 'package:fire_fighter/generated/assets.dart';
import 'package:fire_fighter/views/widget/common_image_view_widget.dart';
import 'package:get/get.dart';

class ReportIssueScreen extends StatefulWidget {
  const ReportIssueScreen({super.key});

  @override
  State<ReportIssueScreen> createState() => _ReportIssueScreenState();
}

class _ReportIssueScreenState extends State<ReportIssueScreen> {
  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> reports = [
      {
        "title": "Wrong Location",
        "subtitle": "Tell us where the battery icon should be.",
        "image": Assets.imagesReportCarImage,
        "onTap": () => Get.to(() => const WrongLocationScreen()),
      },
      {
        "title": "Missing Car",
        "subtitle": "Not seeing your car? Submit details to add it.",
        "image": Assets.imagesReportCarImage,
        "onTap": () => Get.to(() => const MissingCarScreen()),
      },
      {
        "title": "General Feedback",
        "subtitle":
            "Have another issue or suggestion? Share your feedback with our team.",
        "image": Assets.imagesReportCarImage,
        "onTap": () => Get.to(() => const GeneralFeedbackScreen()),
      },
    ];

    return Scaffold(
      body: AnimatedListView(
        padding: EdgeInsets.all(24),
        children: [
          Gap(50),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Bounce(
                onTap: () => Get.back(),
                child: CommonImageView(
                  imagePath: Assets.imagesBackArrowAppbar,
                  height: 32,
                ),
              ),
            ],
          ),
          Gap(16),
          MyText(
            text: "Report an Issue",
            size: 24,
            color: kFontText,
            weight: FontWeight.w700,
          ),
          MyText(
            text: "Choose the type of report below and share details with us.",
            size: 20,
            paddingBottom: 32,
            color: kFontText7,
            weight: FontWeight.w600,
          ),

          // Report list
          ListView.builder(
            shrinkWrap: true,
            padding: EdgeInsets.zero,
            physics: NeverScrollableScrollPhysics(),
            itemCount: reports.length,
            itemBuilder: (context, index) {
              final report = reports[index];
              return Bounce(
                onTap: report["onTap"],
                child: Container(
                  padding: EdgeInsets.all(12),
                  margin: EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: kWhite,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: kBorderColor3),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CommonImageView(imagePath: report["image"], height: 130),
                      Gap(8),
                      MyText(
                        text: report["title"],
                        size: 16,
                        color: kFontText,
                        weight: FontWeight.w700,
                      ),
                      MyText(
                        text: report["subtitle"],
                        size: 14,
                        color: kFontText7,
                        weight: FontWeight.w500,
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
          Gap(20),
        ],
      ),
    );
  }
}
