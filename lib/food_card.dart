import 'package:flutter/material.dart';
import 'food_item.dart';
import 'services/favorites_service.dart';
import 'extensions/food_item_extensions.dart';
import 'services/language_service.dart';
import 'utils/localization_helper.dart';

class FoodCard extends StatefulWidget {
  const FoodCard({
    super.key,
    required this.item,
    required this.priceText,
    required this.onTap,
    this.onFavoriteChanged,
  });

  final FoodItem item;
  final String priceText;
  final VoidCallback onTap;
  final Function(bool isFavorite)? onFavoriteChanged;

  @override
  State<FoodCard> createState() => _FoodCardState();
}

class _FoodCardState extends State<FoodCard> with LocalizationMixin {
  bool _isLoading = false;
  late bool _isFavorite;
  final LanguageService _languageService = LanguageService();

  @override
  void initState() {
    super.initState();
    _isFavorite = widget.item.isFavorite;
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

  Future<void> _toggleFavorite() async {
    if (_isLoading) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final newFavoriteStatus =
          await FavoritesService.toggleFavorite(widget.item.id);
      setState(() {
        _isFavorite = newFavoriteStatus;
        _isLoading = false;
      });

      // Notify parent widget about the change
      widget.onFavoriteChanged?.call(newFavoriteStatus);
    } catch (e) {
      setState(() {
        _isLoading = false;
      });

      // Show error message
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(getText('failed_update_favorite')),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return withDirectionality(
      InkWell(
      onTap: widget.onTap,
      borderRadius: BorderRadius.circular(14),
      child: Ink(
        decoration: BoxDecoration(
          color: cs.surface,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: cs.outlineVariant),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            ClipRRect(
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(13)),
              child: AspectRatio(
                aspectRatio: 1.5,
                child: widget.item.imageUrl.isNotEmpty
                    ? Image.network(widget.item.imageUrl, fit: BoxFit.cover)
                    : Image.asset('images/placeholder.jpg', fit: BoxFit.cover),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 8, 10, 4),
              child: Text(
                widget.item.getLocalizedName(),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style:
                    const TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
              ),
            ),
            Flexible(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Row(
                  children: [
                    const Icon(Icons.star, size: 16, color: Colors.amber),
                    const SizedBox(width: 4),
                    Flexible(
                      child: Text(
                        widget.item.rating.toStringAsFixed(1),
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ),
                    const Spacer(),
                    IconButton(
                      onPressed: _isLoading ? null : _toggleFavorite,
                      icon: _isLoading
                          ? const SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : Icon(
                              _isFavorite
                                  ? Icons.favorite
                                  : Icons.favorite_border,
                              color: _isFavorite ? Colors.red : null,
                            ),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(minWidth: 24, minHeight: 24),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 2, 10, 8),
              child: Text(
                widget.priceText,
                style: const TextStyle(
                    fontWeight: FontWeight.w800, fontSize: 13.5),
              ),
            ),
          ],
        ),
      ),
    ),
    );
  }
}
