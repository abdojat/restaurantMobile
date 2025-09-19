

import 'food_item.dart';
import 'food_repository.dart';
import 'extensions/food_item_extensions.dart';

class FoodController {
  FoodController();

  String activeCategory = 'All';
  String query = '';
  bool showFavoritesOnly = false;

  int cartCount = 0;
  int cartTotal = 0;

  List<FoodItem> get all => FoodRepository.dishes;

  List<String> get categories => FoodRepository.categories;
  
  List<String> get categoriesAr => FoodRepository.categoriesAr;

  List<FoodItem> filtered() {
    return all.where((f) {
      final byCat = activeCategory == 'All' || 
          f.category == activeCategory || 
          f.getLocalizedCategory() == activeCategory;
      final byQuery = query.isEmpty || 
          f.name.toLowerCase().contains(query.toLowerCase()) ||
          f.getLocalizedName().toLowerCase().contains(query.toLowerCase());
      final byFavorite = !showFavoritesOnly || f.isFavorite;
      return byCat && byQuery && byFavorite;
    }).toList();
  }

  void addToCart(FoodItem item) {
    cartCount += 1;
    cartTotal += item.price;
  }
}
