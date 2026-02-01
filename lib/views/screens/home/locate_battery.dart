// ignore_for_file: prefer_const_constructors

import 'package:bounce/bounce.dart';
import 'package:fire_fighter/controller/locate_battery_controller.dart';
import 'package:fire_fighter/controller/recent_searches_controller.dart';
import 'package:fire_fighter/model/car_details.dart';
import 'package:fire_fighter/views/screens/dialogs/dialogs.dart';
import 'package:fire_fighter/views/widget/my_button_new.dart';
import 'package:fire_fighter/views/widget/my_text_widget.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:fire_fighter/constants/app_colors.dart';
import 'package:fire_fighter/generated/assets.dart';
import 'package:fire_fighter/views/widget/common_image_view_widget.dart';
import 'package:fire_fighter/views/widget/custom_animated_column.dart';
import 'package:get/get.dart';

class LocateBatteryScreen extends StatefulWidget {
  final String carId;

  const LocateBatteryScreen({
    super.key,
    required this.carId,
  });

  @override
  State<LocateBatteryScreen> createState() => _LocateBatteryScreenState();
}

class _LocateBatteryScreenState extends State<LocateBatteryScreen> {
  late final LocateBatteryController c;
  bool _saved = false;

  @override
  void initState() {
    super.initState();

    // ✅ tagged instance (safe per carId)
    c = Get.put(LocateBatteryController(), tag: widget.carId);

    // fetch
    c.fetchCarById(widget.carId);
  }

  @override
  void dispose() {
    // ✅ clean tagged controller
    if (Get.isRegistered<LocateBatteryController>(tag: widget.carId)) {
      Get.delete<LocateBatteryController>(tag: widget.carId);
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedListView(
        padding: EdgeInsets.all(24),
        children: [
          Gap(50),

          // back
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

          Obx(() {
            if (c.isLoading.value) {
              return Padding(
                padding: const EdgeInsets.only(top: 40),
                child: Center(child: CircularProgressIndicator()),
              );
            }

            if (c.car.value == null) {
              return Padding(
                padding: const EdgeInsets.only(top: 40),
                child: Column(
                  children: [
                    MyText(
                      text: c.error.value.isNotEmpty
                          ? c.error.value
                          : "Car data not found",
                      size: 18,
                      color: kFontText,
                      weight: FontWeight.w700,
                    ),
                    Gap(12),
                    MyButton(
                      onTap: () => c.fetchCarById(widget.carId),
                      radius: 12,
                      buttonText: "Retry",
                      hasgrad: true,
                    ),
                  ],
                ),
              );
            }

            final CarDetails car = c.car.value!;

            // ✅ save recent once (optional)
            if (!_saved) {
              _saved = true;

              final rc = Get.isRegistered<RecentSearchesController>()
                  ? Get.find<RecentSearchesController>()
                  : Get.put(RecentSearchesController());

              rc.addRecentFromDetails(car);
            }

            return Padding(
              padding: const EdgeInsets.only(left: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // title
                  MyText(
                    text: "${car.make} ${car.model} (${car.yearLabel})",
                    size: 24,
                    color: kFontText,
                    weight: FontWeight.w700,
                  ),

                  MyText(
                    text: "Battery location identified below. Follow the blinking marker.",
                    size: 16,
                    color: kFontText7,
                    weight: FontWeight.w600,
                  ),

                  // ✅ location card (highlighted)
                  if (car.location.trim().isNotEmpty) ...[
                    Gap(16),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: kSecondaryGreenColor.withOpacity(0.12),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: kBorderColor3),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          MyText(
                            text: "Location",
                            size: 16,
                            color: kFontText,
                            weight: FontWeight.w700,
                          ),
                          Gap(6),
                          MyText(
                            text: car.location,
                            size: 14,
                            color: kFontText7,
                            weight: FontWeight.w500,
                          ),
                        ],
                      ),
                    ),
                  ],

                  Gap(30),

                  // ✅ diagram image (fallback to thumbnail, then asset)
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: _NetworkImageWithFallback(
                      primaryUrl: car.diagramUrl,
                      secondaryUrl: car.thumbnailUrl,
                      assetFallback: Assets.imagesCarSs,
                    ),
                  ),

                  Gap(44),

                  // Correct
                  MyButton(
                    onTap: () {
                      DialogHelper.FeedbackSentDialog(context);
                    },
                    backgroundColor: kSecondaryGreenColor.withOpacity(0.2),
                    radius: 12,
                    hasicon: true,
                    choiceIcon: Assets.imagesThumbsUp,
                    buttonText: "Correct",
                    fontColor: kSecondaryGreenColor,
                    hasgrad: true,
                  ),
                  Gap(12),

                  // Issue Report
                  MyButton(
                    onTap: () {
                      DialogHelper.FeedbackSentDialog(context);
                    },
                    backgroundColor: kPrimaryColor.withOpacity(0.2),
                    radius: 12,
                    hasicon: true,
                    choiceIcon: Assets.imagesThumbsDown,
                    buttonText: "Issue Report",
                    fontColor: kPrimaryColor,
                    hasgrad: true,
                  ),

                  Gap(40),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}

/// ✅ Helper widget: tries primary URL, then secondary, then asset
class _NetworkImageWithFallback extends StatelessWidget {
  final String primaryUrl;
  final String secondaryUrl;
  final String assetFallback;

  const _NetworkImageWithFallback({
    required this.primaryUrl,
    required this.secondaryUrl,
    required this.assetFallback,
  });

  @override
  Widget build(BuildContext context) {
    final hasPrimary = primaryUrl.trim().isNotEmpty;
    final hasSecondary = secondaryUrl.trim().isNotEmpty;

    if (hasPrimary) {
      return Image.network(
        primaryUrl,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) {
          if (hasSecondary) {
            return Image.network(
              secondaryUrl,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => CommonImageView(imagePath: assetFallback),
            );
          }
          return CommonImageView(imagePath: assetFallback);
        },
      );
    }

    if (hasSecondary) {
      return Image.network(
        secondaryUrl,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => CommonImageView(imagePath: assetFallback),
      );
    }

    return CommonImageView(imagePath: assetFallback);
  }
}
