import 'dart:async';

import 'package:articly/data/services/auth_service.dart';
import 'package:flutter/material.dart';

class VerifyEmailViewModel extends ChangeNotifier {
  VerifyEmailViewModel({required AuthService authService})
    : _authService = authService;

  final AuthService _authService;

  String? _errorMessage;
  bool _isRunning = false;

  bool _isEmailVerified = false;

  String? get errorMessage => _errorMessage;
  bool get isRunning => _isRunning;
  bool get isEmailVerified => _isEmailVerified;

  Future<void> sendEmailVerification() async {
    _errorMessage = null;
    _isRunning = true;
    notifyListeners();

    try {
      await _authService.sendEmailVerification();
    } on CustomAuthException catch (e) {
      _errorMessage = e.displayMessage;
    } catch (e) {
      _errorMessage = 'Something went wrong. Please try again later';
    } finally {
      _isRunning = false;
      notifyListeners();
    }
  }

  Future<bool> checkIfEmailVerified() async {
    final user = _authService.user;

    if (user == null) {
      debugPrint('The user doesn\'t exist, so email is not verified');
      return false;
    }

    await user.reload();
    _isEmailVerified = user.emailVerified;
    notifyListeners();

    if (_isEmailVerified) {
      return true;
    }
    return false;
  }

  String? getEmail() {
    return _authService.user?.email;
  }
}
