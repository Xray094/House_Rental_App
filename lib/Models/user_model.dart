import 'dart:convert';

class UserModel {
  final String id;
  final String token;
  final UserAttributes attributes;

  UserModel({required this.id, required this.token, required this.attributes});

  factory UserModel.fromJson(Map<String, dynamic> json) {
    final userData = json['data']['user'];
    return UserModel(
      id: userData['id'],
      token: json['data']['token'],
      attributes: UserAttributes.fromJson(userData['attributes']),
    );
  }
  factory UserModel.fromJsonForTokenCheck(
    Map<String, dynamic> json,
    String token,
  ) {
    final userData = json['data'];
    return UserModel(
      id: userData['id'],
      token: token,
      attributes: UserAttributes.fromJson(userData['attributes']),
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'token': token, 'attributes': attributes.toJson()};
  }

  static UserModel fromJsonString(String jsonStr) {
    final decodedRaw = jsonDecode(jsonStr);
    final decoded = decodedRaw is Map
        ? Map<String, dynamic>.from(decodedRaw)
        : <String, dynamic>{};
    if (decoded.containsKey('data')) {
      return UserModel.fromJson(decoded);
    }
    return UserModel(
      id: decoded['id'] ?? '',
      token: decoded['token'] ?? '',
      attributes: UserAttributes.fromJson(decoded['attributes'] ?? {}),
    );
  }
}

class UserAttributes {
  final String fullName;
  final String role;
  final String avatarUrl;
  final String phoneNumber;
  final bool isVerified;
  final String birthDate;

  UserAttributes({
    required this.fullName,
    required this.role,
    required this.avatarUrl,
    required this.phoneNumber,
    required this.isVerified,
    required this.birthDate,
  });

  factory UserAttributes.fromJson(Map<String, dynamic> json) {
    return UserAttributes(
      fullName: json['full_name'] ?? '',
      role: json['role'] ?? '',
      avatarUrl: json['avatar_url'] != null
          ? json['avatar_url'].toString().replaceAll(
              '127.0.0.1:8000',
              '10.0.2.2:8000',
            )
          : '',
      phoneNumber: json['phone_number'] ?? '',
      isVerified: json['is_verified'] ?? false,
      birthDate: json['birth_date'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'full_name': fullName,
      'role': role,
      'avatar_url': avatarUrl,
      'phone_number': phoneNumber,
      'is_verified': isVerified,
      'birth_date': birthDate,
    };
  }
}
