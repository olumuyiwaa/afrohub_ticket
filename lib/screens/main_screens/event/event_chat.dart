import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../utilities/const.dart';

class EventChat extends StatefulWidget {
  final int eventID;
  final String eventName;
  final String? eventPicture;
  const EventChat({
    super.key,
    required this.eventID,
    required this.eventName,
    this.eventPicture,
  });

  @override
  State<EventChat> createState() => _EventChatState();
}

class _EventChatState extends State<EventChat> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController messageContent = TextEditingController();
  // Mock data for chat messages
  final List<Map<String, dynamic>> messages = [
    {'userId': '3', 'userName': 'Charlie', 'text': 'Hi everyone!'},
    {'userId': '1', 'userName': 'Alice', 'text': 'Hey, how are you?'},
    {'userId': '2', 'userName': 'Bob', 'text': 'I am good, you?'},
    {'userId': '1', 'userName': 'Alice', 'text': 'Doing well!'},
  ];
  //.reversed.toList();
  // Mock logged-in user ID
  final String loggedInUserId = '1';

  @override
  void initState() {
    super.initState();
    _scrollToBottom();
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          actions: [
            IconButton(onPressed: () {}, icon: const Icon(Icons.more_vert)),
            const SizedBox(
              width: 4,
            )
          ],
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                  clipBehavior: Clip.hardEdge,
                  height: 36,
                  width: 36,
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(120),
                  ),
                  child: CachedNetworkImage(
                    imageUrl: widget.eventPicture!,
                    placeholder: (context, url) => CircularProgressIndicator(
                      color: accentColor,
                    ),
                    errorWidget: (context, url, error) =>
                        SvgPicture.asset('assets/svg/communities.svg'),
                    fit: BoxFit.cover, // Adjust image fitting
                  )),
              const SizedBox(
                width: 12,
              ),
              Expanded(
                  child: Text(widget.eventName,
                      style: const TextStyle(fontSize: 18))),
            ],
          ),
        ),
        body: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: ListView.builder(
                  reverse: true,
                  padding: const EdgeInsets.all(8.0),
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final message = messages[messages.length - 1 - index];
                    final isMe = message['userId'] == loggedInUserId;
                    return Align(
                      alignment:
                          isMe ? Alignment.centerRight : Alignment.centerLeft,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4.0),
                        child: Row(
                          mainAxisAlignment: isMe
                              ? MainAxisAlignment.end
                              : MainAxisAlignment.start,
                          children: [
                            if (!isMe) ...[
                              CircleAvatar(
                                radius: 20,
                                backgroundColor: Colors.grey,
                                child: Text(
                                  message['userName'][0],
                                  style: const TextStyle(color: Colors.white),
                                ),
                              ),
                              const SizedBox(width: 8),
                            ],
                            Flexible(
                              child: Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: isMe ? accentColor : Colors.grey[300],
                                  borderRadius: BorderRadius.only(
                                    topLeft: const Radius.circular(12),
                                    topRight: const Radius.circular(12),
                                    bottomLeft: isMe
                                        ? const Radius.circular(12)
                                        : Radius.zero,
                                    bottomRight: isMe
                                        ? Radius.zero
                                        : const Radius.circular(12),
                                  ),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    if (!isMe)
                                      Text(
                                        message['userName'],
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black54,
                                        ),
                                      ),
                                    Text(
                                      message['text'],
                                      style: TextStyle(
                                        color: isMe
                                            ? Colors.white
                                            : Colors.black87,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            if (isMe) const SizedBox(width: 8),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(width: 2, color: accentColor)),
                          child: TextField(
                            controller: messageContent,
                            maxLines: null,
                            cursorColor: accentColor,
                            decoration: InputDecoration(
                              hintStyle: TextStyle(color: greyColor),
                              hintText: 'Type your message...',
                              border: InputBorder.none,
                            ),
                          )),
                    ),
                    const SizedBox(width: 8),
                    IconButton(
                      icon: Icon(
                        Icons.send,
                        color: accentColor,
                        size: 32,
                      ),
                      onPressed: () {
                        // Add message send functionality
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ));
  }
}
