class DeleteProfileRequest {
  final String password;

  DeleteProfileRequest({required this.password});

  Map<String, dynamic> toJson() {
    return {
      'password': password,
    };
  }
}
