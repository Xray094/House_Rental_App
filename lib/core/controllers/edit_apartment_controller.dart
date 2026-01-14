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

  // Error state variables
  var titleError = ''.obs;
  var descError = ''.obs;
  var priceError = ''.obs;
  var govError = ''.obs;
  var cityError = ''.obs;
  var addressError = ''.obs;
  var areaError = ''.obs;
  var roomsError = ''.obs;
  var floorError = ''.obs;
  var featuresError = ''.obs;
  var imagesError = ''.obs;

  late String apartmentId;

  void clearAllErrors() {
    titleError.value = '';
    descError.value = '';
    priceError.value = '';
    govError.value = '';
    cityError.value = '';
    addressError.value = '';
    areaError.value = '';
    roomsError.value = '';
    floorError.value = '';
    featuresError.value = '';
    imagesError.value = '';
  }

  void validateFields() {
    clearAllErrors();
    bool isValid = true;

    if (titleCtrl.text.trim().isEmpty) {
      titleError.value = 'Please enter a title';
      isValid = false;
    } else if (titleCtrl.text.trim().length < 3) {
      titleError.value = 'Title must be at least 3 characters';
      isValid = false;
    }

    if (descCtrl.text.trim().isEmpty) {
      descError.value = 'Please enter a description';
      isValid = false;
    } else if (descCtrl.text.trim().length < 20) {
      descError.value = 'Description must be at least 20 characters';
      isValid = false;
    }

    if (priceCtrl.text.trim().isEmpty) {
      priceError.value = 'Please enter a price';
      isValid = false;
    } else {
      int price = int.tryParse(priceCtrl.text.trim()) ?? 0;
      if (price < 1) {
        priceError.value = 'Price must be at least 1';
        isValid = false;
      } else if (price >= 10000) {
        priceError.value = 'Price cannot exceed 10000';
        isValid = false;
      }
    }

    if (govCtrl.text.trim().isEmpty) {
      govError.value = 'Please enter governorate';
      isValid = false;
    }

    if (cityCtrl.text.trim().isEmpty) {
      cityError.value = 'Please enter city';
      isValid = false;
    }

    if (addressCtrl.text.trim().isEmpty) {
      addressError.value = 'Please enter address';
      isValid = false;
    }

    if (areaCtrl.text.trim().isEmpty) {
      areaError.value = 'Please enter area';
      isValid = false;
    } else {
      int area = int.tryParse(areaCtrl.text.trim()) ?? 0;
      if (area > 10000) {
        areaError.value = 'Area cannot exceed 10000';
        isValid = false;
      }
    }

    if (roomsCtrl.text.trim().isEmpty) {
      roomsError.value = 'Please enter rooms';
      isValid = false;
    } else {
      int rooms = int.tryParse(roomsCtrl.text.trim()) ?? 0;
      if (rooms < 1) {
        roomsError.value = 'At least 1 room required';
        isValid = false;
      } else if (rooms > 100) {
        roomsError.value = 'Maximum 100 rooms allowed';
        isValid = false;
      }
    }

    if (floorCtrl.text.trim().isEmpty) {
      floorError.value = 'Please enter floor number';
      isValid = false;
    } else {
      int floor = int.tryParse(floorCtrl.text.trim()) ?? 0;
      if (floor < 0) {
        floorError.value = 'Floor cannot be negative';
        isValid = false;
      } else if (floor > 200) {
        floorError.value = 'Maximum 200 floors allowed';
        isValid = false;
      }
    }

    if (selectedFeatures.isEmpty) {
      featuresError.value = 'Please select at least one feature';
      isValid = false;
    }

    if (existingImageUrls.isEmpty && gallery.isEmpty) {
      imagesError.value = 'Please add at least one photo';
      isValid = false;
    }

    if (isValid) {
      updateApartment();
    }
  }

  void toggleFeature(String feature) {
    if (selectedFeatures.contains(feature)) {
      selectedFeatures.remove(feature);
    } else {
      selectedFeatures.add(feature);
    }
    featuresError.value = '';
  }

  Future<void> pickImages() async {
    final List<XFile> pickedFiles = await _picker.pickMultiImage();
    if (pickedFiles.isNotEmpty) {
      gallery.addAll(pickedFiles.map((file) => File(file.path)));
      imagesError.value = '';
    }
  }

  void removeNewImage(int index) {
    gallery.removeAt(index);
    if (gallery.isNotEmpty || existingImageUrls.isNotEmpty) {
      imagesError.value = '';
    }
  }

  void removeExistingImage(int index) {
    existingImageUrls.removeAt(index);
    if (gallery.isNotEmpty || existingImageUrls.isNotEmpty) {
      imagesError.value = '';
    }
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
