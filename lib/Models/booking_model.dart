import 'package:intl/intl.dart';
import 'package:house_rental_app/Models/apartment_model.dart';

class BookingModel {
  final String id;
  final String apartmentId;
  final String apartmentTitle;
  final DateTime startDate;
  final DateTime endDate;
  final int nightsCount;
  final String totalPriceFormatted;
  final String status;
  final String createdAtHuman;
  final ApartmentModel? apartment;

  BookingModel({
    required this.id,
    required this.apartmentId,
    required this.apartmentTitle,
    required this.startDate,
    required this.endDate,
    required this.nightsCount,
    required this.totalPriceFormatted,
    required this.status,
    required this.createdAtHuman,
    this.apartment,
  });

  factory BookingModel.fromJson(Map<String, dynamic> json) {
    final id = json['id']?.toString() ?? '';
    final attributes = json['attributes'] ?? {};
    final relationships = json['relationships'] ?? {};

    DateTime parseDate(String? s) {
      if (s == null) return DateTime.now();
      try {
        return DateFormat('yyyy-MM-dd').parse(s);
      } catch (_) {
        return DateTime.tryParse(s) ?? DateTime.now();
      }
    }

    final startDate = parseDate(attributes['start_date']?.toString());
    final endDate = parseDate(attributes['end_date']?.toString());
    String apartmentId = '';
    String apartmentTitle = '';

    final apartmentRel = relationships['apartment'];
    ApartmentModel? apartment;

    if (apartmentRel != null) {
      apartmentId = apartmentRel['id']?.toString() ?? '';
      final aptAttr = apartmentRel['attributes'] ?? {};
      apartmentTitle = aptAttr['title'] ?? '';

      try {
        apartment = ApartmentModel.fromJson(
          apartmentRel as Map<String, dynamic>,
        );
      } catch (_) {
        apartment = null;
      }
    }

    return BookingModel(
      id: id,
      apartmentId: apartmentId,
      apartmentTitle: apartmentTitle,
      startDate: startDate,
      endDate: endDate,
      nightsCount: attributes['nights_count'] ?? 0,
      totalPriceFormatted: attributes['total_price_formatted'] ?? '',
      status: attributes['status'] ?? '',
      createdAtHuman: attributes['created_at_human'] ?? '',
      apartment: apartment,
    );
  }
}
