
import '../../../data/models/resendCode/resend_code_request.dart';

abstract class ResendCodeEvent {}

class ResendCodeSubmitted extends ResendCodeEvent {
  final ResendCodeRequest request;

  ResendCodeSubmitted({required this.request});
}