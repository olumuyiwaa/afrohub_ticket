import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_paypal/flutter_paypal.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:http/http.dart' as http;

class PaymentScreen extends StatefulWidget {
  final String title;
  final String category;
  final String date;
  final String location;
  final double price;
  final int unit;
  const PaymentScreen(
      {super.key,
      required this.title,
      required this.category,
      required this.date,
      required this.location,
      required this.price,
      required this.unit});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  // Stripe payment method
  Future<void> handleStripePayment() async {
    try {
      // Call your backend to get Stripe Payment Intent
      final response = await http.post(
        Uri.parse(
            "https://your-backend-server.com/create-payment-intent"), // Replace with your backend API
        body: json.encode({
          'amount': 1000, // Example: $10.00 (amount in cents)
          'currency': 'usd',
        }),
        headers: {'Content-Type': 'application/json'},
      );

      final paymentIntent = json.decode(response.body);

      // Initialize payment sheet
      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          paymentIntentClientSecret: paymentIntent['client_secret'],
          merchantDisplayName: 'Your Business Name',
        ),
      );

      // Display Stripe payment sheet
      await Stripe.instance.presentPaymentSheet();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Payment successful!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  // PayPal payment method
  void handlePayPalPayment() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (BuildContext context) => UsePaypal(
          sandboxMode: true, // Set to false in production
          clientId:
              "your_paypal_client_id", // Replace with your PayPal Client ID
          secretKey:
              "your_paypal_secret", // Replace with your PayPal Secret Key
          returnURL: "success.example.com",
          cancelURL: "cancel.example.com",
          transactions: const [
            {
              "amount": {
                "total": '10.00',
                "currency": "USD",
                "details": {
                  "subtotal": '10.00',
                  "shipping": '0',
                  "shipping_discount": 0
                }
              },
              "description": "The payment transaction description.",
              "item_list": {
                "items": [
                  {
                    "name": "Sample Item",
                    "quantity": 1,
                    "price": '10.00',
                    "currency": "USD"
                  }
                ]
              }
            }
          ],
          onSuccess: (Map params) {
            print("Success: $params");
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('PayPal payment successful!')),
            );
          },
          onError: (error) {
            print("Error: $error");
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('PayPal payment failed!')),
            );
          },
          onCancel: () {
            print('PayPal payment canceled.');
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('PayPal payment canceled.')),
            );
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Make Payment'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Event Title
                  Text(
                    widget.title,
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),

                  // Category, Location, Date, Price
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Category",
                            style: TextStyle(fontSize: 12, color: Colors.grey),
                          ),
                          Text(
                            widget.category,
                            style: const TextStyle(
                                fontSize: 14, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          const Text(
                            "Date",
                            style: TextStyle(fontSize: 12, color: Colors.grey),
                          ),
                          Text(
                            widget.date,
                            style: const TextStyle(
                                fontSize: 14, fontWeight: FontWeight.bold),
                          ),
                        ],
                      )
                    ],
                  ),
                  const SizedBox(height: 18),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Location",
                            style: TextStyle(fontSize: 12, color: Colors.grey),
                          ),
                          Text(
                            widget.location,
                            style: const TextStyle(
                                fontSize: 14, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          const Text(
                            "Price",
                            style: TextStyle(fontSize: 12, color: Colors.grey),
                          ),
                          Text(
                            "\$ ${widget.price}",
                            style: const TextStyle(
                                fontSize: 14, fontWeight: FontWeight.bold),
                          ),
                        ],
                      )
                    ],
                  ),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "No. of Tickets:",
                        style: TextStyle(
                          fontSize: 18,
                        ),
                      ),
                      Text(
                        widget.unit.toString(),
                        style: const TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      )
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Total:",
                        style: TextStyle(fontSize: 18),
                      ),
                      Text(
                        (widget.price * widget.unit).toString(),
                        style: const TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      )
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 48),
            const Text(
              'Choose Payment Method',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 20),
            InkWell(
              onTap: handleStripePayment,
              child: Container(
                width: 200,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8)),
                padding: const EdgeInsets.symmetric(
                  vertical: 12,
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.credit_card),
                    SizedBox(
                      width: 8,
                    ),
                    Text('Pay with Stripe'),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            InkWell(
              onTap: handlePayPalPayment,
              child: Container(
                width: 200,
                decoration: BoxDecoration(
                    color: Colors.yellow,
                    borderRadius: BorderRadius.circular(8)),
                padding: const EdgeInsets.symmetric(
                  vertical: 12,
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.paypal),
                    SizedBox(
                      width: 8,
                    ),
                    Text('Pay with PayPal'),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
