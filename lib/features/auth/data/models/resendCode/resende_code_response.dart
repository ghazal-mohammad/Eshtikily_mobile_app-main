class ResendCodeResponse {
  final String message;
  final String expiresIn;
  final String status;

  ResendCodeResponse({
    required this.message,
    required this.expiresIn,
    required this.status,
  });

  factory ResendCodeResponse.fromJson(Map<String, dynamic> json) {
    final data = json['data'] as Map<String, dynamic>;
    return ResendCodeResponse(
      message: data['message'] ?? '',
      expiresIn: data['expires_in'] ?? '',
      status: json['status'] ?? '',
    );
  }
}