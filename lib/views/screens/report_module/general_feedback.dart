import 'package:fire_fighter/constants/app_colors.dart';
import 'package:fire_fighter/constants/extensions.dart';
import 'package:fire_fighter/controller/general_feedback_controller.dart';
import 'package:fire_fighter/views/screens/report_module/report_form_widgets.dart';
import 'package:fire_fighter/views/widget/my_button_new.dart';
import 'package:fire_fighter/views/widget/my_text_widget.dart';
import 'package:fire_fighter/views/widget/my_textfeild.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

class GeneralFeedbackScreen extends StatefulWidget {
  final String? initialCategory;
  final String? initialMessage;

  const GeneralFeedbackScreen({
    super.key,
    this.initialCategory,
    this.initialMessage,
  });

  @override
  State<GeneralFeedbackScreen> createState() => _GeneralFeedbackScreenState();
}

class _GeneralFeedbackScreenState extends State<GeneralFeedbackScreen> {
  late final GeneralFeedbackController c;

  @override
  void initState() {
    super.initState();
    c = Get.put(GeneralFeedbackController());

    final category = widget.initialCategory?.trim() ?? "";
    final message = widget.initialMessage?.trim() ?? "";

    if (category.isNotEmpty) {
      c.categoryC.text = category;
    }
    if (message.isNotEmpty) {
      c.messageC.text = message;
    }
  }

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
      backgroundColor: kbackground,
      resizeToAvoidBottomInset: true,
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
                if (c.isSubmitting.value) return;
                await c.submit();
              },
              radius: 16,
              buttonText:
                  c.isSubmitting.value ? "Submitting..." : "Submit Feedback",
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
                title: "General Feedback",
                subtitle: "Share another issue, suggestion, or app feedback.",
                icon: Icons.chat_bubble_rounded,
              ),
              Gap(context.rs(10, min: 8, max: 12)),
              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  keyboardDismissBehavior:
                      ScrollViewKeyboardDismissBehavior.onDrag,
                  child: ReportFormCard(
                    children: [
                      Obx(() {
                        if (c.error.value.isEmpty) {
                          return const SizedBox.shrink();
                        }
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: MyText(
                            text: c.error.value,
                            size: 12,
                            color: Colors.red,
                            maxLines: 2,
                            textOverflow: TextOverflow.ellipsis,
                            weight: FontWeight.w700,
                          ),
                        );
                      }),
                      _compactField(
                        label: "Email",
                        required: true,
                        controller: c.emailC,
                        hint: "Email",
                        icon: Icons.email_rounded,
                        keyboardType: TextInputType.emailAddress,
                      ),
                      _categoryDropdown(context),
                      _compactField(
                        label: "Message",
                        required: true,
                        controller: c.messageC,
                        hint: "Write your message",
                        icon: Icons.notes_rounded,
                        showPrefix: false,
                        maxLines: 4,
                        marginBottom: 0,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _compactField({
    required String label,
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    bool required = false,
    int maxLines = 1,
    double marginBottom = 8,
    TextInputType? keyboardType,
    bool showPrefix = true,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        reportLabel(label, isRequired: required),
        MyTextField(
          controller: controller,
          hint: hint,
          hintsize: 13,
          hintColor: kFontText5,
          hintWeight: FontWeight.w600,
          marginBottom: marginBottom,
          prefix: showPrefix ? ReportFieldIcon(icon) : null,
          borderColor: kBorderColor3,
          keyboardType: keyboardType,
          maxLines: maxLines,
        ),
      ],
    );
  }

  Widget _categoryDropdown(BuildContext context) {
    const categories = [
      "App issue",
      "Battery location",
      "Can't find battery",
      "Found battery in another location",
      "Vehicle data",
      "Suggestion",
      "Other",
    ];

    final selected =
        categories.contains(c.categoryC.text.trim())
            ? c.categoryC.text.trim()
            : null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        reportLabel("Category", isRequired: true),
        DropdownButtonFormField<String>(
          value: selected,
          isExpanded: true,
          icon: const Icon(Icons.keyboard_arrow_down_rounded),
          decoration: InputDecoration(
            hintText: "Category",
            filled: true,
            fillColor: kWhite,
            prefixIcon: const ReportFieldIcon(Icons.sell_rounded),
            hintStyle: TextStyle(
              color: kFontText5,
              fontSize: context.rs(13, min: 12),
              fontWeight: FontWeight.w600,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(context.rs(12)),
              borderSide: BorderSide(color: kBorderColor3),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(context.rs(12)),
              borderSide: BorderSide(color: kBorderColor3),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(context.rs(12)),
              borderSide: const BorderSide(color: kPrimaryColor, width: 1.4),
            ),
            contentPadding: EdgeInsets.symmetric(
              horizontal: context.rs(16),
              vertical: context.rs(14),
            ),
          ),
          items:
              categories
                  .map(
                    (category) => DropdownMenuItem(
                      value: category,
                      child: Text(
                        category,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: kFontText,
                          fontSize: context.rs(13, min: 12),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  )
                  .toList(),
          onChanged: (value) {
            if (value == null) return;
            c.categoryC.text = value;
          },
        ),
        Gap(context.rs(8, min: 6, max: 10)),
      ],
    );
  }
}
