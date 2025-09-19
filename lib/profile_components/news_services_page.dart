import 'package:flutter/material.dart';
import '../utils/localization_helper.dart';

class NewsAndServicesPage extends StatefulWidget {
  const NewsAndServicesPage({super.key});

  @override
  State<NewsAndServicesPage> createState() => _NewsAndServicesPageState();
}

class _NewsAndServicesPageState extends State<NewsAndServicesPage> with LocalizationMixin {

  @override
  Widget build(BuildContext context) {
    return withDirectionality(
      Scaffold(
        appBar: createLocalizedAppBar(
          titleKey: 'news_services',
        ),
        body: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            NewsCard(
              title: getText('new_feature_released'),
              content: getText('new_feature_content'),
            ),
            NewsCard(
              title: getText('security_update'),
              content: getText('security_update_content'),
            ),
            NewsCard(
              title: getText('new_language_support'),
              content: getText('new_language_support_content'),
            ),
            NewsCard(
              title: getText('performance_improvements'),
              content: getText('performance_improvements_content'),
            ),
          ],
        ),
      ),
    );
  }
}

class NewsCard extends StatelessWidget {
  final String title;
  final String content;

  const NewsCard({super.key, required this.title, required this.content});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 3,
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.teal,
              ),
              textAlign: TextAlign.left,
            ),
            const SizedBox(height: 8),
            Text(
              content,
              style: const TextStyle(fontSize: 16),
              textAlign: TextAlign.left,
            ),
          ],
        ),
      ),
    );
  }
}
