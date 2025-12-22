import 'package:eshhtikiyl_app/core/utils/auth_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/datasources/profile_remote_data_source.dart';
import '../bloc/update_profile_bloc/bloc_update_profile.dart';
import '../bloc/update_profile_bloc/event_update_profile.dart';
import '../bloc/update_profile_bloc/state_update_profile.dart';
import '../../data/models/update_profile/request_model_update_profile.dart';
import '../../../../core/utils/validate.dart';
import '../../../../core/utils/password_requirements.dart';
import '../../../../core/utils/toast_services.dart';

class EditProfilePage extends StatefulWidget {
  final ProfileRemoteDataSource remoteDataSource;

  const EditProfilePage({super.key, required this.remoteDataSource});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController oldPasswordController = TextEditingController();

  bool _obscurePassword = true;

  @override
  void initState() {
    super.initState();
    context.read<UpdateProfileBloc>().add(LoadProfile());
    passwordController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    nameController.dispose();
    phoneController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void _saveProfile() {

    if (_formKey.currentState!.validate()) {
      final request = UpdateProfileRequest(
        name: nameController.text,
        phoneNumber: phoneController.text,
        password:
            passwordController.text.isEmpty ? null : passwordController.text,
        old_password: oldPasswordController.text,
      );
      context.read<UpdateProfileBloc>().add(UpdateProfileData(request));
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
        ),        title: const Text("تعديل الملف الشخصي",
            style: TextStyle(fontFamily: 'Almarai')),
        backgroundColor: const Color.fromARGB(168, 10, 60, 58),
      ),
      body: BlocConsumer<UpdateProfileBloc, UpdateProfileState>(
        listener: (context, state) {
          if (state is ProfileUpdated) {
            ToastService.showSuccess(context, state.message);
            Navigator.pop(context);
          } else if (state is ProfileError) {
            ToastService.showError(context, state.error);
          } else if (state is ProfileLoaded) {
            nameController.text = state.user.name;
            phoneController.text = state.user.phone_number;
          }
        },
        builder: (context, state) {
          if (state is ProfileLoading) {
            return const Center(
                child: CircularProgressIndicator(color: Colors.teal));
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  _buildTextField(
                    controller: nameController,
                    label: "الاسم",
                    icon: Icons.person,
                    validator: Validate.validateName,
                  ),
                  const SizedBox(height: 12),
                  _buildTextField(
                    controller: phoneController,
                    label: "رقم الهاتف",
                    icon: Icons.phone,
                    keyboardType: TextInputType.phone,
                    validator: Validate.validatePhoneNumber,
                  ),
                const SizedBox(height: 12),
                _buildTextField(
                  controller: passwordController,
                  label: "كلمة المرور (اختياري)",
                  icon: Icons.lock,
                  obscureText: _obscurePassword,
                  keyboardType: TextInputType.visiblePassword,
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePassword
                          ? Icons.visibility_off
                          : Icons.visibility,
                      color: Colors.white70,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscurePassword = !_obscurePassword;
                      });
                    },
                  ),
                  validator: (value) {
                    if (value != null && value.isNotEmpty) {
                      return Validate.validatePassword(value);
                    }
                    return null;
                    },
                  ),
                  const SizedBox(height: 24),
                  _buildTextField(
                    controller: oldPasswordController,
                    label: " كلمة المرور القديمة",
                    icon: Icons.lock,
                    obscureText: _obscurePassword,
                    keyboardType: TextInputType.visiblePassword,
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.teal[300],
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12)),
                      ),
                      onPressed: state is ProfileLoading ? null : _saveProfile,
                      child: const Text(
                        "حفظ التعديلات",
                        style: TextStyle(fontSize: 16, fontFamily: 'Almarai'),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    bool obscureText = false,
    Widget? suffixIcon,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      style: const TextStyle(color: Colors.white),
      validator: validator,
      decoration: InputDecoration(
        prefixIcon: Icon(icon, color: Colors.teal[200]),
        labelText: label,
        labelStyle: const TextStyle(color: Colors.tealAccent),
        filled: true,
        fillColor: Colors.white.withOpacity(0.1),
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none),
        suffixIcon: suffixIcon,
      ),
    );
  }
}
