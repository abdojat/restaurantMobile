import 'package:flutter/material.dart';
import '../services/language_service.dart';
import '../utils/localization_helper.dart';

class LanguagePage extends StatefulWidget {
  const LanguagePage({super.key});

  @override
  State<LanguagePage> createState() => _LanguagePageState();
}

class _LanguagePageState extends State<LanguagePage> with LocalizationMixin {
  final LanguageService _languageService = LanguageService();
  bool _isChangingLanguage = false;

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: _languageService.isRTL ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.language, size: 100, color: Color(0xFF008C8C)),
                const SizedBox(height: 20),
                Text(
                  _languageService.getText('select_language'),
                  style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 40),

                // Arabic Button
                _buildLanguageButton(
                  language: 'arabic',
                  isSelected: _languageService.isArabic,
                  onPressed: () => _changeLanguage('ar'),
                ),
                const SizedBox(height: 16),

                // English Button
                _buildLanguageButton(
                  language: 'english',
                  isSelected: _languageService.isEnglish,
                  onPressed: () => _changeLanguage('en'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLanguageButton({
    required String language,
    required bool isSelected,
    required VoidCallback onPressed,
  }) {
    return ElevatedButton(
      onPressed: _isChangingLanguage ? null : onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: isSelected 
            ? const Color(0xFF008C8C) 
            : Colors.grey.shade200,
        minimumSize: const Size(double.infinity, 50),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        elevation: isSelected ? 2 : 0,
      ),
      child: _isChangingLanguage
          ? const SizedBox(
              height: 20,
              width: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            )
          : Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  _languageService.getText(language),
                  style: TextStyle(
                    fontSize: 18,
                    color: isSelected ? Colors.white : Colors.black87,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                  ),
                ),
                if (isSelected) ...[
                  const SizedBox(width: 8),
                  const Icon(
                    Icons.check_circle,
                    color: Colors.white,
                    size: 20,
                  ),
                ],
              ],
            ),
    );
  }

  Future<void> _changeLanguage(String languageCode) async {
    if (_isChangingLanguage) return;

    setState(() {
      _isChangingLanguage = true;
    });

    try {
      if (languageCode == 'ar') {
        await _languageService.switchToArabic();
      } else {
        await _languageService.switchToEnglish();
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(_languageService.getText('language_changed')),
            backgroundColor: Colors.green,
          ),
        );

        // Refresh the UI by rebuilding
        setState(() {});
        
        // Optionally navigate back after a short delay
        await Future.delayed(const Duration(milliseconds: 500));
        if (mounted) {
          Navigator.pop(context);
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error changing language: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isChangingLanguage = false;
        });
      }
    }
  }
}
