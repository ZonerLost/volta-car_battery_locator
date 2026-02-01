import 'package:dropdown_button2/dropdown_button2.dart';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:fire_fighter/constants/app_colors.dart';
import 'package:fire_fighter/generated/assets.dart';
import 'package:fire_fighter/views/widget/common_image_view_widget.dart';
import 'package:fire_fighter/views/widget/custom_animated_row.dart';
import 'package:fire_fighter/views/widget/my_text_widget.dart';

// ... (other imports remain the same)
class CustomDropDown extends StatelessWidget {
  const CustomDropDown({
    super.key,
    required this.hint,
    required this.items,
    required this.selectedValue,
    required this.onChanged,
    this.bgColor,
    this.marginBottom,
    this.width,
    this.labelText,
    this.prefixIcon, // Add prefixIcon parameter
  });

  final List<dynamic>? items;
  final String selectedValue;
  final ValueChanged<dynamic>? onChanged;
  final String hint;
  final String? labelText;
  final Color? bgColor;
  final double? marginBottom, width;
  final Widget? prefixIcon; // Add prefixIcon property

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: marginBottom ?? 16),
      child: Animate(
        effects: [
          MoveEffect(
            duration: Duration(milliseconds: 500),
            begin: const Offset(20, 0),
          ),
        ],
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (labelText != null)
              Animate(
                effects: [
                  MoveEffect(
                    duration: Duration(milliseconds: 500),
                    begin: const Offset(20, 0),
                  ),
                ],
                child: MyText(
                  paddingBottom: 10,
                  text: labelText!,
                  size: 16,
                  color: kBlack,
                  textAlign: TextAlign.start,
                  weight: FontWeight.w600,
                ),
              ),
            Animate(
              effects: [
                MoveEffect(
                  duration: Duration(milliseconds: 500),
                  begin: const Offset(20, 0),
                ),
              ],
              child: DropdownButtonHideUnderline(
                child: DropdownButton2(
                  items:
                      items!
                          .map(
                            (item) => DropdownMenuItem<dynamic>(
                              value: item,
                              child: MyText(
                                text: item,
                                size: 12,
                                color: kBlack,
                                weight: FontWeight.w600,
                              ),
                            ),
                          )
                          .toList(),
                  value: selectedValue == hint ? null : selectedValue,
                  hint: MyText(
                    text: hint,
                    size: 12,
                    color: kSubText,
                    textAlign: TextAlign.start,
                    weight: FontWeight.w500,
                  ),
                  onChanged: onChanged,
                  iconStyleData: const IconStyleData(icon: SizedBox()),
                  isDense: true,
                  isExpanded: true,
                  customButton: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    height: 48,
                    decoration: BoxDecoration(
                      color: kWhite,
                      border: Border.all(color: kBorderColor3),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: AnimatedRow(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            if (prefixIcon != null) ...[
                              prefixIcon!,
                              SizedBox(
                                width: 8,
                              ), // Space between prefix and text
                            ],
                            MyText(
                              text:
                                  selectedValue == hint ? hint : selectedValue,
                              size: 14,
                              color: kFontText5,
                              weight: FontWeight.w600,
                            ),
                          ],
                        ),
                        CommonImageView(
                          imagePath: Assets.imagesArrowDown,
                          height: 24,
                        ),
                      ],
                    ),
                  ),
                  menuItemStyleData: const MenuItemStyleData(height: 35),
                  dropdownStyleData: DropdownStyleData(
                    elevation: 6,
                    maxHeight: 300,
                    offset: const Offset(0, -5),
                    decoration: BoxDecoration(
                      border: Border.all(color: kBorderColor),
                      borderRadius: BorderRadius.circular(10),
                      color: kWhite,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
