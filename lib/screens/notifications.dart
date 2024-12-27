import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';

// Model for notifications
class TicketNotification {
  final String id;
  final String eventID;
  final String title;
  final String message;
  final DateTime timestamp;
  final NotificationType type;
  final bool isRead;

  TicketNotification({
    required this.id,
    required this.eventID,
    required this.title,
    required this.message,
    required this.timestamp,
    required this.type,
    this.isRead = false,
  });
}

enum NotificationType { ticketPurchase, eventReminder, eventUpdate, general }

// Sample data
final List<TicketNotification> sampleNotifications = [
  TicketNotification(
    id: '1',
    eventID: '2',
    title: 'Ticket Purchase Confirmed',
    message:
        'Your tickets for "Taylor Swift Concert" have been confirmed. Check your email for details.',
    timestamp: DateTime.now().subtract(const Duration(minutes: 5)),
    type: NotificationType.ticketPurchase,
  ),
  TicketNotification(
    id: '2',
    eventID: '24',
    title: 'Event Reminder',
    message:
        'The "Ed Sheeran Concert" starts in 24 hours. Don\'t forget your tickets!',
    timestamp: DateTime.now().subtract(const Duration(hours: 2)),
    type: NotificationType.eventReminder,
  ),
  TicketNotification(
    id: '4',
    eventID: '200',
    title: 'Venue Change',
    message:
        'There as been an update to the details of "Taylor Swift Concert" by the Organisers. Check details.',
    timestamp: DateTime.now().subtract(const Duration(days: 2)),
    type: NotificationType.eventUpdate,
    isRead: true,
  ),
];

class Notifications extends StatelessWidget {
  const Notifications({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 243, 243, 243),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text(
          'Notifications',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
        ),
        actions: [
          Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const CloseButton(
                color: Colors.red,
              )),
          const SizedBox(
            width: 12,
          )
        ],
      ),
      body: sampleNotifications.isNotEmpty
          ? ListView.builder(
              itemCount: sampleNotifications.length,
              itemBuilder: (context, index) {
                final notification = sampleNotifications[index];
                return NotificationTile(notification: notification);
              },
            )
          : SafeArea(
              child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgPicture.asset(
                    'assets/svg/notificationBold.svg',
                    width: 160,
                    color: const Color(0xff869FAC),
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  const Text('No Notifications available'),
                ],
              ),
            )),
    );
  }
}

class NotificationTile extends StatelessWidget {
  final TicketNotification notification;

  const NotificationTile({
    super.key,
    required this.notification,
  });

  IconData _getNotificationIcon() {
    switch (notification.type) {
      case NotificationType.ticketPurchase:
        return Icons.confirmation_number;
      case NotificationType.eventReminder:
        return Icons.access_time;
      case NotificationType.eventUpdate:
        return Icons.notification_important;
      case NotificationType.general:
        return Icons.notifications;
    }
  }

  Color _getNotificationColor() {
    switch (notification.type) {
      case NotificationType.ticketPurchase:
        return Colors.green;
      case NotificationType.eventReminder:
        return Colors.orange;
      case NotificationType.eventUpdate:
        return Colors.red;

      case NotificationType.general:
        return Colors.blue;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        tileColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: _getNotificationColor().withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(
            size: 32,
            _getNotificationIcon(),
            color: _getNotificationColor(),
          ),
        ),
        title: Text(
          notification.title,
          style: TextStyle(
            fontWeight:
                notification.isRead ? FontWeight.normal : FontWeight.w500,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              notification.message,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 12),
            ),
            const SizedBox(height: 4),
            Text(
              DateFormat.yMMMd().add_jm().format(notification.timestamp),
              style: TextStyle(
                fontSize: 11,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
        trailing: !notification.isRead
            ? Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: _getNotificationColor(),
                  shape: BoxShape.circle,
                ),
              )
            : null,
        onTap: () {
          // Handle notification tap
        },
      ),
    );
  }
}
