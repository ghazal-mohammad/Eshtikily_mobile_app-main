import '../../../data/models/update_profile/request_model_update_profile.dart';

abstract class UpdateProfileEvent {}

class LoadProfile extends UpdateProfileEvent {}

class UpdateProfileData extends UpdateProfileEvent {
  final UpdateProfileRequest request;
  UpdateProfileData(this.request);
}
