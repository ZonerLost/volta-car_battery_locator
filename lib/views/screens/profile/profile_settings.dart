// ignore_for_file: prefer_const_constructors

import 'package:bounce/bounce.dart';
import 'package:fire_fighter/constants/app_colors.dart';
import 'package:fire_fighter/generated/assets.dart';
import 'package:fire_fighter/views/screens/dialogs/dialogs.dart';
import 'package:fire_fighter/views/screens/profile/edit_profile.dart';
import 'package:fire_fighter/views/screens/profile/help_center.dart';
import 'package:fire_fighter/views/screens/profile/privacy.dart';
import 'package:fire_fighter/views/widget/common_image_view_widget.dart';
import 'package:fire_fighter/views/widget/custom_animated_column.dart';
import 'package:fire_fighter/views/widget/my_text_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

import '../../../controller/profile_controller.dart';

class ProfileSettingsScreen extends StatefulWidget {
  const ProfileSettingsScreen({super.key});

  @override
  State<ProfileSettingsScreen> createState() => _ProfileSettingsScreenState();
}

class _ProfileSettingsScreenState extends State<ProfileSettingsScreen> {
  late final ProfileSettingsController c;

  @override
  void initState() {
    super.initState();

    /// ✅ Put controller once
    c = Get.put(ProfileSettingsController());

    /// ✅ Load profile once screen opens
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final user = FirebaseAuth.instance.currentUser;
      final isGuest = user?.isAnonymous ?? false;

      if (!isGuest) {
        c.refreshProfile(); // only real users
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    final isGuest = user?.isAnonymous ?? false;

    return Scaffold(
      body: AnimatedListView(
        padding: const EdgeInsets.all(24),
        children: [
          Gap(50),

          // ✅ FIXED HEADER: Guest = no Obx, User = Obx
          isGuest
              ? Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 18,
                ),
                decoration: BoxDecoration(
                  color: kWhite,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: kBorderColor3),
                ),
                child: Row(
                  children: [
                    CommonImageView(
                      imagePath: Assets.imagesProfile,
                      height: 38,
                    ),
                    Gap(12),
                    Expanded(
                      child: MyText(
                        text: "User",
                        size: 16,
                        weight: FontWeight.w600,
                        color: kFontText,
                      ),
                    ),
                  ],
                ),
              )
              : Obx(
                () => Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 18,
                  ),
                  decoration: BoxDecoration(
                    color: kWhite,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: kBorderColor3),
                  ),
                  child: Row(
                    children: [
                      CommonImageView(
                        imagePath: Assets.imagesProfile,
                        height: 38,
                      ),
                      Gap(12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            MyText(
                              text:
                                  c.isLoading.value
                                      ? "Loading..."
                                      : (c.fullName.value.isEmpty
                                          ? "User"
                                          : c.fullName.value),
                              size: 16,
                              weight: FontWeight.w600,
                              color: kFontText,
                            ),
                            MyText(
                              text: c.isLoading.value ? "" : c.email.value,
                              size: 14,
                              maxLines: 1,
                              textOverflow: TextOverflow.ellipsis,
                              color: kFontText,
                            ),
                          ],
                        ),
                      ),
                      Bounce(
                        onTap: () async {
                          final res = await Get.to(
                            () => const EditProfileScreen(),
                          );
                          if (res == true) {
                            await c.refreshProfile();
                          }
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: kPrimaryColor,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: MyText(
                            text: "Edit",
                            size: 12,
                            color: kWhite,
                            weight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

          Gap(32),

          MyText(
            text: "Settings",
            size: 20,
            weight: FontWeight.w700,
            color: kBlack,
            paddingBottom: 16,
          ),

          /// ✅ Settings Card
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 4),
            decoration: BoxDecoration(
              color: kWhite,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: kBorderColor3),
            ),
            child: Column(
              children: [
                _buildSettingTile(
                  icon: Assets.imagesPrivacy,
                  title: "Privacy & Terms",
                  subtitle: "View our policies and data practices.",
                  onTap: () => Get.to(() => const PrivacyPolicyScreen()),
                ),
                _divider(),

                _buildSettingTile(
                  icon: Assets.imagesCache,
                  title: "Cache / Offline Data",
                  subtitle: "Remove stored searches and free space.",
                  onTap: () {
                    DialogHelper.CacheDialog(
                      context,
                      onConfirm: () async {
                        await c.clearCache();
                      },
                    );
                  },
                ),

                _divider(),

                _buildSettingTile(
                  icon: Assets.imagesSupport,
                  title: "Support & Info",
                  subtitle: "Get help or report urgent issues.",
                  onTap: () => Get.to(() => const HelpCenterScreen()),
                ),

                _divider(),

                _buildSettingTile(
                  icon: Assets.imagesLogout,
                  title: isGuest ? "Exit Guest" : "Logout",
                  subtitle:
                      isGuest
                          ? "Return to login screen."
                          : "Log out of your account.",
                  onTap: () {
                    DialogHelper.LogoutDialog(
                      context,
                      onConfirm: () async {
                        await c.logout(context);
                      },
                    );
                  },
                ),
                if (!isGuest) ...[
                  _divider(),
                  _buildSettingTile(
                    icon: Assets.imagesClose,
                    title: "Delete Account",
                    subtitle: "Permanently delete your account and saved data.",
                    onTap: () => _showDeleteAccountDialog(context),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingTile({
    required String icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Bounce(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            CommonImageView(imagePath: icon, height: 38),
            Gap(14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  MyText(
                    text: title,
                    size: 16,
                    weight: FontWeight.w600,
                    color: kFontText,
                  ),
                  MyText(text: subtitle, size: 13, color: kFontText),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _divider() {
    return Divider(height: 0, color: kDividerColor, indent: 16, endIndent: 16);
  }

  Future<void> _showDeleteAccountDialog(BuildContext context) async {
    final passwordController = TextEditingController();
    final needsPassword = c.needsPasswordForDeletion;

    await Get.dialog<void>(
      AlertDialog(
        backgroundColor: kWhite,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text("Delete account permanently?"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Your profile, recent searches, and Firebase account will be permanently deleted. This cannot be undone.",
            ),
            if (needsPassword) ...[
              const Gap(16),
              TextField(
                controller: passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: "Current password",
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ],
        ),
        actions: [
          TextButton(onPressed: Get.back, child: const Text("Cancel")),
          Obx(
            () => FilledButton(
              style: FilledButton.styleFrom(backgroundColor: kPrimaryColor),
              onPressed:
                  c.isDeleting.value
                      ? null
                      : () async {
                        final deleted = await c.deleteAccount(
                          password: passwordController.text,
                        );
                        if (!deleted || !context.mounted) return;
                        Get.offAllNamed('/login');
                      },
              child: Text(
                c.isDeleting.value ? "Deleting..." : "Delete permanently",
              ),
            ),
          ),
        ],
      ),
      barrierDismissible: false,
    );
    passwordController.dispose();
  }
}
