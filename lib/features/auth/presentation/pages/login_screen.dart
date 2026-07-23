// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:resturent_billinng_app/config/routes/app_routes.dart';
import 'package:resturent_billinng_app/core/constants/app_colors.dart';
import 'package:resturent_billinng_app/utils/phone_number_utils.dart';
import 'package:resturent_billinng_app/widgets/app_button.dart';
import 'package:resturent_billinng_app/widgets/app_phone_field.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final phoneController = TextEditingController();
  String countryCode = '+91';
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    phoneController.addListener(_onPhoneChanged);
  }

  void _onPhoneChanged() {
    if (mounted) setState(() {});
  }

  Future<void> _completeLogin() async {
    if (_isLoading) return;

    final mobile = PhoneNumberUtils.normalizeLocalNumber(
      phoneController.text,
      countryCode: countryCode,
    );
    if (mobile.length < 9) {
      _showSnackBar('Please enter a valid phone number');
      return;
    }

    setState(() => _isLoading = true);
    try {
      context.go(
        Uri(
          path: AppRoutes.otpScreen,
          queryParameters: {'phone': mobile},
        ).toString(),
      );
    } catch (_) {
      _showSnackBar('Unable to continue');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  bool _isValidPhoneNumber() {
    final digits = phoneController.text.replaceAll(RegExp(r'\D'), '');
    return digits.length >= 9;
  }

  void _showSnackBar(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, style: const TextStyle(color: Colors.white)),
      ),
    );
  }

  @override
  void dispose() {
    phoneController.removeListener(_onPhoneChanged);
    phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      resizeToAvoidBottomInset: true,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/loginimg.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                keyboardDismissBehavior:
                    ScrollViewKeyboardDismissBehavior.onDrag,
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 28),
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: constraints.maxHeight - 48,
                  ),
                  child: IntrinsicHeight(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Spacer(),
                        Text(
                          'Welcome to ',
                          style: TextStyle(
                            fontSize: 24,
                            color: AppColors.surface,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          'Billing Simplified. Businness Amplified',
                          style: TextStyle(
                            fontSize: 18,
                            color: AppColors.surface,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 30),
                        AppPhoneField(
                          controller: phoneController,
                          hintText: "Enter phone number",
                          minHeight: 64,
                        ),

                        const SizedBox(height: 14),
                        AppButton(
                          key: const ValueKey('send_otp_button'),
                          buttonText: 'Send OTP',
                          isLoading: _isLoading,
                          isDisabled: !_isValidPhoneNumber(),
                          onPressed: _completeLogin,
                        ),
                        const SizedBox(height: 30),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
