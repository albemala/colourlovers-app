import 'package:colourlovers_app/widgets/item-tiles/item-tile.dart';
import 'package:colourlovers_app/widgets/item-tiles/pattern-tile/view-state.dart';
import 'package:colourlovers_app/widgets/items/pattern.dart';
import 'package:flutter/material.dart';

class PatternTileView extends StatelessWidget {
  final void Function() onTap;
  final PatternTileViewState state;

  const PatternTileView({
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
      child: PatternView(imageUrl: state.imageUrl),
    );
  }
}
