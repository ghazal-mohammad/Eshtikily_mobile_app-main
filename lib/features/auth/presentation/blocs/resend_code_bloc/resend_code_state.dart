
import '../../../data/models/resendCode/resende_code_response.dart';

abstract class ResendCodeState {}

class ResendCodeInitial extends ResendCodeState {}

class ResendCodeLoading extends ResendCodeState {}

class ResendCodeSuccess extends ResendCodeState {
  final ResendCodeResponse response;

  ResendCodeSuccess({required this.response});
}

class ResendCodeFailure extends ResendCodeState {
  final String error;

  ResendCodeFailure({required this.error});
}