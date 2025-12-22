
import '../utils/app_messages.dart';

/// معالج أخطاء مبسط
class ErrorHandler {
static String apiError(dynamic error) {
if (error is String) return _simplifyMessage(error);

final msg = error.toString();

// الأخطاء الشائعة فقط
if (msg.contains('Timeout')) return AppMessages.timeoutError;
if (msg.contains('Socket') || msg.contains('Network')) return AppMessages.networkError;
if (msg.contains('401') || msg.contains('Unauthorized')) return AppMessages.unauthorized;
if (msg.contains('Format') || msg.contains('JSON')) return AppMessages.serverError;

return AppMessages.unknownError;
}

static String _simplifyMessage(String error) {
final msg = error.toLowerCase();

// الرسائل المهمة فقط
if (msg.contains('email') && msg.contains('taken')) return AppMessages.emailAlreadyExists;
if (msg.contains('verification') || msg.contains('wrong code')) return AppMessages.invalidVerificationCode;
if (msg.contains('credentials')) return AppMessages.invalidCredentials;
if (msg.contains('server')) return AppMessages.serverError;

// إذا كانت قصيرة وغير تقنية
if (error.length < 50 && !_isTechnical(error)) return error;

return AppMessages.unknownError;
}

static bool _isTechnical(String msg) {
final tech = ['exception', 'error', 'failed', 'sql', 'database'];
return tech.any((t) => msg.contains(t));
}
}
