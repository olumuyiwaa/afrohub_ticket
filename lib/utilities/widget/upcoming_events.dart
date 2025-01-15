import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../../api/api_get.dart';
import '../../model/class_events.dart';
import '../../screens/main_screens/event/event_page.dart';
import '../../screens/main_screens/view_all.dart';
import '../const.dart';
import 'event_card.dart';

class UpcomingEvents extends StatefulWidget {
  const UpcomingEvents({super.key});

  @override
  State<UpcomingEvents> createState() => _UpcomingEventsState();
}

class _UpcomingEventsState extends State<UpcomingEvents> {
  List<Event> _events = [];

  bool _isLoading = true;

  Future<void> _loadEvents() async {
    setState(() {
      _isLoading = true;
    });
    try {
      final fetchedEvents = await getFeaturedEvents();
      setState(() {
        _events = fetchedEvents.toList();
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _loadEvents();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              "Upcoming Events",
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
                                title: "Upcoming Events",
                                events: _events,
                              )));
                },
                child: Text(
                  "view All",
                  style: TextStyle(color: accentColor),
                ))
          ],
        ),
        const SizedBox(
          height: 8,
        ),
        SizedBox(
          height: 140,
          child: _isLoading
              ? Center(
                  child: Lottie.asset(
                  'assets/lottie/loading.json',
                  fit: BoxFit.cover,
                ))
              : _events.isEmpty
                  ? const Center(
                      child: Text('No Event Available'),
                    )
                  : ListView.builder(
                      itemCount: _events.length < 5 ? _events.length : 5,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (BuildContext context, int index) {
                        final event = _events[index];
                        return Container(
                          width: 300,
                          margin: const EdgeInsets.only(right: 16),
                          child: InkWell(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (BuildContext context) =>
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
    );
  }
}
