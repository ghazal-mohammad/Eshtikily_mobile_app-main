import 'package:eshhtikiyl_app/features/home/presentation/models/more_menu_item.dart';
import 'package:flutter/material.dart';

import '../../../../core/routes/app_routes.dart';
import '../../../../core/services/logout_srevice.dart';
import '../../../profile/presentation/pages/show_profile_page.dart';

class MoreTab extends StatelessWidget {
  const MoreTab({super.key});

  static final List<MoreMenuItem> _menuItems = [
    MoreMenuItem(
      icon: Icons.person_outline,
      title: "الملف الشخصي",
      iconColor: Colors.blue[200],
      onTap: (context) {
        Navigator.pushNamed(context, AppRoutes.profile);
      },
    ),
    MoreMenuItem(
      icon: Icons.settings_outlined,
      title: "الإعدادات",
      iconColor: Colors.amber[200],
      onTap: (context) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("صفحة الإعدادات قريباً..."),
          ),
        );
      },
    ),
    MoreMenuItem(
      icon: Icons.help_outline,
      title: "المساعدة والدعم",
      iconColor: Colors.green[200],
      onTap: (context) {},
    ),
    MoreMenuItem(
      icon: Icons.logout,
      title: "تسجيل الخروج",
      iconColor: Colors.red[200],
      onTap: (context) {
        LogoutService.handleLogout(context);
      },
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A3C3A),
      appBar: _buildAppBar(),
      body: _buildMenuList(context),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      automaticallyImplyLeading: false,
      title: const Row(
        children: [
          Icon(Icons.more_horiz, color: Colors.white, size: 28),
          SizedBox(width: 12),
          Text(
            'المزيد',
            style: TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontFamily: 'Almarai',
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
      centerTitle: false,
      backgroundColor: const Color(0xFF1A4A48),
      elevation: 0,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          bottom: Radius.circular(20),
        ),
      ),
    );
  }

  Widget _buildMenuList(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Column(
        children: [
          _buildUserCard(),
          Expanded(
            child: ListView.separated(
              itemCount: _menuItems.length,
              separatorBuilder: (_, __) => const Divider(
                color: Colors.white12,
                height: 1,
                indent: 72,
              ),
              itemBuilder: (context, index) {
                return _buildMenuItem(context, _menuItems[index]);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUserCard() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
      ),
      child: Row(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: Colors.teal.withOpacity(0.3),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.person,
              color: Colors.white,
              size: 30,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "مرحباً بك",
                  style: TextStyle(
                    color: Colors.teal[200],
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  "يمكنك الوصول إلى جميع خيارات التطبيق من هنا",
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem(BuildContext context, MoreMenuItem item) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      leading: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color:
              item.iconColor?.withOpacity(0.2) ?? Colors.white.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(item.icon, color: item.iconColor ?? Colors.white),
      ),
      title: Text(
        item.title,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
      ),
      trailing: Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.05),
          shape: BoxShape.circle,
        ),
        child: const Icon(
          Icons.arrow_forward_ios,
          color: Colors.white54,
          size: 16,
        ),
      ),
      onTap: () => item.onTap(context),
    );
  }
}
