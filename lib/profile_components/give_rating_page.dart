import 'package:flutter/material.dart';
import '../utils/localization_helper.dart';

class GiveRatingPage extends StatefulWidget {
  const GiveRatingPage({super.key});

  @override
  State<GiveRatingPage> createState() => _GiveRatingPageState();
}

class _GiveRatingPageState extends State<GiveRatingPage> with LocalizationMixin {
  int selectedRating = 0;

  @override
  Widget build(BuildContext context) {
    return withDirectionality(
      Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.teal,
          title: Text(
            getText('give_rating'),
            style: const TextStyle(color: Colors.white),
          ),
          iconTheme: const IconThemeData(color: Colors.white),
        ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              getText('rate_experience'),
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 30),

            // ⭐ Rating stars
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(5, (index) {
                int starIndex = index + 1;
                return IconButton(
                  onPressed: () {
                    setState(() {
                      selectedRating = starIndex;
                    });
                  },
                  icon: Icon(
                    Icons.star,
                    size: 40,
                    color: selectedRating >= starIndex
                        ? Colors.amber
                        : Colors.grey,
                  ),
                );
              }),
            ),

            const SizedBox(height: 30),

            // 📝 Optional feedback field
            TextField(
              maxLines: 4,
              decoration: InputDecoration(
                hintText: getText('write_feedback'),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Colors.teal, width: 2),
                ),
              ),
            ),

            const SizedBox(height: 30),

            // ✅ Submit button
            ElevatedButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      getText('rating_thank_you').replaceAll('{rating}', selectedRating.toString()),
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 18),
                    ),
                    backgroundColor: Colors.teal,
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(
                    horizontal: 40, vertical: 15),
              ),
              child: Text(
                getText('submit'),
                style: const TextStyle(fontSize: 18),
              ),
            )
          ],
        ),
      ),
    ),
    );
  }
}
