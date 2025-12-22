class VerificationResponse {
  final String status;
  final UserData user;

  VerificationResponse({
    required this.status,
    required this.user,
  });

  factory VerificationResponse.fromJson(Map<String, dynamic> json) {
    final data = json['data'] as Map<String, dynamic>;
    return VerificationResponse(
      status: json['status'] ?? '',
      user: UserData.fromJson(data['user']),
    );
  }
}

class UserData {
  final int id;
  final String name;
  final String email;
  final String phone_number;
  // final String? email_verified_at;
  final String token;
  // final String createdAt;
  // final String updatedAt;

  UserData({
    required this.id,
    required this.name,
    required this.email,
    required this.phone_number,
    // this.email_verified_at,
    required this.token,
    // required this.createdAt,
    // required this.updatedAt,
  });

  factory UserData.fromJson(Map<String, dynamic> json) {
    return UserData(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      phone_number: json['phone_number'] ?? '',
      // email_verified_at: json['email_verified_at'],
      token: json['token'] ?? '',
      // createdAt: json['created_at'] ?? '',
      // updatedAt: json['updated_at'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone_number': phone_number,
      // 'email_verified_at': email_verified_at,
      'token': token,
      // 'created_at': createdAt,
      // 'updated_at': updatedAt,
    };
  }
}