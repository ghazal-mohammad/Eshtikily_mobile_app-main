
import 'package:eshhtikiyl_app/core/network/http_client.dart';
import 'package:eshhtikiyl_app/core/utils/auth_storage.dart';

import '../../../../core/network/api_endpoints.dart';
import '../../../../core/utils/logger.dart';
import '../models/login/login_request.dart';
import '../models/login/login_response.dart';
import '../models/register/register_request.dart';
import '../models/register/register_response.dart';
import '../models/resendCode/resend_code_request.dart';
import '../models/resendCode/resende_code_response.dart';
import '../models/verifyCode/verify_code_request.dart';
import '../models/verifyCode/verify_code_response.dart';

class AuthRemoteDataSource {
  final HttpClient httpClient;

  AuthRemoteDataSource({required this.httpClient});

  Future<RegisterResponse> register(RegisterRequest request) async {
    try {
      Logger.info('Starting registration');

      final response = await httpClient.post(
        endpoint: ApiEndpoints.register,
        data: request.toJson(),
      );
      print("sssssssssssss$response");


      Logger.info('Registration successful');
      return RegisterResponse.fromJson(response);
    } catch (e) {
      print("REGISTER ERROR => $e");

      Logger.error('Registration failed', error: e);
      rethrow;
    }
  }

  Future<VerificationResponse> verifyCode(VerificationRequest request) async {
    try {
      Logger.info('Starting verification for: ${request.email}');

      final response = await httpClient.post(
        endpoint: ApiEndpoints.verifyCode,
        data: request.toJson(),
      );

      Logger.info('Verification successful for: ${request.email}');

      final verificationResponse = VerificationResponse.fromJson(response);

      await AuthStorage.saveAuthToken(verificationResponse.user.token);
      await AuthStorage.saveUserData(verificationResponse.user.toJson());

      return verificationResponse;
    } catch (e) {
      Logger.error('Verification failed for: ${request.email}', error: e);

      rethrow;
    }
  }

  Future<ResendCodeResponse> resendVerificationCode(ResendCodeRequest request) async {
    try {
      Logger.info('Resending verification code to: ${request.email}');

      final response = await httpClient.post(
        endpoint: ApiEndpoints.resendCode,
        data: request.toJson(),
        requiresAuth: false,
      );
      print("sssssssssssss$response");

      Logger.info('Resend successful for: ${request.email}');
      return ResendCodeResponse.fromJson(response);
    } catch (e) {
      print("exxxxxe$e");
      Logger.error('Resend failed for: ${request.email}', error: e);
      rethrow;
    }
  }

  Future<LoginResponse> login(LoginRequest request) async {
    try {
      Logger.info('Starting login for: ${request.email}');

      final response = await httpClient.post(
        endpoint: ApiEndpoints.login,
        data: request.toJson(),
      );

      Logger.info('Login successful for: ${request.email}');

      final loginResponse = LoginResponse.fromJson(response);

      await AuthStorage.saveAuthToken(loginResponse.user.token);
      await AuthStorage.saveUserData(loginResponse.user.toJson());

      return loginResponse;
    } catch (e) {
      Logger.error('Login failed for: ${request.email}', error: e);
      rethrow;
    }
  }

  Future<bool> logout() async {
    try {
      Logger.info('Starting logout process');

      await httpClient.post(
        endpoint: ApiEndpoints.logout,
        data: {},
        requiresAuth: true,
      );

      Logger.info('Logout successful');
      return true;
    } catch (e) {
      Logger.error('Logout failed', error: e);

      final msg = e.toString();

      if (msg.contains('401') || msg.contains('Unauthenticated')) {
        Logger.info('Token expired, treat as successful');
        return true;
      }

      return false;
    }
  }


}