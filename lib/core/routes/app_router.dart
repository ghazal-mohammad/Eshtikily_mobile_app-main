import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../features/auth/presentation/pages/gold_login_page.dart';
import '../../features/auth/presentation/pages/gold_signup_page.dart';
import '../../features/auth/presentation/pages/gold_verification_page.dart';
import '../../features/home/presentation/pages/home_page.dart';
import '../../features/complaints/complaint_list.dart';
import '../../features/complaints/create_complaint.dart';
import '../../features/home/presentation/widgets/notifications_page.dart';
import '../../features/profile/presentation/bloc/update_profile_bloc/bloc_update_profile.dart';
import '../../features/profile/presentation/pages/show_profile_page.dart';
import '../../features/profile/presentation/pages/update_profile_page.dart';
import '../../features/profile/presentation/pages/delete_profile_page.dart';
import '../widgets/app_loader.dart';
import 'app_routes.dart';

class AppRouter {
  static Route<dynamic>? generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.loader:
        return MaterialPageRoute(builder: (_) => const AppLoader());

      case AppRoutes.login:
        return MaterialPageRoute(builder: (_) => const LoginPage());

      case AppRoutes.signup:
        return MaterialPageRoute(builder: (_) => const SignupPage());

      case AppRoutes.verification:
        final email = settings.arguments as String?;
        if (email != null) {
          return MaterialPageRoute(builder: (_) => VerificationPage(email: email));
        }
        return _errorRoute();

      case AppRoutes.home:
        return MaterialPageRoute(builder: (_) => const HomePage());

      case AppRoutes.complaintList:
        return MaterialPageRoute(builder: (_) => const ListComplaintsPage());

      case AppRoutes.createComplaint:
        return MaterialPageRoute(builder: (_) => const CreateComplaintPage());

      case AppRoutes.notifications:
        return MaterialPageRoute(builder: (_) => const NotificationsPage());

      case AppRoutes.profile:
        return MaterialPageRoute(builder: (_) => const ProfilePage());

      case AppRoutes.editProfile:

        final remoteDataSource = settings.arguments as dynamic;
        return MaterialPageRoute(
          builder: (_) => BlocProvider<UpdateProfileBloc>(
            create: (_) => UpdateProfileBloc(remoteDataSource: remoteDataSource),
            child: EditProfilePage(remoteDataSource: remoteDataSource),
          ),
        );

      case AppRoutes.deleteProfile:
        return MaterialPageRoute(builder: (_) => const DeleteProfilePage());

      default:
        return _errorRoute();
    }
  }

  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(
      builder: (_) => const Scaffold(
        body: Center(child: Text('الصفحة غير موجودة')),
      ),
    );
  }
}
