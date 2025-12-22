import 'package:eshhtikiyl_app/background_message_handler.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';

import 'core/routes/app_routes.dart';
import 'core/services/login_protection_service.dart';
import 'core/services/notification_services.dart';
import 'core/utils/auth_storage.dart';

import 'core/routes/app_router.dart';
import 'features/home/presentation/pages/home_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await _initializeApp();
  runApp(const MyApp());
}

Future<void> _initializeApp() async {
  try {
    await Firebase.initializeApp(
      options: const FirebaseOptions(
        apiKey: "AIzaSyC19OHwq0BeMVKw5q3nft5liuzJtnzz6RI",
        appId: "1:95532699305:android:1e9ff37061bf6953e2e3b8",
        messagingSenderId: "95532699305",
        projectId: "vendorslist-8abd3",
      ),
    );

    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

    await NotificationService.initialize();
    await LoginProtectionService.initialize();
  } catch (e) {
    print('خطأ في تهيئة التطبيق: $e');
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'تطبيق الشكاوى الحكومية',
      debugShowCheckedModeBanner: false,
      theme: _buildTheme(),
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('ar', 'AE'),
        Locale('en', 'US'),
      ],
      locale: const Locale('ar', 'AE'),
      initialRoute: AppRoutes.login,
      onGenerateRoute: AppRouter.generateRoute,
    );
  }

  ThemeData _buildTheme() {
    return ThemeData(
      primarySwatch: Colors.teal,
      scaffoldBackgroundColor: const Color(0xFF0A3C3A),
      fontFamily: 'Almarai',
      appBarTheme: const AppBarTheme(
        backgroundColor: Color.fromARGB(168, 10, 60, 58),
        elevation: 3.0,
        titleTextStyle: TextStyle(
          fontFamily: 'Almarai',
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
      textTheme: const TextTheme(
        displayLarge: TextStyle(
          fontFamily: 'Almarai',
          fontSize: 28,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
        displayMedium: TextStyle(
          fontFamily: 'Almarai',
          fontSize: 22,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
        bodyLarge: TextStyle(
          fontFamily: 'Almarai',
          fontSize: 16,
          color: Colors.white,
        ),
        bodyMedium: TextStyle(
          fontFamily: 'Almarai',
          fontSize: 14,
          color: Colors.white70,
        ),
      ),
    );
  }
}

// class _AppLoader extends StatefulWidget {
//   const _AppLoader({super.key});
//
//   @override
//   State<_AppLoader> createState() => _AppLoaderState();
// }
//
// class _AppLoaderState extends State<_AppLoader> {
//   Future<bool> _checkLoginStatus() async {
//     try {
//       return await AuthStorage.isLoggedIn();
//     } catch (e) {
//       return false;
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return FutureBuilder<bool>(
//       future: _checkLoginStatus(),
//       builder: (context, snapshot) {
//         if (snapshot.connectionState == ConnectionState.waiting) {
//           return _buildSplashScreen();
//         }
//
//         final isLoggedIn = snapshot.data ?? false;
//
//         // Navigate after build complete
//         WidgetsBinding.instance.addPostFrameCallback((_) {
//           if (isLoggedIn) {
//             Navigator.pushReplacementNamed(context, '/home');
//           } else {
//             Navigator.pushReplacementNamed(context, '/login');
//           }
//         });
//
//         return Container(color: const Color(0xFF0A3C3A));
//       },
//     );
//   }
//
//   Widget _buildSplashScreen() {
//     return Scaffold(
//       backgroundColor: const Color(0xFF0A3C3A),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Container(
//               width: 120,
//               height: 120,
//               decoration: BoxDecoration(
//                 color: Colors.white.withOpacity(0.1),
//                 borderRadius: BorderRadius.circular(8),
//                 image: const DecorationImage(
//                   image: AssetImage('assets/images/logo.png'),
//                   fit: BoxFit.contain,
//                 ),
//               ),
//               child: const Icon(
//                 Icons.gavel,
//                 size: 60,
//                 color: Colors.white,
//               ),
//             ),
//             const SizedBox(height: 20),
//             const CircularProgressIndicator(
//               valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
//             ),
//             const SizedBox(height: 20),
//             const Text(
//               'جاري التحميل...',
//               style: TextStyle(
//                 color: Colors.white,
//                 fontSize: 16,
//                 fontFamily: 'Almarai',
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
