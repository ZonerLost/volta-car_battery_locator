// ignore_for_file: prefer_const_constructors
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:fire_fighter/constants/app_colors.dart';
import 'package:fire_fighter/constants/app_sizes.dart';
import 'package:fire_fighter/views/widget/app_bar.dart';
import 'package:fire_fighter/views/widget/custom_animated_column.dart';
import 'package:fire_fighter/views/widget/my_text_widget.dart';

class PrivacyPolicyScreen extends StatefulWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  State<PrivacyPolicyScreen> createState() => _PrivacyPolicyScreenState();
}

class _PrivacyPolicyScreenState extends State<PrivacyPolicyScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kWhite,
      body: AnimatedListView(
        padding: AppSizes.DEFAULT,
        children: [
          HeaderAppBar(
            title: "",
            onTap: () {
              Get.back();
            },
            paddingLeft: 0,
            paddingRight: 0,
          ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                MyText(
                  text: "Privacy & Terms ",
                  size: 20,
                  paddingBottom: 18,
                  weight: FontWeight.w700,
                  color: kBlack,
                  textAlign: TextAlign.start,
                ),
                MyText(
                  text: "Last updated: July 1, 2026",
                  size: 14,
                  weight: FontWeight.w500,
                  color: kFontText8,
                  paddingBottom: 12,
                  textAlign: TextAlign.start,
                ),
                MyText(
                  text:
                      "By using this app, you agree to our Terms of Service and Privacy Policy.",
                  size: 20,
                  weight: FontWeight.w500,
                  lineHeight: 0,
                  color: kFontText8,
                  paddingBottom: 18,
                  textAlign: TextAlign.start,
                ),
                Container(
                  padding: const EdgeInsets.all(16),
                  margin: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: kWhite,
                    border: Border.all(color: kBorderColor3),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // --- Section 1 ---
                      MyText(
                        text: "1. Information We Collect:",
                        size: 18,
                        paddingBottom: 18,
                        weight: FontWeight.w600,
                        color: kBlack,
                        textAlign: TextAlign.start,
                      ),
                      MyText(
                        text:
                            "When you use our app, we may collect the following types of information:",
                        size: 18,
                        paddingBottom: 6,
                        weight: FontWeight.w500,
                        color: kFontText,
                        lineHeight: 0,
                        textAlign: TextAlign.start,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 6),
                        child: Column(
                          children: [
                            BulletRow(
                              Text:
                                  "Account Information: Name, email address, and password when you create an account.",
                            ),
                            BulletRow(
                              Text:
                                  "Usage Data: Car make, model, year selections, and search history to help you quickly access previous searches.",
                            ),
                            BulletRow(
                              Text:
                                  "Feedback Data: Thumbs up/down votes, corrections, and missing car submissions to improve accuracy.",
                            ),
                            BulletRow(
                              Text:
                                  "Device Information: Basic technical details such as device type, operating system, and app version.",
                            ),
                            BulletRow(
                              Text:
                                  "Offline Data (if enabled): Recent searches and diagrams cached locally on your device.",
                            ),
                          ],
                        ),
                      ),
                      Gap(10),
                      MyText(
                        text:
                            "We do not collect sensitive personal information such as payment details, location tracking, or contact lists.",
                        size: 18,
                        weight: FontWeight.w500,
                        color: kFontText,
                        textAlign: TextAlign.start,
                      ),
                      Gap(20),

                      // --- Section 2 ---
                      MyText(
                        text: "2. How We Use Your Information",
                        size: 18,
                        paddingBottom: 18,
                        weight: FontWeight.w600,
                        color: kBlack,
                        textAlign: TextAlign.start,
                      ),
                      BulletRow(
                        Text:
                            "Providing quick and accurate car battery location results.",
                      ),
                      BulletRow(
                        Text:
                            "Improving the database with user feedback and corrections.",
                      ),
                      BulletRow(
                        Text:
                            "Expanding the list of supported car models through crowdsourced submissions.",
                      ),
                      BulletRow(
                        Text: "Maintaining app security and performance.",
                      ),
                      BulletRow(
                        Text:
                            "Communicating important updates, fixes, or service announcements.",
                      ),
                      Gap(20),

                      // --- Section 3 ---
                      MyText(
                        text: "3. Data Sharing",
                        size: 18,
                        paddingBottom: 18,
                        weight: FontWeight.w600,
                        color: kBlack,
                        textAlign: TextAlign.start,
                      ),
                      MyText(
                        text:
                            "We do not sell your personal information to third parties. We may share limited data only in the following cases:",
                        size: 18,
                        paddingBottom: 10,
                        weight: FontWeight.w500,
                        color: kFontText,
                        textAlign: TextAlign.start,
                      ),
                      BulletRow(
                        Text:
                            "With Admins: User feedback and corrections are shared with our admin team for review.",
                      ),
                      BulletRow(
                        Text:
                            "For Legal Compliance: If required by law or government authorities.",
                      ),
                      BulletRow(
                        Text:
                            "With Service Providers: Trusted third parties that help us run servers, databases, and analytics (all bound by confidentiality agreements).",
                      ),
                      Gap(20),

                      // --- Section 4 ---
                      MyText(
                        text: "4. Data Storage & Security",
                        size: 18,
                        paddingBottom: 18,
                        weight: FontWeight.w600,
                        color: kBlack,
                        textAlign: TextAlign.start,
                      ),
                      BulletRow(
                        Text:
                            "All data is stored securely in our encrypted databases.",
                      ),
                      BulletRow(
                        Text:
                            "Passwords are encrypted and never visible to anyone, including admins.",
                      ),
                      BulletRow(
                        Text:
                            "We regularly review and update our security practices to protect against unauthorized access.",
                      ),
                      Gap(20),

                      // --- Section 5 ---
                      MyText(
                        text: "5. Your Rights",
                        size: 18,
                        paddingBottom: 18,
                        weight: FontWeight.w600,
                        color: kBlack,
                        textAlign: TextAlign.start,
                      ),
                      MyText(
                        text: "You have the right to:",
                        size: 18,
                        paddingBottom: 10,
                        weight: FontWeight.w500,
                        color: kFontText,
                        textAlign: TextAlign.start,
                      ),
                      BulletRow(
                        Text:
                            "Access and review the personal data we hold about you.",
                      ),
                      BulletRow(
                        Text: "Request corrections or updates to your data.",
                      ),
                      BulletRow(
                        Text:
                            "Request deletion of your account and associated data.",
                      ),
                      BulletRow(
                        Text:
                            "Opt-out of data collection features such as offline caching.",
                      ),
                      Gap(10),
                      MyText(
                        text:
                            "You can permanently delete your account from Settings > Delete Account. For other privacy requests, use Support & Info in the app.",
                        size: 18,
                        weight: FontWeight.w500,
                        color: kFontText,
                        textAlign: TextAlign.start,
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

  Row BulletRow({required String Text}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        MyText(text: "\u2022", size: 20, color: kFontText),
        const SizedBox(width: 8),
        Expanded(
          child: MyText(
            text: Text,
            size: 16,
            weight: FontWeight.w500,
            color: kFontText,
            textAlign: TextAlign.start,
          ),
        ),
      ],
    );
  }
}
