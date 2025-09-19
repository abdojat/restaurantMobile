import 'package:flutter/material.dart';
import '../utils/localization_helper.dart';

class HelpAndReportPage extends StatefulWidget {
  const HelpAndReportPage({super.key});

  @override
  State<HelpAndReportPage> createState() => _HelpAndReportPageState();
}

class _HelpAndReportPageState extends State<HelpAndReportPage> with LocalizationMixin {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController messageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return withDirectionality(
      Scaffold(
        appBar: createLocalizedAppBar(
          titleKey: 'help_report',
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // --- FAQ Section ---
            Text(
              getText('faq'),
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            ExpansionTile(
              title: Text(
                getText('how_to_book_table'),
                style: const TextStyle(fontSize: 16),
              ),
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    getText('book_table_through_tables_page'),
                  ),
                )
              ],
            ),
            ExpansionTile(
              title: Text(
                getText('how_to_track_order'),
                style: const TextStyle(fontSize: 16),
              ),
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    getText('track_order_through_orders_page'),
                  ),
                )
              ],
            ),
            ExpansionTile(
              title: Text(
                getText('is_cash_on_delivery_available'),
                style: const TextStyle(fontSize: 16),
              ),
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    getText('cash_on_delivery_available'),
                  ),
                )
              ],
            ),

            const SizedBox(height: 20),

            // --- Contact Us ---
            Text(
              getText('contact_us'),
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                const Icon(Icons.email, color: Color(0xFF008C8C)),
                const SizedBox(width: 8),
                Text(
                  getText('support_email'),
                ),
                SizedBox(width: 8),
                Text("support@restaurant.com"),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: const [
                Icon(Icons.phone, color: Color(0xFF008C8C)),
                SizedBox(width: 8),
                Text("+123 456 7890"),
              ],
            ),

            const SizedBox(height: 20),

            // --- Report Form ---
            Text(
              getText('send_note_report'),
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),

            TextField(
              controller: nameController,
              decoration: InputDecoration(
                labelText: getText('name'),
                labelStyle: TextStyle(color: Color(0xFF008C8C)),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Color(0xFF008C8C)),
                  borderRadius: BorderRadius.circular(12),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: messageController,
              maxLines: 4,
              decoration: InputDecoration(
                labelText: getText('message'),
                labelStyle: TextStyle(color: Color(0xFF008C8C)),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Color(0xFF008C8C)),
                  borderRadius: BorderRadius.circular(12),
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 16),

            Center(
              child: ElevatedButton(
                onPressed: () {
                  String name = nameController.text.trim();
                  String msg = messageController.text.trim();

                  if (name.isEmpty || msg.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(getText('fill_all_fields'))),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(getText('message_sent_successfully'))),
                    );
                    nameController.clear();
                    messageController.clear();
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF008C8C),
                  padding: const EdgeInsets.symmetric(
                      horizontal: 32, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  getText('send'),
                  style: const TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    ),
    );
  }
}
