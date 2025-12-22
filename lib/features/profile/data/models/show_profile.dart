import '../../../auth/data/models/verifyCode/verify_code_response.dart';

class UserProfileResponse {
  final String status;
  final UserData user;
  // final CitizenData citizen;

  UserProfileResponse({
    required this.status,
    required this.user,
    // required this.citizen,
  });

  factory UserProfileResponse.fromJson(Map<String, dynamic> json) {
    final data = json['data'] as Map<String, dynamic>;
    return UserProfileResponse(
      status: json['status'] ?? '',
      user: UserData.fromJson(data['user']),
      // citizen: CitizenData.fromJson(data['citizen']),
    );
  }
}

class CitizenData {
  final int id;
  final int userId;
  // final String createdAt;
  // final String updatedAt;

  CitizenData({
    required this.id,
    required this.userId,
    // required this.createdAt,
    // required this.updatedAt,
  });

  factory CitizenData.fromJson(Map<String, dynamic> json) {
    return CitizenData(
      id: json['id'] ?? 0,
      userId: json['user_id'] ?? 0,
      // createdAt: json['created_at'] ?? '',
      // updatedAt: json['updated_at'] ?? '',
    );
  }
}
