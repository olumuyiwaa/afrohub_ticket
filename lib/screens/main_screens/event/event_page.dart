import 'package:afrohub/screens/main_screens/event/event_chat.dart';
import 'package:afrohub/utilities/const.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:latlong2/latlong.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../utilities/buttons/button_big.dart';
import '../../../utilities/widget/upcoming_events.dart';
import 'payment_screen.dart';

class EventPage extends StatefulWidget {
  final int eventId;
  const EventPage({super.key, required this.eventId});

  @override
  State<EventPage> createState() => _EventPageState();
}

class _EventPageState extends State<EventPage> {
  int count = 0;

  void subtract() {
    setState(() {
      if (count > 0) {
        --count;
      }
    });
  }

  void add() {
    setState(() {
      if (count < (event["stockLeft"] > 10 ? 10 : event["stockLeft"])) {
        ++count;
      }
    });
  }

  // Function to launch Google Maps or Apple Maps
  Future<void> openMap() async {
    String googleMapsUrl =
        "https://www.google.com/maps/search/?api=1&query=${event["latitude"]},${event["longitude"]}";

    String appleMapsUrl =
        "http://maps.apple.com/?ll=${event["latitude"]},${event["longitude"]}";

    // Use canLaunchUrl and launchUrl to open the maps
    if (await canLaunchUrl(Uri.parse(appleMapsUrl))) {
      await launchUrl(Uri.parse(appleMapsUrl));
    } else if (await canLaunchUrl(Uri.parse(googleMapsUrl))) {
      await launchUrl(Uri.parse(googleMapsUrl));
    } else {
      throw "Could not open the map.";
    }
  }

  final Map<dynamic, dynamic> event = {
    "title": "Concert in the Park",
    "image":
        "https://www.bellegroveplantation.com/wp-content/uploads/2023/03/bigstock-Professional-Dslr-Camera-And-L-467472545-1024x683.jpg",
    "date": "24/12/2024",
    "time": "16:00",
    "location": "Tallinn",
    "address": "123 Main Street, Tallinn, Estonia",
    "latitude": 59.4370,
    "longitude": 24.7536,
    "price": 25.00,
    "description":
        "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book.",
    "stockLeft": 100,
    "isBookmarked": false
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
                borderRadius: BorderRadius.circular(8),
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(32),
                  ),
                  child: SvgPicture.asset(
                    'assets/svg/hearth.svg',
                    color: false ? accentColor : greyColor,
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
              child:
                  const SizedBox.shrink(), // Keeps the container content empty
            )),
          )
        ],
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Stack(
            children: [
              ListView(
                children: [
                  Text(
                    "${event["date"]} ${event["time"]}",
                  ),
                  const SizedBox(
                    height: 6,
                  ),
                  Text(
                    event["title"],
                    style: const TextStyle(
                        fontWeight: FontWeight.w700, fontSize: 20),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  Row(
                    children: [
                      const Icon(
                        Icons.location_on,
                        size: 18,
                      ),
                      const SizedBox(
                        width: 4,
                      ),
                      Text(
                        event["location"],
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  Container(
                    padding: const EdgeInsets.all(12),
                    margin: const EdgeInsets.symmetric(horizontal: 8),
                    height: 52,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: lightAccent),
                    child: Row(
                      children: [
                        SvgPicture.asset('assets/svg/ticket2.svg'),
                        const SizedBox(
                          width: 8,
                        ),
                        const Text(
                          "Ticket Price",
                          style: TextStyle(fontWeight: FontWeight.w500),
                        ),
                        const Spacer(),
                        Text(
                          "\$ ${event["price"]}",
                          style: const TextStyle(
                              fontWeight: FontWeight.w500, fontSize: 18),
                        )
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  const Text(
                    "Description",
                    style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
                  ),
                  const SizedBox(
                    height: 6,
                  ),
                  Text(event["description"]),
                  const SizedBox(
                    height: 32,
                  ),
                  Stack(
                    children: [
                      Container(
                        clipBehavior: Clip.hardEdge,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8)),
                        height: 220,
                        child: FlutterMap(
                          options: MapOptions(
                              initialCenter: LatLng(event["latitude"],
                                  event["longitude"]), // San Francisco
                              initialZoom: 14.2),
                          children: [
                            TileLayer(
                              urlTemplate:
                                  "https://tile.openstreetmap.org/{z}/{x}/{y}.png",

                              fallbackUrl:
                                  "https://cartodb-basemaps-{s}.global.ssl.fastly.net/light_all/{z}/{x}/{y}.png",
                              subdomains: const ['a', 'b', 'c', 'd'],
                              errorImage: const AssetImage(
                                  'assets/error_tile.png'), // Optional fallback image
                            ),
                            MarkerLayer(
                              markers: [
                                Marker(
                                  width: 80.0,
                                  height: 80.0,
                                  point: LatLng(
                                      event["latitude"], event["longitude"]),
                                  child: const Icon(
                                    Icons.location_pin,
                                    color: Colors.red,
                                    size: 40.0,
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                      Positioned(
                          bottom: 10,
                          left: 4,
                          child: InkWell(
                            onTap: openMap,
                            child: Container(
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  border: Border.all(
                                      width: 1.2, color: accentColor),
                                  borderRadius: BorderRadius.circular(8)),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 6),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.map,
                                    color: accentColor,
                                    size: 18,
                                  ),
                                  const SizedBox(
                                    width: 8,
                                  ),
                                  Text(
                                    "View on Map",
                                    style: TextStyle(
                                        color: accentColor,
                                        fontWeight: FontWeight.w500),
                                  ),
                                ],
                              ),
                            ),
                          ))
                    ],
                  ),
                  const SizedBox(
                    height: 24,
                  ),
                  UpcomingEvents(),
                  const SizedBox(
                    height: 92,
                  )
                ],
              ),
              Positioned(
                bottom: 12,
                left: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8)),
                  child: Row(
                    children: [
                      InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                      const EventChat(
                                          eventID: 1,
                                          eventName: "Event Name",
                                          eventPicture:
                                              "https://www.bellegroveplantation.com/wp-content/uploads/2023/03/bigstock-Professional-Dslr-Camera-And-L-467472545-1024x683.jpg")));
                        },
                        borderRadius: BorderRadius.circular(8),
                        child: Container(
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: const Color(0XFFC2CFD6),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: SvgPicture.asset(
                            'assets/svg/message.svg',
                            color: accentColor,
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 8,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          GestureDetector(
                            onTap: subtract,
                            child: Container(
                              alignment: Alignment.center,
                              height: 52,
                              width: 52,
                              decoration: BoxDecoration(
                                color: const Color(0XFFC2CFD6),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Text(
                                '-',
                                style: TextStyle(
                                    fontSize: 20, color: Colors.black),
                              ),
                            ),
                          ),
                          Container(
                            alignment: Alignment.center,
                            width: 28,
                            child: Text(count.toString(),
                                style: const TextStyle(
                                  fontSize: 14,
                                )),
                          ),
                          GestureDetector(
                            onTap: add,
                            child: Container(
                              alignment: Alignment.center,
                              height: 52,
                              width: 52,
                              decoration: BoxDecoration(
                                color: const Color(0XFFC2CFD6),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Text(
                                '+',
                                style: TextStyle(
                                    fontSize: 20, color: Colors.black),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                          child: InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                      const PaymentScreen()));
                        },
                        child: const ButtonBig(buttonText: "Buy Ticket"),
                      )),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
