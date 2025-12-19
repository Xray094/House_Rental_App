import 'package:get/get.dart';
import 'package:house_rental_app/Services/api_service.dart';

import 'package:dio/dio.dart';

class LogoutService {
  final Dio _dio = Get.find<ApiService>().dio;

  Future<bool> logout() async {
    try {
      final response = await _dio.delete('/logout');
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }
}
