import 'package:flutter/material.dart';
import 'cart_page.dart';
import 'currency_format.dart';
import 'food_card.dart';
import 'food_controller.dart';
import 'food_details_sheet.dart';
import 'food_repository.dart';
import 'utils/localization_helper.dart';

class FoodPage extends StatefulWidget {
  const FoodPage({super.key});

  @override
  State<FoodPage> createState() => _FoodPageState();
}

class _FoodPageState extends State<FoodPage> with LocalizationMixin {
  late final FoodController controller;
  final TextEditingController _search = TextEditingController();
  bool _showCartBanner = false;

  @override
  void initState() {
    super.initState();
    controller = FoodController();
    _loadData();
  }

  Future<void> _loadData() async {
    await FoodRepository.loadAllData();
    setState(() {
      // Refresh UI after data is loaded
    });
  }

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  void _openDetails(item) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      showDragHandle: true,
      backgroundColor: Theme.of(context).colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (ctx) => FoodDetailsSheet(
        item: item,
        formatPrice: formatRupiah,
        onPlaceOrder: () {
          
          Navigator.of(ctx).pop();
          setState(() {
            controller.addToCart(item);
            _showCartBanner = true;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(getText('order_placed_successfully')),
              behavior: SnackBarBehavior.floating,
            ),
          );
        },
        onFavoriteChanged: (isFavorite) {
          // Update repository and refresh UI
          FoodRepository.updateDishFavoriteStatus(item.id, isFavorite);
          setState(() {
            // Trigger UI refresh
          });
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    final items = controller.filtered();

    return withDirectionality(
      Scaffold(
        appBar: createLocalizedAppBar(
          titleKey: 'food',
          actions: [
            IconButton(
              icon: Icon(
                controller.showFavoritesOnly ? Icons.favorite : Icons.favorite_border,
                color: controller.showFavoritesOnly ? Colors.red : null,
              ),
              onPressed: () {
                setState(() {
                  controller.showFavoritesOnly = !controller.showFavoritesOnly;
                });
              },
              tooltip: controller.showFavoritesOnly ? getText('show_all_items') : getText('show_favorites_only'),
            ),
            IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const CartPage()),
                );
              },
              icon: const Icon(Icons.shopping_cart),
            ),
          ],
        ),
      body: Stack(
        children: [
          Column(
            children: [
              // Search
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                child: TextField(
                  controller: _search,
                  onChanged: (v) => setState(() => controller.query = v.trim()),
                  decoration: InputDecoration(
                    hintText: getText('search_food'),
                    prefixIcon: const Icon(Icons.search),
                    filled: true,
                    fillColor: cs.surfaceContainerHighest.withOpacity(.6),
                    contentPadding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),

              // Favorites indicator
              if (controller.showFavoritesOnly)
                Padding(
                  padding: const EdgeInsets.only(top: 8.0, left: 16.0, right: 16.0),
                  child: Row(
                    children: [
                      const Icon(Icons.favorite, color: Colors.red, size: 20),
                      const SizedBox(width: 8),
                      Text(
                        getText('showing_favorites_only'),
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.primary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const Spacer(),
                      TextButton(
                        onPressed: () {
                          setState(() {
                            controller.showFavoritesOnly = false;
                          });
                        },
                        child: Text(getText('clear')),
                      ),
                    ],
                  ),
                ),

              // Chips
              SizedBox(
                height: 48,
                child: ListView.separated(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (_, i) {
                    final label = controller.categories[i];
                    final active = label == controller.activeCategory;
                    String localizedLabel;
                    if (label == 'All') {
                      localizedLabel = getText('all');
                    } else if (isArabic) {
                      // Get Arabic category name (same index since both lists include 'All'/'الكل')
                      localizedLabel = controller.categoriesAr[i];
                    } else {
                      localizedLabel = label;
                    }
                    return ChoiceChip(
                      label: Text(localizedLabel),
                      selected: active,
                      onSelected: (_) =>
                          setState(() => controller.activeCategory = label),
                      showCheckmark: false,
                      labelStyle: TextStyle(
                        color: active ? Colors.white : cs.onSurface,
                        fontWeight: FontWeight.w600,
                      ),
                      selectedColor: const Color(0xFF1AA483),
                      backgroundColor: cs.surfaceContainerHighest,
                      shape: StadiumBorder(
                        side: BorderSide(
                          color: active
                              ? const Color(0xFF1AA483)
                              : cs.outlineVariant,
                        ),
                      ),
                    );
                  },
                  separatorBuilder: (_, __) => const SizedBox(width: 8),
                  itemCount: controller.categories.length,
                ),
              ),

              // Grid
              Expanded(
                child: GridView.builder(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisExtent: 235, // ← was 215
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                  ),
                  itemCount: items.length,
                  itemBuilder: (_, i) {
                    final item = items[i];
                    return FoodCard(
                      item: item,
                      priceText: formatRupiah(item.price),
                      onTap: () => _openDetails(item),
                      onFavoriteChanged: (isFavorite) {
                        // Update repository and refresh UI
                        FoodRepository.updateDishFavoriteStatus(item.id, isFavorite);
                        setState(() {
                          // Trigger UI refresh
                        });
                      },
                    );
                  },
                ),
              ),
            ],
          ),
          if (_showCartBanner)
            Positioned(
              left: 12,
              right: 12,
              bottom: 12,
              child: Material(
                elevation: 8,
                borderRadius: BorderRadius.circular(12),
                color: Theme.of(context).colorScheme.surface,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: cs.outlineVariant),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          '${controller.cartCount} ${getText('items')} • ${formatRupiah(controller.cartTotal)}',
                          style: const TextStyle(fontWeight: FontWeight.w600),
                        ),
                      ),
                      FilledButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => CartPage()),
                          );
                        },
                        child: Text(getText('cart')),
                      ),
                      IconButton(
                        tooltip: getText('hide'),
                        onPressed: () =>
                            setState(() => _showCartBanner = false),
                        icon: const Icon(Icons.close),
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    ),
    );
  }
}
