import 'package:colourlovers_app/widgets/item-tiles/color-tile/view-state.dart';
import 'package:colourlovers_app/widgets/item-tiles/color-tile/view.dart';
import 'package:colourlovers_app/widgets/text.dart';
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: 16,
      children: [
        const H2TextView('Colors'),
        Column(
          spacing: 8,
          children:
              colorViewStates.map((state) {
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
