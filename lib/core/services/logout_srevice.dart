import 'package:eshhtikiyl_app/core/network/http_client.dart';
import 'package:eshhtikiyl_app/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:flutter/material.dart';
import '../utils/auth_storage.dart';
import '../utils/toast_services.dart';

class LogoutService {
  static final _remote = AuthRemoteDataSource(httpClient: HttpClient());

  static Future<bool> showLogoutConfirmation(BuildContext context) async {
    return await showDialog<bool>(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            contentPadding: const EdgeInsets.symmetric(vertical: 20, horizontal: 15),
            titlePadding: const EdgeInsets.only(top: 20),

            title: Column(
              children: [
                Icon(Icons.logout, size: 45, color: Colors.red.shade400),
                const SizedBox(height: 10),
                const Text(
                  'تسجيل الخروج',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ],
            ),

            content: const Text(
              'هل أنت متأكد أنك تريد تسجيل الخروج؟',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
            ),

            actionsAlignment: MainAxisAlignment.center,
            actionsPadding: const EdgeInsets.only(bottom: 10, top: 10),

            actions: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey.shade300,
                  foregroundColor: Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () => Navigator.pop(context, false),
                child: const Text('إلغاء'),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red.shade400,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () => Navigator.pop(context, true),
                child: const Text('تسجيل الخروج'),
              ),
            ],
          ),
        );
      },
    ) ?? false;
  }

  static Future<bool> performLogout(BuildContext context) async {
    try {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => const Center(child: CircularProgressIndicator()),
      );

      final success = await _remote.logout();

      if (!success) {
        if (context.mounted) Navigator.pop(context);
        ToastService.showError(context, 'تعذّر الاتصال بالسيرفر، الرجاء المحاولة لاحقاً');
        return false;
      }

      await AuthStorage.clearAllData();

      if (context.mounted) Navigator.pop(context);

      if (context.mounted) {
        ToastService.showSuccess(context, 'تم تسجيل الخروج بنجاح');
        Navigator.pushNamedAndRemoveUntil(context, '/login', (_) => false);
      }

      return true;
    } catch (e) {
      if (context.mounted) Navigator.pop(context);
      ToastService.showError(context, 'حدث خطأ غير متوقع');
      return false;
    }
  }

  static Future<void> handleLogout(BuildContext context) async {
    if (await showLogoutConfirmation(context)) {
      await performLogout(context);
    }
  }
}
