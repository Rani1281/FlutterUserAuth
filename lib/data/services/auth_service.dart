import 'package:articly/config/auth_exceptions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class AuthService {
  AuthService({FirebaseAuth? auth, GoogleSignIn? googleSignIn})
    : _auth = auth ?? FirebaseAuth.instance,
      _googleSignIn = googleSignIn ?? GoogleSignIn.instance;

  final FirebaseAuth _auth;
  final GoogleSignIn _googleSignIn;

  User? get user => _auth.currentUser;

  Stream<User?> get authChanges => _auth.idTokenChanges();

  Future<UserCredential?> register(String email, String password) async {
    try {
      return await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      final errorMessage = authMessages[e.code] ?? 'An error occurred';
      throw CustomAuthException(errorMessage, code: e.code);
    } catch (e) {
      rethrow;
    }
  }

  Future<UserCredential?> login(String email, String password) async {
    try {
      return await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      final errorMessage = authMessages[e.code] ?? 'An error occurred';
      throw CustomAuthException(errorMessage, code: e.code);
    } catch (e) {
      rethrow;
    }
  }

  Future<UserCredential> signInWithGoogle() async {
    try {
      if (kIsWeb) {
        final GoogleAuthProvider googleProvider = GoogleAuthProvider();
        return await _auth.signInWithPopup(googleProvider);
      } else {
        await _googleSignIn.initialize();

        final GoogleSignInAccount googleUser = await _googleSignIn
            .authenticate();

        final GoogleSignInAuthentication googleAuth = googleUser.authentication;

        final credential = GoogleAuthProvider.credential(
          idToken: googleAuth.idToken,
        );

        return await _auth.signInWithCredential(credential);
      }
    } on FirebaseAuthException catch (e) {
      final errorMessage = authMessages[e.code] ?? 'Something went wrong';
      throw CustomAuthException(errorMessage, code: e.code);
    } on GoogleSignInException catch (e) {
      if (e.code == GoogleSignInExceptionCode.canceled) {
        throw CustomAuthException(
          'Sign in cancelled by user',
          code: 'SIGN_IN_CANCELLED',
        );
      }
      throw CustomAuthException(
        'Something went wrong',
        code: e.code.name,
        errorMessage: e.description,
      );
    } catch (e) {
      throw CustomAuthException(
        'Something went wrong',
        code: 'UNKNOWN_ERROR',
        errorMessage: e.toString(),
      );
    }
  }

  Future<void> updateUsername(String newUsername) async {
    try {
      final user = _auth.currentUser;
      if (user != null && newUsername.isNotEmpty) {
        await user.updateDisplayName(newUsername);
      }
    } on FirebaseAuthException catch (e) {
      throw CustomAuthException(
        'Something went wrong',
        code: e.code,
        errorMessage: e.message,
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<void> sendEmailVerification() async {
    try {
      final user = _auth.currentUser;
      if (user != null && !user.emailVerified) {
        await user.sendEmailVerification();
      }
    } on FirebaseAuthException catch (e) {
      throw CustomAuthException(
        'Something went wrong',
        code: e.code,
        errorMessage: e.message,
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<void> sendPasswordResetEmail(String email) async {
    try {
      final user = _auth.currentUser;
      if (user != null && user.emailVerified) {
        await _auth.sendPasswordResetEmail(email: email);
      }
    } on FirebaseAuthException catch (e) {
      throw CustomAuthException(
        'Something went wrong',
        code: e.code,
        errorMessage: e.message,
      );
    } catch (e) {
      rethrow;
    }
  }

  /// Sign the user out if he doesn't exist anymore
  Future<void> checkIfUserStillExists() async {
    final user = _auth.currentUser;
    if (user != null) {
      try {
        await user.getIdToken(true); // forces token refresh
      } catch (e) {
        // Handle user deletion
        await _auth.signOut();
        debugPrint('Signing out because the user doesn\'t exist anymore');
      }
    }
  }

  Future<void> signOut() async {
    try {
      await _auth.signOut();
      await _googleSignIn.signOut();
      debugPrint('User was successfully signed out');
    } on FirebaseAuthException catch (e) {
      throw CustomAuthException(
        'Something went wrong',
        code: e.code,
        errorMessage: e.message,
      );
    } catch (e) {
      rethrow;
    }
  }

  String? getProfilePicture() {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        final url = user.photoURL;
        if (url != null && url.isNotEmpty) return url;
      }
      return null;
    } on FirebaseAuthException catch (e) {
      throw CustomAuthException(
        'Something went wrong',
        code: e.code,
        errorMessage: e.message,
      );
    } catch (e) {
      rethrow;
    }
  }
}

class CustomAuthException {
  final String displayMessage;
  final String? code;
  final String? errorMessage;

  const CustomAuthException(
    this.displayMessage, {
    this.code,
    this.errorMessage,
  });
}
