import 'package:bounce/bounce.dart';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:fire_fighter/constants/app_colors.dart';
import 'package:fire_fighter/views/widget/common_image_view_widget.dart';
import 'package:fire_fighter/views/widget/custom_animated_row.dart';
import 'package:fire_fighter/views/widget/my_text_widget.dart';

class MyButton extends StatelessWidget {
  const MyButton({
    super.key,
    required this.onTap,
    required this.buttonText,
    this.height = 48,
    this.width,
    this.backgroundColor,
    this.fontColor,
    this.fontSize,
    this.outlineColor = kBorderColor2,
    this.radius = 10,
    this.svgIcon,
    this.haveSvg = false,
    this.choiceIcon,
    this.isleft = false,
    this.mhoriz = 0,
    this.hasicon = false,
    this.hasshadow = false,
    this.mBottom = 0,
    this.hasgrad = false,
    this.isactive = true,
    this.mTop = 0,
    this.fontWeight,
  });

  final String buttonText;
  final VoidCallback onTap;
  final double? height;
  final double? width;
  final double radius;
  final double? fontSize;
  final Color outlineColor;
  final bool hasicon, isleft, hasshadow, hasgrad, isactive;
  final Color? backgroundColor, fontColor;
  final String? svgIcon, choiceIcon;
  final bool haveSvg;
  final double mTop, mBottom, mhoriz;
  final FontWeight? fontWeight;

  @override
  Widget build(BuildContext context) {
    return Animate(
      effects: const [
        FadeEffect(duration: Duration(milliseconds: 1000)),
        MoveEffect(curve: Curves.fastLinearToSlowEaseIn),
      ],
      child: Bounce(
        duration: Duration(milliseconds: isactive ? 100 : 0),
        onTap: onTap,
        child: Container(
          margin: EdgeInsets.only(
            top: mTop,
            bottom: mBottom,
            left: mhoriz,
            right: mhoriz,
          ),
          height: height,
          width: width,
          decoration: BoxDecoration(
            color:
                isactive
                    ? backgroundColor ?? kPrimaryColor
                    : backgroundColor ??
                        const Color(0xff0E1A34).withOpacity(0.35),

            borderRadius: BorderRadius.circular(radius),
            border: Border.all(color: outlineColor),
          ),
          child: Material(
            color: Colors.transparent,
            child: AnimatedRow(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (hasicon)
                  Padding(
                    padding:
                        isleft
                            ? const EdgeInsets.only(left: 20.0)
                            : const EdgeInsets.only(right: 0),
                    child: CommonImageView(imagePath: choiceIcon, height: 20),
                  ),
                MyText(
                  paddingLeft: hasicon ? 10 : 0,
                  text: buttonText,
                  size: fontSize ?? 16,

                  letterSpacing: 0.5,
                  color: fontColor ?? kWhite,
                  weight: fontWeight ?? FontWeight.w800,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ignore: must_be_immutable
class MyBorderButton extends StatelessWidget {
  MyBorderButton({
    super.key,
    required this.onTap,
    required this.buttonText,
    this.height = 48,
    this.width,
    this.backgroundColor,
    this.fontColor,
    this.fontSize = 16,
    this.outlineColor,
    this.radius = 7,
    this.haveSvg = false,
    this.isleft = false,
    this.mhoriz = 0,
    this.child,
    this.hasicon = false,
    this.hasshadow = false,
    this.mBottom = 0,
    this.hasgrad = false,
    this.isactive = true,
    this.mTop = 0,
    this.fontWeight = FontWeight.w400,
    this.svgIcon,
    this.choiceIcon,
    this.rightpadding,
  });

  final String buttonText;
  final VoidCallback onTap;
  final double? height;
  final double? width;
  final String? svgIcon, choiceIcon;
  final double? rightpadding;
  final double radius;
  final double fontSize;
  final Color? outlineColor;
  final bool hasicon, isleft, hasshadow, hasgrad, isactive;
  final Color? backgroundColor, fontColor;
  final bool haveSvg;
  final double mTop, mBottom, mhoriz;
  final FontWeight fontWeight;

  FontWeight? weight;
  Widget? child;
  Color? borderColor;

  @override
  Widget build(BuildContext context) {
    return Animate(
      effects: const [
        FadeEffect(duration: Duration(milliseconds: 1000)),
        MoveEffect(curve: Curves.fastLinearToSlowEaseIn),
      ],
      child: Bounce(
        duration: Duration(milliseconds: isactive ? 100 : 0),
        onTap: onTap,
        child: Container(
          margin: EdgeInsets.only(
            top: mTop,
            bottom: mBottom,
            left: mhoriz,
            right: mhoriz,
          ),
          height: height,
          width: width,
          decoration: BoxDecoration(
            color:
                isactive
                    ? backgroundColor ?? kPrimaryColor
                    : backgroundColor ??
                        const Color(0xff0E1A34).withOpacity(0.35),
            border: Border.all(color: outlineColor ?? kBorderColor3),
            borderRadius: BorderRadius.circular(radius),
          ),
          child: Material(
            color: Colors.transparent,
            child: AnimatedRow(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (hasicon)
                  Padding(
                    padding:
                        isleft
                            ? const EdgeInsets.only(left: 0)
                            : const EdgeInsets.only(right: 0),
                    child: CommonImageView(imagePath: choiceIcon, height: 34),
                  ),
                MyText(
                  paddingLeft: hasicon ? 0 : 0,
                  text: buttonText,
                  size: 16,
                  paddingRight: rightpadding ?? 0,
                  letterSpacing: 0.5,
                  color: fontColor ?? kWhite,
                  weight: fontWeight,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
