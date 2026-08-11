import 'package:firebase_auth/firebase_auth.dart';
import 'package:fire_fighter/constants/app_colors.dart';
import 'package:fire_fighter/constants/extensions.dart';
import 'package:fire_fighter/views/screens/auth/login.dart';
import 'package:fire_fighter/views/screens/bottom_nav/BottomBarNav.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BatterySafetyScreen extends StatelessWidget {
  const BatterySafetyScreen({super.key, this.onAccepted});

  final VoidCallback? onAccepted;

  void _continueToApp() {
    if (onAccepted != null) {
      onAccepted!();
      return;
    }

    final user = FirebaseAuth.instance.currentUser;
    Get.offAll(() => user == null ? const LoginScreen() : const BottomNavBar());
  }

  @override
  Widget build(BuildContext context) {
    final compact = context.screenHeight < 700;

    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: const Color(0xFF170809),
        body: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(context.rs(24, min: 18, max: 32)),
              child: Container(
                width: double.infinity,
                constraints: const BoxConstraints(maxWidth: 560),
                padding: EdgeInsets.all(
                  context.rs(compact ? 22 : 28, min: 20, max: 32),
                ),
                decoration: BoxDecoration(
                  color: kWhite,
                  borderRadius: BorderRadius.circular(
                    context.rs(24, min: 20, max: 28),
                  ),
                  border: Border.all(
                    color: kPrimaryColor.withOpacity(0.22),
                    width: 1.5,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.34),
                      blurRadius: 32,
                      offset: const Offset(0, 16),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      height: context.rs(72, min: 64, max: 82),
                      width: context.rs(72, min: 64, max: 82),
                      decoration: BoxDecoration(
                        color: kContainerYellowColor2,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: kYellowColor.withOpacity(0.7),
                          width: 2,
                        ),
                      ),
                      child: Icon(
                        Icons.warning_amber_rounded,
                        color: kPrimaryColor2,
                        size: context.rs(42, min: 38, max: 48),
                      ),
                    ),
                    SizedBox(height: context.rs(compact ? 16 : 20, min: 14)),
                    Text(
                      'CAUTION: Vehicle Battery Safety',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: kFontText,
                        fontFamily: 'Inter',
                        fontSize: context.rs(23, min: 21, max: 28),
                        fontWeight: FontWeight.w900,
                        height: 1.2,
                      ),
                    ),
                    SizedBox(height: context.rs(compact ? 14 : 18, min: 12)),
                    Text(
                      'Working with car batteries involves risks of electrical '
                      'shock, burns, and explosive gases. Always proceed with '
                      'extreme caution. Before performing any actions, consult '
                      'your vehicle\u2019s Owner\u2019s Manual for specific instructions, '
                      'safety warnings, and component locations.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: kFontText7,
                        fontFamily: 'Inter',
                        fontSize: context.rs(16, min: 15, max: 18),
                        fontWeight: FontWeight.w500,
                        height: 1.55,
                      ),
                    ),
                    SizedBox(height: context.rs(compact ? 22 : 28, min: 20)),
                    SizedBox(
                      width: double.infinity,
                      height: context.rs(52, min: 48, max: 56),
                      child: FilledButton(
                        key: const Key('battery-safety-ok-button'),
                        onPressed: _continueToApp,
                        style: FilledButton.styleFrom(
                          backgroundColor: kPrimaryColor,
                          foregroundColor: kWhite,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                          textStyle: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: context.rs(16, min: 15, max: 18),
                            fontWeight: FontWeight.w800,
                            letterSpacing: 0.4,
                          ),
                        ),
                        child: const Text('OK, I Understand'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
