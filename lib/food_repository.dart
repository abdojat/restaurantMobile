import 'package:dio/dio.dart';
import 'food_item.dart';
import 'config/app_config.dart';
import 'services/favorites_service.dart';

/// Replace this with your API/repository later.
class FoodRepository {
  static final Dio _dio = Dio();
  static List<String> _categories = [];
  static List<String> _categoriesAr = [];
  static List<FoodItem> _dishes = [];
  static List<FoodItem> _filteredDishes = [];
  static final String _currentCategory = 'All';
  static final String _searchQuery = '';

  static List<String> get categories => ['All', ..._categories];
  static List<String> get categoriesAr => ['الكل', ..._categoriesAr];
  static List<FoodItem> get dishes => _filteredDishes;
  static String get currentCategory => _currentCategory;
  static String get searchQuery => _searchQuery;

  // Fetch categories from API
  static Future<void> fetchCategories() async {
    try {
      final response =
          await _dio.get('${AppConfig.menuUrl}/categories');
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data['categories'];
        _categories =
            data.map((category) => category['name'].toString()).toList();
        _categoriesAr =
            data.map((category) => category['name_ar']?.toString() ?? category['name'].toString()).toList();
      }
    } catch (e) {
      // Keep default categories if API call fails
    }
  }

  static Future<void> fetchMenu() async {
    try {
      final response = await _dio.get(AppConfig.menuUrl);
      if (response.statusCode == 200) {
        final List<dynamic> menuData = response.data['menu'];
        List<FoodItem> allDishes = [];

        // Fetch user's favorites
        List<String> favoriteIds = [];
        try {
          final favorites = await FavoritesService.getFavorites();
          favoriteIds = favorites.map((fav) => fav['id'].toString()).toList();
        } catch (e) {
          // Continue without favorites if not logged in or error occurs
        }

        for (var category in menuData) {
          final String categoryName = category['name'];
          final String categoryNameAr = category['name_ar'];
          final List<dynamic> dishes = category['dishes'] ?? [];
          for (var dish in dishes) {
            final dishId = dish['id'].toString();
            final foodItem = FoodItem(
              id: dishId,
              name: dish['name'] ?? '',
              nameAr: dish['name_ar'],
              description: dish['description'],
              descriptionAr: dish['description_ar'],
              imageUrl: dish['image_path'] != null
                  ? '${dish['image_path']}'
                  : '',
              price: (double.tryParse(dish['price']?.toString() ?? '0') ?? 0.0)
                  .round(),
              rating: 4.5, // Default rating since not provided in API
              category: categoryName,
              categoryAr: categoryNameAr,
              isFavorite: favoriteIds.contains(dishId),
            );
            allDishes.add(foodItem);
          }
        }

        _dishes = allDishes;
        _filteredDishes = allDishes;
      }
    } catch (e) {
      // Keep default dishes if API call fails
    }
  }

  List<FoodItem> fetchAll() => _dishes.isNotEmpty
      ? _dishes
      : const [
          FoodItem(
            id: '1',
            name: 'Meatball Sweats',
            imageUrl:
                'https://images.unsplash.com/photo-1544025162-d76694265947?w=800',
            price: 35000,
            rating: 4.8,
            category: 'Dinner Food',
          ),
          FoodItem(
            id: '2',
            name: 'Noodle Ex',
            imageUrl:
                'https://images.unsplash.com/photo-1504754524776-8f4f37790ca0?w=800',
            price: 42000,
            rating: 4.6,
            category: 'Economic Food',
          ),
          FoodItem(
            id: '3',
            name: 'Burger Ala Ala',
            imageUrl:
                'https://images.unsplash.com/photo-1550547660-d9450f859349?w=800',
            price: 28000,
            rating: 4.7,
            category: 'Hot Food',
          ),
          FoodItem(
            id: '4',
            name: 'Chicken Collage',
            imageUrl:
                'https://images.unsplash.com/photo-1625944526791-2e2b8a1feeb3?w=800',
            price: 26000,
            rating: 4.5,
            category: 'Family',
          ),
        ];

  static Future<void> loadAllData() async {
    await Future.wait([
      fetchCategories(),
      fetchMenu(),
    ]);
  }

  /// Refresh favorites status for all dishes without refetching menu
  static Future<void> refreshFavoritesStatus() async {
    try {
      final favorites = await FavoritesService.getFavorites();
      final favoriteIds = favorites.map((fav) => fav['id'].toString()).toSet();

      // Update existing dishes with new favorite status
      _dishes = _dishes
          .map((dish) => dish.copyWith(
                isFavorite: favoriteIds.contains(dish.id),
              ))
          .toList();
    } catch (e) {
      // print('Error refreshing favorites status: $e');
    }
  }

  /// Update a specific dish's favorite status
  static void updateDishFavoriteStatus(String dishId, bool isFavorite) {
    final index = _dishes.indexWhere((dish) => dish.id == dishId);
    if (index != -1) {
      _dishes[index] = _dishes[index].copyWith(isFavorite: isFavorite);
    }
  }
}
