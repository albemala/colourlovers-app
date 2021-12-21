import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

class ColorView extends StatelessWidget {
  final String hex;

  const ColorView({
    Key? key,
    required this.hex,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: HexColor(hex),
    );
  }
}
