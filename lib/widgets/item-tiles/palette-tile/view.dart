import 'package:colourlovers_app/widgets/item-tiles/item-tile.dart';
import 'package:colourlovers_app/widgets/item-tiles/palette-tile/view-state.dart';
import 'package:colourlovers_app/widgets/items/palette.dart';
import 'package:flutter/material.dart';

class PaletteTileView extends StatelessWidget {
  final void Function() onTap;
  final PaletteTileViewState state;

  const PaletteTileView({super.key, required this.onTap, required this.state});

  @override
  Widget build(BuildContext context) {
    return ItemTileView(
      onTap: onTap,
      title: state.title,
      numViews: state.numViews,
      numVotes: state.numVotes,
      child: PaletteView(
        hexs: state.hexs.toList(),
        widths: state.widths.toList(),
      ),
    );
  }
}
