import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'models/table_model.dart';
import 'models/reservation_item.dart';
import 'services/cart_service.dart';
import 'services/language_service.dart';
import 'utils/localization_helper.dart';
import 'extensions/table_model_extensions.dart';

class BookingBottomSheet extends StatefulWidget {
  final TableModel table;

  const BookingBottomSheet({super.key, required this.table});

  @override
  State<BookingBottomSheet> createState() => _BookingBottomSheetState();
}

class _BookingBottomSheetState extends State<BookingBottomSheet>
    with LocalizationMixin {
  late final LanguageService _languageService;
  bool isCustomTime = false;
  String? selectedTimeChip;
  DateTime? selectedDate;
  TimeOfDay? selectedTime;
  Map<String, Map<String, dynamic>> selectedAdditions = {};

  @override
  void initState() {
    super.initState();
    _languageService = LanguageService();
  }

  void _initializeAdditions() {
    if (selectedAdditions.isEmpty) {
      selectedAdditions = {
        getText('chair'): {"isSelected": false, "price": getText('free')},
        getText('table'): {"isSelected": false, "price": getText('free')},
      };
    }
  }

  // Check if a date should be selectable
  bool isDateSelectable(DateTime date) {
    // Convert to just date (without time) for comparison
    final dateOnly = DateTime(date.year, date.month, date.day);

    // Check if any reservation exists for this date
    return !widget.table.reservationsList.any((reservation) {
      if (reservation.startDate == null) return false;

      final reservationDate = DateTime.parse(reservation.startDate!);
      final reservationDateOnly = DateTime(
          reservationDate.year, reservationDate.month, reservationDate.day);

      return reservationDateOnly.isAtSameMomentAs(dateOnly);
    });
  }

  void pickDate() async {
    final now = DateTime.now();
    final languageService = LanguageService();
    final isArabic = languageService.isArabic;
    final locale = isArabic
        ? const Locale('ar', 'SA')
        : const Locale('en', 'US');

    final picked = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: now,
      lastDate: now.add(const Duration(days: 30)),
      selectableDayPredicate: isDateSelectable,
      locale: locale,
      builder: (context, child) {
        return Localizations(
          locale: locale,
          delegates: const [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          child: Directionality(
            textDirection: isArabic ? TextDirection.rtl : TextDirection.ltr,
            child: Theme(
              data: Theme.of(context).copyWith(
                colorScheme: const ColorScheme.light(
                  primary: Color(0xFF008C8C),
                  onPrimary: Colors.white,
                  onSurface: Colors.black,
                  surface: Colors.white,
                ),
                textButtonTheme: TextButtonThemeData(
                  style: TextButton.styleFrom(
                    foregroundColor: Color(0xFF008C8C),
                  ),
                ),
                textTheme: Theme.of(context).textTheme.copyWith(
                      bodySmall: TextStyle(
                          color: Colors.grey[400]), // For disabled dates
                    ),
              ),
              child: child!,
            ),
          ),
        );
      },
    );

    if (picked != null) {
      setState(() {
        selectedDate = picked;
        // Reset selected time when date changes
        selectedTime = null;
      });
    }
  }

  void pickTime() async {
    final languageService = LanguageService();
    final isArabic = languageService.isArabic;
    final locale =
        isArabic ? const Locale('ar', 'SA') : const Locale('en', 'US');

    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      builder: (context, child) {
        return Localizations(
          locale: locale,
          delegates: const [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          child: Directionality(
            textDirection: isArabic ? TextDirection.rtl : TextDirection.ltr,
            child: Theme(
              data: Theme.of(context).copyWith(
                timePickerTheme: const TimePickerThemeData(
                  dialHandColor: Color(0xFF008C8C),
                  dialBackgroundColor: Color(0xFFE0F2F1),
                  hourMinuteTextColor: Colors.black,
                  hourMinuteColor: Color(0xFFE0F2F1),
                ),
                colorScheme: const ColorScheme.light(
                  primary: Color(0xFF008C8C),
                  onPrimary: Colors.white,
                  onSurface: Colors.black,
                ),
              ),
              child: child!,
            ),
          ),
        );
      },
    );

    if (picked != null) {
      setState(() {
        selectedTime = picked;
      });
    }
  }

  void _addReservationToCart() {
    if (selectedDate == null || selectedTime == null) return;

    final reservationItem = ReservationItem(
      id: '${widget.table.id}_${DateTime.now().millisecondsSinceEpoch}',
      tableId: widget.table.id.toString(),
      tableName: widget.table.getLocalizedName(),
      tableType: widget.table.type,
      reservationDate: selectedDate!,
      reservationTime: selectedTime!,
      duration: selectedTimeChip ?? 'Custom',
      guests: 1, // Default guests, could be made configurable
      additions: Map<String, Map<String, dynamic>>.from(selectedAdditions),
      basePrice: 50000, // Base reservation price, could be from table model
    );

    CartService().addReservation(reservationItem);

    // Show confirmation and close bottom sheet
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(getText('table_reservation_added')),
        backgroundColor: Color(0xFF008C8C),
        duration: Duration(seconds: 2),
      ),
    );

    Navigator.pop(context);
  }

  bool isTableAvailable() {
    if (selectedDate == null || selectedTime == null) return false;
    final fullDateTime = DateTime(
      selectedDate!.year,
      selectedDate!.month,
      selectedDate!.day,
      selectedTime!.hour,
      selectedTime!.minute,
    );

    // تحقق من تضارب الحجز
    return !widget.table.reservationsList.any((reservation) =>
        reservation.startDate != null &&
        DateTime.parse(reservation.startDate!) == fullDateTime);
  }

  String _formatDate(DateTime date) {
    final languageService = LanguageService();
    if (languageService.isArabic) {
      // Arabic date format: DD/MM/YYYY
      return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
    } else {
      // English date format: DD/MM/YYYY
      return '${date.day}/${date.month}/${date.year}';
    }
  }

  String _formatTime(TimeOfDay time) {
    final languageService = LanguageService();
    if (languageService.isArabic) {
      // Arabic time format: HH:MM
      return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
    } else {
      // English time format
      return time.format(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    // Set default selectedTimeChip if null
    selectedTimeChip ??= '30 ${getText('minutes')}';

    // Initialize additions with localized keys
    _initializeAdditions();

    return withDirectionality(
      Container(
        width: double.infinity,
        height: 790,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Drag handle
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: const Color(0xFFB3B3B3),
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
            const SizedBox(height: 30),

            // Time title
            Text(
              getText('duration'),
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 12),

            if (!isCustomTime)
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    timeChip('30 ${getText('minutes')}'),
                    timeChip('45 ${getText('minutes')}'),
                    timeChip('1 ${getText('hour')}'),
                    timeChip('2 ${getText('hours')}'),
                  ],
                ),
              )
            else
              Row(
                children: [
                  const SizedBox(width: 10),
                  Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: '10 ${getText('minutes')}',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(6),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 10),
                      ),
                    ),
                  ),
                ],
              ),

            const SizedBox(height: 16),

            // Custom time toggle
            Center(
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    isCustomTime = !isCustomTime;
                  });
                },
                child: Text(
                  isCustomTime
                      ? getText('select_from_list')
                      : getText('custom_time'),
                  style: const TextStyle(
                    color: Color(0xFF008C8C),
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 30),

            Text(
              getText('reservation_date_time'),
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: pickDate,
                    icon: const Icon(Icons.calendar_today,
                        color: Color(0xFF008C8C), size: 20),
                    label: Text(
                      selectedDate == null
                          ? getText('select_date')
                          : _formatDate(selectedDate!),
                      style: const TextStyle(fontSize: 16, color: Colors.black),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: pickTime,
                    icon: const Icon(Icons.access_time,
                        color: Color(0xFF008C8C), size: 20),
                    label: Text(
                      selectedTime == null
                          ? getText('select_hour')
                          : _formatTime(selectedTime!),
                      style: const TextStyle(fontSize: 16, color: Colors.black),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 30),

            Text(
              getText('additional'),
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 16),

            additionalRow(getText('chair'), getText('free')),
            const SizedBox(height: 8),
            additionalRow(getText('table'), getText('free')),
            const SizedBox(height: 30),

            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: selectedDate != null && selectedTime != null
                    ? _addReservationToCart
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: selectedDate != null && selectedTime != null
                      ? const Color(0xFF008C8C)
                      : Colors.grey,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text(
                  selectedDate != null && selectedTime != null
                      ? getText('add_to_cart')
                      : getText('select_date_time'),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget timeChip(String label) {
    final isSelected = selectedTimeChip == label;

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedTimeChip = label;
        });
      },
      child: Container(
        margin: const EdgeInsets.only(right: 8),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF008C8C) : const Color(0xFFF3F1F1),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: TextStyle(
              color: isSelected ? Colors.white : Colors.black, fontSize: 15),
        ),
      ),
    );
  }

  Widget additionalRow(String label, String price) {
    // Ensure the key exists in selectedAdditions
    if (!selectedAdditions.containsKey(label)) {
      selectedAdditions[label] = {"isSelected": false, "price": price};
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Checkbox(
              value: selectedAdditions[label]?["isSelected"] ?? false,
              onChanged: (value) {
                setState(() {
                  selectedAdditions[label] = selectedAdditions[label] ?? {};
                  selectedAdditions[label]!["isSelected"] = value ?? false;
                });
              },
              activeColor: const Color(0xFF008C8C),
            ),
            Text(label,
                style:
                    const TextStyle(fontSize: 17, fontWeight: FontWeight.w400)),
          ],
        ),
        Text(price,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
      ],
    );
  }
}
