import '../../../../auth/data/models/verifyCode/verify_code_response.dart';

class UpdateProfileResponse {
  final String message;
  final UserData user;

  UpdateProfileResponse({required this.message, required this.user});

  factory UpdateProfileResponse.fromJson(Map<String, dynamic> json) {
    final data = json['data'] as Map<String, dynamic>;
    print('Data is edit  : $data');
    return UpdateProfileResponse(
      message: data['message'] ?? '',
      user: UserData.fromJson(data['user']),
    );

  }
}
