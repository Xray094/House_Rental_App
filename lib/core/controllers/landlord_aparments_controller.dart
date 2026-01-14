import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:house_rental_app/Models/apartment_model.dart';
import 'package:house_rental_app/Services/apartment_service.dart';

class LandlordApartmentsController extends GetxController {
  var myApartments = <ApartmentModel>[].obs;
  var isLoading = false.obs;
  final ApartmentService service = ApartmentService();

  @override
  void onInit() {
    fetchMyApartments();
    super.onInit();
  }

  Future<void> fetchMyApartments() async {
    isLoading.value = true;
    final response = await service.getLandlordApartments();
    myApartments.value = response;
    isLoading.value = false;
  }

  Future<void> deleteApartment(String id) async {
    Get.defaultDialog(
      title: "Delete Property",
      titleStyle: const TextStyle(
        color: Colors.red,
        fontWeight: FontWeight.bold,
      ),
      middleTextStyle: TextStyle(color: Colors.black),
      middleText: "Are you sure you want to remove this listing?",
      textConfirm: "Delete",
      textCancel: "Cancel",
      confirmTextColor: Colors.black,
      buttonColor: Colors.red,
      onConfirm: () async {
        Get.back();
        isLoading.value = true;
        final result = await service.deleteApartment(id);
        isLoading.value = false;
        if (result['success']) {
          myApartments.removeWhere((element) => element.id == id);
          Get.snackbar(
            "Deleted",
            "Apartment removed successfully",
            backgroundColor: Colors.green,
            colorText: Colors.white,
            snackPosition: SnackPosition.TOP,
          );
        } else {
          Get.snackbar(
            "Error",
            result['message'],
            backgroundColor: Colors.red,
            colorText: Colors.white,
            snackPosition: SnackPosition.TOP,
          );
        }
      },
    );
  }
}
