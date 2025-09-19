import 'package:flutter/foundation.dart';
import '../food_item.dart';
import '../models/reservation_item.dart';
import 'api_service.dart';

class CartItem {
  final FoodItem foodItem;
  int quantity;

  CartItem({
    required this.foodItem,
    this.quantity = 1,
  });

  int get totalPrice => foodItem.price * quantity;

  CartItem copyWith({
    FoodItem? foodItem,
    int? quantity,
  }) {
    return CartItem(
      foodItem: foodItem ?? this.foodItem,
      quantity: quantity ?? this.quantity,
    );
  }
}

class CartService extends ChangeNotifier {
  static final CartService _instance = CartService._internal();
  factory CartService() => _instance;
  CartService._internal();

  final List<CartItem> _items = [];
  final List<ReservationItem> _reservations = [];

  List<CartItem> get items => List.unmodifiable(_items);
  List<ReservationItem> get reservations => List.unmodifiable(_reservations);

  int get itemCount =>
      _items.fold(0, (sum, item) => sum + item.quantity) + _reservations.length;

  int get totalPrice =>
      _items.fold(0, (sum, item) => sum + item.totalPrice) +
      _reservations.fold(0, (sum, reservation) => sum + reservation.totalPrice);

  bool isInCart(String foodItemId) {
    return _items.any((item) => item.foodItem.id == foodItemId);
  }

  void addToCart(FoodItem foodItem, {int quantity = 1}) {
    final existingIndex =
        _items.indexWhere((item) => item.foodItem.id == foodItem.id);

    if (existingIndex != -1) {
      // Item already exists, increase quantity
      _items[existingIndex].quantity += quantity;
    } else {
      // Add new item
      _items.add(CartItem(foodItem: foodItem, quantity: quantity));
    }

    notifyListeners();
  }

  void removeFromCart(String foodItemId) {
    _items.removeWhere((item) => item.foodItem.id == foodItemId);
    notifyListeners();
  }

  void updateQuantity(String foodItemId, int newQuantity) {
    if (newQuantity <= 0) {
      removeFromCart(foodItemId);
      return;
    }

    final index = _items.indexWhere((item) => item.foodItem.id == foodItemId);
    if (index != -1) {
      _items[index].quantity = newQuantity;
      notifyListeners();
    }
  }

  void addReservation(ReservationItem reservation) {
    _reservations.add(reservation);
    notifyListeners();
  }

  void removeReservation(String reservationId) {
    _reservations.removeWhere((reservation) => reservation.id == reservationId);
    notifyListeners();
  }

  bool hasReservation(String reservationId) {
    return _reservations.any((reservation) => reservation.id == reservationId);
  }

  void clearCart() {
    _items.clear();
    _reservations.clear();
    notifyListeners();
  }

  CartItem? getCartItem(String foodItemId) {
    try {
      return _items.firstWhere((item) => item.foodItem.id == foodItemId);
    } catch (e) {
      return null;
    }
  }

  // API Methods
  Future<bool> placeOrder({
    String? tableId,
    required String type, // 'dine_in', 'takeaway', 'delivery'
    String? notes,
    String? specialInstructions,
  }) async {
    if (_items.isEmpty) return false;

    try {
      final items = _items
          .map((cartItem) => {
                'dish_id': cartItem.foodItem.id,
                'quantity': cartItem.quantity,
                'special_instructions': null, // Add if needed
              })
          .toList();

      final success = await ApiService.createOrder(
        tableId: '1',
        type: type,
        items: items,
        notes: notes,
        specialInstructions: specialInstructions,
      );

      if (success) {
        // Clear food items from cart after successful order
        _items.clear();
        notifyListeners();
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  Future<bool> createReservation(ReservationItem reservation) async {
    try {
      // Convert DateTime and TimeOfDay to proper DateTime for API
      final reservationDateTime = DateTime(
        reservation.reservationDate.year,
        reservation.reservationDate.month,
        reservation.reservationDate.day,
        reservation.reservationTime.hour,
        reservation.reservationTime.minute,
      );

      // Calculate end time based on duration (assuming duration is in hours)
      final durationHours =
          int.tryParse(reservation.duration.replaceAll(RegExp(r'[^\d]'), '')) ??
              2;
      final endDateTime =
          reservationDateTime.add(Duration(hours: durationHours));

      final success = await ApiService.createReservation(
        tableId: reservation.tableId,
        startDate: reservationDateTime,
        endDate: endDateTime,
        guests: reservation.guests,
        specialRequests: null, // Add if needed in ReservationItem model
        contactPhone: null, // Add if needed in ReservationItem model
        contactEmail: null, // Add if needed in ReservationItem model
      );

      return success;
    } catch (e) {
      return false;
    }
  }

  Future<bool> placeCartOrder() async {
    bool success = true;

    // Place food orders if there are food items
    if (_items.isNotEmpty) {
      String orderType = 'takeaway'; // Default type
      String? tableId;

      // If there are reservations, it's a dine_in order
      if (_reservations.isNotEmpty) {
        orderType = 'dine_in';
        tableId = _reservations.first.tableId; // Use first reservation's table
      }

      success = await placeOrder(
        tableId: tableId,
        type: orderType,
      );
    }

    // Create reservations if there are any
    if (_reservations.isNotEmpty && success) {
      for (final reservation in _reservations) {
        final reservationSuccess = await createReservation(reservation);
        if (!reservationSuccess) {
          success = false;
          break;
        }
      }

      if (success) {
        // Clear reservations after successful creation
        _reservations.clear();
        notifyListeners();
      }
    }

    return success;
  }
}
