import 'package:flutter/material.dart';

class PatternView extends StatelessWidget {
  final String imageUrl;

  const PatternView({
    super.key,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Image.network(
      imageUrl,
      repeat: ImageRepeat.repeat,
    );
  }
}
