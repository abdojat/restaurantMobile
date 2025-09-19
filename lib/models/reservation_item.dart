import 'package:flutter/material.dart';

class ReservationItem {
  final String id;
  final String tableId;
  final String tableName;
  final String tableType;
  final DateTime reservationDate;
  final TimeOfDay reservationTime;
  final String duration;
  final int guests;
  final Map<String, Map<String, dynamic>> additions;
  final int basePrice;

  ReservationItem({
    required this.id,
    required this.tableId,
    required this.tableName,
    required this.tableType,
    required this.reservationDate,
    required this.reservationTime,
    required this.duration,
    required this.guests,
    required this.additions,
    required this.basePrice,
  });

  int get additionsPrice {
    return additions.values
        .where((addition) => addition['isSelected'] == true)
        .fold(0, (sum, addition) {
      final priceStr = addition['price'] as String;
      if (priceStr == 'Free') return sum;
      // Extract number from price string like "Rp25.000"
      final numStr = priceStr.replaceAll(RegExp(r'[^\d]'), '');
      return sum + (int.tryParse(numStr) ?? 0);
    });
  }

  int get totalPrice => basePrice + additionsPrice;

  String formattedDateTime(BuildContext context) {
    final months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    
    return '${reservationDate.day} ${months[reservationDate.month - 1]} ${reservationDate.year} at ${reservationTime.format(context)}';
  }

  ReservationItem copyWith({
    String? id,
    String? tableId,
    String? tableName,
    String? tableType,
    DateTime? reservationDate,
    TimeOfDay? reservationTime,
    String? duration,
    int? guests,
    Map<String, Map<String, dynamic>>? additions,
    int? basePrice,
  }) {
    return ReservationItem(
      id: id ?? this.id,
      tableId: tableId ?? this.tableId,
      tableName: tableName ?? this.tableName,
      tableType: tableType ?? this.tableType,
      reservationDate: reservationDate ?? this.reservationDate,
      reservationTime: reservationTime ?? this.reservationTime,
      duration: duration ?? this.duration,
      guests: guests ?? this.guests,
      additions: additions ?? this.additions,
      basePrice: basePrice ?? this.basePrice,
    );
  }
}
