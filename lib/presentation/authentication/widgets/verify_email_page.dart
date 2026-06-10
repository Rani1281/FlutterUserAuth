import 'dart:async';
import 'package:articly/presentation/authentication/view_models/verify_email_view_model.dart';
import 'package:articly/presentation/authentication/widgets/cooldown_widget.dart';
import 'package:flutter/material.dart';

class VerifyEmailScreen extends StatefulWidget {
  const VerifyEmailScreen({super.key, required this.viewModel});

  final VerifyEmailViewModel viewModel;

  @override
  State<VerifyEmailScreen> createState() => _VerifyEmailScreenState();
}

class _VerifyEmailScreenState extends State<VerifyEmailScreen> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    debugPrint('InitState activated');
    // Send first email verification
    widget.viewModel.sendEmailVerification();

    // Activate timer to check email verification status every 3 seconds

    _timer = Timer.periodic(
      const Duration(seconds: 3),
      (_) async => widget.viewModel.checkIfEmailVerified().then((isVerified) {
        if (isVerified) _timer?.cancel();
      }),
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: widget.viewModel,
      builder: (context, child) {
        return Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: true,
            title: const Text('Verify email'),
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 450),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 40),
                    const Text(
                      'Check your email',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'We\'ve sent a verification link to your email ${widget.viewModel.getEmail() ?? ''}. Please check your inbox and click the link to verify your account. If you can\'t find it, please check in your spam folder or send again.',
                      style: TextStyle(fontSize: 16, color: Colors.black54),
                    ),
                    const SizedBox(height: 16),
                    if (widget.viewModel.isEmailVerified)
                      const Text(
                        'Your email is verified!',
                        style: TextStyle(
                          color: Colors.green,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                    const SizedBox(height: 32), // Space before the button

                    CooldownAuthButton(
                      text: 'Resend email',
                      onResend: widget.viewModel.sendEmailVerification,
                      startCounting: true,
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
