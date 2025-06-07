import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

class PaletteView extends StatelessWidget {
  final List<String> hexs;
  final List<double> widths;

  const PaletteView({super.key, required this.hexs, required this.widths});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return CustomPaint(
          painter: _PalettePainter(hexs: hexs, widths: widths),
          size: Size(constraints.maxWidth, constraints.maxHeight),
        );
      },
    );
  }
}

class _PalettePainter extends CustomPainter {
  final List<String> hexs;
  final List<double> widths;

  _PalettePainter({required this.hexs, required this.widths});

  @override
  void paint(Canvas canvas, Size size) {
    double currentX = 0;
    for (var i = 0; i < hexs.length; i++) {
      final color = HexColor(hexs[i]);
      final width = widths.length > i ? widths[i] : 1 / hexs.length;
      final rectWidth = size.width * width;

      final paint = Paint()..color = color;
      canvas.drawRect(
        Rect.fromLTWH(currentX, 0, rectWidth, size.height),
        paint,
      );
      currentX += rectWidth;
    }
  }

  @override
  bool shouldRepaint(covariant _PalettePainter oldDelegate) {
    return oldDelegate.hexs != hexs || oldDelegate.widths != widths;
  }
}
