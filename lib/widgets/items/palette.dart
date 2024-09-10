import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

class PaletteView extends StatelessWidget {
  final List<String> hexs;
  final List<double> widths;

  const PaletteView({
    super.key,
    required this.hexs,
    required this.widths,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Row(
          children: hexs.map((color) {
            return SizedBox(
              width: constraints.minWidth * _width(color),
              child: Container(
                color: HexColor(color),
              ),
            );
          }).toList(),
        );
      },
    );
  }

  double _width(String color) {
    final index = hexs.indexOf(color);
    return index < widths.length ? widths[index] : 1 / hexs.length;
  }
}
