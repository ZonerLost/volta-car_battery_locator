import 'package:fire_fighter/constants/app_colors.dart';
import 'package:fire_fighter/constants/extensions.dart';
import 'package:fire_fighter/controller/missing_car_controller.dart';
import 'package:fire_fighter/views/screens/report_module/report_form_widgets.dart';
import 'package:fire_fighter/views/widget/my_button_new.dart';
import 'package:fire_fighter/views/widget/my_text_widget.dart';
import 'package:fire_fighter/views/widget/my_textfeild.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

class MissingCarScreen extends StatefulWidget {
  const MissingCarScreen({super.key});

  @override
  State<MissingCarScreen> createState() => _MissingCarScreenState();
}

class _MissingCarScreenState extends State<MissingCarScreen> {
  final MissingCarController c = Get.put(MissingCarController());

  @override
  void dispose() {
    if (Get.isRegistered<MissingCarController>()) {
      Get.delete<MissingCarController>();
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
                title: "Missing Car",
                subtitle: "Not seeing your car? Submit details to add it.",
                icon: Icons.directions_car_filled_rounded,
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
                      Row(
                        children: [
                          Expanded(
                            child: _compactField(
                              label: "Make",
                              required: true,
                              controller: c.makeC,
                              hint: "Make",
                              icon: Icons.local_offer_rounded,
                            ),
                          ),
                          Gap(context.rs(10, min: 8, max: 12)),
                          Expanded(
                            child: _compactField(
                              label: "Model",
                              required: true,
                              controller: c.modelC,
                              hint: "Model",
                              icon: Icons.car_repair_rounded,
                            ),
                          ),
                        ],
                      ),
                      _compactField(
                        label: "Year",
                        required: true,
                        controller: c.yearC,
                        hint: "Enter year",
                        icon: Icons.calendar_month_rounded,
                        keyboardType: TextInputType.number,
                      ),
                      _compactField(
                        label: "Message",
                        controller: c.messageC,
                        hint: "Optional message",
                        icon: Icons.notes_rounded,
                        showIcon: false,
                        maxLines: 3,
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
    bool showIcon = true,
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
          prefix: showIcon ? ReportFieldIcon(icon) : null,
          borderColor: kBorderColor3,
          keyboardType: keyboardType,
          maxLines: maxLines,
        ),
      ],
    );
  }
}
