import 'package:house_rental_app/core/config/di.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:dio/dio.dart';

Future<bool> logout() async {
  final Dio dio = Dio(BaseOptions(baseUrl: baseUrl));
  try {
    final String? token = sl<SharedPreferences>().getString('token');

    final response = await dio.delete(
      '/logout',
      options: Options(
        headers: {
          'Authorization': 'Bearer $token',
          'accept': 'application/json',
          'content-type': 'application/json',
        },
      ),
    );
    return response.statusCode == 200;
  } catch (e) {
    print("Logout Error: $e");
    return false;
  }
}
