import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:house_rental_app/Services/apartment_service.dart';
import 'package:house_rental_app/core/controllers/landlord_aparments_controller.dart';
import 'package:image_picker/image_picker.dart';

class CreateApartmentController extends GetxController {
  final ImagePicker _picker = ImagePicker();

  var gallery = <File>[].obs;
  var hasBalcony = false.obs;
  var isLoading = false.obs;

  Future<void> pickImages() async {
    final List<XFile> pickedFiles = await _picker.pickMultiImage();
    if (pickedFiles.isNotEmpty) {
      gallery.addAll(pickedFiles.map((file) => File(file.path)));
    }
  }

  void removeImage(int index) {
    gallery.removeAt(index);
  }

  void toggleBalcony(bool? val) {
    hasBalcony.value = val ?? false;
  }

  final ApartmentService _apartmentService = ApartmentService();

  Future<void> submitApartment({
    required String title,
    required String description,
    required String price,
    required String gov,
    required String city,
    required String address,
    required String area,
    required String rooms,
    required String floor,
  }) async {
    if (gallery.isEmpty) {
      Get.snackbar("Error", "Please add at least one photo");
      return;
    }

    isLoading.value = true;

    final result = await _apartmentService.createApartment(
      title: title,
      description: description,
      price: price,
      governorate: gov,
      city: city,
      address: address,
      area: area,
      roomsCount: rooms,
      floor: floor,
      hasBalcony: hasBalcony.value,
      images: gallery.toList(),
    );

    isLoading.value = false;

    if (result['success']) {
      Get.back();
      Get.snackbar(
        "Success",
        result['message'],
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
      Get.find<LandlordApartmentsController>().fetchMyApartments();
    } else {
      Get.snackbar(
        "Error",
        result['message'],
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }
}
