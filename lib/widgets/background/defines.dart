import 'dart:ui';

const topPalette1 = ['69D2E7', 'A7DBD8', 'E0E4CC', 'F38630', 'FA6900'];
const topPalette2 = ['FE4365', 'FC9D9A', 'F9CDAD', 'C8C8A9', '83AF9B'];
const topPalette3 = ['ECD078', 'D95B43', 'C02942', '542437', '53777A'];
const topPalette4 = ['556270', '4ECDC4', 'C7F464', 'FF6B6B', 'C44D58'];
const topPalette5 = ['774F38', 'E08E79', 'F1D4AF', 'ECE5CE', 'C5E0DC'];
const topPalette6 = ['E8DDCB', 'CDB380', '036564', '033649', '031634'];
const topPalette7 = ['490A3D', 'BD1550', 'E97F02', 'F8CA00', '8A9B0F'];
const topPalette8 = ['594F4F', '547980', '45ADA8', '9DE0AD', 'E5FCC2'];
const topPalette9 = ['00A0B0', '6A4A3C', 'CC333F', 'EB6841', 'EDC951'];
const topPalette10 = ['E94E77', 'D68189', 'C6A49A', 'C6E5D9', 'F4EAD5'];

final topPalettes = [
  topPalette1,
  topPalette2,
  topPalette3,
  topPalette4,
  topPalette5,
  topPalette6,
  topPalette7,
  topPalette8,
  topPalette9,
  topPalette10,
];

class BackgroundBlob {
  final Offset positionRatio;
  final double sizeRatio;
  final List<Color> colors;
  final double blur;

  BackgroundBlob({
    required this.positionRatio,
    required this.sizeRatio,
    required this.colors,
    required this.blur,
  });
}
