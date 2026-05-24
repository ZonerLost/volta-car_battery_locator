import 'package:bounce/bounce.dart';
import 'package:fire_fighter/constants/app_colors.dart';
import 'package:fire_fighter/constants/extensions.dart';
import 'package:fire_fighter/controller/locate_battery_controller.dart';
import 'package:fire_fighter/controller/recent_searches_controller.dart';
import 'package:fire_fighter/generated/assets.dart';
import 'package:fire_fighter/model/car_details.dart';
import 'package:fire_fighter/views/screens/dialogs/dialogs.dart';
import 'package:fire_fighter/views/screens/report_module/general_feedback.dart';
import 'package:fire_fighter/views/screens/report_module/wrong_location.dart';
import 'package:fire_fighter/views/widget/common_image_view_widget.dart';
import 'package:fire_fighter/views/widget/my_button_new.dart';
import 'package:fire_fighter/views/widget/my_text_widget.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

class LocateBatteryScreen extends StatefulWidget {
  final String carId;

  const LocateBatteryScreen({super.key, required this.carId});

  @override
  State<LocateBatteryScreen> createState() => _LocateBatteryScreenState();
}

class _LocateBatteryScreenState extends State<LocateBatteryScreen> {
  late final LocateBatteryController c;
  bool _saved = false;

  @override
  void initState() {
    super.initState();
    c = Get.put(LocateBatteryController(), tag: widget.carId);
    c.fetchCarById(widget.carId);
  }

