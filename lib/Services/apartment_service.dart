import 'package:dio/dio.dart';
import 'package:get_storage/get_storage.dart';
import 'package:house_rental_app/Models/apartment_model.dart';
import 'package:house_rental_app/core/config/di.dart';

class ApartmentService {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: baseUrl,
      headers: {
        'accept': 'application/json',
        'content-type': 'application/json',
      },
    ),
  );

  Future<List<ApartmentModel>> getApartments() async {
    try {
      final box = GetStorage();
      final String? token = box.read('token');

      final response = await _dio.get(
        '/apartments',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'accept': 'application/json',
            'content-type': 'application/json',
          },
        ),
      );

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
