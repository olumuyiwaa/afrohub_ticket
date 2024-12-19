import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

class ImageContainer extends StatelessWidget {
  final String mediaUrl;
  final double? width;
  final double? height; // Add width as an optional parameter

  const ImageContainer({
    super.key,
    required this.mediaUrl,
    this.width,
    this.height, // Initialize width
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        // Navigate to full-screen image page on tap
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => FullScreenImagePage(mediaUrl: mediaUrl),
          ),
        );
      },
      child: Container(
        height: height ?? 300,
        width: width ?? double.infinity, // Use the passed width or full width
        decoration: BoxDecoration(
          color: Colors.grey,
          borderRadius: BorderRadius.circular(4),
          image: DecorationImage(
            image: NetworkImage(mediaUrl),
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}

class FullScreenImagePage extends StatelessWidget {
  final String mediaUrl;

  const FullScreenImagePage({super.key, required this.mediaUrl});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          PhotoView(
            imageProvider: NetworkImage(mediaUrl),
            backgroundDecoration: const BoxDecoration(color: Colors.black),
            minScale: PhotoViewComputedScale.contained,
            maxScale: PhotoViewComputedScale.covered * 2.0,
            initialScale: PhotoViewComputedScale.contained,
            gestureDetectorBehavior: HitTestBehavior.opaque,
            loadingBuilder: (context, event) => Center(
              child: CircularProgressIndicator(
                value: event == null
                    ? null
                    : event.cumulativeBytesLoaded / event.expectedTotalBytes!,
              ),
            ),
          ),
          Positioned(
            top: 40,
            right: 10,
            child: IconButton(
              icon: const Icon(Icons.close_fullscreen_rounded,
                  color: Colors.white, size: 28),
              onPressed: () => Navigator.pop(context), // Close button
            ),
          ),
        ],
      ),
    );
  }
}
