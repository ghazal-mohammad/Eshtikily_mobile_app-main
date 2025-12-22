import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/network/http_client.dart';
import '../../../../core/routes/app_routes.dart';
import '../../data/datasources/profile_remote_data_source.dart';
import '../../../../widgets/gold_text_field.dart';
import '../../../../widgets/gold_btn.dart';
import '../../../../core/utils/toast_services.dart';
import '../bloc/delete_profile_bloc/delete_profile_bloc.dart';
import '../bloc/delete_profile_bloc/delete_profile_event.dart';
import '../bloc/delete_profile_bloc/delete_profile_state.dart';

class DeleteProfilePage extends StatefulWidget {
  const DeleteProfilePage({super.key});

  @override
  State<DeleteProfilePage> createState() => _DeleteProfilePageState();
}

class _DeleteProfilePageState extends State<DeleteProfilePage> {
  final _passwordCtrl = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _obscurePassword = true;

  DeleteProfileBloc _createBloc() {
    return DeleteProfileBloc(
      remoteDataSource: ProfileRemoteDataSource(httpClient: HttpClient()),
    );
  }

  Future<bool?> _showConfirmationDialog(BuildContext context) {
    return showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (_) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        backgroundColor: const Color(0xFF0A3C3A),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'تأكيد الحذف',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontFamily: 'Almarai',
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                'هل أنت متأكد من أنك تريد حذف حسابك؟ هذه العملية لا يمكن التراجع عنها.',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.white70,
                  fontFamily: 'Almarai',
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context, false),
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Colors.white24),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      child: const Text(
                        'إلغاء',
                        style: TextStyle(
                            color: Colors.white70, fontFamily: 'Almarai'),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => Navigator.pop(context, true),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      child: const Text(
                        'حذف',
                        style: TextStyle(
                            color: Colors.white, fontFamily: 'Almarai'),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _confirmDelete(BuildContext context) async {
    final confirmed = await _showConfirmationDialog(context);
    if (confirmed ?? false) {
      _handleDelete(context);
    }
  }

  void _handleDelete(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      context.read<DeleteProfileBloc>().add(
            DeleteProfileSubmitted(password: _passwordCtrl.text),
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => _createBloc(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text("حذف الحساب"),
          leading: IconButton(
            icon:  Icon(Icons.arrow_back,
              color: Colors.teal[400],
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),        ),
        body: BlocListener<DeleteProfileBloc, DeleteProfileState>(
          listener: (context, state) {
            if (state is DeleteProfileSuccess) {
              ToastService.showSuccess(context, state.message);
              Navigator.pushNamedAndRemoveUntil(
                  context, AppRoutes.login, (route) => false);
            } else if (state is DeleteProfileFailure) {
              ToastService.showError(context, state.error);
            }
          },
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GoldTextField(
                    controller: _passwordCtrl,
                    hint: 'أدخل كلمة المرور لتأكيد الحذف',
                    obscure: _obscurePassword,
                    validator: (txt) => txt == null || txt.isEmpty
                        ? 'يرجى إدخال كلمة المرور'
                        : null,
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
                  ),
                  const SizedBox(height: 20),
                  BlocBuilder<DeleteProfileBloc, DeleteProfileState>(
                    builder: (context, state) {
                      return GoldButton(
                        label: state is DeleteProfileLoading
                            ? 'جاري الحذف...'
                            : 'حذف الحساب',
                        onTap: state is DeleteProfileLoading
                            ? null
                            : () => _confirmDelete(context),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _passwordCtrl.dispose();
    super.dispose();
  }
}
