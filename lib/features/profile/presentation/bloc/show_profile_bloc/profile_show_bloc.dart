import 'package:bloc/bloc.dart';
import 'package:eshhtikiyl_app/features/profile/presentation/bloc/show_profile_bloc/profile_show_state.dart';
import '../../../data/datasources/profile_remote_data_source.dart';
import 'profile_event.dart';


class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final ProfileRemoteDataSource remoteDataSource;

  ProfileBloc({required this.remoteDataSource}) : super(ProfileInitial()) {
    on<ProfileRequested>(_onProfileRequested);
  }

  Future<void> _onProfileRequested(
      ProfileRequested event,
      Emitter<ProfileState> emit,
      ) async {
    emit(ProfileLoading());
    try {
      final response = await remoteDataSource.getProfile();
      print('profillle :$response');
      emit(ProfileSuccess(profile: response));
    } catch (e) {
      print('eeerrrrrrrrrooor ');
      emit(ProfileFailure(error: e.toString()));
    }
  }
}
