class LoginModule {
  String mobile;
  String password;

  LoginModule({required this.mobile, required this.password});

  Map<String, dynamic> toMap() {
    return {'phone_number': mobile, 'password': password};
  }
}
