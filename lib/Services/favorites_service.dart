import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:house_rental_app/Models/apartment_model.dart';
import 'package:house_rental_app/Services/api_service.dart';

class FavoritesService {
  final Dio dio = Get.find<ApiService>().dio;

  Future<bool> toggleFavorite(String apartmentId) async {
    try {
      final response = await dio.post('/apartments/$apartmentId/favorite');
      return response.data['message']?.contains('added') == true;
    } catch (e) {
      return true;
    }
  }

  Future<List<ApartmentModel>> getFavorites() async {
    try {
      final response = await dio.get('/favorites');

      if (response.statusCode == 200 && response.data != null) {
        final List<dynamic> data = response.data['data'];
        return data.map((json) => ApartmentModel.fromJson(json)).toList();
      }

      return [];
    } catch (e) {
      return [];
    }
  }

  Future<bool> isFavorite(String apartmentId) async {
    try {
      final response = await dio.get('/favorites');

      if (response.statusCode == 200 && response.data != null) {
        final List<dynamic> data = response.data['data'];
        return data.any(
          (apartment) => apartment['id']?.toString() == apartmentId,
        );
      }

      return false;
    } catch (e) {
      return false;
    }
  }
}
