// ignore_for_file: prefer_const_constructors

import 'package:bounce/bounce.dart';
import 'package:fire_fighter/constants/app_colors.dart';
import 'package:fire_fighter/generated/assets.dart';
import 'package:fire_fighter/views/widget/common_image_view_widget.dart';
import 'package:fire_fighter/views/widget/custom_animated_column.dart';
import 'package:fire_fighter/views/widget/my_button_new.dart';
import 'package:fire_fighter/views/widget/my_text_widget.dart';
import 'package:fire_fighter/views/widget/my_textfeild.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

import '../../../controller/wrong_location_controller.dart';

class WrongLocationScreen extends StatefulWidget {
  final String? make;
  final String? model;
  final String? year;
  final String? reportedArea;

  const WrongLocationScreen({
    super.key,
    this.make,
    this.model,
    this.year,
    this.reportedArea,
  });

  @override
  State<WrongLocationScreen> createState() => _WrongLocationScreenState();
}

class _WrongLocationScreenState extends State<WrongLocationScreen> {
  // ✅ FIX: initialize here (no late)
  final WrongLocationController c = Get.put(WrongLocationController());

  bool _prefilled = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // ✅ prefill once (safe)
    if (!_prefilled) {
      _prefilled = true;
      c.prefill(
        make: widget.make,
        model: widget.model,
        year: widget.year,
        reportedArea: widget.reportedArea,
      );
    }
  }

  @override
  void dispose() {
    // ✅ optional cleanup (if you open this screen many times)
    if (Get.isRegistered<WrongLocationController>()) {
      Get.delete<WrongLocationController>();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: Obx(() => MyButton(
              onTap: () {
                if (c.isSubmitting.value) return;
                c.submit();
              },

              radius: 12,
              buttonText:
              c.isSubmitting.value ? "Submitting..." : "Submit Feedback",
              hasgrad: true,
            )),
          ),
          Gap(30),
        ],
      ),
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
          Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                MyText(
                  text: "Wrong Location",
                  size: 24,
                  color: kFontText,
                  weight: FontWeight.w700,
                ),
                MyText(
                  text: "Tell us where the battery icon should be.",
                  size: 20,
                  paddingBottom: 18,
                  color: kFontText7,
                  weight: FontWeight.w600,
                ),

                // ✅ error
                Obx(() {
                  if (c.error.value.isEmpty) return SizedBox.shrink();
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: MyText(
                      text: c.error.value,
                      size: 14,
                      color: Colors.red,
                      weight: FontWeight.w600,
                    ),
                  );
                }),

                _buildLabel("Make", isRequired: true),
                MyTextField(
                  controller: c.makeC,
                  hint: "Enter Car Make (e.g. Toyota)",
                  hintsize: 14,
                  hintColor: kFontText5,
                  hintWeight: FontWeight.w600,
                  marginBottom: 12,
                  prefix: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CommonImageView(
                      imagePath: Assets.imagesCarTaxiFront,
                      height: 24,
                    ),
                  ),
                  borderColor: kBorderColor3,
                ),

                _buildLabel("Model", isRequired: true),
                MyTextField(
                  controller: c.modelC,
                  hint: "Enter Car Model (e.g. Corolla)",
                  hintsize: 14,
                  hintColor: kFontText5,
                  hintWeight: FontWeight.w600,
                  marginBottom: 12,
                  prefix: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CommonImageView(
                      imagePath: Assets.imagesCar,
                      height: 24,
                    ),
                  ),
                  borderColor: kBorderColor3,
                ),

                _buildLabel("Year", isRequired: true),
                MyTextField(
                  controller: c.yearC,
                  hint: "Enter Year (e.g. 2015)",
                  hintsize: 14,
                  hintColor: kFontText5,
                  hintWeight: FontWeight.w600,
                  marginBottom: 12,
                  prefix: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CommonImageView(
                      imagePath: Assets.imagesCalendar2,
                      height: 24,
                    ),
                  ),
                  borderColor: kBorderColor3,
                  keyboardType: TextInputType.number,
                ),

                _buildLabel("Reported Area"),
                MyTextField(
                  controller: c.reportedAreaC,
                  hint: "Where is it currently shown? (optional)",
                  hintsize: 14,
                  hintColor: kFontText5,
                  hintWeight: FontWeight.w600,
                  marginBottom: 12,
                  prefix: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CommonImageView(
                      imagePath: Assets.imagesTarget,
                      height: 24,
                    ),
                  ),
                  borderColor: kBorderColor3,
                ),

                _buildLabel("Correct Area", isRequired: true),
                MyTextField(
                  controller: c.correctAreaC,
                  hint: "Where should it be? (Engine Bay - Front Right)",
                  hintsize: 14,
                  hintColor: kFontText5,
                  hintWeight: FontWeight.w600,
                  marginBottom: 12,
                  prefix: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CommonImageView(
                      imagePath: Assets.imagesBatteryCharging,
                      height: 24,
                    ),
                  ),
                  borderColor: kBorderColor3,
                ),

                _buildLabel("Message"),
                MyTextField(
                  controller: c.messageC,
                  hint: "Write your message here (optional)",
                  hintsize: 14,
                  hintColor: kFontText5,
                  hintWeight: FontWeight.w600,
                  marginBottom: 12,
                  prefix: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CommonImageView(
                      imagePath: Assets.imagesTarget,
                      height: 24,
                    ),
                  ),
                  borderColor: kBorderColor3,
                  maxLines: 3,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLabel(String label, {bool isRequired = false}) {
    return Row(
      children: [
        MyText(
          text: label,
          size: 20,
          paddingBottom: 12,
          color: kFontText,
          weight: FontWeight.w600,
        ),
        if (isRequired)
          MyText(
            text: "*",
            size: 20,
            paddingBottom: 12,
            color: kPrimaryColor,
            weight: FontWeight.w600,
          ),
      ],
    );
  }
}
