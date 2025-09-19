import '../models/table_model.dart';
import '../services/language_service.dart';

extension TableModelLocalization on TableModel {
  /// Get localized name based on current language
  String getLocalizedName() {
    final languageService = LanguageService();
    if (languageService.isArabic && nameAr.isNotEmpty) {
      return nameAr;
    }
    return name;
  }

  /// Get localized description based on current language
  String getLocalizedDescription() {
    final languageService = LanguageService();
    if (languageService.isArabic && descriptionAr.isNotEmpty) {
      return descriptionAr;
    }
    return description;
  }
}