  @override
  void dispose() {
    if (Get.isRegistered<LocateBatteryController>(tag: widget.carId)) {
      Get.delete<LocateBatteryController>(tag: widget.carId);
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kbackground,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.fromLTRB(
            context.rs(22, min: 18, max: 28),
            context.rs(10, min: 8, max: 14),
            context.rs(22, min: 18, max: 28),
            context.rs(14, min: 10, max: 18),
          ),
          child: Column(
            children: [
              Row(
                children: [
                  Bounce(
                    onTap: () => Get.back(),
                    child: Container(
                      height: context.rs(42, min: 38, max: 46),
                      width: context.rs(42, min: 38, max: 46),
                      decoration: BoxDecoration(
                        color: kWhite,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: kBorderColor),
                        boxShadow: [
                          BoxShadow(
                            color: kFontText.withOpacity(0.08),
                            blurRadius: 16,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: Center(
                        child: CommonImageView(
                          imagePath: Assets.imagesBackArrowAppbar,
                          height: context.rs(23, min: 21, max: 25),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Gap(context.rs(12, min: 8, max: 14)),
              Expanded(
                child: Obx(() {
                  if (c.isLoading.value) {
                    return const Center(
                      child: CircularProgressIndicator(color: kPrimaryColor),
                    );
                  }

                  if (c.car.value == null) {
                    return Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                  children: [
                    MyText(
                      text:
                          c.error.value.isNotEmpty
                              ? c.error.value
                              : "Car data not found",
                      size: 18,
                      color: kFontText,
                      weight: FontWeight.w700,
                    ),
                    Gap(12),
                    MyButton(
                      onTap: () => c.fetchCarById(widget.carId),
                      radius: 12,
                      buttonText: "Retry",
                      hasgrad: true,
                    ),
                  ],
                      ),
                    );
                  }

                  final CarDetails car = c.car.value!;
                  final batteryInfo = _BatteryInfo.fromCar(car);

                  if (!_saved) {
                    _saved = true;

                    final rc =
                        Get.isRegistered<RecentSearchesController>()
                            ? Get.find<RecentSearchesController>()
                            : Get.put(RecentSearchesController());

                    rc.addRecentFromDetails(car);
                  }

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      MyText(
                        text: "${car.make} ${car.model} (${car.yearLabel})",
                        size: 22,
                        maxLines: 2,
                        textOverflow: TextOverflow.ellipsis,
                        color: kFontText,
                        weight: FontWeight.w800,
                      ),
                      MyText(
                        text:
                            "Battery location identified below. Follow the blinking marker.",
                        size: 14,
                        paddingTop: 4,
                        maxLines: 2,
                        textOverflow: TextOverflow.ellipsis,
                        color: kFontText7,
                        weight: FontWeight.w600,
                      ),
                      if (batteryInfo.hasLocation) ...[
                        Gap(context.rs(10, min: 8, max: 12)),
                        _BatteryInfoCard(
                          title: "Battery Location",
                          body: batteryInfo.locationText,
                          bodyMaxLines: batteryInfo.hasAccessNotes ? 3 : 4,
                          backgroundColor: const Color(0x3387C1FF),
                          borderColor: const Color(0x6687C1FF),
                        ),
                      ],
                      if (batteryInfo.hasAccessNotes) ...[
                        Gap(context.rs(8, min: 6, max: 10)),
                        _BatteryInfoCard(
                          title: "Access Information",
                          body: batteryInfo.accessNotes,
                          bodyMaxLines: 3,
                          backgroundColor:
                              kSecondaryGreenColor.withOpacity(0.12),
                          borderColor: kBorderColor3,
                        ),
                      ],
                      Gap(context.rs(12, min: 8, max: 14)),
                      Expanded(
                        child: Container(
                          width: double.infinity,
                          padding: EdgeInsets.symmetric(
                            horizontal: context.rs(6, min: 2, max: 10),
                            vertical: context.rs(6, min: 4, max: 10),
                          ),
                          decoration: BoxDecoration(
                            color: kWhite,
                            borderRadius: BorderRadius.circular(
                              context.rs(18, min: 14, max: 22),
                            ),
                            border: Border.all(color: kBorderColor),
                            boxShadow: [
                              BoxShadow(
                                color: kFontText.withOpacity(0.07),
                                blurRadius: 22,
                                offset: const Offset(0, 10),
                              ),
                            ],
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(
                              context.rs(14, min: 12, max: 18),
                            ),
                            child: BatteryDiagramWithMarker(car: car),
                          ),
                        ),
                      ),
                      Gap(context.rs(10, min: 8, max: 12)),
                      MyButton(
                        onTap: () {
                          DialogHelper.FeedbackSentDialog(context);
                        },
                        backgroundColor: kSecondaryGreenColor.withOpacity(0.2),
                        radius: 16,
                        hasicon: true,
                        choiceIcon: Assets.imagesThumbsUp,
                        buttonText: "Correct",
                        fontColor: kSecondaryGreenColor,
                        hasgrad: true,
                      ),
                      Gap(context.rs(8, min: 6, max: 10)),
                      MyButton(
                        onTap: () {
                          _showIssueReportSheet(context, car, batteryInfo);
                        },
                        backgroundColor: kPrimaryColor.withOpacity(0.2),
                        radius: 16,
                        hasicon: true,
                        choiceIcon: Assets.imagesThumbsDown,
                        buttonText: "Issue Report",
                        fontColor: kPrimaryColor,
                        hasgrad: true,
                      ),
                    ],
                  );
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showIssueReportSheet(
    BuildContext context,
    CarDetails car,
    _BatteryInfo batteryInfo,
  ) {
    Get.bottomSheet(
      Container(
        padding: EdgeInsets.fromLTRB(
          context.rs(22, min: 18, max: 26),
          context.rs(16, min: 14, max: 20),
          context.rs(22, min: 18, max: 26),
          context.rs(22, min: 18, max: 26),
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(context.rs(26, min: 22, max: 30)),
          ),
        ),
        child: SafeArea(
          top: false,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 44,
                  height: 4,
                  decoration: BoxDecoration(
                    color: kBorderColor3,
                    borderRadius: BorderRadius.circular(99),
                  ),
                ),
              ),
              Gap(18),
              MyText(
                text: "Report Issue",
                size: 23,
                color: kFontText,
                weight: FontWeight.w800,
              ),
              Gap(6),
              MyText(
                text: "What issue did you run into?",
                size: 15,
                color: kFontText7,
                weight: FontWeight.w500,
              ),
              Gap(18),
              _IssueReportOption(
                title: "Can't find battery",
                onTap: () {
                  Get.back();
                  Get.to(
                    () => GeneralFeedbackScreen(
                      initialCategory: "Can't find battery",
                    ),
                  );
                },
              ),
              _IssueReportOption(
                title: "Found battery in another location",
                onTap: () {
                  Get.back();
                  Get.to(
                    () => WrongLocationScreen(
                      make: car.make,
                      model: car.model,
                      year: car.yearLabel,
                      reportedArea: batteryInfo.locationText,
                    ),
                  );
                },
              ),
              _IssueReportOption(
                title: "Other",
                onTap: () {
                  Get.back();
                  Get.to(() => GeneralFeedbackScreen(initialCategory: "Other"));
                },
              ),
            ],
          ),
        ),
      ),
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
    );
  }
}

class _IssueReportOption extends StatelessWidget {
  final String title;
  final VoidCallback onTap;

  const _IssueReportOption({required this.title, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Bounce(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        margin: EdgeInsets.only(bottom: context.rs(12, min: 10, max: 14)),
        padding: EdgeInsets.symmetric(
          horizontal: context.rs(14, min: 12, max: 16),
          vertical: context.rs(16, min: 14, max: 18),
        ),
        decoration: BoxDecoration(
          color: kGreyContainerGreyColor2,
          borderRadius: BorderRadius.circular(context.rs(14, min: 12, max: 16)),
          border: Border.all(color: kBorderColor),
        ),
        child: Row(
          children: [
            Expanded(
              child: MyText(
                text: title,
                size: 16,
                color: kFontText,
                weight: FontWeight.w700,
              ),
            ),
            Icon(Icons.chevron_right, color: kFontText7, size: 24),
          ],
        ),
      ),
    );
  }
}

class BatteryDiagramWithMarker extends StatelessWidget {
  final CarDetails car;

  const BatteryDiagramWithMarker({super.key, required this.car});

  @override
  Widget build(BuildContext context) {
    final marker = car.marker;
    final hasMarker = marker != null && car.markerStatus == "set";
    final batteryCount = _BatteryInfo.fromCar(car).batteryCount;

    return AspectRatio(
      aspectRatio: 0.62,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final width = constraints.maxWidth;
          final height = constraints.maxHeight;

          final left = hasMarker ? (marker.xPct / 100) * width : 0.0;
          final top = hasMarker ? (marker.yPct / 100) * height : 0.0;

          return Stack(
            children: [
              Positioned.fill(
                child: Image.asset(
                  "assets/images/car1.jpeg",
                  fit: BoxFit.contain,
                ),
              ),
              if (hasMarker)
                Positioned(
                  left: left,
                  top: top,
                  child: Transform.translate(
                    offset: Offset(
                      batteryCount > 1
                          ? -_BlinkingBatteryMarker.markerWidth(batteryCount) /
                              2
                          : -18,
                      -18,
                    ),
                    child: _BlinkingBatteryMarker(count: batteryCount),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}

class _BatteryInfoCard extends StatelessWidget {
  final String title;
  final String body;
  final Color backgroundColor;
  final Color borderColor;
  final int bodyMaxLines;

  const _BatteryInfoCard({
    required this.title,
    required this.body,
    required this.backgroundColor,
    required this.borderColor,
    this.bodyMaxLines = 4,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(context.rs(12, min: 10, max: 14)),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(context.rs(16, min: 14, max: 18)),
        border: Border.all(color: borderColor),
        boxShadow: [
          BoxShadow(
            color: kFontText.withOpacity(0.04),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          MyText(
            text: title,
            size: 16,
            color: kFontText,
            weight: FontWeight.w800,
          ),
          Gap(context.rs(5, min: 4, max: 6)),
          MyText(
            text: body,
            size: 13,
            maxLines: bodyMaxLines,
            textOverflow: TextOverflow.ellipsis,
            color: kFontText7,
            weight: FontWeight.w600,
          ),
        ],
      ),
    );
  }
}

class _BatteryInfo {
  final String locationText;
  final String accessNotes;
  final int batteryCount;

  const _BatteryInfo({
    required this.locationText,
    required this.accessNotes,
    required this.batteryCount,
  });

  bool get hasLocation => locationText.trim().isNotEmpty;
  bool get hasAccessNotes => accessNotes.trim().isNotEmpty;

  factory _BatteryInfo.fromCar(CarDetails car) {
    final location = car.location.trim();
    final description = car.description.trim();
    final count = _batteryCountFrom(car);

    if (location.isNotEmpty) {
      final label = _formatLocationLines(_withBatteryCount(location, count));
      final splitDescription = _splitDescription(description);
      final notes =
          splitDescription.hasAccessNotes
              ? splitDescription.accessNotes
              : description == location
              ? ""
              : description;

      return _BatteryInfo(
        locationText: label,
        accessNotes: notes,
        batteryCount: count,
      );
    }

    final split = _splitDescription(description);

    return _BatteryInfo(
      locationText: _formatLocationLines(split.locationText),
      accessNotes: split.accessNotes,
      batteryCount: count,
    );
  }

  static int _batteryCountFrom(CarDetails car) {
    final source = "${car.location} ${car.description}";
    final match = RegExp(
      r'\b([1-3])\s*batter(?:y|ies)\b',
      caseSensitive: false,
    ).firstMatch(source);

    final textCount = int.tryParse(match?.group(1) ?? "") ?? 1;
    final fieldCount = car.batteryCount > 0 ? car.batteryCount : 1;

    return fieldCount > textCount
        ? fieldCount.clamp(1, 3)
        : textCount.clamp(1, 3);
  }

  static String _withBatteryCount(String text, int count) {
    if (count <= 1) return text;

    final hasCount = RegExp(
      r'\b[1-3]\s*batter(?:y|ies)\b',
      caseSensitive: false,
    ).hasMatch(text);

    return hasCount ? text : "$count Batteries - $text";
  }

  static String _formatLocationLines(String text) {
    final normalized = text.trim();
    if (normalized.isEmpty) return "";

    final match = RegExp(
      r'^([1-3]\s*batter(?:y|ies)\s*-\s*)(.+)$',
      caseSensitive: false,
    ).firstMatch(normalized);

    if (match == null) {
      return normalized.replaceAll(RegExp(r'\s*&\s*'), '\n');
    }

    final prefix = match.group(1)!.trim();
    final body = match.group(2)!.replaceAll(RegExp(r'\s*&\s*'), '\n').trim();

    return "$prefix\n$body";
  }

  static _BatteryInfoSplit _splitDescription(String description) {
    if (description.isEmpty) {
      return const _BatteryInfoSplit(locationText: "", accessNotes: "");
    }

    final parts =
        description
            .split("/")
            .map((part) => part.trim())
            .where((part) => part.isNotEmpty)
            .toList();

    final accessIndex = parts.indexWhere(
      (part) => RegExp(
        r'\b(remove|access|lift|open|pull|unscrew|release|take off)\b',
        caseSensitive: false,
      ).hasMatch(part),
    );

    if (accessIndex <= 0) {
      return _BatteryInfoSplit(locationText: description, accessNotes: "");
    }

    return _BatteryInfoSplit(
      locationText: parts.take(accessIndex).join(" / "),
      accessNotes: parts.skip(accessIndex).join(" / "),
    );
  }
}

class _BatteryInfoSplit {
  final String locationText;
  final String accessNotes;

  const _BatteryInfoSplit({
    required this.locationText,
    required this.accessNotes,
  });

  bool get hasAccessNotes => accessNotes.trim().isNotEmpty;
}

class _BlinkingBatteryMarker extends StatefulWidget {
  final int count;

  const _BlinkingBatteryMarker({required this.count});

  static double markerWidth(int count) {
    return (count * 36) + ((count - 1) * 6);
  }

  @override
  State<_BlinkingBatteryMarker> createState() => _BlinkingBatteryMarkerState();
}

class _BlinkingBatteryMarkerState extends State<_BlinkingBatteryMarker>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: Tween<double>(begin: 0.35, end: 1).animate(_controller),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: List.generate(widget.count, (index) {
          return Padding(
            padding: EdgeInsets.only(left: index == 0 ? 0 : 6),
            child: Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: Colors.red,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.red.withOpacity(0.38),
                    blurRadius: 14,
                    spreadRadius: 4,
                  ),
                ],
              ),
              child: const Icon(
                Icons.battery_alert,
                color: Colors.white,
                size: 18,
              ),
            ),
          );
        }),
      ),
    );
  }
}
