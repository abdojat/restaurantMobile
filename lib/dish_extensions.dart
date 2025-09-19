import 'services/language_service.dart';
import 'recent_page.dart';

extension DishExtensions on Dish {
  String getLocalizedName() {
    final languageService = LanguageService();
    return languageService.isArabic ? nameAr.isNotEmpty ? nameAr : name : name;
  }

  String getLocalizedDescription() {
    final languageService = LanguageService();
    return languageService.isArabic ? descriptionAr.isNotEmpty ? descriptionAr : description : description;
  }

  String getLocalizedIngredients() {
    final languageService = LanguageService();
    return languageService.isArabic ? ingredientsAr.isNotEmpty ? ingredientsAr : ingredients : ingredients;
  }

  String getLocalizedAllergens() {
    final languageService = LanguageService();
    return languageService.isArabic ? allergensAr.isNotEmpty ? allergensAr : allergens : allergens;
  }
}

extension TableExtensions on Table {
  String getLocalizedName() {
    final languageService = LanguageService();
    return languageService.isArabic ? nameAr.isNotEmpty ? nameAr : name : name;
  }

  String getLocalizedDescription() {
    final languageService = LanguageService();
    return languageService.isArabic ? descriptionAr.isNotEmpty ? descriptionAr : description : description;
  }
}
