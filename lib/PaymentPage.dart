// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'utils/localization_helper.dart';

class Paymentpage extends StatefulWidget {
  const Paymentpage({super.key});

  @override
  State<Paymentpage> createState() => _PaymentpageState();
}

class _PaymentpageState extends State<Paymentpage> with LocalizationMixin {
  // ignore: non_constant_identifier_names
  String? Payment;

  @override
  Widget build(BuildContext context) {
    return withDirectionality(
      Scaffold(
        appBar: createLocalizedAppBar(
          titleKey: 'payment_method',
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                // ATM Bersama

                RadioListTile(
                    activeColor: const Color(0xff008C8C),
                    contentPadding: const EdgeInsets.only(top: 20, left: 15),
                    title: Text(
                      getText('atm_bersama'),
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    value: getText('atm_bersama'),
                    groupValue: Payment,
                    onChanged: (val) {
                      setState(() {
                        Payment = val;
                      });
                    }),
                const Divider(
                  indent: 60,
                  endIndent: 20,
                  thickness: 1,
                ),

                // Gopay

                RadioListTile(
                    activeColor: const Color(0xff008C8C),
                    contentPadding: const EdgeInsets.only(top: 10, left: 15),
                    title: const Text(
                      "Gopay",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    value: "Gopay",
                    groupValue: Payment,
                    onChanged: (val) {
                      setState(() {
                        Payment = val;
                      });
                    }),
                const Divider(
                  indent: 60,
                  endIndent: 20,
                  thickness: 1,
                ),

                // LinkAja

                RadioListTile(
                    activeColor: const Color(0xff008C8C),
                    contentPadding: const EdgeInsets.only(top: 10, left: 15),
                    title: const Text(
                      "LinkAja",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    value: "LinkAja",
                    groupValue: Payment,
                    onChanged: (val) {
                      setState(() {
                        Payment = val;
                      });
                    }),
                const Divider(
                  indent: 60,
                  endIndent: 20,
                  thickness: 1,
                ),
              ],
            ),
            Container(
              decoration: BoxDecoration(color: Colors.white, boxShadow: [
                BoxShadow(
                    offset: const Offset(1, -0.2),
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 3,
                    blurRadius: 5)
              ]),
              width: 500,
              height: 100,
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                      width: 500,
                      decoration: const BoxDecoration(
                          color: Color(
                            0xff008C8C,
                          ),
                          borderRadius: BorderRadius.all(Radius.circular(10))),
                      child: ElevatedButton(
                        onPressed: Payment == null ? null : () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xff008C8C),
                          disabledBackgroundColor: Colors.grey,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 40, vertical: 16),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                        ),
                        child: Text(
                          getText('pay_now'),
                          style: TextStyle(fontSize: 18, color: Colors.white),
                        ),
                      )),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
