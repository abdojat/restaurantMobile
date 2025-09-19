class Meal {
  final String urlImage;
  final String name;
  final String rating;
  final String price;

  const Meal(
      {required this.urlImage,
      required this.name,
      required this.rating,
      required this.price});
}

const allMeals = [
  Meal(
      urlImage: "images/image1.jpeg",
      name: "meal 1",
      rating: "rating",
      price: "price"),
  Meal(
      urlImage: "images/image1.jpeg",
      name: "meal 2",
      rating: "rating",
      price: "price"),
  Meal(
      urlImage: "images/image1.jpeg",
      name: "meal 3",
      rating: "rating",
      price: "price"),
  Meal(
      urlImage: "images/image1.jpeg",
      name: "meal 4",
      rating: "rating",
      price: "price"),
  Meal(
      urlImage: "images/image1.jpeg",
      name: "meal 5",
      rating: "rating",
      price: "price"),
  Meal(
      urlImage: "images/image1.jpeg",
      name: "meal 5",
      rating: "rating",
      price: "price"),
];

final List<String> popularSearch = [
  "meal 1",
  "meal 2",
  "meal 3",
  "meal 4",
  "meal 5",
  "meal 6",
];
