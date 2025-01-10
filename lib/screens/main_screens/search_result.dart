import 'package:afrohub/utilities/const.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../api/api_get.dart';
import '../../model/class_events.dart';
import '../../utilities/search.dart';
import '../../utilities/widget/event_card_2.dart';
import 'event/event_page.dart';

class SearchResult extends StatefulWidget {
  final String text;

  const SearchResult({super.key, required this.text});

  @override
  State<SearchResult> createState() => _SearchResultState();
}

class _SearchResultState extends State<SearchResult> {
  // Searched and all events lists
  List<Event> searchedEvents = [];
  List<Event> allEvents = [];
  final initalQuery = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadEvents();
  }

  /// Loads events and performs the search
  Future<void> _loadEvents() async {
    try {
      final fetchedEvents = await getFeaturedEvents();
      setState(() {
        allEvents = fetchedEvents.toList();
        _searchEvents();
      });
    } catch (e) {
      // Handle error if fetching events fails
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to load events')),
      );
    }
  }

  /// Filters events based on the search text
  void _searchEvents() {
    setState(() {
      searchedEvents = allEvents
          .where((event) =>
              event.title.toLowerCase().contains(widget.text.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    initalQuery.text = widget.text;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
                child: Search(
              searchController: initalQuery,
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
            const SizedBox(width: 12),
            Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: CloseButton(
                  onPressed: () {
                    Navigator.of(context).popUntil((route) => route.isFirst);
                  },
                  color: Colors.red,
                ))
          ],
        ),
      ),
      body: searchedEvents.isEmpty
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
                    'No Event Found',
                    style: TextStyle(color: greyColor, fontSize: 20),
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: searchedEvents.length,
              itemBuilder: (context, index) {
                final event = searchedEvents[index];

                return Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (BuildContext context) => EventPage(
                            eventId: event.id,
                          ),
                        ),
                      );
                    },
                    child: EventCard2(
                      title: event.title,
                      image: event.image ?? "",
                      location: event.location,
                      date: event.date,
                      price: event.price,
                      category: event.category,
                    ),
                  ),
                );
              },
            ),
    );
  }
}
