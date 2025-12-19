import 'package:intl/intl.dart';
import 'package:house_rental_app/Models/apartment_model.dart';

class BookingModel {
  final String id;
  final String apartmentId;
  final String apartmentTitle;
  final DateTime startDate;
  final DateTime endDate;
  final int nightsCount;
  final double totalPrice;
  final double apartmentPricePerNight;
  final String totalPriceFormatted;
  final String status;
  final String createdAtHuman;
  final List<String> gallery;
  final ApartmentModel? apartment;

  BookingModel({
    required this.id,
    required this.apartmentId,
    required this.apartmentTitle,
    required this.startDate,
    required this.endDate,
    required this.nightsCount,
    required this.totalPrice,
    required this.apartmentPricePerNight,
    required this.totalPriceFormatted,
    required this.status,
    required this.createdAtHuman,
    required this.gallery,
    this.apartment,
  });

  factory BookingModel.fromApiJson(Map<String, dynamic> json) {
    // json is expected to be the full booking resource object as in the API
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

    // Apartment info
    String apartmentId = '';
    String apartmentTitle = '';
    List<String> gallery = [];

    final apartmentRel = relationships['apartment'];
    ApartmentModel? apartment;

    if (apartmentRel != null) {
      apartmentId = apartmentRel['id']?.toString() ?? '';
      final aptAttr = apartmentRel['attributes'] ?? {};
      apartmentTitle = aptAttr['title'] ?? '';

      final galleryList = aptAttr['gallery'] as List<dynamic>?;
      if (galleryList != null) {
        gallery = galleryList
            .map(
              (g) => (g is Map && g['url'] != null)
                  ? g['url'].toString()
                  : g.toString(),
            )
            .toList();
      }

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
      nightsCount: (attributes['nights_count'] ?? 0) is int
          ? (attributes['nights_count'] ?? 0) as int
          : int.tryParse((attributes['nights_count'] ?? '0').toString()) ?? 0,
      totalPrice: (attributes['total_price'] ?? 0) is double
          ? (attributes['total_price'] ?? 0) as double
          : double.tryParse((attributes['total_price'] ?? '0').toString()) ??
                0.0,
      apartmentPricePerNight:
          (apartmentRel != null &&
              (apartmentRel['attributes'] ?? {})['price'] != null)
          ? ((apartmentRel['attributes']['price'] is double)
                ? apartmentRel['attributes']['price'] as double
                : double.tryParse(
                        apartmentRel['attributes']['price'].toString(),
                      ) ??
                      0.0)
          : 0.0,
      totalPriceFormatted:
          attributes['total_price_formatted']?.toString() ?? '',
      status: attributes['status']?.toString() ?? '',
      createdAtHuman: attributes['created_at_human']?.toString() ?? '',
      gallery: gallery,
      apartment: apartment,
    );
  }
}
