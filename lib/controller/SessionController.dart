import 'package:get/get.dart';

class SessionController extends GetxController {
  final isGuest = false.obs;

  void setGuest(bool value) {
    isGuest.value = value;
  }
}
