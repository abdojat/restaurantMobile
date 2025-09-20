import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/table_model.dart';
import '../models/user_model.dart';
import '../food_item.dart';
import '../config/app_config.dart';
import 'dart:io';

class ApiService {
  static final Dio _dio = Dio(BaseOptions(
    baseUrl: AppConfig.baseUrl,
    connectTimeout: AppConfig.connectTimeout,
    receiveTimeout: AppConfig.receiveTimeout,
    headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    },
  ));

  // Get stored authentication token from SharedPreferences
  static Future<void> _initializeAuth() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');
    if (token != null && token.isNotEmpty) {
      _dio.options.headers['Authorization'] = 'Bearer $token';
    }
  }

  static void setAuthToken(String token) {
    _dio.options.headers['Authorization'] = 'Bearer $token';
  }

  static void clearAuthToken() {
    _dio.options.headers.remove('Authorization');
  }

  static int _parsePrice(dynamic price) {
    if (price == null) return 0;
    if (price is num) return price.toInt();
    if (price is String) {
      final numericString = price.replaceAll(RegExp(r'[^\d.]'), '');
      return double.tryParse(numericString)?.toInt() ?? 0;
    }
    return 0;
  }

  static Future<List<TableModel>> getTables() async {
    try {
      print('🔍 Fetching tables from: ${AppConfig.baseUrl}/api/menu/tables');
      final response = await _dio.get('/api/menu/tables');

      print('📊 Response status: ${response.statusCode}');
      print('📊 Response data: ${response.data}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = response.data;
        final List<dynamic> tablesJson = data['tables'];

        print('✅ Found ${tablesJson.length} tables');
        return tablesJson.map((json) => TableModel.fromJson(json)).toList();
      } else {
        print('❌ API returned status ${response.statusCode}: ${response.data}');
        throw Exception('Failed to load tables: ${response.statusCode} - ${response.data}');
      }
    } on DioException catch (e) {
      print('❌ DioException: ${e.type}');
      print('❌ Message: ${e.message}');
      if (e.response != null) {
        print('❌ Response status: ${e.response!.statusCode}');
        print('❌ Response data: ${e.response!.data}');
        
        // Handle the specific database schema error
        if (e.response!.statusCode == 500 && 
            e.response!.data.toString().contains('image_path') &&
            e.response!.data.toString().contains('does not exist')) {
          print('🔧 Database schema issue detected - returning empty tables list');
          // Return empty list as temporary workaround
          return <TableModel>[];
        }
      }
      
      if (e.type == DioExceptionType.connectionTimeout) {
        throw Exception(
            'Connection timeout. Please check your internet connection.');
      } else if (e.type == DioExceptionType.receiveTimeout) {
        throw Exception('Server response timeout. Please try again.');
      } else if (e.response != null) {
        throw Exception('Server error: ${e.response!.statusCode} - ${e.response!.data}');
      } else {
        throw Exception('Network error: ${e.message}');
      }
    } catch (e) {
      print('❌ Unexpected error: $e');
      throw Exception('Unexpected error: $e');
    }
  }

  static Future<List<FoodItem>> getDiscountedDishes() async {
    try {
      final response = await _dio.get('/api/menu/discounts');
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = response.data;
        final List<dynamic> dishesJson =
            data['discounted_dishes'] ?? data['data'] ?? [];

        return dishesJson
            .map((json) => FoodItem(
                  id: json['id'].toString(),
                  name: json['name'] ?? 'Unknown Dish',
                  nameAr: json['name_ar'],
                  description: json['description'],
                  descriptionAr: json['description_ar'],
                  imageUrl: json['image_path'] != null
                      ? '${json['image_path']}'
                      : 'images/placeholder.jpg',
                  price: _parsePrice(json['discounted_price']) != 0
                      ? _parsePrice(json['discounted_price'])
                      : _parsePrice(json['price']),
                  rating:
                      4.0, // Default rating since not provided in discount response
                  category: json['category']?['name'] ?? 'Food',
                  categoryAr: json['category']?['name_ar'],
                  isFavorite: false,
                ))
            .toList();
      } else {
        throw Exception(
            'Failed to load discounted dishes: ${response.statusCode}');
      }
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout) {
        throw Exception(
            'Connection timeout. Please check your internet connection.');
      } else if (e.type == DioExceptionType.receiveTimeout) {
        throw Exception('Server response timeout. Please try again.');
      } else if (e.response != null) {
        throw Exception('Server error: ${e.response!.statusCode}');
      } else {
        throw Exception('Network error: ${e.message}');
      }
    } catch (e) {
      throw Exception('Unexpected error: $e');
    }
  }

  static Future<List<FoodItem>> getRecommendedDishes() async {
    try {
      final response = await _dio.get('/api/menu/recommendations');

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = response.data;
        final List<dynamic> dishesJson =
            data['recommendations'] ?? data['data'] ?? [];

        return dishesJson
            .map((json) => FoodItem(
                  id: json['id'].toString(),
                  name: json['name'] ?? 'Unknown Dish',
                  nameAr: json['name_ar'],
                  description: json['description'],
                  descriptionAr: json['description_ar'],
                  imageUrl: json['image_path'] != null
                      ? '${json['image_path']}'
                      : 'images/placeholder.jpg',
                  price: _parsePrice(json['price']),
                  rating: (json['average_rating'] ?? 4.0).toDouble(),
                  category: json['category']?['name'] ?? 'Food',
                  categoryAr: json['category']?['name_ar'],
                  isFavorite: false,
                ))
            .toList();
      } else {
        throw Exception(
            'Failed to load recommended dishes: ${response.statusCode}');
      }
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout) {
        throw Exception(
            'Connection timeout. Please check your internet connection.');
      } else if (e.type == DioExceptionType.receiveTimeout) {
        throw Exception('Server response timeout. Please try again.');
      } else if (e.response != null) {
        throw Exception('Server error: ${e.response!.statusCode}');
      } else {
        throw Exception('Network error: ${e.message}');
      }
    } catch (e) {
      throw Exception('Unexpected error: $e');
    }
  }

  static Future<bool> createOrder({
    String? tableId,
    required String type,
    required List<Map<String, dynamic>> items,
    String? notes,
    String? specialInstructions,
  }) async {
    try {
      // Initialize auth token if not already set
      await _initializeAuth();
      final orderData = {
        'table_id': tableId,
        'type': type,
        'items': items,
        'notes': notes,
        'special_instructions': specialInstructions,
      };
      final response = await _dio.post('/api/customer/orders', data: orderData);

      return response.statusCode == 201;
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout) {
        throw Exception(
            'Connection timeout. Please check your internet connection.');
      } else if (e.type == DioExceptionType.receiveTimeout) {
        throw Exception('Server response timeout. Please try again.');
      } else if (e.response != null) {
        throw Exception('Server error: ${e.response!.statusCode}');
      } else {
        throw Exception('Network error: ${e.message}');
      }
    } catch (e) {
      throw Exception('Unexpected error: $e');
    }
  }

  static Future<bool> createReservation({
    required String tableId,
    required DateTime startDate,
    required DateTime endDate,
    required int guests,
    String? specialRequests,
    String? contactPhone,
    String? contactEmail,
  }) async {
    try {
      // Initialize auth token if not already set
      await _initializeAuth();
      final reservationData = {
        'table_id': tableId,
        'start_date': startDate.toIso8601String(),
        'end_date': endDate.toIso8601String(),
        'guests': guests,
        'special_requests': specialRequests,
        'contact_phone': contactPhone,
        'contact_email': contactEmail,
      };

      final response =
          await _dio.post('/api/customer/reservations', data: reservationData);

      return response.statusCode == 201;
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout) {
        throw Exception(
            'Connection timeout. Please check your internet connection.');
      } else if (e.type == DioExceptionType.receiveTimeout) {
        throw Exception('Server response timeout. Please try again.');
      } else if (e.response != null) {
        throw Exception('Server error: ${e.response!.statusCode}');
      } else {
        throw Exception('Network error: ${e.message}');
      }
    } catch (e) {
      throw Exception('Unexpected error: $e');
    }
  }

  static Future<UserModel> updateProfile({
    String? name,
    String? email,
    String? phoneNumber,
    File? avatarFile,
  }) async {
    try {
      await _initializeAuth();

      FormData formData = FormData();

      if (name != null) {
        formData.fields.add(MapEntry('name', name));
      }
      if (email != null) {
        formData.fields.add(MapEntry('email', email));
      }
      if (phoneNumber != null) {
        formData.fields.add(MapEntry('phone_number', phoneNumber));
      }

      if (avatarFile != null) {
        formData.files.add(MapEntry(
          'avatar',
          await MultipartFile.fromFile(avatarFile.path),
        ));
      }

      final response = await _dio.post('/api/auth/profile', data: formData);

      if (response.statusCode == 200) {
        final userData = response.data['user'];
        return UserModel.fromJson(userData);
      } else {
        throw Exception('Failed to update profile: ${response.statusCode}');
      }
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout) {
        throw Exception(
            'Connection timeout. Please check your internet connection.');
      } else if (e.type == DioExceptionType.receiveTimeout) {
        throw Exception('Server response timeout. Please try again.');
      } else if (e.response != null) {
        final errorMessage = e.response?.data['message'] ??
            'Server error: ${e.response!.statusCode}';
        throw Exception(errorMessage);
      } else {
        throw Exception('Network error: ${e.message}');
      }
    } catch (e) {
      throw Exception('Unexpected error: $e');
    }
  }
}
