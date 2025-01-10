// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';

import '../../../api/api_post.dart';
import '../../../utilities/const.dart';

class PaymentScreen extends StatefulWidget {
  final String title;
  final String image;
  final String category;
  final String ticketId;
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
      required this.unit,
      required this.ticketId,
      required this.image});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Make Payment',
          style: TextStyle(fontSize: 18),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 320,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: greyColor, // Fallback color
                  image: DecorationImage(
                    image: _getImageProvider(
                        widget.image), // Dynamic image provider
                    fit: BoxFit.cover, // Adjust the image fit
                  ),
                ),
              ),
              const SizedBox(
                height: 24,
              ),
              Text(
                widget.title,
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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
          const SizedBox(height: 32),
          // const Row(
          //   mainAxisAlignment: MainAxisAlignment.center,
          //   children: [
          //     Text(
          //       'Choose Payment Method',
          //       style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          //     )
          //   ],
          // ),
          // const SizedBox(height: 24),
          // InkWell(
          //   onTap: () {
          //     handleStripePayment(
          //       context: context,
          //       ticketId: widget.ticketId,
          //       ticketCount: widget.unit,
          //     );
          //   },
          //   child: Container(
          //     width: 200,
          //     decoration: BoxDecoration(
          //         color: Colors.white, borderRadius: BorderRadius.circular(8)),
          //     padding: const EdgeInsets.symmetric(
          //       vertical: 12,
          //     ),
          //     child: const Row(
          //       mainAxisAlignment: MainAxisAlignment.center,
          //       children: [
          //         Icon(Icons.credit_card),
          //         SizedBox(
          //           width: 8,
          //         ),
          //         Text('Pay with Stripe'),
          //       ],
          //     ),
          //   ),
          // ),
          // const SizedBox(height: 12),
          InkWell(
            onTap: () {
              initiatePaypalPayment(
                context: context,
                ticketId: widget.ticketId,
                ticketCount: widget.unit,
              );
            },
            child: Container(
              width: 200,
              decoration: BoxDecoration(
                  color: Colors.yellow, borderRadius: BorderRadius.circular(8)),
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
    );
  }
}

ImageProvider _getImageProvider(String image) {
  if (image.startsWith('http')) {
    // If the image is a URL
    return NetworkImage(image);
  } else {
    try {
      // Try decoding the Base64 string
      final Uint8List decodedBytes = base64Decode(image);
      return MemoryImage(decodedBytes);
    } catch (e) {
      // Return a fallback image in case of error
      return const AssetImage('assets/images/fallback.png');
    }
  }
}
