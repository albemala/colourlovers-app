import 'package:flutter/material.dart';

class UrlImageView extends StatelessWidget {
  final String imageUrl;

  const UrlImageView({super.key, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    if (imageUrl.startsWith('http://') || imageUrl.startsWith('https://')) {
      return Image.network(imageUrl, repeat: ImageRepeat.repeat);
    } else if (imageUrl.startsWith('asset://')) {
      return Image.asset(
        imageUrl.replaceFirst('asset://', ''),
        repeat: ImageRepeat.repeat,
      );
    } else {
      // Fallback or error handling for unsupported image URLs
      return const Placeholder();
    }
  }
}
