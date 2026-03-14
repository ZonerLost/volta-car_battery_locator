// ignore_for_file: prefer_const_constructors

import 'package:bounce/bounce.dart';
import 'package:fire_fighter/constants/app_colors.dart';
import 'package:fire_fighter/controller/locate_battery_controller.dart';
import 'package:fire_fighter/controller/recent_searches_controller.dart';
import 'package:fire_fighter/generated/assets.dart';
import 'package:fire_fighter/model/car_details.dart';
import 'package:fire_fighter/views/screens/dialogs/dialogs.dart';
import 'package:fire_fighter/views/widget/common_image_view_widget.dart';
import 'package:fire_fighter/views/widget/custom_animated_column.dart';
import 'package:fire_fighter/views/widget/my_button_new.dart';
import 'package:fire_fighter/views/widget/my_text_widget.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
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
    c = Get.put(LocateBatteryController(), tag: widget.carId);
    c.fetchCarById(widget.carId);
  }

  @override
  void dispose() {
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
                  MyText(
                    text: "${car.make} ${car.model} (${car.yearLabel})",
                    size: 24,
                    color: kFontText,
                    weight: FontWeight.w700,
                  ),

                  MyText(
                    text:
                    "Battery location identified below. Follow the blinking marker.",
                    size: 16,
                    color: kFontText7,
                    weight: FontWeight.w600,
                  ),

                  if (car.description.trim().isNotEmpty) ...[
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
                            text: "Battery Location",
                            size: 16,
                            color: kFontText,
                            weight: FontWeight.w700,
                          ),
                          Gap(6),
                          MyText(
                            text: car.description,
                            size: 14,
                            color: kFontText7,
                            weight: FontWeight.w500,
                          ),
                        ],
                      ),
                    ),
                  ],

                  Gap(30),

                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: BatteryDiagramWithMarker(car: car),
                  ),

                  Gap(44),

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

class BatteryDiagramWithMarker extends StatelessWidget {
  final CarDetails car;

  const BatteryDiagramWithMarker({
    super.key,
    required this.car,
  });

  @override
  Widget build(BuildContext context) {
    final marker = car.marker;
    final hasMarker = marker != null && car.markerStatus == "set";

    return AspectRatio(
      aspectRatio: 0.62,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final width = constraints.maxWidth;
          final height = constraints.maxHeight;

          final left = hasMarker ? (marker.xPct / 100) * width : 0.0;
          final top = hasMarker ? (marker.yPct / 100) * height : 0.0;

          return Stack(
            children: [
              Positioned.fill(
                child: Image.asset(
                  "assets/images/car1.jpeg",
                  fit: BoxFit.contain,
                ),
              ),
              if (hasMarker)
                Positioned(
                  left: left,
                  top: top,
                  child: Transform.translate(
                    offset: const Offset(-18, -18),
                    child: const _BlinkingBatteryMarker(),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}
class _BlinkingBatteryMarker extends StatefulWidget {
  const _BlinkingBatteryMarker();

  @override
  State<_BlinkingBatteryMarker> createState() =>
      _BlinkingBatteryMarkerState();
}

class _BlinkingBatteryMarkerState extends State<_BlinkingBatteryMarker>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: Tween<double>(begin: 0.35, end: 1).animate(_controller),
      child: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: Colors.red,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.red.withOpacity(0.35),
              blurRadius: 10,
              spreadRadius: 3,
            ),
          ],
        ),
        child: const Icon(
          Icons.battery_alert,
          color: Colors.white,
          size: 20,
        ),
      ),
    );
  }
}