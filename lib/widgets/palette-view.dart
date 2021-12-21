import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

class PaletteView extends StatelessWidget {
  final List<String> colors;
  final List<double> widths;

  const PaletteView({
    Key? key,
    required this.colors,
    required this.widths,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Row(
          children: colors.map((color) {
            final width = _width(color);
            return SizedBox(
              width: constraints.minWidth * width,
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
    final index = colors.indexOf(color);
    return index < widths.length ? widths[index] : 1 / colors.length;
  }
}
