import 'package:afrohub/utilities/const.dart';
import 'package:flutter/material.dart';

import '../../model/class_events.dart';
import '../../utilities/widget/event_card_2.dart';
import 'event/event_page.dart';

class Filter extends StatefulWidget {
  final List<Event> events;

  const Filter({super.key, required this.events});

  @override
  State<Filter> createState() => _FilterState();
}

class _FilterState extends State<Filter> {
  // Filtered list
  List<Event> filteredEvents = [];
  List<String> selectedCategories = ['All'];

  @override
  void initState() {
    super.initState();
    filteredEvents = widget.events; // Initially display all events
  }

  // Function to filter events
  void filterEvents() {
    setState(() {
      if (selectedCategories.contains('All') || selectedCategories.isEmpty) {
        filteredEvents = widget.events;
      } else {
        filteredEvents = widget.events
            .where((event) => selectedCategories.contains(event.category))
            .toList();
      }
    });
  }

  void openFilterOptions() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        final List<String> africanCountries = [
          "All",
          "All Africa",
          "Western Africa",
          "Eastern Africa",
          "Northern Africa",
          "Southern Africa",
          "Algeria",
          "Angola",
          "Benin",
          "Botswana",
          "Burkina Faso",
          "Burundi",
          "Cabo Verde",
          "Cameroon",
          "Central African Republic",
          "Chad",
          "Comoros",
          "Congo",
          "Congo (DRC)",
          "Djibouti",
          "Egypt",
          "Equatorial Guinea",
          "Eritrea",
          "Eswatini",
          "Ethiopia",
          "Gabon",
          "Gambia",
          "Ghana",
          "Guinea",
          "Guinea-Bissau",
          "Ivory Coast",
          "Kenya",
          "Lesotho",
          "Liberia",
          "Libya",
          "Madagascar",
          "Malawi",
          "Mali",
          "Mauritania",
          "Mauritius",
          "Morocco",
          "Mozambique",
          "Namibia",
          "Niger",
          "Nigeria",
          "Rwanda",
          "Sao Tome and Principe",
          "Senegal",
          "Seychelles",
          "Sierra Leone",
          "Somalia",
          "South Africa",
          "South Sudan",
          "Sudan",
          "Tanzania",
          "Togo",
          "Tunisia",
          "Uganda",
          "Zambia",
          "Zimbabwe"
        ];

        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setModalState) {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Filter by Category',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  Expanded(
                    child: Scrollbar(
                      thumbVisibility: true, // Ensures the scrollbar is visible
                      child: ListView.builder(
                        itemCount: (africanCountries.length / 2)
                            .ceil(), // Number of rows
                        itemBuilder: (context, rowIndex) {
                          // Get countries for the current row
                          final rowItems = africanCountries
                              .skip(rowIndex * 2)
                              .take(2)
                              .toList();

                          return Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: rowItems.map((country) {
                              return Expanded(
                                child: CheckboxListTile(
                                  title: Text(
                                    country,
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(fontSize: 12),
                                  ),
                                  activeColor: accentColor,
                                  value: selectedCategories.contains(country),
                                  onChanged: (bool? value) {
                                    setModalState(() {
                                      if (value == true) {
                                        if (country == 'All') {
                                          selectedCategories = ['All'];
                                        } else {
                                          selectedCategories.remove('All');
                                          selectedCategories.add(country);
                                        }
                                      } else {
                                        selectedCategories.remove(country);
                                        if (selectedCategories.isEmpty) {
                                          selectedCategories.add('All');
                                        }
                                      }
                                    });
                                  },
                                ),
                              );
                            }).toList(),
                          );
                        },
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    child: InkWell(
                      onTap: () {
                        Navigator.pop(context);
                        filterEvents();
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: Colors.white),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 18, vertical: 12),
                        child: const Text('Apply Filters'),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Event Filter',
          style: TextStyle(fontSize: 18),
        ),
        actions: [
          InkWell(
            onTap: openFilterOptions,
            borderRadius: BorderRadius.circular(32),
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(32),
              ),
              child: const Icon(Icons.filter_list),
            ),
          ),
          const SizedBox(
            width: 12,
          )
        ],
      ),
      body: filteredEvents.isEmpty
          ? const Center(
              child: Text("No Events in this Category"),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: filteredEvents.length,
              itemBuilder: (context, index) {
                final event = filteredEvents[index];

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
                      child: EventCard2(
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
