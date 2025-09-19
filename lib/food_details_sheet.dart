import 'package:flutter/material.dart';
import 'food_item.dart';
import 'services/favorites_service.dart';
import 'services/cart_service.dart';
import 'utils/localization_helper.dart';
import 'extensions/food_item_extensions.dart';

class FoodDetailsSheet extends StatefulWidget {
  const FoodDetailsSheet({
    super.key,
    required this.item,
    required this.onPlaceOrder,
    required this.formatPrice,
    this.onFavoriteChanged,
  });

  final FoodItem item;
  final VoidCallback onPlaceOrder;
  final String Function(int) formatPrice;
  final Function(bool isFavorite)? onFavoriteChanged;

  @override
  State<FoodDetailsSheet> createState() => _FoodDetailsSheetState();
}

class _FoodDetailsSheetState extends State<FoodDetailsSheet> with LocalizationMixin {
  bool _isLoading = false;
  bool _isAddingToCart = false;
  late bool _isFavorite;
  final CartService _cartService = CartService();

  @override
  void initState() {
    super.initState();
    _isFavorite = widget.item.isFavorite;
  }

  Future<void> _toggleFavorite() async {
    if (_isLoading) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final newFavoriteStatus = await FavoritesService.toggleFavorite(widget.item.id);
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
            content: Text('${getText('failed_update_favorite')}: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _addToCart() async {
    if (_isAddingToCart) return;

    setState(() {
      _isAddingToCart = true;
    });

    try {
      _cartService.addToCart(widget.item);
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${widget.item.getLocalizedName()} ${getText('added_to_cart')}'),
            backgroundColor: const Color(0xFF1AA483),
            duration: const Duration(seconds: 2),
          ),
        );
        
        // Close the bottom sheet after successfully adding to cart
        Navigator.of(context).pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${getText('failed_add_to_cart')}: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
        
        setState(() {
          _isAddingToCart = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return withDirectionality(
      Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: AspectRatio(
              aspectRatio: 16 / 9,
              child: widget.item.imageUrl.isNotEmpty
                  ? Image.network(
                      widget.item.imageUrl,
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
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return Container(
                          color: Colors.grey[200],
                          child: Center(
                            child: CircularProgressIndicator(
                              value: loadingProgress.expectedTotalBytes != null
                                  ? loadingProgress.cumulativeBytesLoaded /
                                      loadingProgress.expectedTotalBytes!
                                  : null,
                              color: const Color(0xFF1AA483),
                            ),
                          ),
                        );
                      },
                    )
                  : Container(
                      color: Colors.grey[300],
                      child: const Icon(
                        Icons.restaurant,
                        size: 50,
                        color: Colors.grey,
                      ),
                    ),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: Text(
                  widget.item.getLocalizedName(),
                  style: const TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: 18,
                  ),
                ),
              ),
              const Icon(Icons.more_horiz),
            ],
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              const Icon(Icons.star, size: 18, color: Colors.amber),
              const SizedBox(width: 4),
              Text(
                widget.item.rating.toStringAsFixed(1),
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: cs.onSurfaceVariant,
                ),
              ),
              const Spacer(),
              IconButton.filledTonal(
                onPressed: _isLoading ? null : _toggleFavorite,
                icon: _isLoading
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : Icon(
                        _isFavorite ? Icons.favorite : Icons.favorite_border,
                        color: _isFavorite ? Colors.red : null,
                      ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              widget.formatPrice(widget.item.price),
              style:
                  const TextStyle(fontWeight: FontWeight.w900, fontSize: 16.5),
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: _isAddingToCart ? null : _addToCart,
              style: FilledButton.styleFrom(
                minimumSize: const Size.fromHeight(46),
                backgroundColor: const Color(0xFF1AA483),
              ),
              child: _isAddingToCart
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(getText('adding')),
                      ],
                    )
                  : Text(getText('add_to_cart')),
            ),
          ),
          const SizedBox(height: 8),
        ],
      ),
    ),
    );
  }
}
