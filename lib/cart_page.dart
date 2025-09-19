import 'package:flutter/material.dart';
import 'recent_page.dart';
import 'table_page.dart';
import 'services/cart_service.dart';
import 'utils/localization_helper.dart';
import 'extensions/food_item_extensions.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> with LocalizationMixin {
  final CartService _cartService = CartService();

  @override
  Widget build(BuildContext context) {
    int calculateReservationsTotal() {
      return _cartService.reservations
          .fold(0, (sum, reservation) => sum + reservation.totalPrice);
    }

    int calculateFoodTotal() {
      return _cartService.items.fold(0, (sum, item) => sum + item.totalPrice);
    }

    int calculateTotal() {
      return calculateReservationsTotal() + calculateFoodTotal();
    }

    String formatPrice(int price) {
      return "${price.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')} SP";
    }

    return withDirectionality(
      Scaffold(
        backgroundColor: Colors.white,
        appBar: createLocalizedAppBar(titleKey: 'detail_cart'),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ==== FOOD SECTION ====
                Text(
                  getText('food'),
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 12),

                // Display cart items
                if (_cartService.items.isNotEmpty)
                  Column(
                    children: _cartService.items.map((cartItem) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: Row(
                          children: [
                            SizedBox(
                              height: 80,
                              width: 80,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.network(
                                  cartItem.foodItem.imageUrl,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Container(
                                      color: Colors.grey[300],
                                      child: const Icon(Icons.food_bank,
                                          color: Colors.grey),
                                    );
                                  },
                                ),
                              ),
                            ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(12),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      cartItem.foodItem.getLocalizedName(),
                                      style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500),
                                    ),
                                    Text(
                                      formatPrice(cartItem.foodItem.price),
                                      style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            // Quantity controls
                            Row(
                              children: [
                                IconButton(
                                  onPressed: () {
                                    setState(() {
                                      _cartService.updateQuantity(
                                          cartItem.foodItem.id,
                                          cartItem.quantity - 1);
                                    });
                                  },
                                  icon: const Icon(Icons.remove_circle_outline,
                                      color: Color(0xFF008C8C)),
                                ),
                                Text(
                                  cartItem.quantity.toString(),
                                  style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500),
                                ),
                                IconButton(
                                  onPressed: () {
                                    setState(() {
                                      _cartService.updateQuantity(
                                          cartItem.foodItem.id,
                                          cartItem.quantity + 1);
                                    });
                                  },
                                  icon: const Icon(Icons.add_circle_outline,
                                      color: Color(0xFF008C8C)),
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  )
                else
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text(
                          getText('add_items'),
                          style: const TextStyle(
                              color: Color(0xFF008C8C),
                              fontSize: 16,
                              fontWeight: FontWeight.w500),
                        ),
                      ),
                    ],
                  ),

                const SizedBox(height: 20),

                // ==== TABLES SECTION ====
                Text(
                  getText('tables'),
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 12),

                if (_cartService.reservations.isNotEmpty)
                  Column(
                    children: _cartService.reservations.map((reservation) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey[300]!),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Table name and type
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    reservation.tableName,
                                    style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500),
                                  ),
                                  Text(
                                    formatPrice(reservation.basePrice),
                                    style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 4),
                              // Date and time
                              Text(
                                '${reservation.reservationDate.day}/${reservation.reservationDate.month}/${reservation.reservationDate.year} - ${reservation.reservationTime.format(context)}',
                                style: TextStyle(
                                    fontSize: 14, color: Colors.grey[600]),
                              ),
                              Text(
                                '${getText('duration')}: ${reservation.duration}',
                                style: TextStyle(
                                    fontSize: 14, color: Colors.grey[600]),
                              ),
                              // Show selected additions if any
                              ...reservation.additions.entries
                                  .where((entry) =>
                                      entry.value['isSelected'] == true)
                                  .map((entry) {
                                return Padding(
                                  padding: const EdgeInsets.only(top: 4),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text('+ ${entry.key}',
                                          style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.grey[600])),
                                      Text("${entry.value['price']}",
                                          style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.grey[600])),
                                    ],
                                  ),
                                );
                              }),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  )
                else
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const TablePage()));
                        },
                        child: Text(
                          getText('add_table'),
                          style: const TextStyle(
                              color: Color(0xFF008C8C),
                              fontSize: 16,
                              fontWeight: FontWeight.w500),
                        ),
                      ),
                    ],
                  ),

                const SizedBox(height: 20),

                // ==== TOTAL SECTION ====
                Text(getText('total'),
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.w500)),
                const SizedBox(height: 12),
                if (calculateFoodTotal() > 0)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(getText('food'),
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w400)),
                      Text(formatPrice(calculateFoodTotal()),
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w500)),
                    ],
                  ),
                if (calculateFoodTotal() > 0 &&
                    calculateReservationsTotal() > 0)
                  const SizedBox(height: 8),
                if (calculateReservationsTotal() > 0)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(getText('table_reservations'),
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w400)),
                      Text(formatPrice(calculateReservationsTotal()),
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w500)),
                    ],
                  ),
                const Divider(
                    height: 32, thickness: 0.5, color: Color(0xFFB3B3B3)),

                Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    formatPrice(calculateTotal()),
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.w600),
                  ),
                ),
                const SizedBox(height: 20),

                // ==== CONTINUE BUTTON ====
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF008C8C),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6)),
                    ),
                    onPressed: calculateTotal() > 0
                        ? () async {
                            // Show loading indicator
                            showDialog(
                              context: context,
                              barrierDismissible: false,
                              builder: (context) => const Center(
                                child: CircularProgressIndicator(
                                  color: Color(0xFF008C8C),
                                ),
                              ),
                            );

                            try {
                              final success =
                                  await _cartService.placeCartOrder();

                              // Close loading dialog
                              Navigator.of(context).pop();

                              if (success) {
                                // Show success message
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                        getText('order_placed_successfully')),
                                    backgroundColor: const Color(0xFF008C8C),
                                  ),
                                );

                                // Navigate to recent page
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const RecentPage()));
                              } else {
                                // Show error message
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(getText('order_failed')),
                                    backgroundColor: Colors.red,
                                  ),
                                );
                              }
                            } catch (e) {
                              // Close loading dialog
                              Navigator.of(context).pop();

                              // Show error message
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                      '${getText('error')}: ${e.toString()}'),
                                  backgroundColor: Colors.red,
                                ),
                              );
                            }
                          }
                        : null,
                    child: Text(
                      calculateTotal() > 0
                          ? getText('place_order')
                          : getText('add_items_to_cart'),
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: calculateTotal() > 0
                              ? Colors.white
                              : Colors.grey),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
