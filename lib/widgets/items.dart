import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:lucide_icons/lucide_icons.dart';

class ColorView extends StatelessWidget {
  final String hex;

  const ColorView({
    super.key,
    required this.hex,
  });

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: HexColor(hex),
    );
  }
}

class PaletteView extends StatelessWidget {
  final List<String> hexs;
  final List<double> widths;

  const PaletteView({
    super.key,
    required this.hexs,
    this.widths = const [],
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

class PatternView extends StatelessWidget {
  final String imageUrl;

  const PatternView({
    super.key,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Image.network(
      imageUrl,
      repeat: ImageRepeat.repeat,
    );
  }
}

class UserView extends StatelessWidget {
  const UserView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color:
          Theme.of(context).colorScheme.primaryContainer, // TODO review colors
      child: Align(
        alignment: Alignment.centerRight, // TODO left?
        child: Padding(
          padding: const EdgeInsets.only(right: 8), // TODO review padding
          child: Icon(
            LucideIcons.userCircle2,
            size: 56,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
      ),
    );
  }
}
