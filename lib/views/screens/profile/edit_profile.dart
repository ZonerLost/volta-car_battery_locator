import 'package:bounce/bounce.dart';
import 'package:fire_fighter/constants/app_colors.dart';
import 'package:fire_fighter/constants/extensions.dart';
import 'package:fire_fighter/generated/assets.dart';
import 'package:fire_fighter/views/screens/bottom_nav/BottomBarNav.dart';
import 'package:fire_fighter/views/screens/report_module/report_form_widgets.dart';
import 'package:fire_fighter/views/widget/common_image_view_widget.dart';
import 'package:fire_fighter/views/widget/my_button_new.dart';
import 'package:fire_fighter/views/widget/my_text_widget.dart';
import 'package:fire_fighter/views/widget/my_textfeild.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

import '../../../controller/edit_profile_controller.dart';
import '../../../controller/profile_controller.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final EditProfileController c = Get.put(EditProfileController());

  @override
  void dispose() {
    if (Get.isRegistered<EditProfileController>()) {
      Get.delete<EditProfileController>();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kWhite,
      resizeToAvoidBottomInset: false,
      bottomNavigationBar: SafeArea(
        top: false,
        child: Padding(
          padding: EdgeInsets.fromLTRB(
            context.rs(22, min: 18, max: 28),
            context.rs(10, min: 8, max: 12),
            context.rs(22, min: 18, max: 28),
            context.rs(16, min: 12, max: 20),
          ),
          child: Obx(
            () => MyButton(
              onTap: () async {
                if (c.isSaving.value) return;
                final saved = await c.saveProfile();
                if (!saved) return;

                if (Get.isRegistered<ProfileSettingsController>()) {
                  await Get.find<ProfileSettingsController>().refreshProfile();
                }

                Get.offAll(() => const BottomNavBar(), arguments: 0);
              },
              radius: 16,
              buttonText: c.isSaving.value ? "Saving..." : "Save Changes",
              hasgrad: true,
            ),
          ),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.fromLTRB(
            context.rs(22, min: 18, max: 28),
            context.rs(12, min: 10, max: 16),
            context.rs(22, min: 18, max: 28),
            context.rs(8, min: 6, max: 10),
          ),
          child: Column(
            children: [
              const Row(children: [ReportBackButton()]),
              Gap(context.rs(10, min: 8, max: 12)),
              const ReportHeaderCard(
                title: "Personal Info",
                subtitle: "Update your name, email, and password.",
                icon: Icons.person_rounded,
              ),
              Gap(context.rs(10, min: 8, max: 12)),
              Expanded(
                child: Obx(() {
                  if (c.isLoading.value) {
                    return const Center(
                      child: CircularProgressIndicator(color: kPrimaryColor),
                    );
                  }

                  return ReportFormCard(
                    children: [
                      reportLabel("Full Name"),
                      MyTextField(
                        controller: c.fullNameC,
                        hint: "Enter your full name",
                        hintsize: 13,
                        hintColor: kFontText5,
                        hintWeight: FontWeight.w600,
                        marginBottom: 10,
                        prefix: const ReportFieldIcon(Icons.person_rounded),
                        borderColor: kBorderColor3,
                      ),
                      reportLabel("Email Address"),
                      MyTextField(
                        controller: c.emailC,
                        hint: "Enter your email",
                        hintsize: 13,
                        hintColor: kFontText5,
                        hintWeight: FontWeight.w600,
                        marginBottom: 10,
                        prefix: const ReportFieldIcon(Icons.email_rounded),
                        borderColor: kBorderColor3,
                        keyboardType: TextInputType.emailAddress,
                      ),
                      Row(
                        children: [
                          Expanded(child: reportLabel("New Password")),
                          Bounce(
                            onTap: () async => c.changePassword(),
                            child: MyText(
                              text: "Update",
                              size: 14,
                              paddingBottom: 10,
                              color: kPrimaryColor,
                              weight: FontWeight.w800,
                            ),
                          ),
                        ],
                      ),
                      Obx(
                        () => MyTextField(
                          controller: c.newPasswordC,
                          hint: "Enter new password",
                          hintsize: 13,
                          hintColor: kFontText5,
                          hintWeight: FontWeight.w600,
                          marginBottom: 0,
                          obscureText: c.obscurePassword.value,
                          prefix: const ReportFieldIcon(Icons.lock_rounded),
                          borderColor: kBorderColor3,
                          suffix: Bounce(
                            onTap: c.togglePasswordVisibility,
                            child: Padding(
                              padding: EdgeInsets.only(
                                right: context.rs(2, min: 0, max: 4),
                              ),
                              child: CommonImageView(
                                imagePath: Assets.imagesEye,
                                height: context.rs(22, min: 20, max: 24),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
