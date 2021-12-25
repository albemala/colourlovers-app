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
    if (hex == null) return Container();
    return Container(
      color: HexColor(hex!),
    );
  }
}
