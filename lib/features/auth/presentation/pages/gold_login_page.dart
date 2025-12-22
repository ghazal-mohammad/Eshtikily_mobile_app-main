import 'dart:async';

import 'package:eshhtikiyl_app/features/complaints/complaints_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import '../../../../../../../core/network/http_client.dart';
import '../../../../core/routes/app_routes.dart';
import '../../../../core/services/login_protection_service.dart';
import '../../../../core/utils/validate.dart';
import '../../../../../../../widgets/gold_btn.dart';
import '../../../../../../../widgets/gold_logo.dart';
import '../../../../../../../widgets/gold_text_field.dart';
import '../../../../core/utils/auth_storage.dart';
import '../../../../core/utils/toast_services.dart';
import '../../data/datasources/auth_remote_data_source.dart';
import '../../data/models/login/login_request.dart';
import '../../data/models/login/login_response.dart';
import '../blocs/login_bloc/login_bloc.dart';
import '../blocs/login_bloc/login_event.dart';
import '../blocs/login_bloc/login_state.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();


}

class _LoginPageState extends State<LoginPage> {
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _obscurePassword = true;
  Timer? _countdownTimer;
  int _refreshCounter = 0;

  @override
  void initState() {
    super.initState();
    _initializeProtectionService();
    _emailCtrl.addListener(_checkAccountStatus);
  }


