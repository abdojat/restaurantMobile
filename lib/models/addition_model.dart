class Addition {
  final String name;
  final int price;

  Addition({required this.name, required this.price});

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is Addition &&
              runtimeType == other.runtimeType &&
              name == other.name &&
              price == other.price;

  @override
  int get hashCode => name.hashCode ^ price.hashCode;
}
