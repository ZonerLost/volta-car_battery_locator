// ignore_for_file: prefer_const_constructors

import 'package:bounce/bounce.dart';
import 'package:fire_fighter/views/screens/dialogs/dialogs.dart';
import 'package:fire_fighter/views/widget/my_button_new.dart';
import 'package:fire_fighter/views/widget/my_text_widget.dart';
import 'package:fire_fighter/views/widget/my_textfeild.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:fire_fighter/constants/app_colors.dart';
import 'package:fire_fighter/generated/assets.dart';
import 'package:fire_fighter/views/widget/common_image_view_widget.dart';
import 'package:fire_fighter/views/widget/custom_animated_column.dart';
import 'package:get/get.dart';

import '../../../controller/general_feedback_controller.dart';

class GeneralFeedbackScreen extends StatefulWidget {
  const GeneralFeedbackScreen({super.key});

  @override
  State<GeneralFeedbackScreen> createState() => _GeneralFeedbackScreenState();
}

class _GeneralFeedbackScreenState extends State<GeneralFeedbackScreen> {
  final GeneralFeedbackController c = Get.put(GeneralFeedbackController());

  @override
  void dispose() {
    if (Get.isRegistered<GeneralFeedbackController>()) {
      Get.delete<GeneralFeedbackController>();
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
              onTap: () async {
                await c.submit();
                DialogHelper.FeedbackSentDialog(context);
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
            crossAxisAlignment: CrossAxisAlignment.start,
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
                  text: "General Feedback",
                  size: 24,
                  color: kFontText,
                  weight: FontWeight.w700,
                ),
                MyText(
                  text:
                  "Have another issue or suggestion? Share your feedback with our team.",
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

                MyText(
                  text: "Email",
                  size: 16,
                  paddingBottom: 12,
                  color: kFontText,
                  weight: FontWeight.w700,
                ),
                MyTextField(
                  controller: c.emailC,
                  hint: "Enter your email",
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
                  keyboardType: TextInputType.emailAddress,
                ),

                MyText(
                  text: "Category",
                  size: 20,
                  paddingBottom: 12,
                  color: kFontText,
                  weight: FontWeight.w600,
                ),
                MyTextField(
                  controller: c.categoryC,
                  hint: "Select Category i.e Legal chatbot...",
                  hintsize: 14,
                  hintColor: kFontText5,
                  hintWeight: FontWeight.w600,
                  marginBottom: 12,
                  prefix: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CommonImageView(
                      imagePath: Assets.imagesTag,
                      height: 24,
                    ),
                  ),
                  borderColor: kBorderColor3,
                ),

                MyText(
                  text: "Message",
                  size: 16,
                  paddingBottom: 12,
                  color: kFontText,
                  weight: FontWeight.w700,
                ),
                MyTextField(
                  controller: c.messageC,
                  hint: "Write your message here",
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

                MyText(
                  text: "Add Attachment (Optional)",
                  size: 16,
                  paddingBottom: 12,
                  color: kFontText,
                  weight: FontWeight.w700,
                ),
                Obx(() => MyTextField(
                  hint: c.selectedFileName.value.isEmpty
                      ? "Proof.png"
                      : c.selectedFileName.value,
                  hintsize: 14,
                  hintColor: kFontText5,
                  hintWeight: FontWeight.w600,
                  marginBottom: 12,
                  prefix: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CommonImageView(
                      imagePath: Assets.imagesNote,
                      height: 24,
                    ),
                  ),
                  suffix: GestureDetector(
                    onTap: () async => await c.pickProofImage(),
                    child: CommonImageView(
                      imagePath: Assets.imagesUpload,
                      height: 18,
                    ),
                  ),
                  borderColor: kBorderColor3,
                  isReadOnly: true,
                )),

                Gap(20),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
