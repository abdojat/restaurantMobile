import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'config/app_config.dart';
import 'utils/localization_helper.dart';
import 'dish_extensions.dart';

// Data Models
class Order {
  final int id;
  final int userId;
  final int tableId;
  final String orderNumber;
  final String status;
  final String type;
  final double subtotal;
  final double taxAmount;
  final double totalAmount;
  final String? notes;
  final String? specialInstructions;
  final DateTime createdAt;
  final DateTime updatedAt;
  final List<OrderItem> orderItems;
  final Table? table;

  Order({
    required this.id,
    required this.userId,
    required this.tableId,
    required this.orderNumber,
    required this.status,
    required this.type,
    required this.subtotal,
    required this.taxAmount,
    required this.totalAmount,
    this.notes,
    this.specialInstructions,
    required this.createdAt,
    required this.updatedAt,
    required this.orderItems,
    this.table,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['id'],
      userId: json['user_id'],
      tableId: json['table_id'],
      orderNumber: json['order_number'] ?? '',
      status: json['status'] ?? 'pending',
      type: json['type'] ?? 'dine_in',
      subtotal: double.parse(json['subtotal'].toString()),
      taxAmount: double.parse(json['tax_amount'].toString()),
      totalAmount: double.parse(json['total_amount'].toString()),
      notes: json['notes'],
      specialInstructions: json['special_instructions'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      orderItems: (json['order_items'] as List? ?? [])
          .map((item) => OrderItem.fromJson(item))
          .toList(),
      table: json['table'] != null ? Table.fromJson(json['table']) : null,
    );
  }
}

class OrderItem {
  final int id;
  final int orderId;
  final int dishId;
  final int quantity;
  final double unitPrice;
  final double totalPrice;
  final String? specialInstructions;
  final String status;
  final DateTime createdAt;
  final DateTime updatedAt;
  final Dish dish;

  OrderItem({
    required this.id,
    required this.orderId,
    required this.dishId,
    required this.quantity,
    required this.unitPrice,
    required this.totalPrice,
    this.specialInstructions,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    required this.dish,
  });

  factory OrderItem.fromJson(Map<String, dynamic> json) {
    return OrderItem(
      id: json['id'],
      orderId: json['order_id'],
      dishId: json['dish_id'],
      quantity: json['quantity'] ?? 1,
      unitPrice: double.parse(json['unit_price'].toString()),
      totalPrice: double.parse(json['total_price'].toString()),
      specialInstructions: json['special_instructions'],
      status: json['status'] ?? 'pending',
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      dish: Dish.fromJson(json['dish']),
    );
  }
}

class Dish {
  final int id;
  final String name;
  final String nameAr;
  final String description;
  final String descriptionAr;
  final double price;
  final int categoryId;
  final String? imagePath;
  final bool isVegetarian;
  final bool isVegan;
  final bool isGlutenFree;
  final bool isAvailable;
  final int preparationTime;
  final String ingredients;
  final String ingredientsAr;
  final String allergens;
  final String allergensAr;
  final double? discountPercentage;
  final bool isOnDiscount;

  Dish({
    required this.id,
    required this.name,
    required this.nameAr,
    required this.description,
    required this.descriptionAr,
    required this.price,
    required this.categoryId,
    this.imagePath,
    required this.isVegetarian,
    required this.isVegan,
    required this.isGlutenFree,
    required this.isAvailable,
    required this.preparationTime,
    required this.ingredients,
    required this.ingredientsAr,
    required this.allergens,
    required this.allergensAr,
    this.discountPercentage,
    required this.isOnDiscount,
  });

  factory Dish.fromJson(Map<String, dynamic> json) {
    return Dish(
      id: json['id'],
      name: json['name'] ?? '',
      nameAr: json['name_ar'] ?? '',
      description: json['description'] ?? '',
      descriptionAr: json['description_ar'] ?? '',
      price: double.parse(json['price'].toString()),
      categoryId: json['category_id'],
      imagePath: json['image_path'],
      isVegetarian: json['is_vegetarian'] ?? false,
      isVegan: json['is_vegan'] ?? false,
      isGlutenFree: json['is_gluten_free'] ?? false,
      isAvailable: json['is_available'] ?? true,
      preparationTime: json['preparation_time'] ?? 0,
      ingredients: json['ingredients'] ?? '',
      ingredientsAr: json['ingredients_ar'] ?? '',
      allergens: json['allergens'] ?? '',
      allergensAr: json['allergens_ar'] ?? '',
      discountPercentage: json['discount_percentage'] != null
          ? double.parse(json['discount_percentage'].toString())
          : null,
      isOnDiscount: json['is_on_discount'] ?? false,
    );
  }
}

class Table {
  final int id;
  final String name;
  final String nameAr;
  final int capacity;
  final String type;
  final String status;
  final String? imagePath;
  final String description;
  final String descriptionAr;
  final bool isActive;

  Table({
    required this.id,
    required this.name,
    required this.nameAr,
    required this.capacity,
    required this.type,
    required this.status,
    this.imagePath,
    required this.description,
    required this.descriptionAr,
    required this.isActive,
  });

