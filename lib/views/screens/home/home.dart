// ignore_for_file: prefer_const_constructors

import 'package:bounce/bounce.dart';
import 'package:fire_fighter/views/screens/home/locate_battery.dart';
import 'package:fire_fighter/views/screens/notifications/notifications.dart';
import 'package:fire_fighter/views/widget/my_button_new.dart';
import 'package:fire_fighter/views/widget/my_text_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:fire_fighter/constants/app_colors.dart';
import 'package:fire_fighter/generated/assets.dart';
import 'package:fire_fighter/views/widget/common_image_view_widget.dart';
import 'package:fire_fighter/views/widget/custom_animated_column.dart';
import 'package:get/get.dart';

import '../../../controller/home_controller.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // ✅ SINGLE INSTANCE (important)
  final HomeController hc = Get.put(HomeController(), permanent: true);

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    final isGuest = user?.isAnonymous ?? false;
    return Scaffold(
      body: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () => FocusScope.of(context).unfocus(),
        child: AnimatedListView(
          padding: const EdgeInsets.all(32),
          children: [
            const Gap(50),

            /// 🔔 Notification Icon
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.end,
            //   children: [
            //     Bounce(
            //       onTap: () => Get.to(() => NotificationScreen()),
            //       child: CommonImageView(
            //         imagePath: Assets.imagesBellRing,
            //         height: 24,
            //       ),
            //     ),
            //   ],
            // ),

            const Gap(16),

            Row(
              children: [
                Obx(() {
                  // ✅ Force Rx read (always)
                  final _ = hc.user.value; // just to register dependency
                  final user = FirebaseAuth.instance.currentUser;
                  final isGuest = user?.isAnonymous ?? false;

                  final name = isGuest ? "User" : (hc.user.value?.fullName ?? "User");

                  return MyText(
                    text: "Welcome $name",
                    size: 24,
                    color: kFontText,
                    weight: FontWeight.w700,
                  );
                }),
              ],
            ),


            MyText(
              text: "Locate the car battery easily by just entering make, model and year.",
              size: 20,
              paddingBottom: 32,
              color: kFontText7,
              weight: FontWeight.w600,
            ),

            const Gap(10),

            /// ✅ optional debug line (remove later)
            Obx(() => Text(
              "makes=${hc.makeSuggestions.length} | models=${hc.modelSuggestions.length} | years=${hc.yearLabelSuggestions.length} | loading=${hc.isLoading.value}",
            )),

            const Gap(20),

            /// ================= MAKE =================
            _sectionTitle("Make", required: true),

            Obx(() => DropdownButtonFormField<String>(
              value: hc.selectedMake.value.isEmpty ? null : hc.selectedMake.value,
              isExpanded: true,
              decoration: InputDecoration(
                hintText: hc.isLoading.value ? "Loading..." : "Select Make",
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: kBorderColor3),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: kPrimaryColor),
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                prefixIcon: _carIcon(),
              ),
              items: hc.makeSuggestions
                  .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                  .toList(),
              onChanged: hc.isLoading.value
                  ? null
                  : (v) async {
                if (v == null) return;
                await hc.selectMake(v);
              },
            )),

            const Gap(12),

            /// ================= MODEL =================
            _sectionTitle("Model", required: true),

            Obx(() => DropdownButtonFormField<String>(
              value: hc.selectedModel.value.isEmpty ? null : hc.selectedModel.value,
              isExpanded: true,
              decoration: InputDecoration(
                hintText: hc.selectedMake.value.isEmpty
                    ? "Select Make first"
                    : (hc.isLoading.value ? "Loading..." : "Select Model"),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: kBorderColor3),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: kPrimaryColor),
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                prefixIcon: _carIcon(),
              ),
              items: hc.modelSuggestions
                  .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                  .toList(),
              onChanged: (hc.selectedMake.value.isEmpty || hc.isLoading.value)
                  ? null
                  : (v) async {
                if (v == null) return;
                await hc.selectModel(v);
              },
            )),

            const Gap(12),

            /// ================= YEAR =================
            _sectionTitle("Year", required: true),

            Obx(() => DropdownButtonFormField<String>(
              value: hc.selectedYearLabel.value.isEmpty ? null : hc.selectedYearLabel.value,
              isExpanded: true,
              decoration: InputDecoration(
                hintText: (hc.selectedMake.value.isEmpty || hc.selectedModel.value.isEmpty)
                    ? "Select Make & Model first"
                    : (hc.isLoading.value ? "Loading..." : "Select Year"),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: kBorderColor3),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: kPrimaryColor),
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                prefixIcon: Icon(Icons.calendar_month, color: kFontText5),
              ),
              items: hc.yearLabelSuggestions
                  .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                  .toList(),
              onTap: () async {
                if (hc.selectedMake.value.isEmpty || hc.selectedModel.value.isEmpty) return;
                await hc.loadYearLabels();
              },
              onChanged: (hc.selectedMake.value.isEmpty ||
                  hc.selectedModel.value.isEmpty ||
                  hc.isLoading.value)
                  ? null
                  : (v) async {
                if (v == null) return;
                await hc.selectYearLabelAndFetchCarId(v);
              },
            )),

            const Gap(48),

            /// ================= LOCATE BUTTON =================
            Obx(() => MyButton(
              onTap: () {
                if (!hc.canLocate) {
                  Get.snackbar("Locate Battery", "Please select make, model and year.");
                  return;
                }
                Get.to(() => LocateBatteryScreen(carId: hc.selectedCarId.value));
              },
              radius: 12,
              buttonText: hc.isLoading.value ? "Loading..." : "Locate Battery",
              hasgrad: true,
            )),
          ],
        ),
      ),
    );
  }

  Widget _sectionTitle(String title, {bool required = false}) {
    return Row(
      children: [
        MyText(
          text: "$title ",
          size: 20,
          paddingBottom: 12,
          color: kFontText,
          weight: FontWeight.w600,
        ),
        if (required)
          MyText(
            text: "* ",
            size: 20,
            paddingBottom: 12,
            color: kPrimaryColor,
            weight: FontWeight.w600,
          ),
      ],
    );
  }

  Widget _carIcon() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: CommonImageView(
        imagePath: Assets.imagesCarTaxiFront,
        height: 24,
      ),
    );
  }
}
