class DeleteProfileResponse {
  final String status;
  final String data;

  DeleteProfileResponse({required this.status, required this.data});

  factory DeleteProfileResponse.fromJson(Map<String, dynamic> json) {
    return DeleteProfileResponse(
      status: json['status'] ?? '',
      data: json['data'] ?? '',
    );
  }
}
