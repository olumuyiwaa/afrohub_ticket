import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lottie/lottie.dart';

import '../../api/api_get.dart';
import '../../model/class_events.dart';
import '../../utilities/buttons/notification_button.dart';
import '../../utilities/const.dart';
import '../../utilities/widget/event_card_2.dart';
import 'main_screens/event/event_page.dart';

class InterestPage extends StatefulWidget {
  final String title;
  const InterestPage({super.key, required this.title});

  @override
  State<InterestPage> createState() => _InterestPageState();
}

class _InterestPageState extends State<InterestPage> {
  List<Event> events = [];
  List<Event> allEvents = [];
  bool _isLoading = true;

  Future<void> _loadEvents() async {
    setState(() {
      _isLoading = true;
    });
    try {
      final fetchedEvents = await getFeaturedEvents();
      setState(() {
        allEvents = fetchedEvents.toList();
        _fetchEventsCategory();
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to load events')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
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
      body: _isLoading
          ? Center(
              child: Lottie.asset(
              'assets/lottie/loading.json',
              fit: BoxFit.cover,
            ))
          : events.isEmpty
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
                        'No ${widget.title} Event(s) Found',
                        style: TextStyle(color: greyColor, fontSize: 20),
                      ),
                    ],
                  ),
                )
              : GridView.builder(
                  padding: const EdgeInsets.all(16),
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: events.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2, // Number of columns
                    crossAxisSpacing: 8.0, // Spacing between columns
                    mainAxisSpacing: 8.0, // Spacing between rows
                    childAspectRatio:
                        0.74, // Adjust based on desired card height
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
