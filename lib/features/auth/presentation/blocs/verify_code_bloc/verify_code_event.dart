
import '../../../data/models/verifyCode/verify_code_request.dart';

abstract class VerificationEvent {}

class VerificationSubmitted extends VerificationEvent {
  final VerificationRequest request;

  VerificationSubmitted({required this.request});
}