# Arabic Language Switching Implementation Guide

## Overview
The restaurant app now supports Arabic language switching with full RTL (Right-to-Left) support. The backend provides translated properties for dishes, categories, and tables, which are properly handled by the mobile app.

## Features Implemented

### 1. Language Service (`services/language_service.dart`)
- **Singleton pattern** for global language state management
- **Persistent storage** using SharedPreferences
- **RTL support** for Arabic text direction
- **Localization methods** for common UI elements
- **Helper methods** for extracting localized names and descriptions from objects

### 2. Updated Profile Page (`profile_page.dart`)
- **Fully localized** with Arabic translations
- **RTL support** with proper text direction
- **Language switching button** that navigates to language selection
- **Responsive to language changes** with automatic UI updates

### 3. Language Selection Page (`profile_components/language_page.dart`)
- **Interactive language buttons** with visual feedback
- **Current language indication** with check marks
- **Loading states** during language switching
- **Success feedback** with localized messages
- **RTL support** with proper navigation icons

### 4. Enhanced Data Models

#### FoodItem Model (`food_item.dart`)
```dart
class FoodItem {
  final String name;        // English name
  final String? nameAr;     // Arabic name
  final String? description;    // English description
  final String? descriptionAr;  // Arabic description
  final String category;        // English category
  final String? categoryAr;     // Arabic category
  // ... other properties
}
```

#### TableModel (`models/table_model.dart`)
Already includes:
- `name` and `nameAr` properties
- `description` and `descriptionAr` properties

### 5. API Service Updates (`services/api_service.dart`)
- **Enhanced data parsing** to extract Arabic translations
- **Support for translated categories** in dish responses
- **Proper handling** of both English and Arabic properties

### 6. Extension Methods (`extensions/food_item_extensions.dart`)
```dart
extension FoodItemLocalization on FoodItem {
  String getLocalizedName()        // Returns Arabic or English name
  String getLocalizedDescription() // Returns Arabic or English description
  String getLocalizedCategory()    // Returns Arabic or English category
}
```

### 7. Localized UI Components (`widgets/localized_food_card.dart`)
- **Example implementation** of a food card with language switching
- **Automatic RTL support** and text direction handling
- **Responsive to language changes** with proper state management

## Usage Examples

### Basic Language Service Usage
```dart
final languageService = LanguageService();

// Check current language
if (languageService.isArabic) {
  // Handle Arabic-specific logic
}

// Switch languages
await languageService.switchToArabic();
await languageService.switchToEnglish();

// Get localized text
String profileText = languageService.getText('profile');
```

### Using with Food Items
```dart
import 'extensions/food_item_extensions.dart';

// In your widget
Text(foodItem.getLocalizedName())        // Shows Arabic or English name
Text(foodItem.getLocalizedDescription()) // Shows Arabic or English description
Text(foodItem.getLocalizedCategory())    // Shows Arabic or English category
```

### Using with Table Models
```dart
final languageService = LanguageService();

String tableName = languageService.getLocalizedName(tableModel);
String tableDesc = languageService.getLocalizedDescription(tableModel);
```

### Making Widgets Language-Responsive
```dart
class MyWidget extends StatefulWidget {
  @override
  State<MyWidget> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyWidget> {
  final LanguageService _languageService = LanguageService();

  @override
  void initState() {
    super.initState();
    _languageService.addListener(_onLanguageChanged);
  }

  @override
  void dispose() {
    _languageService.removeListener(_onLanguageChanged);
    super.dispose();
  }

  void _onLanguageChanged() {
    if (mounted) {
      setState(() {}); // Rebuild UI when language changes
    }
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: _languageService.isRTL ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
        // Your widget content
      ),
    );
  }
}
```

## Backend Data Structure Expected

The backend should provide the following structure for dishes:
```json
{
  "id": 1,
  "name": "Grilled Chicken",
  "name_ar": "دجاج مشوي",
  "description": "Delicious grilled chicken",
  "description_ar": "دجاج مشوي لذيذ",
  "category": {
    "name": "Main Course",
    "name_ar": "الطبق الرئيسي"
  }
}
```

For tables:
```json
{
  "id": 1,
  "name": "Table 1",
  "name_ar": "طاولة 1",
  "description": "Window side table",
  "description_ar": "طاولة بجانب النافذة"
}
```

## Available Translations

The language service includes translations for common UI elements:
- Profile, Account, Payment Method, My Cart
- Help & Report, Language, Favorite, More Info
- Privacy Policy, News & Services, Give Rating
- Logout, Edit, Save, Cancel, Name, Email
- And more...

## Installation Steps

1. **Language service is automatically initialized** in `main.dart`
2. **Import the language service** where needed:
   ```dart
   import 'services/language_service.dart';
   ```
3. **Use extensions for food items**:
   ```dart
   import 'extensions/food_item_extensions.dart';
   ```
4. **Add language responsiveness** to your widgets as shown in examples above

## Testing the Implementation

1. **Navigate to Profile → Language**
2. **Select Arabic** - UI should switch to RTL with Arabic text
3. **Select English** - UI should switch back to LTR with English text
4. **Check food items** - Names and descriptions should display in selected language
5. **Verify table data** - Table names and descriptions should be localized

The language preference is **automatically saved** and will persist between app sessions.
