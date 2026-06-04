import 'package:bounce/bounce.dart';
import 'package:fire_fighter/constants/app_colors.dart';
import 'package:fire_fighter/constants/extensions.dart';
import 'package:fire_fighter/controller/home_controller.dart';
import 'package:fire_fighter/generated/assets.dart';
import 'package:fire_fighter/utils/app_snackbar.dart';
import 'package:fire_fighter/views/screens/home/locate_battery.dart';
import 'package:fire_fighter/views/widget/common_image_view_widget.dart';
import 'package:fire_fighter/views/widget/custom_animated_column.dart';
import 'package:fire_fighter/views/widget/my_text_widget.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

class YearSelectionScreen extends StatefulWidget {
  const YearSelectionScreen({super.key});

  @override
  State<YearSelectionScreen> createState() => _YearSelectionScreenState();
}

class _YearSelectionScreenState extends State<YearSelectionScreen> {
  final HomeController hc = Get.find<HomeController>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      hc.loadYearLabels();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kbackground,
      body: AnimatedListView(
        padding: EdgeInsets.fromLTRB(
          context.rs(22, min: 18, max: 32),
          context.rs(48, min: 38, max: 60),
          context.rs(22, min: 18, max: 32),
          context.rs(30, min: 22, max: 36),
        ),
        children: [
          Row(
            children: [
              Bounce(
                onTap: () => Get.back(),
                child: Container(
                  height: context.rs(44, min: 40, max: 48),
                  width: context.rs(44, min: 40, max: 48),
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
                      height: context.rs(24, min: 22, max: 26),
                    ),
                  ),
                ),
              ),
            ],
          ),
          Gap(context.rs(22, min: 18, max: 28)),
          Container(
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
                  color: kPrimaryColor.withOpacity(0.24),
                  blurRadius: 28,
                  offset: const Offset(0, 14),
                ),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: Obx(
                    () => Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        MyText(
                          text: "Select Year",
                          size: 26,
                          color: kWhite,
                          weight: FontWeight.w800,
                        ),
                        MyText(
                          text:
                              "${hc.selectedMake.value} ${hc.selectedModel.value}",
                          size: 16,
                          paddingTop: 8,
                          color: kWhite.withOpacity(0.88),
                          weight: FontWeight.w600,
                        ),
                      ],
                    ),
                  ),
                ),
                Gap(context.rs(12, min: 10, max: 16)),
                Container(
                  height: context.rs(70, min: 62, max: 82),
                  width: context.rs(70, min: 62, max: 82),
                  decoration: BoxDecoration(
                    color: kWhite.withOpacity(0.16),
                    borderRadius: BorderRadius.circular(22),
                    border: Border.all(color: kWhite.withOpacity(0.22)),
                  ),
                  child: Icon(
                    Icons.calendar_month_rounded,
                    color: kWhite,
                    size: context.rs(34, min: 30, max: 40),
                  ),
                ),
              ],
            ),
          ),
          Gap(context.rs(22, min: 18, max: 28)),
          Obx(() {
            if (hc.isLoading.value && hc.yearLabelSuggestions.isEmpty) {
              return Container(
                padding: EdgeInsets.symmetric(
                  vertical: context.rs(44, min: 36, max: 54),
                ),
                decoration: BoxDecoration(
                  color: kWhite,
                  borderRadius: BorderRadius.circular(
                    context.rs(22, min: 18, max: 26),
                  ),
                  border: Border.all(color: kBorderColor),
                ),
                child: const Center(
                  child: CircularProgressIndicator(color: kPrimaryColor),
                ),
              );
            }

            if (hc.yearLabelSuggestions.isEmpty) {
              return Container(
                width: double.infinity,
                padding: EdgeInsets.all(context.rs(22, min: 18, max: 28)),
                decoration: BoxDecoration(
                  color: kWhite,
                  borderRadius: BorderRadius.circular(
                    context.rs(22, min: 18, max: 26),
                  ),
                  border: Border.all(color: kBorderColor),
                ),
                child: Column(
                  children: [
                    Icon(
                      Icons.search_off_rounded,
                      color: kFontText6,
                      size: context.rs(42, min: 36, max: 48),
                    ),
                    MyText(
                      text: "No years found for this model.",
                      size: 16,
                      paddingTop: 12,
                      color: kFontText7,
                      weight: FontWeight.w700,
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              );
            }

            return Container(
              padding: EdgeInsets.all(context.rs(16, min: 14, max: 20)),
              decoration: BoxDecoration(
                color: kWhite,
                borderRadius: BorderRadius.circular(
                  context.rs(22, min: 18, max: 26),
                ),
                border: Border.all(color: kBorderColor),
                boxShadow: [
                  BoxShadow(
                    color: kFontText.withOpacity(0.08),
                    blurRadius: 24,
                    offset: const Offset(0, 12),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  MyText(
                    text: "Available Years",
                    size: 20,
                    color: kFontText,
                    weight: FontWeight.w800,
                  ),
                  MyText(
                    text: "Pick the matching year range for your vehicle.",
                    size: 14,
                    paddingTop: 4,
                    paddingBottom: 18,
                    color: kFontText6,
                    weight: FontWeight.w600,
                  ),
                  ...hc.yearLabelSuggestions.map((yearLabel) {
                    return _YearOption(
                      label: yearLabel,
                      onTap: () async {
                        await hc.selectYearLabelAndFetchCarId(yearLabel);

                        if (hc.selectedCarId.value.isEmpty) {
                          AppSnackBar.show(
                            "Locate Battery",
                            "No battery location found for $yearLabel.",
                          );
                          return;
                        }

                        Get.to(
                          () => LocateBatteryScreen(
                            carId: hc.selectedCarId.value,
                          ),
                        );
                      },
                    );
                  }),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}

class _YearOption extends StatelessWidget {
  const _YearOption({required this.label, required this.onTap});

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Bounce(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        margin: EdgeInsets.only(bottom: context.rs(12, min: 10, max: 14)),
        padding: EdgeInsets.symmetric(
          horizontal: context.rs(14, min: 12, max: 18),
          vertical: context.rs(14, min: 12, max: 16),
        ),
        decoration: BoxDecoration(
          color: kGreyContainerGreyColor2,
          borderRadius: BorderRadius.circular(context.rs(16, min: 14, max: 18)),
          border: Border.all(color: kBorderColor),
        ),
        child: Row(
          children: [
            Container(
              height: context.rs(42, min: 38, max: 46),
              width: context.rs(42, min: 38, max: 46),
              decoration: BoxDecoration(
                color: kPrimaryColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(
                Icons.event_available_rounded,
                color: kPrimaryColor,
                size: context.rs(22, min: 20, max: 24),
              ),
            ),
            Gap(context.rs(12, min: 10, max: 14)),
            Expanded(
              child: MyText(
                text: label,
                size: 17,
                color: kFontText,
                weight: FontWeight.w800,
              ),
            ),
            Container(
              height: context.rs(32, min: 30, max: 34),
              width: context.rs(32, min: 30, max: 34),
              decoration: BoxDecoration(
                color: kWhite,
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
