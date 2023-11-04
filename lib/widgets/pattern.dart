import 'package:flutter/material.dart';

class PatternTileView extends StatelessWidget {
  final String? imageUrl; // TODO can we make this non-nullable?

  const PatternTileView({
    super.key,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return imageUrl == null
        ? Container()
        : Image.network(
            imageUrl!,
            repeat: ImageRepeat.repeat,
          );
  }
}
