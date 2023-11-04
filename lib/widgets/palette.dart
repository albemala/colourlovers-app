import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

class PaletteTileView extends StatelessWidget {
  final List<String>? colors; // TODO can we make this non-nullable?
  final List<double> widths;

  const PaletteTileView({
    super.key,
    required this.colors,
    this.widths = const [],
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Row(
          children: colors?.map((color) {
                return SizedBox(
                  width: constraints.minWidth * _width(color),
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
