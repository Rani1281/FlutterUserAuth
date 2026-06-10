import 'dart:async';

import 'package:articly/data/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:logging/logging.dart';

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

  final log = Logger('VerifyEmailViewModel');

  Future<void> sendEmailVerification() async {
    log.info('Email verification sending started...');
    _errorMessage = null;
    _isRunning = true;
    notifyListeners();

    if (_authService.user == null) {
      log.shout('User doesn\'t exist, so not sending a verification');
      return Future.value();
    }

    try {
      await _authService.sendEmailVerification();
      log.fine('Email verification was sent successfully!');
    } on CustomAuthException catch (e) {
      log.shout(
        'A Firebase Auth exception occurred: ${e.errorMessage}.\nCode: ${e.code}',
      );
      _errorMessage = e.displayMessage;
    } catch (e) {
      log.shout('An error has occurred: ${e.toString()}');
      _errorMessage = 'Something went wrong. Please try again later';
    } finally {
      _isRunning = false;
      notifyListeners();
    }
  }

  Future<bool> checkIfEmailVerified() async {
    final user = _authService.user;

    if (user == null) {
      log.warning('The user doesn\'t exist, so email is not verified');
      return false;
    }

    await user.reload();
    _isEmailVerified = user.emailVerified;
    notifyListeners();

    if (_isEmailVerified) {
      log.fine('Email is verified!');
      return true;
    }
    return false;
  }

  String? getEmail() {
    return _authService.user?.email;
  }
}
