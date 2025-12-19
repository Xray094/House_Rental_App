import 'package:dio/dio.dart';
import 'package:house_rental_app/Models/login_model.dart';
import 'package:house_rental_app/Models/register_model.dart';
import 'package:house_rental_app/Models/user_model.dart';
import 'package:house_rental_app/core/config/di.dart';

class AuthService {
  final Dio _dio = Dio(BaseOptions(baseUrl: baseUrl));

  /// Attempts to login and returns [UserModel] on success, otherwise null.
  Future<UserModel?> login(LoginModule loginModule) async {
    try {
      final response = await _dio.post('/login', data: loginModule.toMap());

      if (response.statusCode == 200) {
        final user = UserModel.fromJson(response.data);
        return user;
      }
      return null;
    } catch (e) {
      print('Login Error: $e');
      return null;
    }
  }

  Future<bool> register(RegisterModule registerModule) async {
    try {
      FormData data = await registerModule.toFormData();

      Response response = await _dio.post('/register', data: data);

      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } on DioException catch (e) {
      if (e.response != null) {
        print('HTTP Error Status: ${e.response?.statusCode}');
        print('Response Data: ${e.response?.data}');
      } else {
        print('Registration Connection Error: $e');
      }
      return false;
    }
  }
}
