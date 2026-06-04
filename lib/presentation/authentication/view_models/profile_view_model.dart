import 'package:articly/data/services/auth_service.dart';
import 'package:flutter/material.dart';

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

  String? getUsername() {
    return _authService.user?.displayName;
  }

  String? getUserEmail() {
    return _authService.user?.email;
  }

  Future<void> logOut() async {
    _errorMessageLogout = null;
    _isRunningLogout = true;
    notifyListeners();

    try {
      await _authService.signOut();
    } on CustomAuthException catch (e) {
      _errorMessageLogout = e.displayMessage;
    } catch (e) {
      _errorMessageLogout = 'Something went wrong. Please try again later';
    } finally {
      _isRunningLogout = false;
      notifyListeners();
    }
  }

  Future<void> editUsername(String newName) async {
    _errorMessageUsername = null;
    _isRunningUsername = true;
    notifyListeners();

    try {
      await _authService.updateUsername(newName);
    } on CustomAuthException catch (e) {
      _errorMessageUsername = e.displayMessage;
    } catch (e) {
      _errorMessageUsername = 'Something went wrong. Please try again later';
    } finally {
      _isRunningUsername = false;
      notifyListeners();
    }
  }
}
