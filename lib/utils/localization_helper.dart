import 'package:flutter/material.dart';
import '../services/language_service.dart';

/// A mixin to provide localization capabilities to StatefulWidget classes
mixin LocalizationMixin<T extends StatefulWidget> on State<T> {
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
      setState(() {});
    }
  }

  /// Get localized text
  String getText(String key) => _languageService.getText(key);

  /// Check if current language is Arabic
  bool get isArabic => _languageService.isArabic;

  /// Check if current language is RTL
  bool get isRTL => _languageService.isRTL;

  /// Wrap widget with proper directionality
  Widget withDirectionality(Widget child) {
    return Directionality(
      textDirection: isRTL ? TextDirection.rtl : TextDirection.ltr,
      child: child,
    );
  }

  /// Create localized AppBar
  AppBar createLocalizedAppBar({
    required String titleKey,
    List<Widget>? actions,
    Widget? leading,
    bool automaticallyImplyLeading = true,
  }) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      title: Text(
        getText(titleKey),
        style: const TextStyle(
          color: Colors.black,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
      ),
      centerTitle: true,
      leading: leading ?? (automaticallyImplyLeading ? IconButton(
        icon: Icon(
          isRTL ? Icons.arrow_forward_ios : Icons.arrow_back_ios,
          color: const Color(0xFF008C8C),
        ),
        onPressed: () => Navigator.pop(context),
      ) : null),
      actions: actions,
    );
  }

  /// Create localized bottom navigation bar items
  List<BottomNavigationBarItem> createLocalizedBottomNavItems() {
    return [
      BottomNavigationBarItem(
        icon: const Icon(Icons.home),
        label: getText("home"),
      ),
      BottomNavigationBarItem(
        icon: const Icon(Icons.search),
        label: getText("search"),
      ),
      BottomNavigationBarItem(
        icon: const Icon(Icons.history),
        label: getText("orders"),
      ),
      BottomNavigationBarItem(
        icon: const Icon(Icons.person),
        label: getText("profile"),
      ),
    ];
  }
}
