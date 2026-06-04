// ignore_for_file: prefer_const_constructors
import 'package:bounce/bounce.dart';
import 'package:fire_fighter/views/widget/my_text_widget.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:fire_fighter/constants/app_colors.dart';
import 'package:fire_fighter/generated/assets.dart';
import 'package:fire_fighter/views/widget/common_image_view_widget.dart';
import 'package:fire_fighter/views/widget/custom_animated_column.dart';
import 'package:get/get.dart';

import '../../../controller/recent_searches_controller.dart';

class RecentSearchesScreen extends StatefulWidget {
  const RecentSearchesScreen({super.key});

  @override
  State<RecentSearchesScreen> createState() => _RecentSearchesScreenState();
}

class _RecentSearchesScreenState extends State<RecentSearchesScreen> {
  final RecentSearchesController rc = Get.put(RecentSearchesController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedListView(
        padding: EdgeInsets.all(24),
        children: [
          Gap(100),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              MyText(
                text: "Recent Searches",
                size: 24,
                color: kFontText,
                weight: FontWeight.w700,
              ),
              MyText(
                text: "Quickly access cars you looked up before.",
                size: 16,
                color: kFontText7,
                weight: FontWeight.w500,
              ),
              Gap(20),

              Obx(() {
                if (rc.isLoading.value) {
                  return Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: Center(child: CircularProgressIndicator()),
                  );
                }

                if (rc.searches.isEmpty) {
                  return SizedBox(
                    height: MediaQuery.sizeOf(context).height * 0.45,
                    child: Center(
                      child: MyText(
                        text: "No recent searches yet.",
                        size: 15,
                        color: kFontText7,
                        weight: FontWeight.w600,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  );
                }

                return ListView.builder(
                  shrinkWrap: true,
                  padding: EdgeInsets.all(0),
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: rc.searches.length,
                  itemBuilder: (context, index) {
                    final s = rc.searches[index];

                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 6),
                      child: Bounce(
                        onTap: () {
                          rc.openRecent(s);
                        },
                        child: Container(
                          padding: EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: kWhite,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: kBorderColor),
                          ),
                          child: Row(
                            children: [
                              // If you want diagram preview instead of asset icon:
                              // Use Image.network(s.diagramUrl) with fallback
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child:
                                    s.thumbnailUrl.isNotEmpty
                                        ? Image.network(
                                          s.thumbnailUrl,
                                          height: 40,
                                          width: 40,
                                          fit: BoxFit.cover,
                                          errorBuilder:
                                              (_, __, ___) => CommonImageView(
                                                imagePath:
                                                    Assets.imagesCarRecent,
                                                height: 40,
                                              ),
                                        )
                                        : CommonImageView(
                                          imagePath: Assets.imagesCarRecent,
                                          height: 40,
                                        ),
                              ),

                              Gap(12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    MyText(
                                      text:
                                          "${s.make} ${s.model} (${s.yearLabel})",

                                      size: 16,
                                      color: kFontText,
                                      weight: FontWeight.w600,
                                    ),
                                    MyText(
                                      text:
                                          s.location.isEmpty
                                              ? "Battery location saved"
                                              : s.location,
                                      size: 14,
                                      color: kFontText7,
                                      weight: FontWeight.w500,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                );
              }),
            ],
          ),
        ],
      ),
    );
  }
}
