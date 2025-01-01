import 'dart:convert';
import 'dart:typed_data';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../const.dart';

class EventCard2 extends StatelessWidget {
  final String title;
  final String image;
  final String location;
  final String date;
  final String price;
  final String category;

  const EventCard2({
    super.key,
    required this.title,
    required this.image,
    required this.location,
    required this.date,
    required this.price,
    required this.category,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          clipBehavior: Clip.hardEdge,
          height: 152,
          width: double.maxFinite,
          decoration: BoxDecoration(
            color: Colors.grey,
            borderRadius: BorderRadius.circular(4),
          ),
          child: _buildImage(),
        ),
        const SizedBox(height: 8),
        Text(
          title,
          maxLines: 1,
          style: const TextStyle(
            fontSize: 14,
            overflow: TextOverflow.ellipsis,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                location,
                maxLines: 1,
                style: const TextStyle(
                  fontSize: 12,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
            Text(
              date,
              maxLines: 1,
              style: const TextStyle(
                fontSize: 12,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "\$ $price",
              style: const TextStyle(fontSize: 12),
            ),
            Row(
              children: [
                Icon(
                  Icons.theater_comedy_sharp,
                  size: 18,
                  color: greyColor,
                ),
                const SizedBox(width: 4),
                Text(
                  category,
                  style: const TextStyle(fontSize: 12),
                ),
              ],
            )
          ],
        ),
      ],
    );
  }

  Widget _buildImage() {
    // Check if the image is a URL or a Base64 string
    if (image.startsWith('http')) {
      return CachedNetworkImage(
        imageUrl: image,
        placeholder: (context, url) => Lottie.asset(
          'assets/lottie/image.json',
          fit: BoxFit.cover,
        ),
        errorWidget: (context, url, error) => const Icon(
          Icons.photo,
          size: 32,
        ),
        fit: BoxFit.cover,
      );
    } else {
      try {
        final Uint8List decodedBytes = base64Decode(image);
        return Image.memory(
          decodedBytes,
          fit: BoxFit.cover,
        );
      } catch (e) {
        return const Icon(
          Icons.photo,
          size: 32,
        );
      }
    }
  }
}
