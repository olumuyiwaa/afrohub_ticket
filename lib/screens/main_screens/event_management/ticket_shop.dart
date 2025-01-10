import 'dart:convert';
import 'dart:typed_data';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../../../api/api_get.dart';
import '../../../model/class_events.dart';
import '../../../utilities/buttons/button_big.dart';
import '../../../utilities/const.dart';
import 'create_event.dart';
import 'event_details.dart';

class TicketShop extends StatefulWidget {
  const TicketShop({super.key});

  @override
  State<TicketShop> createState() => _TicketShopState();
}

class _TicketShopState extends State<TicketShop> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  List<Event> _events = [];

  Future<void> _loadEvents() async {
    final fetchedEvents = await getFeaturedEvents();
    setState(() {
      _events = fetchedEvents.toList();
    });
  }

  @override
  void initState() {
    super.initState();
    _loadEvents();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(24),
            children: [
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Your Hub For Ticket Sales',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.w700),
                  ),
                  SizedBox(
                    height: 12,
                  ),
                  Text(
                    "Seamless Ticketing, Simplified Management..",
                    style: TextStyle(fontSize: 16),
                  ),
                ],
              ),
              const SizedBox(
                height: 24,
              ),
              InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (BuildContext context) =>
                                const CreateEvent()));
                  },
                  child: const ButtonBig(
                    buttonText: 'Create New Event',
                    isGradient: true,
                  )),
              const SizedBox(
                height: 16,
              ),
              const Text(
                "Your Posted Events",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 16),
                child: _events.isEmpty
                    ? Center(
                        child: Lottie.asset(
                          'assets/lottie/loading.json',
                          fit: BoxFit.cover,
                        ),
                      )
                    : GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: _events.length,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2, // Number of columns
                          crossAxisSpacing: 8.0, // Spacing between columns
                          mainAxisSpacing: 8.0, // Spacing between rows
                          childAspectRatio:
                              0.74, // Adjust based on desired card height
                        ),
                        itemBuilder: (context, index) {
                          return InkWell(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (BuildContext context) =>
                                            EventDetails(
                                              eventID: _events[index].id,
                                            )));
                              },
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    clipBehavior: Clip.hardEdge,
                                    height: 152,
                                    width: 240,
                                    decoration: BoxDecoration(
                                      color: Colors.grey,
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child:
                                        _buildImage("${_events[index].image}"),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    maxLines: 1,
                                    _events[index].title,
                                    style: const TextStyle(
                                        fontSize: 14,
                                        overflow: TextOverflow.ellipsis,
                                        fontWeight: FontWeight.w500),
                                  ),
                                  const SizedBox(height: 8),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                          child: Text(
                                        _events[index].location,
                                        maxLines: 1,
                                        style: const TextStyle(
                                          fontSize: 12,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      )),
                                      Text(
                                        _events[index].date,
                                        style: const TextStyle(fontSize: 12),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 8,
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "\$ ${_events[index].price}",
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
                                            _events[index].category,
                                            style:
                                                const TextStyle(fontSize: 12),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              ));
                        },
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImage(String imageUrl) {
    // Check if the image is a URL or a Base64 string
    if (imageUrl.startsWith('http')) {
      return CachedNetworkImage(
        imageUrl: imageUrl,
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
        final Uint8List decodedBytes = base64Decode(imageUrl);
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