  factory Table.fromJson(Map<String, dynamic> json) {
    return Table(
      id: json['id'],
      name: json['name'] ?? '',
      nameAr: json['name_ar'] ?? '',
      capacity: json['capacity'] ?? 1,
      type: json['type'] ?? 'single',
      status: json['status'] ?? 'available',
      imagePath: json['image_path'],
      description: json['description'] ?? '',
      descriptionAr: json['description_ar'] ?? '',
      isActive: json['is_active'] ?? true,
    );
  }
}

class Reservation {
  final int id;
  final String status;
  final DateTime reservationDate;
  final String reservationTime;
  final int numberOfGuests;
  final String? specialRequests;

  Reservation({
    required this.id,
    required this.status,
    required this.reservationDate,
    required this.reservationTime,
    required this.numberOfGuests,
    this.specialRequests,
  });

  factory Reservation.fromJson(Map<String, dynamic> json) {
    return Reservation(
      id: json['id'],
      status: json['status'] ?? 'pending',
      reservationDate: DateTime.parse(json['reservation_date']),
      reservationTime: json['reservation_time'] ?? '00:00',
      numberOfGuests: json['number_of_guests'] ?? 1,
      specialRequests: json['special_requests'],
    );
  }
}

class RecentPage extends StatefulWidget {
  const RecentPage({super.key});

  @override
  State<RecentPage> createState() => _RecentPageState();
}

class _RecentPageState extends State<RecentPage>
    with LocalizationMixin, SingleTickerProviderStateMixin {
  late TabController _tabController;
  final Dio _dio = Dio();
  List<Order> _orders = [];
  List<Reservation> _reservations = [];
  bool _isLoadingOrders = true;
  bool _isLoadingReservations = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _loadData();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    await Future.wait([
      _loadOrders(),
      _loadReservations(),
    ]);
  }

  Future<void> _loadOrders() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token');

