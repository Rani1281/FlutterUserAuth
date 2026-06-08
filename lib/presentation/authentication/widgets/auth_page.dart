import 'package:articly/presentation/authentication/widgets/forgot_password_page.dart';
import 'package:articly/presentation/authentication/view_models/auth_page_model.dart';
import 'package:articly/presentation/authentication/widgets/auth_button.dart';
import 'package:articly/presentation/authentication/widgets/auth_text_field.dart';
import 'package:articly/theme/app_colors.dart';
import 'package:flutter/material.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key, required this.viewModel});

  final AuthPageModel viewModel;

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: widget.viewModel,
      builder: (context, _) {
        final bool isLogin = widget.viewModel.isLogin;
        return Scaffold(
          backgroundColor: AppColors.scaffoldBackgroundColor,
          appBar: AppBar(
            automaticallyImplyLeading: true,
            title: Text(
              isLogin ? 'Login' : 'Register', // Title changes based on state
            ),
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 40),
                // Main title changes based on state
                ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: 460),
                  child: Row(
                    children: [
                      Text(
                        isLogin ? 'Welcome back' : 'Create your account',
                        // style: const TextStyle(
                        //   fontSize: 28,
                        //   fontWeight: FontWeight.bold,
                        //   color: Colors.black87,
                        // ),
                        style: Theme.of(context).textTheme.headlineLarge,
                      ),
                    ],
                  ),
                ),

                // --- Toggle Link Row ---
                ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: 450),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        isLogin
                            ? 'Don\'t have an account?'
                            : 'Already have an account?', // Text changes
                      ),
                      TextButton(
                        onPressed: () => widget.viewModel
                            .toggleForm(), // Call the toggle function
                        child: Text(
                          isLogin ? 'Register' : 'Login', // Text changes
                          style: const TextStyle(
                            color: Colors.blue,
                          ), // body medium + colors
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 15),

                if (!isLogin) ...[
                  // <--- username field --->
                  AuthTextField(
                    key: Key('usernameField'),
                    controller: _usernameController,
                    hintText: 'Username',
                  ),
                  const SizedBox(height: 16),
                ],

                // <--- Email Field --->
                AuthTextField(
                  key: Key('emailField'),
                  controller: _emailController,
                  hintText: 'Email',
                ),
                const SizedBox(height: 16),

                // <--- Password Field --->
                AuthTextField(
                  key: Key('passwordField'),
                  controller: _passwordController,
                  hintText: 'Password',
                  obscureText: !widget.viewModel.isPasswordVisible,
                  suffixIcon: IconButton(
                    icon: Icon(
                      widget.viewModel.isPasswordVisible
                          ? Icons.visibility
                          : Icons.visibility_off,
                      color: Colors.black45,
                    ),
                    onPressed: widget.viewModel.togglePasswordVisibility,
                  ),
                ),

                if (!isLogin) ...[
                  const SizedBox(height: 15),

                  // Confirm Password field (only for Register)
                  AuthTextField(
                    key: Key('confirmPasswordField'),
                    controller: _confirmPasswordController,
                    hintText: 'Confirm password',
                    obscureText: !widget.viewModel.isConfirmPasswordVisible,
                    suffixIcon: IconButton(
                      icon: Icon(
                        widget.viewModel.isConfirmPasswordVisible
                            ? Icons.visibility
                            : Icons.visibility_off,
                        color: Colors.black45,
                      ),
                      onPressed:
                          widget.viewModel.toggleConfirmPasswordVisibility,
                    ),
                  ),
                ],

                // Forgot Password link (only for Login)
                if (isLogin) ...[
                  const SizedBox(height: 5),

                  ConstrainedBox(
                    constraints: BoxConstraints(maxWidth: 450),
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ForgotPasswordPage(
                                email: _emailController.text.trim(),
                              ),
                            ),
                          );
                        },
                        child: const Text(
                          'Forgot password?',
                          style: TextStyle(color: Colors.blue),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 5),
                ],

                SizedBox(height: isLogin ? 0 : 15),

                // <--- Error Message Text --->
                if (widget.viewModel.error != null) ...[
                  Text(
                    widget.viewModel.error!,
                    style: TextStyle(color: Colors.red),
                    softWrap: true,
                    overflow: TextOverflow.clip,
                  ),

                  const SizedBox(height: 18),
                ],

                // <--- Action button --->
                AuthButton(
                  key: Key('actionButton'),
                  color: const Color.fromARGB(255, 250, 209, 88),
                  onPressed: () => widget.viewModel.submit(
                    username: _usernameController.text.trim(),
                    email: _emailController.text.trim(),
                    password: _passwordController.text.trim(),
                    confirmPassword: _confirmPasswordController.text.trim(),
                  ),
                  child: widget.viewModel.isRunning
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : Text(
                          isLogin ? 'Login' : 'Create account',
                          style: TextStyle(fontSize: 16, color: Colors.black87),
                        ),
                ),

                Padding(
                  padding: EdgeInsets.symmetric(vertical: 10),
                  child: Center(
                    child: Text(
                      'Or',
                      style: const TextStyle(color: Colors.black54),
                    ),
                  ),
                ),

                // <--- Google sign in button --->
                AuthButton(
                  key: ValueKey('GoogleSignInButton'),
                  onPressed: widget.viewModel.continueWithGoogle,
                  color: Colors.white,
                  child: widget.viewModel.isRunningGoogle
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : Row(
                          spacing: 15,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              height: 20,
                              width: 20,
                              child: Image.asset('assets/google_icon.png'),
                            ),
                            const Text(
                              'Continue with Google',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.black87,
                              ),
                            ),
                          ],
                        ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
