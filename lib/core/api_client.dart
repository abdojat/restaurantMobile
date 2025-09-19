// lib/core/api_client.dart
import 'package:dio/dio.dart';
import '../config/app_config.dart';

class ApiClient {
  final Dio dio;

  ApiClient._(this.dio);

  factory ApiClient({String? baseUrl, Future<String?> Function()? getToken}) {
    final d = Dio(BaseOptions(
      baseUrl: baseUrl ?? AppConfig.apiUrl,
      connectTimeout: AppConfig.connectTimeout,
      receiveTimeout: AppConfig.connectTimeout,
      headers: {'Accept': 'application/json'},
    ));

    // Attach auth header
    d.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        final token = getToken == null ? null : await getToken();
        if (token != null && token.isNotEmpty) {
          options.headers['Authorization'] = 'Bearer $token';
        }
        return handler.next(options);
      },
      onError: (e, handler) {
        // Centralized error mapping/logging
        return handler.next(e);
      },
    ));

    return ApiClient._(d);
  }
}
