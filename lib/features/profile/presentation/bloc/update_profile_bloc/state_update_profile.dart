import '../../../../auth/data/models/verifyCode/verify_code_response.dart';

abstract class UpdateProfileState {}

class ProfileInitial extends UpdateProfileState {}

class ProfileLoading extends UpdateProfileState {}

class ProfileLoaded extends UpdateProfileState {
  final UserData user;
  ProfileLoaded(this.user);
}

class ProfileUpdated extends UpdateProfileState {
  final String message;
  final UserData user;
  ProfileUpdated({required this.message, required this.user});
}

class ProfileError extends UpdateProfileState {
  final String error;
  ProfileError(this.error);
}
