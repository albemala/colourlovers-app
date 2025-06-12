import 'package:colourlovers_app/widgets/url_image.dart';
import 'package:flutter/material.dart';

class PatternView extends StatelessWidget {
  final String imageUrl;

  const PatternView({super.key, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return UrlImageView(imageUrl: imageUrl);
  }
}
