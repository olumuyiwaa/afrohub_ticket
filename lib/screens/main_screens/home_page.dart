import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../api/api_get.dart';
import '../../model/events.dart';
import '../../utilities/buttons/button_big.dart';
import '../../utilities/buttons/notification_button.dart';
import '../../utilities/const.dart';
import '../../utilities/search.dart';
import '../../utilities/widget/event_card_2.dart';
import '../../utilities/widget/upcoming_events.dart';
import 'category_page.dart';
import 'event/event_page.dart';
import 'event_management/create_event.dart';
import 'filter.dart';
import 'search_result.dart';
import 'view_all.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<List<Event>> featuredEvents;
  String? username;

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
    getUserInfo();
  }

  Future<void> getUserInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? fetchedName = prefs.getString('full_name');
    setState(() {
      username = fetchedName;
    });
  }

  final List<String> categories = [
    "swimming",
    "game",
    "football",
    "comedy",
    "concert",
    "trophy",
    "tour",
    "festival",
    "study",
    "party",
    "olympic",
    "culture"
  ];

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    Text(
                      'Welcome Back!',
                    ),
                    SizedBox(
                      width: 4,
                    ),
                    Icon(
                      Icons.waving_hand,
                      color: Colors.orangeAccent,
                      size: 16,
                    ),
                  ],
                ),
                Text(
                  username ?? 'Loading...',
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.w500),
                ),
              ],
            ),
            const NotificationButton()
          ],
        ),
        const SizedBox(
          height: 40,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
                child: Search(
              hintText: 'Search for ticket...',
              onSubmitted: (query) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (BuildContext context) => SearchResult(
                      text: query,
                    ),
                  ),
                );
              },
            )),
            const SizedBox(
              width: 16,
            ),
            InkWell(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) => Filter(
                              events: _events,
                            )));
              },
              borderRadius: BorderRadius.circular(8),
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.filter_alt,
                  color: accentColor,
                ),
              ),
            )
          ],
        ),
        const SizedBox(
          height: 20,
        ),
        InkWell(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (BuildContext context) => const CreateEvent()));
            },
            child: const ButtonBig(
              buttonText: 'Create New Event',
              isGradient: true,
            )),
        const SizedBox(
          height: 12,
        ),
        const UpcomingEvents(),
        const SizedBox(
          height: 16,
        ),
        const Text(
          "View By Category",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
        ),
        const SizedBox(
          height: 12,
        ),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 8,
            mainAxisSpacing: 8,
            mainAxisExtent: 36,
          ),
          itemCount: categories.length,
          itemBuilder: (context, index) {
            final category = categories[index];

            return InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (BuildContext context) => CategoryPage(
                                title: category,
                              )));
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: accentColor,
                      width: 2,
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        "assets/img/$category.png", // Corrected asset path
                        width: 20,
                      ),
                      const SizedBox(
                        width: 4,
                      ),
                      Text(
                        category[0].toUpperCase() +
                            category.substring(1), // Correct capitalization
                        style: TextStyle(
                          fontSize: 13,
                          color: accentColor,
                          fontWeight: FontWeight.w500,
                        ),
                      )
                    ],
                  ),
                ));
          },
        ),
        const SizedBox(
          height: 16,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Featured Events",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                ),
                TextButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(lightColor),
                  ),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (BuildContext context) => ViewAll(
                                  title: "Featured Events",
                                  events: _events,
                                )));
                  },
                  child: Text(
                    "View All",
                    style: TextStyle(color: accentColor),
                  ),
                )
              ],
            ),
            const SizedBox(
              height: 8,
            ),
            _events.isEmpty
                ? Center(
                    child: Lottie.asset(
                      'assets/lottie/loading.json',
                      fit: BoxFit.cover,
                    ),
                  )
                : GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: _events.length < 10 ? _events.length : 10,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2, // Number of columns
                      crossAxisSpacing: 8.0, // Spacing between columns
                      mainAxisSpacing: 8.0, // Spacing between rows
                      childAspectRatio:
                          0.74, // Adjust based on desired card height
                    ),
                    itemBuilder: (context, index) {
                      final event = _events[index];
                      return InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                        EventPage(
                                          eventId: event.id,
                                        )));
                          },
                          child: EventCard2(
                            title: event.title,
                            image: event.image ?? "",
                            location: event.location,
                            date: event.date,
                            price: event.price,
                            category: event.category,
                          ));
                    },
                  )
          ],
        )
      ],
    );
  }
}