  Future<void> _initializeProtectionService() async {
    await LoginProtectionService.initialize();
  }

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passCtrl.dispose();
    _countdownTimer?.cancel();
    super.dispose();
  }



  LoginBloc _createLoginBloc() {
    return LoginBloc(
      remoteDataSource: AuthRemoteDataSource(
        httpClient: HttpClient(),
      ),
    );
  }

  void _handleLogin(BuildContext context) {
    if (_isAccountLocked) {
      _showAccountLockedError();
      return;
    }

    if (_isTooFast) {
      _showTooFastError();
      return;
    }

    if (_formKey.currentState!.validate()) {
      final request = LoginRequest(
        email: _emailCtrl.text.trim(),
        password: _passCtrl.text,
      );

      context.read<LoginBloc>().add(LoginSubmitted(request: request));
    }
  }

  void _startCountdownTimer() {
    _countdownTimer?.cancel();

    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_isAccountLocked) {
        setState(() {
          _refreshCounter++;
        });

        if (!_isAccountLocked) {
          timer.cancel();
          setState(() {});
        }
      } else {
        timer.cancel();
      }
    });
  }

  void _checkAccountStatus() {
    final email = _emailCtrl.text.trim();
    if (email.isNotEmpty) {
      setState(() {});

      if (_isAccountLocked && (_countdownTimer == null || !_countdownTimer!.isActive)) {
        _startCountdownTimer();
      }
    }
  }

  bool get _isAccountLocked {
    final email = _emailCtrl.text.trim();
    return LoginProtectionService.isAccountLocked(email);
  }

  bool get _isTooFast {
    final email = _emailCtrl.text.trim();
    return LoginProtectionService.isTooFast(email);
  }

  int get _remainingAttempts {
    final email = _emailCtrl.text.trim();
    return LoginProtectionService.getRemainingAttempts(email);
  }

  String get _remainingTimeText {
    final email = _emailCtrl.text.trim();
    final remainingTime = LoginProtectionService.getRemainingLockTime(email);
    return LoginProtectionService.formatRemainingTime(remainingTime);
  }

  void _showAccountLockedError() {
    ToastService.showError(context, "الحساب مؤقتاً مغلق. يرجى المحاولة بعد $_remainingTimeText");
  }

  void _showTooFastError() {
    ToastService.showWarning(context, "يرجى الانتظار بضع ثواني قبل المحاولة مرة أخرى");
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => _createLoginBloc(),
      child: Scaffold(
        body: SafeArea(
          child: BlocListener<LoginBloc, LoginState>(
            listener: (context, state) {
              if (state is LoginSuccess) {
                ComplaintsController complaintsController =Get.put(ComplaintsController());
                complaintsController.getComplaints();
                _saveUserDataAndNavigate(state.response);

                LoginProtectionService.recordSuccessfulAttempt(_emailCtrl.text.trim());
                ToastService.showSuccess(context, "مرحباً بعودتك , تم تسجيل الدخول بنجاح");

              } else if (state is LoginFailure) {
                LoginProtectionService.recordFailedAttempt(_emailCtrl.text.trim());
                String errorMessage = "فشل تسجيل الدخول. يرجى المحاولة مرة أخرى.";

                if (state.error.contains("Invalid credentials") || state.error.contains("wrong-password")) {
                  errorMessage = "البريد الإلكتروني أو كلمة المرور غير صحيحة";
                } else if (state.error.contains("user-not-found")) {
                  errorMessage = "لا يوجد حساب بهذا البريد الإلكتروني";
                }

                ToastService.showError(context, errorMessage);

                if (_isAccountLocked) {
                  _startCountdownTimer();
                }
              }

            },            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 40),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    const EagleLogo(size: 140),
                    const SizedBox(height: 32),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                      child: const Column(
                        children: [
                          Text(
                            'شارك برأيك.. سوريا الجديدة تسمعك',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: 8),
                          Text(
                            'سجل دخولك لتقديم شكواك ومتابعتها مع الحكومة',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.white70,
                              fontWeight: FontWeight.w400,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),

                    if (_isAccountLocked || (_emailCtrl.text.isNotEmpty && _remainingAttempts < 5))
                      _buildSecurityStatusCard(),

                    const SizedBox(height: 24),

                    Column(
                      children: [
                        GoldTextField(
                          controller: _emailCtrl,
                          hint: 'البريد الإلكتروني',
                          validator: (value) {
                            if (_isAccountLocked) {
                              return 'الحساب مغلق مؤقتاً';
                            }
                            return Validate.validateEmail(value);
                          },
                          keyboard: TextInputType.emailAddress,
                          prefixIcon: const Icon(Icons.email_outlined, color: Color(0xFFBFA46F)),
                        ),
                        const SizedBox(height: 16),

                        GoldTextField(
                          controller: _passCtrl,
                          hint: 'كلمة المرور',
                          validator: (value) {
                            if (_isAccountLocked) return null;
                            return Validate.validateLoginPassword(value);
                          },
                          obscure: _obscurePassword,
                          prefixIcon: const Icon(Icons.lock_outline, color: Color(0xFFBFA46F)),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscurePassword ? Icons.visibility_off : Icons.visibility,
                              color: Colors.white70,
                            ),
                            onPressed: () {
                              setState(() {
                                _obscurePassword = !_obscurePassword;
                              });
                            },
                          ),
                        ),
                        const SizedBox(height: 8),

                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            onPressed: () {
                              // TODO: إضافة صفحة استعادة كلمة المرور
                            },
                            child: const Text(
                              "نسيت كلمة المرور؟",
                              style: TextStyle(color: Color(0xFFBFA46F)),
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),

                        BlocBuilder<LoginBloc, LoginState>(
                          builder: (context, state) {
                            return GoldButton(
                              label: state is LoginLoading ? 'جاري تسجيل الدخول...' : 'تسجيل الدخول',
                              onTap: state is LoginLoading ? null : () => _handleLogin(context),
                              isLoading: state is LoginLoading,
                            );
                          },
                        ),
                      ],
                    ),

                    const SizedBox(height: 24),

                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.05),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            "جديد في خدمتنا؟ ",
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 14,
                            ),
                          ),
                          GestureDetector(
                            onTap: () => Navigator.pushReplacementNamed(context, '/signup'),
                            child: const Text(
                              "إنشاء حساب",
                              style: TextStyle(
                                color: Color(0xFFBFA46F),
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSecurityStatusCard() {
    final remainingAttempts = _remainingAttempts;
    final usedAttempts = 5 - remainingAttempts;

    if (_isAccountLocked) {
      return _buildLockedCardWithTimer();
    }

    if (remainingAttempts <= 2) {
      String attemptsText = remainingAttempts == 1 ? 'محاولة واحدة' : '$remainingAttempts محاولات';
      return _buildStatusCard(
        icon: Icons.warning_amber_rounded,
        title: " تنبيه أمني عاجل",
        message: "باقي $attemptsText فقط!\nتم استخدام $usedAttempts من 5 محاولات.",
        color: Colors.red,
      );
    }

    if (remainingAttempts < 5) {
      return _buildStatusCard(
        icon: Icons.security_rounded,
        title: "ملاحظة أمنية",
        message: "المحاولات المستخدمة: $usedAttempts/5\nالمحاولات المتبقية: $remainingAttempts",
        color: Colors.orange,
      );
    }

    return const SizedBox();
  }
  Widget _buildLockedCardWithTimer() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.orange.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.orange.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.orange.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.lock_clock_rounded, color: Colors.orange, size: 24),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "الحساب مغلق مؤقتاً",
                  style: TextStyle(
                    color: Colors.orange,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  "لأسباب أمنية، تم غلق هذا الحساب مؤقتاً. يرجى المحاولة مرة أخرى بعد $_remainingTimeText.",
                  style: TextStyle(
                    color: Colors.orange.withOpacity(0.9),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusCard({
    required IconData icon,
    required String title,
    required String message,
    required Color color,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: color,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  message,
                  style: TextStyle(
                    color: color.withOpacity(0.9),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  void _saveUserDataAndNavigate(LoginResponse response) async {
    try {
      await AuthStorage.saveAuthToken(response.user.token);
      await AuthStorage.saveUserData({
        'id': response.user.id,
        'name': response.user.name,
        'email': response.user.email,
        'phone_number': response.user.phone_number,
      });

      Navigator.of(context).pushReplacementNamed(AppRoutes.home);
    } catch (e) {
      ToastService.showError(context, 'فشل في حفظ الجلسة. يرجى المحاولة مرة أخرى');
    }
  }
}
