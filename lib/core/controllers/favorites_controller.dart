import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:house_rental_app/Models/apartment_model.dart';
import 'package:house_rental_app/Services/favorites_service.dart';

class FavoritesController extends GetxController {
  final FavoritesService _favoritesService = Get.put(FavoritesService());

  var favoriteApartments = <ApartmentModel>[].obs;
  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadFavorites();
  }

  /// Load all favorite apartments
  Future<void> loadFavorites() async {
    isLoading(true);
    try {
      final favorites = await _favoritesService.getFavorites();
      favoriteApartments.assignAll(favorites);
    } catch (e) {
      // Handle error - could show a snackbar or log the error
      Get.snackbar(
        'Error',
        'Failed to load favorites',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading(false);
    }
  }

  /// Toggle favorite status for an apartment
  Future<bool> toggleFavorite(String apartmentId) async {
    try {
      final result = await _favoritesService.toggleFavorite(apartmentId);

      // Reload favorites to get the updated list
      await loadFavorites();

      return result;
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to update favorite status',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.black,
      );
      return false;
    }
  }

  /// Check if an apartment is favorite
  Future<bool> isFavorite(String apartmentId) async {
    return await _favoritesService.isFavorite(apartmentId);
  }

  /// Remove an apartment from favorites
  Future<void> removeFromFavorites(String apartmentId) async {
    try {
      await _favoritesService.toggleFavorite(apartmentId);
      await loadFavorites();
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to remove from favorites',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.black,
      );
    }
  }
}
