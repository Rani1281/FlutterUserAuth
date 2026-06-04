import 'package:articly/data/services/auth_service.dart';
import 'package:articly/domain/string_extension.dart';
import 'package:flutter/material.dart';

class AuthPageModel extends ChangeNotifier {
  AuthPageModel({required this.service});

  final AuthService service;

  bool _isLogin = true;
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;
  String? _error;
  bool _isRunning = false;
  bool _isRunningGoogle = false;

  bool get isLogin => _isLogin;
  bool get isPasswordVisible => _isPasswordVisible;
  bool get isConfirmPasswordVisible => _isConfirmPasswordVisible;
  String? get error => _error;
  bool get isRunning => _isRunning;
  bool get isRunningGoogle => _isRunningGoogle;

  void toggleForm() {
    _isLogin = !isLogin;
    notifyListeners();
  }

  void togglePasswordVisibility() {
    _isPasswordVisible = !_isPasswordVisible;
    notifyListeners();
  }

  void toggleConfirmPasswordVisibility() {
    _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
    notifyListeners();
  }

  Future<void> submit({
    required String username,
    required String email,
    required String password,
    required String confirmPassword,
  }) async {
    // set isRunning to true and notify
    // 1. Validate the fields according to isLogin. Return and error if not valid.

    // 2. Call Firebase Auth appropriate method according to isLogin. Check Firebase exceptions, or other ones, and set an error.

    // Maybe need to call notifyListeners, but not sure. (start with not)

    _isRunning = true;
    _error = null; // clear the error
    notifyListeners();

    final String? message = validateFields(
      username: username,
      email: email,
      password: password,
      confirmPassword: confirmPassword,
    );

    if (message != null) {
      _error = message;
      _isRunning = false;
      notifyListeners();
      return Future.value();
    }

    // Authenticate with Firebase
    await authenticate(username: username, email: email, password: password);
  }

  String? validateFields({
    required String username,
    required String email,
    required String password,
    required String confirmPassword,
  }) {
    // check email and password
    final String? emailMsg = validateEmail(email);
    if (emailMsg != null) return emailMsg;

    final String? passwordMsg = validatePassword(password);
    if (passwordMsg != null) return passwordMsg;

    // Handle additional fields to validate during registration
    if (!isLogin) {
      final String? usernameMsg = validateUsername(username);
      if (usernameMsg != null) return usernameMsg;

      final String? confirmPasswordMsg = validateConfirmPassword(
        confirmPassword,
        password,
      );
      if (confirmPasswordMsg != null) return confirmPasswordMsg;
    }

    return null;
  }

  Future<void> authenticate({
    required String username,
    required String email,
    required String password,
  }) async {
    try {
      if (isLogin) {
        await service.login(email, password);
      } else {
        await service.register(email, password);
        await service.updateUsername(username);
      }
    } on CustomAuthException catch (e) {
      _error = e.displayMessage;
    } catch (e) {
      _error =
          'Something went wrong, please check your details or try again later';
    } finally {
      _isRunning = false;
      notifyListeners();
    }
  }

  Future<void> continueWithGoogle() async {
    _isRunningGoogle = true;
    _error = null;
    notifyListeners();

    try {
      await service.signInWithGoogle();
    } on CustomAuthException catch (e) {
      _error = e.displayMessage;
    } catch (e) {
      _error =
          'Something went wrong, please check your details or try again later';
    } finally {
      _isRunningGoogle = false;
      notifyListeners();
    }
  }

  // ! <--- Validation Methods --->

  static String? validateUsername(String username) {
    if (username.isEmpty) {
      return 'Username is required';
    }
    if (username.length > 50) {
      return 'Username is too long';
    }
    return null;
  }

  static String? validateEmail(String email) {
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (email.isEmpty) {
      return 'Email is required';
    }
    if (!emailRegex.hasMatch(email)) {
      return 'The email is invalid';
    }
    return null;
  }

  static String? validatePassword(String password) {
    // final lt = password.hasLetter;
    // final nb = password.hasNumber;
    // final sb = password.hasSymbol;

    if (password.isEmpty) {
      return 'Password is required';
    }
    if (password.length < 6) {
      return 'Password must contain at least 6 characters';
    }
    if (!password.hasLetter) {
      return 'Password must contain at least one letter';
    }
    if (!password.hasNumber) {
      return 'Password must have at least one number';
    }
    // else if (!password.hasSymbol) {
    //   return 'Password must have at least one symbol';
    // }
    // TODO: after acaling a bit consider adding this
    return null;
  }

  static String? validateConfirmPassword(
    String confirmPassword,
    String password,
  ) {
    if (confirmPassword.isEmpty) {
      return 'Password confirmation is required';
    }
    if (validatePassword(password) != null || confirmPassword != password) {
      return 'The password does not match the original one';
    }
    return null;
  }
}
