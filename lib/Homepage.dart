// ignore_for_file: sized_box_for_whitespace, camel_case_types, file_names

import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'PaymentPage.dart';
import 'SearchPage.dart';
import 'food_page.dart';
import 'profile_page.dart';
import 'models/user_model.dart' as models;
import 'recent_page.dart';
import 'table_page.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'cart_page.dart';
import 'food_card.dart';
import 'food_details_sheet.dart';
import 'food_item.dart';
import 'services/api_service.dart';
import 'services/auth_service.dart';
import 'services/favorites_service.dart';
import 'services/language_service.dart';

class homepage extends StatefulWidget {
  const homepage({super.key});

  @override
  State<homepage> createState() => _HomepageState();
}

int navigationbaritem = 0;
int activeSliderImage = 0;

List images = [
  "images/image1.jpeg",
  "images/image2.jpeg",
  "images/image4.jpeg",
  "images/image5.jpeg"
];

class _HomepageState extends State<homepage> {
  List<FoodItem> _discountedDishes = [];
  bool _isLoadingDishes = true;
  List<FoodItem> _recommendedDishes = [];
  bool _isLoadingRecommended = true;
  String _userName = 'User';
  models.UserModel? _currentUser;
  final LanguageService _languageService = LanguageService();

  @override
  void initState() {
    super.initState();
    _languageService.addListener(_onLanguageChanged);
    _loadDiscountedDishes();
    _loadRecommendedDishes();
    _loadCurrentUser();
  }

  @override
  void dispose() {
    _languageService.removeListener(_onLanguageChanged);
    super.dispose();
  }

  void _onLanguageChanged() {
    if (mounted) {
      setState(() {});
    }
  }

