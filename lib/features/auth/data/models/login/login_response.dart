import 'package:eshhtikiyl_app/features/auth/data/models/verifyCode/verify_code_response.dart';

class LoginResponse {
  final String status;
  final UserData user;

  LoginResponse({
    required this.status,
    required this.user,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    final data = json['data'] as Map<String, dynamic>;
    return LoginResponse(
      status: json['status'] ?? '',
      user: UserData.fromJson(data['user']),
    );
  }
}