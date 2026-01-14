import 'dart:io';

import 'package:dio/dio.dart';
import 'package:get/get.dart' hide Response, FormData, MultipartFile;
import 'package:house_rental_app/Models/apartment_model.dart';
import 'package:house_rental_app/Services/api_service.dart';

class ApartmentService {
  final Dio _dio = Get.find<ApiService>().dio;

  Future<Map<String, dynamic>> getApartmentsWithPagination({
    int page = 1,
    String? governorate,
    String? city,
    double? minPrice,
    double? maxPrice,
    int? minRooms,
    int? minArea,
    int perPage = 10,
  }) async {
    try {
      Map<String, dynamic> queryParams = {'page': page, 'per_page': perPage};
      if (governorate != null && governorate.isNotEmpty) {
        queryParams['governorate'] = governorate;
      }
      if (city != null && city.isNotEmpty) {
        queryParams['city'] = city;
      }
      if (minPrice != null && minPrice > 0) {
        queryParams['min_price'] = minPrice.toStringAsFixed(2);
      }
      if (maxPrice != null && maxPrice > 0) {
        queryParams['max_price'] = maxPrice.toStringAsFixed(2);
      }
      if (minRooms != null && minRooms > 0) {
        queryParams['min_rooms'] = minRooms;
      }
      if (minArea != null && minArea > 0) {
        queryParams['min_area'] = minArea;
      }

      final response = await _dio.get(
        '/apartments',
        queryParameters: queryParams,
      );

      final List<dynamic> data = response.data['data'] ?? [];
      final meta = response.data['meta'] as Map<String, dynamic>? ?? {};
      final links = response.data['links'] as Map<String, dynamic>? ?? {};

      final currentPage = meta['current_page'] as int? ?? 1;
      final lastPage = meta['last_page'] as int? ?? 1;
      final nextPageUrl = links['next'] as String?;

      final apartments = data
          .map((json) => ApartmentModel.fromJson(json))
          .toList();

      return {
        'apartments': apartments,
        'hasMore': nextPageUrl != null && nextPageUrl.isNotEmpty,
        'currentPage': currentPage,
        'lastPage': lastPage,
        'nextPageUrl': nextPageUrl,
        'total': meta['total'] as int? ?? apartments.length,
      };
    } catch (e) {
      print("Apartment Pagination Fetch Error: $e");
      return {
        'apartments': <ApartmentModel>[],
        'hasMore': false,
        'currentPage': 1,
        'lastPage': 1,
        'nextPageUrl': null,
        'total': 0,
      };
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

  Future<Map<String, dynamic>> updateApartment({
    required String id,
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
    required List<String> existingImageUrls,
    required List<File> newImages,
  }) async {
    try {
      List<MultipartFile> imageFiles = [];
      for (File file in newImages) {
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
        'existing_images[]': existingImageUrls,
        'new_images[]': imageFiles,
      });

      final response = await _dio.patch('/apartments/$id', data: formData);

      return {
        'success': true,
        'message': 'Apartment updated successfully',
        'data': response.data,
      };
    } on DioException catch (e) {
      String errorMessage =
          e.response?.data['message'] ?? "Failed to update apartment";
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

  Future<Map<String, List<String>>> getFilterOptions() async {
    try {
      final response = await _dio.get('/apartments/filters');
      final governorates = <String>[];
      final cities = <String>[];

      if (response.data['data']['governorates'] != null) {
        final govData = response.data['data']['governorates'];
        if (govData is List) {
          governorates.addAll(List<String>.from(govData.whereType<String>()));
        }
      }

      if (response.data['data']['cities'] != null) {
        final cityData = response.data['data']['cities'];
        if (cityData is List) {
          cities.addAll(List<String>.from(cityData.whereType<String>()));
        }
      }
      governorates.sort();
      cities.sort();

      return {'governorates': governorates, 'cities': cities};
    } catch (e) {
      print("Filter Options Fetch Error: $e");
      return {'governorates': <String>[], 'cities': <String>[]};
    }
  }
}
