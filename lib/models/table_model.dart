class TableModel {
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
  final String createdAt;
  final String updatedAt;
  final List<Reservation> reservationsList;
  final List<ActiveReservation> activeReservations;
  
  // Keep existing fields for compatibility
  String? selectedTime;
  List<String> selectedAdditions;

  TableModel({
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
    required this.createdAt,
    required this.updatedAt,
    required this.reservationsList,
    required this.activeReservations,
    this.selectedTime,
    this.selectedAdditions = const [],
  });

  factory TableModel.fromJson(Map<String, dynamic> json) {
    return TableModel(
      id: json['id'],
      name: json['name'],
      nameAr: json['name_ar'],
      capacity: json['capacity'],
      type: json['type'],
      status: json['status'],
      imagePath: json['image_path'],
      description: json['description'],
      descriptionAr: json['description_ar'],
      isActive: json['is_active'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      reservationsList: (json['reservations_list'] as List?)
          ?.map((e) => Reservation.fromJson(e))
          .toList() ?? [],
      activeReservations: (json['active_reservations'] as List?)
          ?.map((e) => ActiveReservation.fromJson(e))
          .toList() ?? [],
    );
  }

  // Getters for backward compatibility
  String get title => name;
  String get desc => description;
  String get image => imagePath ?? 'assets/images/restaurant.png';
}

class Reservation {
  final int customerId;
  final String? startDate;
  final String? endDate;

  Reservation({
    required this.customerId,
    this.startDate,
    this.endDate,
  });

  factory Reservation.fromJson(Map<String, dynamic> json) {
    return Reservation(
      customerId: json['customer_id'],
      startDate: json['start_date'],
      endDate: json['end_date'],
    );
  }
}

class ActiveReservation {
  final int id;
  final int tableId;
  final int userId;

  ActiveReservation({
    required this.id,
    required this.tableId,
    required this.userId,
  });

  factory ActiveReservation.fromJson(Map<String, dynamic> json) {
    return ActiveReservation(
      id: json['id'],
      tableId: json['table_id'],
      userId: json['user_id'],
    );
  }
}
