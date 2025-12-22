import 'package:bloc/bloc.dart';
import 'package:eshhtikiyl_app/features/auth/presentation/blocs/resend_code_bloc/resend_code_event.dart';
import 'package:eshhtikiyl_app/features/auth/presentation/blocs/resend_code_bloc/resend_code_state.dart';
import '../../../data/datasources/auth_remote_data_source.dart';


class ResendCodeBloc extends Bloc<ResendCodeEvent, ResendCodeState> {
  final AuthRemoteDataSource remoteDataSource;

  ResendCodeBloc({required this.remoteDataSource}) : super(ResendCodeInitial()) {
    on<ResendCodeSubmitted>(_onResendCodeSubmitted);
  }

  Future<void> _onResendCodeSubmitted(
      ResendCodeSubmitted event,
      Emitter<ResendCodeState> emit,
      ) async {
    emit(ResendCodeLoading());

    try {
      final response = await remoteDataSource.resendVerificationCode(event.request);
      emit(ResendCodeSuccess(response: response));
    } catch (e) {
      emit(ResendCodeFailure(error: e.toString()));
    }
  }
}