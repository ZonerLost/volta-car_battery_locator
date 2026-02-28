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

import '../../../controller/edit_profile_controller.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  /// ✅ SAFE: no late init issue
  final EditProfileController c = Get.put(EditProfileController());

  @override
  void dispose() {
    /// optional: agar tum chaho to controller remove bhi kar sakte ho
    /// Get.delete<EditProfileController>();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Obx(
            () => Padding(
          padding: const EdgeInsets.all(24.0),
          child: MyButton(
            onTap: () async {
              if (c.isSaving.value) return;
              await c.saveProfile();
            },
            radius: 12,
            buttonText: c.isSaving.value ? "Saving..." : "Save Changes",
            hasgrad: true,
          ),
        ),
      ),
      body: AnimatedListView(
        padding: const EdgeInsets.all(24),
        children: [
          const Gap(50),

          Row(
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

          const Gap(16),

          const MyText(
            text: "Personal Info",
            size: 24,
            color: kFontText,
            weight: FontWeight.w700,
          ),

          const MyText(
            text: "Change your personal info settings including name, password.",
            size: 20,
            paddingBottom: 32,
            color: kFontText7,
            weight: FontWeight.w600,
          ),

          Obx(() {
            if (c.isLoading.value) {
              return const Padding(
                padding: EdgeInsets.only(top: 40),
                child: Center(child: CircularProgressIndicator()),
              );
            }

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const MyText(
                  text: "Full Name",
                  size: 16,
                  paddingBottom: 12,
                  color: kFontText,
                  weight: FontWeight.w700,
                ),
                MyTextField(
                  controller: c.fullNameC,
                  hint: "Enter your full name",
                  borderColor: kBorderColor3,
                ),

                const Gap(16),

                const MyText(
                  text: "Email Address",
                  size: 16,
                  paddingBottom: 12,
                  color: kFontText,
                  weight: FontWeight.w700,
                ),
                MyTextField(
                  controller: c.emailC,
                  hint: "Enter your email",
                  borderColor: kBorderColor3,
                ),

                const Gap(16),

                Row(
                  children: [
                    const MyText(
                      text: "New Password",
                      size: 16,
                      color: kFontText,
                      weight: FontWeight.w700,
                    ),
                    const Gap(6),
                    CommonImageView(
                      imagePath: Assets.imagesPasswordIcon,
                      height: 16,
                    ),
                  ],
                ),
                const Gap(12),

                Obx(() => MyTextField(
                  controller: c.newPasswordC,
                  hint: "**********",
                  obscureText: c.obscurePassword.value,
                  borderColor: kBorderColor3,
                  suffix: Bounce(
                    onTap: c.togglePasswordVisibility,
                    child: CommonImageView(
                      imagePath: Assets.imagesEye,
                      height: 24,
                    ),
                  ),
                )),

                const Gap(16),

                MyText(
                  text: "Update Password",
                  size: 16,
                  color: kPrimaryColor,
                  weight: FontWeight.w700,
                  onTap: () async {
                    await c.changePassword();
                  },
                ),
              ],
            );
          }),
        ],
      ),
    );
  }
}
