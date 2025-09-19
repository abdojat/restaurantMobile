import 'package:flutter/foundation.dart';

@immutable
class FoodItem {
  final String id;
  final String name;
  final String? nameAr;
  final String? description;
  final String? descriptionAr;
  final String imageUrl;
  final int price;        // in IDR
  final double rating;    // 0..5
  final String category;
  final String? categoryAr;
  final bool isFavorite;

  const FoodItem({
    required this.id,
    required this.name,
    this.nameAr,
    this.description,
    this.descriptionAr,
    required this.imageUrl,
    required this.price,
    required this.rating,
    required this.category,
    this.categoryAr,
    this.isFavorite = false,
  });

  FoodItem copyWith({
    String? id,
    String? name,
    String? nameAr,
    String? description,
    String? descriptionAr,
    String? imageUrl,
    int? price,
    double? rating,
    String? category,
    String? categoryAr,
    bool? isFavorite,
  }) {
    return FoodItem(
      id: id ?? this.id,
      name: name ?? this.name,
      nameAr: nameAr ?? this.nameAr,
      description: description ?? this.description,
      descriptionAr: descriptionAr ?? this.descriptionAr,
      imageUrl: imageUrl ?? this.imageUrl,
      price: price ?? this.price,
      rating: rating ?? this.rating,
      category: category ?? this.category,
      categoryAr: categoryAr ?? this.categoryAr,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }
}
