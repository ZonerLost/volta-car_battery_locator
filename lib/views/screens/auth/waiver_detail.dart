import 'package:fire_fighter/views/screens/bottom_nav/BottomBarNav.dart';
import 'package:fire_fighter/views/widget/my_button_new.dart';
import 'package:get/get.dart';
import 'package:fire_fighter/constants/app_fonts.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:fire_fighter/constants/app_colors.dart';
import 'package:fire_fighter/constants/app_sizes.dart';
import 'package:fire_fighter/views/widget/app_bar.dart';
import 'package:fire_fighter/views/widget/custom_animated_column.dart';
import 'package:fire_fighter/views/widget/my_text_widget.dart';
import 'package:get/get_connect/http/src/utils/utils.dart';

class WavierDetailScreen extends StatefulWidget {
  const WavierDetailScreen({super.key});

  @override
  State<WavierDetailScreen> createState() => _WavierDetailScreenState();
}

class _WavierDetailScreenState extends State<WavierDetailScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kWhite,
      body: Stack(
        children: [
          AnimatedListView(
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
                      text: "User Waiver & Release of Liability",
                      size: 20,
                      paddingBottom: 18,

                      weight: FontWeight.w500,
                      color: kBlack,
                      textAlign: TextAlign.start,
                    ),
                    MyText(
                      text:
                          "By booking and participating in activities at this club, you acknowledge and agree to the following:",
                      size: 16,
                      weight: FontWeight.w500,
                      lineHeight: 0,
                      color: kFontText8,
                      paddingBottom: 18,

                      textAlign: TextAlign.start,
                    ),
                    MyText(
                      text: "Assumption of Risk",
                      size: 16,
                      paddingBottom: 18,

                      weight: FontWeight.w500,
                      color: kBlack,
                      textAlign: TextAlign.start,
                    ),

                    Padding(
                      padding: const EdgeInsets.only(left: 24.0),
                      child: Column(
                        children: [
                          BulletRow(
                            Text:
                                'Playing sports such as tennis, padel, or squash involves physical activity and carries a risk of accidents, falls, or injuries.',
                          ),
                          Gap(18),
                          BulletRow(
                            Text:
                                'You voluntarily choose to participate with full knowledge of these risks.',
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    MyText(
                      text: "Release of Liability",
                      size: 16,
                      paddingBottom: 18,

                      weight: FontWeight.w500,
                      color: kBlack,
                      textAlign: TextAlign.start,
                    ),

                    Padding(
                      padding: const EdgeInsets.only(left: 24.0),
                      child: Column(
                        children: [
                          BulletRow(
                            Text:
                                "The club, its staff, coaches, and affiliates will not be held responsible for any injuries, accidents, medical conditions, or property loss that may occur while using the facilities or participating in lessons, clinics, or matches.",
                          ),
                          Gap(18),
                          BulletRow(
                            Text:
                                "By accepting this waiver, you release the club from any legal or financial responsibility related to such incidents",
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    MyText(
                      text: "Personal Responsibility",
                      size: 16,
                      paddingBottom: 18,

                      weight: FontWeight.w500,
                      color: kBlack,
                      textAlign: TextAlign.start,
                    ),

                    Padding(
                      padding: const EdgeInsets.only(left: 24.0),
                      child: Column(
                        children: [
                          BulletRow(
                            Text:
                                "You agree to take full responsibility for your health, safety, and actions while on club premises.",
                          ),
                          Gap(18),
                          BulletRow(
                            Text:
                                "If you have any medical conditions or concerns, you are encouraged to consult a physician before participating.",
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    MyText(
                      text: "Consent to Terms",
                      size: 16,
                      paddingBottom: 18,

                      weight: FontWeight.w500,
                      color: kBlack,
                      textAlign: TextAlign.start,
                    ),

                    Padding(
                      padding: const EdgeInsets.only(left: 24.0),
                      child: Column(
                        children: [
                          BulletRow(
                            Text:
                                "By checking the box below and continuing, you confirm that you have read, understood, and accepted these terms as a condition of using the platform and club facilities.",
                          ),
                          Gap(18),
                          BulletRow(
                            Text:
                                "By checking the box below and continuing, you confirm that you have read, understood, and accepted these terms as a condition of using the platform and club facilities.",
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Positioned(
            bottom: 40,
            left: 32,
            right: 32,
            child: MyButton(
              onTap: () {
                Get.offAll( () => const BottomNavBar());
              },
              radius: 12,
              buttonText: "Agree & Accept",
              hasgrad: true,
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

        const SizedBox(width: 8), // Space between bullet and text
        Expanded(
          child: MyText(
            text: Text,
            size: 14,
            weight: FontWeight.w600,
            color: kFontText,
            textAlign: TextAlign.start,
          ),
        ),
      ],
    );
  }
}
