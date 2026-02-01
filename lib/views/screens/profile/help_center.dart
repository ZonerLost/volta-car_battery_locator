import 'package:fire_fighter/generated/assets.dart';
import 'package:fire_fighter/views/widget/common_image_view_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gap/gap.dart';
import 'package:fire_fighter/constants/app_colors.dart';
import 'package:fire_fighter/constants/app_sizes.dart';
import 'package:fire_fighter/views/widget/app_bar.dart';
import 'package:fire_fighter/views/widget/custom_animated_column.dart';
import 'package:fire_fighter/views/widget/my_text_widget.dart';

class HelpCenterScreen extends StatefulWidget {
  const HelpCenterScreen({super.key});

  @override
  State<HelpCenterScreen> createState() => _HelpCenterScreenState();
}

class _HelpCenterScreenState extends State<HelpCenterScreen> {
  final List<Map<String, String>> faqs = [
    {
      "question": "How does the Car Battery Locator app work?",
      "answer":
          "The app shows the battery location by selecting Make, Model, and Year. A diagram with a blinking icon indicates the battery's spot.",
    },
    {
      "question": "Do I need an internet connection to use the app?",
      "answer":
          "Yes, an internet connection is required to load diagrams and updates. However, recently viewed data may be accessible offline if cached.",
    },
    {
      "question": "What if the battery location shown is wrong?",
      "answer":
          "You can submit feedback using the thumbs down or correction option to help us improve the accuracy of the database.",
    },
    {
      "question": "Can I request a car that isn't listed in the app?",
      "answer":
          "Yes, you can submit a missing car request through the app, and we'll review and add it as soon as possible.",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kbackground,
      body: AnimatedListView(
        padding: AppSizes.DEFAULT,
        children: [
          HeaderAppBar(
            title: "",
            onTap: () => Get.back(),
            paddingLeft: 0,
            paddingRight: 0,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                MyText(
                  text: "Contact us",
                  size: 20,
                  weight: FontWeight.w700,
                  paddingBottom: 12,
                  color: kFontText,
                ),
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: kWhite,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: kBorderColor3),
                  ),
                  child: Row(
                    children: [
                      CommonImageView(
                        imagePath: Assets.imagesGoogle,
                        height: 32,
                      ),
                      Gap(12),
                      Expanded(
                        child: MyText(
                          text: "Email us (firefighter@gmail.cc)",
                          size: 16,
                          weight: FontWeight.w500,
                          color: kFontText,
                        ),
                      ),
                    ],
                  ),
                ),
                Gap(24),
                MyText(
                  text: "FAQ's",
                  size: 20,
                  weight: FontWeight.w700,
                  paddingBottom: 12,
                  color: kFontText,
                ),

                // Fixed FAQ containers
                Column(
                  children:
                      faqs.asMap().entries.map((entry) {
                        Map<String, String> faq = entry.value;
                        return Container(
                          margin: const EdgeInsets.only(bottom: 10),
                          decoration: BoxDecoration(
                            color: kWhite,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: kBorderColor3),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.08),
                                blurRadius: 4,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: _AnimatedFAQTile(
                            question: faq["question"]!,
                            answer: faq["answer"]!,
                          ),
                        );
                      }).toList(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _AnimatedFAQTile extends StatefulWidget {
  final String question;
  final String answer;

  const _AnimatedFAQTile({required this.question, required this.answer});

  @override
  State<_AnimatedFAQTile> createState() => _AnimatedFAQTileState();
}

class _AnimatedFAQTileState extends State<_AnimatedFAQTile> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
      child: ExpansionTile(
        iconColor: kFontText,
        collapsedIconColor: kFontText,
        tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        childrenPadding: const EdgeInsets.only(
          left: 16,
          right: 16,
          bottom: 12,
          top: 0,
        ),
        onExpansionChanged: (expanded) {
          setState(() {
            _isExpanded = expanded;
          });
        },
        title: MyText(
          text: widget.question,
          size: 16,
          weight: FontWeight.w600,
          color: kFontText,
        ),
        children: [
          MyText(
            text: widget.answer,
            size: 15,
            weight: FontWeight.w500,
            color: kFontText,
            textAlign: TextAlign.start,
          ),
        ],
      ),
    );
  }
}
