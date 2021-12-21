import 'package:flutter/material.dart';

class PatternView extends StatelessWidget {
  final String imageUrl;

  const PatternView({
    Key? key,
    required this.imageUrl,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Image.network(
      imageUrl,
      repeat: ImageRepeat.repeat,
    );
  }
}
