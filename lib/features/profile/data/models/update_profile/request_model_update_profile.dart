class UpdateProfileRequest {
  final String? name;
  final String? phoneNumber;
  final String? password;
  final String? old_password;

  UpdateProfileRequest({this.name, this.phoneNumber, this.password, this.old_password});

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    if (name != null) data['name'] = name;
    if (phoneNumber != null) data['phone_number'] = phoneNumber;
    if (password != null) data['password'] = password;
    if (old_password != null) data['old_password'] = old_password;
    return data;
  }
}
