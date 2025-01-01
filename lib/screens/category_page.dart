import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../api/api_get.dart';
import '../../model/events.dart';
import '../../utilities/buttons/notification_button.dart';
import '../../utilities/const.dart';
import '../../utilities/widget/event_card_2.dart';
import 'main_screens/event/event_page.dart';

class CategoryPage extends StatefulWidget {
  final String title;
  const CategoryPage({super.key, required this.title});

  @override
  State<CategoryPage> createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  List<Event> events = [];
  List<Event> allEvents = [];

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
        const SnackBar(content: Text('Failed to load events')),
      );
    }
  }

  /// Filters events based on the category
  void _fetchEventsCategory() {
    setState(() {
      events = allEvents
          .where((event) =>
              event.category.toLowerCase().contains(widget.title.toLowerCase()))
          .toList();
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
      appBar: AppBar(
        actions: const [
          NotificationButton(),
          SizedBox(
            width: 8,
          )
        ],
        title: Text(
          widget.title[0].toUpperCase() + widget.title.substring(1),
          style: const TextStyle(fontSize: 18),
        ),
      ),
      body: events.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgPicture.asset(
                    'assets/svg/ticket.svg',
                    width: 180,
                    color: greyColor,
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                  Text(
                    'No Event Found In ${widget.title}',
                    style: TextStyle(color: greyColor, fontSize: 20),
                  ),
                ],
              ),
            )
          : GridView.builder(
              padding: const EdgeInsets.all(12),
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: events.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, // Number of columns
                crossAxisSpacing: 8.0, // Spacing between columns
                mainAxisSpacing: 8.0, // Spacing between rows
                childAspectRatio: 0.74, // Adjust based on desired card height
              ),
              itemBuilder: (context, index) {
                final event = events[index];
                return InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (BuildContext context) => EventPage(
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
            ),
    );
  }
}
