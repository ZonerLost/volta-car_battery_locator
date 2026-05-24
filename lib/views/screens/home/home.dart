import 'package:firebase_auth/firebase_auth.dart';
import 'package:fire_fighter/constants/app_colors.dart';
import 'package:fire_fighter/constants/extensions.dart';
import 'package:fire_fighter/generated/assets.dart';
import 'package:fire_fighter/views/screens/home/year_selection.dart';
import 'package:fire_fighter/views/widget/common_image_view_widget.dart';
import 'package:fire_fighter/views/widget/custom_animated_column.dart';
import 'package:fire_fighter/views/widget/my_button_new.dart';
import 'package:fire_fighter/views/widget/my_text_widget.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

import '../../../controller/home_controller.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final HomeController hc = Get.put(HomeController(), permanent: true);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kbackground,
      body: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () => FocusScope.of(context).unfocus(),
        child: AnimatedListView(
          padding: EdgeInsets.fromLTRB(
            context.rs(22, min: 18, max: 32),
            context.rs(54, min: 42, max: 66),
            context.rs(22, min: 18, max: 32),
            context.rs(28, min: 20, max: 34),
          ),
          children: [
            _HomeHeader(hc: hc),
            Gap(context.rs(22, min: 16, max: 28)),
            Container(
              padding: EdgeInsets.all(context.rs(18, min: 16, max: 24)),
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
                  Row(
                    children: [
                      Container(
                        height: context.rs(42, min: 38, max: 46),
                        width: context.rs(42, min: 38, max: 46),
                        decoration: BoxDecoration(
                          color: kSecondaryColor.withOpacity(0.12),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Icon(
                          Icons.directions_car_filled_rounded,
                          color: kSecondaryColor,
                          size: context.rs(24, min: 22, max: 26),
                        ),
                      ),
                      Gap(context.rs(12, min: 10, max: 14)),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            MyText(
                              text: "Select Vehicle",
                              size: 20,
                              color: kFontText,
                              weight: FontWeight.w800,
                            ),
                            MyText(
                              text: "Choose make and model to continue",
                              size: 14,
                              color: kFontText6,
                              weight: FontWeight.w600,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Gap(context.rs(22, min: 18, max: 26)),
                  _sectionTitle("Make", required: true),
                  Obx(
                    () => DropdownButtonFormField<String>(
                      value:
                          hc.selectedMake.value.isEmpty
                              ? null
                              : hc.selectedMake.value,
                      isExpanded: true,
                      icon: const Icon(Icons.keyboard_arrow_down_rounded),
                      decoration: _dropdownDecoration(
                        context: context,
                        hintText:
                            hc.isLoading.value ? "Loading..." : "Select Make",
                        prefixIcon: _fieldIcon(
                          context,
                          Icons.local_offer_rounded,
                          kPrimaryColor,
                        ),
                      ),
                      items:
                          hc.makeSuggestions
                              .map(
                                (e) => DropdownMenuItem(
                                  value: e,
                                  child: Text(
                                    e,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              )
                              .toList(),
                      onChanged:
                          hc.isLoading.value
                              ? null
                              : (v) async {
                                if (v == null) return;
                                await hc.selectMake(v);
                              },
                    ),
                  ),
                  Gap(context.rs(16, min: 12, max: 18)),
                  _sectionTitle("Model", required: true),
                  Obx(
                    () => DropdownButtonFormField<String>(
                      value:
                          hc.selectedModel.value.isEmpty
                              ? null
                              : hc.selectedModel.value,
                      isExpanded: true,
                      icon: const Icon(Icons.keyboard_arrow_down_rounded),
                      decoration: _dropdownDecoration(
                        context: context,
                        hintText:
                            hc.selectedMake.value.isEmpty
                                ? "Select Make first"
                                : (hc.isLoading.value
                                    ? "Loading..."
                                    : "Select Model"),
                        prefixIcon: _fieldIcon(
                          context,
                          Icons.car_repair_rounded,
                          kSecondaryColor,
                        ),
                      ),
                      items:
                          hc.modelSuggestions
                              .map(
                                (e) => DropdownMenuItem(
                                  value: e,
                                  child: Text(
                                    e,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              )
                              .toList(),
                      onChanged:
                          (hc.selectedMake.value.isEmpty || hc.isLoading.value)
                              ? null
                              : (v) async {
                                if (v == null) return;
                                await hc.selectModel(v);
                              },
                    ),
                  ),
                  Gap(context.rs(26, min: 22, max: 32)),
                  Obx(
                    () => MyButton(
                      onTap: () async {
                        if (hc.selectedMake.value.isEmpty ||
                            hc.selectedModel.value.isEmpty) {
                          Get.snackbar(
                            "Locate Battery",
                            "Please select make and model.",
                          );
                          return;
                        }

                        await hc.loadYearLabels();
                        if (hc.yearLabelSuggestions.isEmpty) {
                          Get.snackbar(
                            "Locate Battery",
                            "No years found for this model.",
                          );
                          return;
                        }

                        Get.to(() => const YearSelectionScreen());
                      },
                      radius: 16,
                      buttonText: hc.isLoading.value ? "Loading..." : "Next",
                      hasgrad: true,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  InputDecoration _dropdownDecoration({
    required BuildContext context,
    required String hintText,
    required Widget prefixIcon,
  }) {
    return InputDecoration(
      hintText: hintText,
      filled: true,
      fillColor: kGreyContainerGreyColor2,
      hintStyle: TextStyle(
        color: kFontText6,
        fontWeight: FontWeight.w600,
        fontSize: context.rs(14, min: 13, max: 15),
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(context.rs(16, min: 14, max: 18)),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(context.rs(16, min: 14, max: 18)),
        borderSide: BorderSide(color: kBorderColor),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(context.rs(16, min: 14, max: 18)),
        borderSide: const BorderSide(color: kPrimaryColor, width: 1.4),
      ),
      disabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(context.rs(16, min: 14, max: 18)),
        borderSide: BorderSide(color: kBorderColor.withOpacity(0.7)),
      ),
      contentPadding: EdgeInsets.symmetric(
        horizontal: context.rs(12, min: 10, max: 14),
        vertical: context.rs(15, min: 13, max: 17),
      ),
      prefixIcon: prefixIcon,
    );
  }

  Widget _sectionTitle(String title, {bool required = false}) {
    return Row(
      children: [
        MyText(
          text: "$title ",
          size: 15,
          paddingBottom: 10,
          color: kFontText,
          weight: FontWeight.w800,
        ),
        if (required)
          MyText(
            text: "* ",
            size: 16,
            paddingBottom: 10,
            color: kPrimaryColor,
            weight: FontWeight.w800,
          ),
      ],
    );
  }

  Widget _fieldIcon(BuildContext context, IconData icon, Color color) {
    return Padding(
      padding: EdgeInsets.all(context.rs(10, min: 8, max: 11)),
      child: Container(
        width: context.rs(30, min: 28, max: 32),
        height: context.rs(30, min: 28, max: 32),
        decoration: BoxDecoration(
          color: color.withOpacity(0.12),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: color, size: context.rs(18, min: 16, max: 20)),
      ),
    );
  }
}

class _HomeHeader extends StatelessWidget {
  const _HomeHeader({required this.hc});

  final HomeController hc;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(context.rs(20, min: 18, max: 26)),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [kPrimaryColor, kPrimaryColor2],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(context.rs(26, min: 22, max: 30)),
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
            child: Obx(() {
              final _ = hc.user.value;
              final user = FirebaseAuth.instance.currentUser;
              final isGuest = user?.isAnonymous ?? false;
              final name =
                  isGuest ? "User" : (hc.user.value?.fullName ?? "User");

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  MyText(
                    text: "Welcome $name",
                    size: 24,
                    color: kWhite,
                    weight: FontWeight.w800,
                  ),
                  MyText(
                    text: "Find the battery location for any saved vehicle.",
                    size: 15,
                    paddingTop: 8,
                    color: kWhite.withOpacity(0.86),
                    weight: FontWeight.w600,
                  ),
                ],
              );
            }),
          ),
          Gap(context.rs(12, min: 10, max: 16)),
          Container(
            height: context.rs(76, min: 64, max: 88),
            width: context.rs(76, min: 64, max: 88),
            decoration: BoxDecoration(
              color: kWhite.withOpacity(0.16),
              borderRadius: BorderRadius.circular(22),
              border: Border.all(color: kWhite.withOpacity(0.2)),
            ),
            child: Center(
              child: CommonImageView(
                imagePath: Assets.imagesCarTaxiFront,
                height: context.rs(42, min: 36, max: 48),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