      final response = await _dio.get(
        '${AppConfig.customerUrl}/orders',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Accept': 'application/json',
          },
        ),
      );

      if (response.statusCode == 200) {
        final List<dynamic> ordersData = response.data['orders']['data'] ?? [];
        setState(() {
          _orders = ordersData.map((json) => Order.fromJson(json)).toList();
          _isLoadingOrders = false;
        });
      }
    } catch (e) {
      setState(() {
        _isLoadingOrders = false;
      });
    }
  }

  Future<void> _loadReservations() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token');

      final response = await _dio.get(
        '${AppConfig.customerUrl}/reservations',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Accept': 'application/json',
          },
        ),
      );

      if (response.statusCode == 200) {
        final List<dynamic> reservationsData =
            response.data['reservations']['data'] ?? [];
        setState(() {
          _reservations = reservationsData
              .map((json) => Reservation.fromJson(json))
              .toList();
          _isLoadingReservations = false;
        });
      }
    } catch (e) {
      setState(() {
        _isLoadingReservations = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return withDirectionality(
      Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Column(
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                child: Row(
                  children: [
                    Text(
                      getText('recent'),
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 24,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),

              // ==== Tabs Orders / Reservations ====
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: TabBar(
                  controller: _tabController,
                  labelColor: const Color(0xFF008C8C),
                  unselectedLabelColor: const Color(0xFFB3B3B3),
                  labelStyle: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                  ),
                  unselectedLabelStyle: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                  ),
                  indicatorColor: const Color(0xFF008C8C),
                  indicatorWeight: 4,
                  tabs: [
                    Tab(text: getText('orders')),
                    Tab(text: getText('reservations')),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // ==== Tab Content ====
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    // Orders Tab
                    _buildOrdersList(),
                    // Reservations Tab
                    _buildReservationsList(),
                  ],
                ),
              ),

              // ==== Bottom Navigation ====
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Color(0x0A000000),
                      blurRadius: 10,
                      offset: Offset(0, -8),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        // bottomNavigationBar: BottomNavigationBar(
        //   selectedItemColor: const Color(0xFF008C8C),
        //   unselectedItemColor: const Color(0xFFB3B3B3),
        //   currentIndex: 3,
        //   items: const [
        //     BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
        //     BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Search'),
        //     BottomNavigationBarItem(icon: Icon(Icons.history), label: 'Recent'),
        //     BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        //   ],
        // ),
      ),
    );
  }

  Widget _buildOrdersList() {
    if (_isLoadingOrders) {
      return const Center(
        child: CircularProgressIndicator(
          color: Color(0xFF008C8C),
        ),
      );
    }

    if (_orders.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.receipt_long,
              size: 64,
              color: Color(0xFFB3B3B3),
            ),
            const SizedBox(height: 16),
            Text(
              getText('no_orders_found'),
              style: const TextStyle(
                fontSize: 18,
                color: Color(0xFFB3B3B3),
              ),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _loadOrders,
      color: const Color(0xFF008C8C),
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        itemCount: _orders.length,
        separatorBuilder: (context, index) => const SizedBox(height: 16),
        itemBuilder: (context, index) {
          final order = _orders[index];
          return _buildOrderItem(order);
        },
      ),
    );
  }

  Widget _buildReservationsList() {
    if (_isLoadingReservations) {
      return const Center(
        child: CircularProgressIndicator(
          color: Color(0xFF008C8C),
        ),
      );
    }

    if (_reservations.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.event_seat,
              size: 64,
              color: Color(0xFFB3B3B3),
            ),
            const SizedBox(height: 16),
            Text(
              getText('no_reservations_found'),
              style: const TextStyle(
                fontSize: 18,
                color: Color(0xFFB3B3B3),
              ),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _loadReservations,
      color: const Color(0xFF008C8C),
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        itemCount: _reservations.length,
        separatorBuilder: (context, index) => const SizedBox(height: 16),
        itemBuilder: (context, index) {
          final reservation = _reservations[index];
          return _buildReservationItem(reservation);
        },
      ),
    );
  }

  Widget _buildOrderItem(Order order) {
    Color statusColor = _getStatusColor(order.status);
    String formattedDate = _formatDate(order.createdAt);
    String itemsText = order.orderItems.isNotEmpty
        ? '${order.orderItems.length} ${order.orderItems.length > 1 ? getText('items') : getText('item')}'
        : getText('no_orders_found');

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  order.orderNumber,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  formattedDate,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Color(0xFF6E6E6E),
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Container(
                      width: 4,
                      height: 4,
                      decoration: const BoxDecoration(
                        color: Colors.black,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      itemsText,
                      style: const TextStyle(fontSize: 14),
                    ),
                    const SizedBox(width: 16),
                    Text(
                      '${order.totalAmount.toStringAsFixed(2)} SP',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                if (order.table != null) ...[
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(
                        Icons.table_restaurant,
                        size: 14,
                        color: Color(0xFF6E6E6E),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        order.table!.getLocalizedName(),
                        style: const TextStyle(
                          fontSize: 12,
                          color: Color(0xFF6E6E6E),
                        ),
                      ),
                    ],
                  ),
                ],
                if (order.orderItems.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Text(
                    order.orderItems
                        .map((item) =>
                            '${item.quantity}x ${item.dish.getLocalizedName()}')
                        .join(', '),
                    style: const TextStyle(
                      fontSize: 12,
                      color: Color(0xFF6E6E6E),
                      fontStyle: FontStyle.italic,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: statusColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Text(
              _getLocalizedStatus(order.status),
              style: TextStyle(
                fontSize: 12,
                color: statusColor,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReservationItem(Reservation reservation) {
    Color statusColor = _getStatusColor(reservation.status);
    String formattedDate = _formatDate(reservation.reservationDate);
    String guestsText =
        '${reservation.numberOfGuests} ${reservation.numberOfGuests > 1 ? getText('guests') : getText('guest')}';

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${getText('reservation_number')}${reservation.id}',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '$formattedDate ${getText('at')} ${reservation.reservationTime}',
                  style: const TextStyle(
                    fontSize: 14,
                    color: Color(0xFF6E6E6E),
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Container(
                      width: 4,
                      height: 4,
                      decoration: const BoxDecoration(
                        color: Colors.black,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      guestsText,
                      style: const TextStyle(fontSize: 14),
                    ),
                  ],
                ),
                if (reservation.specialRequests != null &&
                    reservation.specialRequests!.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Text(
                    '${getText('special_requests')}: ${reservation.specialRequests}',
                    style: const TextStyle(
                      fontSize: 12,
                      color: Color(0xFF6E6E6E),
                      fontStyle: FontStyle.italic,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: statusColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Text(
              _getLocalizedStatus(reservation.status),
              style: TextStyle(
                fontSize: 12,
                color: statusColor,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'completed':
      case 'confirmed':
      case 'delivered':
      case 'received':
        return const Color(0xFF008C8C);
      case 'pending':
      case 'processing':
        return const Color(0xFFF39C12);
      case 'cancelled':
      case 'failed':
        return const Color(0xFFC34D33);
      default:
        return const Color(0xFF6E6E6E);
    }
  }

  String _formatDate(DateTime date) {
    final months = [
      getText('january'),
      getText('february'),
      getText('march'),
      getText('april'),
      getText('may'),
      getText('june'),
      getText('july'),
      getText('august'),
      getText('september'),
      getText('october'),
      getText('november'),
      getText('december')
    ];

    return '${date.day} ${months[date.month - 1]} ${date.year}, ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
  }

  String _getLocalizedStatus(String status) {
    // Try to get localized status, fallback to capitalized English
    final localizedStatus = getText(status.toLowerCase());
    if (localizedStatus != status.toLowerCase()) {
      return localizedStatus;
    }
    // Fallback to capitalized status
    return status
        .split(' ')
        .map((word) => word.isNotEmpty
            ? word[0].toUpperCase() + word.substring(1).toLowerCase()
            : '')
        .join(' ');
  }
}
