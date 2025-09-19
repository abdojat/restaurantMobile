import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../core/api_client.dart';
import '../models/user_model.dart';
import '../config/app_config.dart';

class AuthService {
  late final ApiClient _apiClient;

  AuthService() {
    _apiClient = ApiClient(
      baseUrl: AppConfig.apiUrl,
      getToken: getStoredToken,
    );
  }

  Future<String?> getStoredToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('auth_token');
  }

  Future<void> _storeToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('auth_token', token);
  }

  Future<void> _removeToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_token');
    await prefs.remove('user_data');
  }

  Future<AuthResult> login({
    required String phone_number,
    required String password,
  }) async {
    try {
      final response = await _apiClient.dio.post(
        '/auth/login',
        data: {
          'phone_number': phone_number,
          'password': password,
        },
      );

      if (response.statusCode == 200) {
        final data = response.data;
        final token = data['token'];
        final user = data['user'];

        if (token != null) {
          await _storeToken(token);
        }
        return AuthResult.success(
          token: token,
          user: UserModel.fromJson(user),
        );
      } else {
        return AuthResult.failure('Login failed');
      }
    } on DioException catch (e) {
      String errorMessage = 'Login failed';

      if (e.response?.statusCode == 401) {
        errorMessage = 'Invalid phone number or password';
      } else if (e.response?.statusCode == 422) {
        final errors = e.response?.data['errors'];
        if (errors != null) {
          errorMessage = errors.values.first[0];
        }
      } else if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout) {
        errorMessage = 'Connection timeout. Please try again.';
      } else if (e.type == DioExceptionType.connectionError) {
        errorMessage = 'No internet connection';
      }

      return AuthResult.failure(errorMessage);
    } catch (e) {
      return AuthResult.failure('An unexpected error occurred');
    }
  }

  Future<AuthResult> register({
    required String name,
    required String phone_number,
    required String email,
    required String password,
    required String passwordConfirmation,
  }) async {
    try {
      final response = await _apiClient.dio.post(
        '/auth/register',
        data: {
          'name': name,
          'phone_number': phone_number,
          'email': email,
          'password': password,
          'password_confirmation': passwordConfirmation,
        },
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        final data = response.data;
        final token = data['token'];
        final user = data['user'];

        if (token != null) {
          await _storeToken(token);
        }

        return AuthResult.success(
          token: token,
          user: UserModel.fromJson(user),
        );
      } else {
        return AuthResult.failure('Registration failed');
      }
    } on DioException catch (e) {
      String errorMessage = 'Registration failed';

      if (e.response?.statusCode == 422) {
        final errors = e.response?.data['errors'];
        if (errors != null) {
          errorMessage = errors.values.first[0];
        }
      } else if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout) {
        errorMessage = 'Connection timeout. Please try again.';
      } else if (e.type == DioExceptionType.connectionError) {
        errorMessage = 'No internet connection';
      }

      return AuthResult.failure(errorMessage);
    } catch (e) {
      return AuthResult.failure('An unexpected error occurred');
    }
  }

  Future<void> logout() async {
    try {
      await _apiClient.dio.post('/auth/logout');
    } catch (e) {
      // Even if logout fails on server, remove local token
    } finally {
      await _removeToken();
    }
  }

  Future<bool> isLoggedIn() async {
    final token = await getStoredToken();
    return token != null && token.isNotEmpty;
  }

  Future<bool> validateToken(String token) async {
    try {
      final response = await _apiClient.dio.get(
        '/auth/me',
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
        ),
      );
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

  Future<UserModel?> getCurrentUser() async {
    try {
      final response = await _apiClient.dio.get('/auth/me');
      if (response.statusCode == 200) {
        return UserModel.fromJson(response.data);
      }
    } catch (e) {
      await _removeToken();
    }
    return null;
  }
}

class AuthResult {
  final bool isSuccess;
  final String? errorMessage;
  final String? token;
  final UserModel? user;

  AuthResult._({
    required this.isSuccess,
    this.errorMessage,
    this.token,
    this.user,
  });

  factory AuthResult.success({String? token, UserModel? user}) {
    return AuthResult._(
      isSuccess: true,
      token: token,
      user: user,
    );
  }

  factory AuthResult.failure(String errorMessage) {
    return AuthResult._(
      isSuccess: false,
      errorMessage: errorMessage,
    );
  }
}
