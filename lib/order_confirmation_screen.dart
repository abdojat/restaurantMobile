import 'package:flutter/material.dart';

class OrderConfirmationScreen extends StatelessWidget {
  const OrderConfirmationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(),
        title: const Text('Order Confirmation'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const _OrderItem(
              image: 'assets/noodle.png',
              title: 'Single Breakfast',
              price: 'Rp70.000',
            ),
            const SizedBox(height: 12),
            const _OrderItem(
              image: 'assets/noodle.png',
              title: 'Noodle Ex',
              price: 'Rp42.000',
            ),
            const Divider(height: 32),
            _priceRow('Subtotal', 'Rp112.000'),
            _priceRow('Discount [A29B4]', '-Rp22.400', isDiscount: true),
            _priceRow('Delivery Fee', 'Rp10.000'),
            const SizedBox(height: 12),
            const Divider(),
            _priceRow('Total', 'Rp99.600', isTotal: true),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: () {},
                child: const Text('Place Order'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _priceRow(String label, String amount,
      {bool isDiscount = false, bool isTotal = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style: TextStyle(
                fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
              )),
          Text(amount,
              style: TextStyle(
                color: isDiscount
                    ? Colors.red
                    : isTotal
                        ? Colors.black
                        : Colors.grey[800],
                fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
              )),
        ],
      ),
    );
  }
}

class _OrderItem extends StatelessWidget {
  final String image;
  final String title;
  final String price;

  const _OrderItem({
    required this.image,
    required this.title,
    required this.price,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Image.asset(image, width: 48, height: 48),
        const SizedBox(width: 12),
        Expanded(child: Text(title)),
        Text(price),
      ],
    );
  }
}
