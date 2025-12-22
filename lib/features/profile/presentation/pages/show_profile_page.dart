import 'package:eshhtikiyl_app/core/network/http_client.dart';
import 'package:eshhtikiyl_app/features/profile/presentation/pages/delete_profile_page.dart';
import 'package:eshhtikiyl_app/features/profile/presentation/pages/update_profile_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/routes/app_routes.dart';
import '../../data/datasources/profile_remote_data_source.dart';
import '../bloc/update_profile_bloc/bloc_update_profile.dart';
import '../../../auth/data/models/verifyCode/verify_code_response.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  UserData? user;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchProfile();
  }

  Future<void> fetchProfile() async {
    try {
      final dataSource = ProfileRemoteDataSource(httpClient: HttpClient());
      final response = await dataSource.getProfile();
      setState(() {
        user = response.user;
        isLoading = false;
      });
    } catch (e) {
      setState(() => isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('حدث خطأ: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A3C3A),
      appBar: AppBar(
        leading: IconButton(
          icon:  Icon(Icons.arrow_back,
            color: Colors.teal[400],
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),        backgroundColor: const Color.fromARGB(168, 10, 60, 58),
        title: const Text(
          "الملف الشخصي",
          style: TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontFamily: 'Almarai',
            fontWeight: FontWeight.w600,
          ),
        ),
        elevation: 4,
        shadowColor: Colors.black.withOpacity(0.3),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
        ),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator(color: Colors.teal))
          : user == null
              ? const Center(
                  child: Text("لا توجد بيانات",
                      style: TextStyle(color: Colors.white)))
              : ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    _buildProfileCard("الاسم", user!.name, Icons.person),
                    _buildProfileCard(
                        "البريد الإلكتروني", user!.email, Icons.email),
                    _buildProfileCard(
                        "رقم الهاتف", user!.phone_number, Icons.phone),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildActionButton("تعديل", Icons.edit, Colors.teal,
                            () {
                          final remoteDataSource =
                              ProfileRemoteDataSource(httpClient: HttpClient());

                          Navigator.pushNamed(
                            context,
                            AppRoutes.editProfile,
                            arguments: remoteDataSource,
                          ).then((_) => fetchProfile());
                        }),
                        _buildActionButton("حذف", Icons.delete, Colors.red, () {
                          Navigator.pushNamed(context, AppRoutes.deleteProfile);
                        }),
                      ],
                    )
                  ],
                ),
    );
  }

  Widget _buildProfileCard(String title, String value, IconData icon) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      color: const Color(0xFF1A4A47),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: Icon(icon, color: Colors.teal[300]),
        title: Text(title,
            style: const TextStyle(color: Colors.white, fontFamily: 'Almarai')),
        subtitle: Text(value,
            style: TextStyle(color: Colors.teal[100], fontFamily: 'Almarai')),
      ),
    );
  }

  Widget _buildActionButton(
      String label, IconData icon, Color color, VoidCallback onTap) {
    return ElevatedButton.icon(
      onPressed: onTap,
      icon: Icon(icon, color: Colors.white),
      label: Text(label, style: const TextStyle(color: Colors.white)),
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}
