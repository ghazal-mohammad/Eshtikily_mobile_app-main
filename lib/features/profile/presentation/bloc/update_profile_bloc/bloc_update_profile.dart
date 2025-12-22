import 'package:eshhtikiyl_app/features/profile/presentation/bloc/update_profile_bloc/event_update_profile.dart';
import 'package:eshhtikiyl_app/features/profile/presentation/bloc/update_profile_bloc/state_update_profile.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/datasources/profile_remote_data_source.dart';


class UpdateProfileBloc extends Bloc<UpdateProfileEvent, UpdateProfileState> {
  final ProfileRemoteDataSource remoteDataSource;

  UpdateProfileBloc({required this.remoteDataSource}) : super(ProfileInitial()) {
    on<LoadProfile>((event, emit) async {
      emit(ProfileLoading());
      try {
        final profile = await remoteDataSource.getProfile();
        emit(ProfileLoaded(profile.user));
      } catch (e) {
        emit(ProfileError(e.toString()));
      }
    });

    on<UpdateProfileData>((event, emit) async {
      emit(ProfileLoading());
      try {
        final response = await remoteDataSource.updateProfile(event.request);
        emit(ProfileUpdated(message: response.message, user: response.user));
      } catch (e) {
        emit(ProfileError(e.toString()));
      }
    });
  }
}
