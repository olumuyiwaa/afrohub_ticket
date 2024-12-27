import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lottie/lottie.dart';

import '../const.dart';

class EventCard extends StatelessWidget {
  final String image;
  final String title;
  final String location;
  final String date;
  final String? category;
  final String? unit;
  final String price;

  const EventCard(
      {super.key,
      required this.image,
      required this.title,
      required this.location,
      required this.date,
      this.category,
      required this.price,
      this.unit});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 140,
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(8)),
      padding: const EdgeInsets.all(8),
      child: Row(
        children: [
          Container(
            height: double.maxFinite,
            clipBehavior: Clip.hardEdge,
            width: 124,
            decoration: BoxDecoration(
              color: Colors.grey,
              borderRadius: BorderRadius.circular(4),
            ),
            child: CachedNetworkImage(
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
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 4),
              Text(
                maxLines: 1,
                title,
                style: const TextStyle(
                    fontSize: 14,
                    overflow: TextOverflow.ellipsis,
                    fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  SvgPicture.asset(
                    'assets/svg/Location.svg',
                    color: greyColor,
                    width: 18,
                  ),
                  const SizedBox(
                    width: 4,
                  ),
                  Expanded(
                      child: Text(
                    location,
                    maxLines: 1,
                    style: const TextStyle(
                      fontSize: 12,
                      overflow: TextOverflow.ellipsis,
                    ),
                  )),
                ],
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  SvgPicture.asset(
                    'assets/svg/calender.svg',
                    color: greyColor,
                    width: 18,
                  ),
                  const SizedBox(
                    width: 4,
                  ),
                  Text(
                    date,
                    style: const TextStyle(fontSize: 12),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              category != null
                  ? Row(
                      children: [
                        Icon(
                          Icons.category_rounded,
                          size: 18,
                          color: greyColor,
                        ),
                        const SizedBox(
                          width: 4,
                        ),
                        Text(
                          category!,
                          style: const TextStyle(fontSize: 12),
                        ),
                      ],
                    )
                  : const SizedBox.shrink(),
              const Spacer(),
              Row(
                children: [
                  unit != null
                      ? Text(
                          "Ticket: $unit",
                          style: const TextStyle(
                              fontSize: 14, fontWeight: FontWeight.w500),
                        )
                      : const SizedBox.shrink(),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6),
                    height: 24,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4),
                        color: lightAccent),
                    child: Center(
                      child: Text(
                        "\$ ${price == '0' ? 'Free' : price}",
                        style: TextStyle(color: accentColor),
                      ),
                    ),
                  )
                ],
              )
            ],
          )),
        ],
      ),
    );
  }
}
