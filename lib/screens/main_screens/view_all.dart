import 'package:flutter/material.dart';

import '../../utilities/buttons/notification_button.dart';
import '../../utilities/widget/event_card.dart';
import 'event/event_page.dart';

class ViewAll extends StatelessWidget {
  final String title;
  final List<Map<String, dynamic>> events;
  const ViewAll({super.key, required this.title, required this.events});

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
          title,
          style: const TextStyle(fontSize: 18),
        ),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
        itemCount: events.length,
        itemBuilder: (BuildContext context, int index) {
          final event = events[index];
          return Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (BuildContext context) => EventPage(
                                eventId: event["id"],
                              )));
                },
                child: EventCard(
                  image: event["image"],
                  title: event["title"],
                  location: event["location"],
                  date: event["date"],
                  category: event["category"],
                  price: event["price"].toString(),
                ),
              ));
        },
      ),
    );
  }
}
