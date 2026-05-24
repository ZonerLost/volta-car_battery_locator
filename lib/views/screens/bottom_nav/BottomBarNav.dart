import 'package:fire_fighter/views/screens/report_module/report_issue.dart';
import 'package:fire_fighter/views/screens/search_module/recent_searches.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fire_fighter/constants/app_colors.dart';
import 'package:fire_fighter/constants/extensions.dart';
import 'package:fire_fighter/views/screens/home/home.dart';
import 'package:fire_fighter/views/screens/profile/profile_settings.dart';

class BottomNavBar extends StatefulWidget {
  const BottomNavBar({super.key});

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  int currentIndex = 0;

  final List<_NavItem> navItems = const [
    _NavItem(icon: Icons.home_rounded, label: 'Home'),
    _NavItem(icon: Icons.history_rounded, label: 'Searches'),
    _NavItem(icon: Icons.report_problem_rounded, label: 'Report'),
    _NavItem(icon: Icons.person_rounded, label: 'Profile'),
  ];

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
  }

  void handleNavigation(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kWhite,
      body: screens[currentIndex],
      bottomNavigationBar: SafeArea(
        top: false,
        child: Container(
          margin: EdgeInsets.fromLTRB(
            context.rs(18, min: 14, max: 24),
            context.rs(8, min: 6, max: 10),
            context.rs(18, min: 14, max: 24),
            context.rs(12, min: 8, max: 16),
          ),
          padding: EdgeInsets.all(context.rs(6, min: 5, max: 8)),
          decoration: BoxDecoration(
            color: kWhite,
            borderRadius: BorderRadius.circular(context.rs(24, max: 30)),
            border: Border.all(color: kBorderColor.withOpacity(0.9)),
            boxShadow: [
              BoxShadow(
                color: kFontText.withOpacity(0.12),
                blurRadius: 24,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Row(
            children: List.generate(navItems.length, (index) {
              final item = navItems[index];
              final selected = index == currentIndex;

              return Expanded(
                child: InkWell(
                  onTap: () => handleNavigation(index),
                  borderRadius: BorderRadius.circular(context.rs(18, max: 22)),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 220),
                    curve: Curves.easeOut,
                    height: context.rs(54, min: 50, max: 60),
                    padding: EdgeInsets.symmetric(
                      horizontal: context.rs(6, min: 4, max: 10),
                    ),
                    decoration: BoxDecoration(
                      color:
                          selected
                              ? kPrimaryColor.withOpacity(0.1)
                              : Colors.transparent,
                      borderRadius: BorderRadius.circular(
                        context.rs(18, max: 22),
                      ),
                    ),
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            item.icon,
                            size: context.rs(24, min: 22, max: 26),
                            color: selected ? kPrimaryColor : kFontText6,
                          ),
                          AnimatedSize(
                            duration: const Duration(milliseconds: 180),
                            curve: Curves.easeOut,
                            child:
                                selected
                                    ? Padding(
                                      padding: EdgeInsets.only(
                                        left: context.rs(7, min: 5, max: 8),
                                      ),
                                      child: Text(
                                        item.label,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          color: kPrimaryColor,
                                          fontSize: context.rs(
                                            13,
                                            min: 12,
                                            max: 14,
                                          ),
                                          fontWeight: FontWeight.w800,
                                        ),
                                      ),
                                    )
                                    : const SizedBox.shrink(),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}

class _NavItem {
  const _NavItem({required this.icon, required this.label});

  final IconData icon;
  final String label;
}
