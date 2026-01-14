import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:house_rental_app/Models/apartment_model.dart';
import 'package:house_rental_app/Services/apartment_service.dart';
import 'package:house_rental_app/core/controllers/landlord_aparments_controller.dart';
import 'package:image_picker/image_picker.dart';

class EditApartmentController extends GetxController {
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
  var existingImageUrls = <String>[].obs;
  var hasBalcony = false.obs;
  var isLoading = false.obs;
  var isUpdating = false.obs;

  var selectedFeatures = <String>[].obs;
  final List<String> availableFeatures = ["Wifi", "Elevator", "Gym", "Parking"];

  late String apartmentId;

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

  void removeNewImage(int index) {
    gallery.removeAt(index);
  }

  void removeExistingImage(int index) {
    existingImageUrls.removeAt(index);
  }

  void toggleBalcony(bool? val) {
    hasBalcony.value = val ?? false;
  }

  void loadApartmentData(ApartmentModel apartment) {
    apartmentId = apartment.id;
    final attr = apartment.attributes;
    final location = attr.location;
    final specs = attr.specs;

    titleCtrl.text = attr.title;
    descCtrl.text = attr.description;
    priceCtrl.text = attr.price.toString();
    govCtrl.text = location.governorate;
    cityCtrl.text = location.city;
    addressCtrl.text = location.address;
    areaCtrl.text = specs.area.toString();
    roomsCtrl.text = specs.rooms.toString();
    floorCtrl.text = specs.floor.toString();
    hasBalcony.value = specs.hasBalcony;

    existingImageUrls.value = attr.galleryUrls;

    selectedFeatures.value = List.from(attr.features);
  }

  Future<void> updateApartment() async {
    if (existingImageUrls.isEmpty && gallery.isEmpty) {
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

    isUpdating.value = true;

    try {
      final result = await _apartmentService.updateApartment(
        id: apartmentId,
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
        existingImageUrls: existingImageUrls.toList(),
        newImages: gallery.toList(),
      );

      isUpdating.value = false;

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
    } catch (e) {
      isUpdating.value = false;
      Get.snackbar(
        "Error",
        "Failed to update apartment: $e",
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
