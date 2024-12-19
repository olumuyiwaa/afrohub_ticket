import 'dart:io';

import 'package:afrohub/utilities/const.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mime/mime.dart';

import '../../classes/chat_message.dart';

class MessageInput extends StatefulWidget {
  final int destinationID;
  final int sessionUserID;
  final void Function(ChatMessage)? onMessageSent;

  const MessageInput({
    super.key,
    required this.destinationID,
    required this.sessionUserID,
    this.onMessageSent,
  });

  @override
  State<MessageInput> createState() => _MessageInputState();
}

class _MessageInputState extends State<MessageInput> {
  final messageContent = TextEditingController();
  File? _mediaFile;

  Future<void> _pickMedia() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.image,
    );

    if (result != null && result.files.isNotEmpty) {
      final file = File(result.files.first.path!);

      setState(() {
        _mediaFile = file;
      });
    }
  }

  @override
  void dispose() {
    messageContent.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Container(
        padding: const EdgeInsets.fromLTRB(12, 4, 4, 4),
        decoration: BoxDecoration(
          color: const Color(0xFFFAFAFA),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: const Color(0xFF869FAC),
            width: 2,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: messageContent,
              maxLines: null,
              cursorColor: accentColor,
              decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Enter your message...',
                  hintStyle: const TextStyle(color: Colors.grey),
                  suffixIcon: SizedBox(
                      width: 108,
                      child: Row(children: [
                        Container(
                            decoration: BoxDecoration(
                              color: const Color(0xFF869FAC),
                              borderRadius: BorderRadius.circular(32),
                            ),
                            child: IconButton(
                              icon: SvgPicture.asset(
                                'assets/svg/image_attach.svg',
                                width: 16.0,
                                height: 16.0,
                                color: Colors.white,
                              ),
                              onPressed: _pickMedia,
                            )),
                        const SizedBox(
                          width: 8,
                        ),
                        Container(
                          decoration: BoxDecoration(
                            color: accentColor,
                            borderRadius: BorderRadius.circular(32),
                          ),
                          child: IconButton(
                            onPressed: () {
                              String? message = messageContent.text.isEmpty
                                  ? ' '
                                  : messageContent.text;
                              File? media = _mediaFile;
                              if (message.isEmpty && media == null) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                        "Please enter a message or select a media file."),
                                    backgroundColor: Colors.red,
                                  ),
                                );
                                return;
                              } else if (media != null && message.isEmpty) {
                                final newMessage = ChatMessage(
                                  senderId: widget.sessionUserID.toString(),
                                  data: " ",
                                  timestamp: 'Just now',
                                  mediaUrl: media.path,
                                  mediatype: lookupMimeType(_mediaFile!.path),
                                );

                                // sendMessage(
                                //   context: context,
                                //   communityID: widget.destinationID,
                                //   message: null,
                                //   media: media,
                                //   fileType: mimetype,
                                // );

                                // Clear input and reset media
                                messageContent.clear();
                                setState(() {
                                  _mediaFile = null;
                                });

                                // Trigger the callback with newMessage
                                if (widget.onMessageSent != null) {
                                  widget.onMessageSent!(newMessage);
                                }
                                return;
                              } else if (message.isNotEmpty || media != null) {
                                final newMessage = ChatMessage(
                                  senderId: widget.sessionUserID.toString(),
                                  data: message,
                                  timestamp: 'Just now',
                                  mediaUrl: media?.path,
                                  mediatype: media != null
                                      ? lookupMimeType(_mediaFile!.path)
                                      : null,
                                );

                                // sendMessage(
                                //   context: context,
                                //   communityID: widget.destinationID,
                                //   message: message,
                                //   media: media,
                                //   fileType: mimetype,
                                // );

                                // Clear input and reset media
                                messageContent.clear();
                                setState(() {
                                  _mediaFile = null;
                                });

                                // Trigger the callback with newMessage
                                if (widget.onMessageSent != null) {
                                  widget.onMessageSent!(newMessage);
                                }
                              }
                            },
                            icon: SvgPicture.asset(
                              'assets/svg/sent.svg',
                              width: 16,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ]))),
            ),
            if (_mediaFile != null)
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Stack(
                  alignment: Alignment.topRight,
                  children: [
                    Image.file(
                      _mediaFile!,
                      height: 100,
                      width: 100,
                      fit: BoxFit.cover,
                    ),
                    IconButton(
                      icon: const Icon(Icons.cancel, color: Colors.red),
                      onPressed: () {
                        setState(() {
                          _mediaFile = null;
                        });
                      },
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
