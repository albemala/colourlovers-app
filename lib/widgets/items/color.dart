import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

class ColorView extends StatelessWidget {
  final String hex;

  const ColorView({super.key, required this.hex});

  @override
  Widget build(BuildContext context) {
    return ColoredBox(color: HexColor(hex));
  }
}
