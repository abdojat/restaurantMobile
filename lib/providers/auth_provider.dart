import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/auth_service.dart';
import '../models/user_model.dart';

class AuthProvider with ChangeNotifier {
  String? _token;
  UserModel? _user;
  bool _isLoading = true;
  final AuthService _authService = AuthService();

  bool get isAuthenticated => _token != null;
  bool get isLoading => _isLoading;
  String? get token => _token;
  UserModel? get user => _user;

  AuthProvider() {
    _loadAuthData();
  }

  Future<void> _loadAuthData() async {
    try {
      _token = await _authService.getStoredToken();
      if (_token != null) {
        // Validate token with server
        final isValid = await _authService.validateToken(_token!);
        if (isValid) {
          // Load user data if stored
          final prefs = await SharedPreferences.getInstance();
          final userData = prefs.getString('user_data');
          if (userData != null) {
            try {
              // Parse the stored user data from JSON string to Map
              final userMap = Map<String, dynamic>.from(jsonDecode(userData));
              _user = UserModel.fromJson(userMap);
            } catch (e) {
              debugPrint('Error parsing user data: $e');
              // Clear corrupted user data
              await _clearStoredData();
            }
          }
        } else {
          // Token is invalid, clear stored data
          debugPrint('Stored token is invalid, clearing auth data');
          await _clearStoredData();
          _token = null;
        }
      }
    } catch (e) {
      debugPrint('Error loading auth data: $e');
      // Clear potentially corrupted data
      await _clearStoredData();
      _token = null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> _clearStoredData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('auth_token');
      await prefs.remove('user_data');
    } catch (e) {
      debugPrint('Error clearing stored data: $e');
    }
  }

  Future<AuthResult> login(String phone, String password) async {
    try {
      _isLoading = true;
      notifyListeners();
      
      final result = await _authService.login(
        phone_number: phone,
        password: password,
      );

      if (result.token != null) {
        _token = result.token;
        _user = result.user;
        
        // Store user data
        if (result.user != null) {
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString('user_data', jsonEncode(result.user!.toJson()));
        }
      }
      
      return result;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> logout() async {
    try {
      await _authService.logout();
    } catch (e) {
      debugPrint('Error during logout: $e');
    } finally {
      _token = null;
      _user = null;
      notifyListeners();
    }
  }

  Future<void> refreshAuthState() async {
    if (_token != null) {
      try {
        final isValid = await _authService.validateToken(_token!);
        if (!isValid) {
          debugPrint('Token validation failed during refresh, logging out');
          await logout();
        }
      } catch (e) {
        debugPrint('Error refreshing auth state: $e');
      }
    }
  }
}
