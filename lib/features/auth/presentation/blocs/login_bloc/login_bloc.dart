import 'package:bloc/bloc.dart';
import 'package:eshhtikiyl_app/features/auth/presentation/blocs/login_bloc/login_event.dart';
import 'package:eshhtikiyl_app/features/auth/presentation/blocs/login_bloc/login_state.dart';
import '../../../../../core/utils/auth_storage.dart';
import '../../../data/datasources/auth_remote_data_source.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final AuthRemoteDataSource remoteDataSource;

  LoginBloc({required this.remoteDataSource}) : super(LoginInitial()) {
    on<LoginSubmitted>(_onLoginSubmitted);
  }

  Future<void> _onLoginSubmitted(
      LoginSubmitted event,
      Emitter<LoginState> emit,
      ) async {
    emit(LoginLoading());

    try {
      final response = await remoteDataSource.login(event.request);
     var token=  await AuthStorage.getAuthToken();
      print('token is : $token');

      emit(LoginSuccess(response: response));
    } catch (e) {
      emit(LoginFailure(error: e.toString()));
    }
  }
}