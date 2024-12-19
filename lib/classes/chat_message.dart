class ChatMessage {
  final String? id;
  final String senderId;
  final String? receiverId;
  final String? messageType;
  final String data;
  final bool? read;
  final bool? delivered;
  final String? mediaUrl;
  final String? mediatype;
  final String timestamp;

  ChatMessage({
    this.id,
    required this.senderId,
    this.receiverId,
    this.messageType,
    required this.data,
    this.read,
    this.delivered,
    required this.mediaUrl,
    required this.mediatype,
    required this.timestamp,
  });

  // Add this method
  Map<String, dynamic> toJson() {
    return {
      "_id": id,
      "senderId": senderId,
      "receiverId": receiverId,
      "messageType": messageType,
      "data": data,
      "read": read,
      "delivered": delivered,
      "mediaUrl": mediaUrl,
      "mediatype": mediatype,
      "timestamp": timestamp,
    };
  }

  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    return ChatMessage(
      id: json["_id"],
      senderId: json["senderId"],
      receiverId: json["receiverId"],
      messageType: json["messageType"],
      data: json["data"],
      read: json["read"],
      delivered: json["delivered"],
      mediaUrl: json["media"]["name"].isNotEmpty ? json["mediaUrl"] : null,
      mediatype: json["media"]["mimeType"].isNotEmpty
          ? json["media"]["mimeType"]
          : null,
      timestamp: _formatTimeAgo(DateTime.parse(json["timestamp"])),
    );
  }
  // Helper method to format the time difference into "time ago" format
  static String _formatTimeAgo(DateTime createdAt) {
    final Duration difference = DateTime.now().difference(createdAt);

    final int days = difference.inDays;
    final int hours = difference.inHours;
    final int minutes = difference.inMinutes;

    if (days >= 365) {
      final int years = (days / 365).floor();
      return '$years yr${years > 1 ? 's ago' : ' ago'}';
    } else if (days >= 30) {
      final int months = (days / 30).floor();
      return '$months mth${months > 1 ? 's ago' : ' ago'}';
    } else if (days > 0) {
      return '$days day${days > 1 ? 's ago' : ' ago'}';
    } else if (hours > 0) {
      return '$hours hr${hours > 1 ? 's ago' : ' ago'}';
    } else if (minutes > 0) {
      return '$minutes min${minutes > 1 ? 's ago' : ' ago'}';
    } else {
      return 'Just now';
    }
  }
}
