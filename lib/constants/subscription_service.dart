
import 'package:get/get.dart';

class SubscriptionService extends GetxService {
  static SubscriptionService get instance => Get.find();
  
  // Observable subscription state
  var selectedPlanIndex = 0.obs; // 0: Free, 1: Light, 2: Full
  
  // Getter to check if user has premium subscription (Light or Full)
  bool get hasPremiumSubscription => selectedPlanIndex.value > 0;
  
  // Getter to check if user has Light tier
  bool get hasLightTier => selectedPlanIndex.value == 1;
  
  // Getter to check if user has Full tier
  bool get hasFullTier => selectedPlanIndex.value == 2;
  
  // Method to update subscription
  void updateSubscription(int planIndex) {
    selectedPlanIndex.value = planIndex;
  }
}