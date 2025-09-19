class ReservationModel {
  final String tableName;
  final String tableImage;
  final String tableDesc;
  final DateTime dateTime;
  final String? duration;
  final List<Map<String, dynamic>> additions;

  ReservationModel({
    required this.tableName,
    required this.tableImage,
    required this.tableDesc,
    required this.dateTime,
    this.duration,
    this.additions = const [],
  });
}
