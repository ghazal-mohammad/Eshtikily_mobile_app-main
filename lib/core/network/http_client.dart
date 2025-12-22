import 'dart:convert';
import 'package:eshhtikiyl_app/core/network/exceptions.dart';
import 'package:http/http.dart' as http;

import '../constants/api_constants.dart';
import '../utils/auth_storage.dart';
import '../utils/logger.dart';
import '../utils/app_messages.dart';

class HttpClient {
  static const Map<String, String> _defaultHeaders = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };

  Future<Map<String, dynamic>> post({
    required String endpoint,
    required Map<String, dynamic> data,
    bool requiresAuth = false,
  }) async {
    // print("REQUEST URL => $url");
    print("REQUEST BODY => ${jsonEncode(data)}");

    return _sendRequest(
      method: 'POST',
      endpoint: endpoint,
      data: data,
      requiresAuth: requiresAuth,
    );
  }

  Future<Map<String, dynamic>> get({
    required String endpoint,
    bool requiresAuth = false,
  }) async {
    return _sendRequest(
      method: 'GET',
      endpoint: endpoint,
      requiresAuth: requiresAuth,
    );
  }

  Future<bool> ping() async {
    try {
      final response = await http
          .get(Uri.parse('${ApiConstants.baseUrl}/'))
          .timeout(const Duration(seconds: 5));
      return response.statusCode == 200;
    } catch (_) {
      return false;
    }
  }

  Future<Map<String, dynamic>> _sendRequest({
    required String method,
    required String endpoint,
    Map<String, dynamic>? data,
    bool requiresAuth = false,
  }) async {
    try {
      final url = Uri.parse('${ApiConstants.baseUrl}$endpoint');
      final headers = Map<String, String>.from(_defaultHeaders);

      if (requiresAuth) {
        final token = await AuthStorage.getAuthToken();
        if (token == null) throw ApiException('لم يتم العثور على رمز الجلسة', 401);
        headers['Authorization'] = 'Bearer $token';
      }

      http.Response response;

      if (method == 'POST') {
        response = await http
            .post(
          url,
          headers: headers,
          body: data != null ? json.encode(data) : null,
        )
            .timeout(const Duration(seconds: ApiConstants.timeoutSeconds));
      } else if (method == 'GET') {
        response = await http
            .get(url, headers: headers)
            .timeout(const Duration(seconds: ApiConstants.timeoutSeconds));
      } else {
        throw ApiException('طريقة الطلب غير مدعومة: $method', 400);
      }

      return _handleResponse(response);
    } on ApiException {
      rethrow;
    } on http.ClientException catch (e) {
      throw NetworkException('فشل الاتصال بالخادم: ${e.message}');
    } on Exception catch (e) {
      throw NetworkException(_simplifyError(e));
    }
  }

  Map<String, dynamic> _handleResponse(http.Response response) {
    if (response.statusCode == 401) {
      AuthStorage.clearAllData();
      throw ApiException('انتهت الجلسة. يرجى تسجيل الدخول مرة أخرى.', 401);
    }

    // if (response.body.isEmpty) {
    //   throw ApiException(AppMessages.serverError, response.statusCode);
    // }

    try {
      final jsonResponse = json.decode(response.body);

      if (response.statusCode >= 200 && response.statusCode < 300) {
        return jsonResponse;
      } else {
        print("422 RAW BODY => ${response.body}");

        // ✅ 422 Validation: طلع أول رسالة خطأ من Laravel بدل رسالة عامة
        if (response.statusCode == 422 && jsonResponse is Map<String, dynamic>) {
          final errors = jsonResponse['errors'];

          if (errors is Map && errors.isNotEmpty) {
            final firstKey = errors.keys.first;
            final firstVal = errors[firstKey];

            if (firstVal is List && firstVal.isNotEmpty) {
              throw ApiException(firstVal.first.toString(), 422);
            } else {
              throw ApiException(firstVal.toString(), 422);
            }
          }

          // إذا ما رجعت errors لأي سبب
          throw ApiException(jsonResponse['message']?.toString() ?? 'بيانات غير صحيحة', 422);
        }

        throw ApiException(
          _getErrorMessage(jsonResponse is Map<String, dynamic> ? jsonResponse : {}, response.statusCode),
          response.statusCode,
        );
      }

    } catch (_) {
      throw ApiException(AppMessages.serverError, response.statusCode);
    }
  }

  String _getErrorMessage(Map<String, dynamic> json, int statusCode) {
    final message = (json['message'] ?? json['error'] ?? '').toString().toLowerCase();

    switch (statusCode) {
      case 422:
        return message.contains('phone') ? 'رقم الهاتف مستخدم مسبقاً' : 'بيانات غير صحيحة';
      case 404:
        return 'لم يتم العثور على الصفحة';
      case 403:
        return 'لا تملك الصلاحية';
      case 500:
        return AppMessages.serverError;
    }

    if (message.contains('email has already been taken')) return AppMessages.emailAlreadyExists;
    if (message.contains('phone number has already been taken')) return 'رقم الهاتف مستخدم';
    if (message.contains('verification code') || message.contains('wrong code')) {
      return AppMessages.invalidVerificationCode;
    }
    if (message.contains('credentials do not match')) return AppMessages.invalidCredentials;
    if (message.contains('unauthenticated') || message.contains('token')) {
      return AppMessages.unauthorized;
    }

    return 'حدث خطأ (رمز: $statusCode)';
  }

  String _simplifyError(dynamic error) {
    final errorStr = error.toString();

    if (errorStr.contains('Timeout') || errorStr.contains('Socket')) {
      return 'فشل الاتصال بالخادم';
    }

    if (errorStr.contains('Format') || errorStr.contains('JSON')) {
      return AppMessages.serverError;
    }

    return 'حدث خطأ غير متوقع';
  }
}
