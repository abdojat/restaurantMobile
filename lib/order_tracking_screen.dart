import 'package:flutter/material.dart';

class OrderTrackingScreen extends StatelessWidget {
  final int currentStep = 2;

  final List<String> steps = [
    'Order received from the restaurant',
    'Preparing your order',
    'Captain picked up the order',
    'Captain is on the way',
    'Order delivered',
  ];

  OrderTrackingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(),
        title: const Text('Order Trecking'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        child: Column(
          children: List.generate(steps.length, (index) {
            final isActive = index == currentStep;
            final isPassed = index < currentStep;

            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  children: [
                    Icon(
                      isActive
                          ? Icons.radio_button_checked
                          : Icons.radio_button_unchecked,
                      color: isActive
                          ? Colors.teal
                          : isPassed
                              ? Colors.grey
                              : Colors.grey[400],
                      size: 20,
                    ),
                    if (index != steps.length - 1)
                      Container(
                        width: 2,
                        height: 40,
                        color: isPassed || isActive
                            ? Colors.teal
                            : Colors.grey[300],
                      ),
                  ],
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 2),
                    child: Text(
                      steps[index],
                      style: TextStyle(
                        color: isActive ? Colors.teal : Colors.black,
                        fontWeight:
                            isActive ? FontWeight.w600 : FontWeight.normal,
                      ),
                    ),
                  ),
                ),
              ],
            );
          }),
        ),
      ),
    );
  }
}
