import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class ProfileSettingsController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  final isLoading = true.obs;

  final fullName = "User".obs;
  final email = "".obs;

  // if you store profile image url later
  final photoUrl = "".obs;

  @override
  void onInit() {
    super.onInit();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    try {
      isLoading.value = true;

      final u = _auth.currentUser;
      if (u == null) {
        fullName.value = "User";
        email.value = "";
        return;
      }

      // fallback from auth
      email.value = (u.email ?? "").trim();

      // fetch from firestore users/{uid}
      final doc = await _db.collection("users").doc(u.uid).get();
      final d = doc.data();

      if (d != null) {
        fullName.value =
            (d["fullName"] ?? d["name"] ?? d["username"] ?? "User").toString();
        email.value = (d["email"] ?? email.value).toString();
        photoUrl.value = (d["photoUrl"] ?? d["avatarUrl"] ?? "").toString();
      }
    } catch (_) {
      // keep fallback values
    } finally {
      isLoading.value = false;
    }
  }

  /// Call after profile edit
  Future<void> refreshProfile() async => _loadProfile();

  /// Logout
  Future<void> logout() async {
    await _auth.signOut();
  }

  /// Cache clear hook (aap yahan apna recent searches / local storage clear kar sakte ho)
  Future<void> clearCache() async {
    // Example:
    // - clear recent searches controller list
    // - clear any local db (Hive/SharedPrefs) if you are using
    // Keep it safe no-op if not implemented.

    // If you have a RecentSearchesController:
    // if (Get.isRegistered<RecentSearchesController>()) {
    //   Get.find<RecentSearchesController>().clearAll();
    // }

    // If you have SharedPreferences:
    // final sp = await SharedPreferences.getInstance();
    // await sp.remove("recent_searches");
  }
}

