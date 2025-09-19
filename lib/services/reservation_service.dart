// services/reservation_service.dart
import '../models/reservation_model.dart';

class ReservationService {
  static final ReservationService _instance = ReservationService._internal();

  factory ReservationService() {
    return _instance;
  }

  ReservationService._internal();

  final List<ReservationModel> reservations = [];
}
