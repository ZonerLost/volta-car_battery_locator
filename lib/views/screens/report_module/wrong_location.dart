import 'package:fire_fighter/constants/app_colors.dart';
import 'package:fire_fighter/constants/extensions.dart';
import 'package:fire_fighter/controller/wrong_location_controller.dart';
import 'package:fire_fighter/views/screens/report_module/report_form_widgets.dart';
import 'package:fire_fighter/views/widget/custom_animated_column.dart';
import 'package:fire_fighter/views/widget/my_button_new.dart';
import 'package:fire_fighter/views/widget/my_text_widget.dart';
import 'package:fire_fighter/views/widget/my_textfeild.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

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
  final WrongLocationController c = Get.put(WrongLocationController());
  bool _prefilled = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_prefilled) return;
    _prefilled = true;
    c.prefill(
      make: widget.make,
      model: widget.model,
      year: widget.year,
      reportedArea: widget.reportedArea,
    );
  }

  @override
  void dispose() {
    if (Get.isRegistered<WrongLocationController>()) {
      Get.delete<WrongLocationController>();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kbackground,
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
              onTap: () {
                if (c.isSubmitting.value) return;
                c.submit();
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
                title: "Wrong Location",
                subtitle: "Tell us where the battery marker should be.",
                icon: Icons.location_off_rounded,
              ),
              Gap(context.rs(10, min: 8, max: 12)),
              Expanded(
                child: ReportFormCard(
                  children: [
                    Obx(() {
                      if (c.error.value.isEmpty) return const SizedBox.shrink();
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
                    Row(
                      children: [
                        Expanded(
                          child: _compactField(
                            label: "Year",
                            required: true,
                            controller: c.yearC,
                            hint: "Year",
                            icon: Icons.calendar_month_rounded,
                            keyboardType: TextInputType.number,
                          ),
                        ),
                        Gap(context.rs(10, min: 8, max: 12)),
                        Expanded(
                          child: _compactField(
                            label: "Shown Area",
                            controller: c.reportedAreaC,
                            hint: "Current",
                            icon: Icons.my_location_rounded,
                          ),
                        ),
                      ],
                    ),
                    _compactField(
                      label: "Correct Area",
                      required: true,
                      controller: c.correctAreaC,
                      hint: "Where should it be?",
                      icon: Icons.battery_charging_full_rounded,
                    ),
                    _compactField(
                      label: "Message",
                      controller: c.messageC,
                      hint: "Optional message",
                      icon: Icons.notes_rounded,
                      maxLines: 2,
                      marginBottom: 0,
                    ),
                  ],
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
          prefix: ReportFieldIcon(icon),
          borderColor: kBorderColor3,
          keyboardType: keyboardType,
          maxLines: maxLines,
        ),
      ],
    );
  }
}
