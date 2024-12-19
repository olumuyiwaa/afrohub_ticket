import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../utilities/const.dart';
import '../../../utilities/input/message_input.dart';
import '../../../utilities/widget/image_container.dart';

class EventChat extends StatefulWidget {
  final int eventID;
  final String eventName;
  final String? eventPicture;
  final VoidCallback? onExit;
  const EventChat(
      {super.key,
      required this.eventID,
      required this.eventName,
      this.eventPicture,
      this.onExit});

  @override
  State<EventChat> createState() => _EventChatState();
}

class _EventChatState extends State<EventChat> {
  final ScrollController _scrollController = ScrollController();
  int sessionUserID = 1; // to be handled

  Future<void> _loadMessages() async {
    final fetchedMessages = [];
    setState(() {
      _messages = fetchedMessages.reversed.toList();
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToBottom();
    });
  }

  @override
  void initState() {
    super.initState();
    // _initializeSocket();
    // _loadSessionUserID();
    // _loadMessages();
  }

  List<dynamic> _messages = [];
  //
  // Future<void> _initializeSocket() async {
  //   await _socketService.init();
  //   _socketService.connect();
  //
  //   _socketService.socket.on('familyMessage', _handleEventMessage);
  // }

  void _handleCommunityMessage(data) {
    setState(() {
      _loadMessages();
    });
    _scrollToBottom();
  }

  // Future<void> _loadSessionUserID() async {
  //   final prefs = await SharedPreferences.getInstance();
  //   setState(() {
  //     sessionUserID = prefs.getInt('id');
  //   });
  // }

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
    return WillPopScope(
        onWillPop: () async {
          if (widget.onExit != null) {
            widget.onExit!();
          }
          return true;
        },
        child: Scaffold(
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
                  widget.eventPicture != null
                      ? Container(
                          clipBehavior: Clip.hardEdge,
                          height: 36,
                          width: 36,
                          decoration: BoxDecoration(
                            color: Colors.black,
                            borderRadius: BorderRadius.circular(120),
                          ),
                          child: CachedNetworkImage(
                            imageUrl: widget.eventPicture!,
                            placeholder: (context, url) =>
                                CircularProgressIndicator(
                              color: accentColor,
                            ),
                            errorWidget: (context, url, error) =>
                                SvgPicture.asset('assets/svg/communities.svg'),
                            fit: BoxFit.cover, // Adjust image fitting
                          ))
                      : CircleAvatar(
                          backgroundColor: Colors.transparent,
                          child: SvgPicture.asset('assets/svg/communities.svg'),
                        ),
                  const SizedBox(
                    width: 12,
                  ),
                  Expanded(
                      child: Text(
                    widget.eventName,
                  )),
                ],
              ),
            ),
            body: SafeArea(
              child: sessionUserID == null
                  ? Center(
                      child: CircularProgressIndicator(
                      color: accentColor,
                    ))
                  : Column(
                      children: [
                        Expanded(
                          child: _messages.isEmpty
                              ? Center(
                                  child: Image.asset(
                                    'assets/img/noMessage.png',
                                  ),
                                )
                              : ListView.builder(
                                  controller:
                                      _scrollController, // Attach controller
                                  itemCount: _messages.length,
                                  itemBuilder: (context, index) {
                                    final message = _messages[index];
                                    final isSender =
                                        int.tryParse(message.senderId) ==
                                            sessionUserID;

                                    return Padding(
                                      padding: const EdgeInsets.all(8),
                                      child: Column(
                                        crossAxisAlignment: isSender
                                            ? CrossAxisAlignment.end
                                            : CrossAxisAlignment.start,
                                        children: [
                                          isSender
                                              ? Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.end,
                                                  children: [
                                                    const Text('You'),
                                                    const SizedBox(
                                                      width: 8,
                                                    ),
                                                    Container(
                                                        clipBehavior:
                                                            Clip.hardEdge,
                                                        height: 24,
                                                        width: 24,
                                                        decoration:
                                                            BoxDecoration(
                                                          color: Colors.black,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(24),
                                                        ),
                                                        child:
                                                            CachedNetworkImage(
                                                          imageUrl: message
                                                              .senderImage,
                                                          placeholder: (context,
                                                                  url) =>
                                                              CircularProgressIndicator(
                                                            color: accentColor,
                                                          ),
                                                          errorWidget: (context,
                                                                  url, error) =>
                                                              SvgPicture.asset(
                                                                  'assets/svg/usericon.svg'),
                                                          fit: BoxFit
                                                              .cover, // Adjust image fitting
                                                        )),
                                                  ],
                                                )
                                              : Row(
                                                  children: [
                                                    Container(
                                                        clipBehavior:
                                                            Clip.hardEdge,
                                                        height: 24,
                                                        width: 24,
                                                        decoration:
                                                            BoxDecoration(
                                                          color: Colors.black,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(24),
                                                        ),
                                                        child:
                                                            CachedNetworkImage(
                                                          imageUrl: message
                                                              .senderImage,
                                                          placeholder: (context,
                                                                  url) =>
                                                              CircularProgressIndicator(
                                                            color: accentColor,
                                                          ),
                                                          errorWidget: (context,
                                                                  url, error) =>
                                                              SvgPicture.asset(
                                                                  'assets/svg/usericon.svg'),
                                                          fit: BoxFit
                                                              .cover, // Adjust image fitting
                                                        )),
                                                    const SizedBox(
                                                      width: 8,
                                                    ),
                                                    Text(message.senderName)
                                                  ],
                                                ),
                                          const SizedBox(
                                            height: 4,
                                          ),
                                          Container(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 16, vertical: 12),
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(18),
                                              color: isSender
                                                  ? const Color(0XFFEAFBED)
                                                  : Colors.white,
                                            ),
                                            child: message.mediaUrl != null &&
                                                    message.mediaType != null
                                                ? Column(
                                                    crossAxisAlignment: isSender
                                                        ? CrossAxisAlignment.end
                                                        : CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      ImageContainer(
                                                        mediaUrl:
                                                            message.mediaUrl!,
                                                        height: 320,
                                                        width: 240,
                                                      ),
                                                      const SizedBox(height: 8),
                                                      Text(
                                                        message.data,
                                                        style: const TextStyle(
                                                          fontWeight:
                                                              FontWeight.w500,
                                                        ),
                                                      ),
                                                    ],
                                                  )
                                                : Text(
                                                    message.data,
                                                    style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    ),
                                                  ),
                                          ),
                                          const SizedBox(height: 8),
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 12),
                                            child: Text(
                                              message.timestamp,
                                              style: const TextStyle(
                                                  fontSize: 10,
                                                  color: Colors.grey),
                                            ),
                                          )
                                        ],
                                      ),
                                    );
                                  },
                                ),
                        ),
                        MessageInput(
                          destinationID: widget.eventID,
                          onMessageSent: (newMessage) {
                            _loadMessages;
                          },
                          sessionUserID: sessionUserID!,
                        ),
                        const SizedBox(
                          height: 4,
                        )
                      ],
                    ),
            )));
  }
}
