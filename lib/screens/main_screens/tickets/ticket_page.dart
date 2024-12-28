import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../../../utilities/const.dart';

class TicketPage extends StatelessWidget {
  TicketPage({super.key});

  final Map<dynamic, dynamic> ticket = {
    "title": "Concert in the Park",
    "image":
        "https://www.bellegroveplantation.com/wp-content/uploads/2023/03/bigstock-Professional-Dslr-Camera-And-L-467472545-1024x683.jpg",
    "date": "24/12/2024",
    "time": "16:00",
    "location": "Tallinn",
    "category": "Party",
    "address": "123 Main Street, Tallinn, Estonia",
    "latitude": 59.4370,
    "longitude": 24.7536,
    "price": 25.00,
    "organizer": "beauty look",
    "description":
        "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book.",
    "unit": 3,
    "organizerPhoto":
        "https://media.licdn.com/dms/image/v2/D4D03AQHT47BuaMJRTg/profile-displayphoto-shrink_400_400/profile-displayphoto-shrink_400_400/0/1713186951164?e=1739404800&v=beta&t=Yw8rKZ6jIeB8tfEyFbWM4PdNGnd6N_lcpyzwVL6D2NQ",
    "QRCodeLink": "https://www.bellegroveplantation.com",
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
                onTap: () {},
                borderRadius: BorderRadius.circular(8),
                child: Container(
                  margin: const EdgeInsets.all(8),
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(32),
                  ),
                  child: SvgPicture.asset(
                    'assets/svg/download.svg',
                    color: greyColor,
                  ),
                ),
              ),
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
                    ticket["image"],
                  ),
                  fit: BoxFit.cover, // Adjust the image fit
                ),
              ),
              child:
                  const SizedBox.shrink(), // Keeps the container content empty
            )),
          )
        ],
        body: ListView(children: [
          Container(
            margin: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 8,
                  spreadRadius: 1,
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Event Title
                      Text(
                        ticket["title"],
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
                                style:
                                    TextStyle(fontSize: 12, color: Colors.grey),
                              ),
                              Text(
                                ticket["category"],
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
                                style:
                                    TextStyle(fontSize: 12, color: Colors.grey),
                              ),
                              Text(
                                ticket["date"],
                                style: const TextStyle(
                                    fontSize: 14, fontWeight: FontWeight.bold),
                              ),
                            ],
                          )
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "Location",
                                style:
                                    TextStyle(fontSize: 12, color: Colors.grey),
                              ),
                              Text(
                                ticket["location"],
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
                                style:
                                    TextStyle(fontSize: 12, color: Colors.grey),
                              ),
                              Text(
                                "\$ ${ticket["price"]}",
                                style: const TextStyle(
                                    fontSize: 14, fontWeight: FontWeight.bold),
                              ),
                            ],
                          )
                        ],
                      ),
                      const SizedBox(height: 12),

                      // Organizer
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 16,
                            backgroundImage: NetworkImage(
                              ticket["organizerPhoto"], // Organizer image
                            ),
                          ),
                          const SizedBox(width: 8),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                ticket["organizer"],
                                style: const TextStyle(
                                    fontSize: 14, fontWeight: FontWeight.bold),
                              ),
                              const Text(
                                'Organizer',
                                style:
                                    TextStyle(fontSize: 12, color: Colors.grey),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          const Text(
                            "Ticket Admits:",
                            style: TextStyle(fontSize: 18, color: Colors.grey),
                          ),
                          const SizedBox(
                            width: 8,
                          ),
                          Text(
                            ticket["unit"].toString(),
                            style: const TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          )
                        ],
                      ),
                    ],
                  ),
                ),

                // QR Code Section
                Center(
                  child: QrImageView(
                    data: ticket["QRCodeLink"], // Add ticket-specific QR data
                    version: QrVersions.auto,
                    size: 360,
                  ),
                ),
                const SizedBox(height: 16),
              ],
            ),
          )
        ]),
      ),
    );
  }
}
