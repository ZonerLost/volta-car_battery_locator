import 'package:flutter/material.dart';

import '../../views/screens/auth/forgot_password.dart';
import '../../views/screens/auth/login.dart';
import '../../views/screens/auth/reset_password.dart';
import '../../views/screens/auth/signup.dart';
import '../../views/screens/auth/waiver_detail.dart';
import '../../views/screens/bottom_nav/BottomBarNav.dart';
import '../../views/screens/home/home.dart';
import '../../views/screens/home/locate_battery.dart';
import '../../views/screens/launch/splash/splash.dart';
import '../../views/screens/notifications/notifications.dart';
import '../../views/screens/profile/edit_profile.dart';
import '../../views/screens/profile/help_center.dart';
import '../../views/screens/profile/privacy.dart';
import '../../views/screens/profile/profile_settings.dart';
import '../../views/screens/report_module/general_feedback.dart';
import '../../views/screens/report_module/missing_car.dart';
import '../../views/screens/report_module/report_issue.dart';
import '../../views/screens/report_module/wrong_location.dart';
import '../../views/screens/search_module/recent_searches.dart';


class AppRoutes {
  // Route Names
  static const String splash = '/';
  static const String login = '/login';
  static const String signup = '/signup';
  static const String otp = '/otp';
  static const String forgotPassword = '/forgot-password';
  static const String resetPassword = '/reset-password';
  static const String waiverDetail = '/waiver-detail';

  static const String bottomNav = '/bottom-nav';
  static const String home = '/home';
  static const String locateBattery = '/locate-battery';

  static const String notifications = '/notifications';

  static const String profileSettings = '/profile-settings';
  static const String editProfile = '/edit-profile';
  static const String helpCenter = '/help-center';
  static const String privacy = '/privacy';

  static const String reportIssue = '/report-issue';
  static const String generalFeedback = '/general-feedback';
  static const String missingCar = '/missing-car';
  static const String wrongLocation = '/wrong-location';

  static const String recentSearches = '/recent-searches';

  // Central Route Generator
  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
    // LAUNCH
      case splash:
        return MaterialPageRoute(builder: (_) => const SplashScreen());

    // AUTH
      case login:
        return MaterialPageRoute(builder: (_) => const LoginScreen());
      case signup:
        return MaterialPageRoute(builder: (_) => const SignUpScreen());
      // case otp:
      //   return MaterialPageRoute(builder: (_) => const OTPScreen());
      case forgotPassword:
        return MaterialPageRoute(builder: (_) => const ForgotPasswordScreen());
      case resetPassword:
        return MaterialPageRoute(builder: (_) => const ResetPasswordScreen());
      case waiverDetail:
        return MaterialPageRoute(builder: (_) => const WavierDetailScreen());

    // NAV / HOME
      case bottomNav:
        return MaterialPageRoute(builder: (_) => const BottomNavBar());
      case home:
        return MaterialPageRoute(builder: (_) => const HomeScreen());
      case locateBattery:
        return MaterialPageRoute(builder: (_) => const LocateBatteryScreen(carId: '',));

    // NOTIFICATIONS
      case notifications:
        return MaterialPageRoute(builder: (_) => const NotificationScreen());

    // PROFILE
      case profileSettings:
        return MaterialPageRoute(builder: (_) => const ProfileSettingsScreen());
      case editProfile:
        return MaterialPageRoute(builder: (_) => const EditProfileScreen());
      case helpCenter:
        return MaterialPageRoute(builder: (_) => const HelpCenterScreen());
      case privacy:
        return MaterialPageRoute(builder: (_) => const PrivacyPolicyScreen());

    // REPORT
      case reportIssue:
        return MaterialPageRoute(builder: (_) => const ReportIssueScreen());
      case generalFeedback:
        return MaterialPageRoute(builder: (_) => const GeneralFeedbackScreen());
      case missingCar:
        return MaterialPageRoute(builder: (_) => const MissingCarScreen());
      case wrongLocation:
        return MaterialPageRoute(builder: (_) => const WrongLocationScreen());

    // SEARCH
      case recentSearches:
        return MaterialPageRoute(builder: (_) => const RecentSearchesScreen());

      default:
        return MaterialPageRoute(
          builder: (_) => const Scaffold(
            body: Center(child: Text('Route not found')),
          ),
        );
    }
  }
}
