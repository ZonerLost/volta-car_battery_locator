import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

import '../model/car_details.dart';

class LocateBatteryController extends GetxController {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> get carsRef =>
      _db.collection("modules").doc("carDatabase").collection("cars");

  final isLoading = true.obs;
  final car = Rxn<CarDetails>();
  final error = "".obs;

  Future<void> fetchCarById(String carId) async {
    try {
      isLoading.value = true;
      error.value = "";

      final doc = await carsRef.doc(carId).get();

      if (!doc.exists || doc.data() == null) {
        car.value = null;
        error.value = "Car data not found.";
        return;
      }

      car.value = CarDetails.fromDoc(doc as DocumentSnapshot<Map<String, dynamic>>);
    } catch (e) {
      car.value = null;
      error.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }
}
