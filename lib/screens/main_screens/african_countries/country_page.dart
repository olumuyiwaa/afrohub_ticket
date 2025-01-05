import 'dart:convert';
import 'dart:typed_data';

import 'package:afrohub/utilities/const.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart' as flutter_map;
import 'package:latlong2/latlong.dart';
import 'package:lottie/lottie.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../utilities/buttons/button_big.dart';
import '../../../api/api_get.dart';
import '../../../model/events.dart';
import '../../../utilities/widget/event_card.dart';
import '../event/event_page.dart';
import '../view_all.dart';

class CountryPage extends StatefulWidget {
  final String countryId;
  const CountryPage({super.key, required this.countryId});

  @override
  State<CountryPage> createState() => _CountryPageState();
}

class _CountryPageState extends State<CountryPage> {
  String countryTitle = "";
  String countryDescription = "";
  String countryPresident = "";
  String countryPopulation = "";
  String countryCapital = "";
  String countryCurrency = "";
  String countryImage = "";
  double? countryLatitude;
  double? countryLongitude;
  String countryDemonym = "";
  String countryLanguage = "";
  String countryTimeZone = "";
  String tutorialLink = "";
  String associationLeaderName = "";
  String associationLeaderEmail = "";
  String associationLeaderPhone = "";
  String associationLeaderPhoto = "";

  List<Event> events = [];
  List<Event> allEvents = [];

  Future<void> _fetchCountryDetails() async {
    try {
      final countryDetails = await getCountryDetails(widget.countryId);
      setState(() {
        countryTitle = countryDetails.title;
        countryDescription = countryDetails.description;
        countryPresident = countryDetails.president;
        countryPopulation = countryDetails.population;
        countryCapital = countryDetails.capital;
        countryCurrency = countryDetails.currency;
        countryImage = countryDetails.image;
        countryLatitude = countryDetails.latitude;
        countryLongitude = countryDetails.longitude;
        countryDemonym = countryDetails.demonym;
        countryLanguage = countryDetails.language;
        countryTimeZone = countryDetails.timeZone;
        tutorialLink = countryDetails.link;
        associationLeaderName = countryDetails.associationLeaderName;
        associationLeaderEmail = countryDetails.associationLeaderEmail;
        associationLeaderPhone = countryDetails.associationLeaderPhone;
        associationLeaderPhoto = countryDetails.associationLeaderPhoto;
      });
    } catch (error) {
      // Handle any errors
    }
  }

