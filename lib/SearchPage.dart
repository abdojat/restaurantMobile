// ignore_for_file: file_names, non_constant_identifier_names, sized_box_for_whitespace, avoid_types_as_parameter_names

import 'package:flutter/material.dart';
import 'cart_page.dart';
import 'currency_format.dart';
import 'food_card.dart';
import 'food_controller.dart';
import 'food_details_sheet.dart';
import 'food_repository.dart';
import 'utils/localization_helper.dart';
import 'extensions/food_item_extensions.dart';

class Searchpage extends StatefulWidget {
  const Searchpage({super.key});

  @override
  State<Searchpage> createState() => _SearchpageState();
}

class _SearchpageState extends State<Searchpage> with LocalizationMixin {
  final _searchController = TextEditingController();
  late final FoodController controller;
  String? selectedChip;
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
      // Data loaded, UI will be rebuilt
    });
  }

  List<String> get _popularSearchTerms {
    // Generate popular search terms dynamically based on current language
    return FoodRepository.dishes
        .take(6)
        .map((dish) => dish.getLocalizedName())
        .toList();
  }

  @override
  void dispose() {
    _searchController.dispose();
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
    return withDirectionality(
      Scaffold(
        appBar: createLocalizedAppBar(
          titleKey: 'search',
          automaticallyImplyLeading: false,
          actions: [
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
          Builder(
            builder: (context) {
              final items = controller.filtered();
              
              return CustomScrollView(
                slivers: [
                  // Search box
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(15, 20, 15, 0),
                      child: TextField(
                        controller: _searchController,
                        decoration: InputDecoration(
                          prefixIcon: const Icon(Icons.search),
                          hintText: getText('search_dishes'),
                          filled: true,
                          fillColor: Theme.of(context).colorScheme.surfaceContainerHighest.withOpacity(.6),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                        ),
                        onChanged: (value) {
                          setState(() {
                            controller.query = value.trim();
                          });
                        },
                      ),
                    ),
                  ),
                  
                  // No results message
                  if (controller.query.isNotEmpty && items.isEmpty) ...[
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(15, 40, 15, 40),
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.restaurant_menu_rounded,
                                size: 100,
                                color: Color(0xff008C8C),
                              ),
                              SizedBox(height: 20),
                              Text(
                                getText('no_results_found'),
                                style: const TextStyle(
                                    fontSize: 25, fontWeight: FontWeight.bold),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                  
                  // Popular search or search results header
                  if (controller.query.isEmpty) ...[
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(15, 20, 15, 0),
                        child: Text(
                          getText('popular_search'),
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 25),
                        ),
                      ),
                    ),
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(15, 10, 15, 0),
                        child: Wrap(
                          spacing: 10,
                          children: _popularSearchTerms.map((item) {
                            return FilterChip(
                              backgroundColor: Colors.grey[100],
                              selectedColor: const Color(0xff008C8C),
                              checkmarkColor: Colors.white,
                              shape: const RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20))),
                              side: BorderSide.none,
                              elevation: 10,
                              label: Text(
                                item,
                              ),
                              selected: selectedChip == item,
                              onSelected: (bool value) {
                                setState(() {
                                  selectedChip = value ? item : null;
                                  if (value) {
                                    selectedChip = item;
                                    _searchController.text = item;
                                    controller.query = item;
                                  } else {
                                    selectedChip = null;
                                    _searchController.clear();
                                    controller.query = '';
                                  }
                                });
                              },
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(15, 20, 15, 10),
                        child: Text(
                          getText('suggested_dishes'),
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 25),
                        ),
                      ),
                    ),
                  ] else ...[
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(15, 20, 15, 10),
                        child: Text(
                          "${getText('search_results')} (${items.length})",
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 20),
                        ),
                      ),
                    ),
                  ],
                  
                  // Grid of dishes
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(15, 0, 15, 15),
                    sliver: SliverGrid(
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisExtent: 235,
                        mainAxisSpacing: 12,
                        crossAxisSpacing: 12,
                      ),
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          final item = items[index];
                          return FoodCard(
                            item: item,
                            priceText: formatRupiah(item.price),
                            onTap: () => _openDetails(item),
                            onFavoriteChanged: (isFavorite) {
                              FoodRepository.updateDishFavoriteStatus(item.id, isFavorite);
                              setState(() {
                                // Trigger UI refresh
                              });
                            },
                          );
                        },
                        childCount: items.length,
                      ),
                    ),
                  ),
                ],
              );
            },
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
                    border: Border.all(color: Theme.of(context).colorScheme.outlineVariant),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          '${controller.cartCount} item(s) • ${formatRupiah(controller.cartTotal)}',
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
