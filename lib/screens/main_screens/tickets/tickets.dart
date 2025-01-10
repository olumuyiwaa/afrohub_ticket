import 'package:afrohub/model/class_tickets.dart';
import 'package:afrohub/screens/main_screens/tickets/ticket_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lottie/lottie.dart';

import '../../../api/api_get.dart';
import '../../../utilities/widget/event_card.dart';

class Tickets extends StatefulWidget {
  const Tickets({super.key});

  @override
  State<Tickets> createState() => _TicketsState();
}

class _TicketsState extends State<Tickets> {
  List<Ticket> tickets = [];

  bool _isLoading = true;

  Future<void> loadTickets() async {
    setState(() {
      _isLoading = true;
    });
    try {
      final fetchedTickets = await fetchTickets();
      setState(() {
        tickets = fetchedTickets.toList();
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
    loadTickets();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            'My Tickets',
            style: TextStyle(fontSize: 18),
          ),
        ),
        body: _isLoading
            ? Center(
                child: Lottie.asset(
                'assets/lottie/loading.json',
                fit: BoxFit.cover,
              ))
            : tickets.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SvgPicture.asset(
                          'assets/svg/ticket.svg',
                          width: 160,
                          color: const Color(0xff869FAC),
                        ),
                        const SizedBox(
                          height: 24,
                        ),
                        const Text('No Ticket Purchased Yet'),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
                    itemCount: tickets.length,
                    itemBuilder: (BuildContext context, int index) {
                      final ticket = tickets[index];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: InkWell(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (BuildContext context) =>
                                          TicketPage(
                                            ticketDetails: ticket.ticketDetails,
                                            unit: ticket.ticketCount.toString(),
                                          )));
                            },
                            child: EventCard(
                              image: ticket.ticketDetails.image!,
                              title: ticket.ticketDetails.title,
                              location: ticket.ticketDetails.location,
                              date: ticket.ticketDetails.date,
                              status: ticket.status,
                              unit: ticket.ticketCount.toString(),
                              price: ticket.ticketDetails.price.toString(),
                            )),
                      );
                    },
                  ));
  }
}