  /// Loads events and performs the search
  Future<void> _loadEvents() async {
    try {
      final fetchedEvents = await getFeaturedEvents();
      setState(() {
        allEvents = fetchedEvents.toList();
        _fetchEventsCategory();
      });
    } catch (e) {
      // Handle error if fetching events fails
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            backgroundColor: Colors.red,
            content: Text(
              'Failed to load events',
              textAlign: TextAlign.center,
            )),
      );
    }
  }

  /// Filters events based on the category
  void _fetchEventsCategory() {
    setState(() {
      events = allEvents
          .where((event) =>
              event.category.toLowerCase().contains(countryTitle.toLowerCase()))
          .toList();
    });
  }

  @override
  void initState() {
    super.initState();
    _fetchCountryDetails();
    _loadEvents();
    Future.delayed(const Duration(seconds: 1), () {
      setState(() {});
    });
  }

  // Function to launch Google Maps or Apple Maps
  Future<void> openMap() async {
    String googleMapsUrl =
        "https://www.google.com/maps/search/?api=1&query=$countryLatitude,$countryLongitude";

    String appleMapsUrl =
        "http://maps.apple.com/?ll=$countryLatitude,$countryLongitude";

    // Use canLaunchUrl and launchUrl to open the maps
    if (await canLaunchUrl(Uri.parse(appleMapsUrl))) {
      await launchUrl(Uri.parse(appleMapsUrl));
    } else if (await canLaunchUrl(Uri.parse(googleMapsUrl))) {
      await launchUrl(Uri.parse(googleMapsUrl));
    } else {
      throw "Could not open the map.";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: countryTitle.isEmpty
          ? Center(
              child: Lottie.asset(
                'assets/lottie/event_loading.json',
                fit: BoxFit.cover,
              ),
            )
          : NestedScrollView(
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
                        // Navigator.push(
                        //     context,
                        //     MaterialPageRoute(
                        //         builder: (BuildContext context) => const EditEvent()));
                      },
                      borderRadius: BorderRadius.circular(32),
                      child: Container(
                        margin: const EdgeInsets.all(8),
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
                    // InkWell(
                    //   onTap: () {
                    // Navigator.push(
                    //     context,
                    //     MaterialPageRoute(
                    //         builder: (BuildContext context) =>
                    //             CountryChat(
                    //                 countryID: 1,
                    //                 countryName: countryTitle,
                    //                 countryPicture:
                    //                     "https://www.bellegroveplantation.com/wp-content/uploads/2023/03/bigstock-Professional-Dslr-Camera-And-L-467472545-1024x683.jpg")));
                    //   },
                    //   borderRadius: BorderRadius.circular(8),
                    //   child: Container(
                    //     margin: const EdgeInsets.all(8),
                    //     padding: const EdgeInsets.all(8),
                    //     decoration: BoxDecoration(
                    //       color: Colors.white,
                    //       borderRadius: BorderRadius.circular(32),
                    //     ),
                    //     child: SvgPicture.asset(
                    //       'assets/svg/message.svg',
                    //       color: accentColor,
                    //     ),
                    //   ),
                    // ),
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
                        image: _getImageProvider(countryImage),
                        fit: BoxFit.cover, // Adjust the image fit
                      ),
                    ),
                    child: const SizedBox.shrink(),
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
                          countryTitle,
                          style: const TextStyle(
                              fontWeight: FontWeight.w700, fontSize: 20),
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        Row(
                          children: [
                            const Icon(
                              Icons.person,
                              size: 18,
                            ),
                            const SizedBox(
                              width: 4,
                            ),
                            Text(
                              countryPresident,
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 12,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(
                              width: 94,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    "Capital",
                                    style: TextStyle(
                                        fontWeight: FontWeight.w700,
                                        fontSize: 16),
                                  ),
                                  const SizedBox(
                                    height: 6,
                                  ),
                                  Text(countryCapital),
                                ],
                              ),
                            ),
                            SizedBox(
                                width: 94,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      "Currency",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w700,
                                          fontSize: 16),
                                    ),
                                    const SizedBox(
                                      height: 6,
                                    ),
                                    Text(countryCurrency),
                                  ],
                                )),
                            SizedBox(
                                width: 94,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      "Population",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w700,
                                          fontSize: 16),
                                    ),
                                    const SizedBox(
                                      height: 6,
                                    ),
                                    Text(countryPopulation),
                                  ],
                                )),
                          ],
                        ),
                        const SizedBox(
                          height: 12,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(
                                width: 94,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      "Demonym",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w700,
                                          fontSize: 16),
                                    ),
                                    const SizedBox(
                                      height: 6,
                                    ),
                                    Text(countryDemonym),
                                  ],
                                )),
                            SizedBox(
                                width: 94,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      "Language",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w700,
                                          fontSize: 16),
                                    ),
                                    const SizedBox(
                                      height: 6,
                                    ),
                                    Text(countryLanguage),
                                  ],
                                )),
                            SizedBox(
                                width: 94,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      "Time Zone",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w700,
                                          fontSize: 16),
                                    ),
                                    const SizedBox(
                                      height: 6,
                                    ),
                                    Text(countryTimeZone),
                                  ],
                                )),
                          ],
                        ),
                        const SizedBox(
                          height: 12,
                        ),
                        Text(
                          "About $countryTitle",
                          style: const TextStyle(
                              fontWeight: FontWeight.w700, fontSize: 16),
                        ),
                        const SizedBox(
                          height: 6,
                        ),
                        Text(countryDescription),
                        const SizedBox(
                          height: 32,
                        ),
                        Stack(
                          children: [
                            Container(
                              clipBehavior: Clip.hardEdge,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8)),
                              height: 280,
                              child: flutter_map.FlutterMap(
                                options: flutter_map.MapOptions(
                                    initialCenter: LatLng(countryLatitude!,
                                        countryLongitude!), // San Francisco
                                    initialZoom: 5.4),
                                children: [
                                  flutter_map.TileLayer(
                                    urlTemplate:
                                        "https://tile.openstreetmap.org/{z}/{x}/{y}.png",

                                    fallbackUrl:
                                        "https://cartodb-basemaps-{s}.global.ssl.fastly.net/light_all/{z}/{x}/{y}.png",
                                    subdomains: const ['a', 'b', 'c', 'd'],
                                    errorImage: const AssetImage(
                                        'assets/error_tile.png'), // Optional fallback image
                                  ),
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
                          height: 12,
                        ),
                        events.isEmpty
                            ? const SizedBox.shrink()
                            : Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "$countryTitle Themed Events",
                                        style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w700),
                                      ),
                                      TextButton(
                                          style: ButtonStyle(
                                            backgroundColor:
                                                MaterialStateProperty.all(
                                                    lightColor),
                                          ),
                                          onPressed: () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (BuildContext
                                                            context) =>
                                                        ViewAll(
                                                          title:
                                                              "$countryTitle Themed Events",
                                                          events: events,
                                                        )));
                                          },
                                          child: Text(
                                            "view All",
                                            style:
                                                TextStyle(color: accentColor),
                                          ))
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 8,
                                  ),
                                  SizedBox(
                                    height: 140,
                                    child: ListView.builder(
                                      itemCount:
                                          events.length < 5 ? events.length : 5,
                                      scrollDirection: Axis.horizontal,
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                        final event = events[index];
                                        return Container(
                                          width: 300,
                                          margin:
                                              const EdgeInsets.only(right: 16),
                                          child: InkWell(
                                              onTap: () {
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (BuildContext
                                                                context) =>
                                                            EventPage(
                                                              eventId: event.id,
                                                            )));
                                              },
                                              child: EventCard(
                                                title: event.title,
                                                image: event.image ?? "",
                                                location: event.location,
                                                date: event.date,
                                                price: event.price,
                                                category: event.category,
                                              )),
                                        );
                                      },
                                    ),
                                  ),
                                ],
                              ),
                        const SizedBox(
                          height: 64,
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
                            Expanded(
                                child: InkWell(
                              onTap: () {
                                launchUrl(Uri.parse(tutorialLink));
                              },
                              child: const ButtonBig(
                                isdark: false,
                                buttonText: "Learn Cuisines",
                                icon: Icon(
                                  Icons.dinner_dining_outlined,
                                  size: 20,
                                ),
                              ),
                            )),
                            const SizedBox(width: 8),
                            Expanded(
                                child: InkWell(
                              onTap: () {
                                showModalBottomSheet(
                                  context: context,
                                  shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.vertical(
                                        top: Radius.circular(16)),
                                  ),
                                  builder: (BuildContext context) {
                                    return Padding(
                                      padding: const EdgeInsets.all(24),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          const Text(
                                            "Association Leader",
                                            style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          const SizedBox(height: 12),
                                          Expanded(
                                              child: Container(
                                                  decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(8),
                                            color: greyColor, // Fallback color
                                            image: DecorationImage(
                                              image: _getImageProvider(
                                                  associationLeaderPhoto),
                                              fit: BoxFit
                                                  .cover, // Adjust the image fit
                                            ),
                                          ))),
                                          const SizedBox(height: 12),
                                          Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 8),
                                              child: Row(
                                                children: [
                                                  const SizedBox(
                                                      width: 54,
                                                      child: Text(
                                                        "Name:",
                                                        style: TextStyle(
                                                            fontSize: 14,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w500),
                                                      )),
                                                  const SizedBox(
                                                    width: 8,
                                                  ),
                                                  Text(associationLeaderName)
                                                ],
                                              )),
                                          Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 8),
                                              child: Row(
                                                children: [
                                                  const SizedBox(
                                                      width: 54,
                                                      child: Text(
                                                        "Email:",
                                                        style: TextStyle(
                                                            fontSize: 14,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w500),
                                                      )),
                                                  const SizedBox(
                                                    width: 8,
                                                  ),
                                                  Text(associationLeaderEmail)
                                                ],
                                              )),
                                          Padding(
                                              padding:
                                                  const EdgeInsets.only(top: 8),
                                              child: Row(
                                                children: [
                                                  const SizedBox(
                                                      width: 54,
                                                      child: Text(
                                                        "Phone:",
                                                        style: TextStyle(
                                                            fontSize: 14,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w500),
                                                      )),
                                                  const SizedBox(
                                                    width: 12,
                                                  ),
                                                  Text(associationLeaderPhone)
                                                ],
                                              )),
                                          const SizedBox(height: 16),
                                          InkWell(
                                              onTap: () {
                                                Navigator.pop(
                                                    context); // Close the modal
                                              },
                                              child: const ButtonBig(
                                                buttonText: "Close",
                                              )),
                                        ],
                                      ),
                                    );
                                  },
                                );
                              },
                              child: const ButtonBig(
                                buttonText: "Association Leader",
                                icon: Icon(
                                  Icons.contact_mail,
                                  size: 20,
                                  color: Colors.white,
                                ),
                              ),
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
