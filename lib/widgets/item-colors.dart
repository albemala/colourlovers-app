import 'package:colourlovers_app/widgets/item-tiles/color-tile/view-state.dart';
import 'package:colourlovers_app/widgets/item-tiles/color-tile/view.dart';
import 'package:colourlovers_app/widgets/text.dart';
import 'package:flextras/flextras.dart';
import 'package:flutter/material.dart';

class ItemColorsView extends StatelessWidget {
  final List<ColorTileViewState> colorViewStates;
  final void Function(ColorTileViewState) onColorTap;

  const ItemColorsView({
    super.key,
    required this.colorViewStates,
    required this.onColorTap,
  });

  @override
  Widget build(BuildContext context) {
    return SeparatedColumn(
      separatorBuilder: () {
        return const SizedBox(height: 16);
      },
      children: [
        const H2TextView('Colors'),
        SeparatedColumn(
          separatorBuilder: () {
            return const SizedBox(height: 8);
          },
          children: colorViewStates.map((state) {
            return ColorTileView(
              state: state,
              onTap: () {
                onColorTap(state);
              },
            );
          }).toList(),
        ),
      ],
    );
  }
}
