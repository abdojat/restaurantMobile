import '../food_item.dart';
import '../services/language_service.dart';

extension FoodItemLocalization on FoodItem {
  /// Get localized name based on current language
  String getLocalizedName() {
    final languageService = LanguageService();
    if (languageService.isArabic && nameAr != null && nameAr!.isNotEmpty) {
      return nameAr!;
    }
    return name;
  }

  /// Get localized description based on current language
  String getLocalizedDescription() {
    final languageService = LanguageService();
    if (languageService.isArabic && descriptionAr != null && descriptionAr!.isNotEmpty) {
      return descriptionAr!;
    }
    return description ?? '';
  }

  /// Get localized category based on current language
  String getLocalizedCategory() {
    final languageService = LanguageService();
    if (languageService.isArabic && categoryAr != null && categoryAr!.isNotEmpty) {
      return categoryAr!;
    }
    return category;
  }
}
