// import 'package:bounce/bounce.dart';
// import 'package:fire_fighter/views/screens/auth/waiver_detail.dart';
// import 'package:flutter/material.dart';
// import 'package:gap/gap.dart';
// import 'package:get/get.dart';
// import 'package:pinput/pinput.dart';
// import 'package:fire_fighter/constants/app_colors.dart';
// import 'package:fire_fighter/generated/assets.dart';
// import 'package:fire_fighter/views/widget/common_image_view_widget.dart';
// import 'package:fire_fighter/views/widget/custom_animated_column.dart';
// import 'package:fire_fighter/views/widget/my_button_new.dart';
// import 'package:fire_fighter/views/widget/my_text_widget.dart';
//
// class OtpScreen extends StatefulWidget {
//   const OtpScreen({super.key});
//
//   @override
//   State<OtpScreen> createState() => _OtpScreenState();
// }
//
// class _OtpScreenState extends State<OtpScreen> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: AnimatedListView(
//         padding: EdgeInsets.all(0),
//         children: [
//           Stack(
//             children: [
//               CommonImageView(
//                 imagePath: Assets.imagesOptCar2,
//                 width: Get.width,
//               ),
//               Positioned(
//                 top: 40,
//                 left: 30,
//                 child: Bounce(
//                   onTap: () {
//                     Get.back();
//                   },
//                   child: CommonImageView(
//                     imagePath: Assets.imagesBackArrowWhite,
//                     height: 34,
//                   ),
//                 ),
//               ),
//             ],
//           ),
//           Container(
//             color: kbackground,
//             padding: const EdgeInsets.all(32),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               mainAxisAlignment: MainAxisAlignment.start,
//               children: [
//                 Row(
//                   children: [
//                     MyText(
//                       text: "Verify your email",
//                       size: 24,
//                       color: kFontText,
//                       weight: FontWeight.w700,
//                     ),
//                   ],
//                 ),
//                 MyText(
//                   text:
//                       "We’ve sent a verification link to your Phone +92*********. Please confirm to activate your account.",
//                   size: 20,
//                   paddingBottom: 32,
//                   color: kFontText7,
//                   weight: FontWeight.w600,
//                 ),
//
//                 Pinput(
//                   length: 6,
//                   defaultPinTheme: PinTheme(
//                     width: 56,
//                     height: 51,
//                     textStyle: TextStyle(
//                       fontSize: 22,
//                       fontWeight: FontWeight.w600,
//                       color: kBlack,
//                     ),
//                     decoration: BoxDecoration(
//                       border: Border.all(
//                         color: kSubText.withOpacity(0.3),
//                         width: 2,
//                       ),
//                       color: kWhite,
//                       borderRadius: BorderRadius.circular(8),
//                     ),
//                     margin: EdgeInsets.symmetric(horizontal: 4),
//                   ),
//                   focusedPinTheme: PinTheme(
//                     width: 56,
//                     height: 51,
//                     textStyle: TextStyle(
//                       fontSize: 20,
//                       fontWeight: FontWeight.w500,
//                       color: kBlack,
//                     ),
//                     decoration: BoxDecoration(
//                       color: kWhite,
//                       borderRadius: BorderRadius.circular(8),
//                       border: Border.all(color: kPrimaryColor, width: 2),
//                     ),
//                     margin: EdgeInsets.symmetric(horizontal: 4),
//                   ),
//                   submittedPinTheme: PinTheme(
//                     width: 56,
//                     height: 51,
//                     textStyle: TextStyle(
//                       fontSize: 20,
//                       fontWeight: FontWeight.w500,
//                       color: kBlack,
//                     ),
//                     decoration: BoxDecoration(
//                       color: kWhite,
//                       border: Border.all(color: kPrimaryColor, width: 2),
//                       borderRadius: BorderRadius.circular(8),
//                     ),
//                     margin: EdgeInsets.symmetric(horizontal: 4),
//                   ),
//                   errorPinTheme: PinTheme(
//                     width: 48,
//                     height: 56,
//                     textStyle: TextStyle(
//                       fontSize: 20,
//                       fontWeight: FontWeight.w500,
//
//                       color: kredColor,
//                     ),
//                     decoration: BoxDecoration(
//                       border: Border.all(color: kredColor, width: 2),
//                       color: kWhite,
//                       borderRadius: BorderRadius.circular(8),
//                     ),
//                     margin: EdgeInsets.symmetric(horizontal: 4),
//                   ),
//                 ),
//                 Gap(80),
//                 Row(
//                   spacing: 6,
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     MyText(
//                       text: "00:30 Sec",
//                       size: 14,
//                       color: kFontText,
//                       weight: FontWeight.w600,
//                       paddingTop: 16,
//                     ),
//                     MyText(
//                       text: "-",
//                       size: 14,
//                       color: kFontText,
//                       weight: FontWeight.w600,
//                       paddingTop: 16,
//                     ),
//
//                     MyText(
//                       text: "Resend Code",
//                       size: 14,
//                       color: kSecondaryColor,
//                       weight: FontWeight.w600,
//                       paddingTop: 16,
//                     ),
//                   ],
//                 ),
//                 Gap(80),
//
//                 MyButton(
//                   onTap: () {
//                     Get.to(() => WavierDetailScreen());
//                   },
//                   radius: 12,
//                   buttonText: "Verify",
//                   hasgrad: true,
//                 ),
//
//                 Gap(8),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     MyText(
//                       text: "Already have an account?",
//                       size: 16,
//                       color: kFontText7,
//                       weight: FontWeight.w500,
//                     ),
//                     Gap(6),
//                     Bounce(
//                       onTap: () {
//                         Get.back();
//                       },
//                       child: MyText(
//                         text: "Login",
//                         size: 16,
//                         color: kSecondaryColor,
//                         weight: FontWeight.w600,
//                       ),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
