import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../utilities/const.dart';
import '../event/event_chat.dart';
import 'edit_event.dart';

class EventDetails extends StatelessWidget {
  final int eventID;
  EventDetails({super.key, required this.eventID});

  final Map<dynamic, dynamic> event = {
    "title": "Concert in the Park",
    "image":
        "https://www.bellegroveplantation.com/wp-content/uploads/2023/03/bigstock-Professional-Dslr-Camera-And-L-467472545-1024x683.jpg",
    "date": "24/12/2024",
    "time": "16:00",
    "location": "Tallinn",
    "category": "Photography",
    "address": "123 Main Street, Tallinn, Estonia",
    "latitude": 59.4370,
    "longitude": 24.7536,
    "price": 25.00,
    "description":
        "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book.",
    "stockLeft": 100,
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
          actions: [
            InkWell(
              onTap: () {},
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
                        builder: (BuildContext context) => const EditEvent()));
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
                image: NetworkImage(
                  event["image"],
                ),
                fit: BoxFit.cover, // Adjust the image fit
              ),
            ),
            child: const SizedBox.shrink(), // Keeps the container content empty
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
                            builder: (BuildContext context) => const EventChat(
                                eventID: 1,
                                eventName: "Event Name",
                                eventPicture:
                                    "https://www.bellegroveplantation.com/wp-content/uploads/2023/03/bigstock-Professional-Dslr-Camera-And-L-467472545-1024x683.jpg")));
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
            event["title"],
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 10),
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
                    event["category"],
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
                    event["date"],
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
                    event["location"],
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
                    "\$ ${event["price"]}",
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
                    "Total Tickets Sold",
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                  Text(
                    event["totalTicketsSold"].toString(),
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
                    "\$ ${(event["price"] * event["totalTicketsSold"]).toStringAsFixed(2)}",
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
                      "\$${(event["price"] * buyer["unit"]).toStringAsFixed(2)}"),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
