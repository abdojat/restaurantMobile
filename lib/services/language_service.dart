import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LanguageService extends ChangeNotifier {
  static const String _languageKey = 'selected_language';
  static const String _englishCode = 'en';
  static const String _arabicCode = 'ar';
  
  String _currentLanguage = _englishCode;
  bool _isRTL = false;

  String get currentLanguage => _currentLanguage;
  bool get isRTL => _isRTL;
  bool get isArabic => _currentLanguage == _arabicCode;
  bool get isEnglish => _currentLanguage == _englishCode;

  // Singleton pattern
  static final LanguageService _instance = LanguageService._internal();
  factory LanguageService() => _instance;
  LanguageService._internal();

  // Initialize language from stored preferences
  Future<void> initialize() async {
    final prefs = await SharedPreferences.getInstance();
    _currentLanguage = prefs.getString(_languageKey) ?? _englishCode;
    _isRTL = _currentLanguage == _arabicCode;
    notifyListeners();
  }

  // Switch to Arabic
  Future<void> switchToArabic() async {
    await _changeLanguage(_arabicCode);
  }

  // Switch to English
  Future<void> switchToEnglish() async {
    await _changeLanguage(_englishCode);
  }

  // Private method to handle language change
  Future<void> _changeLanguage(String languageCode) async {
    if (_currentLanguage != languageCode) {
      _currentLanguage = languageCode;
      _isRTL = languageCode == _arabicCode;
      
      // Save to preferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_languageKey, languageCode);
      
      notifyListeners();
    }
  }

  // Get localized text for common UI elements
  String getText(String key) {
    final translations = {
      'en': {
        // Profile & Account
        'profile': 'Profile',
        'account': 'Account',
        'payment_method': 'Payment Method',
        'my_cart': 'My Cart',
        'help_report': 'Help & Report',
        'language': 'Language',
        'favorite': 'Favorite',
        'more_info': 'More Info',
        'privacy_policy': 'Privacy Policy',
        'news_services': 'News & Services',
        'give_rating': 'Give Rating',
        'logout': 'Logout',
        'edit': 'Edit',
        'save': 'Save',
        'cancel': 'Cancel',
        'name': 'Name',
        'email': 'Email',
        'edit_profile': 'Edit Profile',
        'select_language': 'Select App Language',
        'arabic': 'Arabic',
        'english': 'English',
        'language_changed': 'Language changed successfully',
        'profile_updated': 'Profile updated successfully!',
        'logout_confirm': 'Are you sure you want to logout?',
        
        // Homepage
        'home': 'Home',
        'welcome': 'Welcome',
        'good_morning': 'Good Morning',
        'good_afternoon': 'Good Afternoon',
        'good_evening': 'Good Evening',
        'add_favorites': 'Add dishes to your favorites',
        'special_offers': 'Special Offers',
        'recommended_for_you': 'Recommended for You',
        'popular_dishes': 'Popular Dishes',
        'categories': 'Categories',
        'see_all': 'See All',
        'order_now': 'Order Now',
        'add_to_cart': 'Add to Cart',
        
        // Search
        'search': 'Search',
        'search_dishes': 'Search for dishes...',
        'search_food': 'Search food',
        'search_table': 'Search table',
        
        // Food Page
        'food': 'Food',
        'show_all_items': 'Show all items',
        'show_favorites_only': 'Show favorites only',
        'showing_favorites_only': 'Showing favorites only',
        'clear': 'Clear',
        'order_placed_successfully': 'Successfully place order',
        'hide': 'Hide',
        
        // Table Page
        'tables': 'Tables',
        'error_loading_tables': 'Error loading tables',
        'retry': 'Retry',
        
        // Help & Report Page
        'contact_us': 'Contact Us',
        'faq': 'FAQ',
        'report_issue': 'Report Issue',
        'how_to_book_table': 'How to book a table?',
        'book_table_through_tables_page': 'You can book a table through the Tables page in our app.',
        'how_to_track_order': 'How to track my order?',
        'track_order_through_orders_page': 'You can track your order through the Orders page.',
        'is_cash_on_delivery_available': 'Is cash on delivery available?',
        'cash_on_delivery_available': 'Yes, cash on delivery is available for all orders.',
        'support_email': 'Support Email:',
        'send_note_report': 'Send a Note / Report',
        'message': 'Message',
        'send': 'Send',
        'fill_all_fields': 'Please fill all fields',
        'message_sent_successfully': 'Message sent successfully',
        
        // Privacy Policy Page
        'introduction': 'Introduction',
        'privacy_intro_text': 'We value your privacy. This Privacy Policy explains how we collect, use, and protect your information when you use our application.',
        'information_collection': '1. Information Collection',
        'information_collection_text': 'We may collect personal information such as your name, email address, and phone number when you use our services.',
        'how_we_use_info': '2. How We Use Information',
        'how_we_use_info_text': 'Your information is used to provide and improve our services, process transactions, and communicate with you.',
        'data_security': '3. Data Security',
        'data_security_text': 'We implement strong security measures to protect your data from unauthorized access, alteration, or disclosure.',
        'contact_us_privacy': '4. Contact Us',
        'contact_us_privacy_text': 'If you have any questions or concerns about this Privacy Policy, please contact our support team.',
        'copyright_text': '© 2025 Borcella App. All rights reserved.',
        
        // News & Services Page
        'new_feature_released': '📢 New Feature Released',
        'new_feature_content': 'A new feature has been added to provide users with a better and faster experience when using the app.',
        'security_update': '🔒 Security Update',
        'security_update_content': 'We have enhanced security measures to better protect your data and ensure your privacy.',
        'new_language_support': '🌍 New Language Support',
        'new_language_support_content': 'The app now supports multiple languages to accommodate users from all over the world.',
        'performance_improvements': '⚡ Performance Improvements',
        'performance_improvements_content': 'Some issues have been fixed and the speed and performance of the app have been noticeably improved.',
        
        // Payment Page
        'atm_bersama': 'ATM Bersama',
        'pay_now': 'Pay Now',
        
        // Recent Page
        'recent': 'Recent',
        'orders': 'Orders',
        'reservations': 'Reservations',
        'no_orders_found': 'No orders found',
        'no_reservations_found': 'No reservations found',
        'order_number': 'Order Number',
        'total_amount': 'Total Amount',
        'order_status': 'Status',
        'reservation_date': 'Reservation Date',
        'guests': 'Guests',
        'popular_search': 'Popular Searches',
        'popular_searches_alt': 'Popular Searches',
        'recent_searches': 'Recent Searches',
        'no_results': 'No results found',
        'no_results_found': 'No results found',
        'search_results': 'Search Results',
        'try_different_search': 'Try a different search term',
        'filters': 'Filters',
        'sort_by': 'Sort by',
        'price_low_high': 'Price: Low to High',
        'price_high_low': 'Price: High to Low',
        'rating': 'Rating',
        'popularity': 'Popularity',
        
        // Give Rating Page
        'rate_experience': 'How would you rate your experience?',
        'write_feedback': 'Write your feedback (optional)',
        'submit': 'Submit',
        'rating_thank_you': 'Thank you! You rated us {rating} stars ⭐',
        'recommended_dishes': 'Recommended Dishes',
        'suggested_dishes': 'Suggested Dishes',
        
        // Cart
        'cart': 'Cart',
        'detail_cart': 'Detail Cart',
        'your_cart': 'Your Cart',
        'cart_empty': 'Your cart is empty',
        'add_items': 'Add some delicious items!',
        'subtotal': 'Subtotal',
        'tax': 'Tax',
        'delivery_fee': 'Delivery Fee',
        'total': 'Total',
        'checkout': 'Checkout',
        'quantity': 'Quantity',
        'remove': 'Remove',
        'continue_shopping': 'Continue Shopping',
        'place_order': 'Place Order',
        'add_items_to_cart': 'Add Items to Cart',
        'add_table': 'Add Table',
        'table_reservations': 'Table Reservations',
        
        // Favorites
        'favorites': 'Favorites',
        'my_favorites': 'My Favorites',
        'no_favorites_yet': 'No favorites yet',
        'add_favorites_instruction': 'Start adding dishes to your favorites by tapping the heart icon on any dish.',
        'remove_from_favorites': 'Remove from Favorites',
        'add_to_favorites': 'Add to Favorites',
        'search_favorite_dishes': 'Search favorite dishes...',
        'favorite_dishes': 'favorite dishes',
        'browse_menu': 'Browse Menu',
        
        // Additional recent page keys
        'item': 'item',
        'items': 'items',
        'guest': 'guest',
        'guests': 'guests',
        'reservation_number': 'Reservation #',
        'special_requests': 'Special',
        'at': 'at',
        
        // Order statuses
        'pending': 'Pending',
        'processing': 'Processing',
        'completed': 'Completed',
        'confirmed': 'Confirmed',
        'delivered': 'Delivered',
        'received': 'Received',
        'cancelled': 'Cancelled',
        'failed': 'Failed',
        
        // Months
        'january': 'January',
        'february': 'February',
        'march': 'March',
        'april': 'April',
        'may': 'May',
        'june': 'June',
        'july': 'July',
        'august': 'August',
        'september': 'September',
        'october': 'October',
        'november': 'November',
        'december': 'December',
        
        // Food & Tables
        'menu': 'Menu',
        'dishes': 'Dishes',
        'tables': 'Tables',
        'book_table': 'Book Table',
        'reserve_now': 'Reserve Now',
        'available': 'Available',
        'chairs': 'Chairs',
        'occupied': 'Occupied',
        'reserved': 'Reserved',
        'capacity': 'Capacity',
        'table_details': 'Table Details',
        'no_tables_found': 'Well, there is no table you are looking for :(',
        'find_other_table': 'Find Other Table',
        'all': 'All',
        'single': 'Single',
        'double': 'Double',
        'family': 'Family',
        'special': 'Special',
        'custom': 'Custom',
        'duration': 'Duration',
        'minutes': 'minutes',
        'hour': 'hour',
        'hours': 'hours',
        'custom_time': 'Custom time',
        'select_from_list': 'Select from list',
        'reservation_date_time': 'Reservation Date & Time',
        'select_date': 'Select Date',
        'select_hour': 'Select Hour',
        'additional': 'Additional',
        'chair': 'Chair',
        'table': 'Table',
        'flower': 'Flower',
        'free': 'Free',
        'add_to_cart': 'Add to Cart',
        'select_date_time': 'Select Date & Time',
        'table_reservation_added': 'Table reservation added to cart!',
        'failed_update_favorite': 'Failed to update favorite',
        'added_to_cart': 'added to cart!',
        'failed_add_to_cart': 'Failed to add to cart',
        'adding': 'Adding...',
        'reservation_details': 'Reservation Details',
        'date': 'Date',
        'time': 'Time',
        'number_of_guests': 'Guests',
        'special_requests': 'Special Requests',
        
        // Orders
        'order_history': 'Order History',
        'current_orders': 'Current Orders',
        'order_details': 'Order Details',
        'order_status': 'Order Status',
        'pending': 'Pending',
        'confirmed': 'Confirmed',
        'preparing': 'Preparing',
        'ready': 'Ready',
        'delivered': 'Delivered',
        'cancelled': 'Cancelled',
        'track_order': 'Track Order',
        'reorder': 'Reorder',
        
        // Authentication
        'login': 'Login',
        'register': 'Register',
        'sign_in': 'Sign In',
        'sign_up': 'Sign Up',
        'forgot_password': 'Forgot Password?',
        'password': 'Password',
        'confirm_password': 'Confirm Password',
        'phone': 'Phone',
        'phone_number': 'Phone Number',
        'address': 'Address',
        'create_account': 'Create Account',
        'already_have_account': 'Already have an account?',
        'dont_have_account': "Don't have an account?",
        'sign_up_now': 'Sign Up Now',
        'enter_your_name': 'Enter your name',
        'enter_valid_phone': 'Enter valid 10-digit phone number',
        'registration_successful': 'Registration successful!',
        'login_successful': 'Login successful!',
        'unexpected_error': 'An unexpected error occurred',
        'app_name': 'Madang',
        'app_tagline': 'Booking a table and food from everywhere.',
        
        // General
        'yes': 'Yes',
        'no': 'No',
        'ok': 'OK',
        'done': 'Done',
        'next': 'Next',
        'previous': 'Previous',
        'back': 'Back',
        'close': 'Close',
        'loading': 'Loading...',
        'error': 'Error',
        'success': 'Success',
        'warning': 'Warning',
        'info': 'Information',
        'retry': 'Retry',
        'refresh': 'Refresh',
      },
      'ar': {
        // Profile & Account
        'profile': 'الملف الشخصي',
        'account': 'الحساب',
        'payment_method': 'طريقة الدفع',
        'my_cart': 'سلة التسوق',
        'help_report': 'المساعدة والإبلاغ',
        'language': 'اللغة',
        'favorite': 'المفضلة',
        'more_info': 'معلومات أكثر',
        'privacy_policy': 'سياسة الخصوصية',
        'news_services': 'الأخبار والخدمات',
        'give_rating': 'تقييم التطبيق',
        'logout': 'تسجيل الخروج',
        'edit': 'تعديل',
        'save': 'حفظ',
        'cancel': 'إلغاء',
        'name': 'الاسم',
        'email': 'البريد الإلكتروني',
        'edit_profile': 'تعديل الملف الشخصي',
        'select_language': 'اختر لغة التطبيق',
        'arabic': 'العربية',
        'english': 'الإنجليزية',
        'language_changed': 'تم تغيير اللغة بنجاح',
        'profile_updated': 'تم تحديث الملف الشخصي بنجاح!',
        'logout_confirm': 'هل أنت متأكد من تسجيل الخروج؟',
        
        // Homepage
        'home': 'الرئيسية',
        'welcome': 'مرحباً',
        'good_morning': 'صباح الخير',
        'good_afternoon': 'مساء الخير',
        'good_evening': 'مساء الخير',
        'add_favorites': 'أضف الأطباق إلى مفضلاتك',
        'special_offers': 'عروض خاصة',
        'recommended_for_you': 'مُوصى لك',
        'popular_dishes': 'الأطباق الشائعة',
        'categories': 'الفئات',
        'see_all': 'عرض الكل',
        'order_now': 'اطلب الآن',
        'add_to_cart': 'أضف للسلة',
        
        // البحث
        'search': 'بحث',
        'search_dishes': 'البحث عن الأطباق...',
        'search_food': 'البحث عن الطعام',
        'search_table': 'البحث عن الطاولة',
        
        // صفحة الطعام
        'food': 'الطعام',
        'show_all_items': 'عرض جميع العناصر',
        'show_favorites_only': 'عرض المفضلة فقط',
        'showing_favorites_only': 'عرض المفضلة فقط',
        'clear': 'مسح',
        'order_placed_successfully': 'تم تقديم الطلب بنجاح',
        'hide': 'إخفاء',
        
        // صفحة الطاولات
        'tables': 'الطاولات',
        'error_loading_tables': 'خطأ في تحميل الطاولات',
        'retry': 'إعادة المحاولة',
        
        // صفحة المساعدة والتقرير
        'contact_us': 'اتصل بنا',
        'faq': 'الأسئلة الشائعة',
        'report_issue': 'الإبلاغ عن مشكلة',
        'how_to_book_table': 'كيفية حجز طاولة؟',
        'book_table_through_tables_page': 'يمكنك حجز طاولة من خلال صفحة الطاولات في التطبيق.',
        'how_to_track_order': 'كيفية تتبع طلبي؟',
        'track_order_through_orders_page': 'يمكنك تتبع طلبك من خلال صفحة الطلبات.',
        'is_cash_on_delivery_available': 'هل الدفع عند الاستلام متاح؟',
        'cash_on_delivery_available': 'نعم، الدفع عند الاستلام متاح لجميع الطلبات.',
        'support_email': 'البريد الإلكتروني للدعم:',
        'send_note_report': 'إرسال ملاحظة / تقرير',
        'message': 'الرسالة',
        'send': 'إرسال',
        'fill_all_fields': 'يرجى ملء جميع الحقول',
        'message_sent_successfully': 'تم إرسال الرسالة بنجاح',
        
        // صفحة سياسة الخصوصية
        'introduction': 'مقدمة',
        'privacy_intro_text': 'نحن نقدر خصوصيتك. تشرح سياسة الخصوصية هذه كيفية جمعنا واستخدامنا وحماية معلوماتك عند استخدام تطبيقنا.',
        'information_collection': '1. جمع المعلومات',
        'information_collection_text': 'قد نجمع معلومات شخصية مثل اسمك وعنوان بريدك الإلكتروني ورقم هاتفك عند استخدام خدماتنا.',
        'how_we_use_info': '2. كيف نستخدم المعلومات',
        'how_we_use_info_text': 'تُستخدم معلوماتك لتقديم وتحسين خدماتنا ومعالجة المعاملات والتواصل معك.',
        'data_security': '3. أمان البيانات',
        'data_security_text': 'نطبق تدابير أمنية قوية لحماية بياناتك من الوصول غير المصرح به أو التغيير أو الكشف.',
        'contact_us_privacy': '4. اتصل بنا',
        'contact_us_privacy_text': 'إذا كان لديك أي أسئلة أو مخاوف حول سياسة الخصوصية هذه، يرجى الاتصال بفريق الدعم لدينا.',
        'copyright_text': '© 2025 تطبيق بورسيلا. جميع الحقوق محفوظة.',
        
        // صفحة الأخبار والخدمات
        'new_feature_released': '📢 ميزة جديدة متاحة',
        'new_feature_content': 'تمت إضافة ميزة جديدة لتوفير تجربة أفضل وأسرع للمستخدمين عند استخدام التطبيق.',
        'security_update': '🔒 تحديث أمني',
        'security_update_content': 'لقد عززنا التدابير الأمنية لحماية بياناتك بشكل أفضل وضمان خصوصيتك.',
        'new_language_support': '🌍 دعم لغات جديدة',
        'new_language_support_content': 'يدعم التطبيق الآن لغات متعددة لاستيعاب المستخدمين من جميع أنحاء العالم.',
        'performance_improvements': '⚡ تحسينات الأداء',
        'performance_improvements_content': 'تم إصلاح بعض المشاكل وتحسين سرعة وأداء التطبيق بشكل ملحوظ.',
        
        // صفحة الدفع
        'atm_bersama': 'بنك بيرساما',
        'pay_now': 'ادفع الآن',
        
        // صفحة الطلبات الأخيرة
        'recent': 'الأخيرة',
        'orders': 'الطلبات',
        'reservations': 'الحجوزات',
        'no_orders_found': 'لم يتم العثور على طلبات',
        'no_reservations_found': 'لم يتم العثور على حجوزات',
        'order_number': 'رقم الطلب',
        'total_amount': 'المبلغ الإجمالي',
        'order_status': 'حالة الطلب',
        'reservation_date': 'تاريخ الحجز',
        'guests': 'الضيوف',
        'popular_search': 'البحث الشائع',
        'popular_searches': 'البحث الشائع',
        'recent_searches': 'البحث الأخير',
        'no_results': 'لا توجد نتائج',
        'no_results_found': 'لا توجد نتائج',
        'search_results': 'نتائج البحث',
        'try_different_search': 'جرب كلمة بحث مختلفة',
        'filters': 'المرشحات',
        'sort_by': 'ترتيب حسب',
        'price_low_high': 'السعر: من الأقل للأعلى',
        'price_high_low': 'السعر: من الأعلى للأقل',
        'rating': 'التقييم',
        'popularity': 'الشعبية',
        
        // صفحة التقييم
        'rate_experience': 'كيف تقيم تجربتك معنا؟',
        'write_feedback': 'اكتب تعليقك (اختياري)',
        'submit': 'إرسال',
        'rating_thank_you': 'شكراً لك! لقد قيمتنا بـ {rating} نجوم ⭐',
        'recommended_dishes': 'الأطباق الموصى بها',
        'suggested_dishes': 'الأطباق المقترحة',
        
        // Cart
        'cart': 'السلة',
        'detail_cart': 'تفاصيل السلة',
        'your_cart': 'سلتك',
        'cart_empty': 'سلتك فارغة',
        'add_items': 'أضف بعض الأطباق اللذيذة!',
        'subtotal': 'المجموع الفرعي',
        'tax': 'الضريبة',
        'delivery_fee': 'رسوم التوصيل',
        'total': 'المجموع',
        'checkout': 'الدفع',
        'quantity': 'الكمية',
        'remove': 'إزالة',
        'continue_shopping': 'متابعة التسوق',
        'place_order': 'تقديم الطلب',
        'add_items_to_cart': 'أضف عناصر للسلة',
        'add_table': 'أضف طاولة',
        'table_reservations': 'حجوزات الطاولات',
        'items': 'عناصر',
        
        // Favorites
        'favorites': 'المفضلة',
        'my_favorites': 'مفضلاتي',
        'no_favorites': 'لا توجد مفضلات بعد',
        'add_favorites': 'أضف بعض الأطباق لمفضلاتك!',
        'remove_from_favorites': 'إزالة من المفضلة',
        'add_to_favorites': 'أضف للمفضلة',
        'search_favorite_dishes': 'البحث في الأطباق المفضلة...',
        'favorite_dishes': 'أطباق مفضلة',
        'no_favorites_yet': 'لا توجد مفضلات بعد',
        'add_favorites_instruction': 'أضف بعض الأطباق لمفضلاتك!',
        'browse_menu': 'تصفح القائمة',
        
        // Additional recent page keys
        'item': 'عنصر',
        'items': 'عناصر',
        'guest': 'ضيف',
        'guests': 'ضيوف',
        'reservation_number': 'حجز رقم ',
        'special_requests': 'طلبات خاصة',
        'at': 'في',
        
        // Order statuses
        'pending': 'قيد الانتظار',
        'processing': 'قيد المعالجة',
        'completed': 'مكتمل',
        'confirmed': 'مؤكد',
        'delivered': 'تم التسليم',
        'received': 'تم الاستلام',
        'cancelled': 'ملغي',
        'failed': 'فشل',
        
        // Months
        'january': 'يناير',
        'february': 'فبراير',
        'march': 'مارس',
        'april': 'أبريل',
        'may': 'مايو',
        'june': 'يونيو',
        'july': 'يوليو',
        'august': 'أغسطس',
        'september': 'سبتمبر',
        'october': 'أكتوبر',
        'november': 'نوفمبر',
        'december': 'ديسمبر',
        
        // Food & Tables
        'menu': 'القائمة',
        'dishes': 'الأطباق',
        'tables': 'الطاولات',
        'book_table': 'احجز طاولة',
        'reserve_now': 'احجز الآن',
        'available': 'متاح',
        'chairs': 'كراسي',
        'occupied': 'مشغول',
        'reserved': 'محجوز',
        'capacity': 'السعة',
        'table_details': 'تفاصيل الطاولة',
        'no_tables_found': 'لا توجد طاولة تبحث عنها :(',
        'find_other_table': 'ابحث عن طاولة أخرى',
        'all': 'الكل',
        'single': 'فردي',
        'double': 'مزدوج',
        'family': 'عائلي',
        'special': 'خاص',
        'custom': 'مخصص',
        'duration': 'المدة',
        'minutes': 'دقائق',
        'hour': 'ساعة',
        'hours': 'ساعات',
        'custom_time': 'وقت مخصص',
        'select_from_list': 'اختر من القائمة',
        'reservation_date_time': 'تاريخ ووقت الحجز',
        'select_date': 'اختر التاريخ',
        'select_hour': 'اختر الساعة',
        'additional': 'إضافات',
        'chair': 'كرسي',
        'table': 'طاولة',
        'flower': 'زهور',
        'free': 'مجاني',
        'add_to_cart': 'أضف للسلة',
        'select_date_time': 'اختر التاريخ والوقت',
        'table_reservation_added': 'تم إضافة حجز الطاولة للسلة!',
        'failed_update_favorite': 'فشل في تحديث المفضلة',
        'added_to_cart': 'تم إضافته للسلة!',
        'failed_add_to_cart': 'فشل في الإضافة للسلة',
        'adding': 'جاري الإضافة...',
        'reservation_details': 'تفاصيل الحجز',
        'date': 'التاريخ',
        'time': 'الوقت',
        'guests': 'الضيوف',
        'special_requests': 'طلبات خاصة',
        
        // Orders
        'orders': 'الطلبات',
        'order_history': 'تاريخ الطلبات',
        'current_orders': 'الطلبات الحالية',
        'order_details': 'تفاصيل الطلب',
        'order_status': 'حالة الطلب',
        'pending': 'في الانتظار',
        'confirmed': 'مؤكد',
        'preparing': 'قيد التحضير',
        'ready': 'جاهز',
        'delivered': 'تم التوصيل',
        'cancelled': 'ملغي',
        'track_order': 'تتبع الطلب',
        'reorder': 'إعادة الطلب',
        
        // Authentication
        'login': 'تسجيل الدخول',
        'register': 'التسجيل',
        'sign_in': 'تسجيل الدخول',
        'sign_up': 'إنشاء حساب',
        'forgot_password': 'نسيت كلمة المرور؟',
        'password': 'كلمة المرور',
        'confirm_password': 'تأكيد كلمة المرور',
        'phone': 'الهاتف',
        'phone_number': 'رقم الهاتف',
        'address': 'العنوان',
        'create_account': 'إنشاء حساب',
        'already_have_account': 'لديك حساب بالفعل؟',
        'dont_have_account': 'ليس لديك حساب؟',
        'sign_up_now': 'إنشاء حساب الآن',
        'enter_your_name': 'أدخل اسمك',
        'enter_valid_phone': 'أدخل رقم هاتف صحيح مكون من 10 أرقام',
        'registration_successful': 'تم التسجيل بنجاح!',
        'login_successful': 'تم تسجيل الدخول بنجاح!',
        'unexpected_error': 'حدث خطأ غير متوقع',
        'app_name': 'مدانغ',
        'app_tagline': 'حجز طاولة وطعام من أي مكان.',
        
        // General
        'yes': 'نعم',
        'no': 'لا',
        'ok': 'موافق',
        'done': 'تم',
        'next': 'التالي',
        'previous': 'السابق',
        'back': 'رجوع',
        'close': 'إغلاق',
        'loading': 'جاري التحميل...',
        'error': 'خطأ',
        'success': 'نجح',
        'warning': 'تحذير',
        'info': 'معلومات',
        'retry': 'إعادة المحاولة',
        'refresh': 'تحديث',
      },
    };

    return translations[_currentLanguage]?[key] ?? key;
  }

  // Get localized name from object with name and nameAr properties
  String getLocalizedName(dynamic object) {
    if (object == null) return '';
    
    if (isArabic) {
      // Try to get Arabic name first, fallback to English
      if (object is Map<String, dynamic>) {
        return object['name_ar'] ?? object['nameAr'] ?? object['name'] ?? '';
      } else if (object.runtimeType.toString().contains('Model')) {
        try {
          return (object as dynamic).nameAr ?? (object as dynamic).name ?? '';
        } catch (e) {
          return (object as dynamic).name ?? '';
        }
      }
    }
    
    // Default to English name
    if (object is Map<String, dynamic>) {
      return object['name'] ?? '';
    } else {
      try {
        return (object as dynamic).name ?? '';
      } catch (e) {
        return '';
      }
    }
  }

  // Get localized description from object with description and descriptionAr properties
  String getLocalizedDescription(dynamic object) {
    if (object == null) return '';
    
    if (isArabic) {
      // Try to get Arabic description first, fallback to English
      if (object is Map<String, dynamic>) {
        return object['description_ar'] ?? object['descriptionAr'] ?? object['description'] ?? '';
      } else if (object.runtimeType.toString().contains('Model')) {
        try {
          return (object as dynamic).descriptionAr ?? (object as dynamic).description ?? '';
        } catch (e) {
          return (object as dynamic).description ?? '';
        }
      }
    }
    
    // Default to English description
    if (object is Map<String, dynamic>) {
      return object['description'] ?? '';
    } else {
      try {
        return (object as dynamic).description ?? '';
      } catch (e) {
        return '';
      }
    }
  }
}
