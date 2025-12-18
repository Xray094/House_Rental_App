import 'package:dio/dio.dart';
import 'package:house_rental_app/Models/login_model.dart';
import 'package:house_rental_app/Models/register_model.dart';
import 'package:house_rental_app/Models/user_model.dart';
import 'package:house_rental_app/core/config/di.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  final Dio _dio = Dio(BaseOptions(baseUrl: baseUrl));

  Future<bool> login(LoginModule loginModule) async {
    try {
      Response response = await _dio.post('/login', data: loginModule.toMap());

      if (response.statusCode == 200) {
        sl.get<SharedPreferences>().setString(
          'token',
          response.data['data']['token'],
        );
        UserModel user = UserModel.fromJson(response.data);
        if (sl.isRegistered<UserModel>()) {
          sl.unregister<UserModel>();
        }
        sl.registerSingleton<UserModel>(user);
        sl<SharedPreferences>().setString('token', user.token);
        return true;
      }
      return false;
    } catch (e) {
      print('Login Error: $e');
      return false;
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

final authService = AuthService();
