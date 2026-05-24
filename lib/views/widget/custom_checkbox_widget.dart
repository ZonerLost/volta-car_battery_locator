import 'package:bounce/bounce.dart';
import 'package:fire_fighter/constants/extensions.dart';
import 'package:flutter/material.dart';
import 'package:fire_fighter/constants/app_colors.dart';

class CustomCheckbox extends StatefulWidget {
  final String? text;
  final String? text2;

  final Color? textcolor;
  final Function(bool) onChanged;
  final bool value;

  const CustomCheckbox({
    super.key,
    this.text,
    this.text2,

    required this.onChanged,
    this.textcolor,
    required this.value,
  });

  @override
  _CustomCheckboxState createState() => _CustomCheckboxState();
}

class _CustomCheckboxState extends State<CustomCheckbox> {
  late bool _isChecked;

  @override
  void initState() {
    super.initState();
    _isChecked = widget.value;
  }

  @override
  void didUpdateWidget(covariant CustomCheckbox oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.value != widget.value) {
      _isChecked = widget.value;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _isChecked = !_isChecked;
        });
        widget.onChanged(_isChecked);
      },
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.circular(4),
              color: _isChecked ? kSecondaryColor : kWhite,
              border: Border.all(
                color: _isChecked ? kSecondaryColor : kBorderColor,
                width: 1,
              ),
            ),
            child:
                _isChecked
                    ? const Icon(Icons.check, color: kWhite, size: 24)
                    : null,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: widget.text ?? '',
                    style: TextStyle(
                      color: widget.textcolor ?? kFontText7,
                      fontSize: context.rs(14, min: 12),
                      fontWeight: FontWeight.w600,
                      height: 1.35,
                    ),
                  ),
                  TextSpan(
                    text: widget.text2 ?? '',
                    style: TextStyle(
                      color: kFontText,
                      fontSize: context.rs(14, min: 12),
                      fontWeight: FontWeight.w700,
                      height: 1.35,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class CustomCheckbox2 extends StatefulWidget {
  final String? text;
  final String? text2;

  final Color? textcolor;
  final Function(bool) onChanged;

  const CustomCheckbox2({
    super.key,
    this.text,
    this.text2,

    required this.onChanged,
    this.textcolor,
  });

  @override
  State<CustomCheckbox2> createState() => _CustomCheckbox2State();
}

class _CustomCheckbox2State extends State<CustomCheckbox2> {
  bool _isChecked = false;

  @override
  Widget build(BuildContext context) {
    return Bounce(
      onTap: () {
        setState(() {
          _isChecked = !_isChecked;
        });
        widget.onChanged(_isChecked);
      },
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 14,
            height: 14,
            decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.circular(25),
              color: _isChecked ? kPrimaryColor : null,
              border: Border.all(
                color: _isChecked ? kPrimaryColor : kGreyColor4,
                width: 1,
              ),
            ),
            child:
                _isChecked
                    ? const Icon(Icons.check, color: kWhite, size: 10)
                    : null,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: widget.text ?? '',
                    style: TextStyle(
                      color: widget.textcolor ?? kBlack,
                      fontSize: context.rs(14, min: 12),
                      fontWeight: FontWeight.w500,
                      height: 1.35,
                    ),
                  ),
                  TextSpan(
                    text: widget.text2 ?? '',
                    style: TextStyle(
                      color: kBlack,
                      fontSize: context.rs(14, min: 12),
                      fontWeight: FontWeight.w700,
                      height: 1.35,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
