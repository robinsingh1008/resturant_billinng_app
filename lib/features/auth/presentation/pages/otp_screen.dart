import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:resturent_billinng_app/config/routes/app_routes.dart';
import 'package:resturent_billinng_app/widgets/app_button.dart';
import 'package:resturent_billinng_app/widgets/app_otp_field.dart';

class OtpScreen extends StatefulWidget {
  const OtpScreen({super.key, required this.phoneNumber});

  final String phoneNumber;

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  final _otpController = TextEditingController();
  bool _canVerify = false;

  @override
  void initState() {
    super.initState();
    _otpController.addListener(_onOtpChanged);
  }

  void _onOtpChanged() {
    final canVerify = _otpController.text.trim().length == 6;
    if (_canVerify != canVerify && mounted) {
      setState(() => _canVerify = canVerify);
    }
  }

  void _verifyOtp() {
    if (!_canVerify) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter the 6 digit OTP')),
      );
      return;
    }

    context.go(AppRoutes.language);
  }

  @override
  void dispose() {
    _otpController.removeListener(_onOtpChanged);
    _otpController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            context.go(AppRoutes.login);
          },
          icon: const Icon(Icons.arrow_back_ios),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(22, 18, 22, 22),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Verify OTP',
                style: theme.textTheme.displaySmall?.copyWith(
                  fontSize: 31,
                  height: 1.22,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'Enter the 6 digit code sent to +91 ${widget.phoneNumber}',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                  fontSize: 15,
                  height: 1.35,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 36),
              AppPinCodeField(
                controller: _otpController,
                length: 6,
                fieldHeight: 54,
                fieldWidth: 46,
                fillColor: colorScheme.surface,
                borderColor: theme.dividerColor,
                onCompleted: (_) => _verifyOtp(),
              ),
              const SizedBox(height: 18),
              Center(
                child: TextButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('OTP sent again')),
                    );
                  },
                  child: const Text('Resend OTP'),
                ),
              ),
              const SizedBox(height: 60),
              AppButton(
                key: ValueKey("otp"),
                buttonText: "Verify Otp",
                onPressed: _verifyOtp,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
