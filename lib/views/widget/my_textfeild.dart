import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:fire_fighter/constants/app_colors.dart';
import 'package:fire_fighter/views/widget/custom_animated_column.dart';
import 'package:fire_fighter/views/widget/my_text_widget.dart';

class MyTextField extends StatefulWidget {
  String? label, hint;
  TextEditingController? controller;
  ValueChanged<String>? onChanged;

  /// keep existing param
  bool isObSecure;

  /// ✅ NEW: alias param (so your signup can use obscureText:)
  final bool? obscureText;

  bool? haveLabel, isReadOnly;
  double? marginBottom, radius;
  int? maxLines;
  double? labelSize, hintsize;
  FocusNode? focusNode;
  Color? filledColor, focusedFillColor, bordercolor, hintColor, labelColor;
  Widget? prefix, suffix;
  FontWeight? labelWeight, hintWeight;
  final VoidCallback? onTap;
  final TextInputType? keyboardType;
  final double? height;
  final double? Width;
  final FormFieldValidator<String>? validator;
  Color? backgroundColor;
  Color? borderColor;
  String? errorText;

  MyTextField({
    super.key,
    this.controller,
    this.hint,
    this.label,
    this.onChanged,

    this.isObSecure = false, // existing

    /// ✅ NEW
    this.obscureText,

    this.marginBottom = 16.0,
    this.maxLines = 1,
    this.filledColor,
    this.focusedFillColor,
    this.hintColor,
    this.labelColor,
    this.haveLabel = true,
    this.labelSize,
    this.hintsize,
    this.prefix,
    this.suffix,
    this.labelWeight,
    this.hintWeight,
    this.keyboardType,
    this.isReadOnly,
    this.onTap,
    this.bordercolor,
    this.focusNode,
    this.radius,
    this.height = 48,
    this.Width,
    this.validator,
    this.backgroundColor,
    this.borderColor,
    this.errorText,
  });

  @override
  State<MyTextField> createState() => _MyTextFieldState();
}

class _MyTextFieldState extends State<MyTextField> {
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    widget.focusNode?.addListener(_onFocusChange);
  }

  void _onFocusChange() {
    setState(() {
      _isFocused = widget.focusNode?.hasFocus ?? false;
    });
  }

  @override
  void dispose() {
    widget.focusNode?.removeListener(_onFocusChange);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // ✅ Decide secure value:
    // if obscureText passed, use it, otherwise use isObSecure
    final bool secure = widget.obscureText ?? widget.isObSecure;

    return Animate(
      effects: const [
        FadeEffect(duration: Duration(milliseconds: 500)),
        MoveEffect(
          curve: Curves.ease,
          duration: Duration(milliseconds: 500),
          transformHitTests: false, // ✅ FIX: was F from wrong import
        ),
      ],
      child: Padding(
        padding: EdgeInsets.only(bottom: widget.marginBottom ?? 0),
        child: AnimatedColumn(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (widget.label != null && _isFocused)
              MyText(
                text: widget.label ?? '',
                size: widget.labelSize ?? 10,
                paddingBottom: 8,
                color: kPrimaryColor,
                weight: widget.labelWeight ?? FontWeight.w500,
              ),
            Container(
              width: widget.Width ?? double.infinity,
              decoration: BoxDecoration(
                color: kWhite,
                border: Border.all(
                  color: widget.borderColor ?? kBorderColor3,
                  width: 1,
                ),
                borderRadius: BorderRadius.circular(widget.radius ?? 12),
              ),
              child: TextFormField(
                validator: widget.validator,
                focusNode: widget.focusNode,
                onTap: widget.onTap,
                textAlignVertical: TextAlignVertical.center,
                keyboardType: widget.keyboardType,
                cursorColor: kPrimaryColor,
                maxLines: widget.maxLines ?? 1,
                readOnly: widget.isReadOnly ?? false,
                controller: widget.controller,
                onChanged: widget.onChanged,
                textInputAction: TextInputAction.done,
                obscureText: secure, // ✅ FIX
                obscuringCharacter: '*',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w300,
                  decoration: TextDecoration.none,
                  color: kBlack,
                ),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: _isFocused
                      ? widget.focusedFillColor ?? kTransperentColor
                      : widget.filledColor ?? kTransperentColor,
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(widget.radius ?? 12),
                    borderSide: const BorderSide(color: kBorderColor, width: 1),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(widget.radius ?? 12),
                    borderSide: const BorderSide(
                      color: kBorderColor,
                      width: 1,
                    ),
                  ),
                  prefixIcon: widget.prefix,
                  prefixIconConstraints: const BoxConstraints.tightFor(),
                  suffixIconConstraints: const BoxConstraints.tightFor(),
                  suffixIcon: Padding(
                    padding: const EdgeInsets.only(left: 16, right: 16),
                    child: widget.suffix,
                  ),
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: (widget.maxLines ?? 1) > 1 ? 15 : 0,
                  ),
                  hintText: widget.hint,
                  hintStyle: TextStyle(
                    fontSize: widget.hintsize ?? 16,
                    letterSpacing: 0.5,
                    color: widget.hintColor ?? kSubText,
                    fontWeight: widget.hintWeight ?? FontWeight.w400,
                  ),
                  errorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(widget.radius ?? 8),
                    borderSide: const BorderSide(width: 1, color: Colors.red),
                  ),
                  focusedErrorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(widget.radius ?? 8),
                    borderSide: const BorderSide(width: 1, color: Colors.red),
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
