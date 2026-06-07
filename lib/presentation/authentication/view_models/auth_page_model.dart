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

  /// switches the value of _isLogin to !_isLogin and notifies listeners
  void toggleForm() {
    _isLogin = !isLogin;
    notifyListeners();
  }

  /// switches the value of _isPasswordVisible to !_isPasswordVisible and notifies listeners
  void togglePasswordVisibility() {
    _isPasswordVisible = !_isPasswordVisible;
    notifyListeners();
  }

  void toggleConfirmPasswordVisibility() {
    _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
    notifyListeners();
  }

  /// Sets the value of _isRunning to true and clears the error message, and notifies listeners
  ///
  /// Calls a function that validates the username, email, password and confirmPassword fields - if invalid, sets the error message, assigns _isRunning to false, notifies listeners and returns
  ///
  /// Otherwise, calls a function that authenticates with Firebase
  Future<void> submit({
    required String username,
    required String email,
    required String password,
    required String confirmPassword,
  }) async {
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
    _error = await authenticate(
      username: username,
      email: email,
      password: password,
    );
    _isRunning = false;
    notifyListeners();
  }

  /// Validates the username, email, password and confirm password fields, by calling each one his separate validation function, according to isLogin - if true, validates only the email and the password, and otherwise it validates all fields. If an error message returns, the function returns the error message before checking the next fields.
  ///
  /// If no error message was returned, the function returns null.
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

  /// If isLogin, attempts to login to Firebase by awaiting to the service method service.login(email, password). Otherwise, attempts to register by awaiting to service.register(email, password), and later awaiting to service.updateUsername(username).
  ///
  /// On success, return null. And on error, catches it and returns the error message.
  Future<String?> authenticate({
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
      return null;
    } on CustomAuthException catch (e) {
      return e.displayMessage;
    } catch (e) {
      return 'Something went wrong, please check your details or try again later';
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
    // TODO: after scaling a bit consider adding this
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
