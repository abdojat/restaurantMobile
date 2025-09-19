import 'package:flutter/material.dart';

class AddressScreen extends StatelessWidget {
  const AddressScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(),
        title: const Text('Address'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const _AddressField(label: 'Street Address'),
            const SizedBox(height: 12),
            const _AddressField(label: 'Apt / Suite'),
            const SizedBox(height: 12),
            const _AddressField(label: 'Floor'),
            const SizedBox(height: 12),
            const _AddressField(label: 'Note', maxLines: 3),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: () {},
                child: const Text('Save Location'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AddressField extends StatelessWidget {
  final String label;
  final int maxLines;

  const _AddressField({required this.label, this.maxLines = 1});

  @override
  Widget build(BuildContext context) {
    return TextField(
      maxLines: maxLines,
      decoration: InputDecoration(
        hintText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }
}
