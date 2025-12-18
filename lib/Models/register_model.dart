import 'dart:io';
import 'package:dio/dio.dart';
import 'package:intl/intl.dart';

class RegisterModule {
  String firstName;
  String lastName;
  String mobile;
  String password;
  String role;
  DateTime birthDate;
  File profileImage;
  File idImage;

  RegisterModule({
    required this.firstName,
    required this.lastName,
    required this.mobile,
    required this.password,
    required this.role,
    required this.birthDate,
    required this.profileImage,
    required this.idImage,
  });

  Future<FormData> toFormData() async {
    String formattedDate = DateFormat('yyyy-MM-dd').format(birthDate);

    return FormData.fromMap({
      'first_name': firstName,
      'last_name': lastName,
      'phone_number': mobile,
      'password': password,
      'role': role,
      'birth_date': formattedDate,
      'avatar': await MultipartFile.fromFile(
        profileImage.path,
        filename: profileImage.path.split('/').last,
      ),
      'identity': await MultipartFile.fromFile(
        idImage.path,
        filename: idImage.path.split('/').last,
      ),
    });
  }
}
