import 'package:dio/dio.dart';
import 'package:get/get.dart' hide FormData;
import 'package:house_rental_app/Models/login_model.dart';
import 'package:house_rental_app/Models/register_model.dart';
import 'package:house_rental_app/Models/user_model.dart';
import 'package:house_rental_app/Services/api_service.dart';

class AuthService extends GetxService {
  final Dio _dio = Get.find<ApiService>().dio;

  Future<UserModel?> login(LoginModule loginModule) async {
    try {
      final response = await _dio.post('/login', data: loginModule.toMap());

      if (response.statusCode == 200) {
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

  Future<Map<String, dynamic>> register(RegisterModule registerModule) async {
    try {
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
