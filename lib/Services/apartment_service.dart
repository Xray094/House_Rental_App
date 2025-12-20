import 'dart:io';

import 'package:dio/dio.dart';
import 'package:get/get.dart' hide Response, FormData;
import 'package:house_rental_app/Models/apartment_model.dart';
import 'package:house_rental_app/Services/api_service.dart';

class ApartmentService {
  final Dio _dio = Get.find<ApiService>().dio;

  Future<List<ApartmentModel>> getApartments() async {
    try {
      final response = await _dio.get('/apartments');
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

  //landlord get apartments
  Future<List<ApartmentModel>> getLandlordApartments(String landlordId) async {
    try {
      final response = await _dio.get('/apartments/landlord/$landlordId');
      final List<dynamic> data = response.data['data'];
      return data.map((json) => ApartmentModel.fromJson(json)).toList();
    } catch (e) {
      print("Landlord Apartments Fetch Error: $e");
      return [];
    }
  }

  // Future<Response> createApartment(
  //   Map<String, dynamic> data,
  //   List<File> images,
  // ) async {
  //   final formData = FormData({
  //     ...data,
  //     'gallery[]': images
  //         .map((image) => MultipartFile(image, filename: 'apt.jpg'))
  //         .toList(),
  //   });

  //   return await post(
  //     '/apartments',
  //     formData,
  //     headers: {'Authorization': 'Bearer ${box.read('token')}'},
  //   );
  // }
}
