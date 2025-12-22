import 'package:eshhtikiyl_app/features/profile/presentation/bloc/delete_profile_bloc/delete_profile_event.dart';
import 'package:eshhtikiyl_app/features/profile/presentation/bloc/delete_profile_bloc/delete_profile_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/datasources/profile_remote_data_source.dart';


class DeleteProfileBloc extends Bloc<DeleteProfileEvent, DeleteProfileState> {
  final ProfileRemoteDataSource remoteDataSource;

  DeleteProfileBloc({required this.remoteDataSource}) : super(DeleteProfileInitial()) {
    on<DeleteProfileSubmitted>(_onDeleteProfile);
  }

  Future<void> _onDeleteProfile(
      DeleteProfileSubmitted event,
      Emitter<DeleteProfileState> emit,
      ) async {
    emit(DeleteProfileLoading());

    try {
      final message = await remoteDataSource.deleteProfile(password: event.password);
      emit(DeleteProfileSuccess(message: message));
    } catch (e) {
      emit(DeleteProfileFailure(error: e.toString()));
    }
  }
}
