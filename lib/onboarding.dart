import 'package:flutter/material.dart';
import 'sign_up.dart';
import 'utils/localization_helper.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> with LocalizationMixin {

  @override
  Widget build(BuildContext context) {
    return withDirectionality(
      Scaffold(
        body: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          // image: DecorationImage(
          //   image: AssetImage(
          //     'assets/texture_background.png',
          //   ), // Optional: Add a subtle texture image
          //   fit: BoxFit.cover,
          //   colorFilter: ColorFilter.mode(
          //     Colors.grey.withOpacity(0.1),
          //     BlendMode.dstATop,
          //   ),
          // ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                getText('app_name'),
                style: const TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.teal,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                getText('app_tagline'),
                style: const TextStyle(fontSize: 18, color: Colors.black),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    // Navigate to the next page (e.g., login page)
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => SignUpScreen()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal,
                    padding: const EdgeInsets.symmetric(horizontal: 80, vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  child: Text(
                    getText('next'),
                    style: const TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    ));
  }
}
