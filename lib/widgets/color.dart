import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

class ColorWidget extends StatelessWidget {
  final String? hex;

  const ColorWidget({
    Key? key,
    required this.hex,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: HexColor(hex ?? '000000'),
    );
  }
}
