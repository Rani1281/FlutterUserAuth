import 'dart:async';

import 'package:articly/data/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:logging/logging.dart';

class VerifyEmailViewModel extends ChangeNotifier {
  VerifyEmailViewModel({AuthService? authService})
    : _authService = authService ?? AuthService();

  final AuthService _authService;

  String? _errorMessage;
  bool _isRunning = false;

  bool _isEmailVerified = false;

  bool _isRunningLogOut = false;

  String? get errorMessage => _errorMessage;
  bool get isRunning => _isRunning;
  bool get isEmailVerified => _isEmailVerified;
  bool get isRunningLogOut => _isRunningLogOut;

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

  Future<void> logOut() async {
    _errorMessage = null;
    _isRunningLogOut = true;
    notifyListeners();

    try {
      await _authService.signOut();
      log.fine('The user has been successfully logged out!');
    } on CustomAuthException catch (e) {
      log.warning(
        'An auth exception occurred in logout: ${e.code}: ${e.errorMessage}.',
      );
      _errorMessage = e.displayMessage;
    } catch (e) {
      log.shout('An error occurred in logout: ${e.toString()}');
      _errorMessage = 'An error occurred. Please try again later';
    } finally {
      _isRunningLogOut = false;
      notifyListeners();
    }
  }
}
