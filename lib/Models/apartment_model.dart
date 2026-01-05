import 'package:house_rental_app/Models/booking_model.dart';
import 'package:house_rental_app/Models/review_model.dart';

class ApartmentModel {
  final String id;
  final ApartmentAttributes attributes;
  final String ownerName;
  final List<ReviewModel> reviews;
  final List<BookingModel> bookings;

  ApartmentModel({
    required this.id,
    required this.attributes,
    required this.ownerName,
    required this.reviews,
    this.bookings = const [],
  });

  factory ApartmentModel.fromJson(Map<String, dynamic> json) {
    final rel = json['relationships'] ?? {};

    String extractedOwner = 'Unknown Owner';
    if (rel['landlord'] != null) {
      extractedOwner =
          rel['landlord']['attributes']?['full_name'] ?? 'Unknown Owner';
    }

    List<ReviewModel> reviewList = [];
    if (rel['reviews'] != null && rel['reviews'] is List) {
      reviewList = (rel['reviews'] as List)
          .map((r) => ReviewModel.fromJson(r))
          .toList();
    }

    List<BookingModel> bookingList = [];
    if (rel['bookings'] != null && rel['bookings'] is List) {
      bookingList = (rel['bookings'] as List)
          .map((b) => BookingModel.fromJson(b))
          .toList();
    }

    return ApartmentModel(
      id: json['id']?.toString() ?? '',
      attributes: ApartmentAttributes.fromJson(json['attributes'] ?? {}),
      ownerName: extractedOwner,
      reviews: reviewList,
      bookings: bookingList,
    );
  }
}

class ApartmentAttributes {
  final String title;
  final String description;
  final double price;
  final String formattedPrice;
  final ApartmentLocation location;
  final ApartmentSpecs specs;
  final List<String> features;
  final List<String> galleryUrls;

  ApartmentAttributes({
    required this.title,
    required this.description,
    required this.price,
    required this.formattedPrice,
    required this.location,
    required this.specs,
    required this.features,
    required this.galleryUrls,
  });

  factory ApartmentAttributes.fromJson(Map<String, dynamic> json) {
    return ApartmentAttributes(
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      formattedPrice:
          json['formatted_price']?.toString().replaceAll('S.P', 'USD') ?? '',
      location: ApartmentLocation.fromJson(json['location'] ?? {}),
      specs: ApartmentSpecs.fromJson(json['specs'] ?? {}),
      features: List<String>.from(json['features'] ?? []),
      galleryUrls: ((json['gallery'] ?? []) as List).map((item) {
        String url = item['url'] as String? ?? '';
        if (url.startsWith('/storage')) {
          url = 'http://10.0.2.2:8000$url';
        }
        return url.replaceAll('127.0.0.1:8000', '10.0.2.2:8000');
      }).toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'price': price,
      'formatted_price': formattedPrice,
      'location': location.toJson(),
      'specs': specs.toJson(),
      'features': features,
      'gallery': galleryUrls.map((u) => {'url': u}).toList(),
    };
  }
}

class ApartmentLocation {
  final String governorate;
  final String city;
  final String address;

  ApartmentLocation({
    required this.governorate,
    required this.city,
    required this.address,
  });

  factory ApartmentLocation.fromJson(Map<String, dynamic> json) {
    return ApartmentLocation(
      governorate: json['governorate'] ?? json['governorate_name'] ?? '',
      city: json['city'] ?? json['city_name'] ?? '',
      address: json['address'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {'governorate': governorate, 'city': city, 'address': address};
  }
}

class ApartmentSpecs {
  final int area;
  final int rooms;
  final int floor;
  final bool hasBalcony;

  ApartmentSpecs({
    required this.area,
    required this.rooms,
    required this.floor,
    required this.hasBalcony,
  });

  factory ApartmentSpecs.fromJson(Map<String, dynamic> json) {
    return ApartmentSpecs(
      area: json['area'] ?? 0,
      rooms: json['rooms'] ?? 0,
      floor: json['floor'] ?? 0,
      hasBalcony: json['has_balcony'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'area': area,
      'rooms': rooms,
      'floor': floor,
      'has_balcony': hasBalcony,
    };
  }
}
