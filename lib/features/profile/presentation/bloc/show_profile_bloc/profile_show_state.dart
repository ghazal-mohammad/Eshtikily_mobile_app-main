import '../../../data/models/show_profile.dart';

abstract class ProfileState {}

class ProfileInitial extends ProfileState {}

class ProfileLoading extends ProfileState {}

class ProfileSuccess extends ProfileState {
  final UserProfileResponse profile;

  ProfileSuccess({required this.profile});
}

class ProfileFailure extends ProfileState {
  final String error;

  ProfileFailure({required this.error});
}
