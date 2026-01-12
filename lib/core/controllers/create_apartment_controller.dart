import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:house_rental_app/Services/apartment_service.dart';
import 'package:house_rental_app/core/controllers/landlord_aparments_controller.dart';
import 'package:image_picker/image_picker.dart';

class CreateApartmentController extends GetxController {
  final titleCtrl = TextEditingController();
  final descCtrl = TextEditingController();
  final priceCtrl = TextEditingController();
  final govCtrl = TextEditingController();
  final cityCtrl = TextEditingController();
  final addressCtrl = TextEditingController();
  final areaCtrl = TextEditingController();
  final roomsCtrl = TextEditingController();
  final floorCtrl = TextEditingController();

  final ImagePicker _picker = ImagePicker();
  final ApartmentService _apartmentService = ApartmentService();

  var gallery = <File>[].obs;
  var hasBalcony = false.obs;
  var isLoading = false.obs;

  var selectedFeatures = <String>[].obs;
  final List<String> availableFeatures = ["Wifi", "Elevator", "Gym", "Parking"];

  void toggleFeature(String feature) {
    if (selectedFeatures.contains(feature)) {
      selectedFeatures.remove(feature);
    } else {
      selectedFeatures.add(feature);
    }
  }

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

  Future<void> submitApartment() async {
    if (gallery.isEmpty) {
      Get.snackbar(
        "Error",
        "Please add at least one photo",
        snackPosition: SnackPosition.TOP,
      );
      return;
    }
    if (selectedFeatures.isEmpty) {
      Get.snackbar(
        "Features Required",
        "Please select at least one feature (e.g., Wifi, Elevator)",
        backgroundColor: Colors.orange.shade800,
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
      );
      return;
    }

    isLoading.value = true;

    final result = await _apartmentService.createApartment(
      title: titleCtrl.text,
      description: descCtrl.text,
      price: priceCtrl.text,
      governorate: govCtrl.text,
      city: cityCtrl.text,
      address: addressCtrl.text,
      area: areaCtrl.text,
      roomsCount: roomsCtrl.text,
      floor: floorCtrl.text,
      hasBalcony: hasBalcony.value,
      features: selectedFeatures.toList(),
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
        snackPosition: SnackPosition.TOP,
      );
      Get.find<LandlordApartmentsController>().fetchMyApartments();
    } else {
      Get.snackbar(
        "Error",
        result['message'],
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.TOP,
      );
    }
  }

  @override
  void onClose() {
    titleCtrl.dispose();
    descCtrl.dispose();
    priceCtrl.dispose();
    govCtrl.dispose();
    cityCtrl.dispose();
    addressCtrl.dispose();
    areaCtrl.dispose();
    roomsCtrl.dispose();
    floorCtrl.dispose();
    super.onClose();
  }
}
