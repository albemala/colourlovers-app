import 'package:flutter/material.dart';

class PatternWidget extends StatelessWidget {
  final String? imageUrl;

  const PatternWidget({
    Key? key,
    required this.imageUrl,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (imageUrl == null) return Container();
    return Image.network(
      imageUrl!,
      repeat: ImageRepeat.repeat,
    );
  }
}
