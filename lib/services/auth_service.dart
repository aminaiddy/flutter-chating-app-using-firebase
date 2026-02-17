import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<UserCredential> registerWithEmail({
    required String email,
    required String password,
  }) async {
    if (kDebugMode) {
      print('Registering user with email: ${email.trim()}');
      print('Password length: ${password.trim().length}');
    }

    try {
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );
      
      if (kDebugMode) {
        print('Registration successful for user: ${credential.user?.email}');
      }
      
      return credential;
    } on FirebaseAuthException catch (e) {
      if (kDebugMode) {
        print('Firebase Auth Exception:');
        print('Code: ${e.code}');
        print('Message: ${e.message}');
        print('Email: ${email.trim()}');
      }
      rethrow;
    } catch (e) {
      if (kDebugMode) {
        print('General Exception during registration: $e');
      }
      rethrow;
    }
  }

  Future<UserCredential> signInWithEmail({
    required String email,
    required String password,
  }) async {
    if (kDebugMode) {
      print('Signing in user with email: ${email.trim()}');
    }

    try {
      final credential = await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );
      
      if (kDebugMode) {
        print('Sign in successful for user: ${credential.user?.email}');
      }
      
      return credential;
    } on FirebaseAuthException catch (e) {
      if (kDebugMode) {
        print('Firebase Auth Exception:');
        print('Code: ${e.code}');
        print('Message: ${e.message}');
        print('Email: ${email.trim()}');
      }
      rethrow;
    } catch (e) {
      if (kDebugMode) {
        print('General Exception during sign in: $e');
      }
      rethrow;
    }
  }

  Future<void> signOut() async {
    try {
      await _auth.signOut();
      // Clear the persistent login state
      await _clearLoginState();
      if (kDebugMode) {
        print('User signed out successfully');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Sign out failed: $e');
      }
      rethrow;
    }
  }

  // Save login state to SharedPreferences
  Future<void> _saveLoginState() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isLoggedIn', true);
      if (kDebugMode) {
        print('Login state saved: true');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Failed to save login state: $e');
      }
    }
  }

  // Clear login state from SharedPreferences
  Future<void> _clearLoginState() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isLoggedIn', false);
      if (kDebugMode) {
        print('Login state cleared: false');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Failed to clear login state: $e');
      }
    }
  }

  // Check if user is logged in
  Future<bool> isLoggedIn() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
      if (kDebugMode) {
        print('Login state retrieved: $isLoggedIn');
      }
      return isLoggedIn;
    } catch (e) {
      if (kDebugMode) {
        print('Failed to retrieve login state: $e');
      }
      return false;
    }
  }

  // Method to call after successful login/registration
  Future<void> handleSuccessfulAuth() async {
    await _saveLoginState();
  }
}
