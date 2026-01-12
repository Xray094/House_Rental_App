import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:house_rental_app/Services/api_service.dart';

class BookingService {
  final Dio _dio = Get.find<ApiService>().dio;

  Future<bool> storeBooking({
    required String apartmentId,
    required String startDate,
    required String endDate,
  }) async {
    try {
      final response = await _dio.post(
        '/bookings',
        data: {
          'apartment_id': apartmentId,
          'start_date': startDate,
          'end_date': endDate,
        },
      );
      return response.statusCode == 200 || response.statusCode == 201;
    } on DioException catch (e) {
      String errorMsg = e.response?.data['message'] ?? "Booking failed";
      Get.snackbar("Booking Error", errorMsg, snackPosition: SnackPosition.TOP);
      return false;
    } catch (e) {
      return false;
    }
  }

  Future<Map<String, dynamic>> updateBooking({
    required String bookingId,
    required String startDate,
    required String endDate,
  }) async {
    try {
      final response = await _dio.put(
        '/bookings/$bookingId',
        data: {'start_date': startDate, 'end_date': endDate},
      );

      final data = response.data;
      final msg = (data is Map && data['message'] != null)
          ? data['message']
          : 'Booking updated';
      return {
        'success': response.statusCode == 200 || response.statusCode == 201,
        'message': msg,
      };
    } on DioException catch (e) {
      final data = e.response?.data;
      final msg = (data is Map && data['message'] != null)
          ? data['message']
          : (e.message ?? 'Update failed');
      return {'success': false, 'message': msg};
    } catch (e) {
      return {'success': false, 'message': 'Unexpected error: $e'};
    }
  }

  Future<List<dynamic>> getUserBookings() async {
    try {
      final response = await _dio.get('/bookings');
      final data = response.data;
      if (data == null) return [];
      return (data['data'] as List<dynamic>?) ?? [];
    } catch (e) {
      print("Fetch Bookings Error: $e");
      return [];
    }
  }

  Future<Map<String, dynamic>> cancelBooking(String bookingId) async {
    try {
      final response = await _dio.post('/bookings/$bookingId/cancel');
      final data = response.data;
      final msg = (data is Map && data['message'] != null)
          ? data['message']
          : 'Booking cancelled';
      return {
        'success':
            response.statusCode == 200 ||
            response.statusCode == 201 ||
            response.statusCode == 204,
        'message': msg,
      };
    } on DioException catch (e) {
      final data = e.response?.data;
      final msg = (data is Map && data['message'] != null)
          ? data['message']
          : (e.message ?? 'Cancel failed');
      return {'success': false, 'message': msg};
    } catch (e) {
      print("Cancel Booking Error: $e");
      return {'success': false, 'message': 'Cancel failed'};
    }
  }

  Future<Map<String, dynamic>> approveBooking(String bookingId) async {
    try {
      final response = await _dio.post('/bookings/$bookingId/approve');
      final data = response.data;
      final msg = (data is Map && data['message'] != null)
          ? data['message']
          : 'Booking approved';
      return {'success': response.statusCode == 200, 'message': msg};
    } on DioException catch (e) {
      final data = e.response?.data;
      final msg = (data is Map && data['message'] != null)
          ? data['message']
          : (e.message ?? 'Approve failed');
      return {'success': false, 'message': msg};
    } catch (e) {
      print("Approve Booking Error: $e");
      return {'success': false, 'message': 'Approve failed'};
    }
  }

  Future<Map<String, dynamic>> submitReview({
    required String apartmentId,
    required String bookingId,
    required String comment,
    required String rating,
  }) async {
    try {
      await _dio.post(
        '/reviews',
        data: {
          'apartment_id': apartmentId,
          'booking_id': bookingId,
          'comment': comment,
          'rating': rating,
        },
      );

      return {'success': true, 'message': 'Review submitted!'};
    } on DioException catch (e) {
      String errorMessage = "An error occurred";
      if (e.response?.data != null && e.response?.data['message'] != null) {
        errorMessage = e.response?.data['message'];
      }
      return {'success': false, 'message': errorMessage};
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }
}
