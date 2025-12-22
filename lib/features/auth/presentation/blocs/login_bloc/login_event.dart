
import '../../../data/models/login/login_request.dart';

abstract class LoginEvent {}

class LoginSubmitted extends LoginEvent {
  final LoginRequest request;

  LoginSubmitted({required this.request});
}