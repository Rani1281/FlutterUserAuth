import 'package:articly/data/services/auth_service.dart';
import 'package:articly/presentation/authentication/widgets/forgot_password_page.dart';
import 'package:articly/presentation/authentication/view_models/auth_page_model.dart';
import 'package:articly/presentation/authentication/widgets/auth_button.dart';
import 'package:articly/presentation/authentication/widgets/auth_text_field.dart';
import 'package:articly/theme/app_colors.dart';
import 'package:flutter/material.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key, this.viewModel});

  final AuthPageModel? viewModel;

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  late final AuthPageModel _viewModel;
  late final bool _ownsViewModel;

  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.viewModel != null) {
      _viewModel = widget.viewModel!;
      _ownsViewModel = false;
    } else {
      _viewModel = AuthPageModel(service: AuthService());
      _ownsViewModel = true;
    }
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    if (_ownsViewModel) {
      _viewModel.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _viewModel,
      builder: (context, _) {
        final bool isLogin = _viewModel.isLogin;
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
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 450),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 50),
                    Text(
                      isLogin ? 'Welcome back' : 'Create your account',
                      style: Theme.of(context).textTheme.headlineLarge,
                    ),
                    const SizedBox(height: 15),
                    Wrap(
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        Text(
                          isLogin
                              ? 'Don\'t have an account?'
                              : 'Already have an account?',
                        ),
                        const SizedBox(width: 5),
                        TextButton(
                          onPressed: _viewModel.toggleForm,
                          style: TextButton.styleFrom(
                            padding: EdgeInsets.zero,
                            minimumSize: Size.zero,
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                          child: Text(
                            isLogin ? 'Register' : 'Login',
                            style: const TextStyle(color: Colors.blue),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 15),
                    if (!isLogin) ...[
                      AuthTextField(
                        key: Key('usernameField'),
                        controller: _usernameController,
                        hintText: 'Username',
                      ),
                      const SizedBox(height: 16),
                    ],
                    AuthTextField(
                      key: Key('emailField'),
                      controller: _emailController,
                      hintText: 'Email',
                    ),
                    const SizedBox(height: 16),
                    AuthTextField(
                      key: Key('passwordField'),
                      controller: _passwordController,
                      hintText: 'Password',
                      obscureText: !_viewModel.isPasswordVisible,
                      suffixIcon: IconButton(
                        icon: Icon(
                          _viewModel.isPasswordVisible
                              ? Icons.visibility
                              : Icons.visibility_off,
                          color: Colors.black45,
                        ),
                        onPressed: _viewModel.togglePasswordVisibility,
                      ),
                    ),
                    if (!isLogin) ...[
                      const SizedBox(height: 15),
                      AuthTextField(
                        key: Key('confirmPasswordField'),
                        controller: _confirmPasswordController,
                        hintText: 'Confirm password',
                        obscureText: !_viewModel.isConfirmPasswordVisible,
                        suffixIcon: IconButton(
                          icon: Icon(
                            _viewModel.isConfirmPasswordVisible
                                ? Icons.visibility
                                : Icons.visibility_off,
                            color: Colors.black45,
                          ),
                          onPressed: _viewModel.toggleConfirmPasswordVisibility,
                        ),
                      ),
                    ],

                    // if (isLogin) ...[
                    //   const SizedBox(height: 5),
                    //   Align(
                    //     alignment: Alignment.centerRight,
                    //     child: TextButton(
                    //       onPressed: () {
                    //         Navigator.push(
                    //           context,
                    //           MaterialPageRoute(
                    //             builder: (context) => ForgotPasswordPage(
                    //               email: _emailController.text.trim(),
                    //             ),
                    //           ),
                    //         );
                    //       },
                    //       child: const Text(
                    //         'Forgot password?',
                    //         style: TextStyle(color: Colors.blue),
                    //       ),
                    //     ),
                    //   ),
                    //   const SizedBox(height: 5),
                    // ],

                    SizedBox(height: isLogin ? 0 : 15),
                    if (_viewModel.error != null) ...[
                      Text(
                        _viewModel.error!,
                        style: const TextStyle(color: Colors.red),
                        softWrap: true,
                        overflow: TextOverflow.clip,
                      ),
                      const SizedBox(height: 18),
                    ],
                    AuthButton(
                      key: Key('actionButton'),
                      // color: Colors.red[200]!,
                      // color: Colors.yellow[100]!,
                      // color: Colors.blue[300]!,
                      color: Theme.of(context).primaryColor,
                      onPressed: () => _viewModel.submit(
                        username: _usernameController.text.trim(),
                        email: _emailController.text.trim(),
                        password: _passwordController.text.trim(),
                        confirmPassword: _confirmPasswordController.text.trim(),
                      ),
                      child: _viewModel.isRunning
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : Text(
                              isLogin ? 'Login' : 'Create account',
                              style: TextStyle(
                                fontSize: 16,
                                // color: Colors.black87,
                                color: Colors.white,
                              ),
                            ),
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 10),
                      child: Center(
                        child: Text(
                          'Or',
                          style: TextStyle(color: Colors.black54),
                        ),
                      ),
                    ),
                    AuthButton(
                      key: ValueKey('GoogleSignInButton'),
                      onPressed: _viewModel.continueWithGoogle,
                      color: Colors.white,
                      child: _viewModel.isRunningGoogle
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
            ),
          ),
        );
      },
    );
  }
}
