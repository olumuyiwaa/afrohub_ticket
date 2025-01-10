import 'class_events.dart';

class Ticket {
  final String id;
  final String transactionId;
  final String userId;
  final Event ticketDetails;
  final String paypalOrderId;
  final int amount;
  final int ticketCount;
  final String status;
  final DateTime createdAt;

  Ticket({
    required this.id,
    required this.transactionId,
    required this.userId,
    required this.ticketDetails,
    required this.paypalOrderId,
    required this.amount,
    required this.ticketCount,
    required this.status,
    required this.createdAt,
  });

  factory Ticket.fromJson(Map<String, dynamic> json) {
    return Ticket(
      id: json['_id'],
      transactionId: json['transactionId'],
      userId: json['userId'],
      ticketDetails: Event.fromJson(json['ticketId']),
      paypalOrderId: json['paypalOrderId'],
      amount: json['amount'],
      ticketCount: json['ticketCount'],
      status: json['status'],
      createdAt: DateTime.parse(json['createdAt']),
    );
  }
}
