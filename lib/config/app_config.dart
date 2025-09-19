class AppConfig {
  // Base server configuration
  static const String baseUrl = 'https://restaurantapi-kyfg.onrender.com';
  
  // API endpoints
  static const String apiUrl = '$baseUrl/api';

  // Specific API endpoints (using fixed /api/image route)
  static const String imageUrl = '$baseUrl/storage';
  static const String menuUrl = '$apiUrl/menu';
  static const String authUrl = '$apiUrl/auth';
  static const String customerUrl = '$apiUrl/customer';

  // Timeout configurations
  static const Duration connectTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);
  static const Duration shortTimeout = Duration(seconds: 15);
  static const Duration veryShortTimeout = Duration(seconds: 10);
}
