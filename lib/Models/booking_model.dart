class BookingModel {
  final int id;
  final int apartmentId;
  final int userId;
  final String startDate;
  final String endDate;
  final String status;

  BookingModel({
    required this.id,
    required this.apartmentId,
    required this.userId,
    required this.startDate,
    required this.endDate,
    required this.status,
  });

  factory BookingModel.fromJson(Map<String, dynamic> json) {
    return BookingModel(
      id: json['id'],
      apartmentId: json['apartment_id'],
      userId: json['user_id'],
      startDate: json['start_date'],
      endDate: json['end_date'],
      status: json['status'],
    );
  }
}
