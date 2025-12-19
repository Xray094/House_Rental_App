import 'package:get_storage/get_storage.dart';
import 'package:house_rental_app/core/config/di.dart';

import 'package:dio/dio.dart';

class LogoutService {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: baseUrl,
      headers: {
        'accept': 'application/json',
        'content-type': 'application/json',
      },
    ),
  );

  Future<bool> logout() async {
    try {
      final box = GetStorage();
      final String? token = box.read('token');

      final response = await _dio.delete(
        '/logout',
        options: Options(
          headers: {'Authorization': token != null ? 'Bearer $token' : null},
        ),
      );
      return response.statusCode == 200;
    } catch (e) {
      print("Logout Error: $e");
      return false;
    }
  }
}
