import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

class PaletteWidget extends StatelessWidget {
  final List<String>? colors;
  final List<double> widths;

  const PaletteWidget({
    Key? key,
    required this.colors,
    this.widths = const [],
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Row(
          children: colors?.map((color) {
                final width = _width(color);
                return SizedBox(
                  width: constraints.minWidth * width,
                  child: Container(
                    color: HexColor(color),
                  ),
                );
              }).toList() ??
              [],
        );
      },
    );
  }

  double _width(String color) {
    if (colors == null) return 0;
    final index = colors!.indexOf(color);
    return index < widths.length ? widths[index] : 1 / colors!.length;
  }
}
