import 'package:flutter/material.dart';
import '../food_item.dart';
import '../services/language_service.dart';
import '../extensions/food_item_extensions.dart';

class LocalizedFoodCard extends StatefulWidget {
  final FoodItem foodItem;
  final VoidCallback? onTap;

  const LocalizedFoodCard({
    super.key,
    required this.foodItem,
    this.onTap,
  });

  @override
  State<LocalizedFoodCard> createState() => _LocalizedFoodCardState();
}

class _LocalizedFoodCardState extends State<LocalizedFoodCard> {
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

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: _languageService.isRTL ? TextDirection.rtl : TextDirection.ltr,
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: InkWell(
          onTap: widget.onTap,
          borderRadius: BorderRadius.circular(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Food Image
              ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                child: AspectRatio(
                  aspectRatio: 16 / 9,
                  child: Image.network(
                    widget.foodItem.imageUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: Colors.grey[300],
                        child: const Icon(
                          Icons.restaurant,
                          size: 50,
                          color: Colors.grey,
                        ),
                      );
                    },
                  ),
                ),
              ),
              
              // Food Details
              Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Food Name (Localized)
                    Text(
                      widget.foodItem.getLocalizedName(),
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    
                    const SizedBox(height: 4),
                    
                    // Category (Localized)
                    Text(
                      widget.foodItem.getLocalizedCategory(),
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                    ),
                    
                    const SizedBox(height: 8),
                    
                    // Description (Localized) - if available
                    if (widget.foodItem.getLocalizedDescription().isNotEmpty) ...[
                      Text(
                        widget.foodItem.getLocalizedDescription(),
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[700],
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 8),
                    ],
                    
                    // Price and Rating Row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Price
                        Text(
                          '${widget.foodItem.price} ${_languageService.isArabic ? 'ريال' : 'IDR'}',
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF008C8C),
                          ),
                        ),
                        
                        // Rating
                        Row(
                          children: [
                            const Icon(
                              Icons.star,
                              size: 16,
                              color: Colors.amber,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              widget.foodItem.rating.toStringAsFixed(1),
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
