import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../api/api_get.dart';
import '../../model/events.dart';
import '../../utilities/buttons/notification_button.dart';
import '../../utilities/widget/event_card.dart';
import 'event/event_page.dart';

class Bookmarks extends StatefulWidget {
  Bookmarks({super.key});

  @override
  State<Bookmarks> createState() => _BookmarksState();
}

class _BookmarksState extends State<Bookmarks> {
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
      appBar: AppBar(
        actions: const [
          NotificationButton(),
          SizedBox(
            width: 8,
          )
        ],
        title: const Text(
          'Bookmarks',
          style: TextStyle(fontSize: 18),
        ),
      ),
      body: _events.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgPicture.asset(
                    'assets/svg/hearth.svg',
                    width: 160,
                    color: const Color(0xff869FAC),
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  const Text('No Bookmarked Event Available'),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
              itemCount: _events.length,
              itemBuilder: (BuildContext context, int index) {
                final event = _events[index];
                return Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (BuildContext context) => EventPage(
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
                      ),
                    ));
              },
            ),
    );
  }
}
