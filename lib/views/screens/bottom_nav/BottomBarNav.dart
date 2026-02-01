import 'package:fire_fighter/views/screens/report_module/report_issue.dart';
import 'package:fire_fighter/views/screens/search_module/recent_searches.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fire_fighter/constants/app_colors.dart';
import 'package:fire_fighter/generated/assets.dart';
import 'package:fire_fighter/views/screens/home/home.dart';
import 'package:fire_fighter/views/screens/profile/profile_settings.dart';

class BottomNavBar extends StatefulWidget {
  const BottomNavBar({super.key});

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  int currentIndex = 0;

  late List<Map<String, dynamic>> items;

  final List<Widget> screens = [
    const HomeScreen(),

    const RecentSearchesScreen(),
    const ReportIssueScreen(),
    const ProfileSettingsScreen(),
  ];

  @override
  void initState() {
    super.initState();
    if (Get.arguments != null && Get.arguments is int) {
      currentIndex = Get.arguments as int;
    }
    updateItems();
  }

  void updateItems() {
    items = [
      {
        'image':
            currentIndex == 0
                ? Assets.imagesHomeActive
                : Assets.imagesHomeInactive,
      },

      {
        'image':
            currentIndex == 1
                ? Assets.imagesSearchesActive
                : Assets.imagesSearchInactive,
      },
      {
        'image':
            currentIndex == 2
                ? Assets.imagesRepportActive
                : Assets.imagesReportInactive,
      },
      {
        'image':
            currentIndex == 3
                ? Assets.imagesSettingActive
                : Assets.imagesSettingInactive,
      },
    ];
  }

  void handleNavigation(int index) {
    setState(() {
      currentIndex = index;
      updateItems();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kWhite,
      body: screens[currentIndex],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 15,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: BottomNavigationBar(
          backgroundColor: kWhite,
          type: BottomNavigationBarType.fixed,
          currentIndex: currentIndex,
          onTap: handleNavigation,
          showSelectedLabels: false,
          showUnselectedLabels: false,
          items: List.generate(items.length, (index) {
            return BottomNavigationBarItem(
              icon: Image.asset(items[index]['image']!, height: 60),
              label: '',
            );
          }),
        ),
      ),
    );
  }
}
