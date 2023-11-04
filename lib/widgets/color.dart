import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

class ColorTileView extends StatelessWidget {
  final String? hex; // TODO can we make this non-nullable?

  const ColorTileView({
    super.key,
    required this.hex,
  });

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: HexColor(hex ?? '000000'),
    );
  }
}
