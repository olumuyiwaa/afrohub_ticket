import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../api/api_delete.dart';
import '../../../api/api_get.dart';
import '../../../utilities/const.dart';
import '../event/event_chat.dart';
import 'edit_event.dart';

class EventDetails extends StatefulWidget {
  final String eventID;
  const EventDetails({super.key, required this.eventID});

  @override
  State<EventDetails> createState() => _EventDetailsState();
}

class _EventDetailsState extends State<EventDetails> {
  String eventTitle = "";
  String eventID = "";

  String eventDescription = "";

  String eventLocation = "";

  String eventAddress = "";

  String eventImage = "";

  String eventDate = "";
  String eventTime = "";

  int eventStockLeft = 0;

  String eventPrice = "";

  String eventCategory = "";

  bool isBookmarked = false;

  @override
  void initState() {
    super.initState();
    // Fetch posts and members when the widget is initialized
    _fetchEventDetails();
    // Reload the page after 1 seconds
    Future.delayed(const Duration(seconds: 1), () {
      setState(() {});
    });
  }

  Future<void> showDeleteDialog(BuildContext context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete'),
          content: const Text('Are you sure you want to delete this event?'),
          actions: <Widget>[
            TextButton(
              child: const Text(
                'Cancel',
                style: TextStyle(color: Colors.green),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Delete', style: TextStyle(color: Colors.red)),
              onPressed: () {
                removeEvent(
                  context: context,
                  eventID: eventID,
                );
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _fetchEventDetails() async {
    try {
      final eventDetails = await getEventDetails(widget.eventID);
      setState(() {
        eventID = eventDetails.id;
        eventTitle = eventDetails.title;
        eventDescription = eventDetails.description;
        eventLocation = eventDetails.location;
        eventAddress = eventDetails.address;
        eventImage = eventDetails.image ?? "";
        eventDate = eventDetails.date;
        eventStockLeft = eventDetails.unit;
        eventTime = eventDetails.time;

        eventPrice =
            (eventDetails.price == "free" || eventDetails.price == "Free")
                ? "0"
                : eventDetails.price;
        eventCategory = eventDetails.category;
      });
    } catch (error) {
      // Handle any errors
    }
  }

  final Map<dynamic, dynamic> event = {
    "totalTicketsSold": 120,
    "buyerDetails": [
      {
        "name": "Oladoyin Emmanuel",
        "unit": 2,
      },
      {
        "name": "Oladoyin Emmanuel",
        "unit": 2,
      },
      {
        "name": "Emmanuel Oladoyin",
        "unit": 5,
      },
    ]
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: NestedScrollView(
      headerSliverBuilder: (context, innerBoxIsScrolled) => [
        SliverAppBar(
          leading: InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            borderRadius: BorderRadius.circular(8),
            child: Container(
              margin: const EdgeInsets.all(8),
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(32),
              ),
              child: Icon(
                Icons.arrow_back_ios_new,
                color: greyColor,
              ),
            ),
          ),
          actions: [
            InkWell(
              onTap: () {
                showDeleteDialog(context);
              },
              borderRadius: BorderRadius.circular(32),
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(32),
                ),
                child: const Icon(
                  Icons.delete,
                  color: Colors.red,
                ),
              ),
            ),
            const SizedBox(
              width: 16,
            ),
            InkWell(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) => EditEvent(
                              title: eventTitle,
                              location: eventLocation,
                              description: eventDescription,
                              date: eventDate,
                              time: eventTime,
                              price: eventPrice,
                              address: eventAddress,
                              image: eventImage,
                            )));
              },
              borderRadius: BorderRadius.circular(32),
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(32),
                ),
                child: Icon(
                  Icons.edit,
                  color: accentColor,
                ),
              ),
            ),
            const SizedBox(
              width: 16,
            )
          ],
          expandedHeight: 320,
          floating: false,
          pinned: true,
          flexibleSpace: FlexibleSpaceBar(
              background: Container(
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: greyColor, // Fallback color
              image: DecorationImage(
                image: _getImageProvider(eventImage), // Dynamic image provider
                fit: BoxFit.cover, // Adjust the image fit
              ),
            ),
            child: const SizedBox.shrink(),
          )),
        )
      ],
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTicketInfoCard(),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'View Event Discuss >>',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
                InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (BuildContext context) => EventChat(
                                eventID: "eventID",
                                eventName: eventTitle,
                                eventPicture: eventImage)));
                  },
                  borderRadius: BorderRadius.circular(8),
                  child: Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: SvgPicture.asset(
                      'assets/svg/message.svg',
                      color: accentColor,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 12,
            ),
            _buildSalesBreakdownCard(),
          ],
        ),
      ),
    ));
  }

  Widget _buildTicketInfoCard() {
    return Container(
      width: double.maxFinite,
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(8)),
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            eventTitle,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Address",
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),
              Text(
                eventAddress,
                style:
                    const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(
            height: 5,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Description",
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),
              Text(
                eventDescription,
                style:
                    const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(
            height: 5,
          ),
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
                    eventCategory,
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
                    eventDate,
                    style: const TextStyle(
                        fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                ],
              )
            ],
          ),
          const SizedBox(height: 5),
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
                    eventLocation,
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
                    "\$ $eventPrice",
                    style: const TextStyle(
                        fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                ],
              )
            ],
          ),
          const SizedBox(height: 5),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Total Sold / Remaining",
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                  Text(
                    "${event["totalTicketsSold"]} / $eventStockLeft",
                    style: const TextStyle(
                        fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  const Text(
                    "Revenue:",
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                  Text(
                    "\$ ${(double.tryParse(eventPrice) ?? 0.0 * event["totalTicketsSold"]).toStringAsFixed(2)}",
                    style: const TextStyle(
                        fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                ],
              )
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSalesBreakdownCard() {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Buyer Breakdown",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: ListView.builder(
              itemCount: event["buyerDetails"].length,
              itemBuilder: (context, index) {
                final buyer = event["buyerDetails"][index];
                return ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Colors.blue,
                    child: Text(
                      buyer["name"][0].toUpperCase(),
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                  title: Text(buyer["name"]),
                  subtitle: Text("Tickets Bought: ${buyer["unit"]}"),
                  trailing: Text(
                      "\$${(double.tryParse(eventPrice) ?? 0.0 * buyer["unit"]).toStringAsFixed(2)}"),
                );
              },
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
