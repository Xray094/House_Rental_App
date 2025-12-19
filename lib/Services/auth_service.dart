import 'package:dio/dio.dart';
import 'package:get/get.dart' hide FormData;
import 'package:house_rental_app/Models/login_model.dart';
import 'package:house_rental_app/Models/register_model.dart';
import 'package:house_rental_app/Models/user_model.dart';
import 'package:house_rental_app/Services/api_service.dart';

class AuthService extends GetxService {
  // Use the centralized Dio instance from ApiService
  final Dio _dio = Get.find<ApiService>().dio;

  /// Attempts to login and returns [UserModel] on success, otherwise null.
  Future<UserModel?> login(LoginModule loginModule) async {
    try {
      // POST to /login using the base config from ApiService
      final response = await _dio.post('/login', data: loginModule.toMap());

      if (response.statusCode == 200) {
        // Assuming your Laravel backend returns the user data directly
        // or inside a 'data' wrapper.
        return UserModel.fromJson(response.data);
      }
      return null;
    } on DioException catch (e) {
      print('Login Dio Error: ${e.response?.data ?? e.message}');
      return null;
    } catch (e) {
      print('Login Unexpected Error: $e');
      return null;
    }
  }

  /// Attempts to register a user and returns a structured result
  /// Map keys: 'success' (bool), 'message' (String?), 'errors' (Map?)
  Future<Map<String, dynamic>> register(RegisterModule registerModule) async {
    try {
      // Converts register fields + images into multipart/form-data
      FormData data = await registerModule.toFormData();

      final response = await _dio.post('/register', data: data);

      if (response.statusCode == 200 || response.statusCode == 201) {
        final msg = (response.data is Map && response.data['message'] != null)
            ? response.data['message']
            : 'Registration successful';
        return {'success': true, 'message': msg};
      }

      return {'success': false, 'message': 'Registration failed'};
    } on DioException catch (e) {
      // Handles Laravel Validation Errors (422 Unprocessable Entity)
      if (e.response != null) {
        final responseData = e.response?.data;
        final msg = (responseData is Map && responseData['message'] != null)
            ? responseData['message']
            : 'Registration failed';

        return {
          'success': false,
          'message': msg,
          'errors': responseData is Map ? responseData['errors'] : null,
        };
      } else {
        return {'success': false, 'message': 'Connection error: ${e.message}'};
      }
    } catch (e) {
      return {'success': false, 'message': 'Unexpected error: $e'};
    }
  }
}
