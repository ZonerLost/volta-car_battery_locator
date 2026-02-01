import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:fire_fighter/constants/app_colors.dart';
import 'package:fire_fighter/constants/app_sizes.dart';
import 'package:fire_fighter/views/widget/app_bar.dart';
import 'package:fire_fighter/views/widget/my_text_widget.dart';
import 'package:fire_fighter/views/widget/custom_animated_row.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  final List<Map<String, String>> notifications = [
    {'title': 'Your order has been shipped!', 'time': '2 minutes ago'},
    {'title': 'Payment received successfully.', 'time': '5 minutes ago'},
    {'title': 'New offer available today!', 'time': 'Yesterday'},
  ];

  int? _activeIndex; // Track the tapped notification for color change

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kWhite,
      body: SingleChildScrollView(
        padding: AppSizes.DEFAULT,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            HeaderAppBar(
              title: "Notifications",
              onTap: () => Get.back(),
              paddingLeft: 0,
              paddingRight: 0,
            ),
            const Gap(12),
            MyText(text: "Recent", size: 16, weight: FontWeight.w600),
            const Gap(12),

            // Notification list
            ListView.builder(
              padding: EdgeInsets.zero,
              itemCount: notifications.length,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                final item = notifications[index];
                return _notificationWidget(
                  index: index,
                  title: item['title'] ?? '',
                  time: item['time'] ?? '',
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _notificationWidget({
    required int index,
    required String title,
    required String time,
  }) {
    final bool isActive = _activeIndex == index;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Dismissible(
        key: Key('$title$index'),
        direction: DismissDirection.endToStart,
        background: Container(
          alignment: Alignment.centerRight,
          padding: const EdgeInsets.only(right: 20),
          decoration: BoxDecoration(
            color: kredColor,
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Icon(Icons.delete, color: Colors.white, size: 28),
        ),
        onDismissed: (direction) {
          setState(() {
            notifications.removeAt(index);
          });
        },
        child: GestureDetector(
          onTap: () {
            setState(() {
              _activeIndex = index;
            });
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            height: 67,
            decoration: BoxDecoration(
              color: kWhite,
              border: Border.all(
                color: isActive ? Colors.black12 : kBorderColor,
              ),
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  color: kBlack.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14.0),
              child: AnimatedRow(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        MyText(
                          text: title,
                          color: kBlack,
                          weight: FontWeight.w500,
                        ),
                        const SizedBox(height: 4),
                        MyText(
                          text: time,
                          size: 12,
                          color: kSubText,
                          weight: FontWeight.w500,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
