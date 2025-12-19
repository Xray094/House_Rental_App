import 'package:dio/dio.dart';
import 'package:house_rental_app/Models/login_model.dart';
import 'package:house_rental_app/Models/register_model.dart';
import 'package:house_rental_app/Models/user_model.dart';
import 'package:house_rental_app/core/config/di.dart';

class AuthService {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: baseUrl,
      headers: {
        'accept': 'application/json',
        'content-type': 'application/json',
      },
    ),
  );

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

  /// Attempts to register a user and returns a structured result
  /// Map keys: 'success' (bool), 'message' (String?), 'errors' (Map?)
  Future<Map<String, dynamic>> register(RegisterModule registerModule) async {
    try {
      FormData data = await registerModule.toFormData();

      final response = await _dio.post('/register', data: data);

      if (response.statusCode == 200) {
        final msg = (response.data is Map && response.data['message'] != null)
            ? response.data['message']
            : 'Registration successful';
        return {'success': true, 'message': msg};
      } else {
        final data = response.data;
        final msg = (data is Map && data['message'] != null)
            ? data['message']
            : 'Registration failed';
        return {
          'success': false,
          'message': msg,
          'errors': data is Map ? data['errors'] : null,
        };
      }
    } on DioException catch (e) {
      if (e.response != null) {
        final data = e.response?.data;
        final msg = (data is Map && data['message'] != null)
            ? data['message']
            : 'Registration failed';
        return {
          'success': false,
          'message': msg,
          'errors': data is Map ? data['errors'] : null,
        };
      } else {
        return {'success': false, 'message': 'Connection error: ${e.message}'};
      }
    } catch (e) {
      return {'success': false, 'message': 'Unexpected error: $e'};
    }
  }
}
