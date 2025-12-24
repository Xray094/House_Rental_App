import 'dart:io';

import 'package:dio/dio.dart';
import 'package:get/get.dart' hide Response, FormData, MultipartFile;
import 'package:house_rental_app/Models/apartment_model.dart';
import 'package:house_rental_app/Services/api_service.dart';

class ApartmentService {
  final Dio _dio = Get.find<ApiService>().dio;

  Future<List<ApartmentModel>> getApartments() async {
    try {
      final response = await _dio.get('/apartments');
      response.data['data'];
      final List<dynamic> data = response.data['data'];
      return data.map((json) => ApartmentModel.fromJson(json)).toList();
    } catch (e) {
      print("Apartment Fetch Error: $e");
      return [];
    }
  }

  Future<ApartmentModel?> getApartmentById(String id) async {
    try {
      final response = await _dio.get('/apartments/$id');
      if (response.statusCode == 200) {
        return ApartmentModel.fromJson(response.data['data']);
      }
      return null;
    } catch (e) {
      print("Error fetching apartment details: $e");
      return null;
    }
  }

  Future<List<ApartmentModel>> getLandlordApartments() async {
    try {
      final response = await _dio.get('/my-apartments');
      final List<dynamic> data = response.data['data'];
      return data.map((json) => ApartmentModel.fromJson(json)).toList();
    } catch (e) {
      print("Landlord Apartments Fetch Error: $e");
      return [];
    }
  }

  Future<Map<String, dynamic>> createApartment({
    required String title,
    required String description,
    required String price,
    required String governorate,
    required String city,
    required String address,
    required String area,
    required String roomsCount,
    required String floor,
    required bool hasBalcony,
    required List<String> features,
    required List<File> images,
  }) async {
    try {
      List<MultipartFile> imageFiles = [];
      for (File file in images) {
        imageFiles.add(
          await MultipartFile.fromFile(
            file.path,
            filename: file.path.split('/').last,
          ),
        );
      }
      FormData formData = FormData.fromMap({
        'title': title,
        'description': description,
        'price': price,
        'governorate': governorate,
        'city': city,
        'address': address,
        'area_in_square_meters': area,
        'rooms_count': roomsCount,
        'floor': floor,
        'has_balcony': hasBalcony ? 1 : 0,
        'features[]': features,
        'images[]': imageFiles,
      });

      final response = await _dio.post('/apartments', data: formData);

      return {
        'success': true,
        'message': 'Apartment created successfully',
        'data': response.data,
      };
    } on DioException catch (e) {
      String errorMessage =
          e.response?.data['message'] ?? "Failed to create apartment";
      return {'success': false, 'message': errorMessage};
    } catch (e) {
      return {'success': false, 'message': 'An unexpected error occurred: $e'};
    }
  }

  Future<Map<String, dynamic>> deleteApartment(String id) async {
    try {
      final response = await _dio.delete('/apartments/$id');
      return {
        'success': true,
        'message': response.data['message'] ?? 'Deleted successfully',
      };
    } on DioException catch (e) {
      return {
        'success': false,
        'message': e.response?.data['message'] ?? 'Failed to delete',
      };
    }
  }
}
