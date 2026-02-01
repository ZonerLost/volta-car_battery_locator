import 'package:bounce/bounce.dart';
import 'package:fire_fighter/views/screens/dialogs/dialogs.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:fire_fighter/constants/app_colors.dart';
import 'package:fire_fighter/generated/assets.dart';
import 'package:fire_fighter/views/widget/common_image_view_widget.dart';
import 'package:fire_fighter/views/widget/custom_animated_column.dart';
import 'package:fire_fighter/views/widget/my_text_widget.dart';
import 'package:fire_fighter/views/widget/my_textfeild.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
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
          MyText(
            text: "Personal Info",
            size: 24,
            color: kFontText,
            weight: FontWeight.w700,
          ),
          MyText(
            text:
                "Change your personal info settings including name, password.",
            size: 20,
            paddingBottom: 32,
            color: kFontText7,
            weight: FontWeight.w600,
          ),

          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              MyText(
                text: "Full Name",
                size: 16,
                paddingBottom: 12,
                color: kFontText,
                weight: FontWeight.w700,
              ),
              MyTextField(
                hint: "Enter your full name ",
                hintsize: 14,
                hintColor: kFontText5,
                hintWeight: FontWeight.w600,
                marginBottom: 12,
                prefix: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CommonImageView(
                    imagePath: Assets.imagesPerson,
                    height: 24,
                  ),
                ),
                borderColor: kBorderColor3,
              ),

              MyText(
                text: "Email Address",
                size: 16,
                paddingBottom: 12,
                color: kFontText,
                weight: FontWeight.w700,
              ),
              MyTextField(
                hint: "Enter your email ",
                hintsize: 14,
                hintColor: kFontText5,
                hintWeight: FontWeight.w600,
                marginBottom: 12,
                prefix: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CommonImageView(
                    imagePath: Assets.imagesEmail,
                    height: 24,
                  ),
                ),
                borderColor: kBorderColor3,
              ),
              Row(
                spacing: 6,
                children: [
                  MyText(
                    text: "Password",
                    size: 16,
                    color: kFontText,
                    weight: FontWeight.w700,
                  ),
                  CommonImageView(
                    imagePath: Assets.imagesPasswordIcon,
                    height: 16,
                  ),
                ],
              ),
              Gap(12),
              MyTextField(
                hint: "**********",
                hintsize: 14,
                hintWeight: FontWeight.w600,
                hintColor: kFontText5,
                marginBottom: 12,
                prefix: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CommonImageView(
                    imagePath: Assets.imagesLock,
                    height: 24,
                  ),
                ),
                suffix: Bounce(
                  onTap: () {},
                  child: CommonImageView(
                    imagePath: Assets.imagesEye, // Change icon
                    height: 24,
                  ),
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            spacing: 6,
            children: [
              MyText(
                onTap: () => DialogHelper.ChangePasswordDialog(context),
                text: "Change Password",
                size: 16,
                paddingBottom: 60,
                color: kPrimaryColor,
                weight: FontWeight.w700,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
