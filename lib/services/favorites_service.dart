import 'package:shared_preferences/shared_preferences.dart';
import '../core/api_client.dart';
import '../config/app_config.dart';

class FavoritesService {
  static late final ApiClient _apiClient;

  static void initialize() {
    _apiClient = ApiClient(
      baseUrl: AppConfig.apiUrl,
      getToken: _getStoredToken,
    );
  }

  static Future<String?> _getStoredToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('auth_token');
  }

  /// Toggle favorite status for a dish
  static Future<bool> toggleFavorite(String dishId) async {
    try {
      final response = await _apiClient.dio.post(
        '/customer/favorites/toggle',
        data: {'dish_id': dishId},
      );

      if (response.statusCode == 200) {
        return response.data['is_favorited'] ?? false;
      } else {
        throw Exception('Failed to toggle favorite: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error toggling favorite: $e');
    }
  }

  /// Add dish to favorites
  static Future<void> addToFavorites(String dishId) async {
    try {
      final response = await _apiClient.dio.post(
        '/customer/favorites',
        data: {'dish_id': dishId},
      );

      if (response.statusCode != 201) {
        throw Exception('Failed to add to favorites: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error adding to favorites: $e');
    }
  }

  /// Remove dish from favorites
  static Future<void> removeFromFavorites(String dishId) async {
    try {
      final response = await _apiClient.dio.delete(
        '/customer/favorites/$dishId',
      );

      if (response.statusCode != 200) {
        throw Exception(
            'Failed to remove from favorites: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error removing from favorites: $e');
    }
  }

  /// Get user's favorite dishes
  static Future<List<dynamic>> getFavorites({String? categoryId}) async {
    try {
      String endpoint = '/customer/favorites';
      Map<String, dynamic>? queryParams;

      if (categoryId != null) {
        queryParams = {'category_id': categoryId};
      }

      final response = await _apiClient.dio.get(
        endpoint,
        queryParameters: queryParams,
      );

      if (response.statusCode == 200) {
        return response.data['favorites'] ?? [];
      } else {
        throw Exception('Failed to get favorites: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error getting favorites: $e');
    }
  }
}
