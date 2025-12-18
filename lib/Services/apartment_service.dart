import 'package:dio/dio.dart';
import 'package:house_rental_app/Models/apartment_model.dart';
import 'package:house_rental_app/core/config/di.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ApartmentService {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: baseUrl,
      headers: {
        'Authorization':
            'Bearer ${sl.get<SharedPreferences>().getString('token')}',
        'accept': 'application/json',
        'content-type': 'application/json',
      },
    ),
  );

  Future<List<ApartmentModel>> getApartments() async {
    try {
      final response = await _dio.get('/apartments');
      final List<dynamic> data = response.data['data'];
      return data
          .map((apartmentJson) => ApartmentModel.fromJson(apartmentJson))
          .toList();
    } on DioException catch (e) {
      print(e);
      return [];
    } catch (e) {
      print(e);
      return [];
    }
  }
}

final apartmentService = ApartmentService();