  Future<void> _loadDiscountedDishes() async {
    try {
      final dishes = await ApiService.getDiscountedDishes();
      final updatedDishes = await _updateFavoriteStatus(dishes);
      if (mounted) {
        setState(() {
          _discountedDishes = updatedDishes;
          _isLoadingDishes = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoadingDishes = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to load discounted dishes: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _loadCurrentUser() async {
    try {
      final authService = AuthService();
      final user = await authService.getCurrentUser();
      if (mounted && user != null) {
        setState(() {
          _userName = user.name;
          _currentUser = user;
        });
      }
    } catch (e) {
      // Silently handle error - keep default username
    }
  }

  Future<void> _loadRecommendedDishes() async {
    try {
      final dishes = await ApiService.getRecommendedDishes();
      final updatedDishes = await _updateFavoriteStatus(dishes);
      if (mounted) {
        setState(() {
          _recommendedDishes = updatedDishes;
          _isLoadingRecommended = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoadingRecommended = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to load recommended dishes: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<List<FoodItem>> _updateFavoriteStatus(List<FoodItem> dishes) async {
    try {
      final favorites = await FavoritesService.getFavorites();
      final favoriteIds = favorites.map((fav) => fav['id'].toString()).toSet();

      return dishes
          .map((dish) => dish.copyWith(
                isFavorite: favoriteIds.contains(dish.id),
              ))
          .toList();
    } catch (e) {
      // If favorites service fails, return dishes as-is
      return dishes;
    }
  }

  String _formatPrice(int price) {
    return '${price.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')} SP';
  }

  void _showFoodDetails(FoodItem item) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => FoodDetailsSheet(
        item: item,
        onPlaceOrder: () {
          Navigator.pop(context);
        },
        formatPrice: _formatPrice,
        onFavoriteChanged: (isFavorite) {
          // Update the item in both lists
          final discountedIndex =
              _discountedDishes.indexWhere((dish) => dish.id == item.id);
          final recommendedIndex =
              _recommendedDishes.indexWhere((dish) => dish.id == item.id);

          setState(() {
            if (discountedIndex != -1) {
              _discountedDishes[discountedIndex] =
                  _discountedDishes[discountedIndex]
                      .copyWith(isFavorite: isFavorite);
            }
            if (recommendedIndex != -1) {
              _recommendedDishes[recommendedIndex] =
                  _recommendedDishes[recommendedIndex]
                      .copyWith(isFavorite: isFavorite);
            }
          });
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> pages = [
      Directionality(
        textDirection:
            _languageService.isRTL ? TextDirection.rtl : TextDirection.ltr,
        child: Stack(
          children: [
            ListView(
              children: [
                // ignore: avoid_unnecessary_containers
                Container(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    child: ListTile(
                      title: Text(
                        "${_languageService.getText('welcome')}, $_userName",
                        style: const TextStyle(
                            fontSize: 28, fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(_languageService.getText('add_favorites')),
                      trailing: IconButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => CartPage()),
                            );
                          },
                          icon: const Icon(
                            Icons.shopping_cart,
                            size: 28,
                          )),
                    ),
                  ),
                ),
                CarouselSlider.builder(
                    itemCount: images.length,
                    itemBuilder: (context, index, realindex) {
                      final sliderImage = images[index];
                      return SizedBox(
                          width: 350,
                          height: 200,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(15),
                            child: buildImage(sliderImage, index),
                          ));
                    },
                    options: CarouselOptions(
                        autoPlay: true,
                        autoPlayAnimationDuration: const Duration(seconds: 1),
                        height: 200,
                        onPageChanged: (index, reason) => setState(() {
                              activeSliderImage = index;
                            }))),
                const SizedBox(
                  height: 12,
                ),
                Center(child: buildIndicator()),
                Padding(
                  padding: const EdgeInsets.only(
                      top: 30, left: 30, right: 30, bottom: 15),

                  // Icon Buttons

                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Menu button
                      Column(
                        children: [
                          Container(
                              decoration: const BoxDecoration(
                                  color: Color(0xff008C8C),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(50))),
                              child: IconButton(
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => FoodPage()));
                                  },
                                  icon: const Icon(
                                    Icons.restaurant,
                                    color: Colors.white,
                                  ))),
                          Text(
                            _languageService.getText("menu"),
                            style: const TextStyle(
                                fontSize: 14, fontWeight: FontWeight.bold),
                          )
                        ],
                      ),

                      // Tabels button
                      Column(
                        children: [
                          Container(
                              decoration: const BoxDecoration(
                                  color: Color(0xff008C8C),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(50))),
                              child: IconButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => TablePage()),
                                    );
                                  },
                                  icon: const Icon(
                                    Icons.table_bar,
                                    color: Colors.white,
                                  ))),
                          Text(
                            _languageService.getText("tables"),
                            style: const TextStyle(
                                fontSize: 14, fontWeight: FontWeight.bold),
                          )
                        ],
                      ),

                      // Payment button
                      Column(
                        children: [
                          Container(
                              decoration: const BoxDecoration(
                                  color: Color(0xff008C8C),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(50))),
                              child: IconButton(
                                  onPressed: () {
                                    Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const Paymentpage()));
                                  },
                                  icon: const Icon(
                                    Icons.payment,
                                    color: Colors.white,
                                  ))),
                          Text(
                            _languageService.getText("payment_method"),
                            style: const TextStyle(
                                fontSize: 14, fontWeight: FontWeight.bold),
                          )
                        ],
                      ),

                      // More button
                      Column(
                        children: [
                          Container(
                              decoration: const BoxDecoration(
                                  color: Color(0xff008C8C),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(50))),
                              child: IconButton(
                                  onPressed: () {},
                                  icon: const Icon(
                                    Icons.more,
                                    color: Colors.white,
                                  ))),
                          Text(
                            _languageService.getText("more_info"),
                            style: const TextStyle(
                                fontSize: 14, fontWeight: FontWeight.bold),
                          )
                        ],
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 10, top: 15),
                  child: Text(
                    _languageService.getText("special_offers"),
                    style: const TextStyle(
                        fontSize: 25, fontWeight: FontWeight.bold),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    width: 500,
                    height: 300,
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(30)),
                    ),
                    child: _isLoadingDishes
                        ? const Center(
                            child: CircularProgressIndicator(
                              color: Color(0xff008C8C),
                            ),
                          )
                        : _discountedDishes.isEmpty
                            ? const Center(
                                child: Text(
                                  'No discounted dishes available',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.grey,
                                  ),
                                ),
                              )
                            : ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: _discountedDishes.length,
                                itemBuilder: (context, index) {
                                  final dish = _discountedDishes[index];
                                  return Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: SizedBox(
                                      width: 150,
                                      child: FoodCard(
                                        item: dish,
                                        priceText: _formatPrice(dish.price),
                                        onTap: () => _showFoodDetails(dish),
                                        onFavoriteChanged: (isFavorite) {
                                          setState(() {
                                            _discountedDishes[index] =
                                                dish.copyWith(
                                                    isFavorite: isFavorite);
                                          });
                                        },
                                      ),
                                    ),
                                  );
                                },
                              ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 10, top: 15),
                  child: Text(
                    _languageService.getText('recommended_dishes'),
                    style: const TextStyle(
                        fontSize: 25, fontWeight: FontWeight.bold),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    width: 500,
                    height: 300,
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(30)),
                    ),
                    child: _isLoadingRecommended
                        ? const Center(
                            child: CircularProgressIndicator(
                              color: Color(0xff008C8C),
                            ),
                          )
                        : _recommendedDishes.isEmpty
                            ? const Center(
                                child: Text(
                                  'No recommended dishes available',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.grey,
                                  ),
                                ),
                              )
                            : ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: _recommendedDishes.length,
                                itemBuilder: (context, index) {
                                  final dish = _recommendedDishes[index];
                                  return Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: SizedBox(
                                      width: 150,
                                      child: FoodCard(
                                        item: dish,
                                        priceText: _formatPrice(dish.price),
                                        onTap: () => _showFoodDetails(dish),
                                        onFavoriteChanged: (isFavorite) {
                                          setState(() {
                                            _recommendedDishes[index] =
                                                dish.copyWith(
                                                    isFavorite: isFavorite);
                                          });
                                        },
                                      ),
                                    ),
                                  );
                                },
                              ),
                  ),
                )
              ],
            ),
          ],
        ),
      ),
      const Searchpage(),
      Center(child: Text(_languageService.getText("orders"))),
      Center(child: Text(_languageService.getText("profile"))),
    ];

    // Scaffold

    return Scaffold(
      body: pages[navigationbaritem],
      bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          currentIndex: navigationbaritem,
          onTap: (val) {
            if (val == 1) {
              // Search
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const Searchpage()),
              );
            } else if (val == 2) {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => RecentPage()));
            } else if (val == 3) {
              // Profile
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ProfilePage(
                      user: _currentUser ??
                          models.UserModel(
                              name: _userName,
                              email: "user@example.com",
                              avatarPath: 'assets/images/profileImage.png')),
                ),
              );
            } else {
              // Home & History handled normally
              setState(() {
                navigationbaritem = val;
              });
            }
          },
          unselectedLabelStyle: const TextStyle(color: Colors.black38),
          unselectedItemColor: Colors.black54,
          selectedFontSize: 18,
          unselectedFontSize: 15,
          selectedItemColor: const Color(0xff008C8C),
          selectedIconTheme: const IconThemeData(size: 27),
          selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold),
          items: [
            BottomNavigationBarItem(
                icon: const Icon(Icons.home),
                label: _languageService.getText("home")),
            BottomNavigationBarItem(
                icon: const Icon(Icons.search),
                label: _languageService.getText("search")),
            BottomNavigationBarItem(
                icon: const Icon(Icons.history),
                label: _languageService.getText("orders")),
            BottomNavigationBarItem(
                icon: const Icon(Icons.person),
                label: _languageService.getText("profile")),
          ]),
    );
  }
}

Widget buildIndicator() => AnimatedSmoothIndicator(
    effect: const ExpandingDotsEffect(
        dotWidth: 7, dotHeight: 7, activeDotColor: Color(0xff008C8C)),
    activeIndex: activeSliderImage,
    count: images.length);

Widget buildImage(String sliderImage, int index) => Container(
      margin: const EdgeInsets.symmetric(horizontal: 5),
      child: Image.asset(
        sliderImage,
        fit: BoxFit.fill,
      ),
    );
