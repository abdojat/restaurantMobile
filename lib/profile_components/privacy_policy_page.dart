import 'package:flutter/material.dart';
import '../utils/localization_helper.dart';

class PrivacyPolicyPage extends StatefulWidget {
  const PrivacyPolicyPage({super.key});

  @override
  State<PrivacyPolicyPage> createState() => _PrivacyPolicyPageState();
}

class _PrivacyPolicyPageState extends State<PrivacyPolicyPage>
    with LocalizationMixin {
  @override
  Widget build(BuildContext context) {
    return withDirectionality(
      Scaffold(
        appBar: createLocalizedAppBar(
          titleKey: 'privacy_policy',
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                getText('introduction'),
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF008C8C),
                ),
              ),
              SizedBox(height: 8),
              Text(
                getText('privacy_intro_text'),
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 20),
              Text(
                getText('information_collection'),
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF008C8C),
                ),
              ),
              SizedBox(height: 6),
              Text(
                getText('information_collection_text'),
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 20),
              Text(
                getText('how_we_use_info'),
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF008C8C),
                ),
              ),
              SizedBox(height: 6),
              Text(
                getText('how_we_use_info_text'),
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 20),
              Text(
                getText('data_security'),
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF008C8C),
                ),
              ),
              SizedBox(height: 6),
              Text(
                getText('data_security_text'),
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 20),
              Text(
                getText('contact_us_privacy'),
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF008C8C),
                ),
              ),
              SizedBox(height: 6),
              Text(
                getText('contact_us_privacy_text'),
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 30),
              Center(
                child: Text(
                  getText('copyright_text'),
                  style: const TextStyle(fontSize: 14, color: Colors.grey),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
