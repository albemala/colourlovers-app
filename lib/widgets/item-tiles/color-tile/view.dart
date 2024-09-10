import 'package:colourlovers_app/widgets/item-tiles/color-tile/view-state.dart';
import 'package:colourlovers_app/widgets/item-tiles/item-tile.dart';
import 'package:colourlovers_app/widgets/items/color.dart';
import 'package:flutter/material.dart';

class ColorTileView extends StatelessWidget {
  final void Function() onTap;
  final ColorTileViewState state;

  const ColorTileView({
    super.key,
    required this.onTap,
    required this.state,
  });

  @override
  Widget build(BuildContext context) {
    return ItemTileView(
      onTap: onTap,
      title: state.title,
      numViews: state.numViews,
      numVotes: state.numVotes,
      child: ColorView(hex: state.hex),
    );
  }
}
