import 'package:articly/data/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:logging/logging.dart';

class ProfileViewModel extends ChangeNotifier {
  ProfileViewModel({required AuthService authService})
    : _authService = authService;

  final AuthService _authService;
  String? _errorMessageLogout;
  bool _isRunningLogout = false;

  String? _errorMessageUsername;
  bool _isRunningUsername = false;

  String? get errorMessageLogout => _errorMessageLogout;
  bool get isRunningLogout => _isRunningLogout;

  String? get errorMessageUsername => _errorMessageUsername;
  bool get isRunningUsername => _isRunningUsername;

  final log = Logger('ProfileViewModel');

  String? getUsername() {
    return _authService.user?.displayName;
  }

  String? getUserEmail() {
    return _authService.user?.email;
  }

  Future<void> logOut() async {
    log.info('Logout started...');
    _errorMessageLogout = null;
    _isRunningLogout = true;
    notifyListeners();

    try {
      await _authService.signOut();
      log.fine('Logout was successful!');
    } on CustomAuthException catch (e) {
      log.shout(
        'A Firebase Auth exception occurred: ${e.errorMessage}.\nCode: ${e.code}',
      );
      _errorMessageLogout = e.displayMessage;
    } catch (e) {
      log.shout('An error has occurred: ${e.toString()}');
      _errorMessageLogout = 'Something went wrong. Please try again later';
    } finally {
      _isRunningLogout = false;
      notifyListeners();
    }
  }

  Future<void> editUsername(String newName) async {
    log.info('Edit username started...');
    _errorMessageUsername = null;
    _isRunningUsername = true;
    notifyListeners();

    try {
      await _authService.updateUsername(newName);
      log.fine('User was successfully updated!');
    } on CustomAuthException catch (e) {
      log.shout(
        'A Firebase Auth exception occurred: ${e.errorMessage}.\nCode: ${e.code}',
      );
      _errorMessageUsername = e.displayMessage;
    } catch (e) {
      log.shout('An error has occurred: ${e.toString()}');
      _errorMessageUsername = 'Something went wrong. Please try again later';
    } finally {
      _isRunningUsername = false;
      notifyListeners();
    }
  }
}
